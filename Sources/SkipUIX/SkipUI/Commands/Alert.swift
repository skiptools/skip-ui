// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

import protocol Foundation.LocalizedError

/// A representation of an alert presentation.
///
/// Use an alert when you want the user to act in response to the state of the
/// app or the system. If you want the user to make a choice in response to
/// their own action, use an ``ActionSheet`` instead.
///
/// You show an alert by using the ``View/alert(isPresented:content:)`` view
/// modifier to create an alert, which then appears whenever the bound
/// `isPresented` value is `true`. The `content` closure you provide to this
/// modifer produces a customized instance of the `Alert` type.
///
/// In the following example, a button presents a simple alert when
/// tapped, by updating a local `showAlert` property that binds to the alert.
///
///     @State private var showAlert = false
///     var body: some View {
///         Button("Tap to show alert") {
///             showAlert = true
///         }
///         .alert(isPresented: $showAlert) {
///             Alert(
///                 title: Text("Current Location Not Available"),
///                 message: Text("Your current location can’t be " +
///                                 "determined at this time.")
///             )
///         }
///     }
///
/// ![A default alert dialog with the title Current Location Not Available in bold
/// text, the message your current location can’t be determined at this time in
/// smaller text, and a default OK button.](SkipUI-Alert-OK.png)
///
/// To customize the alert, add instances of the ``Alert/Button`` type, which
/// provides standardized buttons for common tasks like canceling and performing
/// destructive actions. The following example uses two buttons: a default
/// button labeled "Try Again" that calls a `saveWorkoutData` method,
/// and a "destructive" button that calls a `deleteWorkoutData` method.
///
///     @State private var showAlert = false
///     var body: some View {
///         Button("Tap to show alert") {
///             showAlert = true
///         }
///         .alert(isPresented: $showAlert) {
///             Alert(
///                 title: Text("Unable to Save Workout Data"),
///                 message: Text("The connection to the server was lost."),
///                 primaryButton: .default(
///                     Text("Try Again"),
///                     action: saveWorkoutData
///                 ),
///                 secondaryButton: .destructive(
///                     Text("Delete"),
///                     action: deleteWorkoutData
///                 )
///             )
///         }
///     }
///
/// ![An alert dialog with the title, Unable to Save Workout Data in bold text, and
/// the message, The connection to the server was lost, in smaller text. Below
/// the text, two buttons: a default button with Try Again in blue text, and a
/// button with Delete in red text.](SkipUI-Alert-default-and-destructive.png)
///
/// The alert handles its own dismissal when the user taps one of the buttons in the alert, by setting
/// the bound `isPresented` value back to `false`.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use `View.alert(title:isPresented:presenting::actions:) instead.")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "use `View.alert(title:isPresented:presenting::actions:) instead.")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use `View.alert(title:isPresented:presenting::actions:) instead.")
@available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use `View.alert(title:isPresented:presenting::actions:) instead.")
public struct Alert {

    /// Creates an alert with one button.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message to display in the body of the alert.
    ///   - dismissButton: The button that dismisses the alert.
    public init(title: Text, message: Text? = nil, dismissButton: Alert.Button? = nil) { fatalError() }

    /// Creates an alert with two buttons.
    ///
    /// The system determines the visual ordering of the buttons.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message to display in the body of the alert.
    ///   - primaryButton: The first button to show in the alert.
    ///   - secondaryButton: The second button to show in the alert.
    public init(title: Text, message: Text? = nil, primaryButton: Alert.Button, secondaryButton: Alert.Button) { fatalError() }

    /// A button representing an operation of an alert presentation.
    public struct Button {

        /// Creates an alert button with the default style.
        /// - Parameters:
        ///   - label: The text to display on the button.
        ///   - action: A closure to execute when the user taps or presses the
        ///   button.
        /// - Returns: An alert button with the default style.
        public static func `default`(_ label: Text, action: (() -> Void)? = {}) -> Alert.Button { fatalError() }

        /// Creates an alert button that indicates cancellation, with a custom
        /// label.
        /// - Parameters:
        ///   - label: The text to display on the button.
        ///   - action: A closure to execute when the user taps or presses the
        ///   button.
        /// - Returns: An alert button that indicates cancellation.
        public static func cancel(_ label: Text, action: (() -> Void)? = {}) -> Alert.Button { fatalError() }

        /// Creates an alert button that indicates cancellation, with a
        /// system-provided label.
        ///
        /// The system automatically chooses locale-appropriate text for the
        /// button's label.
        /// - Parameter action: A closure to execute when the user taps or presses the
        ///   button.
        /// - Returns: An alert button that indicates cancellation.
        public static func cancel(_ action: (() -> Void)? = {}) -> Alert.Button { fatalError() }

        /// Creates an alert button with a style that indicates a destructive
        /// action.
        /// - Parameters:
        ///   - label: The text to display on the button.
        ///   - action: A closure to execute when the user taps or presses the
        ///   button.
        /// - Returns: An alert button that indicates a destructive action.
        public static func destructive(_ label: Text, action: (() -> Void)? = {}) -> Alert.Button { fatalError() }
    }
}


@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents an alert when a given condition is true, using a localized
    /// string key for the title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     "Login failed.",
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    public func alert<A>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A) -> some View where A : View { return never() }


    /// Presents an alert when a given condition is true, using a string
    /// variable as a title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///         let alertTitle: String = "Login failed."
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     alertTitle,
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    public func alert<S, A>(_ title: S, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A) -> some View where S : StringProtocol, A : View { return never() }


    /// Presents an alert when a given condition is true, using a text view for
    /// the title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///         let alertTitle: String = "Login failed."
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     Text(alertTitle),
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    public func alert<A>(_ title: Text, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A) -> some View where A : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents an alert with a message when a given condition is true, using
    /// a localized string key for a title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     "Login failed.",
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 } message: {
    ///                     Text("Please check your credentials and try again.")
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    ///   - message: A ``ViewBuilder`` returning the message for the alert.
    public func alert<A, M>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where A : View, M : View { return never() }


    /// Presents an alert with a message when a given condition is true using
    /// a string variable as a title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///         let alertTitle: String = "Login failed."
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     alertTitle,
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 } message: {
    ///                     Text("Please check your credentials and try again.")
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    ///   - message: A ``ViewBuilder`` returning the message for the alert.
    public func alert<S, A, M>(_ title: S, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where S : StringProtocol, A : View, M : View { return never() }


    /// Presents an alert with a message when a given condition is true using
    /// a text view as a title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///         let alertTitle: String = "Login failed."
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     Text(alertTitle),
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 } message: {
    ///                    Text("Please check your credentials and try again.")
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    ///   - message: A ``ViewBuilder`` returning the message for the alert.
    public func alert<A, M>(_ title: Text, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where A : View, M : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents an alert using the given data to produce the alert's content
    /// and a localized string key for a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///
    ///         var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 "Save failed.",
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    public func alert<A, T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where A : View { return never() }


    /// Presents an alert using the given data to produce the alert's content
    /// and a string variable as a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///         let alertTitle: String = "Save failed."
    ///
    ///         var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 alertTitle,
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    public func alert<S, A, T>(_ title: S, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where S : StringProtocol, A : View { return never() }


    /// Presents an alert using the given data to produce the alert's content
    /// and a text view as a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///         let alertTitle: String = "Save failed."
    ///
    ///             var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 Text(alertTitle),
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// - Parameters:
    ///   - title: the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    public func alert<A, T>(_ title: Text, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where A : View { return EmptyView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents an alert with a message using the given data to produce the
    /// alert's content and a localized string key for a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///
    ///         var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 "Save failed.",
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             } message: { details in
    ///                 Text(details.error)
    ///             }
    ///         }
    ///     }
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    ///   - message: A ``ViewBuilder`` returning the message for the alert given
    ///     the currently available data.
    public func alert<A, M, T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where A : View, M : View { return never() }


    /// Presents an alert with a message using the given data to produce the
    /// alert's content and a string variable as a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///         let alertTitle: String = "Save failed."
    ///
    ///         var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 alertTitle,
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             } message: { details in
    ///                 Text(details.error)
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    ///   - message: A ``ViewBuilder`` returning the message for the alert given
    ///     the currently available data.
    public func alert<S, A, M, T>(_ title: S, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where S : StringProtocol, A : View, M : View { return never() }


    /// Presents an alert with a message using the given data to produce the
    /// alert's content and a text view for a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///         let alertTitle: String = "Save failed."
    ///
    ///         var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 Text(alertTitle),
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             } message: { details in
    ///                 Text(details.error)
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// - Parameters:
    ///   - title: the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    ///   - message: A ``ViewBuilder`` returning the message for the alert given
    ///     the currently available data.
    public func alert<A, M, T>(_ title: Text, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where A : View, M : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents an alert when an error is present.
    ///
    /// In the example below, a form conditionally presents an alert depending
    /// upon the value of an error. When the error value isn't `nil`, the system
    /// presents an alert with an "OK" action.
    ///
    /// The title of the alert is inferred from the error's `errorDescription`.
    ///
    ///     struct TicketPurchase: View {
    ///         @State private var error: TicketPurchaseError? = nil
    ///         @State private var showAlert = false
    ///
    ///         var body: some View {
    ///             TicketForm(showAlert: $showAlert, error: $error)
    ///                 .alert(isPresented: $showAlert, error: error) {
    ///                     Button("OK") {
    ///                         // Handle acknowledgement.
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - error: An optional localized Error that is used to generate the
    ///     alert's title.  The system passes the contents to the modifier's
    ///     closures. You use this data to populate the fields of an alert that
    ///     you create that the system displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    public func alert<E, A>(isPresented: Binding<Bool>, error: E?, @ViewBuilder actions: () -> A) -> some View where E : LocalizedError, A : View { return never() }


    /// Presents an alert with a message when an error is present.
    ///
    /// In the example below, a form conditionally presents an alert depending
    /// upon the value of an error. When the error value isn't `nil`, the system
    /// presents an alert with an "OK" action.
    ///
    /// The title of the alert is inferred from the error's `errorDescription`.
    ///
    ///     struct TicketPurchase: View {
    ///         @State private var error: TicketPurchaseError? = nil
    ///         @State private var showAlert = false
    ///
    ///         var body: some View {
    ///             TicketForm(showAlert: $showAlert, error: $error)
    ///                 .alert(isPresented: $showAlert, error: error) { _ in
    ///                     Button("OK") {
    ///                         // Handle acknowledgement.
    ///                     }
    ///                 } message: { error in
    ///                     Text(error.recoverySuggestion ?? "Try again later.")
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - error: An optional localized Error that is used to generate the
    ///     alert's title.  The system passes the contents to the modifier's
    ///     closures. You use this data to populate the fields of an alert that
    ///     you create that the system displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    ///   - message: A view builder returning the message for the alert given
    ///     the current error.
    public func alert<E, A, M>(isPresented: Binding<Bool>, error: E?, @ViewBuilder actions: (E) -> A, @ViewBuilder message: (E) -> M) -> some View where E : LocalizedError, A : View, M : View { return never() }

}

#endif
