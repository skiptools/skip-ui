// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A control into which the user securely enters private text.
///
/// Use a `SecureField` when you want behavior similar to a ``TextField``, but
/// you don't want the user's text to be visible. Typically, you use this for
/// entering passwords and other sensitive information.
///
/// A `SecureField` uses a binding to a string value, and a closure that
/// executes when the user commits their edits, such as by pressing the
/// Return key. The field updates the bound string on every keystroke or
/// other edit, so you can read its value at any time from another control,
/// such as a Done button.
///
/// The following example shows a `SecureField` bound to the string `password`.
/// If the user commits their edit in the secure field, the `onCommit` closure
/// sends the password string to a `handleLogin()` method.
///
///     @State private var username: String = ""
///     @State private var password: String = ""
///
///     var body: some View {
///         TextField(
///             "User name (email address)",
///             text: $username)
///             .autocapitalization(.none)
///             .disableAutocorrection(true)
///             .border(Color(UIColor.separator))
///         SecureField(
///             "Password",
///             text: $password
///         ) {
///             handleLogin(username: username, password: password)
///         }
///         .border(Color(UIColor.separator))
///     }
///
/// ![Two vertically arranged views, the first a text field that displays the
/// email address mruiz2@icloud.com, the second view uses bullets in place of
/// the characters entered by the user for their password
/// password.](SkipUI-SecureField-withTextField.png)
///
/// ### SecureField prompts
///
/// A secure field may be provided an explicit prompt to guide users on what
/// text they should provide. The context in which a secure field appears
/// determines where and when a prompt and label may be used. For example, a
/// form on macOS will always place the label alongside the leading edge of
/// the field and will use a prompt, when available, as placeholder text within
/// the field itself. In the same context on iOS, the prompt or label will
/// be used as placeholder text depending on whether a prompt is provided.
///
///     Form {
///         TextField(text: $username, prompt: Text("Required")) {
///             Text("Username")
///         }
///         SecureField(text: $username, prompt: Text("Required")) {
///             Text("Password")
///        }
///     }
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SecureField<Label> : View where Label : View {

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

extension SecureField where Label == Text {

    /// Creates a secure field with a prompt generated from a `Text`.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this secure field.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of `self`, describing
    ///     its purpose.
    ///   - text: The text to display and edit
    ///   - prompt: A `Text` representing the prompt of the secure field
    ///     which provides users with guidance on what to type into the secure
    ///     field.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text?) { fatalError() }

    /// Creates a secure field with a prompt generated from a `Text`.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this secure field.
    ///
    /// - Parameters:
    ///   - title: The title of `self`, describing its purpose.
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the secure field
    ///     which provides users with guidance on what to type into the secure
    ///     field.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<S>(_ title: S, text: Binding<String>, prompt: Text?) where S : StringProtocol { fatalError() }
}

extension SecureField {

    /// Creates a secure field with a prompt generated from a `Text`.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the secure field
    ///     which provides users with guidance on what to type into the secure
    ///     field.
    ///   - label: A view that describes the purpose of the secure field.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init(text: Binding<String>, prompt: Text? = nil, @ViewBuilder label: () -> Label) { fatalError() }
}

extension SecureField where Label == Text {

    /// Creates a secure field with a prompt generated from a `Text`.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this secure field.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of `self`, describing
    ///     its purpose.
    ///   - text: The text to display and edit
    ///   - prompt: A `Text` representing the prompt of the secure field
    ///     which provides users with guidance on what to type into the secure
    ///     field.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>) { fatalError() }

    /// Creates a secure field with a prompt generated from a `Text`.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this secure field.
    ///
    /// - Parameters:
    ///   - title: The title of `self`, describing its purpose.
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the secure field
    ///     which provides users with guidance on what to type into the secure
    ///     field.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init<S>(_ title: S, text: Binding<String>) where S : StringProtocol { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SecureField where Label == Text {

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of `self`, describing
    ///     its purpose.
    ///   - text: The text to display and edit.
    ///   - onCommit: The action to perform when the user performs an action
    ///     (usually pressing the Return key) while the secure field has focus.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Renamed SecureField.init(_:text:). Use View.onSubmit(of:_:) for functionality previously provided by the onCommit parameter.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Renamed SecureField.init(_:text:). Use View.onSubmit(of:_:) for functionality previously provided by the onCommit parameter.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Renamed SecureField.init(_:text:). Use View.onSubmit(of:_:) for functionality previously provided by the onCommit parameter.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Renamed SecureField.init(_:text:). Use View.onSubmit(of:_:) for functionality previously provided by the onCommit parameter.")
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, onCommit: @escaping () -> Void) { fatalError() }

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - title: The title of `self`, describing its purpose.
    ///   - text: The text to display and edit.
    ///   - onCommit: The action to perform when the user performs an action
    ///     (usually pressing the Return key) while the secure field has focus.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Renamed SecureField.init(_:text:). Use View.onSubmit(of:_:) for functionality previously provided by the onCommit parameter.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Renamed SecureField.init(_:text:). Use View.onSubmit(of:_:) for functionality previously provided by the onCommit parameter.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Renamed SecureField.init(_:text:). Use View.onSubmit(of:_:) for functionality previously provided by the onCommit parameter.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Renamed SecureField.init(_:text:). Use View.onSubmit(of:_:) for functionality previously provided by the onCommit parameter.")
    public init<S>(_ title: S, text: Binding<String>, onCommit: @escaping () -> Void) where S : StringProtocol { fatalError() }
}

#endif
