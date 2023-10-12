// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// Erase the generic Label to facilitate specialized constructor support.
public struct Picker</* Label, */ SelectionValue, Content> : View where /* Label : View, */ SelectionValue : Hashable, Content : View {
    @available(*, unavailable)
    public init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
    }

    @available(*, unavailable)
    public init(_ title: String, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}

// Model `PickerStyle` a struct. Kotlin does not support static members of protocols
public struct PickerStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    @available(*, unavailable)
    public static let automatic = PickerStyle(rawValue: 1)

    @available(*, unavailable)
    public static let navigationLink = PickerStyle(rawValue: 2)

    @available(*, unavailable)
    public static let segmented = PickerStyle(rawValue: 3)

    @available(*, unavailable)
    public static let inline = PickerStyle(rawValue: 4)

    @available(*, unavailable)
    public static let wheel = PickerStyle(rawValue: 5)

    @available(*, unavailable)
    public static let menu = PickerStyle(rawValue: 6)

    @available(*, unavailable)
    public static let palette = PickerStyle(rawValue: 7)
}

extension View {
    public func pickerStyle(_ style: PickerStyle) -> some View {
        return self
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

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
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Picker /* where Label == Text */ {

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

#endif
