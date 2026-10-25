// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.animation.core.FiniteAnimationSpec
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.snap
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.unit.Dp

// App bars float over content that fills the screen, as overlays. Content insets itself by the space a bar covers once
// it has shown, and scrollables run beneath the bars, reserving that space inside their scrolling content. Hiding and
// showing a bar with `toolbarVisibility` then only slides the bar: its visibility reaches the bar through a
// `BarVisibility` that only the bar reads, so nothing beneath it recomposes or lays out again.

/// The visibility that content asks of a navigation bar or tab bar with `toolbarVisibility`.
///
/// Only the bar reads it. Containers lay out as though a bar that has shown still shows, so that content keeps its
/// place as the bar slides away over it.
final class BarVisibility {
    /// The requested visibility, or nil when no content asks for one.
    let visibility: MutableState<Visibility?> = mutableStateOf(nil)
    /// The animation of the last change.
    private(set) var animation: Animation?
    /// Whether the bar has laid out, after which it keeps its space while hidden.
    let hasShown = mutableStateOf(false)
    /// How far the bar shows as it slides, from 0 when hidden to 1 when shown, published by the bar. Read it only while
    /// drawing, so that following the bar never recomposes.
    var fraction: State<Float>?
    /// How far the bar slides as it hides, in pixels: off the screen, or behind the system bar it sits against.
    var travelPx = Float(0.0)
    /// The height the bar covers beyond the system bar, in pixels: how far views attached to its edge slide.
    var heightPx = Float(0.0)
    private struct Request {
        let requester: Requester
        let visibility: Visibility
        let animation: Animation?
    }
    /// Active requests in update order. The most recently updated requester takes precedence.
    private var requests: [Request] = []

    /// Identifies the view asking for a visibility, so that it only clears its own request.
    final class Requester {
    }

    /// Whether the bar is hidden and has never shown, so that it reserves no space.
    var isHiddenFromStart: Bool {
        return visibility.value == Visibility.hidden && !hasShown.value
    }

    func request(_ visibility: Visibility, animation: Animation?, by requester: Requester) {
        if let index = requests.firstIndex(where: { $0.requester === requester }) {
            requests.remove(at: index)
        }
        requests.append(Request(requester: requester, visibility: visibility, animation: animation))
        apply(requests.last)
    }

    func clear(by requester: Requester) {
        guard let index = requests.firstIndex(where: { $0.requester === requester }) else {
            return
        }
        requests.remove(at: index)
        apply(requests.last)
    }

    private func apply(_ request: Request?) {
        animation = request?.animation
        if visibility.value != request?.visibility {
            visibility.value = request?.visibility
        }
    }
}

/// Asks `bar` for `visibility` while the calling view is composed.
///
/// The request is made during composition, so that a bar hidden from the start never lays out.
@Composable func RequestBarVisibility(_ bar: BarVisibility, visibility: Visibility, animation: Animation?) {
    let requester = remember { BarVisibility.Requester() }
    bar.request(visibility, animation: animation, by: requester)
    DisposableEffect(bar) {
        onDispose {
            bar.clear(by: requester)
        }
    }
}

/// How far a bar shows: 0 when hidden and 1 when shown, animating with `animation` as its visibility changes.
///
/// Read the value only while drawing or placing, so that the animation never recomposes.
@Composable func animatedBarFraction(isVisible: Bool, animation: Animation?, label: String) -> State<Float> {
    // One call, so that the state stays the same as the animation changes: views drawing with it keep observing it
    let spec = animation?.asAnimationSpec()
    let finiteSpec: FiniteAnimationSpec<Float> = spec is FiniteAnimationSpec ? spec as! FiniteAnimationSpec<Float> : snap()
    return animateFloatAsState(targetValue: isVisible ? Float(1.0) : Float(0.0), animationSpec: finiteSpec, label: label)
}

/// Covers a system bar's area while the app bar over it isn't fully shown, so that content scrolled beneath the app bar
/// never shows through the system bar.
@Composable func HiddenBarScrim(bar: BarVisibility, height: Dp, color: androidx.compose.ui.graphics.Color, modifier: Modifier) {
    Box(modifier: modifier.fillMaxWidth().height(height).drawBehind {
        if (bar.fraction?.value ?? Float(1.0)) < Float(1.0) {
            drawRect(color)
        }
    })
}

/// Slides a bar away by its `travelPx` as it hides. Only the drawing moves: the bar stays composed and laid out, so
/// hiding and showing it never recomposes it, and views following it stay in step.
func slidingAway(_ bar: BarVisibility, edge: VerticalEdge) -> Modifier {
    let direction: Float = edge == VerticalEdge.top ? Float(-1.0) : Float(1.0)
    return Modifier.graphicsLayer {
        translationY = direction * bar.travelPx * (Float(1.0) - (bar.fraction?.value ?? Float(1.0)))
    }
}

/// Slides a view attached to a bar's inner edge along with the bar, such as a `safeAreaInset` beneath the navigation
/// bar, as iOS moves it with the safe area. The view follows the bar's edge until it reaches the system bar.
///
/// - Parameter hidesWithBar: Whether the view slides away entirely, beneath the bar, as a search field in the bar does.
func slidingWithBar(_ bar: BarVisibility, edge: VerticalEdge, hidesWithBar: Bool = false) -> Modifier {
    let direction: Float = edge == VerticalEdge.top ? Float(-1.0) : Float(1.0)
    return Modifier.graphicsLayer {
        let hidden = Float(1.0) - (bar.fraction?.value ?? Float(1.0))
        let distance = hidesWithBar ? (bar.travelPx + size.height) * hidden : min(bar.travelPx * hidden, bar.heightPx)
        translationY = direction * distance
    }
}
#endif
#endif
