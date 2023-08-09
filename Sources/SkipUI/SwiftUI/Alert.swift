// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
