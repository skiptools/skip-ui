// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import protocol Foundation.ParseableFormatStyle
import protocol Foundation.FormatStyle
import protocol Foundation.ReferenceConvertible

/// A standard label for user interface items, consisting of an icon with a
/// title.
///
/// One of the most common and recognizable user interface components is the
/// combination of an icon and a label. This idiom appears across many kinds of
/// apps and shows up in collections, lists, menus of action items, and
/// disclosable lists, just to name a few.
///
/// You create a label, in its simplest form, by providing a title and the name
/// of an image, such as an icon from the
/// symbols collection:
///
///     Label("Lightning", systemImage: "bolt.fill")
///
/// You can also apply styles to labels in several ways. In the case of dynamic
/// changes to the view after device rotation or change to a window size you
/// might want to show only the text portion of the label using the
/// ``LabelStyle/titleOnly`` label style:
///
///     Label("Lightning", systemImage: "bolt.fill")
///         .labelStyle(.titleOnly)
///
/// Conversely, there's also an icon-only label style:
///
///     Label("Lightning", systemImage: "bolt.fill")
///         .labelStyle(.iconOnly)
///
/// Some containers might apply a different default label style, such as only
/// showing icons within toolbars on macOS and iOS. To opt in to showing both
/// the title and the icon, you can apply the ``LabelStyle/titleAndIcon`` label
/// style:
///
///     Label("Lightning", systemImage: "bolt.fill")
///         .labelStyle(.titleAndIcon)
///
/// You can also create a customized label style by modifying an existing
/// style; this example adds a red border to the default label style:
///
///     struct RedBorderedLabelStyle: LabelStyle {
///         func makeBody(configuration: Configuration) -> some View {
///             Label(configuration)
///                 .border(Color.red)
///         }
///     }
///
/// For more extensive customization or to create a completely new label style,
/// you'll need to adopt the ``LabelStyle`` protocol and implement a
/// ``LabelStyleConfiguration`` for the new style.
///
/// To apply a common label style to a group of labels, apply the style
/// to the view hierarchy that contains the labels:
///
///     VStack {
///         Label("Rain", systemImage: "cloud.rain")
///         Label("Snow", systemImage: "snow")
///         Label("Sun", systemImage: "sun.max")
///     }
///     .labelStyle(.iconOnly)
///
/// It's also possible to make labels using views to compose the label's icon
/// programmatically, rather than using a pre-made image. In this example, the
/// icon portion of the label uses a filled ``Circle`` overlaid
/// with the user's initials:
///
///     Label {
///         Text(person.fullName)
///             .font(.body)
///             .foregroundColor(.primary)
///         Text(person.title)
///             .font(.subheadline)
///             .foregroundColor(.secondary)
///     } icon: {
///         Circle()
///             .fill(person.profileColor)
///             .frame(width: 44, height: 44, alignment: .center)
///             .overlay(Text(person.initials))
///     }
///
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct Label<Title, Icon> : View where Title : View, Icon : View {

    /// Creates a label with a custom title and icon.
    public init(@ViewBuilder title: () -> Title, @ViewBuilder icon: () -> Icon) { fatalError() }

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

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Label where Title == Text, Icon == Image {

    /// Creates a label with an icon image and a title generated from a
    /// localized string.
    ///
    /// - Parameters:
    ///    - titleKey: A title generated from a localized string.
    ///    - image: The name of the image resource to lookup.
    public init(_ titleKey: LocalizedStringKey, image name: String) { fatalError() }

    /// Creates a label with a system icon image and a title generated from a
    /// localized string.
    ///
    /// - Parameters:
    ///    - titleKey: A title generated from a localized string.
    ///    - systemImage: The name of the image resource to lookup.
    public init(_ titleKey: LocalizedStringKey, systemImage name: String) { fatalError() }

    /// Creates a label with an icon image and a title generated from a string.
    ///
    /// - Parameters:
    ///    - title: A string used as the label's title.
    ///    - image: The name of the image resource to lookup.
    public init<S>(_ title: S, image name: String) where S : StringProtocol { fatalError() }

    /// Creates a label with a system icon image and a title generated from a
    /// string.
    ///
    /// - Parameters:
    ///    - title: A string used as the label's title.
    ///    - systemImage: The name of the image resource to lookup.
    public init<S>(_ title: S, systemImage name: String) where S : StringProtocol { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Label where Title == LabelStyleConfiguration.Title, Icon == LabelStyleConfiguration.Icon {

    /// Creates a label representing the configuration of a style.
    ///
    /// You can use this initializer within the ``LabelStyle/makeBody(configuration:)``
    /// method of a ``LabelStyle`` instance to create an instance of the label
    /// that's being styled. This is useful for custom label styles that only
    /// wish to modify the current style, as opposed to implementing a brand new
    /// style.
    ///
    /// For example, the following style adds a red border around the label,
    /// but otherwise preserves the current style:
    ///
    ///     struct RedBorderedLabelStyle: LabelStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             Label(configuration)
    ///                 .border(Color.red)
    ///         }
    ///     }
    ///
    /// - Parameter configuration: The label style to use.
    public init(_ configuration: LabelStyleConfiguration) { fatalError() }
}

/// A type that applies a custom appearance to all labels within a view.
///
/// To configure the current label style for a view hierarchy, use the
/// ``View/labelStyle(_:)`` modifier.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol LabelStyle {

    /// A view that represents the body of a label.
    associatedtype Body : View

    /// Creates a view that represents the body of a label.
    ///
    /// The system calls this method for each ``Label`` instance in a view
    /// hierarchy where this style is the current label style.
    ///
    /// - Parameter configuration: The properties of the label.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a label.
    typealias Configuration = LabelStyleConfiguration
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LabelStyle where Self == IconOnlyLabelStyle {

    /// A label style that only displays the icon of the label.
    ///
    /// The title of the label is still used for non-visual descriptions, such as
    /// VoiceOver.
    public static var iconOnly: IconOnlyLabelStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LabelStyle where Self == TitleOnlyLabelStyle {

    /// A label style that only displays the title of the label.
    public static var titleOnly: TitleOnlyLabelStyle { get { fatalError() } }
}

@available(iOS 14.5, macOS 11.3, tvOS 14.5, watchOS 7.4, *)
extension LabelStyle where Self == TitleAndIconLabelStyle {

    /// A label style that shows both the title and icon of the label using a
    /// system-standard layout.
    ///
    /// In most cases, labels show both their title and icon by default. However,
    /// some containers might apply a different default label style to their
    /// content, such as only showing icons within toolbars on macOS and iOS. To
    /// opt in to showing both the title and the icon, you can apply the title
    /// and icon label style:
    ///
    ///     Label("Lightning", systemImage: "bolt.fill")
    ///         .labelStyle(.titleAndIcon)
    ///
    /// To apply the title and icon style to a group of labels, apply the style
    /// to the view hierarchy that contains the labels:
    ///
    ///     VStack {
    ///         Label("Rain", systemImage: "cloud.rain")
    ///         Label("Snow", systemImage: "snow")
    ///         Label("Sun", systemImage: "sun.max")
    ///     }
    ///     .labelStyle(.titleAndIcon)
    ///
    /// The relative layout of the title and icon is dependent on the context it
    /// is displayed in. In most cases, however, the label is arranged
    /// horizontally with the icon leading.
    public static var titleAndIcon: TitleAndIconLabelStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LabelStyle where Self == DefaultLabelStyle {

    /// A label style that resolves its appearance automatically based on the
    /// current context.
    public static var automatic: DefaultLabelStyle { get { fatalError() } }
}

/// The properties of a label.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct LabelStyleConfiguration {

    /// A type-erased title view of a label.
    public struct Title {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
    }

    /// A type-erased icon view of a label.
    public struct Icon {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
    }

    /// A description of the labeled item.
    public var title: LabelStyleConfiguration.Title { get { fatalError() } }

    /// A symbolic representation of the labeled item.
    public var icon: LabelStyleConfiguration.Icon { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LabelStyleConfiguration.Title : View {
    public var body: Body { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LabelStyleConfiguration.Icon : View {
    public var body: Body { fatalError() }
}

/// A container for attaching a label to a value-bearing view.
///
/// The instance's content represents a read-only or read-write value, and its
/// label identifies or describes the purpose of that value.
/// The resulting element has a layout that's consistent with other framework
/// controls and automatically adapts to its container, like a form or toolbar.
/// Some styles of labeled content also apply styling or behaviors to the value
/// content, like making ``Text`` views selectable.
///
/// The following example associates a label with a custom view and has
/// a layout that matches the label of the ``Picker``:
///
///     Form {
///         LabeledContent("Custom Value") {
///             MyCustomView(value: $value)
///         }
///         Picker("Selected Value", selection: $selection) {
///             Text("Option 1").tag(1)
///             Text("Option 2").tag(2)
///         }
///     }
///
/// ### Custom view labels
///
/// You can assemble labeled content with an explicit view for its label
/// using the ``init(content:label:)`` initializer. For example, you can
/// rewrite the previous labeled content example using a ``Text`` view:
///
///     LabeledContent {
///         MyCustomView(value: $value)
///     } label: {
///         Text("Custom Value")
///     }
///
/// The `label` view builder accepts any kind of view, like a ``Label``:
///
///     LabeledContent {
///         MyCustomView(value: $value)
///     } label: {
///         Label("Custom Value", systemImage: "hammer")
///     }
///
/// ### Textual labeled content
///
/// You can construct labeled content with string values or formatted values
/// to create read-only displays of textual values:
///
///     Form {
///         Section("Information") {
///             LabeledContent("Name", value: person.name)
///             LabeledContent("Age", value: person.age, format: .number)
///             LabeledContent("Height", value: person.height,
///                 format: .measurement(width: .abbreviated))
///         }
///         if !person.pets.isEmpty {
///             Section("Pets") {
///                 ForEach(pet) { pet in
///                     LabeledContent(pet.species, value: pet.name)
///                 }
///             }
///         }
///     }
///
/// Wherever possible, SkipUI makes this text selectable.
///
/// ### Compositional elements
///
/// You can use labeled content as the label for other elements. For example,
/// a ``NavigationLink`` can present a summary value for the destination it
/// links to:
///
///     Form {
///         NavigationLink(value: Settings.wifiDetail) {
///             LabeledContent("Wi-Fi", value: ssidName)
///         }
///     }
///
/// In some cases, the styling of views used as the value content is
/// specialized as well. For example, while a ``Toggle`` in an inset group
/// form on macOS is styled as a switch by default, it's styled as a checkbox
/// when used as a value element within a surrounding `LabeledContent`
/// instance:
///
///     Form {
///         LabeledContent("Source Control") {
///             Toggle("Refresh local status automatically",
///                 isOn: $refreshLocalStatus)
///             Toggle("Fetch and refresh server status automatically",
///                 isOn: $refreshServerStatus)
///             Toggle("Add and remove files automatically",
///                 isOn: $addAndRemoveFiles)
///             Toggle("Select files to commit automatically",
///                 isOn: $selectFiles)
///         }
///     }
///
/// ### Controlling label visibility
///
/// A label communicates the identity or purpose of the value, which is
/// important for accessibility. However, you might want to hide the label
/// in the display, and some controls or contexts may visually hide their label
/// by default. The ``View/labelsHidden()`` modifier allows controlling that
/// visibility. The following example hides both labels, producing only a
/// group of the two value views:
///
///     Group {
///         LabeledContent("Custom Value") {
///             MyCustomView(value: $value)
///         }
///         Picker("Selected Value", selection: $selection) {
///             Text("Option 1").tag(1)
///             Text("Option 2").tag(2)
///         }
///     }
///     .labelsHidden()
///
/// ### Styling labeled content
///
/// You can set label styles using the ``View/labeledContentStyle(_:)``
/// modifier. You can also build custom styles using ``LabeledContentStyle``.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct LabeledContent<Label, Content> {
}


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension LabeledContent : PlatformView where Label : PlatformView, Content : PlatformView {
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension LabeledContent : View where Label : View, Content : View {

    /// Creates a standard labeled element, with a view that conveys
    /// the value of the element and a label.
    ///
    /// - Parameters:
    ///   - content: The view that conveys the value of the resulting labeled
    ///     element.
    ///   - label: The label that describes the purpose of the result.
    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) { fatalError() }

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

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension LabeledContent where Label == Text, Content : View {

    /// Creates a labeled view that generates its label from a localized string
    /// key.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// `Text` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the view's localized title, that describes
    ///     the purpose of the view.
    ///   - content: The value content being labeled.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a labeled view that generates its label from a string.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See `Text` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the view.
    ///   - content: The value content being labeled.
    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension LabeledContent where Label == Text, Content == Text {

    /// Creates a labeled informational view.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// `Text` for more information about localizing strings.
    ///
    ///     Form {
    ///         LabeledContent("Name", value: person.name)
    ///     }
    ///
    /// In some contexts, this text will be selectable by default.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the view's localized title, that describes
    ///     the purpose of the view.
    ///   - value: The value being labeled.
    public init<S>(_ titleKey: LocalizedStringKey, value: S) where S : StringProtocol { fatalError() }

    /// Creates a labeled informational view.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See `Text` for more
    /// information about localizing strings.
    ///
    ///     Form {
    ///         ForEach(person.pet) { pet in
    ///             LabeledContent(pet.species, value: pet.name)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the view.
    ///   - value: The value being labeled.
    public init<S1, S2>(_ title: S1, value: S2) where S1 : StringProtocol, S2 : StringProtocol { fatalError() }

    /// Creates a labeled informational view from a formatted value.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// `Text` for more information about localizing strings.
    ///
    ///     Form {
    ///         LabeledContent("Age", value: person.age, format: .number)
    ///         LabeledContent("Height", value: person.height,
    ///             format: .measurement(width: .abbreviated))
    ///     }
    ///
    /// - Parameters:
    ///   - titleKey: The key for the view's localized title, that describes
    ///     the purpose of the view.
    ///   - value: The value being labeled.
    ///   - format: A format style of type `F` to convert the underlying value
    ///     of type `F.FormatInput` to a string representation.
    public init<F>(_ titleKey: LocalizedStringKey, value: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String { fatalError() }

    /// Creates a labeled informational view from a formatted value.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See `Text` for more
    /// information about localizing strings.
    ///
    ///     Form {
    ///         Section("Downloads") {
    ///             ForEach(download) { file in
    ///                 LabeledContent(file.name, value: file.downloadSize,
    ///                     format: .byteCount(style: .file))
    ///            }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the view.
    ///   - value: The value being labeled.
    ///   - format: A format style of type `F` to convert the underlying value
    ///     of type `F.FormatInput` to a string representation.
    public init<S, F>(_ title: S, value: F.FormatInput, format: F) where S : StringProtocol, F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension LabeledContent where Label == LabeledContentStyleConfiguration.Label, Content == LabeledContentStyleConfiguration.Content {

    /// Creates labeled content based on a labeled content style configuration.
    ///
    /// You can use this initializer within the
    /// ``LabeledContentStyle/makeBody(configuration:)`` method of a
    /// ``LabeledContentStyle`` to create a labeled content instance.
    /// This is useful for custom styles that only modify the current style,
    /// as opposed to implementing a brand new style.
    ///
    /// For example, the following style adds a red border around the labeled
    /// content, but otherwise preserves the current style:
    ///
    ///     struct RedBorderLabeledContentStyle: LabeledContentStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             LabeledContent(configuration)
    ///                 .border(.red)
    ///         }
    ///     }
    ///
    /// - Parameter configuration: The properties of the labeled content
    public init(_ configuration: LabeledContentStyleConfiguration) { fatalError() }
}

/// The appearance and behavior of a labeled content instance..
///
/// Use ``View/labeledContentStyle(_:)`` to set a style on a view.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public protocol LabeledContentStyle {

    /// A view that represents the appearance and behavior of labeled content.
    associatedtype Body : View

    /// Creates a view that represents the body of labeled content.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a labeled content instance.
    typealias Configuration = LabeledContentStyleConfiguration
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension LabeledContentStyle where Self == AutomaticLabeledContentStyle {

    /// A labeled content style that resolves its appearance automatically based
    /// on the current context.
    public static var automatic: AutomaticLabeledContentStyle { get { fatalError() } }
}

/// The properties of a labeled content instance.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct LabeledContentStyleConfiguration {

    /// A type-erased label of a labeled content instance.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A type-erased content of a labeled content instance.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// The label of the labeled content instance.
    public let label: LabeledContentStyleConfiguration.Label = { fatalError() }()

    /// The content of the labeled content instance.
    public let content: LabeledContentStyleConfiguration.Content = { fatalError() }()
}


/// The default labeled content style.
///
/// Use ``LabeledContentStyle/automatic`` to construct this style.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct AutomaticLabeledContentStyle : LabeledContentStyle {

    /// Creates an automatic labeled content style.
    public init() { fatalError() }

    /// Creates a view that represents the body of labeled content.
    public func makeBody(configuration: AutomaticLabeledContentStyle.Configuration) -> some View { return never() }


    /// A view that represents the appearance and behavior of labeled content.
//    public typealias Body = some View
}

/// A view that represents the body of a control group with a specified
/// label.
///
/// You don't create this type directly. SkipUI creates it when you build
/// a ``ControlGroup``.
@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct LabeledControlGroupContent<Content, Label> : View where Content : View, Label : View {

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

/// A view that represents the view of a toolbar item group with a specified
/// label.
///
/// You don't create this type directly. SkipUI creates it when you build
/// a ``ToolbarItemGroup``.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct LabeledToolbarItemGroupContent<Content, Label> : View where Content : View, Label : View {

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

/// The default label style in the current context.
///
/// You can also use ``LabelStyle/automatic`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct DefaultLabelStyle : LabelStyle {

    /// Creates an automatic label style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a label.
    ///
    /// The system calls this method for each ``Label`` instance in a view
    /// hierarchy where this style is the current label style.
    ///
    /// - Parameter configuration: The properties of the label.
    public func makeBody(configuration: DefaultLabelStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a label.
//    public typealias Body = some View
}

/// A label style that only displays the title of the label.
///
/// You can also use ``LabelStyle/titleOnly`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct TitleOnlyLabelStyle : LabelStyle {

    /// Creates a title-only label style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a label.
    ///
    /// The system calls this method for each ``Label`` instance in a view
    /// hierarchy where this style is the current label style.
    ///
    /// - Parameter configuration: The properties of the label.
    public func makeBody(configuration: TitleOnlyLabelStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a label.
//    public typealias Body = some View
}

/// A label style that only displays the icon of the label.
///
/// You can also use ``LabelStyle/iconOnly`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct IconOnlyLabelStyle : LabelStyle {

    /// Creates an icon-only label style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a label.
    ///
    /// The system calls this method for each ``Label`` instance in a view
    /// hierarchy where this style is the current label style.
    ///
    /// - Parameter configuration: The properties of the label.
    public func makeBody(configuration: IconOnlyLabelStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a label.
//    public typealias Body = some View
}

#endif
