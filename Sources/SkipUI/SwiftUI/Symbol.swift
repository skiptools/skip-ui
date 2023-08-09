// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import protocol Symbols.SymbolEffect
import struct Symbols.SymbolEffectOptions
import protocol Symbols.TransitionSymbolEffect
import protocol Symbols.ContentTransitionSymbolEffect
import protocol Symbols.IndefiniteSymbolEffect
import protocol Symbols.DiscreteSymbolEffect


@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transition where Self == SymbolEffectTransition {

    /// Creates a transition that applies the provided effect to symbol
    /// images within the inserted or removed view hierarchy. Other
    /// views are unaffected by this transition.
    ///
    /// - Parameter effect: the symbol effect value.
    ///
    /// - Returns: a new transition.
    public static func symbolEffect<T>(_ effect: T, options: SymbolEffectOptions = .default) -> SymbolEffectTransition where T : SymbolEffect, T : TransitionSymbolEffect { fatalError() }

    /// A transition that applies the default symbol effect transition
    /// to symbol images within the inserted or removed view hierarchy.
    /// Other views are unaffected by this transition.
    public static var symbolEffect: SymbolEffectTransition { get { fatalError() } }
}

/// Creates a transition that applies the Appear or Disappear
/// symbol animation to symbol images within the inserted or
/// removed view hierarchy.
///
/// Other views are unaffected by this transition.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@frozen public struct SymbolEffectTransition : Transition {

    public init<T>(effect: T, options: SymbolEffectOptions) where T : SymbolEffect, T : TransitionSymbolEffect { fatalError() }

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: SymbolEffectTransition.Content, phase: TransitionPhase) -> some View { return never() }


    /// Returns the properties this transition type has.
    ///
    /// Defaults to `TransitionProperties()`.
    public static let properties: TransitionProperties = { fatalError() }()

    /// The type of view representing the body.
//    public typealias Body = some View
}



@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Returns a new view with a symbol effect added to it.
    ///
    /// The following example adds a repeating pulse effect to two
    /// symbol images:
    ///
    ///     VStack {
    ///         Image(systemName: "bolt.slash.fill")
    ///         Image(systemName: "folder.fill.badge.person.crop")
    ///     }
    ///     .symbolEffect(.pulse)
    ///
    /// - Parameters:
    ///   - effect: A symbol effect to add to the view. Existing effects
    ///     added by ancestors of the view are preserved, but may be
    ///     overridden by the new effect. Added effects will be applied
    ///     to the ``SkipUI/Image` views contained by the child view.
    ///   - isActive: whether the effect is active or inactive.
    ///
    /// - Returns: a copy of the view with a symbol effect added.
    public func symbolEffect<T>(_ effect: T, options: SymbolEffectOptions = .default, isActive: Bool = true) -> some View where T : IndefiniteSymbolEffect, T : SymbolEffect { return never() }


    /// Returns a new view with a symbol effect added to it.
    ///
    /// The following example adds a bounce effect to two symbol
    /// images, the animation will play each time `counter` changes:
    ///
    ///     VStack {
    ///         Image(systemName: "bolt.slash.fill")
    ///         Image(systemName: "folder.fill.badge.person.crop")
    ///     }
    ///     .symbolEffect(.bounce, value: counter)
    ///
    /// - Parameters:
    ///   - effect: A symbol effect to add to the view. Existing effects
    ///     added by ancestors of the view are preserved, but may be
    ///     overridden by the new effect. Added effects will be applied
    ///     to the ``SkipUI/Image` views contained by the child view.
    ///   - value: the value to monitor for changes, the animation is
    ///     triggered each time the value changes.
    ///
    /// - Returns: a copy of the view with a symbol effect added.
    public func symbolEffect<T, U>(_ effect: T, options: SymbolEffectOptions = .default, value: U) -> some View where T : DiscreteSymbolEffect, T : SymbolEffect, U : Equatable { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ContentTransition {

    /// Creates a content transition that applies the symbol Replace
    /// animation to symbol images that it is applied to.
    ///
    /// - Parameter config: the animation configuration value.
    ///
    /// - Returns: a new content transition.
    public static func symbolEffect<T>(_ effect: T, options: SymbolEffectOptions = .default) -> ContentTransition where T : ContentTransitionSymbolEffect, T : SymbolEffect { fatalError() }

    /// A content transition that applies the default symbol effect
    /// transition to symbol images within the inserted or removed view
    /// hierarchy. Other views are unaffected by this transition.
    public static var symbolEffect: ContentTransition { get { fatalError() } }
}

