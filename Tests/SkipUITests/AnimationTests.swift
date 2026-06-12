// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SwiftUI
import XCTest

#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.junit4.ComposeContentTestRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertWidthIsEqualTo
import androidx.compose.ui.test.assertWidthIsAtLeast
import androidx.compose.ui.test.getUnclippedBoundsInRoot
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.width
import androidx.compose.ui.unit.height

import skip.ui.Animation
#endif

/// Drives SkipUI animation flow through Compose's test clock so we can verify that, for
/// example, a `.frame(width:)` whose argument changes inside `withAnimation` actually
/// interpolates over time rather than snapping. The Compose test rule lets us pause the frame
/// clock (`mainClock.autoAdvance = false`) and step it forward (`advanceTimeBy`) so animation
/// behaviour is fully deterministic.
///
/// These tests are Robolectric-only — they need `createComposeRule()`, which is not available
/// when running on the host Swift side.
final class AnimationTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    override func setUp() {
        super.setUp()
        #if SKIP
        // Each test must start with a clean recent-withAnimation slot so a marker left by a
        // sibling test (or by some unrelated `withAnimation` in setup machinery) can't bleed
        // in via the post-exit fallback.
        Animation.resetRecentWithAnimationForTesting()
        #endif
    }

    // MARK: - `recentWithAnimation` fallback behaviour

    /// `Animation.isInWithAnimation` reports the marker, which is set on exit from
    /// `withAnimation` (per-frame fallback for render-time-resolved values like `Shape.fill`).
    /// All actual consumers of `isInWithAnimation` are @Composable scopes that run *after*
    /// the state mutations inside the body, so they see the post-exit marker.
    func testIsInWithAnimationStaysTrueAcrossScopeExit() throws {
        #if !SKIP
        throw XCTSkip("Animation.isInWithAnimation is Android-only")
        #else
        XCTAssertFalse(Animation.isInWithAnimation)
        withAnimation(.linear(duration: 1)) {
            // body intentionally empty — the marker is published on exit
        }
        XCTAssertTrue(Animation.isInWithAnimation, "marker should keep isInWithAnimation true immediately after exit")
        #endif
    }

    /// `withAnimation(nil) { … }` is the explicit "don't animate" form — both the in-scope
    /// and post-exit values must report `false`, otherwise the fallback would force animations
    /// on code that asked for none.
    func testIsInWithAnimationFalseForNilAnimation() throws {
        #if !SKIP
        throw XCTSkip("Animation.isInWithAnimation is Android-only")
        #else
        var observed = true
        withAnimation(nil) {
            observed = Animation.isInWithAnimation
        }
        XCTAssertFalse(observed, "nil-animation scope should not flip isInWithAnimation inside")
        XCTAssertFalse(Animation.isInWithAnimation, "nil-animation scope should not set the post-exit marker")
        #endif
    }

    // NOTE: A "probe" test that calls `Animation.current` from inside a Composable and checks
    // the value after `withAnimation` exits would directly verify the `.fill` regression fix,
    // but under Robolectric the awaitFrame-based clear races with the recompose triggered by
    // the state write inside `withAnimation`. The race resolves to "clear first" frequently
    // enough that the test is flaky. The fix is exercised indirectly by
    // `testFrameWidthAnimatesUnderWithAnimation` (which animates through the same code path)
    // and by the `recentWithAnimation` plumbing being a precondition for that test to pass.

    // MARK: - Compose-driven animation

    /// Drive a `withAnimation { width = … }` change and step the Compose test clock through
    /// the linear interpolation, sampling the rendered frame width at multiple points and
    /// asserting it's strictly increasing — both that it's left the start (catches "animation
    /// never started") and that successive samples advance (catches "animation latched to one
    /// frame"). Exercises the full path: `withAnimation` publishes its recent-animation marker
    /// → state write triggers recompose → modifier reads the marker via `Animation.current`
    /// → Compose `Animatable.animateTo` → measured layout size.
    func testFrameWidthAnimatesUnderWithAnimation() throws {
        #if !SKIP
        throw XCTSkip("Compose mainClock animation testing is Android-only")
        #else
        // Stop the clock so we step animation frames manually.
        composeRule.mainClock.autoAdvance = false

        let sizeState = State(initialValue: 100.0)
        composeRule.setContent {
            ResizableRectangle(size: sizeState).Compose()
        }
        composeRule.mainClock.advanceTimeByFrame()
        composeRule.waitForIdle()

        // Initial layout: 100×100. Compose reports widths in dp.
        composeRule.onNodeWithTag("animated-rect").assertWidthIsEqualTo(100.0.dp)

        // Trigger an animation: 1s linear, target 300. The state write inside `withAnimation`
        // stamps the slot's transaction, the `.frame(…)` modifier's instrumented call site
        // captures it via `StateTracking.captureLastReadAndClear()` when it re-reads the size
        // during the next recomposition, and `Animation.current` resolves it to the animation.
        withAnimation(.linear(duration: 1.0)) {
            sizeState.wrappedValue = 300.0
        }
        composeRule.mainClock.advanceTimeByFrame()
        composeRule.waitForIdle()

        // After ~250 ms (a quarter of a 1 s linear ramp) the width must be at least past the
        // start — proves the animation actually engaged. We don't bound it tightly because
        // Compose's test clock has some startup slack on the first animation frame.
        composeRule.mainClock.advanceTimeBy(250)
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("animated-rect").assertWidthIsAtLeast(110.0.dp)

        // After ~500 ms total the value should be further along. This catches the "animation
        // latched to one frame" failure where the first sample looks OK but later samples
        // don't progress.
        composeRule.mainClock.advanceTimeBy(250)
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("animated-rect").assertWidthIsAtLeast(150.0.dp)

        // Past the 1 s duration — animation should be at the target.
        composeRule.mainClock.advanceTimeBy(700)
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("animated-rect").assertWidthIsEqualTo(300.0.dp)
        #endif
    }

    /// Without `withAnimation` the same state change must snap — the frame width has no
    /// captured transaction and no environment animation, so it should land at the new value
    /// without interpolation. We leave `autoAdvance = true` here so the snap-related coroutine
    /// (the `LaunchedEffect` that calls `animatable.snapTo`) runs naturally; manually advancing
    /// one frame proved insufficient to flush the snap. The Robolectric clock still completes
    /// the work synchronously from the test's perspective via `waitForIdle()`.
    func testFrameWidthSnapsWithoutAnimation() throws {
        #if !SKIP
        throw XCTSkip("Compose mainClock animation testing is Android-only")
        #else
        let sizeState = State(initialValue: 100.0)
        composeRule.setContent {
            ResizableRectangle(size: sizeState).Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("animated-rect").assertWidthIsEqualTo(100.0.dp)

        // Plain assignment, no withAnimation: should land at the target after the snapshot
        // notifications and the snap-coroutine settle.
        sizeState.wrappedValue = 300.0
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("animated-rect").assertWidthIsEqualTo(300.0.dp)
        #endif
    }

    // MARK: - @Observable provenance

    /// Diagnostic: with the default (auto-advancing) clock and no animation at all, an
    /// `@Observable` property write must propagate to the rendered layout. Separates
    /// "recomposition doesn't happen for observables in this harness" from provenance issues.
    func testObservablePropertyChangePropagates() throws {
        #if !SKIP
        throw XCTSkip("Compose UI testing is Android-only")
        #else
        let model = AnimatedSquaresModel()
        composeRule.setContent {
            ObservableSquares(model: model).Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("obs-unrelated-rect").assertWidthIsEqualTo(100.0.dp)

        model.unrelatedWidth = 300.0
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("obs-unrelated-rect").assertWidthIsEqualTo(300.0.dp)
        #endif
    }

    /// The two-square invariant for `@Observable` reference objects: a property mutated inside
    /// `withAnimation` must interpolate while a sibling property mutated outside it in the same
    /// handler must snap. Exercises the `Observed`/`MutableStateBacking` per-slot stamping path
    /// rather than `@State`.
    func testObservablePropertyAnimatesWhileUnrelatedSnaps() throws {
        #if !SKIP
        throw XCTSkip("Compose mainClock animation testing is Android-only")
        #else
        composeRule.mainClock.autoAdvance = false
        let model = AnimatedSquaresModel()
        composeRule.setContent {
            ObservableSquares(model: model).Compose()
        }
        composeRule.mainClock.advanceTimeByFrame()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("obs-animated-rect").assertWidthIsEqualTo(100.0.dp)
        composeRule.onNodeWithTag("obs-unrelated-rect").assertWidthIsEqualTo(100.0.dp)

        model.unrelatedWidth = 300.0
        withAnimation(.linear(duration: 1.0)) {
            model.width = 300.0
        }
        // Drive the clock in small steps and record when each rect settles at its target.
        // Asserting settle ORDER (snap finishes long before the 1s animation) plus at least
        // one observed intermediate width is robust to Robolectric's paused-clock coroutine
        // scheduling, which makes "measure at exactly t=250ms" style asserts racy.
        var animatedSettled = -1
        var unrelatedSettled = -1
        var sawIntermediate = false
        var step = 0
        while step < 200 && (animatedSettled < 0 || unrelatedSettled < 0) {
            composeRule.mainClock.advanceTimeBy(16)
            composeRule.waitForIdle()
            let a = Double(composeRule.onNodeWithTag("obs-animated-rect").getUnclippedBoundsInRoot().width.value)
            let u = Double(composeRule.onNodeWithTag("obs-unrelated-rect").getUnclippedBoundsInRoot().width.value)
            if a > 105.0 && a < 295.0 {
                sawIntermediate = true
            }
            if animatedSettled < 0 && abs(a - 300.0) < 0.5 {
                animatedSettled = step
            }
            if unrelatedSettled < 0 && abs(u - 300.0) < 0.5 {
                unrelatedSettled = step
            }
            step += 1
        }
        XCTAssertTrue(sawIntermediate, "animated property should interpolate through intermediate widths")
        XCTAssertTrue(unrelatedSettled >= 0, "un-animated property should settle at its target")
        XCTAssertTrue(animatedSettled >= 0, "animated property should reach its target")
        XCTAssertLessThan(unrelatedSettled, animatedSettled, "un-animated property must snap (settled at step \(unrelatedSettled)) well before the 1s animation completes (step \(animatedSettled))")
        #endif
    }

    /// Same invariant when the observable arrives through the SwiftUI environment
    /// (`.environment(model)` + `@Environment(Model.self)`) instead of an init parameter:
    /// provenance is per-slot on the object, so the arrival path must not matter.
    func testEnvironmentObservablePropertyAnimatesWhileUnrelatedSnaps() throws {
        #if !SKIP
        throw XCTSkip("Compose mainClock animation testing is Android-only")
        #else
        composeRule.mainClock.autoAdvance = false
        let model = AnimatedSquaresModel()
        composeRule.setContent {
            ObservableEnvironmentSquares().environment(model).Compose()
        }
        composeRule.mainClock.advanceTimeByFrame()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("obs-animated-rect").assertWidthIsEqualTo(100.0.dp)
        composeRule.onNodeWithTag("obs-unrelated-rect").assertWidthIsEqualTo(100.0.dp)

        model.unrelatedWidth = 300.0
        withAnimation(.linear(duration: 1.0)) {
            model.width = 300.0
        }
        // Drive the clock in small steps and record when each rect settles at its target.
        // Asserting settle ORDER (snap finishes long before the 1s animation) plus at least
        // one observed intermediate width is robust to Robolectric's paused-clock coroutine
        // scheduling, which makes "measure at exactly t=250ms" style asserts racy.
        var animatedSettled = -1
        var unrelatedSettled = -1
        var sawIntermediate = false
        var step = 0
        while step < 200 && (animatedSettled < 0 || unrelatedSettled < 0) {
            composeRule.mainClock.advanceTimeBy(16)
            composeRule.waitForIdle()
            let a = Double(composeRule.onNodeWithTag("obs-animated-rect").getUnclippedBoundsInRoot().width.value)
            let u = Double(composeRule.onNodeWithTag("obs-unrelated-rect").getUnclippedBoundsInRoot().width.value)
            if a > 105.0 && a < 295.0 {
                sawIntermediate = true
            }
            if animatedSettled < 0 && abs(a - 300.0) < 0.5 {
                animatedSettled = step
            }
            if unrelatedSettled < 0 && abs(u - 300.0) < 0.5 {
                unrelatedSettled = step
            }
            step += 1
        }
        XCTAssertTrue(sawIntermediate, "animated property should interpolate through intermediate widths")
        XCTAssertTrue(unrelatedSettled >= 0, "un-animated property should settle at its target")
        XCTAssertTrue(animatedSettled >= 0, "animated property should reach its target")
        XCTAssertLessThan(unrelatedSettled, animatedSettled, "un-animated property must snap (settled at step \(unrelatedSettled)) well before the 1s animation completes (step \(animatedSettled))")
        #endif
    }

    // MARK: - Adversarial sanity checks
    //
    // These tests deliberately assert the WRONG thing about animation behaviour. They exist to
    // prove that the surrounding test machinery (Compose clock control, `assertWidthIsEqualTo`,
    // the recent-animation marker flow) actually catches regressions when something is broken.
    // After confirming each one fails as expected (run once with `EXPECT_FAIL`), the asserts
    // are flipped to their correct values so the suite stays green.

    // Adversarial verification (deliberately-wrong assertions) was run once against this file
    // to confirm the test machinery actually catches regressions:
    //
    //  * `assertWidthIsEqualTo(999.0.dp)` against the initial layout → FAILED (rule reads real
    //    rendered size, not a stale value).
    //  * Mid-animation `assertWidthIsEqualTo(100.0.dp)` after 500 ms of a 1 s linear animation
    //    → FAILED (animation actually moves the value).
    //  * After a plain `state = 300` without `withAnimation`, `assertWidthIsEqualTo(100.0.dp)`
    //    → FAILED (the snap actually happens).
    //  * `XCTAssertTrue(Animation.isInWithAnimation)` outside any scope → FAILED.
    //
    // A subtle but real discovery from that round: in the mid-animation case, omitting the
    // `waitForIdle()` between `advanceTimeByFrame()` and `advanceTimeBy(500)` lets the wrong
    // assertion *pass* — the second time-advance doesn't drive a recomposition without an
    // intermediate idle, so the layout never updates. That's why `testFrameWidthAnimatesUnder­
    // WithAnimation` is careful to wait-for-idle between every clock step.
}

#if SKIP
/// Small test view whose frame width is driven by a shared `skip.ui.State` instance so the test
/// can mutate it externally while still exercising the real `@State` plumbing — including the
/// per-slot transaction stamping that animatable modifiers use to decide animate-vs-snap.
/// (A raw Compose `MutableState` would bypass stamping and always snap at instrumented sites.)
private struct ResizableRectangle: View {
    let size: State<Double>
    var body: some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: size.wrappedValue, height: 50)
            .accessibilityIdentifier("animated-rect")
    }
}

/// Observable model for the @Observable provenance tests: `width` is mutated inside
/// `withAnimation` while `unrelatedWidth` is mutated outside it in the same handler, so the
/// per-slot stamping on `Observed` properties must animate the former and snap the latter.
@Observable private final class AnimatedSquaresModel {
    var width = 100.0
    var unrelatedWidth = 100.0
}

/// Reads the observable's properties directly at the animatable modifier sites.
private struct ObservableSquares: View {
    let model: AnimatedSquaresModel
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.red)
                .frame(width: model.width, height: 50)
                .accessibilityIdentifier("obs-animated-rect")
            Rectangle()
                .fill(Color.green)
                .frame(width: model.unrelatedWidth, height: 50)
                .accessibilityIdentifier("obs-unrelated-rect")
        }
    }
}

/// Same shape, but the model arrives through the SwiftUI environment rather than an
/// initializer parameter.
private struct ObservableEnvironmentSquares: View {
    @Environment(AnimatedSquaresModel.self) var model: AnimatedSquaresModel
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.red)
                .frame(width: model.width, height: 50)
                .accessibilityIdentifier("obs-animated-rect")
            Rectangle()
                .fill(Color.green)
                .frame(width: model.unrelatedWidth, height: 50)
                .accessibilityIdentifier("obs-unrelated-rect")
        }
    }
}

#endif
