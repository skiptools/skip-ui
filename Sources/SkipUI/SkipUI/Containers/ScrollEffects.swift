// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.blur
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.CompositingStrategy
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.layout.LayoutCoordinates
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.unit.dp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
#endif

/// The phases that a view transitions between when it scrolls among other views.
public enum ScrollTransitionPhase : Hashable {
    case topLeading
    case identity
    case bottomTrailing

    public var isIdentity: Bool {
        return self == .identity
    }

    /// -1 for `topLeading`, 0 for `identity`, and 1 for `bottomTrailing`.
    public var value: Double {
        switch self {
        case .topLeading: return -1.0
        case .identity: return 0.0
        case .bottomTrailing: return 1.0
        }
    }
}

/// The configuration of a scroll transition that controls how it animates across phases.
public struct ScrollTransitionConfiguration {
    /// Whether effects follow the scroll position rather than animating between discrete phases.
    let isInteractive: Bool
    let isEnabled: Bool

    /// Effects interpolate continuously as the view scrolls.
    public static let interactive = ScrollTransitionConfiguration(isInteractive: true, isEnabled: true)

    /// Effects animate when the view crosses a phase.
    public static let animated = ScrollTransitionConfiguration(isInteractive: false, isEnabled: true)

    /// Effects stay at the identity phase.
    public static let identity = ScrollTransitionConfiguration(isInteractive: false, isEnabled: false)

    public static func interactive(timingCurve: UnitCurve = .easeInOut) -> ScrollTransitionConfiguration {
        return interactive
    }

    public static func animated(_ animation: Animation = .default) -> ScrollTransitionConfiguration {
        return animated
    }
}

/// Visual effects that change a view's appearance without affecting its layout.
public protocol VisualEffect {
}

/// The base visual effect, which effect modifiers transform.
public struct EmptyVisualEffect : VisualEffect {
    var opacity = 1.0
    var scale = CGSize(width: 1.0, height: 1.0)
    var offset = CGSize.zero
    var rotation = Angle.zero
    var blurRadius = 0.0

    public init() {
    }

    public func opacity(_ opacity: Double) -> EmptyVisualEffect {
        var effect = self
        effect.opacity *= opacity
        return effect
    }

    public func scaleEffect(_ scale: CGFloat, anchor: UnitPoint = .center) -> EmptyVisualEffect {
        return scaleEffect(x: scale, y: scale, anchor: anchor)
    }

    public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0, anchor: UnitPoint = .center) -> EmptyVisualEffect {
        var effect = self
        effect.scale = CGSize(width: scale.width * x, height: scale.height * y)
        return effect
    }

    public func offset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> EmptyVisualEffect {
        var effect = self
        effect.offset = CGSize(width: offset.width + x, height: offset.height + y)
        return effect
    }

    public func offset(_ offset: CGSize) -> EmptyVisualEffect {
        return self.offset(x: offset.width, y: offset.height)
    }

    public func rotationEffect(_ angle: Angle, anchor: UnitPoint = .center) -> EmptyVisualEffect {
        var effect = self
        effect.rotation = Angle(radians: rotation.radians + angle.radians)
        return effect
    }

    public func blur(radius: CGFloat, opaque: Bool = false) -> EmptyVisualEffect {
        var effect = self
        effect.blurRadius += radius
        return effect
    }

    /// Opacity, scale width and height, offset width and height, rotation degrees, and blur radius.
    init(bridgedValues values: [Double]) {
        self.opacity = values[0]
        self.scale = CGSize(width: values[1], height: values[2])
        self.offset = CGSize(width: values[3], height: values[4])
        self.rotation = Angle(degrees: values[5])
        self.blurRadius = values[6]
    }
}

/// The geometry of a scroll view's content and container.
public struct ScrollGeometry : Equatable {
    public var contentOffset: CGPoint
    public var contentSize: CGSize
    public var contentInsets: EdgeInsets
    public var containerSize: CGSize

    public init(contentOffset: CGPoint, contentSize: CGSize, contentInsets: EdgeInsets, containerSize: CGSize) {
        self.contentOffset = contentOffset
        self.contentSize = contentSize
        self.contentInsets = contentInsets
        self.containerSize = containerSize
    }

    /// The content rectangle currently visible in the container.
    public var visibleRect: CGRect {
        return CGRect(origin: contentOffset, size: containerSize)
    }

    public var bounds: CGRect {
        return CGRect(origin: CGPoint(x: -contentInsets.leading, y: -contentInsets.top), size: containerSize)
    }

    /// Content offset, content size, insets (top, leading, bottom, trailing), and container size.
    var bridgedValues: [Double] {
        return [contentOffset.x, contentOffset.y, contentSize.width, contentSize.height, contentInsets.top, contentInsets.leading, contentInsets.bottom, contentInsets.trailing, containerSize.width, containerSize.height]
    }
}

extension View {
    /// Calls `action` when the value that `transform` derives from a `List`'s scroll geometry changes.
    // SKIP DECLARE: fun <T: Any> onScrollGeometryChange(for_: KClass<T>, of: (ScrollGeometry) -> T, action: (T, T) -> Unit): View
    public func onScrollGeometryChange<T>(for type: T.Type, of transform: @escaping (ScrollGeometry) -> T, action: @escaping (_ oldValue: T, _ newValue: T) -> Void) -> any View where T : Equatable {
        #if SKIP
        return ModifiedContent(content: self, modifier: ScrollGeometryModifier(transform: { transform($0) }, action: { action($0 as! T, $1 as! T) }))
        #else
        return self
        #endif
    }

    /// Bridged geometry change; `bridgedTransform` receives `ScrollGeometry.bridgedValues` and returns a comparable value.
    // SKIP @bridge
    public func onScrollGeometryChange(bridgedTransform: @escaping ([Double]) -> Any, bridgedAction: @escaping (Any, Any) -> Void) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: ScrollGeometryModifier(transform: { bridgedTransform($0.bridgedValues) }, action: bridgedAction))
        #else
        return self
        #endif
    }

    /// Applies effects as the view scrolls into and out of its scroll container's visible region.
    public func scrollTransition(_ configuration: ScrollTransitionConfiguration = .interactive, axis: Axis = .vertical, transition: @escaping (EmptyVisualEffect, ScrollTransitionPhase) -> any VisualEffect) -> any View {
        return scrollTransition(topLeading: configuration, bottomTrailing: configuration, axis: axis, transition: transition)
    }

    /// Bridged transition: configurations are 0 (identity), 1 (animated), or 2 (interactive), and `bridgedEffects`
    /// holds the identity, top-leading, and bottom-trailing effects' `EmptyVisualEffect.bridgedValues`.
    // SKIP @bridge
    public func scrollTransition(bridgedTopLeading: Int, bridgedBottomTrailing: Int, bridgedAxis: Int, bridgedEffects: [Double]) -> any View {
        let configuration: (Int) -> ScrollTransitionConfiguration = { $0 == 2 ? .interactive : $0 == 1 ? .animated : .identity }
        let effects = [0, 1, 2].map { EmptyVisualEffect(bridgedValues: Array(bridgedEffects[($0 * 7)..<($0 * 7 + 7)])) }
        return scrollTransition(topLeading: configuration(bridgedTopLeading), bottomTrailing: configuration(bridgedBottomTrailing), axis: bridgedAxis == 1 ? .horizontal : .vertical) { _, phase in
            switch phase {
            case .identity: return effects[0]
            case .topLeading: return effects[1]
            case .bottomTrailing: return effects[2]
            }
        }
    }

    public func scrollTransition(topLeading: ScrollTransitionConfiguration, bottomTrailing: ScrollTransitionConfiguration, axis: Axis = .vertical, transition: @escaping (EmptyVisualEffect, ScrollTransitionPhase) -> any VisualEffect) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: ScrollTransitionModifier(topLeading: topLeading, bottomTrailing: bottomTrailing, axis: axis, transition: transition))
        #else
        return self
        #endif
    }

    /// Calls `action` when at least `threshold` of the view becomes visible, or stops being visible, in its scroll container.
    // SKIP @bridge
    public func onScrollVisibilityChange(threshold: Double = 0.5, _ action: @escaping (Bool) -> Void) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: ScrollVisibilityModifier(threshold: threshold, action: action))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func defaultScrollAnchor(anchorX: CGFloat?, anchorY: CGFloat?) -> any View {
        return defaultScrollAnchor(anchorX == nil || anchorY == nil ? nil : UnitPoint(x: anchorX!, y: anchorY!))
    }

    /// The initial scroll position of a `List`; `.bottom` starts at the end and stays there as rows are added.
    public func defaultScrollAnchor(_ anchor: UnitPoint?) -> any View {
        #if SKIP
        return environment(\._defaultScrollAnchor, anchor, affectsEvaluate: false)
        #else
        return self
        #endif
    }
}

#if SKIP
/// A style applied to scroll edges by `scrollEdgeEffectStyle`.
struct ScrollEdgeEffect {
    let style: ScrollEdgeEffectStyle
    let edges: Edge.Set

    /// Length of the `.soft` fade.
    static let fadeLength = 24.0

    /// Draw the effect on a scroll container, only at edges with content scrolled beneath them.
    func modifier(isScrolledPastTop: Bool, isScrolledPastBottom: Bool) -> Modifier {
        let showsTop = edges.contains(.top) && isScrolledPastTop
        let showsBottom = edges.contains(.bottom) && isScrolledPastBottom
        guard showsTop || showsBottom else {
            return Modifier
        }
        if style == ScrollEdgeEffectStyle.hard {
            return Modifier.drawWithContent {
                drawContent()
                let color = androidx.compose.ui.graphics.Color.Gray.copy(alpha: Float(0.4))
                if showsTop {
                    drawLine(color, Offset(Float(0.0), Float(0.0)), Offset(size.width, Float(0.0)), 1.dp.toPx())
                }
                if showsBottom {
                    drawLine(color, Offset(Float(0.0), size.height), Offset(size.width, size.height), 1.dp.toPx())
                }
            }
        }
        // Soft: fade content out toward the edge, compositing offscreen so the fade masks the content
        return Modifier.graphicsLayer(compositingStrategy: CompositingStrategy.Offscreen).drawWithContent {
            drawContent()
            let fade = Float(ScrollEdgeEffect.fadeLength) * density
            if showsTop {
                drawRect(brush: Brush.verticalGradient(listOf(androidx.compose.ui.graphics.Color.Transparent, androidx.compose.ui.graphics.Color.Black), startY: Float(0.0), endY: fade), blendMode: androidx.compose.ui.graphics.BlendMode.DstIn)
            }
            if showsBottom {
                drawRect(brush: Brush.verticalGradient(listOf(androidx.compose.ui.graphics.Color.Black, androidx.compose.ui.graphics.Color.Transparent), startY: size.height - fade, endY: size.height), blendMode: androidx.compose.ui.graphics.BlendMode.DstIn)
            }
        }
    }
}

/// The fraction of the view hidden past its scroll container's leading (negative) or trailing (positive) edge.
func scrollHiddenFraction(_ coordinates: LayoutCoordinates, axis: Axis) -> Float {
    let size = axis == .vertical ? coordinates.size.height : coordinates.size.width
    guard size > 0 else {
        return Float(0.0)
    }
    // Window bounds are clipped by ancestors, including the scroll container
    let visible = coordinates.boundsInWindow()
    let origin = coordinates.localToWindow(androidx.compose.ui.geometry.Offset.Zero)
    let leadingHidden = axis == .vertical ? visible.top - origin.y : visible.left - origin.x
    let visibleSize = axis == .vertical ? visible.height : visible.width
    let hidden = max(Float(0.0), Float(size) - visibleSize) / Float(size)
    return leadingHidden > Float(0.5) ? -hidden : hidden
}

private func floatMagnitude(_ value: Float) -> Float {
    return value < Float(0.0) ? -value : value
}

final class ScrollTransitionModifier: RenderModifier {
    init(topLeading: ScrollTransitionConfiguration, bottomTrailing: ScrollTransitionConfiguration, axis: Axis, transition: @escaping (EmptyVisualEffect, ScrollTransitionPhase) -> any VisualEffect) {
        super.init()
        self.action = { renderable, context in
            let hiddenFraction = remember { mutableStateOf(Float(0.0)) }
            let identity = transition(EmptyVisualEffect(), .identity) as? EmptyVisualEffect ?? EmptyVisualEffect()
            let leading = transition(EmptyVisualEffect(), .topLeading) as? EmptyVisualEffect ?? EmptyVisualEffect()
            let trailing = transition(EmptyVisualEffect(), .bottomTrailing) as? EmptyVisualEffect ?? EmptyVisualEffect()
            let isLeading = hiddenFraction.value < Float(0.0)
            let configuration = isLeading ? topLeading : bottomTrailing
            // Interactive effects follow the scroll position; animated effects switch phases once the view is partly hidden
            let targetProgress = !configuration.isEnabled ? Float(0.0) : (configuration.isInteractive ? floatMagnitude(hiddenFraction.value) : (hiddenFraction.value == Float(0.0) ? Float(0.0) : Float(1.0)))
            let animatedProgress = animateFloatAsState(targetValue: targetProgress, label: "scrollTransition")
            let progress = configuration.isInteractive ? targetProgress : animatedProgress.value
            let edge = isLeading ? leading : trailing
            let blurRadius = identity.blurRadius + (edge.blurRadius - identity.blurRadius) * Double(progress)
            var modifier = context.modifier
                .onGloballyPositioned { hiddenFraction.value = scrollHiddenFraction($0, axis: axis) }
                .graphicsLayer {
                    let t = Double(progress)
                    alpha = Float(identity.opacity + (edge.opacity - identity.opacity) * t)
                    scaleX = Float(identity.scale.width + (edge.scale.width - identity.scale.width) * t)
                    scaleY = Float(identity.scale.height + (edge.scale.height - identity.scale.height) * t)
                    translationX = Float(identity.offset.width + (edge.offset.width - identity.offset.width) * t) * density
                    translationY = Float(identity.offset.height + (edge.offset.height - identity.offset.height) * t) * density
                    rotationZ = Float(identity.rotation.degrees + (edge.rotation.degrees - identity.rotation.degrees) * t)
                }
            if blurRadius > 0.0 {
                modifier = modifier.blur(blurRadius.dp)
            }
            renderable.Render(context: context.content(modifier: modifier))
        }
    }
}

/// Reports a derived value of the modified `List`'s scroll geometry when it changes.
final class ScrollGeometryModifier: RenderModifier {
    init(transform: @escaping (ScrollGeometry) -> Any, action: @escaping (Any, Any) -> Void) {
        super.init()
        self.action = { renderable, context in
            let lastValue = remember { mutableStateOf<Any?>(nil) }
            let onChange: (ScrollGeometry) -> Void = { geometry in
                let value = transform(geometry)
                if let oldValue = lastValue.value {
                    if oldValue != value {
                        lastValue.value = value
                        action(oldValue, value)
                    }
                } else {
                    lastValue.value = value
                }
            }
            EnvironmentValues.shared.setValues {
                $0.set_onScrollGeometryChange(onChange)
                return ComposeResult.ok
            } in: {
                renderable.Render(context: context)
            }
        }
    }
}

final class ScrollVisibilityModifier: RenderModifier {
    init(threshold: Double, action: @escaping (Bool) -> Void) {
        super.init()
        self.action = { renderable, context in
            let isVisible = remember { mutableStateOf<Bool?>(nil) }
            // Lazy containers dispose rows that scroll away
            DisposableEffect(true) {
                onDispose {
                    if isVisible.value == true {
                        action(false)
                    }
                }
            }
            let modifier = context.modifier.onGloballyPositioned {
                let visible = Double(Float(1.0) - floatMagnitude(scrollHiddenFraction($0, axis: .vertical))) >= threshold
                if isVisible.value != visible {
                    isVisible.value = visible
                    action(visible)
                }
            }
            renderable.Render(context: context.content(modifier: modifier))
        }
    }
}
#endif

#endif
