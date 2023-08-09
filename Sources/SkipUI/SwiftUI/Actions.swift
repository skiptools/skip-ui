// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
    public init() where LabelX == Label<Text, Image> { fatalError() }

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
