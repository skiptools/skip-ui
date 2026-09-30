// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SwiftUI
import XCTest

#if SKIP
import androidx.activity.ComponentActivity
import androidx.compose.runtime.Composable
import androidx.compose.ui.test.assertHeightIsEqualTo
import androidx.compose.ui.test.assertTextEquals
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.unit.dp
#endif

/// Verifies the retained-host, inherited-environment, and layout-transparent contract of
/// `androidCompositionBoundary(id:inputs:)` on Android.
final class AndroidCompositionBoundaryTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createAndroidComposeRule<ComponentActivity>()

    func testUnchangedInputsRetainContentAcrossParentRecomposition() throws {
        #if !SKIP
        throw XCTSkip("androidCompositionBoundary is Android-only")
        #else
        let parentTick = State(initialValue: 0)
        let counter = AndroidCompositionBoundaryBodyCounter()

        composeRule.setContent {
            AndroidCompositionBoundaryStableHost(
                parentTick: parentTick,
                counter: counter
            )
            .Compose()
        }
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("composition-boundary-parent").assertTextEquals("tick 0")
        composeRule.onNodeWithTag("composition-boundary-stable-child").assertTextEquals("retained")
        let initialCount = counter.value("stable-child")
        XCTAssertGreaterThan(initialCount, 0)

        parentTick.wrappedValue = 1
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("composition-boundary-parent").assertTextEquals("tick 1")
        composeRule.onNodeWithTag("composition-boundary-stable-child").assertTextEquals("retained")
        XCTAssertEqual(counter.value("stable-child"), initialCount)
        #endif
    }

    func testChangedInputsUpdateContentInsideExistingComposition() throws {
        #if !SKIP
        throw XCTSkip("androidCompositionBoundary is Android-only")
        #else
        let childText = State(initialValue: "A")
        let counter = AndroidCompositionBoundaryBodyCounter()

        composeRule.setContent {
            AndroidCompositionBoundaryInputHost(
                childText: childText,
                counter: counter
            )
            .Compose()
        }
        composeRule.waitForIdle()

        let initialHost = composeRule.runOnIdle {
            androidCompositionBoundaryHostView(
                root: composeRule.activity.findViewById(android.R.id.content)
            )
        }
        let initialCount = counter.value("input-child")
        composeRule.onNodeWithTag("composition-boundary-input-child").assertTextEquals("A")

        childText.wrappedValue = "B"
        composeRule.waitForIdle()

        let updatedHost = composeRule.runOnIdle {
            androidCompositionBoundaryHostView(
                root: composeRule.activity.findViewById(android.R.id.content)
            )
        }
        composeRule.onNodeWithTag("composition-boundary-input-child").assertTextEquals("B")
        XCTAssertTrue(updatedHost === initialHost)
        XCTAssertGreaterThan(counter.value("input-child"), initialCount)
        #endif
    }

    func testCompositionLocalsAreInheritedAndRefreshWithInputs() throws {
        #if !SKIP
        throw XCTSkip("androidCompositionBoundary is Android-only")
        #else
        let environmentValue = State(initialValue: "outer")

        composeRule.setContent {
            AndroidCompositionBoundaryEnvironmentHost(
                environmentValue: environmentValue
            )
            .Compose()
        }
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("composition-boundary-environment-child")
            .assertTextEquals("outer")

        environmentValue.wrappedValue = "inner"
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("composition-boundary-environment-child")
            .assertTextEquals("inner")
        #endif
    }

    func testParentConstraintChangeRemeasuresRetainedContent() throws {
        #if !SKIP
        throw XCTSkip("androidCompositionBoundary is Android-only")
        #else
        let height = State(initialValue: 80.0)
        let counter = AndroidCompositionBoundaryBodyCounter()

        composeRule.setContent {
            AndroidCompositionBoundaryLayoutHost(
                height: height,
                counter: counter
            )
            .Compose()
        }
        composeRule.waitForIdle()

        let initialHost = composeRule.runOnIdle {
            androidCompositionBoundaryHostView(
                root: composeRule.activity.findViewById(android.R.id.content)
            )
        }
        let initialCount = counter.value("layout-child")
        composeRule.onNodeWithTag("composition-boundary-layout-child")
            .assertHeightIsEqualTo(80.0.dp)

        height.wrappedValue = 140.0
        composeRule.waitForIdle()

        let updatedHost = composeRule.runOnIdle {
            androidCompositionBoundaryHostView(
                root: composeRule.activity.findViewById(android.R.id.content)
            )
        }
        composeRule.onNodeWithTag("composition-boundary-layout-child")
            .assertHeightIsEqualTo(140.0.dp)
        XCTAssertTrue(updatedHost === initialHost)
        XCTAssertEqual(counter.value("layout-child"), initialCount)
        #endif
    }
}

#if SKIP
private final class AndroidCompositionBoundaryBodyCounter {
    private var counts: [String: Int] = [:]

    @discardableResult
    func increment(_ key: String) -> Int {
        let next = (counts[key] ?? 0) + 1
        counts[key] = next
        return next
    }

    func value(_ key: String) -> Int {
        counts[key] ?? 0
    }
}

private struct AndroidCompositionBoundaryCountingContent: View {
    let counterKey: String
    let text: String
    let tag: String
    let counter: AndroidCompositionBoundaryBodyCounter
    let fillsAvailableHeight: Bool

    var body: some View {
        let _ = counter.increment(counterKey)
        if fillsAvailableHeight {
            Text(text)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityIdentifier(tag)
        } else {
            Text(text)
                .accessibilityIdentifier(tag)
        }
    }
}

private struct AndroidCompositionBoundaryStableHost: View {
    let parentTick: State<Int>
    let counter: AndroidCompositionBoundaryBodyCounter

    var body: some View {
        VStack {
            Text("tick \(parentTick.wrappedValue)")
                .accessibilityIdentifier("composition-boundary-parent")
            AndroidCompositionBoundaryCountingContent(
                counterKey: "stable-child",
                text: "retained",
                tag: "composition-boundary-stable-child",
                counter: counter,
                fillsAvailableHeight: false
            )
            .androidCompositionBoundary(id: "stable-boundary")
        }
    }
}

private struct AndroidCompositionBoundaryInputHost: View {
    let childText: State<String>
    let counter: AndroidCompositionBoundaryBodyCounter

    var body: some View {
        let text = childText.wrappedValue
        AndroidCompositionBoundaryCountingContent(
            counterKey: "input-child",
            text: text,
            tag: "composition-boundary-input-child",
            counter: counter,
            fillsAvailableHeight: false
        )
        .androidCompositionBoundary(id: "input-boundary", inputs: text)
    }
}

private struct AndroidCompositionBoundaryEnvironmentHost: View {
    let environmentValue: State<String>

    var body: some View {
        let value = environmentValue.wrappedValue
        AndroidCompositionBoundaryEnvironmentContent()
            .androidCompositionBoundary(id: "environment-boundary", inputs: value)
            .environment(\.testValue, value)
    }
}

private struct AndroidCompositionBoundaryEnvironmentContent: View {
    @Environment(\.testValue) var value: String

    var body: some View {
        Text(value)
            .accessibilityIdentifier("composition-boundary-environment-child")
    }
}

private struct AndroidCompositionBoundaryLayoutHost: View {
    let height: State<Double>
    let counter: AndroidCompositionBoundaryBodyCounter

    var body: some View {
        AndroidCompositionBoundaryCountingContent(
            counterKey: "layout-child",
            text: "layout",
            tag: "composition-boundary-layout-child",
            counter: counter,
            fillsAvailableHeight: true
        )
        .androidCompositionBoundary(id: "layout-boundary")
        .frame(width: 120.0, height: height.wrappedValue)
    }
}
#endif
