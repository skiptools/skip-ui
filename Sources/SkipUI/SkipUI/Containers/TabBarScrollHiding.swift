// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if SKIP
import androidx.compose.material3.adaptive.navigationsuite.NavigationSuiteScaffoldState
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.input.nestedscroll.NestedScrollConnection
import androidx.compose.ui.input.nestedscroll.NestedScrollSource
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

/// Hide the navigation bar while the content scrolls down; bring it back on the
/// way up.
///
/// Material's behaviour for a bottom bar over long content — Gmail, Play and
/// YouTube all do it, and `NavigationSuiteScaffoldState` exists to support it.
/// `TabView` already remembers one of those states and passes it to the
/// scaffold; nothing ever asked it to hide, so the bar was fixed.
///
/// ## Why this has to live here
///
/// There is no way to observe scrolling from SwiftUI code in Skip:
/// `onScrollGeometryChange`, `scrollPosition` and `onScrollPhaseChange` are all
/// absent, `GeometryProxy.frame(in:)` returns a real rectangle only for
/// `.global` and `CGRect(origin: .zero, size: size)` for every other space, and
/// a global-frame marker inside a scroll view is measured once at layout rather
/// than as the content moves. A nested-scroll connection is the mechanism
/// Compose provides, and it can only be installed by whoever composes the
/// scaffold.
///
/// ## The rules
///
/// Scrolling DOWN hides and scrolling UP shows — rather than "show once
/// scrolling stops", because reaching for navigation is the commonest reason to
/// scroll back, so the bar should already be there when you arrive.
///
/// Deltas ACCUMULATE against a threshold. A fingertip resting on a row, or the
/// half-pixel settle at the end of a fling, must not flap an animated bar.
/// Crossing the threshold in one direction resets the count, so a reversal takes
/// a deliberate movement rather than one stray frame.
struct TabBarHidingNestedScrollConnection: NestedScrollConnection {
    let state: NavigationSuiteScaffoldState
    let scope: CoroutineScope

    /// How far, in pixels, the content must move one way before the bar reacts.
    /// ~12dp at 3x, which is a deliberate flick rather than a twitch.
    let threshold: Float = Float(36.0)

    private var accumulated: Float = Float(0.0)

    override func onPreScroll(available: Offset, source: NestedScrollSource) -> Offset {
        // DRAGS ONLY. A fling's momentum arrives as `SideEffect` and would keep
        // driving the bar after the finger has gone, which reads as the bar
        // deciding for itself.
        guard source == NestedScrollSource.Drag else { return Offset.Zero }

        let dy = available.y
        // Sign change: start counting the new direction from here.
        if (dy < Float(0.0) && accumulated > Float(0.0)) || (dy > Float(0.0) && accumulated < Float(0.0)) {
            accumulated = Float(0.0)
        }
        accumulated += dy

        if accumulated <= -threshold {
            accumulated = Float(0.0)
            // Content moving up is the user scrolling down.
            scope.launch { state.hide() }
        } else if accumulated >= threshold {
            accumulated = Float(0.0)
            scope.launch { state.show() }
        }
        // Never consume: this watches the scroll, it does not take it.
        return Offset.Zero
    }
}

#endif
