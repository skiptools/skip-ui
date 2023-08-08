// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// A built-in set of commands for manipulating window toolbars.
///
/// These commands are optional and can be explicitly requested by passing a
/// value of this type to the ``Scene/commands(content:)`` modifier.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct ToolbarCommands : Commands {

    /// A new value describing the built-in toolbar-related commands.
    public init() { fatalError() }

    /// The contents of the command hierarchy.
    ///
    /// For any commands that you create, provide a computed `body` property
    /// that defines the scene as a composition of other scenes. You can
    /// assemble a command hierarchy from built-in commands that SkipUI
    /// provides, as well as other commands that you've defined.
    public var body: Body { get { return never() } }

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    public typealias Body = Never
}

/// Conforming types represent items that can be placed in various locations
/// in a toolbar.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol ToolbarContent {

    /// The type of content representing the body of this toolbar content.
    associatedtype Body : ToolbarContent

    /// The composition of content that comprise the toolbar content.
    @ToolbarContentBuilder var body: Self.Body { get }
}

/// Constructs a toolbar item set from multi-expression closures.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@resultBuilder public struct ToolbarContentBuilder {

    /// Builds an expression within the builder.
    public static func buildExpression<Content>(_ content: Content) -> Content where Content : ToolbarContent { fatalError() }

    public static func buildBlock<Content>(_ content: Content) -> some ToolbarContent where Content : ToolbarContent { return never() }


    /// Builds an expression within the builder.
    public static func buildExpression<Content>(_ content: Content) -> Content where Content : CustomizableToolbarContent { fatalError() }

    public static func buildBlock<Content>(_ content: Content) -> some CustomizableToolbarContent where Content : CustomizableToolbarContent { return never() }

}

extension ToolbarContentBuilder {

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public static func buildIf<Content>(_ content: Content?) -> Content? where Content : ToolbarContent { fatalError() }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public static func buildIf<Content>(_ content: Content?) -> Content? where Content : CustomizableToolbarContent { fatalError() }

//    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//    public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent : ToolbarContent, FalseContent : ToolbarContent { return never() }
//
//    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//    public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent : CustomizableToolbarContent, FalseContent : CustomizableToolbarContent { return never() }
//
//    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//    public static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent : ToolbarContent, FalseContent : ToolbarContent { return never() }
//
//    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//    public static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent : CustomizableToolbarContent, FalseContent : CustomizableToolbarContent { return never() }

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func buildLimitedAvailability<Content>(_ content: Content) -> some ToolbarContent where Content : ToolbarContent { return never() }


    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func buildLimitedAvailability<Content>(_ content: Content) -> some CustomizableToolbarContent where Content : CustomizableToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> some ToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> some ToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> some ToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> some ToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> some ToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> some ToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> some ToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> some ToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> some ToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> some CustomizableToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> some CustomizableToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> some CustomizableToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> some CustomizableToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> some CustomizableToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> some CustomizableToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> some CustomizableToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> some CustomizableToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> some CustomizableToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent { return never() }

}

/// The customization behavior of customizable toolbar content.
///
/// Customizable toolbar content support different types of customization
/// behaviors. For example, some customizable content may not be removed by
/// the user. Some content may be placed in a toolbar that supports
/// customization overall, but not for that particular content.
///
/// Use this type in conjunction with the
/// ``CustomizableToolbarContent/customizationBehavior(_:)`` modifier.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ToolbarCustomizationBehavior : Sendable {

    /// The default customization behavior.
    ///
    /// Items with this behavior start in the toolbar and can be
    /// moved or removed from the toolbar by the user.
    public static var `default`: ToolbarCustomizationBehavior { get { fatalError() } }

    /// The reorderable customization behavior.
    ///
    /// Items with this behavior start in the toolbar and can be moved within
    /// the toolbar by the user, but can not be removed from the toolbar.
    public static var reorderable: ToolbarCustomizationBehavior { get { fatalError() } }

    /// The disabled customization behavior.
    ///
    /// Items with this behavior may not be removed or moved by the user.
    /// They will be placed before other customizatable items. Use this
    /// behavior for the most important items that users need for the app
    /// to do common functionality.
    public static var disabled: ToolbarCustomizationBehavior { get { fatalError() } }
}

/// Options that influence the default customization behavior of
/// customizable toolbar content.
///
/// Use this type in conjunction with the
/// ``CustomizableToolbarContent/defaultCustomization(_:options)`` modifier.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ToolbarCustomizationOptions : OptionSet, Sendable {

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int

    /// Configures default customizable toolbar content to always be
    /// present in the toolbar.
    ///
    /// In iOS, default customizable toolbar content have the option of always
    /// being available in the toolbar regardless of the customization status
    /// of the user. These items will always be in the overflow menu of the
    /// toolbar. Users can customize whether the items are present as controls
    /// in the toolbar itself but will still always be able to access the item
    /// if they remove it from the toolbar itself.
    ///
    /// Consider using this for items that users should always be able to
    /// access, but may not be important enough to always occupy space in
    /// the toolbar itself.
    public static var alwaysAvailable: ToolbarCustomizationOptions { get { fatalError() } }

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: Int { get { fatalError() } }

    /// Creates a new option set from the given raw value.
    ///
    /// This initializer always succeeds, even if the value passed as `rawValue`
    /// exceeds the static properties declared as part of the option set. This
    /// example creates an instance of `ShippingOptions` with a raw value beyond
    /// the highest element, with a bit mask that effectively contains all the
    /// declared static members.
    ///
    ///     let extraOptions = ShippingOptions(rawValue: 255)
    ///     print(extraOptions.isStrictSuperset(of: .all))
    ///     // Prints "true"
    ///
    /// - Parameter rawValue: The raw value of the option set to create. Each bit
    ///   of `rawValue` potentially represents an element of the option set,
    ///   though raw values may include bits that are not defined as distinct
    ///   values of the `OptionSet` type.
    public init(rawValue: Int) { fatalError() }

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = ToolbarCustomizationOptions

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = ToolbarCustomizationOptions
}

/// A model that represents an item which can be placed in the toolbar
/// or navigation bar.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ToolbarItem<ID, Content> : ToolbarContent where Content : View {

    /// The type of content representing the body of this toolbar content.
    public typealias Body = Never
    public var body: Body { return never() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarItem where ID == () {

    /// Creates a toolbar item with the specified placement and content.
    ///
    /// - Parameters:
    ///   - placement: Which section of the toolbar
    ///     the item should be placed in.
    ///   - content: The content of the item.
    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarItem : CustomizableToolbarContent where ID == String {

    /// Creates a toolbar item with the specified placement and content,
    /// which allows for user customization.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this item.
    ///   - placement: Which section of the toolbar
    ///     the item should be placed in.
    ///   - content: The content of the item.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public init(id: String, placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a toolbar item with the specified placement and content,
    /// which allows for user customization.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this item.
    ///   - placement: Which section of the toolbar
    ///     the item should be placed in.
    ///   - showsByDefault: Whether the item appears by default in the toolbar,
    ///     or only shows if the user explicitly adds it via customization.
    ///   - content: The content of the item.
    @available(iOS, introduced: 14.0, deprecated: 100000.0, message: "Use the CustomizableToolbarContent/defaultCustomization(_:options) modifier with a value of .hidden")
    @available(macOS, introduced: 11.0, deprecated: 100000.0, message: "Use the CustomizableToolbarContent/defaultCustomization(_:options) modifier with a value of .hidden")
    @available(tvOS, introduced: 14.0, deprecated: 100000.0, message: "Use the CustomizableToolbarContent/defaultCustomization(_:options) modifier with a value of .hidden")
    @available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "Use the CustomizableToolbarContent/defaultCustomization(_:options) modifier with a value of .hidden")
    public init(id: String, placement: ToolbarItemPlacement = .automatic, showsByDefault: Bool, @ViewBuilder content: () -> Content) { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ToolbarItem : Identifiable where ID : Hashable {

    /// The stable identity of the entity associated with this instance.
    public var id: ID { get { fatalError() } }
}

/// A model that represents a group of `ToolbarItem`s which can be placed in
/// the toolbar or navigation bar.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ToolbarItemGroup<Content> : ToolbarContent where Content : View {

    /// Creates a toolbar item group with a specified placement and content.
    ///
    /// - Parameters:
    ///  - placement: Which section of the toolbar all of its vended
    ///    `ToolbarItem`s should be placed in.
    ///  - content: The content of the group. Each view specified in the
    ///    `ViewBuilder` will be given its own `ToolbarItem` in the toolbar.
    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) { fatalError() }

    /// The type of content representing the body of this toolbar content.
    public typealias Body = Never
    public var body: Body { return never() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ToolbarItemGroup {

    /// Creates a toolbar item group with the specified placement, content,
    /// and a label describing that content.
    ///
    /// A toolbar item group provided a label wraps its content within a
    /// ``ControlGroup`` which allows the content to collapse down into a
    /// menu that presents its content based on available space.
    ///
    /// - Parameters:
    ///   - placement: Which section of the toolbar
    ///     the item should be placed in.
    ///   - content: The content of the item.
    ///   - label: The label describing the content of the item.
    public init<C, L>(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> C, @ViewBuilder label: () -> L) where Content == LabeledToolbarItemGroupContent<C, L>, C : View, L : View { fatalError() }
}

/// A structure that defines the placement of a toolbar item.
///
/// There are two types of placements:
/// - Semantic placements, such as ``ToolbarItemPlacement/principal`` and
///   ``ToolbarItemPlacement/navigation``, denote the intent of the
///   item being added. SkipUI determines the appropriate placement for
///   the item based on this intent and its surrounding context, like the
///   current platform.
/// - Positional placements, such as
///   ``ToolbarItemPlacement/navigationBarLeading``, denote a precise
///   placement for the item, usually for a particular platform.
///
/// In iOS, iPadOS, and macOS, the system uses the space available to the
/// toolbar when determining how many items to render in the toolbar. If not
/// all items fit in the available space, an overflow menu may be created
/// and remaining items placed in that menu.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ToolbarItemPlacement {

    /// The system places the item automatically, depending on many factors
    /// including the platform, size class, or presence of other items.
    ///
    /// In macOS and in Mac Catalyst apps, the system places items in the
    /// current toolbar section in order of leading to trailing. On watchOS,
    /// only the first item appears, pinned beneath the navigation bar.
    ///
    /// In iPadOS, the system places items in the center of the navigation bar
    /// if the navigation bar supports customization. Otherwise, it places
    /// items in the trailing position of the navigation bar.
    ///
    /// In iOS, and tvOS, the system places items in the trailing
    /// position of the navigation bar.
    ///
    /// In iOS, iPadOS, and macOS, the system uses the space available to the
    /// toolbar when determining how many items to render in the toolbar. If not
    /// all items fit in the available space, an overflow menu may be created
    /// and remaining items placed in that menu.
    public static let automatic: ToolbarItemPlacement = { fatalError() }()

    /// The system places the item in the principal item section.
    ///
    /// Principal actions are key units of functionality that receive prominent
    /// placement. For example, the location field for a web browser is a
    /// principal item.
    ///
    /// In macOS and in Mac Catalyst apps, the system places the principal item
    /// in the center of the toolbar.
    ///
    /// In iOS, iPadOS, and tvOS, the system places the principal item in the
    /// center of the navigation bar. This item takes precedent over a title
    /// specified through ``View/navigationTitle``.
    @available(watchOS, unavailable)
    public static let principal: ToolbarItemPlacement = { fatalError() }()

    /// The item represents a navigation action.
    ///
    /// Navigation actions allow the user to move between contexts.
    /// For example, the forward and back buttons of a web browser
    /// are navigation actions.
    ///
    /// In macOS and in Mac Catalyst apps, the system places navigation items
    /// in the leading edge of the toolbar ahead of the inline title if that is
    /// present in the toolbar.
    ///
    /// In iOS, iPadOS, and tvOS, navigation items appear in the leading
    /// edge of the navigation bar. If a system navigation item such as a back
    /// button is present in a compact width, it instead appears in
    /// the ``ToolbarItemPlacement/primaryAction`` placement.
    @available(watchOS, unavailable)
    public static let navigation: ToolbarItemPlacement = { fatalError() }()

    /// The item represents a primary action.
    ///
    /// A primary action is a more frequently used action for the current
    /// context. For example, a button the user clicks or taps to compose a new
    /// message in a chat app.
    ///
    /// In macOS and in Mac Catalyst apps, the location for the primary action
    /// is the leading edge of the toolbar.
    ///
    /// In iOS, iPadOS, and tvOS, the location for the primary action is
    /// the trailing edge of the navigation bar.
    ///
    /// In watchOS the system places the primary action beneath the
    /// navigation bar; the user reveals the action by scrolling.
    public static let primaryAction: ToolbarItemPlacement = { fatalError() }()

    /// The item represents a secondary action.
    ///
    /// A secondary action is a frequently used action for the current context
    /// but is not a requirement for the current context to function.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let secondaryAction: ToolbarItemPlacement = { fatalError() }()

    /// The item represents a change in status for the current context.
    ///
    /// Status items are informational in nature, and don't represent an
    /// action that can be taken by the user. For example, a message that
    /// indicates the time of the last communication with the server to check
    /// for new messages.
    ///
    /// In macOS and in Mac Catalyst apps, the system places status items in
    /// the center of the toolbar.
    ///
    /// In iOS and iPadOS, the system places status items in the center of the
    /// bottom toolbar.
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let status: ToolbarItemPlacement = { fatalError() }()

    /// The item represents a confirmation action for a modal interface.
    ///
    /// Use confirmation actions to receive user confirmation of a
    /// particular action. An example of a confirmation action would be
    /// an action with the label "Add" to add a new event to the calendar.
    ///
    /// In macOS and in Mac Catalyst apps, the system places
    /// `confirmationAction` items on the trailing edge
    /// in the trailing-most position of the sheet and gain the apps accent
    /// color as a background color.
    ///
    /// In iOS, iPadOS, and tvOS, the system places `confirmationAction` items
    /// in the same location as a ``ToolbarItemPlacement/primaryAction``
    /// placement.
    ///
    /// In watchOS, the system places `confirmationAction` items in the
    /// trailing edge of the navigation bar.
    public static let confirmationAction: ToolbarItemPlacement = { fatalError() }()

    /// The item represents a cancellation action for a modal interface.
    ///
    /// Cancellation actions dismiss the modal interface without taking any
    /// action, usually by tapping or clicking a Cancel button.
    ///
    /// In macOS and in Mac Catalyst apps, the system places
    /// `cancellationAction` items on the trailing edge of the sheet but
    /// places them before any ``confirmationAction`` items.
    ///
    /// In iOS, iPadOS, tvOS, and watchOS, the system places
    /// `cancellationAction` items on the leading edge of the navigation bar.
    public static let cancellationAction: ToolbarItemPlacement = { fatalError() }()

    /// The item represents a destructive action for a modal interface.
    ///
    /// Destructive actions represent the opposite of a confirmation action.
    /// For example, a button labeled "Don't Save" that allows the user to
    /// discard unsaved changes to a document before quitting.
    ///
    /// In macOS and in Mac Catalyst apps, the system places `destructiveAction`
    /// items in the leading edge of the sheet and gives them a special
    /// appearance to caution against accidental use.
    ///
    /// In iOS, tvOS, and watchOS, the system places `destructiveAction` items
    /// in the trailing edge of the navigation bar.
    public static let destructiveAction: ToolbarItemPlacement = { fatalError() }()

    /// The item is placed in the keyboard section.
    ///
    /// On iOS, keyboard items are above the software keyboard when present,
    /// or at the bottom of the screen when a hardware keyboard is attached.
    ///
    /// On macOS, keyboard items will be placed inside the Touch Bar.
    ///
    /// A `FocusedValue`can be used to adjust the content of the keyboard bar
    /// based on the currently focused view. In the example below, the keyboard
    /// bar gains additional buttons only when the appropriate `TextField` is
    /// focused.
    ///
    ///     enum Field {
    ///         case suit
    ///         case rank
    ///     }
    ///
    ///     struct KeyboardBarDemo : View {
    ///         @FocusedValue(\.field) var field: Field?
    ///
    ///         var body: some View {
    ///             HStack {
    ///                 TextField("Suit", text: $suitText)
    ///                     .focusedValue(\.field, .suit)
    ///                 TextField("Rank", text: $rankText)
    ///                     .focusedValue(\.field, .rank)
    ///             }
    ///             .toolbar {
    ///                 ToolbarItemGroup(placement: .keyboard) {
    ///                     if field == .suit {
    ///                         Button("♣️", action: {})
    ///                         Button("♥️", action: {})
    ///                         Button("♠️", action: {})
    ///                         Button("♦️", action: {})
    ///                     }
    ///                     DoneButton()
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    @available(iOS 15.0, macOS 12.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let keyboard: ToolbarItemPlacement = { fatalError() }()

    /// Places the item in the leading edge of the top bar.
    ///
    /// On watchOS, iOS, and tvOS, the top bar is the navigation bar.
    @available(iOS 14.0, tvOS 14.0, watchOS 10.0, *)
    @_backDeploy(before: iOS 17.0, tvOS 17.0)
    @available(macOS, unavailable)
    public static var topBarLeading: ToolbarItemPlacement { get { fatalError() } }

    /// Places the item in the trailing edge of the top bar.
    ///
    /// On watchOS, iOS, and tvOS, the top bar is the navigation bar.
    @available(iOS 14.0, tvOS 14.0, watchOS 10.0, *)
    @_backDeploy(before: iOS 17.0, tvOS 17.0)
    @available(macOS, unavailable)
    public static var topBarTrailing: ToolbarItemPlacement { get { fatalError() } }

    /// Places the item in the leading edge of the navigation bar.
    @available(iOS, introduced: 14.0, deprecated: 100000.0, message: "use topBarLeading instead")
    @available(tvOS, introduced: 14.0, deprecated: 100000.0, message: "use topBarLeading instead")
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "use topBarLeading instead")
    public static let navigationBarLeading: ToolbarItemPlacement = { fatalError() }()

    /// Places the item in the trailing edge of the navigation bar.
    @available(iOS, introduced: 14.0, deprecated: 100000.0, message: "use topBarTrailing instead")
    @available(tvOS, introduced: 14.0, deprecated: 100000.0, message: "use topBarTrailing instead")
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "use topBarTrailing instead")
    public static let navigationBarTrailing: ToolbarItemPlacement = { fatalError() }()

    /// Places the item in the bottom toolbar.
    @available(watchOS 10.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    public static let bottomBar: ToolbarItemPlacement = { fatalError() }()
}

/// The placement of a toolbar.
///
/// Use this type in conjunction with modifiers like
/// ``View/toolbarBackground(_:for:)-5ybst`` and ``View/toolbar(_:for:)`` to
/// customize the appearance of different bars managed by SkipUI. Not all bars
/// support all types of customizations.
///
/// See ``ToolbarItemPlacement`` to learn about the different regions of these
/// toolbars that you can place your own controls into.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ToolbarPlacement {

    /// The primary toolbar.
    ///
    /// Depending on the context, this may refer to the navigation bar of an
    /// app on iOS, or watchOS, the tab bar of an app on tvOS, or the window
    /// toolbar of an app on macOS.
    public static var automatic: ToolbarPlacement { get { fatalError() } }

    /// The bottom toolbar of an app.
    @available(watchOS 10.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    public static var bottomBar: ToolbarPlacement { get { fatalError() } }

    /// The navigation bar of an app.
    @available(macOS, unavailable)
    public static var navigationBar: ToolbarPlacement { get { fatalError() } }

    /// The tab bar of an app.
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public static var tabBar: ToolbarPlacement { get { fatalError() } }
}

/// The purpose of content that populates the toolbar.
///
/// A toolbar role provides a description of the purpose of content that
/// populates the toolbar. The purpose of the content influences how a toolbar
/// renders its content. For example, a ``ToolbarRole/browser`` will
/// automatically leading align the title of a toolbar in iPadOS.
///
/// Provide this type to the ``View/toolbarRole(_:)`` modifier:
///
///     ContentView()
///         .navigationTitle("Browser")
///         .toolbarRole(.browser)
///         .toolbar {
///             ToolbarItem(placement: .primaryAction) {
///                 AddButton()
///             }
///          }
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ToolbarRole : Sendable {

    /// The automatic role.
    ///
    /// In iOS, tvOS, and watchOS this resolves to the
    /// ``ToolbarRole/navigationStack`` role. In macOS, this resolves to the
    /// ``ToolbarRole/editor`` role.
    public static var automatic: ToolbarRole { get { fatalError() } }

    /// The navigationStack role.
    ///
    /// Use this role for content that can be pushed and popped.
    @available(macOS, unavailable)
    public static var navigationStack: ToolbarRole { get { fatalError() } }

    /// The browser role.
    ///
    /// Use this role for content that can be navigated forwards
    /// and backwards. In iPadOS, this will leading align the navigation title
    /// and allow for toolbar items to occupy the center of the navigation bar.
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var browser: ToolbarRole { get { fatalError() } }

    /// The editor role.
    ///
    /// Use this role for a toolbar that primarily displays controls
    /// geared towards editing document-like content. In iPadOS, this will
    /// leading align the navigation title, allow for toolbar items to occupy
    /// the center of the navigation bar, and provide a custom appearance
    /// for any back button present in the toolbar.
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var editor: ToolbarRole { get { fatalError() } }
}

/// A type that defines the behavior of title of a toolbar.
///
/// Use values of this type in conjunction with the
/// ``View/toolbarTitleDisplayMode(_:)-45ijr`` modifier to configure
/// the title display behavior of your toolbar.
///
///     NavigationStack {
///         ContentView()
///             .toolbarTitleDisplayMode(.inlineLarge)
///     }
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ToolbarTitleDisplayMode {

    /// The automatic mode.
    ///
    /// For root content in a navigation stack in iOS, iPadOS, or tvOS
    /// this behavior will:
    ///   - Default to ``ToolbarTitleDisplayMode/large``
    ///     when a navigation title is configured.
    ///   - Default to ``ToolbarTitleDisplayMode/inline``
    ///     when no navigation title is provided.
    ///
    /// In all platforms, content pushed onto a navigation stack will use the
    /// behavior of the content already on the navigation stack. This
    /// has no effect in macOS.
    public static var automatic: ToolbarTitleDisplayMode { get { fatalError() } }

    /// The large mode.
    ///
    /// In iOS, and watchOS, this displays the toolbar title below the
    /// content of the navigation bar when scrollable content is scrolled
    /// to the top and transitions to the center of the toolbar as
    /// content is scrolled.
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    public static var large: ToolbarTitleDisplayMode { get { fatalError() } }

    /// The inline large mode.
    ///
    /// In iOS, this behavior displays the title as large inside the toolbar
    /// and moves any leading or centered toolbar items into the overflow menu
    /// of the toolbar. This has no effect in macOS.
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var inlineLarge: ToolbarTitleDisplayMode { get { fatalError() } }

    /// The inline mode.
    ///
    /// In iOS, tvOS, and watchOS this mode displays the title with a
    /// smaller size in the middle of the toolbar. This has no effect
    /// in macOS.
    public static var inline: ToolbarTitleDisplayMode { get { fatalError() } }
}

/// The title menu of a toolbar.
///
/// A title menu represents common functionality that can be done on the
/// content represented by your app's toolbar or navigation title. This
/// menu may be populated from your app's commands like
/// ``CommandGroupPlacement/saveItem`` or
/// ``CommandGroupPlacement/printItem``.
///
///     ContentView()
///         .toolbar {
///             ToolbarTitleMenu()
///         }
///
/// You can provide your own set of actions to override this behavior.
///
///     ContentView()
///         .toolbar {
///             ToolbarTitleMenu {
///                 DuplicateButton()
///                 PrintButton()
///             }
///         }
///
/// In iOS and iPadOS, this will construct a menu that can be presented by
/// tapping the navigation title in the app's navigation bar.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
public struct ToolbarTitleMenu<Content> : ToolbarContent, CustomizableToolbarContent where Content : View {

    /// Creates a toolbar title menu where actions are inferred from your
    /// apps commands.
    public init() where Content == EmptyView { fatalError() }

    /// Creates a toolbar title menu.
    ///
    /// - Parameter content: The content of the toolbar title menu.
    public init(@ViewBuilder content: () -> Content) { fatalError() }

    /// The type of content representing the body of this toolbar content.
    public typealias Body = Never

    public var body: Body { return never() }
}
