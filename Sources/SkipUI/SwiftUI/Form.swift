// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// A container for grouping controls used for data entry, such as in settings
/// or inspectors.
///
/// SkipUI applies platform-appropriate styling to views contained inside a
/// form, to group them together. Form-specific styling applies to
/// things like buttons, toggles, labels, lists, and more. Keep in mind that
/// these stylings may be platform-specific. For example, forms apppear as
/// grouped lists on iOS, and as aligned vertical stacks on macOS.
///
/// The following example shows a simple data entry form on iOS, grouped into
/// two sections. The supporting types (`NotifyMeAboutType` and
/// `ProfileImageSize`) and state variables (`notifyMeAbout`, `profileImageSize`,
/// `playNotificationSounds`, and `sendReadReceipts`) are omitted for
/// simplicity.
///
///     var body: some View {
///         NavigationView {
///             Form {
///                 Section(header: Text("Notifications")) {
///                     Picker("Notify Me About", selection: $notifyMeAbout) {
///                         Text("Direct Messages").tag(NotifyMeAboutType.directMessages)
///                         Text("Mentions").tag(NotifyMeAboutType.mentions)
///                         Text("Anything").tag(NotifyMeAboutType.anything)
///                     }
///                     Toggle("Play notification sounds", isOn: $playNotificationSounds)
///                     Toggle("Send read receipts", isOn: $sendReadReceipts)
///                 }
///                 Section(header: Text("User Profiles")) {
///                     Picker("Profile Image Size", selection: $profileImageSize) {
///                         Text("Large").tag(ProfileImageSize.large)
///                         Text("Medium").tag(ProfileImageSize.medium)
///                         Text("Small").tag(ProfileImageSize.small)
///                     }
///                     Button("Clear Image Cache") {}
///                 }
///             }
///         }
///     }
///
///
/// ![A form on iOS, presented as a grouped list with two sections. The
/// first section is labeled Notifications and contains a navigation link with
/// the label Notify Me About and the current value Direct Messages. The section
/// also contains two toggles, Play Notification Sounds and Send Read Receipts,
/// the first of which is set to the on position. A second section named User
/// Profiles has a navigation link labeled Profile Image Size and the value
/// Medium, followed by a button labeled Clear Image
/// Cache.](SkipUI-Form-iOS.png)
///
/// On macOS, a similar form renders as a vertical stack. To adhere to macOS
/// platform conventions, this version doesn't use sections, and uses colons at
/// the end of its labels. It also sets the picker to use
/// the ``PickerStyle/inline`` style, which produces radio buttons on macOS.
///
///     var body: some View {
///         Spacer()
///         HStack {
///             Spacer()
///             Form {
///                 Picker("Notify Me About:", selection: $notifyMeAbout) {
///                     Text("Direct Messages").tag(NotifyMeAboutType.directMessages)
///                     Text("Mentions").tag(NotifyMeAboutType.mentions)
///                     Text("Anything").tag(NotifyMeAboutType.anything)
///                 }
///                 Toggle("Play notification sounds", isOn: $playNotificationSounds)
///                 Toggle("Send read receipts", isOn: $sendReadReceipts)
///
///                 Picker("Profile Image Size:", selection: $profileImageSize) {
///                     Text("Large").tag(ProfileImageSize.large)
///                     Text("Medium").tag(ProfileImageSize.medium)
///                     Text("Small").tag(ProfileImageSize.small)
///                 }
///                 .pickerStyle(.inline)
///
///                 Button("Clear Image Cache") {}
///             }
///             Spacer()
///         }
///         Spacer()
///     }
///
/// ![A form on iOS, presented as a vertical stack of views. At top, it shows
/// a pop-up menu with the label label Notify Me about and the current value
/// Direct Messages. Below this are two checkboxes, labeled Play Notification
/// Sounds and Send Read Receipts, the first of which is set on. Below this
/// is the label Profile Image Size with three radio buttons -- Large, Medium,
/// and Small -- with Medium currently selected. At the bottom of the form,
/// there is a button titled Clear Image Cache.](SkipUI-Form-macOS.png)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Form<Content> : View where Content : View {

    /// Creates a form with the provided content.
    /// - Parameter content: A ``SkipUI/ViewBuilder`` that provides the content for the
    /// form.
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

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Form where Content == FormStyleConfiguration.Content {

    /// Creates a form based on a form style configuration.
    ///
    /// - Parameter configuration: The properties of the form.
    public init(_ configuration: FormStyleConfiguration) { fatalError() }
}

/// The appearance and behavior of a form.
///
/// To configure the style for a single ``Form`` or for all form instances
/// in a view hierarchy, use the ``View/formStyle(_:)`` modifier.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public protocol FormStyle {

    /// A view that represents the appearance and interaction of a form.
    associatedtype Body : View

    /// Creates a view that represents the body of a form.
    ///
    /// - Parameter configuration: The properties of the form.
    /// - Returns: A view that has behavior and appearance that enables it
    ///   to function as a ``Form``.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a form instance.
    ///
    /// You receive a `configuration` parameter of this type --- which is an
    /// alias for the ``FormStyleConfiguration`` type --- when you implement
    /// the required ``makeBody(configuration:)`` method in a custom form
    /// style implementation.
    typealias Configuration = FormStyleConfiguration
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension FormStyle where Self == ColumnsFormStyle {

    /// A non-scrolling form style with a trailing aligned column of labels
    /// next to a leading aligned column of values.
    public static var columns: ColumnsFormStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension FormStyle where Self == AutomaticFormStyle {

    /// The default form style.
    public static var automatic: AutomaticFormStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension FormStyle where Self == GroupedFormStyle {

    /// A form style with grouped rows.
    ///
    /// Rows in a grouped rows form have leading aligned labels and trailing
    /// aligned controls within visually grouped sections.
    public static var grouped: GroupedFormStyle { get { fatalError() } }
}

/// The properties of a form instance.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct FormStyleConfiguration {

    /// A type-erased content of a form.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A view that is the content of the form.
    public let content: FormStyleConfiguration.Content = { fatalError() }()
}

/// A form style with grouped rows.
///
/// Rows in this form style have leading aligned labels and trailing
/// aligned controls within visually grouped sections.
///
/// Use the ``FormStyle/grouped`` static variable to create this style:
///
///     Form {
///        ...
///     }
///     .formStyle(.grouped)
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct GroupedFormStyle : FormStyle {

    /// Creates a form style with scrolling, grouped rows.
    ///
    /// Don't call this initializer directly. Instead, use the
    /// ``FormStyle/grouped`` static variable to create this style:
    ///
    ///     Form {
    ///        ...
    ///     }
    ///     .formStyle(.grouped)
    ///
    public init() { fatalError() }

    /// Creates a view that represents the body of a form.
    ///
    /// - Parameter configuration: The properties of the form.
    /// - Returns: A view that has behavior and appearance that enables it
    ///   to function as a ``Form``.
    public func makeBody(configuration: GroupedFormStyle.Configuration) -> some View { return never() }


    /// A view that represents the appearance and interaction of a form.
//    public typealias Body = some View
}
