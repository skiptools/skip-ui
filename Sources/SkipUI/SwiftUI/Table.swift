// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import class Foundation.NSObject
import protocol Foundation.SortComparator
import struct Foundation.KeyPathComparator
import struct Foundation.Date
import struct Foundation.UUID
import struct Foundation.SortDescriptor
#if canImport(UIKit)
import class UIKit.NSItemProvider
#endif

/// A container that presents rows of data arranged in one or more columns,
/// optionally providing the ability to select one or more members.
///
/// You commonly create tables from collections of data. The following example
/// shows how to create a simple, three-column table from an array of `Person`
/// instances that conform to the
/// <doc://com.apple.documentation/documentation/Swift/Identifiable> protocol:
///
///     struct Person: Identifiable {
///         let givenName: String
///         let familyName: String
///         let emailAddress: String
///         let id = UUID()
///
///         var fullName: String { givenName + " " + familyName }
///     }
///
///     @State private var people = [
///         Person(givenName: "Juan", familyName: "Chavez", emailAddress: "juanchavez@icloud.com"),
///         Person(givenName: "Mei", familyName: "Chen", emailAddress: "meichen@icloud.com"),
///         Person(givenName: "Tom", familyName: "Clark", emailAddress: "tomclark@icloud.com"),
///         Person(givenName: "Gita", familyName: "Kumar", emailAddress: "gitakumar@icloud.com")
///     ]
///
///     struct PeopleTable: View {
///         var body: some View {
///             Table(people) {
///                 TableColumn("Given Name", value: \.givenName)
///                 TableColumn("Family Name", value: \.familyName)
///                 TableColumn("E-Mail Address", value: \.emailAddress)
///             }
///         }
///     }
///
/// ![A table with three columns and four rows, showing the
/// given name, family name, and email address of four people. Nonsortable
/// column headers at the top of the table indicate the data each column
/// displays.](Table-1-iOS)
///
/// If there are more rows than can fit in the available space, `Table` provides
/// vertical scrolling automatically. On macOS, the table also provides
/// horizontal scrolling if there are more columns than can fit in the width of the view. Scroll bars
/// appear as needed on iOS; on macOS, the `Table` shows or hides
/// scroll bars based on the "Show scroll bars" system preference.
///
/// ### Supporting selection in tables
///
/// To make rows of a table selectable, provide a binding to a selection
/// variable. Binding to a single instance of the table data's
/// <doc://com.apple.documentation/documentation/Swift/Identifiable/3285392-id>
/// type creates a single-selection table. Binding to a
/// <doc://com.apple.documentation/documentation/Swift/Set> creates a table that
/// supports multiple selections. The following example shows how to add
/// multi-select to the previous example. A ``Text`` view below the table shows
/// the number of items currently selected.
///
///     struct SelectableTable: View {
///         @State private var selectedPeople = Set<Person.ID>()
///
///         var body: some View {
///             Table(people, selection: $selectedPeople) {
///                 TableColumn("Given Name", value: \.givenName)
///                 TableColumn("Family Name", value: \.familyName)
///                 TableColumn("E-Mail Address", value: \.emailAddress)
///             }
///             Text("\(selectedPeople.count) people selected")
///         }
///     }
///
/// ### Supporting sorting in tables
///
/// To make the columns of a table sortable, provide a binding to an array
/// of <doc://com.apple.documentation/documentation/Foundation/SortComparator>
/// instances. The table reflects the sorted state through its column
/// headers, allowing sorting for any columns with key paths.
///
/// When the table sort descriptors update, re-sort the data collection
/// that underlies the table; the table itself doesn't perform a sort operation.
/// You can watch for changes in the sort descriptors by using a
/// ``View/onChange(of:perform:)`` modifier, and then sort the data in the
/// modifier's `perform` closure.
///
/// The following example shows how to add sorting capability to the
/// previous example:
///
///     struct SortableTable: View {
///         @State private var sortOrder = [KeyPathComparator(\Person.givenName)]
///
///         var body: some View {
///             Table(people, sortOrder: $sortOrder) {
///                 TableColumn("Given Name", value: \.givenName)
///                 TableColumn("Family Name", value: \.familyName)
///                 TableColumn("E-Mail address", value: \.emailAddress)
///             }
///             .onChange(of: sortOrder) {
///                 people.sort(using: $0)
///             }
///         }
///     }
///
/// ### Building tables with static rows
///
/// To create a table from static rows, rather than the contents of a collection
/// of data, you provide both the columns and the rows.
///
/// The following example shows a table that calculates prices from applying
/// varying gratuities ("tips") to a fixed set of prices. It creates the table
/// with the ``Table/init(of:columns:rows:)`` initializer, with the `rows`
/// parameter providing the base price that each row uses for its calculations. Each
/// column receives each price and performs its calculation, producing a
/// ``Text`` to display the formatted result.
///
///     struct Purchase: Identifiable {
///         let price: Decimal
///         let id = UUID()
///     }
///
///     struct TipTable: View {
///         let currencyStyle = Decimal.FormatStyle.Currency(code: "USD")
///
///         var body: some View {
///             Table(of: Purchase.self) {
///                 TableColumn("Base price") { purchase in
///                     Text(purchase.price, format: currencyStyle)
///                 }
///                 TableColumn("With 15% tip") { purchase in
///                     Text(purchase.price * 1.15, format: currencyStyle)
///                 }
///                 TableColumn("With 20% tip") { purchase in
///                     Text(purchase.price * 1.2, format: currencyStyle)
///                 }
///                 TableColumn("With 25% tip") { purchase in
///                     Text(purchase.price * 1.25, format: currencyStyle)
///                 }
///             } rows: {
///                 TableRow(Purchase(price: 20))
///                 TableRow(Purchase(price: 50))
///                 TableRow(Purchase(price: 75))
///             }
///         }
///     }
///
/// ![A table with four columns and three rows. Each row of the
/// table shows a base price — $20, $50, and $75 — followed in subsequent
/// columns by a dollar value calculated by applying a tip — 15%, 20%, and 25% —
/// to the base amount.](Table-2-macOS)
///
/// ### Styling tables
///
/// Use the ``View/tableStyle(_:)`` modifier to set a ``TableStyle`` for all
/// tables within a view. SkipUI provides several table styles, such as
/// ``InsetTableStyle`` and, on macOS, ``BorderedTableStyle``. The default
/// style is ``AutomaticTableStyle``, which is available on all platforms
/// that support `Table`.
///
/// ### Using tables on different platforms
///
/// You can define a single table for use on macOS, iOS, and iPadOS.
/// However, in a compact horizontal size class environment --- typical on
/// iPhone or on iPad in certain modes, like Slide Over --- the table has
/// limited space to display its columns. To conserve space, the table
/// automatically hides headers and all columns after the first when it detects
/// this condition.
///
/// To provide a good user experience in a space-constrained environment, you
/// can customize the first column to show more information when you detect that
/// the ``EnvironmentValues/horizontalSizeClass`` environment value becomes
/// ``UserInterfaceSizeClass/compact``. For example, you can modify the sortable
/// table from above to conditionally show all the information in
/// the first column:
///
///     struct CompactableTable: View {
///         #if os(iOS)
///         @Environment(\.horizontalSizeClass) private var horizontalSizeClass
///         private var isCompact: Bool { horizontalSizeClass == .compact }
///         #else
///         private let isCompact = false
///         #endif
///
///         @State private var sortOrder = [KeyPathComparator(\Person.givenName)]
///
///         var body: some View {
///             Table(people, sortOrder: $sortOrder) {
///                 TableColumn("Given Name", value: \.givenName) { person in
///                     VStack(alignment: .leading) {
///                         Text(isCompact ? person.fullName : person.givenName)
///                         if isCompact {
///                             Text(person.emailAddress)
///                                 .foregroundStyle(.secondary)
///                         }
///                     }
///                 }
///                 TableColumn("Family Name", value: \.familyName)
///                 TableColumn("E-Mail Address", value: \.emailAddress)
///             }
///             .onChange(of: sortOrder) {
///                 people.sort(using: $0)
///             }
///         }
///     }
///
/// By making this change, you provide a list-like appearance for narrower
/// displays, while displaying the full table on wider ones.
/// Because you use the same table instance in both cases, you get a seamless
/// transition when the size class changes, like when someone moves your app
/// into or out of Slide Over.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct Table<Value, Rows, Columns> : View where Value == Rows.TableRowValue, Rows : TableRowContent, Columns : TableColumnContent, Rows.TableRowValue == Columns.TableRowValue {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Table {

    /// Creates a table with the given columns and rows that generates its contents using values of the
    /// given type.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init(of valueType: Value.Type, @TableColumnBuilder<Value, Never> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) { fatalError() }

    /// Creates a table with the given columns and rows that supports selecting
    /// zero or one row that generates its data using values of the given type.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - selection: A binding to the optional selected row ID.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init(of valueType: Value.Type, selection: Binding<Value.ID?>, @TableColumnBuilder<Value, Never> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) { fatalError() }

    /// Creates a table with the given columns and rows that supports selecting
    /// multiple rows that generates its data using values of the given type.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - selection: A binding to a set that identifies the selected rows IDs.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init(of valueType: Value.Type, selection: Binding<Set<Value.ID>>, @TableColumnBuilder<Value, Never> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) { fatalError() }

    /// Creates a sortable table with the given columns and rows.
    ///
    /// - Parameters:
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init<Sort>(sortOrder: Binding<[Sort]>, @TableColumnBuilder<Value, Sort> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) where Sort : SortComparator, Columns.TableRowValue == Sort.Compared { fatalError() }

    /// Creates a sortable table with the given columns and rows.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init<Sort>(of valueType: Value.Type, sortOrder: Binding<[Sort]>, @TableColumnBuilder<Value, Sort> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) where Sort : SortComparator, Columns.TableRowValue == Sort.Compared { fatalError() }

    /// Creates a sortable table with the given columns and rows that supports
    /// selecting zero or one row.
    ///
    /// - Parameters:
    ///   - selection: A binding to the optional selected row ID.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init<Sort>(selection: Binding<Value.ID?>, sortOrder: Binding<[Sort]>, @TableColumnBuilder<Value, Sort> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) where Sort : SortComparator, Columns.TableRowValue == Sort.Compared { fatalError() }

    /// Creates a sortable table with the given columns and rows that supports
    /// selecting zero or one row.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - selection: A binding to the optional selected row ID.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init<Sort>(of valueType: Value.Type, selection: Binding<Value.ID?>, sortOrder: Binding<[Sort]>, @TableColumnBuilder<Value, Sort> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) where Sort : SortComparator, Columns.TableRowValue == Sort.Compared { fatalError() }

    /// Creates a sortable table with the given columns and rows that supports
    /// selecting multiple rows.
    ///
    /// - Parameters:
    ///   - selection: A binding to a set that identifies selected rows ids.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init<Sort>(selection: Binding<Set<Value.ID>>, sortOrder: Binding<[Sort]>, @TableColumnBuilder<Value, Sort> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) where Sort : SortComparator, Columns.TableRowValue == Sort.Compared { fatalError() }

    /// Creates a sortable table with the given columns and rows that supports
    /// selecting multiple rows.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - selection: A binding to a set that identifies selected rows ids.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init<Sort>(of valueType: Value.Type, selection: Binding<Set<Value.ID>>, sortOrder: Binding<[Sort]>, @TableColumnBuilder<Value, Sort> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) where Sort : SortComparator, Columns.TableRowValue == Sort.Compared { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Table {

    /// Creates a table that computes its rows based on a collection of
    /// identifiable data.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - columns: The columns to display in the table.
    public init<Data>(_ data: Data, @TableColumnBuilder<Value, Never> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Columns.TableRowValue == Data.Element { fatalError() }

    /// Creates a table that computes its rows based on a collection of
    /// identifiable data, and that supports selecting zero or one row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - selection: A binding to the optional selected row ID.
    ///   - columns: The columns to display in the table.
    public init<Data>(_ data: Data, selection: Binding<Value.ID?>, @TableColumnBuilder<Value, Never> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Columns.TableRowValue == Data.Element { fatalError() }

    /// Creates a table that computes its rows based on a collection of
    /// identifiable data, and that supports selecting multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - selection: A binding to a set that identifies selected rows IDs.
    ///   - columns: The columns to display in the table.
    public init<Data>(_ data: Data, selection: Binding<Set<Value.ID>>, @TableColumnBuilder<Value, Never> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Columns.TableRowValue == Data.Element { fatalError() }

    /// Creates a sortable table that computes its rows based on a collection of
    /// identifiable data.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columns: The columns to display in the table.
    public init<Data, Sort>(_ data: Data, sortOrder: Binding<[Sort]>, @TableColumnBuilder<Value, Sort> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Sort : SortComparator, Columns.TableRowValue == Data.Element, Data.Element == Sort.Compared { fatalError() }

    /// Creates a sortable table that computes its rows based on a collection of
    /// identifiable data, and supports selecting zero or one row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - selection: A binding to the optional selected row ID.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columns: The columns to display in the table.
    public init<Data, Sort>(_ data: Data, selection: Binding<Value.ID?>, sortOrder: Binding<[Sort]>, @TableColumnBuilder<Value, Sort> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Sort : SortComparator, Columns.TableRowValue == Data.Element, Data.Element == Sort.Compared { fatalError() }

    /// Creates a sortable table that computes its rows based on a collection of
    /// identifiable data, and supports selecting multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - selection: A binding to a set that identifies selected rows IDs.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columns: The columns to display in the table.
    public init<Data, Sort>(_ data: Data, selection: Binding<Set<Value.ID>>, sortOrder: Binding<[Sort]>, @TableColumnBuilder<Value, Sort> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Sort : SortComparator, Columns.TableRowValue == Data.Element, Data.Element == Sort.Compared { fatalError() }
}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Table {

    /// Creates a table with the given columns and rows that generates its
    /// contents using values of the given type and has dynamically customizable
    /// columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init(of valueType: Value.Type, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Never> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) { fatalError() }

    /// Creates a table with the given columns and rows that supports selecting
    /// zero or one row that generates its data using values of the given type
    /// and has dynamically customizable columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - selection: A binding to the optional selected row ID.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init(of valueType: Value.Type, selection: Binding<Value.ID?>, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Never> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) { fatalError() }

    /// Creates a table with the given columns and rows that supports selecting
    /// multiple rows that generates its data using values of the given type
    /// and has dynamically customizable columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - selection: A binding to a set that identifies the selected rows IDs.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init(of valueType: Value.Type, selection: Binding<Set<Value.ID>>, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Never> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) { fatalError() }

    /// Creates a sortable table with the given columns and rows and has
    /// dynamically customizable columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init<Sort>(of valueType: Value.Type = Value.self, sortOrder: Binding<[Sort]>, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Sort> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) where Sort : SortComparator, Columns.TableRowValue == Sort.Compared { fatalError() }

    /// Creates a sortable table with the given columns and rows that supports
    /// selecting zero or one row and has dynamically customizable columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - selection: A binding to the optional selected row ID.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init<Sort>(of valueType: Value.Type = Value.self, selection: Binding<Value.ID?>, sortOrder: Binding<[Sort]>, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Sort> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) where Sort : SortComparator, Columns.TableRowValue == Sort.Compared { fatalError() }

    /// Creates a sortable table with the given columns and rows that supports
    /// selecting multiple rows and dynamically customizable columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - valueType: The type of value used to derive the table's contents.
    ///   - selection: A binding to a set that identifies selected rows ids.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    ///   - rows: The rows to display in the table.
    public init<Sort>(of valueType: Value.Type = Value.self, selection: Binding<Set<Value.ID>>, sortOrder: Binding<[Sort]>, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Sort> columns: () -> Columns, @TableRowBuilder<Value> rows: () -> Rows) where Sort : SortComparator, Columns.TableRowValue == Sort.Compared { fatalError() }

    /// Creates a table that computes its rows based on a collection of
    /// identifiable data and has dynamically customizable columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data>(_ data: Data, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Never> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Columns.TableRowValue == Data.Element { fatalError() }

    /// Creates a table that computes its rows based on a collection of
    /// identifiable data, that supports selecting zero or one row, and that has
    /// dynamically customizable columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - selection: A binding to the optional selected row ID.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data>(_ data: Data, selection: Binding<Value.ID?>, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Never> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Columns.TableRowValue == Data.Element { fatalError() }

    /// Creates a table that computes its rows based on a collection of
    /// identifiable data, that supports selecting multiple rows, and that has
    /// dynamically customizable columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - selection: A binding to a set that identifies selected rows IDs.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data>(_ data: Data, selection: Binding<Set<Value.ID>>, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Never> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Columns.TableRowValue == Data.Element { fatalError() }

    /// Creates a sortable table that computes its rows based on a collection of
    /// identifiable data and has dynamically customizable columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data, Sort>(_ data: Data, sortOrder: Binding<[Sort]>, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Sort> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Sort : SortComparator, Columns.TableRowValue == Data.Element, Data.Element == Sort.Compared { fatalError() }

    /// Creates a sortable table that computes its rows based on a collection of
    /// identifiable data, supports selecting zero or one row, and has
    /// dynamically customizable columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - selection: A binding to the optional selected row ID.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data, Sort>(_ data: Data, selection: Binding<Value.ID?>, sortOrder: Binding<[Sort]>, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Sort> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Sort : SortComparator, Columns.TableRowValue == Data.Element, Data.Element == Sort.Compared { fatalError() }

    /// Creates a sortable table that computes its rows based on a collection of
    /// identifiable data, supports selecting multiple rows, and has dynamically
    /// customizable columns.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - selection: A binding to a set that identifies selected rows IDs.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data, Sort>(_ data: Data, selection: Binding<Set<Value.ID>>, sortOrder: Binding<[Sort]>, columnCustomization: Binding<TableColumnCustomization<Value>>, @TableColumnBuilder<Value, Sort> columns: () -> Columns) where Rows == TableForEachContent<Data>, Data : RandomAccessCollection, Sort : SortComparator, Columns.TableRowValue == Data.Element, Data.Element == Sort.Compared { fatalError() }
}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Table {

    /// Creates a hierarchical table that computes its rows based on a
    /// collection of identifiable data and key path to the children of that
    /// data.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`, and whose `nil` value represents a leaf row of
    ///     the hierarchy, which is not capable of having children.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data>(_ data: Data, children: KeyPath<Value, Data?>, columnCustomization: Binding<TableColumnCustomization<Value>>? = nil, @TableColumnBuilder<Value, Never> columns: () -> Columns) where Rows == TableOutlineGroupContent<Data>, Data : RandomAccessCollection, Columns.TableRowValue == Data.Element { fatalError() }

    /// Creates a hierarchical table that computes its rows based on a
    /// collection of identifiable data and key path to the children of that
    /// data, and supports selecting zero or one row.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`, and whose `nil` value represents a leaf row of
    ///     the hierarchy, which is not capable of having children.
    ///   - selection: A binding to the optional selected row ID.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Value.ID?>, columnCustomization: Binding<TableColumnCustomization<Value>>? = nil, @TableColumnBuilder<Value, Never> columns: () -> Columns) where Rows == TableOutlineGroupContent<Data>, Data : RandomAccessCollection, Columns.TableRowValue == Data.Element { fatalError() }

    /// Creates a hierarchical table that computes its rows based on a
    /// collection of identifiable data and key path to the children of that
    /// data, and supports selecting multiple rows.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`, and whose `nil` value represents a leaf row of
    ///     the hierarchy, which is not capable of having children.
    ///   - selection: A binding to a set that identifies selected rows IDs.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<Value.ID>>, columnCustomization: Binding<TableColumnCustomization<Value>>? = nil, @TableColumnBuilder<Value, Never> columns: () -> Columns) where Rows == TableOutlineGroupContent<Data>, Data : RandomAccessCollection, Columns.TableRowValue == Data.Element { fatalError() }

    /// Creates a sortable, hierarchical table that computes its rows based on a
    /// collection of identifiable data and key path to the children of that
    /// data.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`, and whose `nil` value represents a leaf row of
    ///     the hierarchy, which is not capable of having children.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data, Sort>(_ data: Data, children: KeyPath<Data.Element, Data?>, sortOrder: Binding<[Sort]>, columnCustomization: Binding<TableColumnCustomization<Value>>? = nil, @TableColumnBuilder<Value, Sort> columns: () -> Columns) where Rows == TableOutlineGroupContent<Data>, Data : RandomAccessCollection, Sort : SortComparator, Columns.TableRowValue == Data.Element, Data.Element == Sort.Compared { fatalError() }

    /// Creates a sortable, hierarchical table that computes its rows based on a
    /// collection of identifiable data and key path to the children of that
    /// data, and supports selecting zero or one row.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`, and whose `nil` value represents a leaf row of
    ///     the hierarchy, which is not capable of having children.
    ///   - selection: A binding to the optional selected row ID.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data, Sort>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Value.ID?>, sortOrder: Binding<[Sort]>, columnCustomization: Binding<TableColumnCustomization<Value>>? = nil, @TableColumnBuilder<Value, Sort> columns: () -> Columns) where Rows == TableOutlineGroupContent<Data>, Data : RandomAccessCollection, Sort : SortComparator, Columns.TableRowValue == Data.Element, Data.Element == Sort.Compared { fatalError() }

    /// Creates a sortable, hierarchical table that computes its rows based on a
    /// collection of identifiable data and key path to the children of that
    /// data, and supports selecting multiple rows.
    ///
    /// Each column in the table that should participate in customization is
    /// required to have an identifier, specified with
    /// ``TableColumnContent/customizationID(_:)``.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the table rows.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`, and whose `nil` value represents a leaf row of
    ///     the hierarchy, which is not capable of having children.
    ///   - selection: A binding to a set that identifies selected rows IDs.
    ///   - sortOrder: A binding to the ordered sorting of columns.
    ///   - columnCustomization: A binding to the state of columns.
    ///   - columns: The columns to display in the table.
    public init<Data, Sort>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<Value.ID>>, sortOrder: Binding<[Sort]>, columnCustomization: Binding<TableColumnCustomization<Value>>? = nil, @TableColumnBuilder<Value, Sort> columns: () -> Columns) where Rows == TableOutlineGroupContent<Data>, Data : RandomAccessCollection, Sort : SortComparator, Columns.TableRowValue == Data.Element, Data.Element == Sort.Compared { fatalError() }
}

/// A column that displays a view for each row in a table.
///
/// You create a column with a label, content view, and optional key path.
/// The table calls the content view builder with the value for each row
/// in the table. The column uses a key path to map to a property of each row
/// value, which sortable tables use to reflect the current sort order.
///
/// The following example creates a sortable column for a table with `Person`
/// rows, displaying each person's given name:
///
///     TableColumn("Given name", value: \.givenName) { person in
///         Text(person.givenName)
///     }
///
/// For the common case of `String` properties, you can use the convenience
/// initializer that doesn't require an explicit content closure and displays
/// that string verbatim as a ``Text`` view. This means you can write the
/// previous example as:
///
///     TableColumn("Given name", value: \.givenName)
///
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TableColumn<RowValue, Sort, Content, Label> : TableColumnContent where RowValue : Identifiable, Sort : SortComparator, Content : View, Label : View {

    /// The type of value of rows presented by this column content.
    public typealias TableRowValue = RowValue

    /// The type of sort comparator associated with this table column content.
    public typealias TableColumnSortComparator = Sort

    /// The type of content representing the body of this table column content.
    public typealias TableColumnBody = Never

    public var tableColumnBody: TableColumnBody { fatalError()}
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumn where Sort == KeyPathComparator<RowValue>, Label == Text {

    /// Creates a sortable column for comparable values that generates its label
    /// from a localized string key.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<V>(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, V>, @ViewBuilder content: @escaping (RowValue) -> Content) where V : Comparable { fatalError() }

    /// Creates a sortable column for comparable values that generates its label
    /// from a string.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S, V>(_ title: S, value: KeyPath<RowValue, V>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol, V : Comparable { fatalError() }

    /// Creates a sortable column for comparable values with a text label.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init<V>(_ text: Text, value: KeyPath<RowValue, V>, @ViewBuilder content: @escaping (RowValue) -> Content) where V : Comparable { fatalError() }

    /// Creates a sortable column that generates its label from a localized
    /// string key, and uses an explicit comparator for sorting values.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - comparator: The `SortComparator` used to order values of the sort
    ///     value type.
    ///   - content: The view content to display for each row in a table.
    public init<V, C>(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, V>, comparator: C, @ViewBuilder content: @escaping (RowValue) -> Content) where V == C.Compared, C : SortComparator { fatalError() }

    /// Creates a sortable column that generates its label from a string, and
    /// uses an explicit comparator for sorting values.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - comparator: The `SortComparator` used to order values of the sort
    ///     value type.
    ///   - content: The view content to display for each row in a table.
    public init<S, V, C>(_ title: S, value: KeyPath<RowValue, V>, comparator: C, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol, V == C.Compared, C : SortComparator { fatalError() }

    /// Creates a sortable column that has a text label, and uses an explicit
    /// comparator for sorting values.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - comparator: The `SortComparator` used to order values of the sort
    ///     value type.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init<V, C>(_ text: Text, value: KeyPath<RowValue, V>, comparator: C, @ViewBuilder content: @escaping (RowValue) -> Content) where V == C.Compared, C : SortComparator { fatalError() }

    /// Creates a sortable column that displays a string property, and
    /// generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     to display verbatim as text in each row of a table,
    ///     and the key path used to create a sort comparator when
    ///     sorting the column.
    ///   - comparator: The `SortComparator` used to order the string values.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, String>, comparator: String.StandardComparator = .localizedStandard) where Content == Text { fatalError() }

    /// Creates a sortable column that displays a string property, and
    /// generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     to display verbatim as text in each row of a table,
    ///     and the key path used to create a sort comparator when
    ///     sorting the column.
    ///   - comparator: The `SortComparator` used to order the string values.
    public init<S>(_ title: S, value: KeyPath<RowValue, String>, comparator: String.StandardComparator = .localizedStandard) where Content == Text, S : StringProtocol { fatalError() }

    /// Creates a sortable column that displays a string property and
    /// has a text label.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     to display verbatim as text in each row of a table,
    ///     and the key path used to create a sort comparator when
    ///     sorting the column.
    ///   - comparator: The `SortComparator` used to order the string values.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, String>, comparator: String.StandardComparator = .localizedStandard) where Content == Text { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumn where RowValue == Sort.Compared, Label == Text {

    /// Creates a sortable column that generates its label from a localized
    /// string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``.
    /// For more information about localizing strings, see``Text``.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - comparator: The prototype sort comparator to use when representing
    ///     this column. When a person taps or clicks the column header,
    ///     the containing table's `sortOrder` incorporates this value,
    ///     potentially with a flipped order.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, sortUsing comparator: Sort, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column that generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - comparator: The prototype sort comparator to use when representing
    ///     this column. When a person taps or clicks the column header,
    ///     the containing table's `sortOrder` incorporates this value,
    ///     potentially with a flipped order.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, sortUsing comparator: Sort, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column with text label.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - comparator: The prototype sort comparator to use when representing
    ///     this column. When a person taps or clicks the column header,
    ///     the containing table's `sortOrder` incorporates this value,
    ///     potentially with a flipped order.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, sortUsing comparator: Sort, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumn where Sort == Never, Label == Text {

    /// Creates an unsortable column that generates its label from a localized
    /// string key.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates an unsortable column that generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``.
    /// For information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates an unsortable column with a text label
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``.
    /// For information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates an unsortable column that displays a string property that
    /// generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column.
    ///     The table uses this to display the property as verbatim text in each
    ///     row of the table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, String>) where Content == Text { fatalError() }

    /// Creates an unsortable column that displays a string property that
    /// generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``.
    /// For information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column.
    ///     The table uses this to display the property as verbatim text in each
    ///     row of the table.
    public init<S>(_ title: S, value: KeyPath<RowValue, String>) where Content == Text, S : StringProtocol { fatalError() }

    /// Creates an unsortable column that displays a string property with a
    /// text label.
    ///
    /// This initializer creates a ``Text`` view for you, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``.
    /// For more information about localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column.
    ///     The table uses this to display the property as verbatim text in each
    ///     row of the table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, String>) where Content == Text { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumn {

    /// Creates a fixed width table column that isn't user resizable.
    ///
    /// - Parameter width: A fixed width for the resulting column. If `width`
    ///   is `nil`, the resulting column has no change in sizing.
    public func width(_ width: CGFloat? = nil) -> TableColumn<RowValue, Sort, Content, Label> { fatalError() }

    /// Creates a resizable table column with the provided constraints.
    ///
    /// Always specify at least one width constraint when calling this method.
    /// Pass `nil` or leave out a constraint to indicate no change to the
    /// sizing of a column.
    ///
    /// To create a fixed size column use ``SkipUI/TableColumn/width(_:)``
    /// instead.
    ///
    /// - Parameters:
    ///   - min: The minimum width of a resizable column. If non-`nil`, the
    ///     value must be greater than or equal to `0`.
    ///   - ideal: The ideal width of the column, used to determine the initial
    ///     width of the table column. The column always starts at least as
    ///     large as the set ideal size, but may be larger if table was sized
    ///     larger than the ideal of all of its columns.
    ///   - max: The maximum width of a resizable column. If non-`nil`, the
    ///     value must be greater than `0`. Pass
    ///     <doc://com.apple.documentation/documentation/CoreGraphics/CGFloat/1454161-infinity>
    ///     to indicate unconstrained maximum width.
    public func width(min: CGFloat? = nil, ideal: CGFloat? = nil, max: CGFloat? = nil) -> TableColumn<RowValue, Sort, Content, Label> { fatalError() }

    /// Does not change the table column's width.
    ///
    /// Use ``SkipUI/TableColumn/width(_:)`` or
    /// ``SkipUI/TableColumn/width(min:ideal:max:)`` instead.
    @available(*, deprecated, message: "Please pass one or more parameters to modify a column's width.")
    public func width() -> TableColumn<RowValue, Sort, Content, Label> { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumn where RowValue : NSObject, Sort == SortDescriptor<RowValue>, Label == Text {

    /// Creates a sortable column for Boolean values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Bool>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for Boolean
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Bool>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for Boolean values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Bool>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional Boolean values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Bool?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional Boolean values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Bool?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional Boolean values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Bool?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for double-precision floating-point values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Double>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for double-precision floating-point
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Double>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for double-precision floating-point values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Double>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional double-precision floating-point values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Double?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional double-precision floating-point values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Double?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional double-precision floating-point values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Double?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for single-precision floating-point values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Float>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for single-precision floating-point
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Float>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for single-precision floating-point values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Float>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional single-precision floating-point values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Float?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional single-precision floating-point values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Float?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional single-precision floating-point values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Float?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for 8-bit integer values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Int8>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for 8-bit integer
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Int8>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for 8-bit integer values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Int8>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional 8-bit integer values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Int8?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional 8-bit integer values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Int8?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional 8-bit integer values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Int8?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for 16-bit integer values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Int16>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for 16-bit integer
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Int16>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for 16-bit integer values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Int16>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional 16-bit integer values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Int16?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional 16-bit integer values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Int16?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional 16-bit integer values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Int16?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for 32-bit integer values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Int32>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for 32-bit integer
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Int32>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for 32-bit integer values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Int32>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional 32-bit integer values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Int32?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional 32-bit integer values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Int32?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional 32-bit integer values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Int32?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for 64-bit integer values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Int64>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for 64-bit integer
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Int64>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for 64-bit integer values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Int64>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional 64-bit integer values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Int64?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional 64-bit integer values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Int64?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional 64-bit integer values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Int64?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for integer values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Int>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for integer
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Int>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for integer values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Int>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional integer values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Int?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional integer values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Int?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional integer values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Int?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for unsigned 8-bit integer values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UInt8>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for unsigned 8-bit integer
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UInt8>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for unsigned 8-bit integer values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UInt8>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional unsigned 8-bit integer values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UInt8?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional unsigned 8-bit integer values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UInt8?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional unsigned 8-bit integer values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UInt8?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for unsigned 16-bit integer values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UInt16>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for unsigned 16-bit integer
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UInt16>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for unsigned 16-bit integer values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UInt16>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional unsigned 16-bit integer values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UInt16?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional unsigned 16-bit integer values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UInt16?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional unsigned 16-bit integer values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UInt16?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for unsigned 32-bit integer values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UInt32>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for unsigned 32-bit integer
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UInt32>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for unsigned 32-bit integer values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UInt32>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional unsigned 32-bit integer values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UInt32?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional unsigned 32-bit integer values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UInt32?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional unsigned 32-bit integer values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UInt32?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for unsigned 64-bit integer values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UInt64>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for unsigned 64-bit integer
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UInt64>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for unsigned 64-bit integer values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UInt64>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional unsigned 64-bit integer values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UInt64?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional unsigned 64-bit integer values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UInt64?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional unsigned 64-bit integer values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UInt64?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for unsigned integer values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UInt>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for unsigned integer
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UInt>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for unsigned integer values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UInt>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional unsigned integer values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UInt?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional unsigned integer values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UInt?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional unsigned integer values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UInt?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for date values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Date>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for date
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Date>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for date values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Date>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional date values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, Date?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional date values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, Date?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional date values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, Date?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for UUID values
    /// that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UUID>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for UUID
    /// values that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UUID>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for UUID values with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     which will be used to update and reflect the sorting state in a
    ///     table.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UUID>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional UUID values that generates
    /// its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, UUID?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column for optional UUID values that displays a
    /// string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, UUID?>, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column for optional UUID values with a text
    /// label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, UUID?>, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column that generates its label from a localized
    /// string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - comparator: The specific comparator to compare string values.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, String>, comparator: String.StandardComparator = .localizedStandard, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - comparator: The specific comparator to compare string values.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, String>, comparator: String.StandardComparator = .localizedStandard, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column with a text label.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - comparator: The specific comparator to compare string values.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, String>, comparator: String.StandardComparator = .localizedStandard, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column that generates its label from a localized
    /// string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - comparator: The specific comparator to compare string values.
    ///   - content: The view content to display for each row in a table.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, String?>, comparator: String.StandardComparator = .localizedStandard, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates a sortable column that displays a string property.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - comparator: The specific comparator to compare string values.
    ///   - content: The view content to display for each row in a table.
    public init<S>(_ title: S, value: KeyPath<RowValue, String?>, comparator: String.StandardComparator = .localizedStandard, @ViewBuilder content: @escaping (RowValue) -> Content) where S : StringProtocol { fatalError() }

    /// Creates a sortable column with a text label.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state.
    ///   - comparator: The specific comparator to compare string values.
    ///   - content: The view content to display for each row in a table.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, String?>, comparator: String.StandardComparator = .localizedStandard, @ViewBuilder content: @escaping (RowValue) -> Content) { fatalError() }

    /// Creates an unsortable column that displays a string property, and which
    /// generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the column's localized title.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state and to display as verbatim
    ///     text in each row.
    ///   - comparator: The specific comparator to compare string values.
    public init(_ titleKey: LocalizedStringKey, value: KeyPath<RowValue, String>, comparator: String.StandardComparator = .localizedStandard) where Content == Text { fatalError() }

    /// Creates a sortable column that displays a string property, and which
    /// generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. For more information about
    /// localizing strings, see ``Text``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the column.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state and to display as verbatim
    ///     text in each row.
    ///   - comparator: The specific comparator to compare string values.
    public init<S>(_ title: S, value: KeyPath<RowValue, String>, comparator: String.StandardComparator = .localizedStandard) where Content == Text, S : StringProtocol { fatalError() }

    /// Creates an unsortable column that displays a string property and has a
    /// text label.
    ///
    /// - Parameters:
    ///   - text: The column's label.
    ///   - value: The path to the property associated with the column,
    ///     used to update the table's sorting state and to display as verbatim
    ///     text in each row.
    ///   - comparator: The specific comparator to compare string values.
    @available(iOS 16.6, macOS 13.5, *)
    public init(_ text: Text, value: KeyPath<RowValue, String>, comparator: String.StandardComparator = .localizedStandard) where Content == Text { fatalError() }
}

/// A result builder that creates table column content from closures.
///
/// The `buildBlock` methods in this type create ``TableColumnContent``
/// instances based on the number and types of sources provided as parameters.
///
/// Don't use this type directly; instead, SkipUI annotates the `columns`
/// parameter of the various ``Table`` initializers with the
/// `@TableColumnBuilder` annotation, implicitly calling this builder for you.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@resultBuilder public struct TableColumnBuilder<RowValue, Sort> where RowValue : Identifiable, Sort : SortComparator {

    /// Creates a sortable table column expression whose value and sort types
    /// match those of the builder.
    public static func buildExpression<Content, Label>(_ column: TableColumn<RowValue, Sort, Content, Label>) -> TableColumn<RowValue, Sort, Content, Label> where Content : View, Label : View { fatalError() }

    /// Creates a sortable table column expression whose value type matches
    /// that of the builder.
    public static func buildExpression<Content, Label>(_ column: TableColumn<RowValue, Never, Content, Label>) -> TableColumn<RowValue, Never, Content, Label> where Content : View, Label : View { fatalError() }

    /// Creates a generic, sortable single column expression.
    public static func buildExpression<Column>(_ column: Column) -> Column where RowValue == Column.TableRowValue, Sort == Column.TableColumnSortComparator, Column : TableColumnContent { fatalError() }

    /// Creates a generic, unsortable single column expression.
    public static func buildExpression<Column>(_ column: Column) -> Column where RowValue == Column.TableRowValue, Column : TableColumnContent, Column.TableColumnSortComparator == Never { fatalError() }

    /// Creates a single, sortable column result.
    public static func buildBlock<Column>(_ column: Column) -> Column where RowValue == Column.TableRowValue, Sort == Column.TableColumnSortComparator, Column : TableColumnContent { fatalError() }

    /// Creates a single, unsortable column result.
    public static func buildBlock<Column>(_ column: Column) -> Column where RowValue == Column.TableRowValue, Column : TableColumnContent, Column.TableColumnSortComparator == Never { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumnBuilder {

    /// Creates a sortable column result from two sources.
    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleTableColumnContent<RowValue, Sort, (C0, C1)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C0.TableRowValue == C1.TableRowValue { fatalError() }

    /// Creates an unsortable column result from two sources.
    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleTableColumnContent<RowValue, Never, (C0, C1)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C0.TableColumnSortComparator == Never, C0.TableRowValue == C1.TableRowValue, C1.TableColumnSortComparator == Never { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumnBuilder {

    /// Creates a sortable column result from three sources.
    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleTableColumnContent<RowValue, Sort, (C0, C1, C2)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue { fatalError() }

    /// Creates an unsortable column result from three sources.
    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleTableColumnContent<RowValue, Never, (C0, C1, C2)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C0.TableColumnSortComparator == Never, C0.TableRowValue == C1.TableRowValue, C1.TableColumnSortComparator == Never, C1.TableRowValue == C2.TableRowValue, C2.TableColumnSortComparator == Never { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumnBuilder {

    /// Creates a sortable column result from four sources.
    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleTableColumnContent<RowValue, Sort, (C0, C1, C2, C3)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue { fatalError() }

    /// Creates an unsortable column result from four sources.
    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleTableColumnContent<RowValue, Never, (C0, C1, C2, C3)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C0.TableColumnSortComparator == Never, C0.TableRowValue == C1.TableRowValue, C1.TableColumnSortComparator == Never, C1.TableRowValue == C2.TableRowValue, C2.TableColumnSortComparator == Never, C2.TableRowValue == C3.TableRowValue, C3.TableColumnSortComparator == Never { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumnBuilder {

    /// Creates a sortable column result from five sources.
    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleTableColumnContent<RowValue, Sort, (C0, C1, C2, C3, C4)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue { fatalError() }

    /// Creates an unsortable column result from five sources.
    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleTableColumnContent<RowValue, Never, (C0, C1, C2, C3, C4)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C0.TableColumnSortComparator == Never, C0.TableRowValue == C1.TableRowValue, C1.TableColumnSortComparator == Never, C1.TableRowValue == C2.TableRowValue, C2.TableColumnSortComparator == Never, C2.TableRowValue == C3.TableRowValue, C3.TableColumnSortComparator == Never, C3.TableRowValue == C4.TableRowValue, C4.TableColumnSortComparator == Never { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumnBuilder {

    /// Creates a sortable column result from six sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleTableColumnContent<RowValue, Sort, (C0, C1, C2, C3, C4, C5)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C5 : TableColumnContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue, C4.TableRowValue == C5.TableRowValue { fatalError() }

    /// Creates an unsortable column result from six sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleTableColumnContent<RowValue, Never, (C0, C1, C2, C3, C4, C5)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C5 : TableColumnContent, C0.TableColumnSortComparator == Never, C0.TableRowValue == C1.TableRowValue, C1.TableColumnSortComparator == Never, C1.TableRowValue == C2.TableRowValue, C2.TableColumnSortComparator == Never, C2.TableRowValue == C3.TableRowValue, C3.TableColumnSortComparator == Never, C3.TableRowValue == C4.TableRowValue, C4.TableColumnSortComparator == Never, C4.TableRowValue == C5.TableRowValue, C5.TableColumnSortComparator == Never { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumnBuilder {

    /// Creates a sortable column result from seven sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleTableColumnContent<RowValue, Sort, (C0, C1, C2, C3, C4, C5, C6)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C5 : TableColumnContent, C6 : TableColumnContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue, C4.TableRowValue == C5.TableRowValue, C5.TableRowValue == C6.TableRowValue { fatalError() }

    /// Creates an unsortable column result from seven sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleTableColumnContent<RowValue, Never, (C0, C1, C2, C3, C4, C5, C6)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C5 : TableColumnContent, C6 : TableColumnContent, C0.TableColumnSortComparator == Never, C0.TableRowValue == C1.TableRowValue, C1.TableColumnSortComparator == Never, C1.TableRowValue == C2.TableRowValue, C2.TableColumnSortComparator == Never, C2.TableRowValue == C3.TableRowValue, C3.TableColumnSortComparator == Never, C3.TableRowValue == C4.TableRowValue, C4.TableColumnSortComparator == Never, C4.TableRowValue == C5.TableRowValue, C5.TableColumnSortComparator == Never, C5.TableRowValue == C6.TableRowValue, C6.TableColumnSortComparator == Never { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumnBuilder {

    /// Creates a sortable column result from eight sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleTableColumnContent<RowValue, Sort, (C0, C1, C2, C3, C4, C5, C6, C7)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C5 : TableColumnContent, C6 : TableColumnContent, C7 : TableColumnContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue, C4.TableRowValue == C5.TableRowValue, C5.TableRowValue == C6.TableRowValue, C6.TableRowValue == C7.TableRowValue { fatalError() }

    /// Creates an unsortable column result from eight sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleTableColumnContent<RowValue, Never, (C0, C1, C2, C3, C4, C5, C6, C7)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C5 : TableColumnContent, C6 : TableColumnContent, C7 : TableColumnContent, C0.TableColumnSortComparator == Never, C0.TableRowValue == C1.TableRowValue, C1.TableColumnSortComparator == Never, C1.TableRowValue == C2.TableRowValue, C2.TableColumnSortComparator == Never, C2.TableRowValue == C3.TableRowValue, C3.TableColumnSortComparator == Never, C3.TableRowValue == C4.TableRowValue, C4.TableColumnSortComparator == Never, C4.TableRowValue == C5.TableRowValue, C5.TableColumnSortComparator == Never, C5.TableRowValue == C6.TableRowValue, C6.TableColumnSortComparator == Never, C6.TableRowValue == C7.TableRowValue, C7.TableColumnSortComparator == Never { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumnBuilder {

    /// Creates a sortable column result from nine sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleTableColumnContent<RowValue, Sort, (C0, C1, C2, C3, C4, C5, C6, C7, C8)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C5 : TableColumnContent, C6 : TableColumnContent, C7 : TableColumnContent, C8 : TableColumnContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue, C4.TableRowValue == C5.TableRowValue, C5.TableRowValue == C6.TableRowValue, C6.TableRowValue == C7.TableRowValue, C7.TableRowValue == C8.TableRowValue { fatalError() }

    /// Creates an unsortable column result from nine sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleTableColumnContent<RowValue, Never, (C0, C1, C2, C3, C4, C5, C6, C7, C8)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C5 : TableColumnContent, C6 : TableColumnContent, C7 : TableColumnContent, C8 : TableColumnContent, C0.TableColumnSortComparator == Never, C0.TableRowValue == C1.TableRowValue, C1.TableColumnSortComparator == Never, C1.TableRowValue == C2.TableRowValue, C2.TableColumnSortComparator == Never, C2.TableRowValue == C3.TableRowValue, C3.TableColumnSortComparator == Never, C3.TableRowValue == C4.TableRowValue, C4.TableColumnSortComparator == Never, C4.TableRowValue == C5.TableRowValue, C5.TableColumnSortComparator == Never, C5.TableRowValue == C6.TableRowValue, C6.TableColumnSortComparator == Never, C6.TableRowValue == C7.TableRowValue, C7.TableColumnSortComparator == Never, C7.TableRowValue == C8.TableRowValue, C8.TableColumnSortComparator == Never { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumnBuilder {

    /// Creates a sortable column result from ten sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleTableColumnContent<RowValue, Sort, (C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C5 : TableColumnContent, C6 : TableColumnContent, C7 : TableColumnContent, C8 : TableColumnContent, C9 : TableColumnContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue, C4.TableRowValue == C5.TableRowValue, C5.TableRowValue == C6.TableRowValue, C6.TableRowValue == C7.TableRowValue, C7.TableRowValue == C8.TableRowValue, C8.TableRowValue == C9.TableRowValue { fatalError() }

    /// Creates an unsortable column result from ten sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleTableColumnContent<RowValue, Never, (C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where RowValue == C0.TableRowValue, C0 : TableColumnContent, C1 : TableColumnContent, C2 : TableColumnContent, C3 : TableColumnContent, C4 : TableColumnContent, C5 : TableColumnContent, C6 : TableColumnContent, C7 : TableColumnContent, C8 : TableColumnContent, C9 : TableColumnContent, C0.TableColumnSortComparator == Never, C0.TableRowValue == C1.TableRowValue, C1.TableColumnSortComparator == Never, C1.TableRowValue == C2.TableRowValue, C2.TableColumnSortComparator == Never, C2.TableRowValue == C3.TableRowValue, C3.TableColumnSortComparator == Never, C3.TableRowValue == C4.TableRowValue, C4.TableColumnSortComparator == Never, C4.TableRowValue == C5.TableRowValue, C5.TableColumnSortComparator == Never, C5.TableRowValue == C6.TableRowValue, C6.TableColumnSortComparator == Never, C6.TableRowValue == C7.TableRowValue, C7.TableColumnSortComparator == Never, C7.TableRowValue == C8.TableRowValue, C8.TableColumnSortComparator == Never, C8.TableRowValue == C9.TableRowValue, C9.TableColumnSortComparator == Never { fatalError() }
}

/// A type used to represent columns within a table.
///
/// This type provides the body content of the column, as well as the types
/// of the column's row values and the comparator used to sort rows.
///
/// You can factor column content out into separate types or properties, or
/// by creating a custom type conforming to `TableColumnContent`.
///
///     var body: some View {
///         Table(people, selection: $selectedPeople, sortOrder: $sortOrder) {
///             nameColumns
///
///             TableColumn("Location", value: \.location) {
///                 LocationView($0.location)
///             }
///         }
///     }
///
///     @TableColumnBuilder<Person, KeyPathComparator<Person>>
///     private var nameColumns: some TableColumnContent<
///         Person, KeyPathComparator<Person>
///     > {
///         TableColumn("First Name", value: \.firstName) {
///             PrimaryColumnView(person: $0)
///         }
///         TableColumn("Last Name", value: \.lastName)
///         TableColumn("Nickname", value: \.nickname)
///     }
///
/// The above example factors three table columns into a separate computed
/// property that has an opaque type. The property's primary associated
/// type `TableRowValue` is a `Person` and its associated type
/// `TableColumnSortComparator` is a key comparator for the `Person` type.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol TableColumnContent<TableRowValue, TableColumnSortComparator> {

    /// The type of value of rows presented by this column content.
    associatedtype TableRowValue : Identifiable = Self.TableColumnBody.TableRowValue

    /// The type of sort comparator associated with this table column content.
    associatedtype TableColumnSortComparator : SortComparator = Self.TableColumnBody.TableColumnSortComparator

    /// The type of content representing the body of this table column content.
    associatedtype TableColumnBody : TableColumnContent

    /// The composition of content that comprise the table column content.
    var tableColumnBody: Self.TableColumnBody { get }
}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableColumnContent {

    /// Sets the default visibility of a table column.
    ///
    /// A `hidden` column will not be visible, unless the `Table` is also bound
    /// to `TableColumnCustomization` and either modified programmatically or by
    /// the user.
    ///
    /// - Parameter visibility: The default visibility to apply to columns.
//    public func defaultVisibility(_ visibility: Visibility) -> some TableColumnContent<Self.TableRowValue, Self.TableColumnSortComparator> { fatalError() }


    /// Sets the identifier to be assocaited with a column when persisting its
    /// state with `TableColumnCustomization`.
    ///
    /// This is required to allow user customization of a specific table column,
    /// in addition to the table as a whole being provided a binding to a
    /// `TableColumnCustomization`.
    ///
    /// The identifier needs to to be stable, including across app version
    /// updates, since it is used to persist the user customization.
    ///
    /// - Parameter id: The identifier to associate with a column.
//    public func customizationID(_ id: String) -> some TableColumnContent<Self.TableRowValue, Self.TableColumnSortComparator> { fatalError() }


    /// Sets the disabled customization behavior for a table column.
    ///
    /// When the containing `Table` is bound to some `TableColumnCustomization`,
    /// all columns will be able to be customized by the user on macOS by
    /// default (i.e. `TableColumnCustomizationBehavior.all`). This
    /// modifier allows disabling specific behavior.
    ///
    /// This modifier has no effect on iOS since `Table` does not support any
    /// built-in user customization features.
    ///
    /// This does not prevent programmatic changes to a table column
    /// customization.
    ///
    /// - Parameter behavior: The behavior to disable, or `.all` to not allow
    ///   any customization.
//    public func disabledCustomizationBehavior(_ behavior: TableColumnCustomizationBehavior) -> some TableColumnContent<Self.TableRowValue, Self.TableColumnSortComparator> { fatalError() }

}

/// A representation of the state of the columns in a table.
///
/// `TableColumnCustomization` can be created and provided to a table to enable
/// column reordering and column visibility. The state can be queried and
/// updated programmatically, as well as bound to persistent app or scene
/// storage.
///
///     struct BugReportTable: View {
///         @ObservedObject var dataModel: DataModel
///         @Binding var selectedBugReports: Set<BugReport.ID>
///
///         @SceneStorage("BugReportTableConfig")
///         private var columnCustomization: TableColumnCustomization<BugReport>
///
///         var body: some View {
///             Table(dataModel.bugReports, selection: $selectedBugReports,
///                 sortOrder: $dataModel.sortOrder,
///                 columnCustomization: $columnCustomization
///             ) {
///                 TableColumn("Title", value: \.title)
///                     .customizationID("title")
///                 TableColumn("ID", value: \.id) {
///                     Link("\($0.id)", destination: $0.url)
///                 }
///                 .customizationID("id")
///                 TableColumn("Number of Reports", value: \.duplicateCount) {
///                     Text($0.duplicateCount, format: .number)
///                 }
///                 .customizationID("duplicates")
///             }
///         }
///     }
///
/// The above example creates a table with three columns. On macOS, these
/// columns can be reordered or hidden and shown by the user of the app.
/// Their configuration will be saved and restored with the window on relaunches
/// of the app, using the "BugReportTableConfig" scene storage identifier.
///
/// The state of a specific column is stored relative to its customization
/// identifier, using using the value from the
/// ``TableColumnContent/customizationID(_:)`` modifier.
/// When column customization is encoded and decoded, it relies on stable
/// identifiers to restore the associate the saved state with a specific column.
/// If a table column does not have a customization identifier, it will not
/// be customizable.
///
/// These identifiers can also be used to programmatically change column
/// customizations, such as programmatically hiding a column:
///
///     columnCustomization[visibility: "duplicates"] = .hidden
///
/// With a binding to the overall customization, a binding to the visibility
/// of a column can be accessed using the same subscript syntax:
///
///     struct BugReportTable: View {
///         @SceneStorage("BugReportTableConfig")
///         private var columnCustomization: TableColumnCustomization<BugReport>
///
///         var body: some View {
///             ...
///             MyVisibilityView($columnCustomization[visibility: "duplicates"])
///         }
///     }
///
///     struct MyVisibilityView: View {
///         @Binding var visibility: Visibility
///         ...
///     }
///
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TableColumnCustomization<RowValue> : Equatable, Sendable, Codable where RowValue : Identifiable {

    /// Creates an empty table column customization.
    ///
    /// With an empty customziation, columns will be ordered as described by the
    /// table's column builder.
    public init() { fatalError() }

    /// The visibility of the column identified by its identifier.
    ///
    /// Explicit identifiers can be associated with a `TableColumn` using the
    /// `customizationID(_:)` modifier.
    ///
    ///     TableColumn("Number of Reports", value: \.duplicateCount) {
    ///         Text($0.duplicateCount, format: .number)
    ///     }
    ///     .customizationID("numberOfReports")
    ///
    ///     ...
    ///
    ///     columnsCustomization[visibility: "numberOfReports"] = .hidden
    ///
    /// If the ID isn't associated with the state, a default value of
    /// `.automatic` is returned.
    public subscript(visibility id: String) -> Visibility { get { fatalError() } }

    /// Resets the column order back to the default, preserving the customized
    /// visibility and size.
    ///
    /// Tables that are bound to this state will order their columns as
    /// described by their column builder.
    public mutating func resetOrder() { fatalError() }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: TableColumnCustomization<RowValue>, b: TableColumnCustomization<RowValue>) -> Bool { fatalError() }

    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws { fatalError() }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws { fatalError() }
}

/// A set of customization behaviors of a column that a table can offer to
/// a user.
///
/// This is used as a value provided to
/// ``TableColumnContent/disabledCustomizationBehavior(_:)``.
///
/// Setting any of these values as the `disabledCustomizationBehavior(_:)`
/// doesn't have any effect on iOS.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TableColumnCustomizationBehavior : SetAlgebra, Sendable {

    /// A type for which the conforming type provides a containment test.
    public typealias Element = TableColumnCustomizationBehavior

    /// Creates an empty customization behavior, representing no customization
    public init() { fatalError() }

    /// All customization behaviors.
    public static var all: TableColumnCustomizationBehavior { get { fatalError() } }

    /// A behavior that allows the column to be reordered by the user.
    public static let reorder: TableColumnCustomizationBehavior = { fatalError() }()

    /// A behavior that allows the column to be resized by the user.
    public static let resize: TableColumnCustomizationBehavior = { fatalError() }()

    /// A behavior that allows the column to be hidden or revealed by the user.
    public static let visibility: TableColumnCustomizationBehavior = { fatalError() }()

    /// Returns a Boolean value that indicates whether the given element exists
    /// in the set.
    ///
    /// This example uses the `contains(_:)` method to test whether an integer is
    /// a member of a set of prime numbers.
    ///
    ///     let primes: Set = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    ///     let x = 5
    ///     if primes.contains(x) {
    ///         print("\(x) is prime!")
    ///     } else {
    ///         print("\(x). Not prime.")
    ///     }
    ///     // Prints "5 is prime!"
    ///
    /// - Parameter member: An element to look for in the set.
    /// - Returns: `true` if `member` exists in the set; otherwise, `false`.
    public func contains(_ member: TableColumnCustomizationBehavior.Element) -> Bool { fatalError() }

    /// Returns a new set with the elements of both this and the given set.
    ///
    /// In the following example, the `attendeesAndVisitors` set is made up
    /// of the elements of the `attendees` and `visitors` sets:
    ///
    ///     let attendees: Set = ["Alicia", "Bethany", "Diana"]
    ///     let visitors = ["Marcia", "Nathaniel"]
    ///     let attendeesAndVisitors = attendees.union(visitors)
    ///     print(attendeesAndVisitors)
    ///     // Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"
    ///
    /// If the set already contains one or more elements that are also in
    /// `other`, the existing members are kept.
    ///
    ///     let initialIndices = Set(0..<5)
    ///     let expandedIndices = initialIndices.union([2, 3, 6, 7])
    ///     print(expandedIndices)
    ///     // Prints "[2, 4, 6, 7, 0, 1, 3]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set with the unique elements of this set and `other`.
    ///
    /// - Note: if this set and `other` contain elements that are equal but
    ///   distinguishable (e.g. via `===`), which of these elements is present
    ///   in the result is unspecified.
    public func union(_ other: TableColumnCustomizationBehavior) -> TableColumnCustomizationBehavior { fatalError() }

    /// Returns a new set with the elements that are common to both this set and
    /// the given set.
    ///
    /// In the following example, the `bothNeighborsAndEmployees` set is made up
    /// of the elements that are in *both* the `employees` and `neighbors` sets.
    /// Elements that are in only one or the other are left out of the result of
    /// the intersection.
    ///
    ///     let employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
    ///     let bothNeighborsAndEmployees = employees.intersection(neighbors)
    ///     print(bothNeighborsAndEmployees)
    ///     // Prints "["Bethany", "Eric"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set.
    ///
    /// - Note: if this set and `other` contain elements that are equal but
    ///   distinguishable (e.g. via `===`), which of these elements is present
    ///   in the result is unspecified.
    public func intersection(_ other: TableColumnCustomizationBehavior) -> TableColumnCustomizationBehavior { fatalError() }

    /// Returns a new set with the elements that are either in this set or in the
    /// given set, but not in both.
    ///
    /// In the following example, the `eitherNeighborsOrEmployees` set is made up
    /// of the elements of the `employees` and `neighbors` sets that are not in
    /// both `employees` *and* `neighbors`. In particular, the names `"Bethany"`
    /// and `"Eric"` do not appear in `eitherNeighborsOrEmployees`.
    ///
    ///     let employees: Set = ["Alicia", "Bethany", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani"]
    ///     let eitherNeighborsOrEmployees = employees.symmetricDifference(neighbors)
    ///     print(eitherNeighborsOrEmployees)
    ///     // Prints "["Diana", "Forlani", "Alicia"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set.
    public func symmetricDifference(_ other: TableColumnCustomizationBehavior) -> TableColumnCustomizationBehavior { fatalError() }

    /// Inserts the given element in the set if it is not already present.
    ///
    /// If an element equal to `newMember` is already contained in the set, this
    /// method has no effect. In this example, a new element is inserted into
    /// `classDays`, a set of days of the week. When an existing element is
    /// inserted, the `classDays` set does not change.
    ///
    ///     enum DayOfTheWeek: Int {
    ///         case sunday, monday, tuesday, wednesday, thursday,
    ///             friday, saturday
    ///     }
    ///
    ///     var classDays: Set<DayOfTheWeek> = [.wednesday, .friday]
    ///     print(classDays.insert(.monday))
    ///     // Prints "(true, .monday)"
    ///     print(classDays)
    ///     // Prints "[.friday, .wednesday, .monday]"
    ///
    ///     print(classDays.insert(.friday))
    ///     // Prints "(false, .friday)"
    ///     print(classDays)
    ///     // Prints "[.friday, .wednesday, .monday]"
    ///
    /// - Parameter newMember: An element to insert into the set.
    /// - Returns: `(true, newMember)` if `newMember` was not contained in the
    ///   set. If an element equal to `newMember` was already contained in the
    ///   set, the method returns `(false, oldMember)`, where `oldMember` is the
    ///   element that was equal to `newMember`. In some cases, `oldMember` may
    ///   be distinguishable from `newMember` by identity comparison or some
    ///   other means.
    public mutating func insert(_ newMember: TableColumnCustomizationBehavior.Element) -> (inserted: Bool, memberAfterInsert: TableColumnCustomizationBehavior.Element) { fatalError() }

    /// Removes the given element and any elements subsumed by the given element.
    ///
    /// - Parameter member: The element of the set to remove.
    /// - Returns: For ordinary sets, an element equal to `member` if `member` is
    ///   contained in the set; otherwise, `nil`. In some cases, a returned
    ///   element may be distinguishable from `member` by identity comparison
    ///   or some other means.
    ///
    ///   For sets where the set type and element type are the same, like
    ///   `OptionSet` types, this method returns any intersection between the set
    ///   and `[member]`, or `nil` if the intersection is empty.
    public mutating func remove(_ member: TableColumnCustomizationBehavior.Element) -> TableColumnCustomizationBehavior.Element? { fatalError() }

    /// Inserts the given element into the set unconditionally.
    ///
    /// If an element equal to `newMember` is already contained in the set,
    /// `newMember` replaces the existing element. In this example, an existing
    /// element is inserted into `classDays`, a set of days of the week.
    ///
    ///     enum DayOfTheWeek: Int {
    ///         case sunday, monday, tuesday, wednesday, thursday,
    ///             friday, saturday
    ///     }
    ///
    ///     var classDays: Set<DayOfTheWeek> = [.monday, .wednesday, .friday]
    ///     print(classDays.update(with: .monday))
    ///     // Prints "Optional(.monday)"
    ///
    /// - Parameter newMember: An element to insert into the set.
    /// - Returns: For ordinary sets, an element equal to `newMember` if the set
    ///   already contained such a member; otherwise, `nil`. In some cases, the
    ///   returned element may be distinguishable from `newMember` by identity
    ///   comparison or some other means.
    ///
    ///   For sets where the set type and element type are the same, like
    ///   `OptionSet` types, this method returns any intersection between the
    ///   set and `[newMember]`, or `nil` if the intersection is empty.
    public mutating func update(with newMember: TableColumnCustomizationBehavior.Element) -> TableColumnCustomizationBehavior.Element? { fatalError() }

    /// Adds the elements of the given set to the set.
    ///
    /// In the following example, the elements of the `visitors` set are added to
    /// the `attendees` set:
    ///
    ///     var attendees: Set = ["Alicia", "Bethany", "Diana"]
    ///     let visitors: Set = ["Diana", "Marcia", "Nathaniel"]
    ///     attendees.formUnion(visitors)
    ///     print(attendees)
    ///     // Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"
    ///
    /// If the set already contains one or more elements that are also in
    /// `other`, the existing members are kept.
    ///
    ///     var initialIndices = Set(0..<5)
    ///     initialIndices.formUnion([2, 3, 6, 7])
    ///     print(initialIndices)
    ///     // Prints "[2, 4, 6, 7, 0, 1, 3]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    public mutating func formUnion(_ other: TableColumnCustomizationBehavior) { fatalError() }

    /// Removes the elements of this set that aren't also in the given set.
    ///
    /// In the following example, the elements of the `employees` set that are
    /// not also members of the `neighbors` set are removed. In particular, the
    /// names `"Alicia"`, `"Chris"`, and `"Diana"` are removed.
    ///
    ///     var employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
    ///     employees.formIntersection(neighbors)
    ///     print(employees)
    ///     // Prints "["Bethany", "Eric"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    public mutating func formIntersection(_ other: TableColumnCustomizationBehavior) { fatalError() }

    /// Removes the elements of the set that are also in the given set and adds
    /// the members of the given set that are not already in the set.
    ///
    /// In the following example, the elements of the `employees` set that are
    /// also members of `neighbors` are removed from `employees`, while the
    /// elements of `neighbors` that are not members of `employees` are added to
    /// `employees`. In particular, the names `"Bethany"` and `"Eric"` are
    /// removed from `employees` while the name `"Forlani"` is added.
    ///
    ///     var employees: Set = ["Alicia", "Bethany", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani"]
    ///     employees.formSymmetricDifference(neighbors)
    ///     print(employees)
    ///     // Prints "["Diana", "Forlani", "Alicia"]"
    ///
    /// - Parameter other: A set of the same type.
    public mutating func formSymmetricDifference(_ other: TableColumnCustomizationBehavior) { fatalError() }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: TableColumnCustomizationBehavior, b: TableColumnCustomizationBehavior) -> Bool { fatalError() }

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = TableColumnCustomizationBehavior.Element
}

/// A type of table row content that creates table rows created by iterating
/// over a collection.
///
/// You don't use this type directly. The various `Table.init(_:,...)`
/// initializers create this type as the table's `Rows` generic type.
///
/// To explicitly create dynamic collection-based rows, use ``ForEach`` instead.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TableForEachContent<Data> : TableRowContent where Data : RandomAccessCollection, Data.Element : Identifiable {

    /// The type of value represented by this table row content.
    public typealias TableRowValue = Data.Element

    /// The composition of content that comprise the table row content.
    public var tableRowBody: TableRowBody { get { return never() } }

    /// The type of content representing the body of this table row content.
    public typealias TableRowBody = Never
}

/// A table row that displays a single view instead of columned content.
///
/// You do not create this type directly. The framework creates it on your
/// behalf.
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TableHeaderRowContent<Value, Content> : TableRowContent where Value : Identifiable, Content : View {

    /// The type of value represented by this table row content.
    public typealias TableRowValue = Value

    /// The composition of content that comprise the table row content.
    public var tableRowBody: TableRowBody { get { return never() } }

    /// The type of content representing the body of this table row content.
    public typealias TableRowBody = Never
}

/// An opaque table row type created by a table's hierarchical initializers.
///
/// This row content is created by `Table.init(_:,children:,...)` initializers
/// as the table's `Rows` generic type.
///
/// To explicitly create hierarchical rows, use ``OutlineGroup`` instead.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TableOutlineGroupContent<Data> : TableRowContent where Data : RandomAccessCollection, Data.Element : Identifiable {

    /// The type of value represented by this table row content.
    public typealias TableRowValue = Data.Element

    /// The composition of content that comprise the table row content.
    public var tableRowBody: TableRowBody { get { return never() } }

    /// The type of content representing the body of this table row content.
    public typealias TableRowBody = Never
}

/// A row that represents a data value in a table.
///
/// Create instances of ``TableRow`` in the closure you provide to the
/// `rows` parameter in ``Table`` initializers that take columns and rows.
/// The table provides the value of a row to each column of a table, which produces
/// the cells for each row in the column.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TableRow<Value> : TableRowContent where Value : Identifiable {

    /// The type of value represented by this table row content.
    public typealias TableRowValue = Value

    /// The type of content representing the body of this table row content.
    public typealias TableRowBody = Never
    public var tableRowBody: TableRowBody { fatalError() }

    /// Creates a table row for the given value.
    ///
    /// The table provides the value of a row to each column of a table,
    /// which produces the cells for each row in the column.
    ///
    /// The following example creates a row for one instance of the `Person`
    /// type. The table delivers this value to its columns, which
    /// displays different fields of `Person`.
    ///
    ///      TableRow(Person(givenName: "Tom", familyName: "Clark"))
    ///
    /// - Parameter value: The value of the row.
    public init(_ value: Value) { fatalError() }
}

/// A result builder that creates table row content from closures.
///
/// The `buildBlock` methods in this type create ``TableRowContent``
/// instances based on the number and types of sources provided as parameters.
///
/// Don't use this type directly; instead, SkipUI annotates the `rows`
/// parameter of the various ``Table`` initializers with the
/// `@TableRowBuilder` annotation, implicitly calling this builder for you.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@resultBuilder public struct TableRowBuilder<Value> where Value : Identifiable {

    /// Builds an expression within the builder.
    public static func buildExpression<Content>(_ content: Content) -> Content where Value == Content.TableRowValue, Content : TableRowContent { fatalError() }

    /// Creates a single row result.
    public static func buildBlock<C>(_ content: C) -> C where Value == C.TableRowValue, C : TableRowContent { fatalError() }
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowBuilder {

    /// Creates a row result for conditional statements.
    ///
    /// This method provides support for "if" statements in multistatement
    /// closures, producing an optional value that is visible only when the
    /// condition evaluates to `true`.
    public static func buildIf<C>(_ content: C?) -> C? where Value == C.TableRowValue, C : TableRowContent { fatalError() }

    /// Creates a row result for the first of two row content alternatives.
    ///
    /// This method rovides support for "if" statements in multistatement
    /// closures, producing conditional content for the "then" branch.
//    public static func buildEither<T, F>(first: T) -> _ConditionalContent<T, F> where Value == T.TableRowValue, T : TableRowContent, F : TableRowContent, T.TableRowValue == F.TableRowValue { fatalError() }

    /// Creates a row result for the second of two row content alternatives.
    ///
    /// This method rovides support for "if" statements in multistatement
    /// closures, producing conditional content for the "else" branch.
//    public static func buildEither<T, F>(second: F) -> _ConditionalContent<T, F> where Value == T.TableRowValue, T : TableRowContent, F : TableRowContent, T.TableRowValue == F.TableRowValue { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowBuilder {

    /// Creates a row result from two sources.
    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleTableRowContent<Value, (C0, C1)> where Value == C0.TableRowValue, C0 : TableRowContent, C1 : TableRowContent, C0.TableRowValue == C1.TableRowValue { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowBuilder {

    /// Creates a row result from three sources.
    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleTableRowContent<Value, (C0, C1, C2)> where Value == C0.TableRowValue, C0 : TableRowContent, C1 : TableRowContent, C2 : TableRowContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowBuilder {

    /// Creates a row result from four sources.
    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleTableRowContent<Value, (C0, C1, C2, C3)> where Value == C0.TableRowValue, C0 : TableRowContent, C1 : TableRowContent, C2 : TableRowContent, C3 : TableRowContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowBuilder {

    /// Creates a row result from five sources.
    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleTableRowContent<Value, (C0, C1, C2, C3, C4)> where Value == C0.TableRowValue, C0 : TableRowContent, C1 : TableRowContent, C2 : TableRowContent, C3 : TableRowContent, C4 : TableRowContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowBuilder {

    /// Creates a row result from six sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleTableRowContent<Value, (C0, C1, C2, C3, C4, C5)> where Value == C0.TableRowValue, C0 : TableRowContent, C1 : TableRowContent, C2 : TableRowContent, C3 : TableRowContent, C4 : TableRowContent, C5 : TableRowContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue, C4.TableRowValue == C5.TableRowValue { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowBuilder {

    /// Creates a row result from seven sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleTableRowContent<Value, (C0, C1, C2, C3, C4, C5, C6)> where Value == C0.TableRowValue, C0 : TableRowContent, C1 : TableRowContent, C2 : TableRowContent, C3 : TableRowContent, C4 : TableRowContent, C5 : TableRowContent, C6 : TableRowContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue, C4.TableRowValue == C5.TableRowValue, C5.TableRowValue == C6.TableRowValue { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowBuilder {

    /// Creates a row result from eight sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleTableRowContent<Value, (C0, C1, C2, C3, C4, C5, C6, C7)> where Value == C0.TableRowValue, C0 : TableRowContent, C1 : TableRowContent, C2 : TableRowContent, C3 : TableRowContent, C4 : TableRowContent, C5 : TableRowContent, C6 : TableRowContent, C7 : TableRowContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue, C4.TableRowValue == C5.TableRowValue, C5.TableRowValue == C6.TableRowValue, C6.TableRowValue == C7.TableRowValue { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowBuilder {

    /// Creates a row result from nine sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleTableRowContent<Value, (C0, C1, C2, C3, C4, C5, C6, C7, C8)> where Value == C0.TableRowValue, C0 : TableRowContent, C1 : TableRowContent, C2 : TableRowContent, C3 : TableRowContent, C4 : TableRowContent, C5 : TableRowContent, C6 : TableRowContent, C7 : TableRowContent, C8 : TableRowContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue, C4.TableRowValue == C5.TableRowValue, C5.TableRowValue == C6.TableRowValue, C6.TableRowValue == C7.TableRowValue, C7.TableRowValue == C8.TableRowValue { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowBuilder {

    /// Creates a row result from ten sources.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleTableRowContent<Value, (C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where Value == C0.TableRowValue, C0 : TableRowContent, C1 : TableRowContent, C2 : TableRowContent, C3 : TableRowContent, C4 : TableRowContent, C5 : TableRowContent, C6 : TableRowContent, C7 : TableRowContent, C8 : TableRowContent, C9 : TableRowContent, C0.TableRowValue == C1.TableRowValue, C1.TableRowValue == C2.TableRowValue, C2.TableRowValue == C3.TableRowValue, C3.TableRowValue == C4.TableRowValue, C4.TableRowValue == C5.TableRowValue, C5.TableRowValue == C6.TableRowValue, C6.TableRowValue == C7.TableRowValue, C7.TableRowValue == C8.TableRowValue, C8.TableRowValue == C9.TableRowValue { fatalError() }
}

/// A type used to represent table rows.
///
/// Like with the ``View`` protocol, you can create custom table row content
/// by declaring a type that conforms to the `TableRowContent` protocol and implementing
/// the required ``TableRowContent/tableRowBody-swift.property`` property.
///
///     struct GroupOfPeopleRows: TableRowContent {
///         @Binding var people: [Person]
///
///         var tableRowBody: some TableRowContent<Person> {
///             ForEach(people) { person in
///                 TableRow(person)
///                     .itemProvider { person.itemProvider }
///             }
///             .dropDestination(for: Person.self) { destination, newPeople in
///                 people.insert(contentsOf: newPeople, at: destination)
///             }
///         }
///     }
///
/// This example uses an opaque result type and specifies that the
/// primary associated type `TableRowValue` for the `tableRowBody`
/// property is a `Person`. From this, SkipUI can infer
/// `TableRowValue` for the `GroupOfPeopleRows` structure is also `Person`.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol TableRowContent<TableRowValue> {

    /// The type of value represented by this table row content.
    associatedtype TableRowValue : Identifiable = Self.TableRowBody.TableRowValue

    /// The type of content representing the body of this table row content.
    associatedtype TableRowBody : TableRowContent

    /// The composition of content that comprise the table row content.
    var tableRowBody: Self.TableRowBody { get }
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowContent {

    /// Adds a context menu to a table row.
    ///
    /// Use this modifier to add a context menu to a table row. Compose
    /// the menu by returning controls like ``Button``, ``Toggle``, and
    /// ``Picker`` from the `menuItems` closure. You can also use ``Menu``
    /// to define submenus, or ``Section`` to group items.
    ///
    /// The following example adds a context menu to each row in a table
    /// that people can use to send an email to the person represented by
    /// that row:
    ///
    ///     Table(of: Person.self) {
    ///         TableColumn("Given Name", value: \.givenName)
    ///         TableColumn("Family Name", value: \.familyName)
    ///     } rows: {
    ///         ForEach(people) { person in
    ///             TableRow(person)
    ///                 .contextMenu {
    ///                     Button("Send Email...") { }
    ///                 }
    ///         }
    ///     }
    ///
    /// If you want to display a preview beside the context menu, use
    /// ``TableRowContent/contextMenu(menuItems:preview:)``. If you want
    /// to display a context menu that's based on the current selection,
    /// use ``View/contextMenu(forSelectionType:menu:primaryAction:)``. To add
    /// context menus to other kinds of views, use ``View/contextMenu(menuItems:)``.
    ///
    /// - Parameter menuItems: A closure that produces the menu's contents. You
    ///   can deactivate the context menu by returning nothing from the closure.
    ///
    /// - Returns: A row that can display a context menu.
//    public func contextMenu<M>(@ViewBuilder menuItems: () -> M) -> ModifiedContent<Self, _ContextMenuTableRowModifier<M>> where M : View { fatalError() }

    /// Adds a context menu with a preview to a table row.
    ///
    /// When you use this modifer to add a context menu to rows in a
    /// table, the system shows a preview beside the menu.
    /// Compose the menu by returning controls like ``Button``, ``Toggle``, and
    /// ``Picker`` from the `menuItems` closure. You can also use ``Menu`` to
    /// define submenus.
    ///
    /// Define the preview by returning a view from the `preview` closure. The
    /// system sizes the preview to match the size of its content. For example,
    /// the following code adds a context menu with a preview to each row in a
    /// table that people can use to send an email to the person represented by
    /// that row:
    ///
    ///     Table(of: Person.self) {
    ///         TableColumn("Given Name", value: \.givenName)
    ///         TableColumn("Family Name", value: \.familyName)
    ///     } rows: {
    ///         ForEach(people) { person in
    ///             TableRow(person)
    ///                 .contextMenu {
    ///                     Button("Send Email...") { }
    ///                 } preview: {
    ///                     Image("envelope") // Loads the image from an asset catalog.
    ///                 }
    ///         }
    ///     }
    ///
    /// > Note: This view modifier produces a context menu on macOS, but that
    /// platform doesn't display the preview.
    ///
    /// If you don't need a preview, use
    /// ``TableRowContent/contextMenu(menuItems:)``. If you want
    /// to display a context menu that's based on the current selection,
    /// use ``View/contextMenu(forSelectionType:menu:primaryAction:)``. To add
    /// context menus to other kinds of views, see ``View/contextMenu(menuItems:)``.
    ///
    /// - Parameters:
    ///   - menuItems: A closure that produces the menu's contents. You can
    ///     deactivate the context menu by returning nothing from the closure.
    ///   - preview: A view that the system displays along with the menu.
    ///
    /// - Returns: A row that can display a context menu with a preview.
//    public func contextMenu<M, P>(@ViewBuilder menuItems: () -> M, @ViewBuilder preview: () -> P) -> ModifiedContent<Self, _ContextMenuPreviewTableRowModifier<M, P>> where M : View, P : View { fatalError() }
}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowContent {

    /// Activates this row as the source of a drag and drop operation.
    ///
    /// Applying the `draggable(_:)` modifier adds the appropriate gestures for
    /// drag and drop to this row.
    ///
    /// - Parameter payload: A closure that returns a single
    /// instance or a value conforming to <doc://com.apple.documentation/documentation/coretransferable/transferable> that
    /// represents the draggable data from this view.
    ///
    /// - Returns: A row that activates this row as the source of a drag and
    ///   drop operation.
//    public func draggable<T>(_ payload: @autoclosure @escaping () -> T) -> some TableRowContent<Self.TableRowValue> where T : Transferable { fatalError() }


    /// Defines the entire row as a destination of a drag and drop operation
    /// that handles the dropped content with a closure that you specify.
    ///
    /// - Parameters:
    ///   - payloadType: The expected type of the dropped models.
    ///   - action: A closure that takes the dropped content and responds
    ///     with `true` if the drop operation was successful; otherwise, return
    ///     `false`.
    ///   - isTargeted: A closure that is called when a drag and drop operation
    ///     enters or exits the drop target area. The received value is `true`
    ///     when the cursor is inside the area, and `false` when the cursor is
    ///     outside.
    ///
    /// - Returns: A row that provides a drop destination for a drag
    ///   operation of the specified type.
//    public func dropDestination<T>(for payloadType: T.Type = T.self, action: @escaping (_ items: [T]) -> Void) -> some TableRowContent<Self.TableRowValue> where T : Transferable { fatalError() }

}


@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Section : TableRowContent where Parent : TableRowContent, Content : TableRowContent, Footer : TableRowContent {

    /// The type of value represented by this table row content.
    public typealias TableRowValue = Content.TableRowValue

    /// The type of content representing the body of this table row content.
    public typealias TableRowBody = Never

    /// Creates a section with a header and the provided section content.
    /// - Parameters:
    ///   - content: The section's content.
    ///   - header: A view to use as the section's header.
    public init<V, H>(@TableRowBuilder<V> content: () -> Content, @ViewBuilder header: () -> H) where Parent == TableHeaderRowContent<V, H>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue, H : View { fatalError() }

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - titleKey: The key for the section's localized title, which describes
    ///     the contents of the section.
    ///   - content: The section's content.
    public init<V>(_ titleKey: LocalizedStringKey, @TableRowBuilder<V> content: () -> Content) where Parent == TableHeaderRowContent<V, Text>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue { fatalError() }

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - title: A string that describes the contents of the section.
    ///   - content: The section's content.
    public init<V, S>(_ title: S, @TableRowBuilder<V> content: () -> Content) where Parent == TableHeaderRowContent<V, Text>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue, S : StringProtocol { fatalError() }

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - content: The section's content.
    public init<V>(@TableRowBuilder<V> content: () -> Content) where Parent == EmptyTableRowContent<V>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue { fatalError() }

    public var tableRowBody: Never { fatalError() }
}

@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Section where Parent : TableRowContent, Content : TableRowContent {

    /// Creates a section with a header and the provided section content.
    /// - Parameters:
    ///   - isExpanded: A binding to a Boolean value that determines the section's
    ///    expansion state (expanded or collapsed).
    ///   - content: The section's content.
    ///   - header: A view to use as the section's header.
    public init<V, H>(isExpanded: Binding<Bool>, @TableRowBuilder<V> content: () -> Content, @ViewBuilder header: () -> H) where Parent == TableHeaderRowContent<V, H>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue, H : View { fatalError() }

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - titleKey: The key for the section's localized title, which describes
    ///     the contents of the section.
    ///   - isExpanded: A binding to a Boolean value that determines the section's
    ///    expansion state (expanded or collapsed).
    ///   - content: The section's content.
    public init<V>(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @TableRowBuilder<V> content: () -> Content) where Parent == TableHeaderRowContent<V, Text>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue { fatalError() }

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - title: A string that describes the contents of the section.
    ///   - isExpanded: A binding to a Boolean value that determines the section's
    ///    expansion state (expanded or collapsed).
    ///   - content: The section's content.
    public init<V, S>(_ title: S, isExpanded: Binding<Bool>, @TableRowBuilder<V> content: () -> Content) where Parent == TableHeaderRowContent<V, Text>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue, S : StringProtocol { fatalError() }
}

#if canImport(UIKit)
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableRowContent {

    /// Provides a closure that vends the drag representation for a
    /// particular data element.
    public func itemProvider(_ action: (() -> NSItemProvider?)?) -> ModifiedContent<Self, ItemProviderTableRowModifier> { fatalError() }
}
#endif
