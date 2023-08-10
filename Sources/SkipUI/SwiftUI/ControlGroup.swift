// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A container view that displays semantically-related controls
/// in a visually-appropriate manner for the context
///
/// You can provide an optional label to this view that describes its children.
/// This view may be used in different ways depending on the surrounding
/// context. For example, when you place the control group in a
/// toolbar item, SkipUI uses the label when the group is moved to the
/// toolbar's overflow menu.
///
///     ContentView()
///         .toolbar(id: "items") {
///             ToolbarItem(id: "media") {
///                 ControlGroup {
///                     MediaButton()
///                     ChartButton()
///                     GraphButton()
///                 } label: {
///                     Label("Plus", systemImage: "plus")
///                 }
///             }
///         }
///
@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct ControlGroup<Content> : View where Content : View {

    /// Creates a new ControlGroup with the specified children
    ///
    /// - Parameters:
    ///   - content: the children to display
    public init(@ViewBuilder content: () -> Content) { fatalError() }

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

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension ControlGroup where Content == ControlGroupStyleConfiguration.Content {

    /// Creates a control group based on a style configuration.
    ///
    /// Use this initializer within the
    /// ``ControlGroupStyle/makeBody(configuration:)`` method of a
    /// ``ControlGroupStyle`` instance to create an instance of the control group
    /// being styled. This is useful for custom control group styles that modify
    /// the current control group style.
    ///
    /// For example, the following code creates a new, custom style that places a
    /// red border around the current control group:
    ///
    ///     struct RedBorderControlGroupStyle: ControlGroupStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             ControlGroup(configuration)
    ///                 .border(Color.red)
    ///         }
    ///     }
    ///
    public init(_ configuration: ControlGroupStyleConfiguration) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension ControlGroup {

    /// Creates a new control group with the specified content and a label.
    ///
    /// - Parameters:
    ///   - content: The content to display.
    ///   - label: A view that describes the purpose of the group.
    public init<C, L>(@ViewBuilder content: () -> C, @ViewBuilder label: () -> L) where Content == LabeledControlGroupContent<C, L>, C : View, L : View { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension ControlGroup {

    /// Creates a new control group with the specified content that generates
    /// its label from a localized string key.
    ///
    /// - Parameters:
    /// - titleKey: The key for the group's localized title, that describes
    /// the contents of the group.
    /// - label: A view that describes the purpose of the group.
    public init<C>(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> C) where Content == LabeledControlGroupContent<C, Text>, C : View { fatalError() }

    /// Creates a new control group with the specified content that generates
    /// its label from a string.
    ///
    /// - Parameters:
    /// - title: A string that describes the contents of the group.
    /// - label: A view that describes the purpose of the group.
    public init<C, S>(_ title: S, @ViewBuilder content: () -> C) where Content == LabeledControlGroupContent<C, Text>, C : View, S : StringProtocol { fatalError() }
}

/// Defines the implementation of all control groups within a view
/// hierarchy.
///
/// To configure the current `ControlGroupStyle` for a view hierarchy, use the
/// ``View/controlGroupStyle(_:)`` modifier.
@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public protocol ControlGroupStyle {

    /// A view representing the body of a control group.
    associatedtype Body : View

    /// Creates a view representing the body of a control group.
    ///
    /// - Parameter configuration: The properties of the control group instance
    ///   being created.
    ///
    /// This method will be called for each instance of ``ControlGroup`` created
    /// within a view hierarchy where this style is the current
    /// `ControlGroupStyle`.
    @ViewBuilder @MainActor func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a `ControlGroup` instance being created.
    typealias Configuration = ControlGroupStyleConfiguration
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ControlGroupStyle where Self == NavigationControlGroupStyle {

    /// The navigation control group style.
    ///
    /// Use this style to group controls related to navigation, such as
    /// back/forward buttons or timeline navigation controls.
    ///
    /// The navigation control group style can vary by platform. On iOS, it
    /// renders as individual borderless buttons, while on macOS, it displays as
    /// a separated momentary segmented control.
    ///
    /// To apply this style to a control group or to a view that contains a
    /// control group, use the ``View/controlGroupStyle(_:)`` modifier.
    public static var navigation: NavigationControlGroupStyle { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ControlGroupStyle where Self == PaletteControlGroupStyle {

    /// A control group style that presents its content as a palette.
    ///
    /// - Note: When used outside of menus, this style is rendered as a
    /// segmented control.
    ///
    /// Use this style to render a multi-select or a stateless palette.
    /// The following example creates a control group that contains both type of shelves:
    ///
    ///     Menu {
    ///         // A multi select palette
    ///         ControlGroup {
    ///             ForEach(ColorTags.allCases) { colorTag in
    ///                 Toggle(isOn: $selectedColorTags[colorTag]) {
    ///                     Label(colorTag.name, systemImage: "circle")
    ///                 }
    ///                 .tint(colorTag.color)
    ///             }
    ///         }
    ///         .controlGroupStyle(.palette)
    ///         .paletteSelectionEffect(.symbolVariant(.fill))
    ///
    ///         // A momentary / stateless palette
    ///         ControlGroup {
    ///             ForEach(Emotes.allCases) { emote in
    ///                 Button {
    ///                     sendEmote(emote)
    ///                 } label: {
    ///                     Label(emote.name, systemImage: emote.systemImage)
    ///                 }
    ///             }
    ///         }
    ///         .controlGroupStyle(.palette)
    ///     }
    ///
    /// To apply this style to a control group, or to a view that contains
    /// control groups, use the ``View/controlGroupStyle(_:)`` modifier.
    public static var palette: PaletteControlGroupStyle { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension ControlGroupStyle where Self == AutomaticControlGroupStyle {

    /// The default control group style.
    ///
    /// The default control group style can vary by platform. By default, both
    /// platforms use a momentary segmented control style that's appropriate for
    /// the environment in which it is rendered.
    ///
    /// You can override a control group's style. To apply the default style to
    /// a control group or to a view that contains a control group, use
    /// the ``View/controlGroupStyle(_:)`` modifier.
    public static var automatic: AutomaticControlGroupStyle { get { fatalError() } }
}

@available(iOS 16.4, macOS 13.3, tvOS 17.0, *)
@available(watchOS, unavailable)
extension ControlGroupStyle where Self == MenuControlGroupStyle {

    /// A control group style that presents its content as a menu when the user
    /// presses the control, or as a submenu when nested within a larger menu.
    ///
    /// To apply this style to a control group, or to a view that contains
    /// control groups, use the ``View/controlGroupStyle(_:)`` modifier.
    public static var menu: MenuControlGroupStyle { get { fatalError() } }
}

@available(iOS 16.4, macOS 13.3, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ControlGroupStyle where Self == CompactMenuControlGroupStyle {

    /// A control group style that presents its content as a compact menu when the user
    /// presses the control, or as a submenu when nested within a larger menu.
    ///
    /// To apply this style to a control group, or to a view that contains
    /// control groups, use the ``View/controlGroupStyle(_:)`` modifier.
    public static var compactMenu: CompactMenuControlGroupStyle { get { fatalError() } }
}

/// The properties of a control group.
@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct ControlGroupStyleConfiguration {

    /// A type-erased content of a `ControlGroup`.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A view that represents the content of the `ControlGroup`.
    public let content: ControlGroupStyleConfiguration.Content = { fatalError() }()

    /// A type-erased label of a ``ControlGroup``.
    @available(iOS 16.0, macOS 13.0, *)
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A view that provides the optional label of the ``ControlGroup``.
    @available(iOS 16.0, macOS 13.0, *)
    public let label: ControlGroupStyleConfiguration.Label = { fatalError() }()
}

/// A control group style that presents its content as a palette.
///
/// Use ``ControlGroupStyle/palette`` to construct this style.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PaletteControlGroupStyle : ControlGroupStyle {

    /// Creates a palette control group style.
    public init() { fatalError() }

    /// Creates a view representing the body of a control group.
    ///
    /// - Parameter configuration: The properties of the control group instance
    ///   being created.
    ///
    /// This method will be called for each instance of ``ControlGroup`` created
    /// within a view hierarchy where this style is the current
    /// `ControlGroupStyle`.
    @MainActor public func makeBody(configuration: PaletteControlGroupStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a control group.
//    public typealias Body = some View
}

/// A control group style that presents its content as a compact menu when the user
/// presses the control, or as a submenu when nested within a larger menu.
///
/// Use ``ControlGroupStyle/compactMenu`` to construct this style.
@available(iOS 16.4, macOS 13.3, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct CompactMenuControlGroupStyle : ControlGroupStyle {

    /// Creates a compact menu control group style.
    public init() { fatalError() }

    /// Creates a view representing the body of a control group.
    ///
    /// - Parameter configuration: The properties of the control group instance
    ///   being created.
    ///
    /// This method will be called for each instance of ``ControlGroup`` created
    /// within a view hierarchy where this style is the current
    /// `ControlGroupStyle`.
    @MainActor public func makeBody(configuration: CompactMenuControlGroupStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a control group.
//    public typealias Body = some View
}

/// The default control group style.
///
/// You can also use ``ControlGroupStyle/automatic`` to construct this style.
@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct AutomaticControlGroupStyle : ControlGroupStyle {

    /// Creates a view representing the body of a control group.
    ///
    /// - Parameter configuration: The properties of the control group instance
    ///   being created.
    ///
    /// This method will be called for each instance of ``ControlGroup`` created
    /// within a view hierarchy where this style is the current
    /// `ControlGroupStyle`.
    @MainActor public func makeBody(configuration: AutomaticControlGroupStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a control group.
//    public typealias Body = some View
}

#endif
