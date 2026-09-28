// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

/// An interface, consisting of a label and additional content, that you display when the content of your app is unavailable to users.
///
/// Renders centered like iOS: a large secondary icon above a bold title, then the description and actions.
public struct ContentUnavailableView : View {
    let label: ComposeBuilder
    let description: ComposeBuilder?
    let actions: ComposeBuilder?

    public init(@ViewBuilder label: () -> any View, @ViewBuilder description: () -> any View = { EmptyView() }, @ViewBuilder actions: () -> any View = { EmptyView() }) {
        self.label = ComposeBuilder.from(label)
        self.description = ComposeBuilder.from(description)
        self.actions = ComposeBuilder.from(actions)
    }

    public init(_ titleKey: LocalizedStringKey, image: String, description: Text? = nil) {
        self.init(label: { Label(titleKey, image: image) }, description: { description.map { $0 as any View } ?? EmptyView() })
    }

    public init(_ titleKey: LocalizedStringKey, systemImage: String, description: Text? = nil) {
        self.init(label: { Label(titleKey, systemImage: systemImage) }, description: { description.map { $0 as any View } ?? EmptyView() })
    }

    public init(_ title: String, image: String, description: Text? = nil) {
        self.init(label: { Label(title, image: image) }, description: { description.map { $0 as any View } ?? EmptyView() })
    }

    public init(_ title: String, systemImage: String, description: Text? = nil) {
        self.init(label: { Label(title, systemImage: systemImage) }, description: { description.map { $0 as any View } ?? EmptyView() })
    }

    /// A view that indicates that there are no search results.
    public static var search: ContentUnavailableView {
        return ContentUnavailableView("No Results", systemImage: "magnifyingglass", description: Text("Check the spelling or try a new search."))
    }

    /// A view that indicates that there are no search results for the given query.
    public static func search(text: String) -> ContentUnavailableView {
        return ContentUnavailableView("No Results for \u{201C}\(text)\u{201D}", systemImage: "magnifyingglass", description: Text("Check the spelling or try a new search."))
    }

    #if SKIP
    public var body: some View {
        VStack(spacing: 8.0) {
            ContentUnavailableLabel(label: label)
            if let description {
                description
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            if let actions {
                actions
                    .padding(.top, 8.0)
            }
        }
        .padding(32.0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

/// Stacks a `Label`'s large icon above its title, as iOS's content-unavailable label style does.
struct ContentUnavailableLabel : View, Renderable {
    let label: ComposeBuilder

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        let renderables = label.Evaluate(context: context, options: 0)
        guard let labelView = renderables.firstOrNull()?.strip() as? Label, renderables.size == 1 else {
            label.font(.title2.bold()).Compose(context: context)
            return
        }
        VStack(spacing: 12.0) {
            labelView.image
                .font(.system(size: 48.0))
                .foregroundStyle(.secondary)
            labelView.title
                .font(.title2.bold())
                .multilineTextAlignment(.center)
        }
        .Compose(context: context)
    }
    #else
    var body: some View {
        stubView()
    }
    #endif
}

#endif

/*
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
    public init(_ title: LocalizedStringKey, image: String, description: Text? = nil) { fatalError() }

    /// Creates an interface, consisting of a title generated from a localized
    /// string, a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    public init(_ title: LocalizedStringKey, systemImage: String, description: Text? = nil) { fatalError() }

    /// Creates an interface, consisting of a title generated from a string,
    /// an image and additional content, that you display when the content of
    /// your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    public init<S>(_ title: S, image: String, description: Text? = nil) where S : StringProtocol { fatalError() }

    /// Creates an interface, consisting of a title generated from a string,
    /// a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    public init<S>(_ title: S, systemImage: String, description: Text? = nil) where S : StringProtocol { fatalError() }
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
*/
