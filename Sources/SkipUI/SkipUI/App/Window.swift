// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// A scene that presents a group of identically structured windows.
///
/// Use a `WindowGroup` as a container for a view hierarchy that your app
/// presents. The hierarchy that you declare as the group's content serves as a
/// template for each window that the app creates from that group:
///
///     @main
///     struct Mail: App {
///         var body: some Scene {
///             WindowGroup {
///                 MailViewer() // Define a view hierarchy for the window.
///             }
///         }
///     }
///
/// SkipUI takes care of certain platform-specific behaviors. For example,
/// on platforms that support it, like macOS and iPadOS, people can open more
/// than one window from the group simultaneously. In macOS, people
/// can gather open windows together in a tabbed interface. Also in macOS,
/// window groups automatically provide commands for standard window
/// management.
///
/// > Important: To enable an iPadOS app to simultaneously display multiple
/// windows, be sure to include the
/// 
/// key with a value of `true` in the
/// 
/// dictionary of your app's Information Property List.
///
/// Every window in the group maintains independent state. For example, the
/// system allocates new storage for any ``State`` or ``StateObject`` variables
/// instantiated by the scene's view hierarchy for each window that it creates.
///
/// For document-based apps, use ``DocumentGroup`` to define windows instead.
///
/// ### Open windows programmatically
///
/// If you initialize a window group with an identifier, a presentation type,
/// or both, you can programmatically open a window from the group. For example,
/// you can give the mail viewer scene from the previous example an identifier:
///
///     WindowGroup(id: "mail-viewer") { // Identify the window group.
///         MailViewer()
///     }
///
/// Elsewhere in your code, you can use the ``EnvironmentValues/openWindow``
/// action from the environment to create a new window from the group:
///
///     struct NewViewerButton: View {
///         @Environment(\.openWindow) private var openWindow
///
///         var body: some View {
///             Button("Open new mail viewer") {
///                 openWindow(id: "mail-viewer") // Match the group's identifier.
///             }
///         }
///     }
///
/// Be sure to use unique strings for identifiers that you apply to window
/// groups in your app.
///
/// ### Present data in a window
///
/// If you initialize a window group with a presentation type, you can pass
/// data of that type to the window when you open it. For example, you can
/// define a second window group for the Mail app that displays a specified
/// message:
///
///     @main
///     struct Mail: App {
///         var body: some Scene {
///             WindowGroup {
///                 MailViewer(id: "mail-viewer")
///             }
///
///             // A window group that displays messages.
///             WindowGroup(for: Message.ID.self) { $messageID in
///                 MessageDetail(messageID: messageID)
///             }
///         }
///     }
///
/// When you call the ``EnvironmentValues/openWindow`` action with a
/// value, SkipUI finds the window group with the matching type
/// and passes a binding to the value into the window group's content closure.
/// For example, you can define a button that opens a message by passing
/// the message's identifier:
///
///     struct NewMessageButton: View {
///         var message: Message
///         @Environment(\.openWindow) private var openWindow
///
///         var body: some View {
///             Button("Open message") {
///                 openWindow(value: message.id)
///             }
///         }
///     }
///
/// Be sure that the type you present conforms to both the
/// 
/// and  protocols.
/// Also, prefer lightweight data for the presentation value.
/// For model values that conform to the
///  protocol,
/// the value's identifier works well as a presentation type, as the above
/// example demonstrates.
///
/// If a window with a binding to the same value that you pass to the
/// `openWindow` action already appears in the user interface, the system
/// brings the existing window to the front rather than opening a new window.
/// If SkipUI doesn't have a value to provide --- for example, when someone
/// opens a window by choosing File > New Window from the macOS menu bar ---
/// SkipUI passes a binding to a `nil` value instead. To avoid receiving a
/// `nil` value, you can optionally specify a default value in your window
/// group initializer. For example, for the message viewer, you can present
/// a new empty message:
///
///     WindowGroup(for: Message.ID.self) { $messageID in
///         MessageDetail(messageID: messageID)
///     } defaultValue: {
///         model.makeNewMessage().id // A new message that your model stores.
///     }
///
/// SkipUI persists the value of the binding for the purposes of state
/// restoration, and reapplies the same value when restoring the window. If the
/// restoration process results in an error, SkipUI sets the binding to the
/// default value if you provide one, or `nil` otherwise.
///
/// ### Title your app's windows
///
/// To help people distinguish among windows from different groups,
/// include a title as the first parameter in the group's initializer:
///
///     WindowGroup("Message", for: Message.ID.self) { $messageID in
///         MessageDetail(messageID: messageID)
///     }
///
/// SkipUI uses this title when referring to the window in:
///
/// * The list of new windows that someone can open using the File > New menu.
/// * The window's title bar.
/// * The list of open windows that the Window menu displays.
///
/// If you don't provide a title for a window, the system refers to the window
/// using the app's name instead.
///
/// > Note: You can override the title that SkipUI uses for a window in the
///   window's title bar and the menu's list of open windows by adding one of
///   the ``View/navigationTitle(_:)-avgj`` modifiers to the window's content.
///   This enables you to customize and dynamically update the title for each
///   individual window instance.
///
/// ### Distinguish windows that present like data
///
/// To programmatically distinguish between windows that present the same type
/// of data, like when you use a
/// 
/// as the identifier for more than one model type, add the `id` parameter
/// to the group's initializer to provide a unique string identifier:
///
///     WindowGroup("Message", id: "message", for: UUID.self) { $uuid in
///         MessageDetail(uuid: uuid)
///     }
///     WindowGroup("Account", id: "account-info", for: UUID.self) { $uuid in
///         AccountDetail(uuid: uuid)
///     }
///
/// Then use both the identifer and a value to open the window:
///
///     struct ActionButtons: View {
///         var messageID: UUID
///         var accountID: UUID
///
///         @Environment(\.openWindow) private var openWindow
///
///         var body: some View {
///             HStack {
///                 Button("Open message") {
///                     openWindow(id: "message", value: messageID)
///                 }
///                 Button("Edit account information") {
///                     openWindow(id: "account-info", value: accountID)
///                 }
///             }
///         }
///     }
///
/// ### Dismiss a window programmatically
///
/// The system provides people with platform-appropriate controls to dismiss a
/// window. You can also dismiss windows programmatically by calling the
/// ``EnvironmentValues/dismiss`` action from within the window's view
/// hierarchy. For example, you can include a button in the account detail
/// view from the previous example that dismisses the view:
///
///     struct AccountDetail: View {
///         var uuid: UUID?
///         @Environment(\.dismiss) private var dismiss
///
///         var body: some View {
///             VStack {
///                 // ...
///
///                 Button("Dismiss") {
///                     dismiss()
///                 }
///             }
///         }
///     }
///
/// The dismiss action doesn't close the window if you call it from a
/// modal --- like a sheet or a popover --- that you present
/// from the window. In that case, the action dismisses the modal presentation
/// instead.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct WindowGroup<Content> : Scene where Content : View {

    /// Creates a window group with an identifier.
    ///
    /// The window group uses the given view as a
    /// template to form the content of each window in the group.
    ///
    /// - Parameters:
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - content: A closure that creates the content for each instance
    ///     of the group.
    public init(id: String, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a window group with a text view title and an identifier.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// > Important: The system ignores any text styling that you apply to
    ///   the ``Text`` view title, like bold or italics. However, you can use
    ///   the formatting controls that the view offers, like for localization,
    ///   dates, and numerical representations.
    ///
    /// - Parameters:
    ///   - title: The ``Text`` view to use for the group's title.
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - content: A closure that creates the content for each instance
    ///     of the group.
    public init(_ title: Text, id: String, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a window group with a localized title string and an
    /// identifier.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// - Parameters:
    ///   - titleKey: The title key to use for the title of the group.
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - content: A closure that creates the content for each instance
    ///     of the group.
    public init(_ titleKey: LocalizedStringKey, id: String, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a window group with a title string and an identifier.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// - Parameters:
    ///   - title: The string to use for the title of the group.
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - content: A closure that creates the content for each instance
    ///     of the group.
    public init<S>(_ title: S, id: String, @ViewBuilder content: () -> Content) where S : StringProtocol { fatalError() }

    /// Creates a window group.
    ///
    /// The window group uses the given view as a template to form the
    /// content of each window in the group.
    ///
    /// - Parameter content: A closure that creates the content for each
    ///   instance of the group.
    public init(@ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a window group with a text view title.
    ///
    /// The window group uses the given view as a
    /// template to form the content of each window in the group.
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// > Important: The system ignores any text styling that you apply to
    ///   the ``Text`` view title, like bold or italics. However, you can use
    ///   the formatting controls that the view offers, like for localization,
    ///   dates, and numerical representations.
    ///
    /// - Parameters:
    ///   - title: The ``Text`` view to use for the group's title.
    ///   - content: A closure that creates the content for each instance
    ///     of the group.
    public init(_ title: Text, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a window group with a localized title string.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// - Parameters:
    ///   - titleKey: The title key to use for the group's title.
    ///   - content: A closure that creates the content for each instance
    ///     of the group.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a window group with a title string.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// - Parameters:
    ///   - title: The string to use for the title of the group.
    ///   - content: A closure that creates the content for each instance
    ///     of the group.
    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol { fatalError() }

//    /// The content and behavior of the scene.
//    ///
//    /// For any scene that you create, provide a computed `body` property that
//    /// defines the scene as a composition of other scenes. You can assemble a
//    /// scene from built-in scenes that SkipUI provides, as well as other
//    /// scenes that you've defined.
//    ///
//    /// Swift infers the scene's ``SkipUI/Scene/Body-swift.associatedtype``
//    /// associated type based on the contents of the `body` property.
//    public func makeCache(subviews: Subviews) -> Never {
//        fatalError()
//    }
//
//    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
//        fatalError()
//    }
//
//    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
//        fatalError()
//    }


    /// The type of scene that represents the body of this scene.
    ///
    /// When you create a custom scene, Swift infers this type from your
    /// implementation of the required ``SkipUI/Scene/body-swift.property``
    /// property.
    public typealias Body = NeverView

    public var body: Body { fatalError() }
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension WindowGroup {

    /// Creates a data-presenting window group with an identifier.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    public init<D, C>(id: String, for type: D.Type, @ViewBuilder content: @escaping (Binding<D?>) -> C) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a text view title and an
    /// identifier.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// > Important: The system ignores any text styling that you apply to
    ///   the ``Text`` view title, like bold or italics. However, you can use
    ///   the formatting controls that the view offers, like for localization,
    ///   dates, and numerical representations.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - title: The ``Text`` view to use for the group's title.
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    public init<D, C>(_ title: Text, id: String, for type: D.Type, @ViewBuilder content: @escaping (Binding<D?>) -> C) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a localized title
    /// string and an identifier.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - titleKey: The title key to use for the group's title.
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    public init<D, C>(_ titleKey: LocalizedStringKey, id: String, for type: D.Type, @ViewBuilder content: @escaping (Binding<D?>) -> C) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a title string and an
    /// identifier.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - title: The string to use for the title of the group.
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    public init<S, D, C>(_ title: S, id: String, for type: D.Type, @ViewBuilder content: @escaping (Binding<D?>) -> C) where Content == PresentedWindowContent<D, C>, S : StringProtocol, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group.
    ///
    /// The window group uses the given view as a template to form the
    /// content of each window in the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    public init<D, C>(for type: D.Type, @ViewBuilder content: @escaping (Binding<D?>) -> C) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a text view title.
    ///
    /// The window group uses the given view as a
    /// template to form the content of each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// > Important: The system ignores any text styling that you apply to
    ///   the ``Text`` view title, like bold or italics. However, you can use
    ///   the formatting controls that the view offers, like for localization,
    ///   dates, and numerical representations.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - title: The ``Text`` view to use for the group's title.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    public init<D, C>(_ title: Text, for type: D.Type, @ViewBuilder content: @escaping (Binding<D?>) -> C) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a localized title
    /// string.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - titleKey: The title key to use for the group's title.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    public init<D, C>(_ titleKey: LocalizedStringKey, for type: D.Type, @ViewBuilder content: @escaping (Binding<D?>) -> C) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a title string.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - title: The string to use for the title of the group.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    public init<S, D, C>(_ title: S, for type: D.Type, @ViewBuilder content: @escaping (Binding<D?>) -> C) where Content == PresentedWindowContent<D, C>, S : StringProtocol, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with an identifier and a default
    /// value.
    ///
    /// The window group uses the given view as a
    /// template to form the content of each window in the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    ///   - defaultValue: A closure that returns a default value to present.
    ///     SkipUI calls this closure when it has no data to provide, like
    ///     when someone opens a new window from the File > New Window menu
    ///     item.
    public init<D, C>(id: String, for type: D.Type = D.self, @ViewBuilder content: @escaping (Binding<D>) -> C, defaultValue: @escaping () -> D) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a text view title, an
    /// identifier, and a default value.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// > Important: The system ignores any text styling that you apply to
    ///   the ``Text`` view title, like bold or italics. However, you can use
    ///   the formatting controls that the view offers, like for localization,
    ///   dates, and numerical representations.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - title: The ``Text`` view to use for the group's title.
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    ///   - defaultValue: A closure that returns a default value to present.
    ///     SkipUI calls this closure when it has no data to provide, like
    ///     when someone opens a new window from the File > New Window menu
    ///     item.
    public init<D, C>(_ title: Text, id: String, for type: D.Type = D.self, @ViewBuilder content: @escaping (Binding<D>) -> C, defaultValue: @escaping () -> D) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a localized title
    /// string, an identifier, and a default value.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - titleKey: The title key to use for the group's title.
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    ///   - defaultValue: A closure that returns a default value to present.
    ///     SkipUI calls this closure when it has no data to provide, like
    ///     when someone opens a new window from the File > New Window menu
    ///     item.
    public init<D, C>(_ titleKey: LocalizedStringKey, id: String, for type: D.Type = D.self, @ViewBuilder content: @escaping (Binding<D>) -> C, defaultValue: @escaping () -> D) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a title string, an
    /// identifier, and a default value.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - title: The string to use for the title of the group.
    ///   - id: A string that uniquely identifies the window group. Identifiers
    ///     must be unique among the window groups in your app.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    ///   - defaultValue: A closure that returns a default value to present.
    ///     SkipUI calls this closure when it has no data to provide, like
    ///     when someone opens a new window from the File > New Window menu
    ///     item.
    public init<S, D, C>(_ title: S, id: String, for type: D.Type = D.self, @ViewBuilder content: @escaping (Binding<D>) -> C, defaultValue: @escaping () -> D) where Content == PresentedWindowContent<D, C>, S : StringProtocol, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a default value.
    ///
    /// The window group using the given view as a template to form the
    /// content of each window in the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - type:The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    ///   - defaultValue: A closure that returns a default value to present.
    ///     SkipUI calls this closure when it has no data to provide, like
    ///     when someone opens a new window from the File > New Window menu
    ///     item.
    public init<D, C>(for type: D.Type = D.self, @ViewBuilder content: @escaping (Binding<D>) -> C, defaultValue: @escaping () -> D) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a text view title and a
    /// default value.
    ///
    /// The window group uses the given view as a
    /// template to form the content of each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// > Important: The system ignores any text styling that you apply to
    ///   the ``Text`` view title, like bold or italics. However, you can use
    ///   the formatting controls that the view offers, like for localization,
    ///   dates, and numerical representations.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - title: The ``Text`` view to use for the group's title.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    ///   - defaultValue: A closure that returns a default value to present.
    ///     SkipUI calls this closure when it has no data to provide, like
    ///     when someone opens a new window from the File > New Window menu
    ///     item.
    public init<D, C>(_ title: Text, for type: D.Type = D.self, @ViewBuilder content: @escaping (Binding<D>) -> C, defaultValue: @escaping () -> D) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a localized title
    /// string and a default value.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - titleKey: The title key to use for the group's title.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    ///   - defaultValue: A closure that returns a default value to present.
    ///     SkipUI calls this closure when it has no data to provide, like
    ///     when someone opens a new window from the File > New Window menu
    ///     item.
    public init<D, C>(_ titleKey: LocalizedStringKey, for type: D.Type = D.self, @ViewBuilder content: @escaping (Binding<D>) -> C, defaultValue: @escaping () -> D) where Content == PresentedWindowContent<D, C>, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }

    /// Creates a data-presenting window group with a title string and a default
    /// value.
    ///
    /// The window group uses the specified content as a
    /// template to create each window in the group.
    ///
    /// The system uses the title to distinguish the window group in the user
    /// interface, such as in the name of commands associated with the group.
    ///
    /// SkipUI creates a window from the group when you present a value
    /// of the specified type using the ``EnvironmentValues/openWindow`` action.
    ///
    /// - Parameters:
    ///   - title: The string to use for the title of the group.
    ///   - type: The type of presented data this window group accepts.
    ///   - content: A closure that creates the content for each instance
    ///     of the group. The closure receives a binding to the value that you
    ///     pass into the ``EnvironmentValues/openWindow`` action when you open
    ///     the window. SkipUI automatically persists and restores the value
    ///     of this binding as part of the state restoration process.
    ///   - defaultValue: A closure that returns a default value to present.
    ///     SkipUI calls this closure when it has no data to provide, like
    ///     when someone opens a new window from the File > New Window menu
    ///     item.
    public init<S, D, C>(_ title: S, for type: D.Type = D.self, @ViewBuilder content: @escaping (Binding<D>) -> C, defaultValue: @escaping () -> D) where Content == PresentedWindowContent<D, C>, S : StringProtocol, D : Decodable, D : Encodable, D : Hashable, C : View { fatalError() }
}

/// The resizability of a window.
///
/// Use the ``Scene/windowResizability(_:)`` scene modifier to apply a value
/// of this type to a ``Scene`` that you define in your ``App`` declaration.
/// The value that you specify indicates the strategy the system uses to
/// place minimum and maximum size restrictions on windows that it creates
/// from that scene.
///
/// For example, you can create a window group that people can resize to
/// between 100 and 400 points in both dimensions by applying both a frame
/// with those constraints to the scene's content, and the
/// ``WindowResizability/contentSize`` resizability to the scene:
///
///     @main
///     struct MyApp: App {
///         var body: some Scene {
///             WindowGroup {
///                 ContentView()
///                     .frame(
///                         minWidth: 100, maxWidth: 400,
///                         minHeight: 100, maxHeight: 400)
///             }
///             .windowResizability(.contentSize)
///         }
///     }
///
/// The default value for all scenes if you don't apply the modifier is
/// ``WindowResizability/automatic``. With that strategy, ``Settings``
/// windows use the ``WindowResizability/contentSize`` strategy, while
/// all others use ``WindowResizability/contentMinSize``.
@available(iOS 17.0, macOS 13.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct WindowResizability : Sendable {

    /// The automatic window resizability.
    ///
    /// When you use automatic resizability, SkipUI applies a resizing
    /// strategy that's appropriate for the scene type:
    /// * Windows from ``WindowGroup``, ``Window``, and ``DocumentGroup``
    ///   scene declarations use the ``contentMinSize`` strategy.
    /// * A window from a ``Settings`` scene declaration uses the
    ///   ``contentSize`` strategy.
    ///
    /// Automatic resizability is the default if you don't specify another
    /// value using the ``Scene/windowResizability(_:)`` scene modifier.
    public static var automatic: WindowResizability { get { fatalError() } }

    /// A window resizability that's derived from the window's content.
    ///
    /// Windows that use this resizability have:
    /// * A minimum size that matches the minimum size of the window's content.
    /// * A maximum size that matches the maximum size of the window's content.
    public static var contentSize: WindowResizability { get { fatalError() } }

    /// A window resizability that's partially derived from the window's
    /// content.
    ///
    /// Windows that use this resizability have:
    /// * A minimum size that matches the minimum size of the window's content.
    /// * No maximum size.
    public static var contentMinSize: WindowResizability { get { fatalError() } }
}

#endif
