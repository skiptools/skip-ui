// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

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

    public func symbolVariant(_ variant: SymbolVariants) -> any View {
        #if SKIP
        return environment(\._symbolVariants, variant, affectsEvaluate: false)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func symbolVariant(bridgedRawValue: Int) -> any View {
        return symbolVariant(SymbolVariants(rawValue: bridgedRawValue))
    }

    @available(*, unavailable)
    public func symbolVariableValueMode(_ mode: SymbolVariableValueMode?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func symbolColorRenderingMode(_ mode: SymbolColorRenderingMode?) -> some View {
        return self
    }
}

extension Image {
    @available(*, unavailable)
    public func symbolRenderingMode(_ mode: SymbolRenderingMode?) -> Image {
        return self
    }

    @available(*, unavailable)
    public func symbolVariableValueMode(_ mode: SymbolVariableValueMode?) -> Image {
        fatalError()
    }

    @available(*, unavailable)
    public func symbolColorRenderingMode(_ mode: SymbolColorRenderingMode?) -> Image {
        fatalError()
    }
}

public enum SymbolRenderingMode : Int, Sendable {
    case monochrome = 0
    case multicolor = 1
    case hierarchical = 2
    case palette = 3
}

/// Symbol variants that can be applied to SF Symbols.
/// Uses a bit flag internally to combine variants.
public struct SymbolVariants : RawRepresentable, Hashable, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    // Bit flags for each variant type
    private static let fillBit = 1 << 0      // 1
    private static let circleBit = 1 << 1    // 2
    private static let squareBit = 1 << 2    // 4
    private static let rectangleBit = 1 << 3 // 8
    private static let slashBit = 1 << 4     // 16

    public static let none = SymbolVariants(rawValue: 0)
    public static let fill = SymbolVariants(rawValue: fillBit)
    public static let circle = SymbolVariants(rawValue: circleBit)
    public static let square = SymbolVariants(rawValue: squareBit)
    public static let rectangle = SymbolVariants(rawValue: rectangleBit)
    public static let slash = SymbolVariants(rawValue: slashBit)

    /// Combine with fill variant
    public var fill: SymbolVariants {
        return SymbolVariants(rawValue: rawValue | Self.fillBit)
    }

    /// Combine with circle variant
    public var circle: SymbolVariants {
        return SymbolVariants(rawValue: rawValue | Self.circleBit)
    }

    /// Combine with square variant
    public var square: SymbolVariants {
        return SymbolVariants(rawValue: rawValue | Self.squareBit)
    }

    /// Combine with rectangle variant
    public var rectangle: SymbolVariants {
        return SymbolVariants(rawValue: rawValue | Self.rectangleBit)
    }

    /// Combine with slash variant
    public var slash: SymbolVariants {
        return SymbolVariants(rawValue: rawValue | Self.slashBit)
    }

    /// Check if this variant contains another variant
    public func contains(_ other: SymbolVariants) -> Bool {
        return (rawValue & other.rawValue) == other.rawValue
    }

    /// Apply the symbol variants to a symbol name, returning the modified name.
    public func applied(to symbolName: String) -> String {
        var name = symbolName

        // Apply shape variants first (circle, square, rectangle)
        if contains(.circle) && !name.contains(".circle") {
            name = name + ".circle"
        } else if contains(.square) && !name.contains(".square") {
            name = name + ".square"
        } else if contains(.rectangle) && !name.contains(".rectangle") {
            name = name + ".rectangle"
        }

        // Apply fill variant
        if contains(.fill) && !name.contains(".fill") {
            name = name + ".fill"
        }

        // Apply slash variant
        if contains(.slash) && !name.contains(".slash") {
            name = name + ".slash"
        }

        return name
    }
}

public struct SymbolVariableValueMode : Equatable, Sendable {
    public static let color = SymbolVariableValueMode()
    public static let draw = SymbolVariableValueMode()
}

public struct SymbolColorRenderingMode : Equatable, Sendable {
    public static let flat = SymbolColorRenderingMode()
    public static let gradient = SymbolColorRenderingMode()
}

/*
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
*/
#endif
