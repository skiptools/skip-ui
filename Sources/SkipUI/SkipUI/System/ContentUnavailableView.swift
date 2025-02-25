// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if false
/// An interface, consisting of a label and additional content, that you
/// display when the content of your app is unavailable to users.
///
/// It is recommended to use `ContentUnavailableView` in situations where a view's
/// content cannot be displayed. That could be caused by a network error, a
/// list without items, a search that returns no results etc.
///
/// You create an `ContentUnavailableView` in its simplest form, by providing a
/// label and some additional content such as a description or a call to action:
///
///     ContentUnavailableView {
///         Label("No Mail", systemImage: "tray.fill")
///     } description: {
///         Text("New mails you receive will appear here.")
///     }
///
/// The system provides default `ContentUnavailableView`s that you can use in
/// specific situations. The example below illustrates the usage of the
/// ``ContentUnavailableView/search`` view:
///
///     struct ContentView: View {
///         @ObservedObject private var viewModel = ContactsViewModel()
///
///         var body: some View {
///             NavigationStack {
///                 List {
///                     ForEach(viewModel.searchResults) { contact in
///                         NavigationLink {
///                             ContactsView(contact)
///                         } label: {
///                             Text(contact.name)
///                         }
///                     }
///                 }
///                 .navigationTitle("Contacts")
///                 .searchable(text: $viewModel.searchText)
///                 .overlay {
///                     if searchResults.isEmpty {
///                         ContentUnavailableView.search
///                     }
///                 }
///             }
///         }
///     }
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ContentUnavailableView<LabelX, Description, Actions> : View where LabelX : View, Description : View, Actions : View {

    /// Creates an interface, consisting of a label and additional content, that you
    /// display when the content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///   - label: The label that describes the view.
    ///   - description: The view that describes the interface.
    ///   - actions: The content of the interface actions.
    public init(@ViewBuilder label: () -> LabelX, @ViewBuilder description: () -> Description = { EmptyView() }, @ViewBuilder actions: () -> Actions = { EmptyView() }) { fatalError() }

    @MainActor public var body: some View { get { return stubView() } }

//    public typealias Body = some View
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ContentUnavailableView where LabelX == Label /*<Text, Image>*/, Description == Text?, Actions == EmptyView {

    /// Creates an interface, consisting of a title generated from a localized
    /// string, an image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    public init(_ title: LocalizedStringKey, image name: String, description: Text? = nil) { fatalError() }

    /// Creates an interface, consisting of a title generated from a localized
    /// string, a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    public init(_ title: LocalizedStringKey, systemImage name: String, description: Text? = nil) { fatalError() }

    /// Creates an interface, consisting of a title generated from a string,
    /// an image and additional content, that you display when the content of
    /// your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    public init<S>(_ title: S, image name: String, description: Text? = nil) where S : StringProtocol { fatalError() }

    /// Creates an interface, consisting of a title generated from a string,
    /// a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    public init<S>(_ title: S, systemImage name: String, description: Text? = nil) where S : StringProtocol { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ContentUnavailableView where LabelX == SearchUnavailableContent.Label, Description == SearchUnavailableContent.Description, Actions == SearchUnavailableContent.Actions {

    /// Creates a `ContentUnavailableView` instance that conveys a search state.
    ///
    /// A `ContentUnavailableView` initialized with this static member is expected to
    /// be contained within a searchable view hierarchy. Such a configuration
    /// enables the search query to be parsed into the view's description.
    ///
    /// For example, consider the usage of this static member in *ContactsListView*:
    ///
    ///     struct ContactsListView: View {
    ///         @ObservedObject private var viewModel = ContactsViewModel()
    ///
    ///         var body: some View {
    ///             NavigationStack {
    ///                 List {
    ///                     ForEach(viewModel.searchResults) { contact in
    ///                         NavigationLink {
    ///                             ContactsView(contact)
    ///                         } label: {
    ///                             Text(contact.name)
    ///                         }
    ///                     }
    ///                 }
    ///                 .navigationTitle("Contacts")
    ///                 .searchable(text: $viewModel.searchText)
    ///                 .overlay {
    ///                     if searchResults.isEmpty {
    ///                         ContentUnavailableView.search
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    public static var search: ContentUnavailableView<SearchUnavailableContent.Label, SearchUnavailableContent.Description, SearchUnavailableContent.Actions> { get { fatalError() } }

    /// Creates a `ContentUnavailableView` instance that conveys a search state.
    ///
    /// For example, consider the usage of this static member in *ContactsListView*:
    ///
    ///     struct ContactsListView: View {
    ///         @ObservedObject private var viewModel = ContactsViewModel()
    ///
    ///         var body: some View {
    ///             NavigationStack {
    ///                 CustomSearchBar(query: $viewModel.searchText)
    ///                 List {
    ///                     ForEach(viewModel.searchResults) { contact in
    ///                         NavigationLink {
    ///                             ContactsView(contact)
    ///                         } label: {
    ///                             Text(contact.name)
    ///                         }
    ///                     }
    ///                 }
    ///                 .navigationTitle("Contacts")
    ///                 .overlay {
    ///                     if viewModel.searchResults.isEmpty {
    ///                         ContentUnavailableView
    ///                             .search(text: viewModel.searchText)
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter text: The search text query.
    public static func search(text: String) -> ContentUnavailableView<LabelX, Description, Actions> { fatalError() }
}
#endif
