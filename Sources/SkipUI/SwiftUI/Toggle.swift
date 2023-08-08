// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// A control that toggles between on and off states.
///
/// You create a toggle by providing an `isOn` binding and a label. Bind `isOn`
/// to a Boolean property that determines whether the toggle is on or off. Set
/// the label to a view that visually describes the purpose of switching between
/// toggle states. For example:
///
///     @State private var vibrateOnRing = false
///
///     var body: some View {
///         Toggle(isOn: $vibrateOnRing) {
///             Text("Vibrate on Ring")
///         }
///     }
///
/// For the common case of text-only labels, you can use the convenience
/// initializer that takes a title string (or localized string key) as its first
/// parameter, instead of a trailing closure:
///
///     @State private var vibrateOnRing = true
///
///     var body: some View {
///         Toggle("Vibrate on Ring", isOn: $vibrateOnRing)
///     }
///
/// ### Styling toggles
///
/// Toggles use a default style that varies based on both the platform and
/// the context. For more information, read about the ``ToggleStyle/automatic``
/// toggle style.
///
/// You can customize the appearance and interaction of toggles by applying
/// styles using the ``View/toggleStyle(_:)`` modifier. You can apply built-in
/// styles, like ``ToggleStyle/switch``, to either a toggle, or to a view
/// hierarchy that contains toggles:
///
///     VStack {
///         Toggle("Vibrate on Ring", isOn: $vibrateOnRing)
///         Toggle("Vibrate on Silent", isOn: $vibrateOnSilent)
///     }
///     .toggleStyle(.switch)
///
/// You can also define custom styles by creating a type that conforms to the
/// ``ToggleStyle`` protocol.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Toggle<Label> : View where Label : View {

    /// Creates a toggle that displays a custom label.
    ///
    /// - Parameters:
    ///   - isOn: A binding to a property that determines whether the toggle is on
    ///     or off.
    ///   - label: A view that describes the purpose of the toggle.
    public init(isOn: Binding<Bool>, @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates a toggle representing a collection of values with a custom label.
    ///
    /// The following example creates a single toggle that represents
    /// the state of multiple alarms:
    ///
    ///     struct Alarm: Hashable, Identifiable {
    ///         var id = UUID()
    ///         var isOn = false
    ///         var name = ""
    ///     }
    ///
    ///     @State private var alarms = [
    ///         Alarm(isOn: true, name: "Morning"),
    ///         Alarm(isOn: false, name: "Evening")
    ///     ]
    ///
    ///     Toggle(sources: $alarms, isOn: \.isOn) {
    ///         Text("Enable all alarms")
    ///     }
    ///
    /// - Parameters:
    ///   - sources: A collection of values used as the source for rendering the
    ///     Toggle's state.
    ///   - isOn: The key path of the values that determines whether the toggle
    ///     is on, mixed or off.
    ///   - label: A view that describes the purpose of the toggle.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<C>(sources: C, isOn: KeyPath<C.Element, Binding<Bool>>, @ViewBuilder label: () -> Label) where C : RandomAccessCollection { fatalError() }

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

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Toggle where Label == ToggleStyleConfiguration.Label {

    /// Creates a toggle based on a toggle style configuration.
    ///
    /// You can use this initializer within the
    /// ``ToggleStyle/makeBody(configuration:)`` method of a ``ToggleStyle`` to
    /// create an instance of the styled toggle. This is useful for custom
    /// toggle styles that only modify the current toggle style, as opposed to
    /// implementing a brand new style.
    ///
    /// For example, the following style adds a red border around the toggle,
    /// but otherwise preserves the toggle's current style:
    ///
    ///     struct RedBorderToggleStyle: ToggleStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             Toggle(configuration)
    ///                 .padding()
    ///                 .border(.red)
    ///         }
    ///     }
    ///
    /// - Parameter configuration: The properties of the toggle, including a
    ///   label and a binding to the toggle's state.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init(_ configuration: ToggleStyleConfiguration) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Toggle where Label == Text {

    /// Creates a toggle that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// `Text` for more information about localizing strings.
    ///
    /// To initialize a toggle with a string variable, use
    /// ``Toggle/init(_:isOn:)-2qurm`` instead.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the toggle's localized title, that describes
    ///     the purpose of the toggle.
    ///   - isOn: A binding to a property that indicates whether the toggle is
    ///    on or off.
    public init(_ titleKey: LocalizedStringKey, isOn: Binding<Bool>) { fatalError() }

    /// Creates a toggle that generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See `Text` for more
    /// information about localizing strings.
    ///
    /// To initialize a toggle with a localized string key, use
    /// ``Toggle/init(_:isOn:)-8qx3l`` instead.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the toggle.
    ///   - isOn: A binding to a property that indicates whether the toggle is
    ///    on or off.
    public init<S>(_ title: S, isOn: Binding<Bool>) where S : StringProtocol { fatalError() }

    /// Creates a toggle representing a collection of values that generates its
    /// label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// `Text` for more information about localizing strings.
    ///
    /// The following example creates a single toggle that represents
    /// the state of multiple alarms:
    ///
    ///     struct Alarm: Hashable, Identifiable {
    ///         var id = UUID()
    ///         var isOn = false
    ///         var name = ""
    ///     }
    ///
    ///     @State private var alarms = [
    ///         Alarm(isOn: true, name: "Morning"),
    ///         Alarm(isOn: false, name: "Evening")
    ///     ]
    ///
    ///     Toggle("Enable all alarms", sources: $alarms, isOn: \.isOn)
    ///
    /// - Parameters:
    ///   - titleKey: The key for the toggle's localized title, that describes
    ///     the purpose of the toggle.
    ///   - sources: A collection of values used as the source for rendering the
    ///     Toggle's state.
    ///   - isOn: The key path of the values that determines whether the toggle
    ///     is on, mixed or off.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<C>(_ titleKey: LocalizedStringKey, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where C : RandomAccessCollection { fatalError() }

    /// Creates a toggle representing a collection of values that generates its
    /// label from a string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See `Text` for more
    /// information about localizing strings.
    ///
    /// The following example creates a single toggle that represents
    /// the state of multiple alarms:
    ///
    ///     struct Alarm: Hashable, Identifiable {
    ///         var id = UUID()
    ///         var isOn = false
    ///         var name = ""
    ///     }
    ///
    ///     @State private var alarms = [
    ///         Alarm(isOn: true, name: "Morning"),
    ///         Alarm(isOn: false, name: "Evening")
    ///     ]
    ///
    ///     Toggle("Enable all alarms", sources: $alarms, isOn: \.isOn)
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the toggle.
    ///   - sources: A collection of values used as the source for rendering
    ///     the Toggle's state.
    ///   - isOn: The key path of the values that determines whether the toggle
    ///     is on, mixed or off.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<S, C>(_ title: S, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where S : StringProtocol, C : RandomAccessCollection { fatalError() }
}

/// The appearance and behavior of a toggle.
///
/// To configure the style for a single ``Toggle`` or for all toggle instances
/// in a view hierarchy, use the ``View/toggleStyle(_:)`` modifier. You can
/// specify one of the built-in toggle styles, like ``ToggleStyle/switch`` or
/// ``ToggleStyle/button``:
///
///     Toggle(isOn: $isFlagged) {
///         Label("Flag", systemImage: "flag.fill")
///     }
///     .toggleStyle(.button)
///
/// Alternatively, you can create and apply a custom style.
///
/// ### Custom styles
///
/// To create a custom style, declare a type that conforms to the `ToggleStyle`
/// protocol and implement the required ``ToggleStyle/makeBody(configuration:)``
/// method. For example, you can define a checklist toggle style:
///
///     struct ChecklistToggleStyle: ToggleStyle {
///         func makeBody(configuration: Configuration) -> some View {
///             // Return a view that has checklist appearance and behavior.
///         }
///     }
///
/// Inside the method, use the `configuration` parameter, which is an instance
/// of the ``ToggleStyleConfiguration`` structure, to get the label and
/// a binding to the toggle state. To see examples of how to use these items
/// to construct a view that has the appearance and behavior of a toggle, see
/// ``ToggleStyle/makeBody(configuration:)``.
///
/// To provide easy access to the new style, declare a corresponding static
/// variable in an extension to `ToggleStyle`:
///
///     extension ToggleStyle where Self == ChecklistToggleStyle {
///         static var checklist: ChecklistToggleStyle { .init() }
///     }
///
/// You can then use your custom style:
///
///     Toggle(activity.name, isOn: $activity.isComplete)
///         .toggleStyle(.checklist)
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol ToggleStyle {

    /// A view that represents the appearance and interaction of a toggle.
    ///
    /// SkipUI infers this type automatically based on the ``View``
    /// instance that you return from your implementation of the
    /// ``makeBody(configuration:)`` method.
    associatedtype Body : View

    /// Creates a view that represents the body of a toggle.
    ///
    /// Implement this method when you define a custom toggle style that
    /// conforms to the ``ToggleStyle`` protocol. Use the `configuration`
    /// input --- a ``ToggleStyleConfiguration`` instance --- to access the
    /// toggle's label and state. Return a view that has the appearance and
    /// behavior of a toggle. For example you can create a toggle that displays
    /// a label and a circle that's either empty or filled with a checkmark:
    ///
    ///     struct ChecklistToggleStyle: ToggleStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             Button {
    ///                 configuration.isOn.toggle()
    ///             } label: {
    ///                 HStack {
    ///                     Image(systemName: configuration.isOn
    ///                             ? "checkmark.circle.fill"
    ///                             : "circle")
    ///                     configuration.label
    ///                 }
    ///             }
    ///             .tint(.primary)
    ///             .buttonStyle(.borderless)
    ///         }
    ///     }
    ///
    /// The `ChecklistToggleStyle` toggle style provides a way to both observe
    /// and modify the toggle state: the circle fills for the on state, and
    /// users can tap or click the toggle to change the state. By using a
    /// customized ``Button`` to compose the toggle's body, SkipUI
    /// automatically provides the behaviors that users expect from a
    /// control that has button-like characteristics.
    ///
    /// You can present a collection of toggles that use this style in a stack:
    ///
    /// ![A screenshot of three items stacked vertically. All have a circle
    /// followed by a label. The first has the label Walk the dog, and the
    /// circle is filled. The second has the label Buy groceries, and the
    /// circle is filled. The third has the label Call Mom, and the cirlce is
    /// empty.](ToggleStyle-makeBody-1-iOS)
    ///
    /// When updating a view hierarchy, the system calls your implementation
    /// of the `makeBody(configuration:)` method for each ``Toggle`` instance
    /// that uses the associated style.
    ///
    /// ### Modify the current style
    ///
    /// Rather than create an entirely new style, you can alternatively
    /// modify a toggle's current style. Use the ``Toggle/init(_:)``
    /// initializer inside the `makeBody(configuration:)` method to create
    /// and modify a toggle based on a `configuration` value. For example,
    /// you can create a style that adds padding and a red border to the
    /// current style:
    ///
    ///     struct RedBorderToggleStyle: ToggleStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             Toggle(configuration)
    ///                 .padding()
    ///                 .border(.red)
    ///         }
    ///     }
    ///
    /// If you create a `redBorder` static variable from this style,
    /// you can apply the style to toggles that already use another style, like
    /// the built-in ``ToggleStyle/switch`` and ``ToggleStyle/button`` styles:
    ///
    ///     Toggle("Switch", isOn: $isSwitchOn)
    ///         .toggleStyle(.redBorder)
    ///         .toggleStyle(.switch)
    ///
    ///     Toggle("Button", isOn: $isButtonOn)
    ///         .toggleStyle(.redBorder)
    ///         .toggleStyle(.button)
    ///
    /// Both toggles appear with the usual styling, each with a red border:
    ///
    /// ![A screenshot of a switch toggle with a red border, and a button
    /// toggle with a red border.](ToggleStyle-makeBody-2-iOS)
    ///
    /// Apply the custom style closer to the toggle than the
    /// modified style because SkipUI evaluates style view modifiers in order
    /// from outermost to innermost. If you apply the styles in the other
    /// order, the red border style doesn't have an effect, because the
    /// built-in styles override it completely.
    ///
    /// - Parameter configuration: The properties of the toggle, including a
    ///   label and a binding to the toggle's state.
    /// - Returns: A view that has behavior and appearance that enables it
    ///   to function as a ``Toggle``.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a toggle instance.
    ///
    /// You receive a `configuration` parameter of this type --- which is an
    /// alias for the ``ToggleStyleConfiguration`` type --- when you implement
    /// the required ``makeBody(configuration:)`` method in a custom toggle
    /// style implementation.
    typealias Configuration = ToggleStyleConfiguration
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
extension ToggleStyle where Self == SwitchToggleStyle {

    /// A toggle style that displays a leading label and a trailing switch.
    ///
    /// Apply this style to a ``Toggle`` or to a view hierarchy that contains
    /// toggles using the ``View/toggleStyle(_:)`` modifier:
    ///
    ///     Toggle("Enhance Sound", isOn: $isEnhanced)
    ///         .toggleStyle(.switch)
    ///
    /// The style produces a label that describes the purpose of the toggle
    /// and a switch that shows the toggle's state. The user taps or clicks
    /// the switch to change the toggle's state. The default appearance is
    /// similar across platforms, although the way you use switches in your
    /// user interface varies a little, as described in the respective Human
    /// Interface Guidelines sections:
    ///
    /// | Platform    | Appearance | Human Interface Guidelines |
    /// |-------------|------------|----------------------------|
    /// | iOS, iPadOS | ![A screenshot of the text On appearing to the left of a toggle switch that's on. The toggle's tint color is green. The toggle and its text appear in a rounded rectangle, and are aligned with opposite edges of the rectangle.](ToggleStyle-switch-1-iOS) | [Switches](https://developer.apple.com/design/human-interface-guidelines/ios/controls/switches/) |
    /// | macOS       | ![A screenshot of the text On appearing to the left of a toggle switch that's on. The toggle's tint color is blue. The toggle and its text are adjacent to each other.](ToggleStyle-switch-1-macOS) | [Switches](https://developer.apple.com/design/human-interface-guidelines/macos/buttons/switches/)
    /// | watchOS     | ![A screenshot of the text On appearing to the left of a toggle switch that's on. The toggle's tint color is green. The toggle and its text appear in a rounded rectangle, and are aligned with opposite edges of the rectangle.](ToggleStyle-switch-1-watchOS) | [Toggles and Switches](https://developer.apple.com/design/human-interface-guidelines/watchos/elements/toggles-and-switches/) |
    ///
    /// In iOS, iPadOS, and watchOS, the label and switch fill as much
    /// horizontal space as the toggle's parent offers by aligning the label's
    /// leading edge and the switch's trailing edge with the containing view's
    /// respective leading and trailing edges. In macOS, the style uses a
    /// minimum of horizontal space by aligning the trailing edge of the label
    /// with the leading edge of the switch. SkipUI helps you to manage the
    /// spacing and alignment when this style appears in a ``Form``.
    ///
    /// SkipUI uses this style as the default for iOS, iPadOS, and watchOS in
    /// most contexts when you don't set a style, or when you apply
    /// the ``ToggleStyle/automatic`` style.
    public static var `switch`: SwitchToggleStyle { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ToggleStyle where Self == ButtonToggleStyle {

    /// A toggle style that displays as a button with its label as the title.
    ///
    /// Apply this style to a ``Toggle`` or to a view hierarchy that contains
    /// toggles using the ``View/toggleStyle(_:)`` modifier:
    ///
    ///     Toggle(isOn: $isFlagged) {
    ///         Label("Flag", systemImage: "flag.fill")
    ///     }
    ///     .toggleStyle(.button)
    ///
    /// The style produces a button with a label that describes the purpose
    /// of the toggle. The user taps or clicks the button to change the
    /// toggle's state. The button indicates the `on` state by filling in the
    /// background with its tint color. You can change the tint color using
    /// the ``View/tint(_:)-93mfq`` modifier. SkipUI uses this style as the
    /// default for toggles that appear in a toolbar.
    ///
    /// The following table shows the toggle in both the `off` and `on` states,
    /// respectively:
    ///
    ///   | Platform    | Appearance |
    ///   |-------------|------------|
    ///   | iOS, iPadOS | ![A screenshot of two buttons with a flag icon and the word flag inside. The first button isn't highlighted; the second one is.](ToggleStyle-button-1-iOS) |
    ///   | macOS       | ![A screenshot of two buttons with a flag icon and the word flag inside. The first button isn't highlighted; the second one is.](ToggleStyle-button-1-macOS) |
    ///
    /// A ``Label`` instance is a good choice for a button toggle's label.
    /// Based on the context, SkipUI decides whether to display both the title
    /// and icon, as in the example above, or just the icon, like when the
    /// toggle appears in a toolbar. You can also control the label's style
    /// by adding a ``View/labelStyle(_:)`` modifier. In any case, SkipUI
    /// always uses the title to identify the control using VoiceOver.
    public static var button: ButtonToggleStyle { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ToggleStyle where Self == DefaultToggleStyle {

    /// The default toggle style.
    ///
    /// Use this ``ToggleStyle`` to let SkipUI pick a suitable style for
    /// the current platform and context. Toggles use the `automatic` style
    /// by default, but you might need to set it explicitly using the
    /// ``View/toggleStyle(_:)`` modifier to override another style
    /// in the environment. For example, you can request automatic styling for
    /// a toggle in an ``HStack`` that's otherwise configured to use the
    /// ``ToggleStyle/button`` style:
    ///
    ///     HStack {
    ///         Toggle(isOn: $isShuffling) {
    ///             Label("Shuffle", systemImage: "shuffle")
    ///         }
    ///         Toggle(isOn: $isRepeating) {
    ///             Label("Repeat", systemImage: "repeat")
    ///         }
    ///
    ///         Divider()
    ///
    ///         Toggle("Enhance Sound", isOn: $isEnhanced)
    ///             .toggleStyle(.automatic) // Set the style automatically here.
    ///     }
    ///     .toggleStyle(.button) // Use button style for toggles in the stack.
    ///
    /// ### Platform defaults
    ///
    /// The `automatic` style produces an appearance that varies by platform,
    /// using the following styles in most contexts:
    ///
    /// | Platform    | Default style                            |
    /// |-------------|------------------------------------------|
    /// | iOS, iPadOS | ``ToggleStyle/switch``                   |
    /// | macOS       | ``ToggleStyle/checkbox``                 |
    /// | tvOS        | A tvOS-specific button style (see below) |
    /// | watchOS     | ``ToggleStyle/switch``                   |
    ///
    /// The default style for tvOS behaves like a button. However,
    /// unlike the ``ToggleStyle/button`` style that's available in some other
    /// platforms, the tvOS toggle takes as much horizontal space as its parent
    /// offers, and displays both the toggle's label and a text field that
    /// indicates the toggle's state. You typically collect tvOS toggles into
    /// a ``List``:
    ///
    ///     List {
    ///         Toggle("Show Lyrics", isOn: $isShowingLyrics)
    ///         Toggle("Shuffle", isOn: $isShuffling)
    ///         Toggle("Repeat", isOn: $isRepeating)
    ///     }
    ///
    /// ![A screenshot of three buttons labeled Show Lyrics, Shuffle, and
    /// Repeat, stacked vertically. The first is highlighted. The second is
    /// on, while the others are off.](ToggleStyle-automatic-2-tvOS)
    ///
    /// ### Contextual defaults
    ///
    /// A toggle's automatic appearance varies in certain contexts:
    ///
    /// * A toggle that appears as part of the content that you provide to one
    ///   of the toolbar modifiers, like ``View/toolbar(content:)-5w0tj``, uses
    ///   the ``ToggleStyle/button`` style by default.
    ///
    /// * A toggle in a ``Menu`` uses a style that you can't create explicitly:
    ///     ```
    ///     Menu("Playback") {
    ///         Toggle("Show Lyrics", isOn: $isShowingLyrics)
    ///         Toggle("Shuffle", isOn: $isShuffling)
    ///         Toggle("Repeat", isOn: $isRepeating)
    ///     }
    ///     ```
    ///   SkipUI shows the toggle's label with a checkmark that appears only
    ///   in the `on` state:
    ///
    ///   | Platform    | Appearance |
    ///   |-------------|------------|
    ///   | iOS, iPadOS | ![A screenshot of a Playback menu in iOS showing three menu items with the labels Repeat, Shuffle, and Show Lyrics. The shuffle item has a checkmark to its left, while the other two items have a blank space to their left.](ToggleStyle-automatic-1-iOS) |
    ///   | macOS       | ![A screenshot of a Playback menu in macOS showing three menu items with the labels Repeat, Shuffle, and Show Lyrics. The shuffle item has a checkmark to its left, while the other two items have a blank space to their left.](ToggleStyle-automatic-1-macOS) |
    public static var automatic: DefaultToggleStyle { get { fatalError() } }
}

/// The properties of a toggle instance.
///
/// When you define a custom toggle style by creating a type that conforms to
/// the ``ToggleStyle`` protocol, you implement the
/// ``ToggleStyle/makeBody(configuration:)`` method. That method takes a
/// `ToggleStyleConfiguration` input that has the information you need
/// to define the behavior and appearance of a ``Toggle``.
///
/// The configuration structure's ``label-swift.property`` reflects the
/// toggle's content, which might be the value that you supply to the
/// `label` parameter of the ``Toggle/init(isOn:label:)`` initializer.
/// Alternatively, it could be another view that SkipUI builds from an
/// initializer that takes a string input, like ``Toggle/init(_:isOn:)-8qx3l``.
/// In either case, incorporate the label into the toggle's view to help
/// the user understand what the toggle does. For example, the built-in
/// ``ToggleStyle/switch`` style horizontally stacks the label with the
/// control element.
///
/// The structure's ``isOn`` property provides a ``Binding`` to the state
/// of the toggle. Adjust the appearance of the toggle based on this value.
/// For example, the built-in ``ToggleStyle/button`` style fills the button's
/// background when the property is `true`, but leaves the background empty
/// when the property is `false`. Change the value when the user performs
/// an action that's meant to change the toggle, like the button does when
/// tapped or clicked by the user.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ToggleStyleConfiguration {

    /// A type-erased label of a toggle.
    ///
    /// SkipUI provides a value of this type --- which is a ``View`` type ---
    /// as the ``label-swift.property`` to your custom toggle style
    /// implementation. Use the label to help define the appearance of the
    /// toggle.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A view that describes the effect of switching the toggle between states.
    ///
    /// Use this value in your implementation of the
    /// ``ToggleStyle/makeBody(configuration:)`` method when defining a custom
    /// ``ToggleStyle``. Access it through the that method's `configuration`
    /// parameter.
    ///
    /// Because the label is a ``View``, you can incorporate it into the
    /// view hierarchy that you return from your style definition. For example,
    /// you can combine the label with a circle image in an ``HStack``:
    ///
    ///     HStack {
    ///         Image(systemName: configuration.isOn
    ///             ? "checkmark.circle.fill"
    ///             : "circle")
    ///         configuration.label
    ///     }
    ///
    public let label: ToggleStyleConfiguration.Label = { fatalError() }()

    /// A binding to a state property that indicates whether the toggle is on.
    ///
    /// Because this value is a ``Binding``, you can both read and write it
    /// in your implementation of the ``ToggleStyle/makeBody(configuration:)``
    /// method when defining a custom ``ToggleStyle``. Access it through
    /// that method's `configuration` parameter.
    ///
    /// Read this value to set the appearance of the toggle. For example, you
    /// can choose between empty and filled circles based on the `isOn` value:
    ///
    ///     Image(systemName: configuration.isOn
    ///         ? "checkmark.circle.fill"
    ///         : "circle")
    ///
    /// Write this value when the user takes an action that's meant to change
    /// the state of the toggle. For example, you can toggle it inside the
    /// `action` closure of a ``Button`` instance:
    ///
    ///     Button {
    ///         configuration.isOn.toggle()
    ///     } label: {
    ///         // Draw the toggle.
    ///     }
    ///
//    @Binding public var isOn: Bool { get { fatalError() } nonmutating set { fatalError() } }

//    public var $isOn: Binding<Bool> { get { fatalError() } }

    /// Whether the ``Toggle`` is currently in a mixed state.
    ///
    /// Use this property to determine whether the toggle style should render
    /// a mixed state presentation. A mixed state corresponds to an underlying
    /// collection with a mix of true and false Bindings.
    /// To toggle the state, use the ``Bool.toggle()`` method on the ``isOn``
    /// binding.
    ///
    /// In the following example, a custom style uses the `isMixed` property
    /// to render the correct toggle state using symbols:
    ///
    ///     struct SymbolToggleStyle: ToggleStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             Button {
    ///                 configuration.isOn.toggle()
    ///             } label: {
    ///                 Image(
    ///                     systemName: configuration.isMixed
    ///                     ? "minus.circle.fill" : configuration.isOn
    ///                     ? "checkmark.circle.fill" : "circle.fill")
    ///                 configuration.label
    ///             }
    ///         }
    ///     }
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public var isMixed: Bool { get { fatalError() } }
}
