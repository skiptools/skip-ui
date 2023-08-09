// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// A control for selecting from a set of mutually exclusive values.
///
/// You create a picker by providing a selection binding, a label, and the
/// content for the picker to display. Set the `selection` parameter to a bound
/// property that provides the value to display as the current selection. Set
/// the label to a view that visually describes the purpose of selecting content
/// in the picker, and then provide the content for the picker to display.
///
/// For example, consider an enumeration of ice cream flavors and a ``State``
/// variable to hold the selected flavor:
///
///     enum Flavor: String, CaseIterable, Identifiable {
///         case chocolate, vanilla, strawberry
///         var id: Self { self }
///     }
///
///     @State private var selectedFlavor: Flavor = .chocolate
///
/// You can create a picker to select among the values by providing a label, a
/// binding to the current selection, and a collection of views for the picker's
/// content. Append a tag to each of these content views using the
/// ``View/tag(_:)`` view modifier so that the type of each selection matches
/// the type of the bound state variable:
///
///     List {
///         Picker("Flavor", selection: $selectedFlavor) {
///             Text("Chocolate").tag(Flavor.chocolate)
///             Text("Vanilla").tag(Flavor.vanilla)
///             Text("Strawberry").tag(Flavor.strawberry)
///         }
///     }
///
/// If you provide a string label for the picker, as the example above does,
/// the picker uses it to initialize a ``Text`` view as a
/// label. Alternatively, you can use the ``init(selection:content:label:)``
/// initializer to compose the label from other views. The exact appearance
/// of the picker depends on the context. If you use a picker in a ``List``
/// in iOS, it appears in a row with the label and selected value, and a
/// chevron to indicate that you can tap the row to select a new value:
///
/// ![A screenshot of a list row that has the string Flavor on the left side,
/// and the string Chocolate on the right. The word Chocolate appears in a less
/// prominent color than the word Flavor. A right facing chevron appears to the
/// right of the word Chocolate.](Picker-1-iOS)
///
/// ### Iterating over a picker’s options
///
/// To provide selection values for the `Picker` without explicitly listing
/// each option, you can create the picker with a ``ForEach``:
///
///     Picker("Flavor", selection: $selectedFlavor) {
///         ForEach(Flavor.allCases) { flavor in
///             Text(flavor.rawValue.capitalized)
///         }
///     }
///
/// ``ForEach`` automatically assigns a tag to the selection views using
/// each option's `id`. This is possible because `Flavor` conforms to the
/// <doc://com.apple.documentation/documentation/Swift/Identifiable>
/// protocol.
///
/// The example above relies on the fact that `Flavor` defines the type of its
/// `id` parameter to exactly match the selection type. If that's not the case,
/// you need to override the tag. For example, consider a `Topping` type
/// and a suggested topping for each flavor:
///
///     enum Topping: String, CaseIterable, Identifiable {
///         case nuts, cookies, blueberries
///         var id: Self { self }
///     }
///
///     extension Flavor {
///         var suggestedTopping: Topping {
///             switch self {
///             case .chocolate: return .nuts
///             case .vanilla: return .cookies
///             case .strawberry: return .blueberries
///             }
///         }
///     }
///
///     @State private var suggestedTopping: Topping = .nuts
///
/// The following example shows a picker that's bound to a `Topping` type,
/// while the options are all `Flavor` instances. Each option uses the tag
/// modifier to associate the suggested topping with the flavor it displays:
///
///     List {
///         Picker("Flavor", selection: $suggestedTopping) {
///             ForEach(Flavor.allCases) { flavor in
///                 Text(flavor.rawValue.capitalized)
///                     .tag(flavor.suggestedTopping)
///             }
///         }
///         HStack {
///             Text("Suggested Topping")
///             Spacer()
///             Text(suggestedTopping.rawValue.capitalized)
///                 .foregroundStyle(.secondary)
///         }
///     }
///
/// When the user selects chocolate, the picker sets `suggestedTopping`
/// to the value in the associated tag:
///
/// ![A screenshot of two list rows. The first has the string Flavor on the left
/// side, and the string Chocolate on the right. A right facing chevron appears
/// to the right of the word Chocolate. The second row has the string Suggested
/// Topping on the left, and the string Nuts on the right. Both words on the
/// right use a less prominent color than those on the left.](Picker-2-iOS)
///
/// Other examples of when the views in a picker's ``ForEach`` need an explicit
/// tag modifier include when you:
/// * Select over the cases of an enumeration that conforms to the
///   <doc://com.apple.documentation/documentation/Swift/Identifiable> protocol
///   by using anything besides `Self` as the `id` parameter type. For example,
///   a string enumeration might use the case's `rawValue` string as the `id`.
///   That identifier type doesn't match the selection type, which is the type
///   of the enumeration itself.
/// * Use an optional value for the `selection` input parameter. For that to
///   work, you need to explicitly cast the tag modifier's input as
///   <doc://com.apple.documentation/documentation/Swift/Optional> to match.
///   For an example of this, see ``View/tag(_:)``.
///
/// ### Styling pickers
///
/// You can customize the appearance and interaction of pickers using
/// styles that conform to the ``PickerStyle`` protocol, like
/// ``PickerStyle/segmented`` or ``PickerStyle/menu``. To set a specific style
/// for all picker instances within a view, use the ``View/pickerStyle(_:)``
/// modifier. The following example applies the ``PickerStyle/segmented``
/// style to two pickers that independently select a flavor and a topping:
///
///     VStack {
///         Picker("Flavor", selection: $selectedFlavor) {
///             ForEach(Flavor.allCases) { flavor in
///                 Text(flavor.rawValue.capitalized)
///             }
///         }
///         Picker("Topping", selection: $selectedTopping) {
///             ForEach(Topping.allCases) { topping in
///                 Text(topping.rawValue.capitalized)
///             }
///         }
///     }
///     .pickerStyle(.segmented)
///
/// ![A screenshot of two segmented controls. The first has segments labeled
/// Chocolate, Vanilla, and Strawberry, with the first of these selected.
/// The second control has segments labeled Nuts, Cookies, and Blueberries,
/// with the second of these selected.](Picker-3-iOS)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Picker<Label, SelectionValue, Content> : View where Label : View, SelectionValue : Hashable, Content : View {

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
extension Picker {

    /// Creates a picker that displays a custom label.
    ///
    /// If the wrapped values of the collection passed to `sources` are not all
    /// the same, some styles render the selection in a mixed state. The
    /// specific presentation depends on the style.  For example, a Picker
    /// with a menu style uses dashes instead of checkmarks to indicate the
    /// selected values.
    ///
    /// In the following example, a picker in a document inspector controls the
    /// thickness of borders for the currently-selected shapes, which can be of
    /// any number.
    ///
    ///     enum Thickness: String, CaseIterable, Identifiable {
    ///         case thin
    ///         case regular
    ///         case thick
    ///
    ///         var id: String { rawValue }
    ///     }
    ///
    ///     struct Border {
    ///         var color: Color
    ///         var thickness: Thickness
    ///     }
    ///
    ///     @State private var selectedObjectBorders = [
    ///         Border(color: .black, thickness: .thin),
    ///         Border(color: .red, thickness: .thick)
    ///     ]
    ///
    ///     Picker(
    ///         sources: $selectedObjectBorders,
    ///         selection: \.thickness
    ///     ) {
    ///         ForEach(Thickness.allCases) { thickness in
    ///             Text(thickness.rawValue)
    ///         }
    ///     } label: {
    ///         Text("Border Thickness")
    ///     }
    ///
    /// - Parameters:
    ///     - sources: A collection of values used as the source for displaying
    ///       the Picker's selection.
    ///     - selection: The key path of the values that determines the
    ///       currently-selected options. When a user selects an option from the
    ///       picker, the values at the key path of all items in the `sources`
    ///       collection are updated with the selected option.
    ///     - content: A view that contains the set of options.
    ///     - label: A view that describes the purpose of selecting an option.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<C>(sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) where C : RandomAccessCollection { fatalError() }

    /// Creates a picker that displays a custom label.
    ///
    /// - Parameters:
    ///     - selection: A binding to a property that determines the
    ///       currently-selected option.
    ///     - content: A view that contains the set of options.
    ///     - label: A view that describes the purpose of selecting an option.
    public init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Picker where Label == Text {

    /// Creates a picker that generates its label from a localized string key.
    ///
    /// - Parameters:
    ///     - titleKey: A localized string key that describes the purpose of
    ///       selecting an option.
    ///     - selection: A binding to a property that determines the
    ///       currently-selected option.
    ///     - content: A view that contains the set of options.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// To initialize a picker with a string variable, use
    /// ``init(_:selection:content:)-5njtq`` instead.
    public init(_ titleKey: LocalizedStringKey, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a picker that generates its label from a localized string key.
    ///
    /// If the wrapped values of the collection passed to `sources` are not all
    /// the same, some styles render the selection in a mixed state. The
    /// specific presentation depends on the style.  For example, a Picker
    /// with a menu style uses dashes instead of checkmarks to indicate the
    /// selected values.
    ///
    /// In the following example, a picker in a document inspector controls the
    /// thickness of borders for the currently-selected shapes, which can be of
    /// any number.
    ///
    ///     enum Thickness: String, CaseIterable, Identifiable {
    ///         case thin
    ///         case regular
    ///         case thick
    ///
    ///         var id: String { rawValue }
    ///     }
    ///
    ///     struct Border {
    ///         var color: Color
    ///         var thickness: Thickness
    ///     }
    ///
    ///     @State private var selectedObjectBorders = [
    ///         Border(color: .black, thickness: .thin),
    ///         Border(color: .red, thickness: .thick)
    ///     ]
    ///
    ///     Picker(
    ///         "Border Thickness",
    ///         sources: $selectedObjectBorders,
    ///         selection: \.thickness
    ///     ) {
    ///         ForEach(Thickness.allCases) { thickness in
    ///             Text(thickness.rawValue)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - titleKey: A localized string key that describes the purpose of
    ///       selecting an option.
    ///     - sources: A collection of values used as the source for displaying
    ///       the Picker's selection.
    ///     - selection: The key path of the values that determines the
    ///       currently-selected options. When a user selects an option from the
    ///       picker, the values at the key path of all items in the `sources`
    ///       collection are updated with the selected option.
    ///     - content: A view that contains the set of options.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<C>(_ titleKey: LocalizedStringKey, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection { fatalError() }

    /// Creates a picker that generates its label from a string.
    ///
    /// - Parameters:
    ///     - title: A string that describes the purpose of selecting an option.
    ///     - selection: A binding to a property that determines the
    ///       currently-selected option.
    ///     - content: A view that contains the set of options.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// To initialize a picker with a localized string key, use
    /// ``init(_:selection:content:)-6lwfn`` instead.
    public init<S>(_ title: S, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) where S : StringProtocol { fatalError() }

    /// Creates a picker bound to a collection of bindings that generates its
    /// label from a string.
    ///
    /// If the wrapped values of the collection passed to `sources` are not all
    /// the same, some styles render the selection in a mixed state. The
    /// specific presentation depends on the style.  For example, a Picker
    /// with a menu style uses dashes instead of checkmarks to indicate the
    /// selected values.
    ///
    /// In the following example, a picker in a document inspector controls the
    /// thickness of borders for the currently-selected shapes, which can be of
    /// any number.
    ///
    ///     enum Thickness: String, CaseIterable, Identifiable {
    ///         case thin
    ///         case regular
    ///         case thick
    ///
    ///         var id: String { rawValue }
    ///     }
    ///
    ///     struct Border {
    ///         var color: Color
    ///         var thickness: Thickness
    ///     }
    ///
    ///     @State private var selectedObjectBorders = [
    ///         Border(color: .black, thickness: .thin),
    ///         Border(color: .red, thickness: .thick)
    ///     ]
    ///
    ///     Picker(
    ///         "Border Thickness",
    ///         sources: $selectedObjectBorders,
    ///         selection: \.thickness
    ///     ) {
    ///         ForEach(Thickness.allCases) { thickness in
    ///             Text(thickness.rawValue)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - title: A string that describes the purpose of selecting an option.
    ///     - sources: A collection of values used as the source for displaying
    ///       the Picker's selection.
    ///     - selection: The key path of the values that determines the
    ///       currently-selected options. When a user selects an option from the
    ///       picker, the values at the key path of all items in the `sources`
    ///       collection are updated with the selected option.
    ///     - content: A view that contains the set of options.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// To initialize a picker with a localized string key, use
    /// ``init(_:sources:selection:content:)-6e1x`` instead.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<C, S>(_ title: S, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection, S : StringProtocol { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Picker {

    /// Creates a picker that displays a custom label.
    ///
    /// - Parameters:
    ///     - selection: A binding to a property that determines the
    ///       currently-selected option.
    ///     - label: A view that describes the purpose of selecting an option.
    ///     - content: A view that contains the set of options.
    @available(iOS, deprecated: 100000.0, renamed: "Picker(selection:content:label:)")
    @available(macOS, deprecated: 100000.0, renamed: "Picker(selection:content:label:)")
    @available(tvOS, deprecated: 100000.0, renamed: "Picker(selection:content:label:)")
    @available(watchOS, deprecated: 100000.0, renamed: "Picker(selection:content:label:)")
    @available(xrOS, deprecated: 100000.0, renamed: "Picker(selection:content:label:)")
    public init(selection: Binding<SelectionValue>, label: Label, @ViewBuilder content: () -> Content) { fatalError() }
}

/// A type that specifies the appearance and interaction of all pickers within
/// a view hierarchy.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol PickerStyle {
}

@available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
extension PickerStyle where Self == NavigationLinkPickerStyle {

    /// A picker style represented by a navigation link that presents the options
    /// by pushing a List-style picker view.
    ///
    /// In navigation stacks, prefer the default ``PickerStyle/menu`` style.
    /// Consider the navigation link style when you have a large number of
    /// options or your design is better expressed by pushing onto a stack.
    ///
    /// To apply this style to a picker, or to a view that contains pickers,
    /// use the ``View/pickerStyle(_:)`` modifier.
    public static var navigationLink: NavigationLinkPickerStyle { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
@available(watchOS, unavailable)
extension PickerStyle where Self == SegmentedPickerStyle {

    /// A picker style that presents the options in a segmented control.
    ///
    /// Use this style when there are two to five options. Consider using
    /// ``PickerStyle/menu`` when there are more than five options.
    ///
    /// For each option's label, use sentence-style capitalization without
    /// ending punctuation, like a period or colon.
    ///
    /// To apply this style to a picker, or to a view that contains pickers, use
    /// the ``View/pickerStyle(_:)`` modifier.
    public static var segmented: SegmentedPickerStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension PickerStyle where Self == InlinePickerStyle {

    /// A `PickerStyle` where each option is displayed inline with other views
    /// in the current container.
    public static var inline: InlinePickerStyle { get { fatalError() } }
}

@available(iOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension PickerStyle where Self == WheelPickerStyle {

    /// A picker style that presents the options in a scrollable wheel that
    /// shows the selected option and a few neighboring options.
    ///
    /// Because most options aren't visible, organize them in a predictable
    /// order, such as alphabetically.
    ///
    /// To apply this style to a picker, or to a view that contains pickers, use
    /// the ``View/pickerStyle(_:)`` modifier.
    public static var wheel: WheelPickerStyle { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension PickerStyle where Self == DefaultPickerStyle {

    /// The default picker style, based on the picker's context.
    ///
    /// How a picker using the default picker style appears largely depends on
    /// the platform and the view type in which it appears. For example, in a
    /// standard view, the default picker styles by platform are:
    ///
    /// * On iOS and watchOS the default is a wheel.
    /// * On macOS, the default is a pop-up button.
    /// * On tvOS, the default is a segmented control.
    ///
    /// The default picker style may also take into account other factors — like
    /// whether the picker appears in a container view — when setting the
    /// appearance of a picker.
    ///
    /// You can override a picker’s style. To apply the default style to a
    /// picker, or to a view that contains pickers, use the
    /// ``View/pickerStyle(_:)`` modifier.
    public static var automatic: DefaultPickerStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension PickerStyle where Self == MenuPickerStyle {

    /// A picker style that presents the options as a menu when the user presses a
    /// button, or as a submenu when nested within a larger menu.
    ///
    /// Use this style when there are more than five options. Consider using
    /// ``PickerStyle/inline`` when there are fewer than five options.
    ///
    /// The button itself indicates the selected option. You can include additional
    /// controls in the set of options, such as a button to customize the list of
    /// options.
    ///
    /// To apply this style to a picker, or to a view that contains pickers, use the
    /// ``View/pickerStyle(_:)`` modifier.
    public static var menu: MenuPickerStyle { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension PickerStyle where Self == PalettePickerStyle {

    /// A picker style that presents the options as a row of compact elements.
    ///
    /// - Note: When used outside of menus, this style is rendered as a
    /// segmented picker. If that is the intended usage, consider
    /// ``PickerStyle/segmented`` instead.
    ///
    /// For each option's label, use one symbol per item, if you add more than 6 options, the picker scrolls horizontally on iOS.
    ///
    /// The following example creates a palette picker:
    ///
    ///     enum Reaction: Identifiable, CaseIterable {
    ///         case thumbsup, thumbsdown, heart, questionMark
    ///         var id: Self { self }
    ///     }
    ///
    ///     @State private var selection: Reaction? = .none
    ///
    ///     var body: some View {
    ///         Menu("Reactions") {
    ///             Picker("Palette", selection: $selection) {
    ///                 Label("Thumbs up", systemImage: "hand.thumbsup")
    ///                     .tag(Reaction.thumbsup)
    ///                 Label("Thumbs down", systemImage: "hand.thumbsdown")
    ///                     .tag(Reaction.thumbsdown)
    ///                 Label("Like", systemImage: "heart")
    ///                     .tag(Reaction.heart)
    ///                 Label("Question mark", systemImage: "questionmark")
    ///                     .tag(Reaction.questionMark)
    ///             }
    ///             .pickerStyle(.palette)
    ///             Button("Reply...") { ... }
    ///         }
    ///     }
    ///
    /// Palette pickers will display the selection of untinted SF Symbols or
    /// template images by applying the system tint. For tinted SF Symbols, a
    /// stroke is outlined around the symbol upon selection. If you would like
    /// to supply a particular image (or SF Symbol) to signify selection, we
    /// suggest using ``PaletteSelectionEffect/custom``.
    /// This deactivates any system selection behavior, allowing the provided
    /// image to solely indicate selection instead.
    ///
    /// The following example creates a palette picker that disables the
    /// system selection behaviour:
    ///
    ///     Menu {
    ///         Picker("Palettes", selection: $selection) {
    ///             ForEach(palettes) { palette in
    ///                 Label(palette.title, systemImage: selection == palette ?
    ///                       "circle.dashed.inset.filled" : "circle.fill")
    ///                 .tint(palette.tint)
    ///                 .tag(palette)
    ///             }
    ///         }
    ///         .pickerStyle(.palette)
    ///         .paletteSelectionEffect(.custom)
    ///     } label: {
    ///         ...
    ///     }
    ///
    /// If a specific SF Symbol variant is preferable instead, use
    /// ``PaletteSelectionEffect/symbolVariant(_:)``:
    ///
    ///     Menu {
    ///         Picker("Flags", selection: $selectedFlag) {
    ///             ForEach(flags) { flag in
    ///                 Label(flag.title, systemImage: "flag")
    ///                     .tint(flag.color)
    ///                     .tag(flag)
    ///             }
    ///         }
    ///         .pickerStyle(.palette)
    ///         .paletteSelectionEffect(.symbolVariant(.slash))
    ///     } label: {
    ///         ...
    ///     }
    ///
    /// To apply this style to a picker, or to a view that contains pickers, use
    /// the ``View/pickerStyle(_:)`` modifier.
    public static var palette: PalettePickerStyle { get { fatalError() } }
}
