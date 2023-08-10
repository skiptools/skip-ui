// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A description of view changes to apply when a view is added to and removed
/// from the view hierarchy.
///
/// A transition should generally be made by applying one or more modifiers to
/// the `content`. For symmetric transitions, the `isIdentity` property on
/// `phase` can be used to change the properties of modifiers. For asymmetric
/// transitions, the phase itself can be used to change those properties.
/// Transitions should not use any identity-affecting changes like `.id`, `if`,
/// and `switch` on the `content`, since doing so would reset the state of the
/// view they're applied to, causing wasted work and potentially surprising
/// behavior when it appears and disappears.
///
/// The following code defines a transition that can be used to change the
/// opacity and rotation when a view appears and disappears.
///
///     struct RotatingFadeTransition: Transition {
///         func body(content: Content, phase: TransitionPhase) -> some View {
///             content
///               .opacity(phase.isIdentity ? 1.0 : 0.0)
///               .rotationEffect(phase.rotation)
///         }
///     }
///     extension TransitionPhase {
///         fileprivate var rotation: Angle {
///             switch self {
///             case .willAppear: return .degrees(30)
///             case .identity: return .zero
///             case .didDisappear: return .degrees(-30)
///             }
///         }
///     }
///
/// - See Also: `TransitionPhase`
/// - See Also: `AnyTransition`
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol Transition {

    /// The type of view representing the body.
    associatedtype Body : View

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    @ViewBuilder func body(content: Self.Content, phase: TransitionPhase) -> Self.Body

    /// Returns the properties this transition type has.
    ///
    /// Defaults to `TransitionProperties()`.
    static var properties: TransitionProperties { get }

    /// The content view type passed to `body()`.
    typealias Content = PlaceholderContentView<Self>
}


/// A type-erased transition.
///
/// - See Also: `Transition`
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct AnyTransition {

    /// Create an instance that type-erases `transition`.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init<T>(_ transition: T) where T : Transition { fatalError() }
}

/// An indication of which the current stage of a transition.
///
/// When a view is appearing with a transition, the transition will first be
/// shown with the `willAppear` phase, then will be immediately moved to the
/// `identity` phase. When a view is being removed, its transition is changed
/// from the `identity` phase to the `didDisappear` phase. If a view is removed
/// while it is still transitioning in, then its phase will change to
/// `didDisappear`. If a view is re-added while it is transitioning out, its
/// phase will change back to `identity`.
///
/// In the `identity` phase, transitions should generally not make any visual
/// change to the view they are applied to, since the transition's view
/// modifications in the `identity` phase will be applied to the view as long as
/// it is visible. In the `willAppear` and `didDisappear` phases, transitions
/// should apply a change that will be animated to create the transition. If no
/// animatable change is applied, then the transition will be a no-op.
///
/// - See Also: `Transition`
/// - See Also: `AnyTransition`
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@frozen public enum TransitionPhase {

    /// The transition is being applied to a view that is about to be inserted
    /// into the view hierarchy.
    ///
    /// In this phase, a transition should show the appearance that will be
    /// animated from to make the appearance transition.
    case willAppear

    /// The transition is being applied to a view that is in the view hierarchy.
    ///
    /// In this phase, a transition should show its steady state appearance,
    /// which will generally not make any visual change to the view.
    case identity

    /// The transition is being applied to a view that has been requested to be
    /// removed from the view hierarchy.
    ///
    /// In this phase, a transition should show the appearance that will be
    /// animated to to make the disappearance transition.
    case didDisappear

    /// A Boolean that indicates whether the transition should have an identity
    /// effect, i.e. not change the appearance of its view.
    ///
    /// This is true in the `identity` phase.
    public var isIdentity: Bool { get { fatalError() } }

    


}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension TransitionPhase {

    /// A value that can be used to multiply effects that are applied
    /// differently depending on the phase.
    ///
    /// - Returns: Zero when in the `identity` case, -1.0 for `willAppear`,
    ///   and 1.0 for `didDisappear`.
    public var value: Double { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension TransitionPhase : Equatable {
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension TransitionPhase : Hashable {
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension TransitionPhase : Sendable {
}

/// The properties a `Transition` can have.
///
/// A transition can have properties that specify high level information about
/// it. This can determine how a transition interacts with other features like
/// Accessibility settings.
///
/// - See Also: `Transition`
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct TransitionProperties : Sendable {

    public init(hasMotion: Bool = true) { fatalError() }

    /// Whether the transition includes motion.
    ///
    /// When this behavior is included in a transition, that transition will be
    /// replaced by opacity when Reduce Motion is enabled.
    ///
    /// Defaults to `true`.
    public var hasMotion: Bool { get { fatalError() } }
}

/// A composite `Transition` that uses a different transition for
/// insertion versus removal.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct AsymmetricTransition<Insertion, Removal> : Transition where Insertion : Transition, Removal : Transition {

    /// The `Transition` defining the insertion phase of `self`.
    public var insertion: Insertion { get { fatalError() } }

    /// The `Transition` defining the removal phase of `self`.
    public var removal: Removal { get { fatalError() } }

    /// Creates a composite `Transition` that uses a different transition for
    /// insertion versus removal.
    public init(insertion: Insertion, removal: Removal) { fatalError() }

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: AsymmetricTransition<Insertion, Removal>.Content, phase: TransitionPhase) -> some View { return never() }


    /// Returns the properties this transition type has.
    ///
    /// Defaults to `TransitionProperties()`.
    public static var properties: TransitionProperties { get { fatalError() } }

    /// The type of view representing the body.
//    public typealias Body = some View
}

/// A transition that when added to a view will animate the view's insertion by
/// moving it in from the specified edge while fading it in, and animate its
/// removal by moving it out towards the opposite edge and fading it out.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct PushTransition : Transition {

    /// The edge from which the view will be animated in.
    public var edge: Edge { get { fatalError() } }

    /// Creates a transition that animates a view by moving and fading it.
    public init(edge: Edge) { fatalError() }

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: PushTransition.Content, phase: TransitionPhase) -> some View { return never() }


    /// The type of view representing the body.
//    public typealias Body = some View
}

/// Returns a transition that scales the view.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ScaleTransition : Transition {

    /// The amount to scale the view by.
    public var scale: Double { get { fatalError() } }

    /// The anchor point to scale the view around.
    public var anchor: UnitPoint { get { fatalError() } }

    /// Creates a transition that scales the view by the specified amount.
    public init(_ scale: Double, anchor: UnitPoint = .center) { fatalError() }

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: ScaleTransition.Content, phase: TransitionPhase) -> some View { return never() }


    /// The type of view representing the body.
//    public typealias Body = some View
}

/// A transition that inserts by moving in from the leading edge, and
/// removes by moving out towards the trailing edge.
///
/// - SeeAlso: `MoveTransition`
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct SlideTransition : Transition {

    public init() { fatalError() }

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: SlideTransition.Content, phase: TransitionPhase) -> some View { return never() }


    /// The type of view representing the body.
//    public typealias Body = some View
}

/// A transition that returns the input view, unmodified, as the output
/// view.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct IdentityTransition : Transition {

    public init() { fatalError() }

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: IdentityTransition.Content, phase: TransitionPhase) -> Body { fatalError() }

    /// Returns the properties this transition type has.
    ///
    /// Defaults to `TransitionProperties()`.
    public static let properties: TransitionProperties = { fatalError() }()

    /// The type of view representing the body.
    public typealias Body = Never
}


/// A kind of transition that applies to the content within a single view,
/// rather than to the insertion or removal of a view.
///
/// Set the behavior of content transitions within a view with the
/// ``View/contentTransition(_:)`` modifier, passing in one of the defined
/// transitions, such as ``opacity`` or ``interpolate`` as the parameter.
///
/// > Tip: Content transitions only take effect within transactions that apply
/// an ``Animation`` to the views inside the ``View/contentTransition(_:)``
/// modifier.
///
/// Content transitions only take effect within the context of an
/// ``Animation`` block.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ContentTransition : Equatable, Sendable {

    /// The identity content transition, which indicates that content changes
    /// shouldn't animate.
    ///
    /// You can pass this value to a ``View/contentTransition(_:)``
    /// modifier to selectively disable animations that would otherwise
    /// be applied by a ``withAnimation(_:_:)`` block.
    public static let identity: ContentTransition = { fatalError() }()

    /// A content transition that indicates content fades from transparent
    /// to opaque on insertion, and from opaque to transparent on removal.
    public static let opacity: ContentTransition = { fatalError() }()

    /// A content transition that indicates the views attempt to interpolate
    /// their contents during transitions, where appropriate.
    ///
    /// Text views can interpolate transitions when the text views have
    /// identical strings. Matching glyph pairs can animate changes to their
    /// color, position, size, and any variable properties. Interpolation can
    /// apply within a ``Font/Design`` case, but not between cases, or between
    /// entirely different fonts. For example, you can interpolate a change
    /// between ``Font/Weight/thin`` and ``Font/Weight/black`` variations of a
    /// font, since these are both cases of ``Font/Weight``. However, you can't
    /// interpolate between the default design of a font and its Italic version,
    /// because these are different fonts. Any changes that can't show an
    /// interpolated animation use an opacity animation instead.
    ///
    /// Symbol images created with the ``Image/init(systemName:)`` initializer
    /// work the same way as text: changes within the same symbol attempt to
    /// interpolate the symbol's paths. When interpolation is unavailable, the
    /// system uses an opacity transition instead.
    public static let interpolate: ContentTransition = { fatalError() }()

    /// Creates a content transition intended to be used with `Text`
    /// views displaying numeric text. In certain environments changes
    /// to the text will enable a nonstandard transition tailored to
    /// numeric characters that count up or down.
    ///
    /// - Parameters:
    ///   - countsDown: true if the numbers represented by the text
    ///     are counting downwards.
    ///
    /// - Returns: a new content transition.
    public static func numericText(countsDown: Bool = false) -> ContentTransition { fatalError() }

    
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Associates a transition with the view.
    ///
    /// When this view appears or disappears, the transition will be applied to
    /// it, allowing for animating it in and out.
    ///
    /// The following code will conditionally show MyView, and when it appears
    /// or disappears, will use a slide transition to show it.
    ///
    ///     if isActive {
    ///         MyView()
    ///             .transition(.slide)
    ///     }
    ///     Button("Toggle") {
    ///         withAnimation {
    ///             isActive.toggle()
    ///         }
    ///     }
    @inlinable public func transition(_ t: AnyTransition) -> some View { return never() }


    /// Associates a transition with the view.
    ///
    /// When this view appears or disappears, the transition will be applied to
    /// it, allowing for animating it in and out.
    ///
    /// The following code will conditionally show MyView, and when it appears
    /// or disappears, will use a custom RotatingFadeTransition transition to
    /// show it.
    ///
    ///     if isActive {
    ///         MyView()
    ///             .transition(RotatingFadeTransition())
    ///     }
    ///     Button("Toggle") {
    ///         withAnimation {
    ///             isActive.toggle()
    ///         }
    ///     }
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func transition<T>(_ transition: T) -> some View where T : Transition { return never() }

}

/// Returns a transition that moves the view away, towards the specified
/// edge of the view.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct MoveTransition : Transition {

    /// The edge to move the view towards.
    public var edge: Edge { get { fatalError() } }

    /// Creates a transition that moves the view away, towards the specified
    /// edge of the view.
    public init(edge: Edge) { fatalError() }

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: MoveTransition.Content, phase: TransitionPhase) -> some View { return never() }


    /// The type of view representing the body.
//    public typealias Body = some View
}

/// Returns a transition that offset the view by the specified amount.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct OffsetTransition : Transition {

    /// The amount to offset the view by.
    public var offset: CGSize { get { fatalError() } }

    /// Creates a transition that offset the view by the specified amount.
    public init(_ offset: CGSize) { fatalError() }

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: OffsetTransition.Content, phase: TransitionPhase) -> some View { return never() }


    /// The type of view representing the body.
//    public typealias Body = some View
}

/// A transition from transparent to opaque on insertion, and from opaque to
/// transparent on removal.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct OpacityTransition : Transition {

    public init() { fatalError() }

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: OpacityTransition.Content, phase: TransitionPhase) -> some View { return never() }


    /// Returns the properties this transition type has.
    ///
    /// Defaults to `TransitionProperties()`.
    public static let properties: TransitionProperties = { fatalError() }()

    /// The type of view representing the body.
//    public typealias Body = some View
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyTransition {

    public static func offset(_ offset: CGSize) -> AnyTransition { fatalError() }

    public static func offset(x: CGFloat = 0, y: CGFloat = 0) -> AnyTransition { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyTransition {

    /// Returns a transition that scales the view.
    public static var scale: AnyTransition { get { fatalError() } }

    /// Returns a transition that scales the view by the specified amount.
    public static func scale(scale: CGFloat, anchor: UnitPoint = .center) -> AnyTransition { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyTransition {

    /// A transition from transparent to opaque on insertion, and from opaque to
    /// transparent on removal.
    public static let opacity: AnyTransition = { fatalError() }()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyTransition {

    /// A transition that inserts by moving in from the leading edge, and
    /// removes by moving out towards the trailing edge.
    ///
    /// - SeeAlso: `AnyTransition.move(edge:)`
    public static var slide: AnyTransition { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyTransition {

    /// Combines this transition with another, returning a new transition that
    /// is the result of both transitions being applied.
    public func combined(with other: AnyTransition) -> AnyTransition { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyTransition {

    /// Returns a transition defined between an active modifier and an identity
    /// modifier.
    public static func modifier<E>(active: E, identity: E) -> AnyTransition where E : ViewModifier { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyTransition {

    /// Attaches an animation to this transition.
    public func animation(_ animation: Animation?) -> AnyTransition { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyTransition {

    /// A transition that returns the input view, unmodified, as the output
    /// view.
    public static let identity: AnyTransition = { fatalError() }()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyTransition {

    /// Returns a transition that moves the view away, towards the specified
    /// edge of the view.
    public static func move(edge: Edge) -> AnyTransition { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension AnyTransition {

    /// Creates a transition that when added to a view will animate the
    /// view's insertion by moving it in from the specified edge while
    /// fading it in, and animate its removal by moving it out towards
    /// the opposite edge and fading it out.
    ///
    /// - Parameters:
    ///   - edge: the edge from which the view will be animated in.
    ///
    /// - Returns: A transition that animates a view by moving and
    ///   fading it.
    public static func push(from edge: Edge) -> AnyTransition { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyTransition {

    /// Provides a composite transition that uses a different transition for
    /// insertion versus removal.
    public static func asymmetric(insertion: AnyTransition, removal: AnyTransition) -> AnyTransition { fatalError() }
}


@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transition where Self == OffsetTransition {

    /// Returns a transition that offset the view by the specified amount.
    public static func offset(_ offset: CGSize) -> Self { fatalError() }

    /// Returns a transition that offset the view by the specified x and y
    /// values.
    public static func offset(x: CGFloat = 0, y: CGFloat = 0) -> Self { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transition where Self == ScaleTransition {

    /// Returns a transition that scales the view.
    public static var scale: ScaleTransition { get { fatalError() } }

    /// Returns a transition that scales the view by the specified amount.
    public static func scale(_ scale: Double, anchor: UnitPoint = .center) -> Self { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transition where Self == OpacityTransition {

    /// A transition from transparent to opaque on insertion, and from opaque to
    /// transparent on removal.
    public static var opacity: OpacityTransition { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transition where Self == SlideTransition {

    /// A transition that inserts by moving in from the leading edge, and
    /// removes by moving out towards the trailing edge.
    ///
    /// - SeeAlso: `AnyTransition.move(edge:)`
    public static var slide: SlideTransition { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transition {

//    public func combined<T>(with other: T) -> some Transition where T : Transition { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transition {

    /// Attaches an animation to this transition.
//    public func animation(_ animation: Animation?) -> some Transition { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transition {

    /// Returns the properties this transition type has.
    ///
    /// Defaults to `TransitionProperties()`.
    public static var properties: TransitionProperties { get { fatalError() } }

    public func apply<V>(content: V, phase: TransitionPhase) -> some View where V : View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transition where Self == IdentityTransition {

    /// A transition that returns the input view, unmodified, as the output
    /// view.
    public static var identity: IdentityTransition { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transition where Self == MoveTransition {

    /// Returns a transition that moves the view away, towards the specified
    /// edge of the view.
    public static func move(edge: Edge) -> Self { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transition where Self == PushTransition {

    /// Creates a transition that when added to a view will animate the
    /// view's insertion by moving it in from the specified edge while
    /// fading it in, and animate its removal by moving it out towards
    /// the opposite edge and fading it out.
    ///
    /// - Parameters:
    ///   - edge: the edge from which the view will be animated in.
    ///
    /// - Returns: A transition that animates a view by moving and
    ///   fading it.
    public static func push(from edge: Edge) -> Self { fatalError() }
}

#endif
