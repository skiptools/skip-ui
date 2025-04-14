// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.core.AnimationSpec
import androidx.compose.animation.core.FiniteAnimationSpec
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.scaleOut
import androidx.compose.animation.slideIn
import androidx.compose.animation.slideOut
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
#endif

// SKIP @bridge
public protocol Transition {
    #if false
    associatedtype Body : View
    @ViewBuilder func body(content: Self.Content, phase: TransitionPhase) -> Self.Body
    static var properties: TransitionProperties { get }
    typealias Content = PlaceholderContentView<Self>
    #endif

    #if SKIP
    @Composable func asEnterTransition(spec: AnimationSpec<Any>) -> EnterTransition
    @Composable func asExitTransition(spec: AnimationSpec<Any>) -> ExitTransition
    #endif
}

extension Transition {
    public func combined(with other: any Transition) -> any Transition {
        return CombinedTransition(self, other)
    }

    @available(*, unavailable)
    public func animation(_ animation: Animation?) -> any Transition {
        fatalError()
    }

    @available(*, unavailable)
    public static var properties: TransitionProperties {
        fatalError()
    }

    @available(*, unavailable)
    public func apply(content: any View, phase: TransitionPhase) -> any View {
        fatalError()
    }

    #if SKIP
    @Composable public func asEnterTransition(spec: AnimationSpec<Any>) -> EnterTransition {
        if spec is FiniteAnimationSpec {
            return fadeIn(spec as! FiniteAnimationSpec<Float>)
        } else {
            return fadeIn()
        }
    }

    @Composable public func asExitTransition(spec: AnimationSpec<Any>) -> ExitTransition {
        if spec is FiniteAnimationSpec {
            return fadeOut(spec as! FiniteAnimationSpec<Float>)
        } else {
            return fadeOut()
        }
    }
    #endif
}

public struct ContentTransition : RawRepresentable, Equatable {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let identity = ContentTransition(rawValue: 0)
    public static let opacity = ContentTransition(rawValue: 1)
    public static let interpolate = ContentTransition(rawValue: 2)
    public static func numericText(countsDown: Bool = false) -> ContentTransition {
        return ContentTransition(rawValue: 3)
    }
}

// SKIP @bridge
public struct AnyTransition {
    let transition: any Transition

    // SKIP @bridge
    public init(_ transition: any Transition) {
        self.transition = transition
    }

    public static func offset(_ offset: CGSize) -> AnyTransition {
        return AnyTransition(OffsetTransition(offset))
    }

    public static func offset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> AnyTransition {
        return AnyTransition(OffsetTransition(CGSize(width: x, height: y)))
    }

    public static var scale: AnyTransition {
        return AnyTransition(ScaleTransition(0.5))
    }

    public static func scale(_ scale: Double) -> AnyTransition {
        return AnyTransition(ScaleTransition(scale))
    }

    @available(*, unavailable)
    public static func scale(_ scale: Double, anchor: UnitPoint = .center) -> AnyTransition {
        fatalError()
    }

    public static var opacity: AnyTransition {
        return AnyTransition(OpacityTransition())
    }

    public static var slide: AnyTransition {
        return AnyTransition(SlideTransition())
    }

    public static var identity: AnyTransition {
        return AnyTransition(IdentityTransition())
    }

    public static func move(edge: Edge) -> AnyTransition {
        return AnyTransition(MoveTransition(edge: edge))
    }

    public static func push(from edge: Edge) -> AnyTransition {
        return AnyTransition(PushTransition(edge: edge))
    }

    public func combined(with other: AnyTransition) -> AnyTransition {
        return AnyTransition(transition.combined(with: other.transition))
    }

    @available(*, unavailable)
    public static func modifier(active: any ViewModifier, identity: any ViewModifier) -> AnyTransition {
        fatalError()
    }

    @available(*, unavailable)
    public func animation(_ animation: Animation?) -> AnyTransition {
        fatalError()
    }

    public static func asymmetric(insertion: AnyTransition, removal: AnyTransition) -> AnyTransition {
        return AnyTransition(AsymmetricTransition(insertion: insertion.transition, removal: removal.transition))
    }
}

public enum TransitionPhase: Hashable {
    case willAppear
    case identity
    case didDisappear

    public var isIdentity: Bool {
        return self == .identity
    }

    public var value: Double {
        switch self {
        case .willAppear:
            return -1.0
        case .identity:
            return 0.0
        case .didDisappear:
            return 1.0
        }
    }
}

public struct TransitionProperties {
    public let hasMotion: Bool

    public init(hasMotion: Bool = true) {
        self.hasMotion = hasMotion
    }
}

// SKIP @bridge
public struct AsymmetricTransition<Insertion, Removal> : Transition {
    public var insertion: Insertion
    public var removal: Removal

    // SKIP @bridge
    public init(insertion: Insertion, removal: Removal) {
        self.insertion = insertion
        self.removal = removal
    }

    #if false
    public func body(content: AsymmetricTransition<Insertion, Removal>.Content, phase: TransitionPhase) -> some View { return stubView() }
    public static var properties: TransitionProperties { get { fatalError() } }
    #endif

    #if SKIP
    @Composable public func asEnterTransition(spec: AnimationSpec<Any>) -> EnterTransition {
        return (insertion as! Transition).asEnterTransition(spec: spec)
    }

    @Composable public func asExitTransition(spec: AnimationSpec<Any>) -> ExitTransition {
        return (removal as! Transition).asExitTransition(spec: spec)
    }
    #endif
}

// SKIP @bridge
public struct CombinedTransition : Transition {
    public var first: any Transition
    public var second: any Transition

    // SKIP @bridge
    public init(_ first: any Transition, _ second: any Transition) {
        self.first = first
        self.second = second
    }

    #if SKIP
    @Composable public func asEnterTransition(spec: AnimationSpec<Any>) -> EnterTransition {
        return first.asEnterTransition(spec: spec) + second.asEnterTransition(spec: spec)
    }

    @Composable public func asExitTransition(spec: AnimationSpec<Any>) -> ExitTransition {
        return first.asExitTransition(spec: spec) + second.asExitTransition(spec: spec)
    }
    #endif
}

// SKIP @bridge
public struct PushTransition : Transition {
    public var edge: Edge

    public init(edge: Edge) {
        self.edge = edge
    }

    // SKIP @bridge
    public init(bridgedEdge: Int) {
        self.init(edge: Edge(rawValue: bridgedEdge) ?? .leading)
    }

    #if false
    public func body(content: PushTransition.Content, phase: TransitionPhase) -> some View { return stubView() }
    #endif

    #if SKIP
    @Composable public func asEnterTransition(spec: AnimationSpec<Any>) -> EnterTransition {
        let isRTL = EnvironmentValues.shared.layoutDirection == LayoutDirection.rightToLeft
        if spec is FiniteAnimationSpec {
            return fadeIn(spec as! FiniteAnimationSpec<Float>) + slideIn(animationSpec: spec as! FiniteAnimationSpec<IntOffset>, initialOffset: { $0.offset(edge: edge, isRTL: isRTL) })
        } else {
            return fadeIn() + slideIn(initialOffset: { $0.offset(edge: edge, isRTL: isRTL) })
        }
    }

    @Composable public func asExitTransition(spec: AnimationSpec<Any>) -> ExitTransition {
        let isRTL = EnvironmentValues.shared.layoutDirection == LayoutDirection.rightToLeft
        if spec is FiniteAnimationSpec {
            return fadeOut(spec as! FiniteAnimationSpec<Float>) + slideOut(animationSpec: spec as! FiniteAnimationSpec<IntOffset>, targetOffset: { $0.offsetOpposite(edge: edge, isRTL: isRTL) })
        } else {
            return fadeOut() + slideOut(targetOffset: { $0.offsetOpposite(edge: edge, isRTL: isRTL) })
        }
    }
    #endif
}

// SKIP @bridge
public struct ScaleTransition : Transition {
    public var scale: Double
    public var anchor: UnitPoint

    public init(_ scale: Double, anchor: UnitPoint = .center) {
        self.scale = scale
        self.anchor = anchor
    }

    // SKIP @bridge
    public init(scale: Double, anchorX: CGFloat, anchorY: CGFloat) {
        self.init(scale, anchor: UnitPoint(x: anchorX, y: anchorY))
    }

    #if false
    public func body(content: ScaleTransition.Content, phase: TransitionPhase) -> some View { return stubView() }
    #endif

    #if SKIP
    @Composable public func asEnterTransition(spec: AnimationSpec<Any>) -> EnterTransition {
        if spec is FiniteAnimationSpec {
            return scaleIn(animationSpec: spec as! FiniteAnimationSpec<Float>, initialScale: Float(scale))
        } else {
            return scaleIn(initialScale: Float(scale))
        }
    }

    @Composable public func asExitTransition(spec: AnimationSpec<Any>) -> ExitTransition {
        if spec is FiniteAnimationSpec {
            return scaleOut(animationSpec: spec as! FiniteAnimationSpec<Float>, targetScale: Float(scale))
        } else {
            return scaleOut(targetScale: Float(scale))
        }
    }
    #endif
}

// SKIP @bridge
public struct SlideTransition : Transition {
    // SKIP @bridge
    public init() {
    }

    #if false
    public func body(content: SlideTransition.Content, phase: TransitionPhase) -> some View { return stubView() }
    #endif

    #if SKIP
    @Composable public func asEnterTransition(spec: AnimationSpec<Any>) -> EnterTransition {
        let isRTL = EnvironmentValues.shared.layoutDirection == LayoutDirection.rightToLeft
        if spec is FiniteAnimationSpec {
            return slideIn(animationSpec: spec as! FiniteAnimationSpec<IntOffset>, initialOffset: { $0.offset(edge: Edge.leading, isRTL: isRTL) })
        } else {
            return slideIn(initialOffset: { $0.offset(edge: Edge.leading, isRTL: isRTL) })
        }
    }

    @Composable public func asExitTransition(spec: AnimationSpec<Any>) -> ExitTransition {
        let isRTL = EnvironmentValues.shared.layoutDirection == LayoutDirection.rightToLeft
        if spec is FiniteAnimationSpec {
            return slideOut(animationSpec: spec as! FiniteAnimationSpec<IntOffset>, targetOffset: { $0.offset(edge: Edge.trailing, isRTL: isRTL) })
        } else {
            return slideOut(targetOffset: { $0.offset(edge: Edge.trailing, isRTL: isRTL) })
        }
    }
    #endif
}

// SKIP @bridge
public struct IdentityTransition : Transition {
    // SKIP @bridge
    public init () {
    }

    #if false
    public func body(content: IdentityTransition.Content, phase: TransitionPhase) -> Body { fatalError() }
    public static let properties: TransitionProperties = { fatalError() }()
    #endif

    #if SKIP
    @Composable public func asEnterTransition(spec: AnimationSpec<Any>) -> EnterTransition {
        return EnterTransition.None
    }

    @Composable public func asExitTransition(spec: AnimationSpec<Any>) -> ExitTransition {
        return ExitTransition.None
    }
    #endif
}

// SKIP @bridge
public struct MoveTransition : Transition {
    public var edge: Edge

    public init(edge: Edge) {
        self.edge = edge
    }

    // SKIP @bridge
    public init(bridgedEdge: Int) {
        self.init(edge: Edge(rawValue: bridgedEdge) ?? .leading)
    }

    #if false
    public func body(content: MoveTransition.Content, phase: TransitionPhase) -> some View { return stubView() }
    #endif

    #if SKIP
    @Composable public func asEnterTransition(spec: AnimationSpec<Any>) -> EnterTransition {
        let isRTL = EnvironmentValues.shared.layoutDirection == LayoutDirection.rightToLeft
        if spec is FiniteAnimationSpec {
            return slideIn(animationSpec: spec as! FiniteAnimationSpec<IntOffset>, initialOffset: { $0.offset(edge: edge, isRTL: isRTL) })
        } else {
            return slideIn(initialOffset: { $0.offset(edge: edge, isRTL: isRTL) })
        }
    }

    @Composable public func asExitTransition(spec: AnimationSpec<Any>) -> ExitTransition {
        let isRTL = EnvironmentValues.shared.layoutDirection == LayoutDirection.rightToLeft
        if spec is FiniteAnimationSpec {
            return slideOut(animationSpec: spec as! FiniteAnimationSpec<IntOffset>, targetOffset: { $0.offset(edge: edge, isRTL: isRTL) })
        } else {
            return slideOut(targetOffset: { $0.offset(edge: edge, isRTL: isRTL) })
        }
    }
    #endif
}

// SKIP @bridge
public struct OffsetTransition : Transition {
    public var offset: CGSize

    public init(_ offset: CGSize) {
        self.offset = offset
    }

    // SKIP @bridge
    public init(offsetWidth: CGFloat, height: CGFloat) {
        self.init(CGSize(width: offsetWidth, height: height))
    }

    #if false
    public func body(content: OffsetTransition.Content, phase: TransitionPhase) -> some View { return stubView() }
    #endif

    #if SKIP
    @Composable public func asEnterTransition(spec: AnimationSpec<Any>) -> EnterTransition {
        let intOffset = with (LocalDensity.current) { IntOffset(offset.width.dp.roundToPx(), offset.height.dp.roundToPx()) }
        if spec is FiniteAnimationSpec {
            return slideIn(animationSpec: spec as! FiniteAnimationSpec<IntOffset>, initialOffset: { _ in intOffset })
        } else {
            return slideIn(initialOffset: { _ in intOffset })
        }
    }

    @Composable public func asExitTransition(spec: AnimationSpec<Any>) -> ExitTransition {
        let intOffset = with (LocalDensity.current) { IntOffset(offset.width.dp.roundToPx(), offset.height.dp.roundToPx()) }
        if spec is FiniteAnimationSpec {
            return slideOut(animationSpec: spec as! FiniteAnimationSpec<IntOffset>, targetOffset: { _ in intOffset })
        } else {
            return slideOut(targetOffset: { _ in intOffset })
        }
    }
    #endif
}

// SKIP @bridge
public struct OpacityTransition : Transition {
    static let shared = OpacityTransition()

    // SKIP @bridge
    public init() {
    }

    #if false
    public func body(content: OpacityTransition.Content, phase: TransitionPhase) -> some View { return stubView() }
    public static let properties: TransitionProperties = { fatalError() }()
    #endif
}

extension View {
    #if !SKIP
    // Skip can't differentiate calls between the two .transition modifiers
    public func transition(_ transition: any Transition) -> any View {
        fatalError()
    }
    #endif

    // SKIP @bridge
    public func transition(_ t: AnyTransition) -> any View {
        #if SKIP
        return TransitionModifierView(view: self, transition: t.transition)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func contentTransition(_ transition: Any /* ContentTransition */) -> any View {
        fatalError()
    }
}

#if SKIP
struct TransitionModifierView: ComposeModifierView {
    let transition: Transition

    init(view: View, transition: Transition) {
        self.transition = transition
        super.init(view: view)
    }

    /// Extract the transition from the given view's modifiers.
    static func transition(for view: View) -> Transition? {
        guard let modifierView = view.strippingModifiers(until: { $0 is TransitionModifierView }, perform: { $0 as? TransitionModifierView }) else {
            return nil
        }
        return modifierView.transition
    }
}

extension IntSize {
    func offset(edge: Edge, isRTL: Bool) -> IntOffset {
        switch edge {
        case .top:
            return IntOffset(0, -self.height)
        case .bottom:
            return IntOffset(0, self.height)
        case .leading:
            return IntOffset(isRTL ? self.width: -self.width, 0)
        case .trailing:
            return IntOffset(isRTL ? -self.width: self.width, 0)
        }
    }

    func offsetOpposite(edge: Edge, isRTL: Bool) -> IntOffset {
        let offset = offset(edge: edge, isRTL: isRTL)
        return IntOffset(offset.x * -1, offset.y * -1)
    }
}
#endif
#endif
