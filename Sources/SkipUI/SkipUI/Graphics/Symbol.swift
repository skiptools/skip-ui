// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

extension View {
    @available(*, unavailable)
    public func symbolEffect(_ effect: Any, options: Any? = nil /* SymbolEffectOptions = .default */, isActive: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func symbolEffect(_ effect: Any, options: Any? = nil /* SymbolEffectOptions = .default */, value: Any) -> some View {
        return self
    }

    @available(*, unavailable)
    public func symbolRenderingMode(_ mode: SymbolRenderingMode?) -> some View {
        return self
    }
    
    @available(*, unavailable)
    public func symbolVariant(_ variant: SymbolVariants) -> some View {
        return self
    }
}

@available(iOS 16.0, macOS 14.0, *)
extension Image {
    @available(*, unavailable)
    public func symbolRenderingMode(_ mode: SymbolRenderingMode?) -> Image {
        return self
    }
}

public enum SymbolRenderingMode {
    case monochrome, multicolor, hierarchical, palette
}

public struct SymbolVariants : Hashable, Sendable {
    public static let none = SymbolVariants()
    public static let circle = SymbolVariants()
    public static let square = SymbolVariants()
    public static let rectangle = SymbolVariants()

    public var circle: SymbolVariants {
        return self
    }
    public var square: SymbolVariants {
        return self
    }
    public var rectangle: SymbolVariants {
        return self
    }

    public static let fill = SymbolVariants()

    public var fill: SymbolVariants {
        return self
    }

    public static let slash = SymbolVariants()

    public var slash: SymbolVariants {
        return self
    }

    public func contains(_ other: SymbolVariants) -> Bool {
        fatalError()
    }
}




#if canImport(Symbols)
#if !os(macOS)
#if false

// TODO: Process for use in SkipUI

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
    public func body(content: SymbolEffectTransition.Content, phase: TransitionPhase) -> some View { return stubView() }


    /// Returns the properties this transition type has.
    ///
    /// Defaults to `TransitionProperties()`.
    public static let properties: TransitionProperties = { fatalError() }()

    /// The type of view representing the body.
//    public typealias Body = some View
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

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension EnvironmentValues {

    /// The current symbol rendering mode, or `nil` denoting that the
    /// mode is picked automatically using the current image and
    /// foreground style as parameters.
    public var symbolRenderingMode: SymbolRenderingMode? { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension EnvironmentValues {

    /// The symbol variant to use in this environment.
    ///
    /// You set this environment value indirectly by using the
    /// ``View/symbolVariant(_:)`` view modifier. However, you access the
    /// environment variable directly using the ``View/environment(_:_:)``
    /// modifier. Do this when you want to use the ``SymbolVariants/none``
    /// variant to ignore the value that's already in the environment:
    ///
    ///     HStack {
    ///         Image(systemName: "heart")
    ///         Image(systemName: "heart")
    ///             .environment(\.symbolVariants, .none)
    ///     }
    ///     .symbolVariant(.fill)
    ///
    /// ![A screenshot of two heart symbols. The first is filled while the
    /// second is outlined.](SymbolVariants-none-1)
    public var symbolVariants: SymbolVariants { get { fatalError() } }
}

#endif
#endif
#endif

