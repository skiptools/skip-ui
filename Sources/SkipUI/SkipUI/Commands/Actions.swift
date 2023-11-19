// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import struct Foundation.URL

/// An action that opens a URL.
///
/// Read the ``EnvironmentValues/openURL`` environment value to get an
/// instance of this structure for a given ``Environment``. Call the
/// instance to open a URL. You call the instance directly because it
/// defines a ``OpenURLAction/callAsFunction(_:)`` method that Swift
/// calls when you call the instance.
///
/// For example, you can open a web site when the user taps a button:
///
///     struct OpenURLExample: View {
///         @Environment(\.openURL) private var openURL
///
///         var body: some View {
///             Button {
///                 if let url = URL(string: "https://www.example.com") {
///                     openURL(url)
///                 }
///             } label: {
///                 Label("Get Help", systemImage: "person.fill.questionmark")
///             }
///         }
///     }
///
/// If you want to know whether the action succeeds, add a completion
/// handler that takes a Boolean value. In this case, Swift implicitly
/// calls the ``OpenURLAction/callAsFunction(_:completion:)`` method
/// instead. That method calls your completion handler after it determines
/// whether it can open the URL, but possibly before it finishes opening
/// the URL. You can add a handler to the example above so that
/// it prints the outcome to the console:
///
///     openURL(url) { accepted in
///         print(accepted ? "Success" : "Failure")
///     }
///
/// The system provides a default open URL action with behavior
/// that depends on the contents of the URL. For example, the default
/// action opens a Universal Link in the associated app if possible,
/// or in the user’s default web browser if not.
///
/// You can also set a custom action using the ``View/environment(_:_:)``
/// view modifier. Any views that read the action from the environment,
/// including the built-in ``Link`` view and ``Text`` views with markdown
/// links, or links in attributed strings, use your action. Initialize an
/// action by calling the ``OpenURLAction/init(handler:)`` initializer with
/// a handler that takes a URL and returns an ``OpenURLAction/Result``:
///
///     Text("Visit [Example Company](https://www.example.com) for details.")
///         .environment(\.openURL, OpenURLAction { url in
///             handleURL(url) // Define this method to take appropriate action.
///             return .handled
///         })
///
/// SkipUI translates the value that your custom action's handler
/// returns into an appropriate Boolean result for the action call.
/// For example, a view that uses the action declared above
/// receives `true` when calling the action, because the
/// handler always returns ``OpenURLAction/Result/handled``.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct OpenURLAction {

    /// The result of a custom open URL action.
    ///
    /// If you declare a custom ``OpenURLAction`` in the ``Environment``,
    /// return one of the result values from its handler.
    ///
    /// * Use ``handled`` to indicate that the handler opened the URL.
    /// * Use ``discarded`` to indicate that the handler discarded the URL.
    /// * Use ``systemAction`` without an argument to ask SkipUI
    ///   to open the URL with the system handler.
    /// * Use ``systemAction(_:)`` with a URL argument to ask SkipUI
    ///   to open the specified URL with the system handler.
    ///
    /// You can use the last option to transform URLs, while
    /// still relying on the system to open the URL. For example,
    /// you could append a path component to every URL:
    ///
    ///     .environment(\.openURL, OpenURLAction { url in
    ///         .systemAction(url.appendingPathComponent("edit"))
    ///     })
    ///
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public struct Result {

        /// The handler opened the URL.
        ///
        /// The action invokes its completion handler with `true` when your
        /// handler returns this value.
        public static let handled: OpenURLAction.Result = { fatalError() }()

        /// The handler discarded the URL.
        ///
        /// The action invokes its completion handler with `false` when your
        /// handler returns this value.
        public static let discarded: OpenURLAction.Result = { fatalError() }()

        /// The handler asks the system to open the original URL.
        ///
        /// The action invokes its completion handler with a value that
        /// depends on the outcome of the system's attempt to open the URL.
        public static let systemAction: OpenURLAction.Result = { fatalError() }()

        /// The handler asks the system to open the modified URL.
        ///
        /// The action invokes its completion handler with a value that
        /// depends on the outcome of the system's attempt to open the URL.
        ///
        /// - Parameter url: The URL that the handler asks the system to open.
        public static func systemAction(_ url: URL) -> OpenURLAction.Result { fatalError() }
    }

    /// Creates an action that opens a URL.
    ///
    /// Use this initializer to create a custom action for opening URLs.
    /// Provide a handler that takes a URL and returns an
    /// ``OpenURLAction/Result``. Place your handler in the environment
    /// using the ``View/environment(_:_:)`` view modifier:
    ///
    ///     Text("Visit [Example Company](https://www.example.com) for details.")
    ///         .environment(\.openURL, OpenURLAction { url in
    ///             handleURL(url) // Define this method to take appropriate action.
    ///             return .handled
    ///         })
    ///
    /// Any views that read the action from the environment, including the
    /// built-in ``Link`` view and ``Text`` views with markdown links, or
    /// links in attributed strings, use your action.
    ///
    /// SkipUI translates the value that your custom action's handler
    /// returns into an appropriate Boolean result for the action call.
    /// For example, a view that uses the action declared above
    /// receives `true` when calling the action, because the
    /// handler always returns ``OpenURLAction/Result/handled``.
    ///
    /// - Parameter handler: The closure to run for the given URL.
    ///   The closure takes a URL as input, and returns a ``Result``
    ///   that indicates the outcome of the action.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init(handler: @escaping (URL) -> OpenURLAction.Result) { fatalError() }

    /// Opens a URL, following system conventions.
    ///
    /// Don't call this method directly. SkipUI calls it when you
    /// call the ``OpenURLAction`` structure that you get from the
    /// ``Environment``, using a URL as an argument:
    ///
    ///     struct OpenURLExample: View {
    ///         @Environment(\.openURL) private var openURL
    ///
    ///         var body: some View {
    ///             Button {
    ///                 if let url = URL(string: "https://www.example.com") {
    ///                     openURL(url) // Implicitly calls openURL.callAsFunction(url)
    ///                 }
    ///             } label: {
    ///                 Label("Get Help", systemImage: "person.fill.questionmark")
    ///             }
    ///         }
    ///     }
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID622)
    /// in *The Swift Programming Language*.
    ///
    /// - Parameter url: The URL to open.
    public func callAsFunction(_ url: URL) { fatalError() }

    /// Asynchronously opens a URL, following system conventions.
    ///
    /// Don't call this method directly. SkipUI calls it when you
    /// call the ``OpenURLAction`` structure that you get from the
    /// ``Environment``, using a URL and a completion handler as arguments:
    ///
    ///     struct OpenURLExample: View {
    ///         @Environment(\.openURL) private var openURL
    ///
    ///         var body: some View {
    ///             Button {
    ///                 if let url = URL(string: "https://www.example.com") {
    ///                     // Implicitly calls openURL.callAsFunction(url) { ... }
    ///                     openURL(url) { accepted in
    ///                         print(accepted ? "Success" : "Failure")
    ///                     }
    ///                 }
    ///             } label: {
    ///                 Label("Get Help", systemImage: "person.fill.questionmark")
    ///             }
    ///         }
    ///     }
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID622)
    /// in *The Swift Programming Language*.
    ///
    /// - Parameters:
    ///   - url: The URL to open.
    ///   - completion: A closure the method calls after determining if
    ///     it can open the URL, but possibly before fully opening the URL.
    ///     The closure takes a Boolean value that indicates whether the
    ///     method can open the URL.
    @available(watchOS, unavailable)
    public func callAsFunction(_ url: URL, completion: @escaping (_ accepted: Bool) -> Void) { fatalError() }
}

/// An action that presents a window.
///
/// Use the ``EnvironmentValues/openWindow`` environment value to get the
/// instance of this structure for a given ``Environment``. Then call the
/// instance to open a window. You call the instance directly because it
/// defines a ``OpenWindowAction/callAsFunction(id:)`` method that Swift calls
/// when you call the instance.
///
/// For example, you can define a button that opens a new mail viewer
/// window:
///
///     @main
///     struct Mail: App {
///         var body: some Scene {
///             WindowGroup(id: "mail-viewer") {
///                 MailViewer()
///             }
///         }
///     }
///
///     struct NewViewerButton: View {
///         @Environment(\.openWindow) private var openWindow
///
///         var body: some View {
///             Button("Open new mail viewer") {
///                 openWindow(id: "mail-viewer")
///             }
///         }
///     }
///
/// You indicate which scene to open by providing one of the following:
///  * A string identifier that you pass through the `id` parameter,
///    as in the above example.
///  * A `value` parameter that has a type that matches the type that
///    you specify in the scene's initializer.
///  * Both an identifier and a value. This enables you to define
///    multiple window groups that take input values of the same type, like a
///    .
///
/// Use the first option to target either a ``WindowGroup`` or a
/// ``Window`` scene in your app that has a matching identifier. For a
/// `WindowGroup`, the system creates a new window for the group. If
/// the window group presents data, the system provides the default value
/// or `nil` to the window's root view. If the targeted scene is a
/// `Window`, the system orders it to the front.
///
/// Use the other two options to target a `WindowGroup` and provide
/// a value to present. If the interface already has a window from
/// the group that's presenting the specified value, the system brings the
/// window to the front. Otherwise, the system creates a new window and
/// passes a binding to the specified value.
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct OpenWindowAction {

    /// Opens a window defined by a window group that presents the type of
    /// the specified value.
    ///
    /// Don't call this method directly. SkipUI calls it when you
    /// call the ``EnvironmentValues/openWindow`` action with a value:
    ///
    ///     openWindow(value: message.id)
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID622)
    /// in *The Swift Programming Language*.
    ///
    /// - Parameter value: The value to present.
    public func callAsFunction<D>(value: D) where D : Decodable, D : Encodable, D : Hashable { fatalError() }

    /// Opens a window that's associated with the specified identifier.
    ///
    /// Don't call this method directly. SkipUI calls it when you
    /// call the ``EnvironmentValues/openWindow`` action with an identifier:
    ///
    ///     openWindow(id: "message")
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID622)
    /// in *The Swift Programming Language*.
    ///
    /// - Parameter id: The identifier of the scene to present.
    public func callAsFunction(id: String) { fatalError() }

    /// Opens a window defined by the window group that presents the specified
    /// value type and that's associated with the specified identifier.
    ///
    /// Don't call this method directly. SkipUI calls it when you
    /// call the ``EnvironmentValues/openWindow`` action with an identifier
    /// and a value:
    ///
    ///     openWindow(id: "message", value: message.id)
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID622)
    /// in *The Swift Programming Language*.
    ///
    /// - Parameters:
    ///   - id: The identifier of the scene to present.
    ///   - value: The value to present.
    public func callAsFunction<D>(id: String, value: D) where D : Decodable, D : Encodable, D : Hashable { fatalError() }
}

/// An action that initiates a refresh operation.
///
/// When the ``EnvironmentValues/refresh`` environment value contains an
/// instance of this structure, certain built-in views in the corresponding
/// ``Environment`` begin offering a refresh capability. They apply the
/// instance's handler to any refresh operation that the user initiates.
/// By default, the environment value is `nil`, but you can use the
/// ``View/refreshable(action:)`` modifier to create and store a new
/// refresh action that uses the handler that you specify:
///
///     List(mailbox.conversations) { conversation in
///         ConversationCell(conversation)
///     }
///     .refreshable {
///         await mailbox.fetch()
///     }
///
/// On iOS and iPadOS, the ``List`` in the example above offers a
/// pull to refresh gesture because it detects the refresh action. When
/// the user drags the list down and releases, the list calls the action's
/// handler. Because SkipUI declares the handler as asynchronous, it can
/// safely make long-running asynchronous calls, like fetching network data.
///
/// ### Refreshing custom views
///
/// You can also offer refresh capability in your custom views.
/// Read the ``EnvironmentValues/refresh`` environment value to get the
/// `RefreshAction` instance for a given ``Environment``. If you find
/// a non-`nil` value, change your view's appearance or behavior to offer
/// the refresh to the user, and call the instance to conduct the
/// refresh. You can call the refresh instance directly because it defines
/// a ``RefreshAction/callAsFunction()`` method that Swift calls
/// when you call the instance:
///
///     struct RefreshableView: View {
///         @Environment(\.refresh) private var refresh
///
///         var body: some View {
///             Button("Refresh") {
///                 Task {
///                     await refresh?()
///                 }
///             }
///             .disabled(refresh == nil)
///         }
///     }
///
/// Be sure to call the handler asynchronously by preceding it
/// with `await`. Because the call is asynchronous, you can use
/// its lifetime to indicate progress to the user. For example,
/// you might reveal an indeterminate ``ProgressView`` before
/// calling the handler, and hide it when the handler completes.
///
/// If your code isn't already in an asynchronous context, create a
///  for the
/// method to run in. If you do this, consider adding a way for the
/// user to cancel the task. For more information, see
/// [Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)
/// in *The Swift Programming Language*.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RefreshAction : Sendable {

    /// Initiates a refresh action.
    ///
    /// Don't call this method directly. SkipUI calls it when you
    /// call the ``RefreshAction`` structure that you get from the
    /// ``Environment``:
    ///
    ///     struct RefreshableView: View {
    ///         @Environment(\.refresh) private var refresh
    ///
    ///         var body: some View {
    ///             Button("Refresh") {
    ///                 Task {
    ///                     await refresh?()  // Implicitly calls refresh.callAsFunction()
    ///                 }
    ///             }
    ///             .disabled(refresh == nil)
    ///         }
    ///     }
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID622)
    /// in *The Swift Programming Language*.
    /// For information about asynchronous operations in Swift, see
    /// [Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html).
    public func callAsFunction() async { fatalError() }
}

/// An action that activates a standard rename interaction.
///
/// Use the ``View/renameAction(_:)-6lghl`` modifier to configure the rename
/// action in the environment.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct RenameAction {

    /// Triggers the standard rename action provided through the environment.
    public func callAsFunction() { fatalError() }
}

/// A button that triggers a standard rename action.
///
/// A rename button receives its action from the environment. Use the
/// ``View/renameAction(_:)-6lghl`` modifier to set the action. The
/// system disables the button if you don't define an action.
///
///     struct RowView: View {
///         @State private var text = ""
///         @FocusState private var isFocused: Bool
///
///         var body: some View {
///             TextField(text: $item.name) {
///                 Text("Prompt")
///             }
///             .focused($isFocused)
///             .contextMenu {
///                 RenameButton()
///                 // ... your own custom actions
///             }
///             .renameAction { $isFocused = true }
///     }
///
/// When someone taps the rename button in the context menu, the rename
/// action focuses the text field by setting the `isFocused`
/// property to true.
///
/// You can use this button inside of a navigation title menu and the
/// navigation title modifier automatically configures the environment
/// with the appropriate rename action.
///
///     ContentView()
///         .navigationTitle($contentTitle) {
///             // ... your own custom actions
///             RenameButton()
///         }
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct RenameButton<LabelX> : View where LabelX : View {

    /// Creates a rename button.
    public init() where LabelX == Label /*<Text, Image>*/ { fatalError() }

    @MainActor public var body: some View { get { return stubView() } }

//    public typealias Body = some View
}

/// An action that dismisses a presentation.
///
/// Use the ``EnvironmentValues/dismiss`` environment value to get the instance
/// of this structure for a given ``Environment``. Then call the instance
/// to perform the dismissal. You call the instance directly because
/// it defines a ``DismissAction/callAsFunction()``
/// method that Swift calls when you call the instance.
///
/// You can use this action to:
///  * Dismiss a modal presentation, like a sheet or a popover.
///  * Pop the current view from a ``NavigationStack``.
///  * Close a window that you create with ``WindowGroup`` or ``Window``.
///
/// The specific behavior of the action depends on where you call it from.
/// For example, you can create a button that calls the ``DismissAction``
/// inside a view that acts as a sheet:
///
///     private struct SheetContents: View {
///         @Environment(\.dismiss) private var dismiss
///
///         var body: some View {
///             Button("Done") {
///                 dismiss()
///             }
///         }
///     }
///
/// When you present the `SheetContents` view, someone can dismiss
/// the sheet by tapping or clicking the sheet's button:
///
///     private struct DetailView: View {
///         @State private var isSheetPresented = false
///
///         var body: some View {
///             Button("Show Sheet") {
///                 isSheetPresented = true
///             }
///             .sheet(isPresented: $isSheetPresented) {
///                 SheetContents()
///             }
///         }
///     }
///
/// Be sure that you define the action in the appropriate environment.
/// For example, don't reorganize the `DetailView` in the example above
/// so that it creates the `dismiss` property and calls it from the
/// ``View/sheet(item:onDismiss:content:)`` view modifier's `content`
/// closure:
///
///     private struct DetailView: View {
///         @State private var isSheetPresented = false
///         @Environment(\.dismiss) private var dismiss // Applies to DetailView.
///
///         var body: some View {
///             Button("Show Sheet") {
///                 isSheetPresented = true
///             }
///             .sheet(isPresented: $isSheetPresented) {
///                 Button("Done") {
///                     dismiss() // Fails to dismiss the sheet.
///                 }
///             }
///         }
///     }
///
/// If you do this, the sheet fails to dismiss because the action applies
/// to the environment where you declared it, which is that of the detail
/// view, rather than the sheet. In fact, in macOS and iPadOS, if the
/// `DetailView` is the root view of a window, the dismiss action closes
/// the window instead.
///
/// The dismiss action has no effect on a view that isn't currently
/// presented. If you need to query whether SkipUI is currently presenting
/// a view, read the ``EnvironmentValues/isPresented`` environment value.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct DismissAction {

    /// Dismisses the view if it is currently presented.
    ///
    /// Don't call this method directly. SkipUI calls it for you when you
    /// call the ``DismissAction`` structure that you get from the
    /// ``Environment``:
    ///
    ///     private struct SheetContents: View {
    ///         @Environment(\.dismiss) private var dismiss
    ///
    ///         var body: some View {
    ///             Button("Done") {
    ///                 dismiss() // Implicitly calls dismiss.callAsFunction()
    ///             }
    ///         }
    ///     }
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID622)
    /// in *The Swift Programming Language*.
    public func callAsFunction() { fatalError() }
}

/// An action that can end a search interaction.
///
/// Use the ``EnvironmentValues/dismissSearch`` environment value to get the
/// instance of this structure for a given ``Environment``. Then call the
/// instance to dismiss the current search interaction. You call the instance
/// directly because it defines a ``DismissSearchAction/callAsFunction()``
/// method that Swift calls when you call the instance.
///
/// When you dismiss search, SkipUI:
///
/// * Sets ``EnvironmentValues/isSearching`` to `false`.
/// * Clears any text from the search field.
/// * Removes focus from the search field.
///
/// > Note: Calling this instance has no effect if the user isn't
/// interacting with a search field.
///
/// Use this action to dismiss a search operation based on
/// another user interaction. For example, consider a searchable
/// view with a ``Button`` that presents more information about the first
/// matching item from a collection:
///
///     struct ContentView: View {
///         @State private var searchText = ""
///
///         var body: some View {
///             NavigationStack {
///                 SearchedView(searchText: searchText)
///                     .searchable(text: $searchText)
///             }
///         }
///     }
///
///     struct SearchedView: View {
///         var searchText: String
///
///         let items = ["a", "b", "c"]
///         var filteredItems: [String] { items.filter { $0 == searchText.lowercased() } }
///
///         @State private var isPresented = false
///         @Environment(\.dismissSearch) private var dismissSearch
///
///         var body: some View {
///             if let item = filteredItems.first {
///                 Button("Details about \(item)") {
///                     isPresented = true
///                 }
///                 .sheet(isPresented: $isPresented) {
///                     NavigationStack {
///                         DetailView(item: item, dismissSearch: dismissSearch)
///                     }
///                 }
///             }
///         }
///     }
///
/// The button becomes visible only after the user enters search text
/// that produces a match. When the user taps the button, SkipUI shows
/// a sheet that provides more information about the item, including
/// an Add button for adding the item to a stored list of items:
///
///     private struct DetailView: View {
///         var item: String
///         var dismissSearch: DismissSearchAction
///
///         @Environment(\.dismiss) private var dismiss
///
///         var body: some View {
///             Text("Information about \(item).")
///                 .toolbar {
///                     Button("Add") {
///                         // Store the item here...
///
///                         dismiss()
///                         dismissSearch()
///                     }
///                 }
///         }
///     }
///
/// People can dismiss the sheet by dragging it down, effectively
/// canceling the operation, leaving the in-progress search interaction
/// intact. Alternatively, people can tap the Add button to store the item.
/// Because the person using your app is likely to be done with both the
/// detail view and the search interaction at this point, the button's
/// closure also uses the ``EnvironmentValues/dismiss`` property to dismiss
/// the sheet, and the ``EnvironmentValues/dismissSearch`` property to
/// reset the search field.
///
/// > Important: Access the action from inside the searched view, as the
///   example above demonstrates, rather than from the searched view’s
///   parent, or another hierarchy, like that of a sheet. SkipUI sets the
///   value in the environment of the view that you apply the searchable
///   modifier to, and doesn’t propagate the value up the view hierarchy.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct DismissSearchAction {

    /// Dismisses the current search operation, if any.
    ///
    /// Don't call this method directly. SkipUI calls it for you when you
    /// call the ``DismissSearchAction`` structure that you get from the
    /// ``Environment``:
    ///
    ///     struct SearchedView: View {
    ///         @Environment(\.dismissSearch) private var dismissSearch
    ///
    ///         var body: some View {
    ///             Button("Cancel") {
    ///                 dismissSearch() // Implicitly calls dismissSearch.callAsFunction()
    ///             }
    ///         }
    ///     }
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID622)
    /// in *The Swift Programming Language*.
    public func callAsFunction() { fatalError() }
}

/// An action that dismisses a window associated to a particular scene.
///
/// Use the ``EnvironmentValues/dismissWindow`` environment value to get the
/// instance of this structure for a given ``Environment``. Then call the
/// instance to dismiss a window. You call the instance directly because it
/// defines a ``DismissWindowAction/callAsFunction(id:)`` method that Swift
/// calls when you call the instance.
///
/// For example, you can define a button that closes an auxiliary window:
///
///     @main
///     struct MyApp: App {
///         var body: some Scene {
///             WindowGroup {
///                 ContentView()
///             }
///             #if os(macOS)
///             Window("Auxiliary", id: "auxiliary") {
///                 AuxiliaryContentView()
///             }
///             #endif
///         }
///     }
///
///     struct DismissWindowButton: View {
///         @Environment(\.dismissWindow) private var dismissWindow
///
///         var body: some View {
///             Button("Close Auxiliary Window") {
///                 dismissWindow(id: "auxiliary")
///             }
///         }
///     }
@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DismissWindowAction {

    /// Dismisses the current window.
    ///
    /// Don't call this method directly. SkipUI calls it when you
    /// call the ``EnvironmentValues/dismissWindow`` action:
    ///
    ///     dismissWindow()
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/declarations#Methods-with-Special-Names)
    /// in *The Swift Programming Language*.
    public func callAsFunction() { fatalError() }

    /// Dismisses the window that's associated with the specified identifier.
    ///
    /// When the specified identifier represents a ``WindowGroup``, all of the
    /// open windows in that group will be dismissed. For dismissing a single
    /// window associated to a `WindowGroup` scene, use
    /// ``dismissWindow(value:)`` or ``dismissWindow(id:value:)``.
    ///
    /// Don't call this method directly. SkipUI calls it when you
    /// call the ``EnvironmentValues/dismissWindow`` action with an identifier:
    ///
    ///     dismissWindow(id: "message")
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/declarations#Methods-with-Special-Names)
    /// in *The Swift Programming Language*.
    ///
    /// - Parameter id: The identifier of the scene to dismiss.
    public func callAsFunction(id: String) { fatalError() }

    /// Dismisses the window defined by the window group that is presenting the
    /// specified value type.
    ///
    /// If multiple windows match the provided value, then they all will be
    /// dismissed. For dismissing a specific window in a specific group, use
    /// ``dismissWindow(id:value:)``.
    ///
    /// Don't call this method directly. SkipUI calls it when you
    /// call the ``EnvironmentValues/dismissWindow`` action with an identifier
    /// and a value:
    ///
    ///     dismissWindow(value: message.id)
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/declarations#Methods-with-Special-Names)
    /// in *The Swift Programming Language*.
    ///
    /// - Parameters:
    ///   - value: The value which is currently presented.
    public func callAsFunction<D>(value: D) where D : Decodable, D : Encodable, D : Hashable { fatalError() }

    /// Dismisses the window defined by the window group that is presenting the
    /// specified value type and that's associated with the specified identifier.
    ///
    /// Don't call this method directly. SkipUI calls it when you
    /// call the ``EnvironmentValues/dismissWindow`` action with an identifier
    /// and a value:
    ///
    ///     dismissWindow(id: "message", value: message.id)
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/declarations#Methods-with-Special-Names)
    /// in *The Swift Programming Language*.
    ///
    /// - Parameters:
    ///   - id: The identifier of the scene to dismiss.
    ///   - value: The value which is currently presented.
    public func callAsFunction<D>(id: String, value: D) where D : Decodable, D : Encodable, D : Hashable { fatalError() }
}

#endif
