// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP


/// A container that presents rows of data arranged in a single column,
/// optionally providing the ability to select one or more members.
///
/// In its simplest form, a `List` creates its contents statically, as shown in
/// the following example:
///
///     var body: some View {
///         List {
///             Text("A List Item")
///             Text("A Second List Item")
///             Text("A Third List Item")
///         }
///     }
///
/// ![A vertical list with three text views.](List-1-iOS)
///
/// More commonly, you create lists dynamically from an underlying collection
/// of data. The following example shows how to create a simple list from an
/// array of an `Ocean` type which conforms to
/// :
///
///     struct Ocean: Identifiable {
///         let name: String
///         let id = UUID()
///     }
///
///     private var oceans = [
///         Ocean(name: "Pacific"),
///         Ocean(name: "Atlantic"),
///         Ocean(name: "Indian"),
///         Ocean(name: "Southern"),
///         Ocean(name: "Arctic")
///     ]
///
///     var body: some View {
///         List(oceans) {
///             Text($0.name)
///         }
///     }
///
/// ![A vertical list with five text views, each with the name of an
/// ocean.](List-2-iOS)
///
/// ### Supporting selection in lists
///
/// To make members of a list selectable, provide a binding to a selection
/// variable. Binding to a single instance of the list data's `Identifiable.ID`
/// type creates a single-selection list. Binding to a
///  creates a list that
/// supports multiple selections. The following example shows how to add
/// multiselect to the previous example:
///
///     struct Ocean: Identifiable, Hashable {
///         let name: String
///         let id = UUID()
///     }
///
///     private var oceans = [
///         Ocean(name: "Pacific"),
///         Ocean(name: "Atlantic"),
///         Ocean(name: "Indian"),
///         Ocean(name: "Southern"),
///         Ocean(name: "Arctic")
///     ]
///
///     @State private var multiSelection = Set<UUID>()
///
///     var body: some View {
///         NavigationView {
///             List(oceans, selection: $multiSelection) {
///                 Text($0.name)
///             }
///             .navigationTitle("Oceans")
///             .toolbar { EditButton() }
///         }
///         Text("\(multiSelection.count) selections")
///     }
///
/// When people make a single selection by tapping or clicking, the selected
/// cell changes its appearance to indicate the selection. To enable multiple
/// selections with tap gestures, put the list into edit mode by either
/// modifying the ``EnvironmentValues/editMode`` value, or adding an
/// ``EditButton`` to your app's interface. When you put the list into edit
/// mode, the list shows a circle next to each list item. The circle contains
/// a checkmark when the user selects the associated item. The example above
/// uses an Edit button, which changes its title to Done while in edit mode:
///
/// ![A navigation view with the title Oceans and a vertical list that contains
/// five text views, each with the name of an ocean. The second and third items
/// are highlighted to indicate that they are selected. At the bottom, a text
/// view reads 2 selections.](List-3-iOS)
///
/// People can make multiple selections without needing to enter edit mode on
/// devices that have a keyboard and mouse or trackpad, like Mac and iPad.
///
/// ### Refreshing the list content
///
/// To make the content of the list refreshable using the standard refresh
/// control, use the ``View/refreshable(action:)`` modifier.
///
/// The following example shows how to add a standard refresh control to a list.
/// When the user drags the top of the list downward, SkipUI reveals the refresh
/// control and executes the specified action. Use an `await` expression
/// inside the `action` closure to refresh your data. The refresh indicator remains
/// visible for the duration of the awaited operation.
///
///     struct Ocean: Identifiable, Hashable {
///          let name: String
///          let id = UUID()
///          let stats: [String: String]
///      }
///
///      class OceanStore: ObservableObject {
///          @Published var oceans = [Ocean]()
///          func loadStats() async {}
///      }
///
///      @EnvironmentObject var store: OceanStore
///
///      var body: some View {
///          NavigationView {
///              List(store.oceans) { ocean in
///                  HStack {
///                      Text(ocean.name)
///                      StatsSummary(stats: ocean.stats) // A custom view for showing statistics.
///                  }
///              }
///              .refreshable {
///                  await store.loadStats()
///              }
///              .navigationTitle("Oceans")
///          }
///      }
///
/// ### Supporting multidimensional lists
///
/// To create two-dimensional lists, group items inside ``Section`` instances.
/// The following example creates sections named after the world's oceans,
/// each of which has ``Text`` views named for major seas attached to those
/// oceans. The example also allows for selection of a single list item,
/// identified by the `id` of the example's `Sea` type.
///
///     struct ContentView: View {
///         struct Sea: Hashable, Identifiable {
///             let name: String
///             let id = UUID()
///         }
///
///         struct OceanRegion: Identifiable {
///             let name: String
///             let seas: [Sea]
///             let id = UUID()
///         }
///
///         private let oceanRegions: [OceanRegion] = [
///             OceanRegion(name: "Pacific",
///                         seas: [Sea(name: "Australasian Mediterranean"),
///                                Sea(name: "Philippine"),
///                                Sea(name: "Coral"),
///                                Sea(name: "South China")]),
///             OceanRegion(name: "Atlantic",
///                         seas: [Sea(name: "American Mediterranean"),
///                                Sea(name: "Sargasso"),
///                                Sea(name: "Caribbean")]),
///             OceanRegion(name: "Indian",
///                         seas: [Sea(name: "Bay of Bengal")]),
///             OceanRegion(name: "Southern",
///                         seas: [Sea(name: "Weddell")]),
///             OceanRegion(name: "Arctic",
///                         seas: [Sea(name: "Greenland")])
///         ]
///
///         @State private var singleSelection: UUID?
///
///         var body: some View {
///             NavigationView {
///                 List(selection: $singleSelection) {
///                     ForEach(oceanRegions) { region in
///                         Section(header: Text("Major \(region.name) Ocean Seas")) {
///                             ForEach(region.seas) { sea in
///                                 Text(sea.name)
///                             }
///                         }
///                     }
///                 }
///                 .navigationTitle("Oceans and Seas")
///             }
///         }
///     }
///
/// Because this example uses single selection, people can make selections
/// outside of edit mode on all platforms.
///
/// ![A vertical list split into sections titled Major Pacific Ocean Seas,
/// Major Atlantic Ocean Seas, and so on. Each section has a different number of
/// rows, with the names of various seas. Within the Major Atlantic Ocean
/// Seas section, the row Sargasso is selected.](List-4-iOS)
///
/// > Note: In iOS 15, iPadOS 15, and tvOS 15 and earlier, lists support
///   selection only in edit mode, even for single selections.
///
/// ### Creating hierarchical lists
///
/// You can also create a hierarchical list of arbitrary depth by providing
/// tree-structured data and a `children` parameter that provides a key path to
/// get the child nodes at any level. The following example uses a deeply-nested
/// collection of a custom `FileItem` type to simulate the contents of a
/// file system. The list created from this data uses collapsing cells to allow
/// the user to navigate the tree structure.
///
///     struct ContentView: View {
///         struct FileItem: Hashable, Identifiable, CustomStringConvertible {
///             var id: Self { self }
///             var name: String
///             var children: [FileItem]? = nil
///             var description: String {
///                 switch children {
///                 case nil:
///                     return "📄 \(name)"
///                 case .some(let children):
///                     return children.isEmpty ? "📂 \(name)" : "📁 \(name)"
///                 }
///             }
///         }
///         let fileHierarchyData: [FileItem] = [
///           FileItem(name: "users", children:
///             [FileItem(name: "user1234", children:
///               [FileItem(name: "Photos", children:
///                 [FileItem(name: "photo001.jpg"),
///                  FileItem(name: "photo002.jpg")]),
///                FileItem(name: "Movies", children:
///                  [FileItem(name: "movie001.mp4")]),
///                   FileItem(name: "Documents", children: [])
///               ]),
///              FileItem(name: "newuser", children:
///                [FileItem(name: "Documents", children: [])
///                ])
///             ]),
///             FileItem(name: "private", children: nil)
///         ]
///         var body: some View {
///             List(fileHierarchyData, children: \.children) { item in
///                 Text(item.description)
///             }
///         }
///     }
///
/// ![A list providing an expanded view of a tree structure. Some rows have a
/// chevron on the right to indicate that they have child rows. The chevron
/// points right when the row's child rows are hidden and points down when they
/// are visible. Row content that is slightly indented from the content in the
/// previous row indicates that the row is a child of the row above. The first
/// three rows, titled users, user1234, and Photos, have downward facing
/// chevrons and are progressively indented. The next two rows, indented
/// together from Photos and titled photo001.jpg and photo002.jpg, have no
/// chevron. The next two rows, titled Movies and Documents have right facing
/// chevrons and align with the Photos row. The next row, titled newuser, has a
/// right facing chevron and is aligned with user1234. The last row is titled
/// private, has no chevron, and is aligned with users.](List-5-iOS)
///
/// ### Styling lists
///
/// SkipUI chooses a display style for a list based on the platform and the
/// view type in which it appears. Use the ``View/listStyle(_:)`` modifier to
/// apply a different ``ListStyle`` to all lists within a view. For example,
/// adding `.listStyle(.plain)` to the example shown in the
/// "Creating Multidimensional Lists" topic applies the
/// ``ListStyle/plain`` style, the following screenshot shows:
///
/// ![A vertical list split into sections titled Major Pacific Ocean Seas,
/// Major Atlantic Ocean Seas, etc. Each section has a different number of
/// rows, with the names of various seas. Within the Major Atlantic Ocean
/// Seas section, the row Sargasso is selected.](List-6-iOS)
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@MainActor public struct List<SelectionValue, Content> : View where SelectionValue : Hashable, Content : View {

    /// Creates a list with the given content that supports selecting multiple
    /// rows.
    ///
    /// - Parameters:
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - content: The content of the list.
    @available(watchOS, unavailable)
    @MainActor public init(selection: Binding<Set<SelectionValue>>?, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a list with the given content that supports selecting a single
    /// row.
    ///
    /// - Parameters:
    ///   - selection: A binding to a selected row.
    ///   - content: The content of the list.
    @available(watchOS 10.0, *)
    @MainActor public init(selection: Binding<SelectionValue?>?, @ViewBuilder content: () -> Content) { fatalError() }

    /// The content of the list.
    @MainActor public var body: some View { get { return never() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
//    public typealias Body = some View
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Data, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a list that computes its views on demand over a constant range,
    /// optionally allowing users to select multiple rows.
    ///
    /// This instance only reads the initial value of `data` and doesn't need to
    /// identify views across updates. To compute views on demand over a dynamic
    /// range, use ``List/init(_:id:selection:rowContent:)-9a28m``.
    ///
    /// - Parameters:
    ///   - data: A constant range of data to populate the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<RowContent>(_ data: Range<Int>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS 10.0, *)
    @MainActor public init<Data, RowContent>(_ data: Data, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS 10.0, *)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a list that computes its views on demand over a constant range,
    /// optionally allowing users to select a single row.
    ///
    /// This instance only reads the initial value of `data` and doesn't need to
    /// identify views across updates. To compute views on demand over a dynamic
    /// range, use ``List/init(_:id:selection:rowContent:)-2r2u9``.
    ///
    /// - Parameters:
    ///   - data: A constant range of data to populate the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<RowContent>(_ data: Range<Int>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, RowContent>, RowContent : View { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List where SelectionValue == Never {

    /// Creates a list with the given content.
    ///
    /// - Parameter content: The content of the list.
    @MainActor public init(@ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data.
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, RowContent>(_ data: Data, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data.
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a list that computes its views on demand over a constant range.
    ///
    /// This instance only reads the initial value of `data` and doesn't need to
    /// identify views across updates. To compute views on demand over a dynamic
    /// range, use ``List/init(_:id:rowContent:)-4s0aj``.
    ///
    /// - Parameters:
    ///   - data: A constant range of data to populate the list.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<RowContent>(_ data: Range<Int>, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, RowContent>, RowContent : View { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List where SelectionValue == Never {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data.
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension List {

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data, optionally
    /// allowing users to select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data, optionally
    /// allowing users to select a single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension List where SelectionValue == Never {

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data.
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable, allows to edit the collection, and
    /// optionally allows users to select multiple rows.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select multiple elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFoods
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing and to be edited by
    ///     the list.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions<Data>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable, allows to edit the collection, and
    /// optionally allows users to select multiple rows.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select multiple elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFoods
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing and to be edited by
    ///     the list.
    ///   - id: The key path to the data model's identifier.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions<Data>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, allows to edit the collection, and
    /// optionally allowing users to select a single row.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select a single elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFood
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions<Data>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, allows to edit the collection, and
    /// optionally allowing users to select a single row.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select a single elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFood
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - id: The key path to the data model's identifier.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions<Data>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension List where SelectionValue == Never {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data and allows to edit the collection.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection.
    ///
    ///     List($foods, editActions: [.delete, .move]) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data and allows to edit the collection.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection.
    ///
    ///     List($foods, editActions: [.delete, .move]) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - id: The key path to the data model's identifier.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

/// The configuration of a tint effect applied to content within a List.
///
/// - See Also: `View.listItemTint(_:)`
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ListItemTint : Sendable {

    /// An explicit tint color.
    ///
    /// This tint effect is fixed and not overridable by other
    /// system effects.
    public static func fixed(_ tint: Color) -> ListItemTint { fatalError() }

    /// An explicit tint color that is overridable.
    ///
    /// This tint effect is overridable by system effects, for
    /// example when the system has a custom user accent
    /// color on macOS.
    public static func preferred(_ tint: Color) -> ListItemTint { fatalError() }

    /// A standard grayscale tint effect.
    ///
    /// Monochrome tints are not overridable.
    public static let monochrome: ListItemTint = { fatalError() }()
}

/// The spacing options between two adjacent sections in a list.
@available(iOS 17.0, watchOS 10.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
public struct ListSectionSpacing : Sendable {

    /// The default spacing between sections
    public static let `default`: ListSectionSpacing = { fatalError() }()

    /// Compact spacing between sections
    public static let compact: ListSectionSpacing = { fatalError() }()

    /// Creates a custom spacing value.
    ///
    /// - Parameter spacing: the amount of spacing to use.
    public static func custom(_ spacing: CGFloat) -> ListSectionSpacing { fatalError() }
}

/// A protocol that describes the behavior and appearance of a list.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol ListStyle {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ListStyle where Self == DefaultListStyle {

    /// The list style that describes a platform's default behavior and
    /// appearance for a list.
    public static var automatic: DefaultListStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ListStyle where Self == SidebarListStyle {

    /// The list style that describes the behavior and appearance of a
    /// sidebar list.
    ///
    /// On macOS and iOS, the sidebar list style displays disclosure indicators in
    /// the section headers that allow the user to collapse and expand sections.
    public static var sidebar: SidebarListStyle { get { fatalError() } }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ListStyle where Self == InsetGroupedListStyle {

    /// The list style that describes the behavior and appearance of an inset
    /// grouped list.
    ///
    /// On iOS, the inset grouped list style displays a continuous background color
    /// that extends from the section header, around both sides of list items in the
    /// section, and down to the section footer. This visually groups the items
    /// to a greater degree than either the ``ListStyle/inset`` or
    /// ``ListStyle/grouped`` styles do.
    public static var insetGrouped: InsetGroupedListStyle { get { fatalError() } }
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension ListStyle where Self == GroupedListStyle {

    /// The list style that describes the behavior and appearance of a grouped
    /// list.
    ///
    /// On iOS, the grouped list style displays a larger header and footer than
    /// the ``ListStyle/plain`` style, which visually distances the members of
    /// different sections.
    public static var grouped: GroupedListStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ListStyle where Self == InsetListStyle {

    /// The list style that describes the behavior and appearance of an inset
    /// list.
    public static var inset: InsetListStyle { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ListStyle where Self == PlainListStyle {

    /// The list style that describes the behavior and appearance of a plain
    /// list.
    public static var plain: PlainListStyle { get { fatalError() } }
}

/// The list style that describes the behavior and appearance of a grouped list.
///
/// You can also use ``ListStyle/grouped`` to construct this style.
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct GroupedListStyle : ListStyle {

    /// Creates a grouped list style.
    public init() { fatalError() }
}

/// The list style that describes a platform's default behavior and appearance
/// for a list.
///
/// You can also use ``ListStyle/automatic`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct DefaultListStyle : ListStyle {

    /// Creates a default list style.
    public init() { fatalError() }
}

/// The list style that describes the behavior and appearance of an inset
/// grouped list.
///
/// You can also use ``ListStyle/insetGrouped`` to construct this style.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct InsetGroupedListStyle : ListStyle {

    /// Creates an inset grouped list style.
    public init() { fatalError() }
}

/// The list style that describes the behavior and appearance of an inset list.
///
/// You can also use ``ListStyle/inset`` to construct this style.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct InsetListStyle : ListStyle {

    /// Creates an inset list style.
    public init() { fatalError() }
}

/// The list style that describes the behavior and appearance of a plain list.
///
/// You can also use ``ListStyle/plain`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PlainListStyle : ListStyle {

    /// Creates a plain list style.
    public init() { fatalError() }
}

/// The list style that describes the behavior and appearance of a
/// sidebar list.
///
/// You can also use ``ListStyle/sidebar`` to construct this style.
@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct SidebarListStyle : ListStyle {

    /// Creates a sidebar list style.
    public init() { fatalError() }
}

#endif
