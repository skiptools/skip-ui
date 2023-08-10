// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// A control for presenting a menu of actions.
///
/// The following example presents a menu of three buttons and a submenu, which
/// contains three buttons of its own.
///
///     Menu("Actions") {
///         Button("Duplicate", action: duplicate)
///         Button("Rename", action: rename)
///         Button("Delete…", action: delete)
///         Menu("Copy") {
///             Button("Copy", action: copy)
///             Button("Copy Formatted", action: copyFormatted)
///             Button("Copy Library Path", action: copyPath)
///         }
///     }
///
/// You can create the menu's title with a ``LocalizedStringKey``, as seen in
/// the previous example, or with a view builder that creates multiple views,
/// such as an image and a text view:
///
///     Menu {
///         Button("Open in Preview", action: openInPreview)
///         Button("Save as PDF", action: saveAsPDF)
///     } label: {
///         Label("PDF", systemImage: "doc.fill")
///     }
///
/// ### Primary action
///
/// Menus can be created with a custom primary action. The primary action will
/// be performed when the user taps or clicks on the body of the control, and
/// the menu presentation will happen on a secondary gesture, such as on
/// long press or on click of the menu indicator. The following example creates
/// a menu that adds bookmarks, with advanced options that are presented in a
/// menu.
///
///     Menu {
///         Button(action: addCurrentTabToReadingList) {
///             Label("Add to Reading List", systemImage: "eyeglasses")
///         }
///         Button(action: bookmarkAll) {
///             Label("Add Bookmarks for All Tabs", systemImage: "book")
///         }
///         Button(action: show) {
///             Label("Show All Bookmarks", systemImage: "books.vertical")
///         }
///     } label: {
///         Label("Add Bookmark", systemImage: "book")
///     } primaryAction: {
///         addBookmark()
///     }
///
/// ### Styling menus
///
/// Use the ``View/menuStyle(_:)`` modifier to change the style of all menus
/// in a view. The following example shows how to apply a custom style:
///
///     Menu("Editing") {
///         Button("Set In Point", action: setInPoint)
///         Button("Set Out Point", action: setOutPoint)
///     }
///     .menuStyle(EditingControlsMenuStyle())
///
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct Menu<Label, Content> : View where Label : View, Content : View {

    /// The content and behavior of the view.
    ///
    /// When you implement a custom view, you must implement a computed
    /// `body` property to provide the content for your view. Return a view
    /// that's composed of built-in views that SkipUI provides, plus other
    /// composite views that you've already defined:
    ///
    ///     struct MyView: View {
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///         }
    ///     }
    ///
    /// For more information about composing views and a view hierarchy,
    /// see <doc:Declaring-a-Custom-View>.
    @MainActor public var body: some View { get { return never() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
//    public typealias Body = some View
}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension Menu {

    /// Creates a menu with a custom label.
    ///
    /// - Parameters:
    ///     - content: A group of menu items.
    ///     - label: A view describing the content of the menu.
    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates a menu that generates its label from a localized string key.
    ///
    /// - Parameters:
    ///     - titleKey: The key for the link's localized title, which describes
    ///         the contents of the menu.
    ///     - content: A group of menu items.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) where Label == Text { fatalError() }

    /// Creates a menu that generates its label from a string.
    ///
    /// To create the label with a localized string key, use
    /// ``Menu/init(_:content:)-7v768`` instead.
    ///
    /// - Parameters:
    ///     - title: A string that describes the contents of the menu.
    ///     - content: A group of menu items.
    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where Label == Text, S : StringProtocol { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension Menu {

    /// Creates a menu with a custom primary action and custom label.
    ///
    /// - Parameters:
    ///     - content: A group of menu items.
    ///     - label: A view describing the content of the menu.
    ///     - primaryAction: The action to perform on primary
    ///         interaction with the menu.
    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label, primaryAction: @escaping () -> Void) { fatalError() }

    /// Creates a menu with a custom primary action that generates its label
    /// from a localized string key.
    ///
    /// - Parameters:
    ///     - titleKey: The key for the link's localized title, which describes
    ///         the contents of the menu.
    ///     - primaryAction: The action to perform on primary
    ///         interaction with the menu.
    ///     - content: A group of menu items.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content, primaryAction: @escaping () -> Void) where Label == Text { fatalError() }

    /// Creates a menu with a custom primary action that generates its label
    /// from a string.
    ///
    /// To create the label with a localized string key, use
    /// `Menu(_:primaryAction:content:)` instead.
    ///
    /// - Parameters:
    ///     - title: A string that describes the contents of the menu.
    ///     - primaryAction: The action to perform on primary
    ///         interaction with the menu.
    ///     - content: A group of menu items.
    public init<S>(_ title: S, @ViewBuilder content: () -> Content, primaryAction: @escaping () -> Void) where Label == Text, S : StringProtocol { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension Menu where Label == MenuStyleConfiguration.Label, Content == MenuStyleConfiguration.Content {

    /// Creates a menu based on a style configuration.
    ///
    /// Use this initializer within the ``MenuStyle/makeBody(configuration:)``
    /// method of a ``MenuStyle`` instance to create an instance of the menu
    /// being styled. This is useful for custom menu styles that modify the
    /// current menu style.
    ///
    /// For example, the following code creates a new, custom style that adds a
    /// red border around the current menu style:
    ///
    ///     struct RedBorderMenuStyle: MenuStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             Menu(configuration)
    ///                 .border(Color.red)
    ///         }
    ///     }
    ///
    public init(_ configuration: MenuStyleConfiguration) { fatalError() }
}

/// The set of menu dismissal behavior options.
///
/// Configure the menu dismissal behavior for a view hierarchy using the
/// ``View/menuActionDismissBehavior(_:)`` view modifier.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct MenuActionDismissBehavior : Equatable {

    /// Use the a dismissal behavior that's appropriate for the given context.
    ///
    /// In most cases, the default behavior is ``enabled``. There are some
    /// cases, like ``Stepper``, that use ``disabled`` by default.
    public static let automatic: MenuActionDismissBehavior = { fatalError() }()

    /// Always dismiss the presented menu after performing an action.
    public static let enabled: MenuActionDismissBehavior = { fatalError() }()

    /// Never dismiss the presented menu after performing an action.
    @available(tvOS 17.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public static let disabled: MenuActionDismissBehavior = { fatalError() }()

    public static func == (a: MenuActionDismissBehavior, b: MenuActionDismissBehavior) -> Bool { fatalError() }
}

/// A control group style that presents its content as a menu when the user
/// presses the control, or as a submenu when nested within a larger menu.
///
/// Use ``ControlGroupStyle/menu`` to construct this style.
@available(iOS 16.4, macOS 13.3, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct MenuControlGroupStyle : ControlGroupStyle {

    /// Creates a menu control group style.
    public init() { fatalError() }

    /// Creates a view representing the body of a control group.
    ///
    /// - Parameter configuration: The properties of the control group instance
    ///   being created.
    ///
    /// This method will be called for each instance of ``ControlGroup`` created
    /// within a view hierarchy where this style is the current
    /// `ControlGroupStyle`.
    @MainActor public func makeBody(configuration: MenuControlGroupStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a control group.
//    public typealias Body = some View
}

/// The order in which a menu presents its content.
///
/// You can configure the preferred menu order using the
/// ``View/menuOrder(_:)`` view modifier.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct MenuOrder : Equatable, Hashable, Sendable {

    /// The ordering of the menu chosen by the system for the current context.
    ///
    /// On iOS, this order resolves to ``fixed`` for menus
    /// presented within scrollable content. Pickers that use the
    /// ``PickerStyle/menu`` style also default to ``fixed`` order. In all
    /// other cases, menus default to ``priority`` order.
    ///
    /// On macOS, tvOS and watchOS, the `automatic` order always resolves to
    /// ``fixed`` order.
    public static let automatic: MenuOrder = { fatalError() }()

    /// Keep the first items closest to user's interaction point.
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let priority: MenuOrder = { fatalError() }()

    /// Order items from top to bottom.
    public static let fixed: MenuOrder = { fatalError() }()

    public static func == (a: MenuOrder, b: MenuOrder) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// A picker style that presents the options as a menu when the user presses a
/// button, or as a submenu when nested within a larger menu.
///
/// You can also use ``PickerStyle/menu`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct MenuPickerStyle : PickerStyle {

    /// Creates a menu picker style.
    public init() { fatalError() }
}

/// A type that applies standard interaction behavior and a custom appearance
/// to all menus within a view hierarchy.
///
/// To configure the current menu style for a view hierarchy, use the
/// ``View/menuStyle(_:)`` modifier.
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public protocol MenuStyle {

    /// A view that represents the body of a menu.
    associatedtype Body : View

    /// Creates a view that represents the body of a menu.
    ///
    /// - Parameter configuration: The properties of the menu.
    ///
    /// The system calls this method for each ``Menu`` instance in a view
    /// hierarchy where this style is the current menu style.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a menu.
    typealias Configuration = MenuStyleConfiguration
}

@available(iOS, introduced: 14.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(macOS, introduced: 11.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(tvOS, introduced: 17.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
extension MenuStyle where Self == BorderlessButtonMenuStyle {

    /// A menu style that displays a borderless button that toggles the display of
    /// the menu's contents when pressed.
    ///
    /// On macOS, the button optionally displays an arrow indicating that it
    /// presents a menu.
    ///
    /// Pressing and then dragging into the contents triggers the chosen action on
    /// release.
    public static var borderlessButton: BorderlessButtonMenuStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension MenuStyle where Self == DefaultMenuStyle {

    /// The default menu style, based on the menu's context.
    ///
    /// The default menu style can vary by platform. By default, macOS uses the
    /// bordered button style.
    ///
    /// If you create a menu inside a container, the style resolves to the
    /// recommended style for menus inside that container for that specific
    /// platform. For example, a menu nested within another menu will resolve to
    /// a submenu:
    ///
    ///     Menu("Edit") {
    ///         Menu("Arrange") {
    ///             Button("Bring to Front", action: moveSelectionToFront)
    ///             Button("Send to Back", action: moveSelectionToBack)
    ///         }
    ///         Button("Delete", action: deleteSelection)
    ///     }
    ///
    /// You can override a menu's style. To apply the default style to a menu,
    /// or to a view that contains a menu, use the ``View/menuStyle(_:)``
    /// modifier.
    public static var automatic: DefaultMenuStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension MenuStyle where Self == ButtonMenuStyle {

    /// A menu style that displays a button that toggles the display of
    /// the menu's contents when pressed.
    ///
    /// On macOS, the button displays an arrow to indicate that it presents a
    /// menu.
    ///
    /// Pressing and then dragging into the contents activates the selected
    /// action on release.
    public static var button: ButtonMenuStyle { get { fatalError() } }
}

/// A configuration of a menu.
///
/// Use the ``Menu/init(_:)`` initializer of ``Menu`` to create an
/// instance using the current menu style, which you can modify to create a
/// custom style.
///
/// For example, the following code creates a new, custom style that adds a red
/// border to the current menu style:
///
///     struct RedBorderMenuStyle: MenuStyle {
///         func makeBody(configuration: Configuration) -> some View {
///             Menu(configuration)
///                 .border(Color.red)
///         }
///     }
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct MenuStyleConfiguration {

    /// A type-erased label of a menu.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A type-erased content of a menu.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }
}

/// The default menu style, based on the menu's context.
///
/// You can also use ``MenuStyle/automatic`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct DefaultMenuStyle : MenuStyle {

    /// Creates a default menu style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a menu.
    ///
    /// - Parameter configuration: The properties of the menu.
    ///
    /// The system calls this method for each ``Menu`` instance in a view
    /// hierarchy where this style is the current menu style.
    public func makeBody(configuration: DefaultMenuStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a menu.
//    public typealias Body = some View
}
