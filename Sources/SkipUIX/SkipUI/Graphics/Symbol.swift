// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

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
    public func symbolEffect<T>(_ effect: T, options: SymbolEffectOptions = .default, isActive: Bool = true) -> some View where T : IndefiniteSymbolEffect, T : SymbolEffect { return stubView() }


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
    public func symbolEffect<T, U>(_ effect: T, options: SymbolEffectOptions = .default, value: U) -> some View where T : DiscreteSymbolEffect, T : SymbolEffect, U : Equatable { return stubView() }

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


/// A symbol rendering mode.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SymbolRenderingMode : Sendable {

    /// A mode that renders symbols as a single layer filled with the
    /// foreground style.
    ///
    /// For example, you can render a filled exclamation mark triangle in
    /// purple:
    ///
    ///     Image(systemName: "exclamationmark.triangle.fill")
    ///         .symbolRenderingMode(.monochrome)
    ///         .foregroundStyle(Color.purple)
    public static let monochrome: SymbolRenderingMode = { fatalError() }()

    /// A mode that renders symbols as multiple layers with their inherit
    /// styles.
    ///
    /// The layers may be filled with their own inherent styles, or the
    /// foreground style. For example, you can render a filled exclamation
    /// mark triangle in its inherent colors, with yellow for the triangle and
    /// white for the exclamation mark:
    ///
    ///     Image(systemName: "exclamationmark.triangle.fill")
    ///         .symbolRenderingMode(.multicolor)
    public static let multicolor: SymbolRenderingMode = { fatalError() }()

    /// A mode that renders symbols as multiple layers, with different opacities
    /// applied to the foreground style.
    ///
    /// SkipUI fills the first layer with the foreground style, and the others
    /// the secondary, and tertiary variants of the foreground style. You can
    /// specify these styles explicitly using the ``View/foregroundStyle(_:_:)``
    /// and ``View/foregroundStyle(_:_:_:)`` modifiers. If you only specify
    /// a primary foreground style, SkipUI automatically derives
    /// the others from that style. For example, you can render a filled
    /// exclamation mark triangle with purple as the tint color for the
    /// exclamation mark, and lower opacity purple for the triangle:
    ///
    ///     Image(systemName: "exclamationmark.triangle.fill")
    ///         .symbolRenderingMode(.hierarchical)
    ///         .foregroundStyle(Color.purple)
    public static let hierarchical: SymbolRenderingMode = { fatalError() }()

    /// A mode that renders symbols as multiple layers, with different styles
    /// applied to the layers.
    ///
    /// In this mode SkipUI maps each successively defined layer in the image
    /// to the next of the primary, secondary, and tertiary variants of the
    /// foreground style. You can specify these styles explicitly using the
    /// ``View/foregroundStyle(_:_:)`` and ``View/foregroundStyle(_:_:_:)``
    /// modifiers. If you only specify a primary foreground style, SkipUI
    /// automatically derives the others from that style. For example, you can
    /// render a filled exclamation mark triangle with yellow as the tint color
    /// for the exclamation mark, and fill the triangle with cyan:
    ///
    ///     Image(systemName: "exclamationmark.triangle.fill")
    ///         .symbolRenderingMode(.palette)
    ///         .foregroundStyle(Color.yellow, Color.cyan)
    ///
    /// You can also omit the symbol rendering mode, as specifying multiple
    /// foreground styles implies switching to palette rendering mode:
    ///
    ///     Image(systemName: "exclamationmark.triangle.fill")
    ///         .foregroundStyle(Color.yellow, Color.cyan)
    public static let palette: SymbolRenderingMode = { fatalError() }()
}

/// A variant of a symbol.
///
/// Many of the symbols
/// that you can add to your app using an ``Image`` or a ``Label`` instance
/// have common variants, like a filled version or a version that's
/// contained within a circle. The symbol's name indicates the variant:
///
///     VStack(alignment: .leading) {
///         Label("Default", systemImage: "heart")
///         Label("Fill", systemImage: "heart.fill")
///         Label("Circle", systemImage: "heart.circle")
///         Label("Circle Fill", systemImage: "heart.circle.fill")
///     }
///
/// ![A screenshot showing an outlined heart, a filled heart, a heart in
/// a circle, and a filled heart in a circle, each with a text label
/// describing the symbol.](SymbolVariants-1)
///
/// You can configure a part of your view hierarchy to use a particular variant
/// for all symbols in that view and its child views using `SymbolVariants`.
/// Add the ``View/symbolVariant(_:)`` modifier to a view to set a variant
/// for that view's environment. For example, you can use the modifier to
/// create the same set of labels as in the example above, using only the
/// base name of the symbol in the label declarations:
///
///     VStack(alignment: .leading) {
///         Label("Default", systemImage: "heart")
///         Label("Fill", systemImage: "heart")
///             .symbolVariant(.fill)
///         Label("Circle", systemImage: "heart")
///             .symbolVariant(.circle)
///         Label("Circle Fill", systemImage: "heart")
///             .symbolVariant(.circle.fill)
///     }
///
/// Alternatively, you can set the variant in the environment directly by
/// passing the ``EnvironmentValues/symbolVariants`` environment value to the
/// ``View/environment(_:_:)`` modifier:
///
///     Label("Fill", systemImage: "heart")
///         .environment(\.symbolVariants, .fill)
///
/// SkipUI sets a variant for you in some environments. For example, SkipUI
/// automatically applies the ``SymbolVariants/fill-swift.type.property``
/// symbol variant for items that appear in the `content` closure of the
/// ``View/swipeActions(edge:allowsFullSwipe:content:)``
/// method, or as the tab bar items of a ``TabView``.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SymbolVariants : Hashable, Sendable {

    /// No variant for a symbol.
    ///
    /// Using this variant with the ``View/symbolVariant(_:)`` modifier doesn't
    /// have any effect. Instead, to show a symbol that ignores the current
    /// variant, directly set the ``EnvironmentValues/symbolVariants``
    /// environment value to `none` using the ``View/environment(_:_:)``
    /// modifer:
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
    public static let none: SymbolVariants = { fatalError() }()

    /// A variant that encapsulates the symbol in a circle.
    ///
    /// Use this variant with a call to the ``View/symbolVariant(_:)`` modifier
    /// to draw symbols in a circle, for those symbols that have a circle
    /// variant:
    ///
    ///     VStack(spacing: 20) {
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         .symbolVariant(.circle)
    ///     }
    ///
    /// ![A screenshot showing two rows of four symbols each. Both rows contain
    /// a flag, a heart, a bolt, and a star. The symbols in the second row are
    /// versions of the symbols in the first row, but each is enclosed in a
    /// circle.](SymbolVariants-circle-1)
    public static let circle: SymbolVariants = { fatalError() }()

    /// A variant that encapsulates the symbol in a square.
    ///
    /// Use this variant with a call to the ``View/symbolVariant(_:)`` modifier
    /// to draw symbols in a square, for those symbols that have a square
    /// variant:
    ///
    ///     VStack(spacing: 20) {
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         .symbolVariant(.square)
    ///     }
    ///
    /// ![A screenshot showing two rows of four symbols each. Both rows contain
    /// a flag, a heart, a bolt, and a star. The symbols in the second row are
    /// versions of the symbols in the first row, but each is enclosed in a
    /// square.](SymbolVariants-square-1)
    public static let square: SymbolVariants = { fatalError() }()

    /// A variant that encapsulates the symbol in a rectangle.
    ///
    /// Use this variant with a call to the ``View/symbolVariant(_:)`` modifier
    /// to draw symbols in a rectangle, for those symbols that have a rectangle
    /// variant:
    ///
    ///     VStack(spacing: 20) {
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "plus")
    ///             Image(systemName: "minus")
    ///             Image(systemName: "xmark")
    ///             Image(systemName: "checkmark")
    ///         }
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "plus")
    ///             Image(systemName: "minus")
    ///             Image(systemName: "xmark")
    ///             Image(systemName: "checkmark")
    ///         }
    ///         .symbolVariant(.rectangle)
    ///     }
    ///
    /// ![A screenshot showing two rows of four symbols each. Both rows contain
    /// a plus sign, a minus sign, a multiplication sign, and a check mark.
    /// The symbols in the second row are versions of the symbols in the first
    /// row, but each is enclosed in a rectangle.](SymbolVariants-rectangle-1)
    public static let rectangle: SymbolVariants = { fatalError() }()

    /// A version of the variant that's encapsulated in a circle.
    ///
    /// Use this property to modify a variant like ``fill-swift.property``
    /// so that it's also contained in a circle:
    ///
    ///     Label("Fill Circle", systemImage: "bolt")
    ///         .symbolVariant(.fill.circle)
    ///
    /// ![A screenshot of a label that shows a bolt in a filled circle
    /// beside the words Fill Circle.](SymbolVariants-circle-2)
    public var circle: SymbolVariants { get { fatalError() } }

    /// A version of the variant that's encapsulated in a square.
    ///
    /// Use this property to modify a variant like ``fill-swift.property``
    /// so that it's also contained in a square:
    ///
    ///     Label("Fill Square", systemImage: "star")
    ///         .symbolVariant(.fill.square)
    ///
    /// ![A screenshot of a label that shows a star in a filled square
    /// beside the words Fill Square.](SymbolVariants-square-2)
    public var square: SymbolVariants { get { fatalError() } }

    /// A version of the variant that's encapsulated in a rectangle.
    ///
    /// Use this property to modify a variant like ``fill-swift.property``
    /// so that it's also contained in a rectangle:
    ///
    ///     Label("Fill Rectangle", systemImage: "plus")
    ///         .symbolVariant(.fill.rectangle)
    ///
    /// ![A screenshot of a label that shows a plus sign in a filled rectangle
    /// beside the words Fill Rectangle.](SymbolVariants-rectangle-2)
    public var rectangle: SymbolVariants { get { fatalError() } }

    /// A variant that fills the symbol.
    ///
    /// Use this variant with a call to the ``View/symbolVariant(_:)`` modifier
    /// to draw filled symbols, for those symbols that have a filled variant:
    ///
    ///     VStack(spacing: 20) {
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         .symbolVariant(.fill)
    ///     }
    ///
    /// ![A screenshot showing two rows of four symbols each. Both rows contain
    /// a flag, a heart, a bolt, and a star. The symbols in the second row are
    /// filled version of the symbols in the first row.](SymbolVariants-fill-1)
    public static let fill: SymbolVariants = { fatalError() }()

    /// A filled version of the variant.
    ///
    /// Use this property to modify a shape variant like
    /// ``circle-swift.type.property`` so that it's also filled:
    ///
    ///     Label("Circle Fill", systemImage: "flag")
    ///         .symbolVariant(.circle.fill)
    ///
    /// ![A screenshot of a label that shows a flag in a filled circle
    /// beside the words Circle Fill.](SymbolVariants-fill-2)
    public var fill: SymbolVariants { get { fatalError() } }

    /// A variant that draws a slash through the symbol.
    ///
    /// Use this variant with a call to the ``View/symbolVariant(_:)`` modifier
    /// to draw symbols with a slash, for those symbols that have such a
    /// variant:
    ///
    ///     VStack(spacing: 20) {
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         .symbolVariant(.slash)
    ///     }
    ///
    /// ![A screenshot showing two rows of four symbols each. Both rows contain
    /// a flag, a heart, a bolt, and a star. A slash is superimposed over
    /// all the symbols in the second row.](SymbolVariants-slash-1)
    public static let slash: SymbolVariants = { fatalError() }()

    /// A slashed version of the variant.
    ///
    /// Use this property to modify a shape variant like
    /// ``circle-swift.type.property`` so that it's also covered by a slash:
    ///
    ///     Label("Circle Slash", systemImage: "flag")
    ///         .symbolVariant(.circle.slash)
    ///
    /// ![A screenshot of a label that shows a flag in a circle with a
    /// slash over it beside the words Circle Slash.](SymbolVariants-slash-2)
    public var slash: SymbolVariants { get { fatalError() } }

    /// Returns a Boolean value that indicates whether the current variant
    /// contains the specified variant.
    ///
    /// - Parameter other: A variant to look for in this variant.
    /// - Returns: `true` if this variant contains `other`; otherwise,
    ///   `false`.
    public func contains(_ other: SymbolVariants) -> Bool { fatalError() }


    

}

#endif
