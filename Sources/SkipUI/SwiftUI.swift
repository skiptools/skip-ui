// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import struct Foundation.Locale
import struct Foundation.IndexSet

/// No-op
@usableFromInline func stub<T>() -> T {
    fatalError("stub")
}

/// No-op
@usableFromInline func never() -> Never {
    stub()
}

/// A representation of an action sheet presentation.
///
/// Use an action sheet when you want the user to make a choice between two
/// or more options, in response to their own action. If you want the user to
/// act in response to the state of the app or the system, rather than a user
/// action, use an ``Alert`` instead.
///
/// You show an action sheet by using the
/// ``View/actionSheet(isPresented:content:)`` view modifier to create an
/// action sheet, which then appears whenever the bound `isPresented` value is
/// `true`. The `content` closure you provide to this modifier produces a
/// customized instance of the `ActionSheet` type. To supply the options, create
/// instances of ``ActionSheet/Button`` to distinguish between ordinary options,
/// destructive options, and cancellation of the user's original action.
///
/// The action sheet handles its own dismissal by setting the bound
/// `isPresented` value back to `false` when the user taps a button in the
/// action sheet.
///
/// The following example creates an action sheet with three options: a Cancel
/// button, a destructive button, and a default button. The second and third of
/// these call methods are named `overwriteWorkout` and `appendWorkout`,
/// respectively.
///
///     @State private var showActionSheet = false
///     var body: some View {
///         Button("Tap to show action sheet") {
///             showActionSheet = true
///         }
///         .actionSheet(isPresented: $showActionSheet) {
///             ActionSheet(title: Text("Resume Workout Recording"),
///                         message: Text("Choose a destination for workout data"),
///                         buttons: [
///                             .cancel(),
///                             .destructive(
///                                 Text("Overwrite Current Workout"),
///                                 action: overwriteWorkout
///                             ),
///                             .default(
///                                 Text("Append to Current Workout"),
///                                 action: appendWorkout
///                             )
///                         ]
///             )
///         }
///     }
///
/// The system may interpret the order of items as they appear in the `buttons`
/// array to accommodate platform conventions. In this example, the Cancel
/// button is the first member of the array, but the action sheet puts it in its
/// standard position at the bottom of the sheet.
///
/// ![An action sheet with the title Resume Workout Recording in bold text and
/// the message Choose a destination for workout data in smaller text. Below
/// the text, three buttons: a destructive Overwrite Current Workout button in
/// red, a default-styled Overwrite Current Workout button, and a Cancel button,
/// farther below and set off in its own button
/// group.](SkipUI-ActionSheet-cancel-and-destructive.png)
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use `View.confirmationDialog(title:isPresented:titleVisibility:presenting::actions:)`instead.")
@available(macOS, unavailable)
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use `View.confirmationDialog(title:isPresented:titleVisibility:presenting:actions:)`instead.")
@available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use `View.confirmationDialog(title:isPresented:titleVisibility:presenting:actions:)`instead.")
public struct ActionSheet {

    /// Creates an action sheet with the provided buttons.
    /// - Parameters:
    ///   - title: The title of the action sheet.
    ///   - message: The message to display in the body of the action sheet.
    ///   - buttons: The buttons to show in the action sheet.
    public init(title: Text, message: Text? = nil, buttons: [ActionSheet.Button] = [.cancel()]) { fatalError() }

    /// A button representing an operation of an action sheet presentation.
    ///
    /// The ``ActionSheet`` button is type-aliased to the ``Alert`` button type,
    /// which provides default, cancel, and destructive styles.
    public typealias Button = Alert.Button
}

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

/// An alignment in both axes.
///
/// An `Alignment` contains a ``HorizontalAlignment`` guide and a
/// ``VerticalAlignment`` guide. Specify an alignment to direct the behavior of
/// certain layout containers and modifiers, like when you place views in a
/// ``ZStack``, or layer a view in front of or behind another view using
/// ``View/overlay(alignment:content:)`` or
/// ``View/background(alignment:content:)``, respectively. During layout,
/// SkipUI brings the specified guides of the affected views together,
/// aligning the views.
///
/// SkipUI provides a set of built-in alignments that represent common
/// combinations of the built-in horizontal and vertical alignment guides.
/// The blue boxes in the following diagram demonstrate the alignment named
/// by each box's label, relative to the background view:
///
/// ![A square that's divided into four equal quadrants. The upper-
/// left quadrant contains the text, Some text in an upper quadrant. The
/// lower-right quadrant contains the text, More text in a lower quadrant.
/// In both cases, the text is split over two lines. A variety of blue
/// boxes are overlaid atop the square. Each contains the name of a built-in
/// alignment, and is aligned with the square in a way that matches the
/// alignment name. For example, the box lableled center appears at the
/// center of the square.](Alignment-1-iOS)
///
/// The following code generates the diagram above, where each blue box appears
/// in an overlay that's configured with a different alignment:
///
///     struct AlignmentGallery: View {
///         var body: some View {
///             BackgroundView()
///                 .overlay(alignment: .topLeading) { box(".topLeading") }
///                 .overlay(alignment: .top) { box(".top") }
///                 .overlay(alignment: .topTrailing) { box(".topTrailing") }
///                 .overlay(alignment: .leading) { box(".leading") }
///                 .overlay(alignment: .center) { box(".center") }
///                 .overlay(alignment: .trailing) { box(".trailing") }
///                 .overlay(alignment: .bottomLeading) { box(".bottomLeading") }
///                 .overlay(alignment: .bottom) { box(".bottom") }
///                 .overlay(alignment: .bottomTrailing) { box(".bottomTrailing") }
///                 .overlay(alignment: .leadingLastTextBaseline) { box(".leadingLastTextBaseline") }
///                 .overlay(alignment: .trailingFirstTextBaseline) { box(".trailingFirstTextBaseline") }
///         }
///
///         private func box(_ name: String) -> some View {
///             Text(name)
///                 .font(.system(.caption, design: .monospaced))
///                 .padding(2)
///                 .foregroundColor(.white)
///                 .background(.blue.opacity(0.8), in: Rectangle())
///         }
///     }
///
///     private struct BackgroundView: View {
///         var body: some View {
///             Grid(horizontalSpacing: 0, verticalSpacing: 0) {
///                 GridRow {
///                     Text("Some text in an upper quadrant")
///                     Color.gray.opacity(0.3)
///                 }
///                 GridRow {
///                     Color.gray.opacity(0.3)
///                     Text("More text in a lower quadrant")
///                 }
///             }
///             .aspectRatio(1, contentMode: .fit)
///             .foregroundColor(.secondary)
///             .border(.gray)
///         }
///     }
///
/// To avoid crowding, the alignment diagram shows only two of the available
/// text baseline alignments. The others align as their names imply. Notice that
/// the first text baseline alignment aligns with the top-most line of text in
/// the background view, while the last text baseline aligns with the
/// bottom-most line. For more information about text baseline alignment, see
/// ``VerticalAlignment``.
///
/// In a left-to-right language like English, the leading and trailing
/// alignments appear on the left and right edges, respectively. SkipUI
/// reverses these in right-to-left language environments. For more
/// information, see ``HorizontalAlignment``.
///
/// ### Custom alignment
///
/// You can create custom alignments --- which you typically do to make use
/// of custom horizontal or vertical guides --- by using the
/// ``init(horizontal:vertical:)`` initializer. For example, you can combine
/// a custom vertical guide called `firstThird` with the built-in horizontal
/// ``HorizontalAlignment/center`` guide, and use it to configure a ``ZStack``:
///
///     ZStack(alignment: Alignment(horizontal: .center, vertical: .firstThird)) {
///         // ...
///     }
///
/// For more information about creating custom guides, including the code
/// that creates the custom `firstThird` alignment in the example above,
/// see ``AlignmentID``.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Alignment : Equatable {

    /// The alignment on the horizontal axis.
    ///
    /// Set this value when you initialize an alignment using the
    /// ``init(horizontal:vertical:)`` method. Use one of the built-in
    /// ``HorizontalAlignment`` guides, like ``HorizontalAlignment/center``,
    /// or a custom guide that you create.
    ///
    /// For information about creating custom guides, see ``AlignmentID``.
    public var horizontal: HorizontalAlignment { get { fatalError() } }

    /// The alignment on the vertical axis.
    ///
    /// Set this value when you initialize an alignment using the
    /// ``init(horizontal:vertical:)`` method. Use one of the built-in
    /// ``VerticalAlignment`` guides, like ``VerticalAlignment/center``,
    /// or a custom guide that you create.
    ///
    /// For information about creating custom guides, see ``AlignmentID``.
    public var vertical: VerticalAlignment { get { fatalError() } }

    /// Creates a custom alignment value with the specified horizontal
    /// and vertical alignment guides.
    ///
    /// SkipUI provides a variety of built-in alignments that combine built-in
    /// ``HorizontalAlignment`` and ``VerticalAlignment`` guides. Use this
    /// initializer to create a custom alignment that makes use
    /// of a custom horizontal or vertical guide, or both.
    ///
    /// For example, you can combine a custom vertical guide called
    /// `firstThird` with the built-in ``HorizontalAlignment/center``
    /// guide, and use it to configure a ``ZStack``:
    ///
    ///     ZStack(alignment: Alignment(horizontal: .center, vertical: .firstThird)) {
    ///         // ...
    ///     }
    ///
    /// For more information about creating custom guides, including the code
    /// that creates the custom `firstThird` alignment in the example above,
    /// see ``AlignmentID``.
    ///
    /// - Parameters:
    ///   - horizontal: The alignment on the horizontal axis.
    ///   - vertical: The alignment on the vertical axis.
    @inlinable public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) { fatalError() }

    public static func == (a: Alignment, b: Alignment) -> Bool { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Alignment {

    /// A guide that marks the center of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/center``
    /// horizontal guide and the ``VerticalAlignment/center``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, Center, appears at the center of the
    /// square.](Alignment-center-1-iOS)
    public static let center: Alignment = { fatalError() }()

    /// A guide that marks the leading edge of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/leading``
    /// horizontal guide and the ``VerticalAlignment/center``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, Leading, appears on the left edge of the
    /// square, centered vertically.](Alignment-leading-1-iOS)
    public static let leading: Alignment = { fatalError() }()

    /// A guide that marks the trailing edge of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/trailing``
    /// horizontal guide and the ``VerticalAlignment/center``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, Trailing, appears on the right edge of the
    /// square, centered vertically.](Alignment-trailing-1-iOS)
    public static let trailing: Alignment = { fatalError() }()

    /// A guide that marks the top edge of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/center``
    /// horizontal guide and the ``VerticalAlignment/top``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, Top, appears on the top edge of the
    /// square, centered horizontally.](Alignment-top-1-iOS)
    public static let top: Alignment = { fatalError() }()

    /// A guide that marks the bottom edge of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/center``
    /// horizontal guide and the ``VerticalAlignment/bottom``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, Bottom, appears on the bottom edge of the
    /// square, centered horizontally.](Alignment-bottom-1-iOS)
    public static let bottom: Alignment = { fatalError() }()

    /// A guide that marks the top and leading edges of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/leading``
    /// horizontal guide and the ``VerticalAlignment/top``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, topLeading, appears in the upper-left corner of
    /// the square.](Alignment-topLeading-1-iOS)
    public static let topLeading: Alignment = { fatalError() }()

    /// A guide that marks the top and trailing edges of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/trailing``
    /// horizontal guide and the ``VerticalAlignment/top``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, topTrailing, appears in the upper-right corner of
    /// the square.](Alignment-topTrailing-1-iOS)
    public static let topTrailing: Alignment = { fatalError() }()

    /// A guide that marks the bottom and leading edges of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/leading``
    /// horizontal guide and the ``VerticalAlignment/bottom``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, bottomLeading, appears in the lower-left corner of
    /// the square.](Alignment-bottomLeading-1-iOS)
    public static let bottomLeading: Alignment = { fatalError() }()

    /// A guide that marks the bottom and trailing edges of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/trailing``
    /// horizontal guide and the ``VerticalAlignment/bottom``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, bottomTrailing, appears in the lower-right corner of
    /// the square.](Alignment-bottomTrailing-1-iOS)
    public static let bottomTrailing: Alignment = { fatalError() }()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Alignment {

    /// A guide that marks the top-most text baseline in a view.
    ///
    /// This alignment combines the ``HorizontalAlignment/center``
    /// horizontal guide and the ``VerticalAlignment/firstTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, centerFirstTextBaseline, appears aligned with, and
    /// partially overlapping, the first line of the text in the upper quadrant,
    /// centered horizontally.](Alignment-centerFirstTextBaseline-1-iOS)
    public static var centerFirstTextBaseline: Alignment { get { fatalError() } }

    /// A guide that marks the bottom-most text baseline in a view.
    ///
    /// This alignment combines the ``HorizontalAlignment/center``
    /// horizontal guide and the ``VerticalAlignment/lastTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, centerLastTextBaseline, appears aligned with, and
    /// partially overlapping, the last line of the text in the lower quadrant,
    /// centered horizontally.](Alignment-centerLastTextBaseline-1-iOS)
    public static var centerLastTextBaseline: Alignment { get { fatalError() } }

    /// A guide that marks the leading edge and top-most text baseline in a
    /// view.
    ///
    /// This alignment combines the ``HorizontalAlignment/leading``
    /// horizontal guide and the ``VerticalAlignment/firstTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, leadingFirstTextBaseline, appears aligned with, and
    /// partially overlapping, the first line of the text in the upper quadrant.
    /// The box aligns with the left edge of the
    /// square.](Alignment-leadingFirstTextBaseline-1-iOS)
    public static var leadingFirstTextBaseline: Alignment { get { fatalError() } }

    /// A guide that marks the leading edge and bottom-most text baseline
    /// in a view.
    ///
    /// This alignment combines the ``HorizontalAlignment/leading``
    /// horizontal guide and the ``VerticalAlignment/lastTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, leadingLastTextBaseline, appears aligned with the
    /// last line of the text in the lower quadrant. The box aligns with the
    /// left edge of the square.](Alignment-leadingLastTextBaseline-1-iOS)
    public static var leadingLastTextBaseline: Alignment { get { fatalError() } }

    /// A guide that marks the trailing edge and top-most text baseline in
    /// a view.
    ///
    /// This alignment combines the ``HorizontalAlignment/trailing``
    /// horizontal guide and the ``VerticalAlignment/firstTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, trailingFirstTextBaseline, appears aligned with the
    /// first line of the text in the upper quadrant. The box aligns with the
    /// right edge of the square.](Alignment-trailingFirstTextBaseline-1-iOS)
    public static var trailingFirstTextBaseline: Alignment { get { fatalError() } }

    /// A guide that marks the trailing edge and bottom-most text baseline
    /// in a view.
    ///
    /// This alignment combines the ``HorizontalAlignment/trailing``
    /// horizontal guide and the ``VerticalAlignment/lastTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, trailingLastTextBaseline, appears aligned with the
    /// last line of the text in the lower quadrant. The box aligns with the
    /// right edge of the square.](Alignment-trailingLastTextBaseline-1-iOS)
    public static var trailingLastTextBaseline: Alignment { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Alignment : Sendable {
}

/// A type that you use to create custom alignment guides.
///
/// Every built-in alignment guide that ``VerticalAlignment`` or
/// ``HorizontalAlignment`` defines as a static property, like
/// ``VerticalAlignment/top`` or ``HorizontalAlignment/leading``, has a
/// unique alignment identifier type that produces the default offset for
/// that guide. To create a custom alignment guide, define your own alignment
/// identifier as a type that conforms to the `AlignmentID` protocol, and
/// implement the required ``AlignmentID/defaultValue(in:)`` method:
///
///     private struct FirstThirdAlignment: AlignmentID {
///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
///             context.height / 3
///         }
///     }
///
/// When implementing the method, calculate the guide's default offset
/// from the view's origin. If it's helpful, you can use information from the
/// ``ViewDimensions`` input in the calculation. This parameter provides context
/// about the specific view that's using the guide. The above example creates an
/// identifier called `FirstThirdAlignment` and calculates a default value
/// that's one-third of the height of the aligned view.
///
/// Use the identifier's type to create a static property in an extension of
/// one of the alignment guide types, like ``VerticalAlignment``:
///
///     extension VerticalAlignment {
///         static let firstThird = VerticalAlignment(FirstThirdAlignment.self)
///     }
///
/// You can apply your custom guide like any of the built-in guides. For
/// example, you can use an ``HStack`` to align its views at one-third
/// of their height using the guide defined above:
///
///     struct StripesGroup: View {
///         var body: some View {
///             HStack(alignment: .firstThird, spacing: 1) {
///                 HorizontalStripes().frame(height: 60)
///                 HorizontalStripes().frame(height: 120)
///                 HorizontalStripes().frame(height: 90)
///             }
///         }
///     }
///
///     struct HorizontalStripes: View {
///         var body: some View {
///             VStack(spacing: 1) {
///                 ForEach(0..<3) { _ in Color.blue }
///             }
///         }
///     }
///
/// Because each set of stripes has three equal, vertically stacked
/// rectangles, they align at the bottom edge of the top rectangle. This
/// corresponds in each case to a third of the overall height, as
/// measured from the origin at the top of each set of stripes:
///
/// ![Three vertical stacks of rectangles, arranged in a row.
/// The rectangles in each stack have the same height as each other, but
/// different heights than the rectangles in the other stacks. The bottom edges
/// of the top-most rectangle in each stack are aligned with each
/// other.](AlignmentId-1-iOS)
///
/// You can also use the ``View/alignmentGuide(_:computeValue:)-6y3u2`` view
/// modifier to alter the behavior of your custom guide for a view, as you
/// might alter a built-in guide. For example, you can change
/// one of the stacks of stripes from the previous example to align its
/// `firstThird` guide at two thirds of the height instead:
///
///     struct StripesGroupModified: View {
///         var body: some View {
///             HStack(alignment: .firstThird, spacing: 1) {
///                 HorizontalStripes().frame(height: 60)
///                 HorizontalStripes().frame(height: 120)
///                 HorizontalStripes().frame(height: 90)
///                     .alignmentGuide(.firstThird) { context in
///                         2 * context.height / 3
///                     }
///             }
///         }
///     }
///
/// The modified guide calculation causes the affected view to place the
/// bottom edge of its middle rectangle on the `firstThird` guide, which aligns
/// with the bottom edge of the top rectangle in the other two groups:
///
/// ![Three vertical stacks of rectangles, arranged in a row.
/// The rectangles in each stack have the same height as each other, but
/// different heights than the rectangles in the other stacks. The bottom edges
/// of the top-most rectangle in the first two stacks are aligned with each
/// other, and with the bottom edge of the middle rectangle in the third
/// stack.](AlignmentId-2-iOS)
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol AlignmentID {

    /// Calculates a default value for the corresponding guide in the specified
    /// context.
    ///
    /// Implement this method when you create a type that conforms to the
    /// ``AlignmentID`` protocol. Use the method to calculate the default
    /// offset of the corresponding alignment guide. SkipUI interprets the
    /// value that you return as an offset in the coordinate space of the
    /// view that's being laid out. For example, you can use the context to
    /// return a value that's one-third of the height of the view:
    ///
    ///     private struct FirstThirdAlignment: AlignmentID {
    ///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
    ///             context.height / 3
    ///         }
    ///     }
    ///
    /// You can override the default value that this method returns for a
    /// particular guide by adding the
    /// ``View/alignmentGuide(_:computeValue:)-9mdoh`` view modifier to a
    /// particular view.
    ///
    /// - Parameter context: The context of the view that you apply
    ///   the alignment guide to. The context gives you the view's dimensions,
    ///   as well as the values of other alignment guides that apply to the
    ///   view, including both built-in and custom guides. You can use any of
    ///   these values, if helpful, to calculate the value for your custom
    ///   guide.
    ///
    /// - Returns: The offset of the guide from the origin in the
    ///   view's coordinate space.
    static func defaultValue(in context: ViewDimensions) -> CGFloat
}

//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AnyShapeStyle.Storage : @unchecked Sendable {
//}

/// The default control group style.
///
/// You can also use ``ControlGroupStyle/automatic`` to construct this style.
@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct AutomaticControlGroupStyle : ControlGroupStyle {

    /// Creates a view representing the body of a control group.
    ///
    /// - Parameter configuration: The properties of the control group instance
    ///   being created.
    ///
    /// This method will be called for each instance of ``ControlGroup`` created
    /// within a view hierarchy where this style is the current
    /// `ControlGroupStyle`.
    @MainActor public func makeBody(configuration: AutomaticControlGroupStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a control group.
//    public typealias Body = some View
}

/// A disclosure group style that resolves its appearance automatically
/// based on the current context.
///
/// Use ``DisclosureGroupStyle/automatic`` to construct this style.
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct AutomaticDisclosureGroupStyle : DisclosureGroupStyle {

    /// Creates an automatic disclosure group style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a disclosure group.
    ///
    /// SkipUI calls this method for each instance of ``DisclosureGroup``
    /// that you create within a view hierarchy where this style is the current
    /// ``DisclosureGroupStyle``.
    ///
    /// - Parameter configuration: The properties of the instance being created.
    public func makeBody(configuration: AutomaticDisclosureGroupStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a disclosure group.
//    public typealias Body = some View
}

/// The default form style.
///
/// Use the ``FormStyle/automatic`` static variable to create this style:
///
///     Form {
///        ...
///     }
///     .formStyle(.automatic)
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct AutomaticFormStyle : FormStyle {

    /// Creates a default form style.
    ///
    /// Don't call this initializer directly. Instead, use the
    /// ``FormStyle/automatic`` static variable to create this style:
    ///
    ///     Form {
    ///        ...
    ///     }
    ///     .formStyle(.automatic)
    ///
    public init() { fatalError() }

    /// Creates a view that represents the body of a form.
    ///
    /// - Parameter configuration: The properties of the form.
    /// - Returns: A view that has behavior and appearance that enables it
    ///   to function as a ``Form``.
    public func makeBody(configuration: AutomaticFormStyle.Configuration) -> some View { return never() }


    /// A view that represents the appearance and interaction of a form.
//    public typealias Body = some View
}

/// The default labeled content style.
///
/// Use ``LabeledContentStyle/automatic`` to construct this style.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct AutomaticLabeledContentStyle : LabeledContentStyle {

    /// Creates an automatic labeled content style.
    public init() { fatalError() }

    /// Creates a view that represents the body of labeled content.
    public func makeBody(configuration: AutomaticLabeledContentStyle.Configuration) -> some View { return never() }


    /// A view that represents the appearance and behavior of labeled content.
//    public typealias Body = some View
}

/// A navigation split style that resolves its appearance automatically
/// based on the current context.
///
/// Use ``NavigationSplitViewStyle/automatic`` to construct this style.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct AutomaticNavigationSplitViewStyle : NavigationSplitViewStyle {

    /// Creates an instance of the automatic navigation split view style.
    ///
    /// Use ``NavigationSplitViewStyle/automatic`` to construct this style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a navigation split view.
    ///
    /// SkipUI calls this method for each instance of ``NavigationSplitView``,
    /// where this style is the current ``NavigationSplitViewStyle``.
    ///
    /// - Parameter configuration: The properties of the instance to create.
    public func makeBody(configuration: AutomaticNavigationSplitViewStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a navigation split view.
//    public typealias Body = some View
}

/// The default table style in the current context.
///
/// You can also use ``TableStyle/automatic`` to construct this style.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct AutomaticTableStyle : TableStyle {

    /// Creates a view that represents the body of a table.
    ///
    /// The system calls this method for each ``Table`` instance in a view
    /// hierarchy where this style is the current table style.
    ///
    /// - Parameter configuration: The properties of the table.
    public func makeBody(configuration: AutomaticTableStyle.Configuration) -> Body { return never() }


    /// A view that represents the body of a table.
    public typealias Body = Never
}

/// The default text editor style, based on the text editor's context.
///
/// You can also use ``TextEditorStyle/automatic`` to construct this style.
@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct AutomaticTextEditorStyle : TextEditorStyle {

    /// Creates a view that represents the body of a text editor.
    ///
    /// The system calls this method for each ``TextEditor`` instance in a view
    /// hierarchy where this style is the current text editor style.
    ///
    /// - Parameter configuration: The properties of the text editor.
    public func makeBody(configuration: AutomaticTextEditorStyle.Configuration) -> AutomaticTextEditorStyle.Body { Body() }

    public init() { fatalError() }

    /// A view that represents the body of a text editor.
    public struct Body : View {

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
        @MainActor public var body: Body { get { return never() } }

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
    }
}

/// The horizontal or vertical dimension in a 2D coordinate system.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public enum Axis : Int8, CaseIterable {

    /// The horizontal dimension.
    case horizontal

    /// The vertical dimension.
    case vertical

    /// An efficient set of axes.
    @frozen public struct Set : OptionSet {

        /// The element type of the option set.
        ///
        /// To inherit all the default implementations from the `OptionSet` protocol,
        /// the `Element` type must be `Self`, the default.
        public typealias Element = Axis.Set

        /// The corresponding value of the raw type.
        ///
        /// A new instance initialized with `rawValue` will be equivalent to this
        /// instance. For example:
        ///
        ///     enum PaperSize: String {
        ///         case A4, A5, Letter, Legal
        ///     }
        ///
        ///     let selectedSize = PaperSize.Letter
        ///     print(selectedSize.rawValue)
        ///     // Prints "Letter"
        ///
        ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
        ///     // Prints "true"
        public let rawValue: Int8

        /// Creates a new option set from the given raw value.
        ///
        /// This initializer always succeeds, even if the value passed as `rawValue`
        /// exceeds the static properties declared as part of the option set. This
        /// example creates an instance of `ShippingOptions` with a raw value beyond
        /// the highest element, with a bit mask that effectively contains all the
        /// declared static members.
        ///
        ///     let extraOptions = ShippingOptions(rawValue: 255)
        ///     print(extraOptions.isStrictSuperset(of: .all))
        ///     // Prints "true"
        ///
        /// - Parameter rawValue: The raw value of the option set to create. Each bit
        ///   of `rawValue` potentially represents an element of the option set,
        ///   though raw values may include bits that are not defined as distinct
        ///   values of the `OptionSet` type.
        public init(rawValue: Int8) { fatalError() }

        public static let horizontal: Axis.Set = { fatalError() }()

        public static let vertical: Axis.Set = { fatalError() }()

        /// The type of the elements of an array literal.
        public typealias ArrayLiteralElement = Axis.Set.Element

        /// The raw type that can be used to represent all values of the conforming
        /// type.
        ///
        /// Every distinct value of the conforming type has a corresponding unique
        /// value of the `RawValue` type, but there may be values of the `RawValue`
        /// type that don't have a corresponding value of the conforming type.
        public typealias RawValue = Int8
    }

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional("PaperSize.Legal")"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: Int8) { fatalError() }

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [Axis]

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int8

    /// A collection of all values of this type.
    public static var allCases: [Axis] { get { fatalError() } }

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: Int8 { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Axis : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Axis : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Axis : Hashable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Axis : RawRepresentable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Axis : Sendable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Axis.Set : Sendable {
}

/// The prominence of backgrounds underneath other views.
///
/// Background prominence should influence foreground styling to maintain
/// sufficient contrast against the background. For example, selected rows in
/// a `List` and `Table` can have increased prominence backgrounds with
/// accent color fills when focused; the foreground content above the background
/// should be adjusted to reflect that level of prominence.
///
/// This can be read and written for views with the
/// `EnvironmentValues.backgroundProminence` property.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct BackgroundProminence : Hashable, Sendable {

    /// The standard prominence of a background
    ///
    /// This is the default level of prominence and doesn't require any
    /// adjustment to achieve satisfactory contrast with the background.
    public static let standard: BackgroundProminence = { fatalError() }()

    /// A more prominent background that likely requires some changes to the
    /// views above it.
    ///
    /// This is the level of prominence for more highly saturated and full
    /// color backgrounds, such as focused/emphasized selected list rows.
    /// Typically foreground content should take on monochrome styling to
    /// have greater contrast against the background.
    public static let increased: BackgroundProminence = { fatalError() }()

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (a: BackgroundProminence, b: BackgroundProminence) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// The kinds of background tasks that your app or extension can handle.
///
/// Use a value of this type with the ``Scene/backgroundTask(_:action:)`` scene
/// modifier to create a handler for background tasks that the system sends
/// to your app or extension. For example, you can use ``urlSession`` to define
/// an asynchronous closure that the system calls when it launches your app or
/// extension to handle a response from a background
/// .
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct BackgroundTask<Request, Response> : Sendable {
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension BackgroundTask {

    /// A task that responds to background URL sessions.
    public static var urlSession: BackgroundTask<String, Void> { get { fatalError() } }

    /// A task that responds to background URL sessions matching the given
    /// identifier.
    ///
    /// - Parameter identifier: The identifier to match.
    ///
    /// - Returns: A background task that you can handle with your app or
    ///   extension.
    public static func urlSession(_ identifier: String) -> BackgroundTask<Void, Void> { fatalError() }

    /// A task that responds to background URL sessions matching the given
    /// predicate.
    ///
    /// - Parameter matching: The predicate to match.
    ///
    /// - Returns: A background task that you can handle with your app or
    ///   extension.
    public static func urlSession(matching: @escaping @Sendable (String) -> Bool) -> BackgroundTask<String, Void> { fatalError() }

    /// A task that updates your app’s state in the background for a
    /// matching identifier.
    ///
    /// - Parameter matching: The identifier to match.
    ///
    /// - Returns: A background task that you can handle with your app or
    ///   extension.
    @available(macOS, unavailable)
    public static func appRefresh(_ identifier: String) -> BackgroundTask<Void, Void> { fatalError() }
}

/// The visual prominence of a badge.
///
/// Badges can be used for different kinds of information, from the
/// passive number of items in a container to the number of required
/// actions. The prominence of badges in Lists can be adjusted to reflect
/// this and be made to draw more or less attention to themselves.
///
/// Badges will default to `standard` prominence unless specified.
///
/// The following example shows a ``List`` displaying a list of folders
/// with an informational badge with lower prominence, showing the number
/// of items in the folder.
///
///     List(folders) { folder in
///         Text(folder.name)
///             .badge(folder.numberOfItems)
///     }
///     .badgeProminence(.decreased)
///
@available(iOS 17.0, macOS 14.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct BadgeProminence : Hashable, Sendable {

    /// The lowest level of prominence for a badge.
    ///
    /// This level or prominence should be used for badges that display a value
    /// of passive information that requires no user action, such as total
    /// number of messages or content.
    ///
    /// In lists on iOS and macOS, this results in badge labels being
    /// displayed without any extra decoration. On iOS, this looks the same as
    /// `.standard`.
    ///
    ///     List(folders) { folder in
    ///         Text(folder.name)
    ///             .badge(folder.numberOfItems)
    ///     }
    ///     .badgeProminence(.decreased)
    ///
    public static let decreased: BadgeProminence = { fatalError() }()

    /// The standard level of prominence for a badge.
    ///
    /// This level of prominence should be used for badges that display a value
    /// that suggests user action, such as a count of unread messages or new
    /// invitations.
    ///
    /// In lists on macOS, this results in a badge label on a grayscale platter;
    /// and in lists on iOS, this prominence of badge has no platter.
    ///
    ///     List(mailboxes) { mailbox in
    ///         Text(mailbox.name)
    ///             .badge(mailbox.numberOfUnreadMessages)
    ///     }
    ///     .badgeProminence(.standard)
    ///
    public static let standard: BadgeProminence = { fatalError() }()

    /// The highest level of prominence for a badge.
    ///
    /// This level of prominence should be used for badges that display a value
    /// that requires user action, such as number of updates or account errors.
    ///
    /// In lists on iOS and macOS, this results in badge labels being displayed
    /// on a red platter.
    ///
    ///     ForEach(accounts) { account in
    ///         Text(account.userName)
    ///             .badge(account.setupErrors)
    ///             .badgeProminence(.increased)
    ///     }
    ///
    public static let increased: BadgeProminence = { fatalError() }()

    public static func == (a: BadgeProminence, b: BadgeProminence) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// A navigation split style that reduces the size of the detail content
/// to make room when showing the leading column or columns.
///
/// Use ``NavigationSplitViewStyle/balanced`` to construct this style.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct BalancedNavigationSplitViewStyle : NavigationSplitViewStyle {

    /// Creates an instance of ``BalancedNavigationSplitViewStyle``.
    ///
    /// You can also use ``NavigationSplitViewStyle/balanced`` to construct this
    /// style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a navigation split view.
    ///
    /// SkipUI calls this method for each instance of ``NavigationSplitView``,
    /// where this style is the current ``NavigationSplitViewStyle``.
    ///
    /// - Parameter configuration: The properties of the instance to create.
    public func makeBody(configuration: BalancedNavigationSplitViewStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a navigation split view.
//    public typealias Body = some View
}

/// Modes for compositing a view with overlapping content.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum BlendMode : Sendable {

    case normal

    case multiply

    case screen

    case overlay

    case darken

    case lighten

    case colorDodge

    case colorBurn

    case softLight

    case hardLight

    case difference

    case exclusion

    case hue

    case saturation

    case color

    case luminosity

    case sourceAtop

    case destinationOver

    case destinationOut

    case plusDarker

    case plusLighter

    public static func == (a: BlendMode, b: BlendMode) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension BlendMode : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension BlendMode : Hashable {
}

/// A menu style that displays a borderless button that toggles the display of
/// the menu's contents when pressed.
///
/// Use ``MenuStyle/borderlessButton`` to construct this style.
@available(iOS, introduced: 14.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(macOS, introduced: 11.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(tvOS, introduced: 17.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
public struct BorderlessButtonMenuStyle : MenuStyle {

    /// Creates a borderless button menu style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a menu.
    ///
    /// - Parameter configuration: The properties of the menu.
    ///
    /// The system calls this method for each ``Menu`` instance in a view
    /// hierarchy where this style is the current menu style.
    public func makeBody(configuration: BorderlessButtonMenuStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a menu.
//    public typealias Body = some View
}

/// A menu style that displays a button that toggles the display of the
/// menu's contents when pressed.
///
/// Use ``MenuStyle/button`` to construct this style.
@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct ButtonMenuStyle : MenuStyle {

    /// Creates a button menu style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a menu.
    ///
    /// - Parameter configuration: The properties of the menu.
    ///
    /// The system calls this method for each ``Menu`` instance in a view
    /// hierarchy where this style is the current menu style.
    public func makeBody(configuration: ButtonMenuStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a menu.
//    public typealias Body = some View
}

/// The options for controlling the repeatability of button actions.
///
/// Use values of this type with the ``View/buttonRepeatBehavior(_:)``
/// modifier.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ButtonRepeatBehavior : Hashable, Sendable {

    /// The automatic repeat behavior.
    public static let automatic: ButtonRepeatBehavior = { fatalError() }()

    /// Repeating button actions will be enabled.
    public static let enabled: ButtonRepeatBehavior = { fatalError() }()

    /// Repeating button actions will be disabled.
    public static let disabled: ButtonRepeatBehavior = { fatalError() }()

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (a: ButtonRepeatBehavior, b: ButtonRepeatBehavior) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// A value that describes the purpose of a button.
///
/// A button role provides a description of a button's purpose.  For example,
/// the ``ButtonRole/destructive`` role indicates that a button performs
/// a destructive action, like delete user data:
///
///     Button("Delete", role: .destructive) { delete() }
///
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ButtonRole : Equatable, Sendable {

    /// A role that indicates a destructive button.
    ///
    /// Use this role for a button that deletes user data, or performs an
    /// irreversible operation. A destructive button signals by its appearance
    /// that the user should carefully consider whether to tap or click the
    /// button. For example, SkipUI presents a destructive button that you add
    /// with the ``View/swipeActions(edge:allowsFullSwipe:content:)``
    /// modifier using a red background:
    ///
    ///     List {
    ///         ForEach(items) { item in
    ///             Text(item.title)
    ///                 .swipeActions {
    ///                     Button(role: .destructive) { delete() } label: {
    ///                         Label("Delete", systemImage: "trash")
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///     .navigationTitle("Shopping List")
    ///
    /// ![A screenshot of a list of three items, where the second item is
    /// shifted to the left, and the row displays a red button with a trash
    /// icon on the right side.](ButtonRole-destructive-1)
    public static let destructive: ButtonRole = { fatalError() }()

    /// A role that indicates a button that cancels an operation.
    ///
    /// Use this role for a button that cancels the current operation.
    public static let cancel: ButtonRole = { fatalError() }()

    public static func == (a: ButtonRole, b: ButtonRole) -> Bool { fatalError() }
}

/// A toggle style that displays as a button with its label as the title.
///
/// You can also use ``ToggleStyle/button`` to construct this style.
///
///     Toggle(isOn: $isFlagged) {
///         Label("Flag", systemImage: "flag.fill")
///     }
///     .toggleStyle(.button)
///
@available(iOS 15.0, macOS 12.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public struct ButtonToggleStyle : ToggleStyle {

    /// Creates a button toggle style.
    ///
    /// Don't call this initializer directly. Instead, use the
    /// ``ToggleStyle/button`` static variable to create this style:
    ///
    ///     Toggle(isOn: $isFlagged) {
    ///         Label("Flag", systemImage: "flag.fill")
    ///     }
    ///     .toggleStyle(.button)
    ///
    public init() { fatalError() }

    /// Creates a view that represents the body of a toggle button.
    ///
    /// SkipUI implements this required method of the ``ToggleStyle``
    /// protocol to define the behavior and appearance of the
    /// ``ToggleStyle/button`` toggle style. Don't call this method
    /// directly; the system calls this method for each
    /// ``Toggle`` instance in a view hierarchy that's styled as
    /// a button.
    ///
    /// - Parameter configuration: The properties of the toggle, including a
    ///   label and a binding to the toggle's state.
    /// - Returns: A view that acts as a button that controls a Boolean state.
    public func makeBody(configuration: ButtonToggleStyle.Configuration) -> some View { return never() }


    /// A view that represents the appearance and interaction of a toggle.
    ///
    /// SkipUI infers this type automatically based on the ``View``
    /// instance that you return from your implementation of the
    /// ``makeBody(configuration:)`` method.
//    public typealias Body = some View
}

/// A matrix to use in an RGBA color transformation.
///
/// The matrix has five columns, each with a red, green, blue, and alpha
/// component. You can use the matrix for tasks like creating a color
/// transformation ``GraphicsContext/Filter`` for a ``GraphicsContext`` using
/// the ``GraphicsContext/Filter/colorMatrix(_:)`` method.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@frozen public struct ColorMatrix : Equatable {

    public var r1: Float { get { fatalError() } }

    public var r2: Float { get { fatalError() } }

    public var r3: Float { get { fatalError() } }

    public var r4: Float { get { fatalError() } }

    public var r5: Float { get { fatalError() } }

    public var g1: Float { get { fatalError() } }

    public var g2: Float { get { fatalError() } }

    public var g3: Float { get { fatalError() } }

    public var g4: Float { get { fatalError() } }

    public var g5: Float { get { fatalError() } }

    public var b1: Float { get { fatalError() } }

    public var b2: Float { get { fatalError() } }

    public var b3: Float { get { fatalError() } }

    public var b4: Float { get { fatalError() } }

    public var b5: Float { get { fatalError() } }

    public var a1: Float { get { fatalError() } }

    public var a2: Float { get { fatalError() } }

    public var a3: Float { get { fatalError() } }

    public var a4: Float { get { fatalError() } }

    public var a5: Float { get { fatalError() } }

    /// Creates the identity matrix.
    @inlinable public init() { fatalError() }

    public static func == (a: ColorMatrix, b: ColorMatrix) -> Bool { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ColorMatrix : Sendable {
}

/// The set of possible working color spaces for color-compositing operations.
///
/// Each color space guarantees the preservation of a particular range of color
/// values.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum ColorRenderingMode : Sendable {

    /// The non-linear sRGB working color space.
    ///
    /// Color component values outside the range `[0, 1]` produce undefined
    /// results. This color space is gamma corrected.
    case nonLinear

    /// The linear sRGB working color space.
    ///
    /// Color component values outside the range `[0, 1]` produce undefined
    /// results. This color space isn't gamma corrected.
    case linear

    /// The extended linear sRGB working color space.
    ///
    /// Color component values outside the range `[0, 1]` are preserved.
    /// This color space isn't gamma corrected.
    case extendedLinear

    public static func == (a: ColorRenderingMode, b: ColorRenderingMode) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorRenderingMode : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorRenderingMode : Hashable {
}

/// The possible color schemes, corresponding to the light and dark appearances.
///
/// You receive a color scheme value when you read the
/// ``EnvironmentValues/colorScheme`` environment value. The value tells you if
/// a light or dark appearance currently applies to the view. SkipUI updates
/// the value whenever the appearance changes, and redraws views that
/// depend on the value. For example, the following ``Text`` view automatically
/// updates when the user enables Dark Mode:
///
///     @Environment(\.colorScheme) private var colorScheme
///
///     var body: some View {
///         Text(colorScheme == .dark ? "Dark" : "Light")
///     }
///
/// Set a preferred appearance for a particular view hierarchy to override
/// the user's Dark Mode setting using the ``View/preferredColorScheme(_:)``
/// view modifier.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum ColorScheme : CaseIterable, Sendable {

    /// The color scheme that corresponds to a light appearance.
    case light

    /// The color scheme that corresponds to a dark appearance.
    case dark

    public static func == (a: ColorScheme, b: ColorScheme) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ColorScheme]

    /// A collection of all values of this type.
    public static var allCases: [ColorScheme] { get { fatalError() } }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorScheme : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorScheme : Hashable {
}

/// The contrast between the app's foreground and background colors.
///
/// You receive a contrast value when you read the
/// ``EnvironmentValues/colorSchemeContrast`` environment value. The value
/// tells you if a standard or increased contrast currently applies to the view.
/// SkipUI updates the value whenever the contrast changes, and redraws
/// views that depend on the value. For example, the following ``Text`` view
/// automatically updates when the user enables increased contrast:
///
///     @Environment(\.colorSchemeContrast) private var colorSchemeContrast
///
///     var body: some View {
///         Text(colorSchemeContrast == .standard ? "Standard" : "Increased")
///     }
///
/// The user sets the contrast by selecting the Increase Contrast option in
/// Accessibility > Display in System Preferences on macOS, or
/// Accessibility > Display & Text Size in the Settings app on iOS.
/// Your app can't override the user's choice.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum ColorSchemeContrast : CaseIterable, Sendable {

    /// SkipUI displays views with standard contrast between the app's
    /// foreground and background colors.
    case standard

    /// SkipUI displays views with increased contrast between the app's
    /// foreground and background colors.
    case increased

    public static func == (a: ColorSchemeContrast, b: ColorSchemeContrast) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ColorSchemeContrast]

    /// A collection of all values of this type.
    public static var allCases: [ColorSchemeContrast] { get { fatalError() } }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorSchemeContrast : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorSchemeContrast : Hashable {
}

/// A navigation view style represented by a series of views in columns.
///
/// You can also use ``NavigationViewStyle/columns`` to construct this style.
@available(iOS, introduced: 15.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView")
@available(macOS, introduced: 12.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView")
public struct ColumnNavigationViewStyle : NavigationViewStyle {
}

/// A non-scrolling form style with a trailing aligned column of labels
/// next to a leading aligned column of values.
///
/// Use the ``FormStyle/columns`` static variable to create this style:
///
///     Form {
///        ...
///     }
///     .formStyle(.columns)
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ColumnsFormStyle : FormStyle {

    /// A non-scrolling form style with a trailing aligned column of labels
    /// next to a leading aligned column of values.
    ///
    /// Don't call this initializer directly. Instead, use the
    /// ``FormStyle/columns`` static variable to create this style:
    ///
    ///     Form {
    ///        ...
    ///     }
    ///     .formStyle(.columns)
    ///
    public init() { fatalError() }

    /// Creates a view that represents the body of a form.
    ///
    /// - Parameter configuration: The properties of the form.
    /// - Returns: A view that has behavior and appearance that enables it
    ///   to function as a ``Form``.
    public func makeBody(configuration: ColumnsFormStyle.Configuration) -> some View { return never() }


    /// A view that represents the appearance and interaction of a form.
//    public typealias Body = some View
}

/// A date picker style that displays the components in a compact, textual
/// format.
///
/// You can also use ``DatePickerStyle/compact`` to construct this style.
@available(iOS 14.0, macCatalyst 13.4, macOS 10.15.4, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct CompactDatePickerStyle : DatePickerStyle {

    /// Creates an instance of the compact date picker style.
    public init() { fatalError() }

    /// Returns the appearance and interaction content for a `DatePicker`.
    ///
    /// The system calls this method for each ``DatePicker`` instance in a view
    /// hierarchy where this style is the current date picker style.
    ///
    /// - Parameter configuration : The properties of the date picker.
    @available(iOS 16.0, macOS 13.0, *)
    public func makeBody(configuration: CompactDatePickerStyle.Configuration) -> some View { return never() }


    /// A view representing the appearance and interaction of a `DatePicker`.
//    public typealias Body = some View
}

/// A control group style that presents its content as a compact menu when the user
/// presses the control, or as a submenu when nested within a larger menu.
///
/// Use ``ControlGroupStyle/compactMenu`` to construct this style.
@available(iOS 16.4, macOS 13.3, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct CompactMenuControlGroupStyle : ControlGroupStyle {

    /// Creates a compact menu control group style.
    public init() { fatalError() }

    /// Creates a view representing the body of a control group.
    ///
    /// - Parameter configuration: The properties of the control group instance
    ///   being created.
    ///
    /// This method will be called for each instance of ``ControlGroup`` created
    /// within a view hierarchy where this style is the current
    /// `ControlGroupStyle`.
    @MainActor public func makeBody(configuration: CompactMenuControlGroupStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a control group.
//    public typealias Body = some View
}

/// The placement of a container background.
///
/// This method controls where to place a background that you specify with the
/// ``View/containerBackground(_:for:)`` or
/// ``View/containerBackground(for:alignment:content:)`` modifier.
@available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
public struct ContainerBackgroundPlacement : Sendable, Hashable {

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (a: ContainerBackgroundPlacement, b: ContainerBackgroundPlacement) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// The placement of margins.
///
/// Different views can support customizating margins that appear in
/// different parts of that view. Use values of this type to customize
/// those margins of a particular placement.
///
/// For example, use a ``ContentMarginPlacement/scrollIndicators``
/// placement to customize the margins of scrollable view's scroll
/// indicators separately from the margins of a scrollable view's
/// content.
///
/// Use this type in conjunction with the ``View/contentMargin(_:for:)``
/// modifier.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ContentMarginPlacement {

    /// The automatic placement.
    ///
    /// Views that support margin customization can automatically use
    /// margins with this placement. For example, a ``ScrollView`` will
    /// use this placement to automatically inset both its content and
    /// scroll indicators by the specified amount.
    public static var automatic: ContentMarginPlacement { get { fatalError() } }

    /// The scroll content placement.
    ///
    /// Scrollable views like ``ScrollView`` will use this placement to
    /// inset their content, but not their scroll indicators.
    public static var scrollContent: ContentMarginPlacement { get { fatalError() } }

    /// The scroll indicators placement.
    ///
    /// Scrollable views like ``ScrollView`` will use this placement to
    /// inset their scroll indicators, but not their content.
    public static var scrollIndicators: ContentMarginPlacement { get { fatalError() } }
}

/// Constants that define how a view's content fills the available space.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public enum ContentMode : Hashable, CaseIterable {

    /// An option that resizes the content so it's all within the available space,
    /// both vertically and horizontally.
    ///
    /// This mode preserves the content's aspect ratio.
    /// If the content doesn't have the same aspect ratio as the available
    /// space, the content becomes the same size as the available space on
    /// one axis and leaves empty space on the other.
    case fit

    /// An option that resizes the content so it occupies all available space,
    /// both vertically and horizontally.
    ///
    /// This mode preserves the content's aspect ratio.
    /// If the content doesn't have the same aspect ratio as the available
    /// space, the content becomes the same size as the available space on
    /// one axis, and larger on the other axis.
    case fill

    public static func == (a: ContentMode, b: ContentMode) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ContentMode]

    /// A collection of all values of this type.
    public static var allCases: [ContentMode] { get { fatalError() } }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ContentMode : Sendable {
}

/// A kind for the content shape of a view.
///
/// The kind is used by the system to influence various effects, hit-testing,
/// and more.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ContentShapeKinds : OptionSet, Sendable {

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: Int { get { fatalError() } }

    /// Creates a content shape kind.
    public init(rawValue: Int) { fatalError() }

    /// The kind for hit-testing and accessibility.
    ///
    /// Setting a content shape with this kind causes the view to hit-test
    /// using the specified shape.
    public static let interaction: ContentShapeKinds = { fatalError() }()

    /// The kind for drag and drop previews.
    ///
    /// When using this kind, only the preview shape is affected. To control the
    /// shape used to hit-test and start the drag preview, use the `interaction`
    /// kind.
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static let dragPreview: ContentShapeKinds = { fatalError() }()

    /// The kind for context menu previews.
    ///
    /// When using this kind, only the preview shape will be affected. To
    /// control the shape used to hit-test and start the context menu
    /// presentation, use the `.interaction` kind.
    @available(tvOS 17.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public static let contextMenuPreview: ContentShapeKinds = { fatalError() }()

    /// The kind for hover effects.
    ///
    /// When using this kind, only the preview shape is affected. To control
    /// the shape used to hit-test and start the effect, use the `interaction`
    /// kind.
    ///
    /// This kind does not affect the `onHover` modifier.
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static let hoverEffect: ContentShapeKinds = { fatalError() }()

    /// The kind for accessibility visuals and sorting.
    ///
    /// Setting a content shape with this kind causes the accessibility frame
    /// and path of the view's underlying accessibility element to match the
    /// shape without adjusting the hit-testing shape, updating the visual focus
    /// ring that assistive apps, such as VoiceOver, draw, as well as how the
    /// element is sorted. Updating the accessibility shape is only required if
    /// the shape or size used to hit-test significantly diverges from the visual
    /// shape of the view.
    ///
    /// To control the shape for accessibility and hit-testing, use the `interaction` kind.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public static let accessibility: ContentShapeKinds = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = ContentShapeKinds

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = ContentShapeKinds

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int
}

@available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "DynamicTypeSize")
@available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "DynamicTypeSize")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "DynamicTypeSize")
@available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "DynamicTypeSize")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "DynamicTypeSize")
public enum ContentSizeCategory : Hashable, CaseIterable {

    case extraSmall

    case small

    case medium

    case large

    case extraLarge

    case extraExtraLarge

    case extraExtraExtraLarge

    case accessibilityMedium

    case accessibilityLarge

    case accessibilityExtraLarge

    case accessibilityExtraExtraLarge

    case accessibilityExtraExtraExtraLarge

    /// A Boolean value indicating whether the content size category is one that
    /// is associated with accessibility.
    @available(iOS 13.4, macOS 10.15.4, tvOS 13.4, watchOS 6.2, *)
    public var isAccessibilityCategory: Bool { get { fatalError() } }

    public static func == (a: ContentSizeCategory, b: ContentSizeCategory) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ContentSizeCategory]

    /// A collection of all values of this type.
    public static var allCases: [ContentSizeCategory] { get { fatalError() } }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ContentSizeCategory {

    /// Returns a Boolean value indicating whether the value of the first argument is less than that of the second argument.
    public static func < (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool { fatalError() }

    /// Returns a Boolean value indicating whether the value of the first argument is less than or equal to that of the second argument.
    public static func <= (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool { fatalError() }

    /// Returns a Boolean value indicating whether the value of the first argument is greater than that of the second argument.
    public static func > (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool { fatalError() }

    /// Returns a Boolean value indicating whether the value of the first argument is greater than or equal to that of the second argument.
    public static func >= (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool { fatalError() }
}

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

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ContentUnavailableView where LabelX == Label<Text, Image>, Description == Text?, Actions == EmptyView {

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

/// A container for views that you present as menu items in a context menu.
///
/// A context menu view allows you to present a situationally specific menu
/// that enables taking actions relevant to the current task.
///
/// You can create a context menu by first defining a `ContextMenu` container
/// with the controls that represent the actions that people can take,
/// and then using the ``View/contextMenu(_:)`` view modifier to apply the
/// menu to a view.
///
/// The example below creates and applies a two item context menu container
/// to a ``Text`` view. The Boolean value `shouldShowMenu`, which defaults to
/// true, controls the availability of context menu:
///
///     private let menuItems = ContextMenu {
///         Button {
///             // Add this item to a list of favorites.
///         } label: {
///             Label("Add to Favorites", systemImage: "heart")
///         }
///         Button {
///             // Open Maps and center it on this item.
///         } label: {
///             Label("Show in Maps", systemImage: "mappin")
///         }
///     }
///
///     private struct ContextMenuMenuItems: View {
///         @State private var shouldShowMenu = true
///
///         var body: some View {
///             Text("Turtle Rock")
///                 .contextMenu(shouldShowMenu ? menuItems : nil)
///         }
///     }
///
/// ![A screenshot of a context menu showing two menu items: Add to
/// Favorites, and Show in Maps.](View-contextMenu-1-iOS)
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use `contextMenu(menuItems:)` instead.")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use `contextMenu(menuItems:)` instead.")
@available(tvOS, unavailable)
@available(watchOS, introduced: 6.0, deprecated: 7.0)
public struct ContextMenu<MenuItems> where MenuItems : View {

    public init(@ViewBuilder menuItems: () -> MenuItems) { fatalError() }
}

/// A container view that displays semantically-related controls
/// in a visually-appropriate manner for the context
///
/// You can provide an optional label to this view that describes its children.
/// This view may be used in different ways depending on the surrounding
/// context. For example, when you place the control group in a
/// toolbar item, SkipUI uses the label when the group is moved to the
/// toolbar's overflow menu.
///
///     ContentView()
///         .toolbar(id: "items") {
///             ToolbarItem(id: "media") {
///                 ControlGroup {
///                     MediaButton()
///                     ChartButton()
///                     GraphButton()
///                 } label: {
///                     Label("Plus", systemImage: "plus")
///                 }
///             }
///         }
///
@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct ControlGroup<Content> : View where Content : View {

    /// Creates a new ControlGroup with the specified children
    ///
    /// - Parameters:
    ///   - content: the children to display
    public init(@ViewBuilder content: () -> Content) { fatalError() }

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

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension ControlGroup where Content == ControlGroupStyleConfiguration.Content {

    /// Creates a control group based on a style configuration.
    ///
    /// Use this initializer within the
    /// ``ControlGroupStyle/makeBody(configuration:)`` method of a
    /// ``ControlGroupStyle`` instance to create an instance of the control group
    /// being styled. This is useful for custom control group styles that modify
    /// the current control group style.
    ///
    /// For example, the following code creates a new, custom style that places a
    /// red border around the current control group:
    ///
    ///     struct RedBorderControlGroupStyle: ControlGroupStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             ControlGroup(configuration)
    ///                 .border(Color.red)
    ///         }
    ///     }
    ///
    public init(_ configuration: ControlGroupStyleConfiguration) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension ControlGroup {

    /// Creates a new control group with the specified content and a label.
    ///
    /// - Parameters:
    ///   - content: The content to display.
    ///   - label: A view that describes the purpose of the group.
    public init<C, L>(@ViewBuilder content: () -> C, @ViewBuilder label: () -> L) where Content == LabeledControlGroupContent<C, L>, C : View, L : View { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension ControlGroup {

    /// Creates a new control group with the specified content that generates
    /// its label from a localized string key.
    ///
    /// - Parameters:
    /// - titleKey: The key for the group's localized title, that describes
    /// the contents of the group.
    /// - label: A view that describes the purpose of the group.
    public init<C>(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> C) where Content == LabeledControlGroupContent<C, Text>, C : View { fatalError() }

    /// Creates a new control group with the specified content that generates
    /// its label from a string.
    ///
    /// - Parameters:
    /// - title: A string that describes the contents of the group.
    /// - label: A view that describes the purpose of the group.
    public init<C, S>(_ title: S, @ViewBuilder content: () -> C) where Content == LabeledControlGroupContent<C, Text>, C : View, S : StringProtocol { fatalError() }
}

/// Defines the implementation of all control groups within a view
/// hierarchy.
///
/// To configure the current `ControlGroupStyle` for a view hierarchy, use the
/// ``View/controlGroupStyle(_:)`` modifier.
@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public protocol ControlGroupStyle {

    /// A view representing the body of a control group.
    associatedtype Body : View

    /// Creates a view representing the body of a control group.
    ///
    /// - Parameter configuration: The properties of the control group instance
    ///   being created.
    ///
    /// This method will be called for each instance of ``ControlGroup`` created
    /// within a view hierarchy where this style is the current
    /// `ControlGroupStyle`.
    @ViewBuilder @MainActor func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a `ControlGroup` instance being created.
    typealias Configuration = ControlGroupStyleConfiguration
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ControlGroupStyle where Self == NavigationControlGroupStyle {

    /// The navigation control group style.
    ///
    /// Use this style to group controls related to navigation, such as
    /// back/forward buttons or timeline navigation controls.
    ///
    /// The navigation control group style can vary by platform. On iOS, it
    /// renders as individual borderless buttons, while on macOS, it displays as
    /// a separated momentary segmented control.
    ///
    /// To apply this style to a control group or to a view that contains a
    /// control group, use the ``View/controlGroupStyle(_:)`` modifier.
    public static var navigation: NavigationControlGroupStyle { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ControlGroupStyle where Self == PaletteControlGroupStyle {

    /// A control group style that presents its content as a palette.
    ///
    /// - Note: When used outside of menus, this style is rendered as a
    /// segmented control.
    ///
    /// Use this style to render a multi-select or a stateless palette.
    /// The following example creates a control group that contains both type of shelves:
    ///
    ///     Menu {
    ///         // A multi select palette
    ///         ControlGroup {
    ///             ForEach(ColorTags.allCases) { colorTag in
    ///                 Toggle(isOn: $selectedColorTags[colorTag]) {
    ///                     Label(colorTag.name, systemImage: "circle")
    ///                 }
    ///                 .tint(colorTag.color)
    ///             }
    ///         }
    ///         .controlGroupStyle(.palette)
    ///         .paletteSelectionEffect(.symbolVariant(.fill))
    ///
    ///         // A momentary / stateless palette
    ///         ControlGroup {
    ///             ForEach(Emotes.allCases) { emote in
    ///                 Button {
    ///                     sendEmote(emote)
    ///                 } label: {
    ///                     Label(emote.name, systemImage: emote.systemImage)
    ///                 }
    ///             }
    ///         }
    ///         .controlGroupStyle(.palette)
    ///     }
    ///
    /// To apply this style to a control group, or to a view that contains
    /// control groups, use the ``View/controlGroupStyle(_:)`` modifier.
    public static var palette: PaletteControlGroupStyle { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension ControlGroupStyle where Self == AutomaticControlGroupStyle {

    /// The default control group style.
    ///
    /// The default control group style can vary by platform. By default, both
    /// platforms use a momentary segmented control style that's appropriate for
    /// the environment in which it is rendered.
    ///
    /// You can override a control group's style. To apply the default style to
    /// a control group or to a view that contains a control group, use
    /// the ``View/controlGroupStyle(_:)`` modifier.
    public static var automatic: AutomaticControlGroupStyle { get { fatalError() } }
}

@available(iOS 16.4, macOS 13.3, tvOS 17.0, *)
@available(watchOS, unavailable)
extension ControlGroupStyle where Self == MenuControlGroupStyle {

    /// A control group style that presents its content as a menu when the user
    /// presses the control, or as a submenu when nested within a larger menu.
    ///
    /// To apply this style to a control group, or to a view that contains
    /// control groups, use the ``View/controlGroupStyle(_:)`` modifier.
    public static var menu: MenuControlGroupStyle { get { fatalError() } }
}

@available(iOS 16.4, macOS 13.3, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ControlGroupStyle where Self == CompactMenuControlGroupStyle {

    /// A control group style that presents its content as a compact menu when the user
    /// presses the control, or as a submenu when nested within a larger menu.
    ///
    /// To apply this style to a control group, or to a view that contains
    /// control groups, use the ``View/controlGroupStyle(_:)`` modifier.
    public static var compactMenu: CompactMenuControlGroupStyle { get { fatalError() } }
}

/// The properties of a control group.
@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct ControlGroupStyleConfiguration {

    /// A type-erased content of a `ControlGroup`.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A view that represents the content of the `ControlGroup`.
    public let content: ControlGroupStyleConfiguration.Content = { fatalError() }()

    /// A type-erased label of a ``ControlGroup``.
    @available(iOS 16.0, macOS 13.0, *)
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A view that provides the optional label of the ``ControlGroup``.
    @available(iOS 16.0, macOS 13.0, *)
    public let label: ControlGroupStyleConfiguration.Label = { fatalError() }()
}

/// The size classes, like regular or small, that you can apply to controls
/// within a view.
@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
public enum ControlSize : CaseIterable, Sendable {

    /// A control version that is minimally sized.
    case mini

    /// A control version that is proportionally smaller size for space-constrained views.
    case small

    /// A control version that is the default size.
    case regular

    /// A control version that is prominently sized.
    @available(macOS 11.0, *)
    case large

    @available(iOS 17.0, macOS 14.0, watchOS 10.0, xrOS 1.0, *)
    case extraLarge

    /// A collection of all values of this type.
    public static var allCases: [ControlSize] { get { fatalError() } }

    public static func == (a: ControlSize, b: ControlSize) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ControlSize]

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ControlSize : Equatable {
}

@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ControlSize : Hashable {
}

/// A resolved coordinate space created by `CoordinateSpaceProtocol`.
///
/// You don't typically use `CoordinateSpace` directly. Instead, use the static
/// properties and functions of `CoordinateSpaceProtocol` such as `.global`,
/// `.local`, and `.named(_:)`.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum CoordinateSpace {

    /// The global coordinate space at the root of the view hierarchy.
    case global

    /// The local coordinate space of the current view.
    case local

    /// A named reference to a view's local coordinate space.
    case named(AnyHashable)
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CoordinateSpace {

    public var isGlobal: Bool { get { fatalError() } }

    public var isLocal: Bool { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CoordinateSpace : Equatable, Hashable {

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (lhs: CoordinateSpace, rhs: CoordinateSpace) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// A frame of reference within the layout system.
///
/// All geometric properties of a view, including size, position, and
/// transform, are defined within the local coordinate space of the view's
/// parent. These values can be converted into other coordinate spaces
/// by passing types conforming to this protocol into functions such as
/// `GeometryProxy.frame(in:)`.
///
/// For example, a named coordinate space allows you to convert the frame
/// of a view into the local coordinate space of an ancestor view by defining
/// a named coordinate space using the `coordinateSpace(_:)` modifier, then
/// passing that same named coordinate space into the `frame(in:)` function.
///
///     VStack {
///         GeometryReader { geometryProxy in
///             let distanceFromTop = geometryProxy.frame(in: "container").origin.y
///             Text("This view is \(distanceFromTop) points from the top of the VStack")
///         }
///         .padding()
///     }
///     .coordinateSpace(.named("container"))
///
/// You don't typically create types conforming to this protocol yourself.
/// Instead, use the system-provided `.global`, `.local`, and `.named(_:)`
/// implementations.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol CoordinateSpaceProtocol {

    /// The resolved coordinate space.
    var coordinateSpace: CoordinateSpace { get }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == NamedCoordinateSpace {

    /// The named coordinate space that is added by the system for the innermost
    /// containing scroll view that allows scrolling along the provided axis.
    public static func scrollView(axis: Axis) -> Self { fatalError() }

    /// The named coordinate space that is added by the system for the innermost
    /// containing scroll view.
    public static var scrollView: NamedCoordinateSpace { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == NamedCoordinateSpace {

    /// Creates a named coordinate space using the given value.
    ///
    /// Use the `coordinateSpace(_:)` modifier to assign a name to the local
    /// coordinate space of a  parent view. Child views can then refer to that
    /// coordinate space using `.named(_:)`.
    ///
    /// - Parameter name: A unique value that identifies the coordinate space.
    ///
    /// - Returns: A named coordinate space identified by the given value.
    public static func named(_ name: some Hashable) -> NamedCoordinateSpace { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == LocalCoordinateSpace {

    /// The local coordinate space of the current view.
    public static var local: LocalCoordinateSpace { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == GlobalCoordinateSpace {

    /// The global coordinate space at the root of the view hierarchy.
    public static var global: GlobalCoordinateSpace { get { fatalError() } }
}

/// The definition of a custom detent with a calculated height.
///
/// You can create and use a custom detent with built-in detents.
///
///     extension PresentationDetent {
///         static let bar = Self.custom(BarDetent.self)
///         static let small = Self.height(100)
///         static let extraLarge = Self.fraction(0.75)
///     }
///
///     private struct BarDetent: CustomPresentationDetent {
///         static func height(in context: Context) -> CGFloat? {
///             max(44, context.maxDetentValue * 0.1)
///         }
///     }
///
///     struct ContentView: View {
///         @State private var showSettings = false
///         @State private var selectedDetent = PresentationDetent.bar
///
///         var body: some View {
///             Button("View Settings") {
///                 showSettings = true
///             }
///             .sheet(isPresented: $showSettings) {
///                 SettingsView(selectedDetent: $selectedDetent)
///                     .presentationDetents(
///                         [.bar, .small, .medium, .large, .extraLarge],
///                         selection: $selectedDetent)
///             }
///         }
///     }
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public protocol CustomPresentationDetent {

    /// Calculates and returns a height based on the context.
    ///
    /// - Parameter context: Information that can help to determine the
    ///   height of the detent.
    ///
    /// - Returns: The height of the detent, or `nil` if the detent should be
    ///   inactive based on the `contenxt` input.
    static func height(in context: Self.Context) -> CGFloat?
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension CustomPresentationDetent {

    /// Information that you can use to calculate the height of a custom detent.
    public typealias Context = PresentationDetent.Context
}

/// Conforming types represent items that can be placed in various locations
/// in a customizable toolbar.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol CustomizableToolbarContent : ToolbarContent where Self.Body : CustomizableToolbarContent {
}

extension CustomizableToolbarContent {

    /// Configures the way customizable toolbar items with the default
    /// behavior behave.
    ///
    /// Default customizable items support a variety of edits by the user.
    /// * A user can add an an item that is not in the toolbar.
    /// * A user can remove an item that is in the toolbar.
    /// * A user can move an item within the toolbar.
    ///
    /// By default, all default customizable items will be initially
    /// present in the toolbar. Provide a value of
    /// ``Visibility/hidden`` to this modifier to specify that items should
    /// initially be hidden from the user, and require them to add those items
    /// to the toolbar if desired.
    ///
    ///     ContentView()
    ///         .toolbar(id: "main") {
    ///             ToolbarItem(id: "new") {
    ///                 // new button here
    ///             }
    ///             .defaultCustomization(.hidden)
    ///         }
    ///
    /// You can ensure that the user can always use an item with default
    /// customizability, even if it's removed from the customizable toolbar. To
    /// do this, provide the ``ToolbarCustomizationOptions/alwaysAvailable``
    /// option. Unlike a customizable item with a customization behavior of
    /// ``ToolbarCustomizationBehavior/none`` which always remain in the toolbar
    /// itself, these items will remain in the overflow if the user removes them
    /// from the toolbar.
    ///
    /// Provide a value of ``ToolbarCustomizationOptions/alwaysAvailable`` to
    /// the options parameter of this modifier to receive this behavior.
    ///
    ///     ContentView()
    ///         .toolbar(id: "main") {
    ///             ToolbarItem(id: "new") {
    ///                 // new button here
    ///             }
    ///             .defaultCustomization(options: .alwaysAvailable)
    ///         }
    ///
    /// - Parameters:
    ///   - defaultVisibility: The default visibility of toolbar content
    ///     with the default customization behavior.
    ///   - options: The customization options to configure the behavior
    ///     of toolbar content with the default customization behavior.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func defaultCustomization(_ defaultVisibility: Visibility = .automatic, options: ToolbarCustomizationOptions = []) -> some CustomizableToolbarContent { return never() }


    /// Configures customizable toolbar content with the default visibility
    /// and options.
    ///
    /// Use the ``CustomizableToolbarContent/defaultCustomization(_:options:)``
    /// modifier providing either a `defaultVisibility` or `options` instead.
    @available(iOS, introduced: 16.0, deprecated: 16.0, message: "Please provide either a visibility or customization options")
    @available(macOS, introduced: 13.0, deprecated: 13.0, message: "Please provide either a visibility or customization options")
    @available(tvOS, introduced: 16.0, deprecated: 16.0, message: "Please provide either a visibility or customization options")
    @available(watchOS, introduced: 9.0, deprecated: 9.0, message: "Please provide either a visibility or customization options")
    public func defaultCustomization() -> some CustomizableToolbarContent { return never() }

}

extension CustomizableToolbarContent {

    /// Configures the customization behavior of customizable toolbar content.
    ///
    /// Customizable toolbar items support different kinds of customization:
    /// * A user can add an an item that is not in the toolbar.
    /// * A user can remove an item that is in the toolbar.
    /// * A user can move an item within the toolbar.
    ///
    /// Based on the customization behavior of the toolbar items, different
    /// edits will be supported.
    ///
    /// Use this modifier to the customization behavior a user can
    /// perform on your toolbar items. In the following example, the
    /// customizable toolbar item supports all of the different kinds of
    /// toolbar customizations and starts in the toolbar.
    ///
    ///     ContentView()
    ///         .toolbar(id: "main") {
    ///             ToolbarItem(id: "new") {
    ///                 // new button here
    ///             }
    ///         }
    ///
    /// You can create an item that can not be removed from the toolbar
    /// or moved within the toolbar  by passing a value of
    /// ``ToolbarCustomizationBehavior/disabled`` to this modifier.
    ///
    ///     ContentView()
    ///         .toolbar(id: "main") {
    ///             ToolbarItem(id: "new") {
    ///                 // new button here
    ///             }
    ///             .customizationBehavior(.disabled)
    ///         }
    ///
    /// You can create an item that can not be removed from the toolbar, but
    /// can be moved by passing a value of
    /// ``ToolbarCustomizationBehavior/reorderable``.
    ///
    ///     ContentView()
    ///         .toolbar(id: "main") {
    ///             ToolbarItem(id: "new") {
    ///                 // new button here
    ///             }
    ///             .customizationBehavior(.reorderable)
    ///         }
    ///
    /// - Parameter behavior: The customization behavior of the customizable
    ///   toolbar content.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func customizationBehavior(_ behavior: ToolbarCustomizationBehavior) -> some CustomizableToolbarContent { return never() }

}


/// Prioritizations for default focus preferences when evaluating where
/// to move focus in different circumstances.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct DefaultFocusEvaluationPriority : Sendable {

    /// Use the default focus preference when focus moves into the affected
    /// branch automatically, but ignore it when the movement is driven by a
    /// user-initiated navigation command.
    public static let automatic: DefaultFocusEvaluationPriority = { fatalError() }()

    /// Always use the default focus preference when focus moves into the
    /// affected branch.
    public static let userInitiated: DefaultFocusEvaluationPriority = { fatalError() }()
}

/// The default gauge view style in the current context of the view being
/// styled.
///
/// You can also use ``GaugeStyle/automatic`` to construct this style.
@available(iOS 16.0, macOS 13.0, watchOS 7.0, *)
@available(tvOS, unavailable)
public struct DefaultGaugeStyle : GaugeStyle {

    /// Creates a default gauge style.
    public init() { fatalError() }

    /// Creates a view representing the body of a gauge.
    ///
    /// The system calls this modifier on each instance of gauge within a view
    /// hierarchy where this style is the current gauge style.
    ///
    /// - Parameter configuration: The properties to apply to the gauge instance.
    public func makeBody(configuration: DefaultGaugeStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a gauge.
//    public typealias Body = some View
}

/// The default style for group box views.
///
/// You can also use ``GroupBoxStyle/automatic`` to construct this style.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DefaultGroupBoxStyle : GroupBoxStyle {

    public init() { fatalError() }

    /// Creates a view representing the body of a group box.
    ///
    /// SkipUI calls this method for each instance of ``SkipUI/GroupBox``
    /// created within a view hierarchy where this style is the current
    /// group box style.
    ///
    /// - Parameter configuration: The properties of the group box instance being
    ///   created.
    public func makeBody(configuration: DefaultGroupBoxStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a group box.
//    public typealias Body = some View
}

/// The default label style in the current context.
///
/// You can also use ``LabelStyle/automatic`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct DefaultLabelStyle : LabelStyle {

    /// Creates an automatic label style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a label.
    ///
    /// The system calls this method for each ``Label`` instance in a view
    /// hierarchy where this style is the current label style.
    ///
    /// - Parameter configuration: The properties of the label.
    public func makeBody(configuration: DefaultLabelStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a label.
//    public typealias Body = some View
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

/// The default menu style, based on the menu's context.
///
/// You can also use ``MenuStyle/automatic`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct DefaultMenuStyle : MenuStyle {

    /// Creates a default menu style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a menu.
    ///
    /// - Parameter configuration: The properties of the menu.
    ///
    /// The system calls this method for each ``Menu`` instance in a view
    /// hierarchy where this style is the current menu style.
    public func makeBody(configuration: DefaultMenuStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a menu.
//    public typealias Body = some View
}

/// The default navigation view style.
///
/// You can also use ``NavigationViewStyle/automatic`` to construct this style.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView instead")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
public struct DefaultNavigationViewStyle : NavigationViewStyle {

    public init() { fatalError() }
}

/// The default picker style, based on the picker's context.
///
/// You can also use ``PickerStyle/automatic`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct DefaultPickerStyle : PickerStyle {

    /// Creates a default picker style.
    public init() { fatalError() }
}

/// The default label used for a share link.
///
/// You don't use this type directly. Instead, ``ShareLink`` uses it
/// automatically depending on how you create a share link.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public struct DefaultShareLinkLabel : View {

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

/// The default `TabView` style.
///
/// You can also use ``TabViewStyle/automatic`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct DefaultTabViewStyle : TabViewStyle {

    public init() { fatalError() }
}

/// The default text field style, based on the text field's context.
///
/// You can also use ``TextFieldStyle/automatic`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct DefaultTextFieldStyle : TextFieldStyle {

    public init() { fatalError() }
}

/// The default toggle style.
///
/// Use the ``ToggleStyle/automatic`` static variable to create this style:
///
///     Toggle("Enhance Sound", isOn: $isEnhanced)
///         .toggleStyle(.automatic)
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct DefaultToggleStyle : ToggleStyle {

    /// Creates a default toggle style.
    ///
    /// Don't call this initializer directly. Instead, use the
    /// ``ToggleStyle/automatic`` static variable to create this style:
    ///
    ///     Toggle("Enhance Sound", isOn: $isEnhanced)
    ///         .toggleStyle(.automatic)
    ///
    public init() { fatalError() }

    /// Creates a view that represents the body of a toggle.
    ///
    /// SkipUI implements this required method of the ``ToggleStyle``
    /// protocol to define the behavior and appearance of the
    /// ``ToggleStyle/automatic`` toggle style. Don't call this method
    /// directly. Rather, the system calls this method for each
    /// ``Toggle`` instance in a view hierarchy that needs the default
    /// style.
    ///
    /// - Parameter configuration: The properties of the toggle, including a
    ///   label and a binding to the toggle's state.
    /// - Returns: A view that acts as a toggle.
    public func makeBody(configuration: DefaultToggleStyle.Configuration) -> some View { return never() }


    /// A view that represents the appearance and interaction of a toggle.
    ///
    /// SkipUI infers this type automatically based on the ``View``
    /// instance that you return from your implementation of the
    /// ``makeBody(configuration:)`` method.
//    public typealias Body = some View
}

/// A selectability type that disables text selection by the person using your app.
///
/// Don't use this type directly. Instead, use ``TextSelectability/disabled``.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DisabledTextSelectability : TextSelectability {

    /// A Boolean value that indicates whether the selectability type allows
    /// selection.
    ///
    /// Conforming types, such as ``EnabledTextSelectability`` and
    /// ``DisabledTextSelectability``, return `true` or `false` for this
    /// property as appropriate. SkipUI expects this value for a given
    /// selectability type to be constant, unaffected by global state.
    public static let allowsSelection: Bool = { fatalError() }()
}

/// A view that shows or hides another content view, based on the state of a
/// disclosure control.
///
/// A disclosure group view consists of a label to identify the contents, and a
/// control to show and hide the contents. Showing the contents puts the
/// disclosure group into the "expanded" state, and hiding them makes the
/// disclosure group "collapsed".
///
/// In the following example, a disclosure group contains two toggles and
/// an embedded disclosure group. The top level disclosure group exposes its
/// expanded state with the bound property, `topLevelExpanded`. By expanding
/// the disclosure group, the user can use the toggles to update the state of
/// the `toggleStates` structure.
///
///     struct ToggleStates {
///         var oneIsOn: Bool = false
///         var twoIsOn: Bool = true
///     }
///     @State private var toggleStates = ToggleStates()
///     @State private var topExpanded: Bool = true
///
///     var body: some View {
///         DisclosureGroup("Items", isExpanded: $topExpanded) {
///             Toggle("Toggle 1", isOn: $toggleStates.oneIsOn)
///             Toggle("Toggle 2", isOn: $toggleStates.twoIsOn)
///             DisclosureGroup("Sub-items") {
///                 Text("Sub-item 1")
///             }
///         }
///     }
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DisclosureGroup<Label, Content> : View where Label : View, Content : View {

    /// Creates a disclosure group with the given label and content views.
    ///
    /// - Parameters:
    ///   - content: The content shown when the disclosure group expands.
    ///   - label: A view that describes the content of the disclosure group.
    public init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates a disclosure group with the given label and content views, and
    /// a binding to the expansion state (expanded or collapsed).
    ///
    /// - Parameters:
    ///   - isExpanded: A binding to a Boolean value that determines the group's
    ///    expansion state (expanded or collapsed).
    ///   - content: The content shown when the disclosure group expands.
    ///   - label: A view that describes the content of the disclosure group.
    public init(isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> Label) { fatalError() }

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

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DisclosureGroup where Label == Text {

    /// Creates a disclosure group, using a provided localized string key to
    /// create a text view for the label.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized label of `self` that describes
    ///     the content of the disclosure group.
    ///   - content: The content shown when the disclosure group expands.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) { fatalError() }

    /// Creates a disclosure group, using a provided localized string key to
    /// create a text view for the label, and a binding to the expansion state
    /// (expanded or collapsed).
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized label of `self` that describes
    ///     the content of the disclosure group.
    ///   - isExpanded: A binding to a Boolean value that determines the group's
    ///    expansion state (expanded or collapsed).
    ///   - content: The content shown when the disclosure group expands.
    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) { fatalError() }

    /// Creates a disclosure group, using a provided string to create a
    /// text view for the label.
    ///
    /// - Parameters:
    ///   - label: A description of the content of the disclosure group.
    ///   - content: The content shown when the disclosure group expands.
    public init<S>(_ label: S, @ViewBuilder content: @escaping () -> Content) where S : StringProtocol { fatalError() }

    /// Creates a disclosure group, using a provided string to create a
    /// text view for the label, and a binding to the expansion state (expanded
    /// or collapsed).
    ///
    /// - Parameters:
    ///   - label: A description of the content of the disclosure group.
    ///   - isExpanded: A binding to a Boolean value that determines the group's
    ///    expansion state (expanded or collapsed).
    ///   - content: The content shown when the disclosure group expands.
    public init<S>(_ label: S, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) where S : StringProtocol { fatalError() }
}

/// A type that specifies the appearance and interaction of disclosure groups
/// within a view hierarchy.
///
/// To configure the disclosure group style for a view hierarchy, use the
/// ``View/disclosureGroupStyle(_:)`` modifier.
///
/// To create a custom disclosure group style, declare a type that conforms
/// to `DisclosureGroupStyle`. Implement the
/// ``DisclosureGroupStyle/makeBody(configuration:)`` method to return a view
/// that composes the elements of the `configuration` that SkipUI provides to
/// your method.
///
///     struct MyDisclosureStyle: DisclosureGroupStyle {
///         func makeBody(configuration: Configuration) -> some View {
///             VStack {
///                 Button {
///                     withAnimation {
///                         configuration.isExpanded.toggle()
///                     }
///                 } label: {
///                     HStack(alignment: .firstTextBaseline) {
///                         configuration.label
///                         Spacer()
///                         Text(configuration.isExpanded ? "hide" : "show")
///                             .foregroundColor(.accentColor)
///                             .font(.caption.lowercaseSmallCaps())
///                             .animation(nil, value: configuration.isExpanded)
///                     }
///                     .contentShape(Rectangle())
///                 }
///                 .buttonStyle(.plain)
///                 if configuration.isExpanded {
///                     configuration.content
///                 }
///             }
///         }
///     }
///
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol DisclosureGroupStyle {

    /// A view that represents the body of a disclosure group.
    associatedtype Body : View

    /// Creates a view that represents the body of a disclosure group.
    ///
    /// SkipUI calls this method for each instance of ``DisclosureGroup``
    /// that you create within a view hierarchy where this style is the current
    /// ``DisclosureGroupStyle``.
    ///
    /// - Parameter configuration: The properties of the instance being created.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a disclosure group instance.
    typealias Configuration = DisclosureGroupStyleConfiguration
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DisclosureGroupStyle where Self == AutomaticDisclosureGroupStyle {

    /// A disclosure group style that resolves its appearance automatically
    /// based on the current context.
    public static var automatic: AutomaticDisclosureGroupStyle { get { fatalError() } }
}

/// The properties of a disclosure group instance.
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DisclosureGroupStyleConfiguration {

    /// A type-erased label of a disclosure group.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// The label for the disclosure group.
    public let label: DisclosureGroupStyleConfiguration.Label = { fatalError() }()

    /// A type-erased content of a disclosure group.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// The content of the disclosure group.
    public let content: DisclosureGroupStyleConfiguration.Content = { fatalError() }()

    /// A binding to a Boolean that indicates whether the disclosure
    /// group is expanded.
//    @Binding public var isExpanded: Bool { get { fatalError() } nonmutating set { fatalError() } }

//    public var $isExpanded: Binding<Bool> { get { fatalError() } }
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

/// Programmatic window dismissal behaviors.
///
/// Use values of this type to control window dismissal during the
/// current transaction.
///
/// For example, to dismiss windows showing a modal presentation
/// that would otherwise prohibit dismissal, use the ``destructive``
/// behavior:
///
///     struct DismissWindowButton: View {
///         @Environment(\.dismissWindow) private var dismissWindow
///
///         var body: some View {
///             Button("Close Auxiliary Window") {
///                 withTransaction(\.dismissBehavior, .destructive) {
///                     dismissWindow(id: "auxiliary")
///                 }
///             }
///         }
///     }
///
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DismissBehavior : Sendable {

    /// The interactive dismiss behavior.
    ///
    /// Use this behavior when you want to dismiss a window in a manner that is
    /// similar to the standard system affordances for window dismissal - for
    /// example, when a user clicks the close button.
    ///
    /// This is the default behavior on macOS and iOS.
    ///
    /// On macOS, dismissing a window using this behavior will not dismiss a
    /// window which is currently showing a modal presentation, such as a sheet
    /// or alert. Additionally, a document window that is dismissed with this
    /// behavior will show the save dialog if there are unsaved changes to the
    /// document.
    ///
    /// On iOS, dismissing a window using this behavior will dismiss it
    /// regardless of any modal presentations being shown.
    public static let interactive: DismissBehavior = { fatalError() }()

    /// The destructive dismiss behavior.
    ///
    /// Use this behavior when you want to dismiss a window regardless of
    /// any conditions that would normally prevent the dismissal. Dismissing
    /// windows in this matter may result in loss of state.
    ///
    /// On macOS, this behavior will cause windows to dismiss even when they are
    /// currently showing a modal presentation, such as a sheet or alert.
    /// Additionally, a document window will not show the save dialog when
    /// there are unsaved changes and the window is dismissed with this
    /// behavior.
    ///
    /// On iOS, this behavior behaves the same as `interactive`.
    public static let destructive: DismissBehavior = { fatalError() }()
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

/// A visual element that can be used to separate other content.
///
/// When contained in a stack, the divider extends across the minor axis of the
/// stack, or horizontally when not in a stack.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Divider : View {

    public init() { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never

    public var body: Body { fatalError() }
}

/// A navigation view style represented by a primary view stack that
/// navigates to a detail view.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView instead")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
public struct DoubleColumnNavigationViewStyle : NavigationViewStyle {

    public init() { fatalError() }
}

/// An interface for a stored variable that updates an external property of a
/// view.
///
/// The view gives values to these properties prior to recomputing the view's
/// ``View/body-swift.property``.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol DynamicProperty {

    /// Updates the underlying value of the stored value.
    ///
    /// SkipUI calls this function before rendering a view's
    /// ``View/body-swift.property`` to ensure the view has the most recent
    /// value.
    mutating func update()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension DynamicProperty {

    /// Updates the underlying value of the stored value.
    ///
    /// SkipUI calls this function before rendering a view's
    /// ``View/body-swift.property`` to ensure the view has the most recent
    /// value.
    public mutating func update() { fatalError() }
}

/// A Dynamic Type size, which specifies how large scalable content should be.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum DynamicTypeSize : Hashable, Comparable, CaseIterable, Sendable {

    /// An extra small size.
    case xSmall

    /// A small size.
    case small

    /// A medium size.
    case medium

    /// A large size.
    case large

    /// An extra large size.
    case xLarge

    /// An extra extra large size.
    case xxLarge

    /// An extra extra extra large size.
    case xxxLarge

    /// The first accessibility size.
    case accessibility1

    /// The second accessibility size.
    case accessibility2

    /// The third accessibility size.
    case accessibility3

    /// The fourth accessibility size.
    case accessibility4

    /// The fifth accessibility size.
    case accessibility5

    /// A Boolean value indicating whether the size is one that is associated
    /// with accessibility.
    public var isAccessibilitySize: Bool { get { fatalError() } }

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (a: DynamicTypeSize, b: DynamicTypeSize) -> Bool { fatalError() }

    public static func == (a: DynamicTypeSize, b: DynamicTypeSize) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [DynamicTypeSize]

    /// A collection of all values of this type.
    public static var allCases: [DynamicTypeSize] { get { fatalError() } }

    public var hashValue: Int { get { fatalError() } }
}

/// A type of view that generates views from an underlying collection of data.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol DynamicViewContent : View {

    /// The type of the underlying collection of data.
    associatedtype Data : Collection

    /// The collection of underlying data.
    var data: Self.Data { get }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension DynamicViewContent {

    /// Sets the deletion action for the dynamic view.
    ///
    /// - Parameter action: The action that you want SkipUI to perform when
    ///   elements in the view are deleted. SkipUI passes a set of indices to the
    ///   closure that's relative to the dynamic view's underlying collection of
    ///   data.
    ///
    /// - Returns: A view that calls `action` when elements are deleted from the
    ///   original view.
    @inlinable public func onDelete(perform action: ((IndexSet) -> Void)?) -> some DynamicViewContent { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension DynamicViewContent {

    /// Sets the move action for the dynamic view.
    ///
    /// - Parameters:
    ///   - action: A closure that SkipUI invokes when elements in the dynamic
    ///     view are moved. The closure takes two arguments that represent the
    ///     offset relative to the dynamic view's underlying collection of data.
    ///     Pass `nil` to disable the ability to move items.
    ///
    /// - Returns: A view that calls `action` when elements are moved within the
    ///   original view.
    @inlinable public func onMove(perform action: ((IndexSet, Int) -> Void)?) -> some DynamicViewContent { return never() }

}

/// An enumeration to indicate one edge of a rectangle.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public enum Edge : Int8, CaseIterable {

    case top

    case leading

    case bottom

    case trailing

    /// An efficient set of `Edge`s.
    @frozen public struct Set : OptionSet {

        /// The element type of the option set.
        ///
        /// To inherit all the default implementations from the `OptionSet` protocol,
        /// the `Element` type must be `Self`, the default.
        public typealias Element = Edge.Set

        /// The corresponding value of the raw type.
        ///
        /// A new instance initialized with `rawValue` will be equivalent to this
        /// instance. For example:
        ///
        ///     enum PaperSize: String {
        ///         case A4, A5, Letter, Legal
        ///     }
        ///
        ///     let selectedSize = PaperSize.Letter
        ///     print(selectedSize.rawValue)
        ///     // Prints "Letter"
        ///
        ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
        ///     // Prints "true"
        public let rawValue: Int8

        /// Creates a new option set from the given raw value.
        ///
        /// This initializer always succeeds, even if the value passed as `rawValue`
        /// exceeds the static properties declared as part of the option set. This
        /// example creates an instance of `ShippingOptions` with a raw value beyond
        /// the highest element, with a bit mask that effectively contains all the
        /// declared static members.
        ///
        ///     let extraOptions = ShippingOptions(rawValue: 255)
        ///     print(extraOptions.isStrictSuperset(of: .all))
        ///     // Prints "true"
        ///
        /// - Parameter rawValue: The raw value of the option set to create. Each bit
        ///   of `rawValue` potentially represents an element of the option set,
        ///   though raw values may include bits that are not defined as distinct
        ///   values of the `OptionSet` type.
        public init(rawValue: Int8) { fatalError() }

        public static let top: Edge.Set = { fatalError() }()

        public static let leading: Edge.Set = { fatalError() }()

        public static let bottom: Edge.Set = { fatalError() }()

        public static let trailing: Edge.Set = { fatalError() }()

        public static let all: Edge.Set = { fatalError() }()

        public static let horizontal: Edge.Set = { fatalError() }()

        public static let vertical: Edge.Set = { fatalError() }()

        /// Creates an instance containing just `e`
        public init(_ e: Edge) { fatalError() }

        /// The type of the elements of an array literal.
        public typealias ArrayLiteralElement = Edge.Set.Element

        /// The raw type that can be used to represent all values of the conforming
        /// type.
        ///
        /// Every distinct value of the conforming type has a corresponding unique
        /// value of the `RawValue` type, but there may be values of the `RawValue`
        /// type that don't have a corresponding value of the conforming type.
        public typealias RawValue = Int8
    }

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional("PaperSize.Legal")"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: Int8) { fatalError() }

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [Edge]

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int8

    /// A collection of all values of this type.
    public static var allCases: [Edge] { get { fatalError() } }

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: Int8 { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Edge : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Edge : Hashable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Edge : RawRepresentable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Edge : Sendable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Edge.Set : Sendable {
}

/// The inset distances for the sides of a rectangle.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct EdgeInsets : Equatable {

    public var top: CGFloat { get { fatalError() } }

    public var leading: CGFloat { get { fatalError() } }

    public var bottom: CGFloat { get { fatalError() } }

    public var trailing: CGFloat { get { fatalError() } }

    @inlinable public init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) { fatalError() }

    @inlinable public init() { fatalError() }

    public static func == (a: EdgeInsets, b: EdgeInsets) -> Bool { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EdgeInsets : Sendable {
}

/// A set of edit actions on a collection of data that a view can offer
/// to a user.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct EditActions<Data> : OptionSet, Sendable {

    /// The raw value.
    public let rawValue: Int = { fatalError() }()

    /// Creates a new set from a raw value.
    ///
    /// - Parameter rawValue: The raw value with which to create the
    /// collection edits.
    public init(rawValue: Int) { fatalError() }

    /// All the edit actions available on this collection.
    public static var all: EditActions<Data> { get { fatalError() } }

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = EditActions<Data>

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = EditActions<Data>

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EditActions where Data : RangeReplaceableCollection {

    /// An edit action that allows the user to delete one or more elements
    /// of a collection.
    public static var delete: EditActions<Data> { get { fatalError() } }

    /// All the edit actions available on this collection.
    public static var all: EditActions<Data> { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EditActions where Data : MutableCollection {

    /// An edit action that allows the user to move elements of a
    /// collection.
    public static var move: EditActions<Data> { get { fatalError() } }

    /// All the edit actions available on this collection.
    public static var all: EditActions<Data> { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EditActions where Data : MutableCollection, Data : RangeReplaceableCollection {

    /// All the edit actions available on this collection.
    public static var all: EditActions<Data> { get { fatalError() } }
}

/// A button that toggles the edit mode environment value.
///
/// An edit button toggles the environment's ``EnvironmentValues/editMode``
/// value for content within a container that supports edit mode.
/// In the following example, an edit button placed inside a ``NavigationView``
/// supports editing of a ``List``:
///
///     @State private var fruits = [
///         "Apple",
///         "Banana",
///         "Papaya",
///         "Mango"
///     ]
///
///     var body: some View {
///         NavigationView {
///             List {
///                 ForEach(fruits, id: \.self) { fruit in
///                     Text(fruit)
///                 }
///                 .onDelete { fruits.remove(atOffsets: $0) }
///                 .onMove { fruits.move(fromOffsets: $0, toOffset: $1) }
///             }
///             .navigationTitle("Fruits")
///             .toolbar {
///                 EditButton()
///             }
///         }
///     }
///
/// Because the ``ForEach`` in the above example defines behaviors for
/// ``DynamicViewContent/onDelete(perform:)`` and
/// ``DynamicViewContent/onMove(perform:)``, the editable list displays the
/// delete and move UI when the user taps Edit. Notice that the Edit button
/// displays the title "Done" while edit mode is active:
///
/// ![A screenshot of an app with an Edit button in the navigation bar.
/// The button is labeled Done to indicate edit mode is active. Below the
/// navigation bar, a list labeled Fruits in edit mode. The list contains
/// four members, each showing a red circle containing a white dash to the
/// left of the item, and an icon composed of three horizontal lines to the
/// right of the item.](EditButton-1)
///
/// You can also create custom views that react to changes in the edit mode
/// state, as described in ``EditMode``.
@available(iOS 13.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct EditButton : View {

    /// Creates an Edit button instance.
    public init() { fatalError() }

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

/// A mode that indicates whether the user can edit a view's content.
///
/// You receive an optional binding to the edit mode state when you
/// read the ``EnvironmentValues/editMode`` environment value. The binding
/// contains an `EditMode` value that indicates whether edit mode is active,
/// and that you can use to change the mode. To learn how to read an environment
/// value, see ``EnvironmentValues``.
///
/// Certain built-in views automatically alter their appearance and behavior
/// in edit mode. For example, a ``List`` with a ``ForEach`` that's
/// configured with the ``DynamicViewContent/onDelete(perform:)`` or
/// ``DynamicViewContent/onMove(perform:)`` modifier provides controls to
/// delete or move list items while in edit mode. On devices without an attached
/// keyboard and mouse or trackpad, people can make multiple selections in lists
/// only when edit mode is active.
///
/// You can also customize your own views to react to edit mode.
/// The following example replaces a read-only ``Text`` view with
/// an editable ``TextField``, checking for edit mode by
/// testing the wrapped value's ``EditMode/isEditing`` property:
///
///     @Environment(\.editMode) private var editMode
///     @State private var name = "Maria Ruiz"
///
///     var body: some View {
///         Form {
///             if editMode?.wrappedValue.isEditing == true {
///                 TextField("Name", text: $name)
///             } else {
///                 Text(name)
///             }
///         }
///         .animation(nil, value: editMode?.wrappedValue)
///         .toolbar { // Assumes embedding this view in a NavigationView.
///             EditButton()
///         }
///     }
///
/// You can set the edit mode through the binding, or you can
/// rely on an ``EditButton`` to do that for you, as the example above
/// demonstrates. The button activates edit mode when the user
/// taps it, and disables the mode when the user taps again.
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public enum EditMode : Sendable {

    /// The user can't edit the view content.
    ///
    /// The ``isEditing`` property is `false` in this state.
    case inactive

    /// The view is in a temporary edit mode.
    ///
    /// The use of this state varies by platform and for different
    /// controls. As an example, SkipUI might engage temporary edit mode
    /// over the duration of a swipe gesture.
    ///
    /// The ``isEditing`` property is `true` in this state.
    case transient

    /// The user can edit the view content.
    ///
    /// The ``isEditing`` property is `true` in this state.
    case active

    /// Indicates whether a view is being edited.
    ///
    /// This property returns `true` if the mode is something other than
    /// inactive.
    public var isEditing: Bool { get { fatalError() } }

    public static func == (a: EditMode, b: EditMode) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension EditMode : Equatable {
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension EditMode : Hashable {
}

/// An opaque wrapper view that adds editing capabilities to a row in a list.
///
/// You don't use this type directly. Instead SkipUI creates this type on
/// your behalf.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct EditableCollectionContent<Content, Data> {
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EditableCollectionContent : View where Content : View {

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

/// An empty, or identity, modifier, used during development to switch
/// modifiers at compile time.
///
/// Use the empty modifier to switch modifiers at compile time during
/// development. In the example below, in a debug build the ``Text``
/// view inside `ContentView` has a yellow background and a red border.
/// A non-debug build reflects the default system, or container supplied
/// appearance.
///
///     struct EmphasizedLayout: ViewModifier {
///         func body(content: Content) -> some View {
///             content
///                 .background(Color.yellow)
///                 .border(Color.red)
///         }
///     }
///
///     struct ContentView: View {
///         var body: some View {
///             Text("Hello, World!")
///                 .modifier(modifier)
///         }
///
///         var modifier: some ViewModifier {
///             #if DEBUG
///                 return EmphasizedLayout()
///             #else
///                 return EmptyModifier()
///             #endif
///         }
///     }
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct EmptyModifier : ViewModifier {
    public static let identity: EmptyModifier = { fatalError() }()

    /// The type of view representing the body.
    public typealias Body = Never

    @inlinable public init() { fatalError() }

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    @MainActor public func body(content: EmptyModifier.Content) -> EmptyModifier.Body { fatalError() }
    public typealias Content = Never
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EmptyModifier : Sendable {
}

/// A view that doesn't contain any content.
///
/// You will rarely, if ever, need to create an `EmptyView` directly. Instead,
/// `EmptyView` represents the absence of a view.
///
/// SkipUI uses `EmptyView` in situations where a SkipUI view type defines one
/// or more child views with generic parameters, and allows the child views to
/// be absent. When absent, the child view's type in the generic type parameter
/// is `EmptyView`.
///
/// The following example creates an indeterminate ``ProgressView`` without
/// a label. The ``ProgressView`` type declares two generic parameters,
/// `Label` and `CurrentValueLabel`, for the types used by its subviews.
/// When both subviews are absent, like they are here, the resulting type is
/// `ProgressView<EmptyView, EmptyView>`, as indicated by the example's output:
///
///     let progressView = ProgressView()
///     print("\(type(of:progressView))")
///     // Prints: ProgressView<EmptyView, EmptyView>
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct EmptyView : View {

    /// Creates an empty view.
    @inlinable public init() { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EmptyView : Sendable {
}


/// An empty widget configuration.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@frozen public struct EmptyWidgetConfiguration : WidgetConfiguration {

    @inlinable public init() { fatalError() }

    /// The type of widget configuration representing the body of
    /// this configuration.
    ///
    /// When you create a custom widget, Swift infers this type from your
    /// implementation of the required `body` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension EmptyWidgetConfiguration : Sendable {
}

/// A selectability type that enables text selection by the person using your app.
///
/// Don't use this type directly. Instead, use ``TextSelectability/enabled``.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct EnabledTextSelectability : TextSelectability {

    /// A Boolean value that indicates whether the selectability type allows
    /// selection.
    ///
    /// Conforming types, such as ``EnabledTextSelectability`` and
    /// ``DisabledTextSelectability``, return `true` or `false` for this
    /// property as appropriate. SkipUI expects this value for a given
    /// selectability type to be constant, unaffected by global state.
    public static let allowsSelection: Bool = { fatalError() }()
}

/// A view type that compares itself against its previous value and prevents its
/// child updating if its new value is the same as its old value.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct EquatableView<Content> : View where Content : Equatable, Content : View {

    public var content: Content { get { fatalError() } }

    @inlinable public init(content: Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

/// A set of key modifiers that you can add to a gesture.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct EventModifiers : OptionSet {

    /// The raw value.
    public let rawValue: Int = { fatalError() }()

    /// Creates a new set from a raw value.
    ///
    /// - Parameter rawValue: The raw value with which to create the key
    ///   modifier.
    public init(rawValue: Int) { fatalError() }

    /// The Caps Lock key.
    public static let capsLock: EventModifiers = { fatalError() }()

    /// The Shift key.
    public static let shift: EventModifiers = { fatalError() }()

    /// The Control key.
    public static let control: EventModifiers = { fatalError() }()

    /// The Option key.
    public static let option: EventModifiers = { fatalError() }()

    /// The Command key.
    public static let command: EventModifiers = { fatalError() }()

    /// Any key on the numeric keypad.
    public static let numericPad: EventModifiers = { fatalError() }()

    /// The Function key.
    @available(iOS, deprecated: 15.0, message: "Function modifier is reserved for system applications")
    @available(macOS, deprecated: 12.0, message: "Function modifier is reserved for system applications")
    @available(tvOS, deprecated: 15.0, message: "Function modifier is reserved for system applications")
    @available(watchOS, deprecated: 8.0, message: "Function modifier is reserved for system applications")
    @available(xrOS, deprecated: 1.0, message: "Function modifier is reserved for system applications")
    public static let function: EventModifiers = { fatalError() }()

    /// All possible modifier keys.
    public static let all: EventModifiers = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = EventModifiers

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = EventModifiers

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EventModifiers : Sendable {
}

/// The way that file dialogs present the file system.
///
/// Apply the options using the ``View/fileDialogBrowserOptions(_:)`` modifier.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct FileDialogBrowserOptions : OptionSet {

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public let rawValue: Int = { fatalError() }()

    /// Creates a new option set from the given raw value.
    ///
    /// This initializer always succeeds, even if the value passed as `rawValue`
    /// exceeds the static properties declared as part of the option set. This
    /// example creates an instance of `ShippingOptions` with a raw value beyond
    /// the highest element, with a bit mask that effectively contains all the
    /// declared static members.
    ///
    ///     let extraOptions = ShippingOptions(rawValue: 255)
    ///     print(extraOptions.isStrictSuperset(of: .all))
    ///     // Prints "true"
    ///
    /// - Parameter rawValue: The raw value of the option set to create. Each bit
    ///   of `rawValue` potentially represents an element of the option set,
    ///   though raw values may include bits that are not defined as distinct
    ///   values of the `OptionSet` type.
    public init(rawValue: Int) { fatalError() }

    /// Allows enumerating packages contents in contrast to the default behavior
    /// when packages are represented flatly, similar to files.
    public static let enumeratePackages: FileDialogBrowserOptions = { fatalError() }()

    /// Displays the files that are hidden by default.
    public static let includeHiddenFiles: FileDialogBrowserOptions = { fatalError() }()

    /// On iOS, configures the `fileExporter`, `fileImporter`,
    /// or `fileMover` to show or hide file extensions.
    /// Default behavior is to hide them.
    /// On macOS, this option has no effect.
    public static let displayFileExtensions: FileDialogBrowserOptions = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = FileDialogBrowserOptions

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = FileDialogBrowserOptions

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int
}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension FileDialogBrowserOptions : Sendable {
}

/// An effect that changes the visual appearance of a view, largely without
/// changing its ancestors or descendants.
///
/// The only change the effect makes to the view's ancestors and descendants is
/// to change the coordinate transform to and from them.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol GeometryEffect : Animatable, ViewModifier where Self.Body == Never {

    /// Returns the current value of the effect.
    func effectValue(size: CGSize) -> ProjectionTransform
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension GeometryEffect {

    /// Returns an effect that produces the same geometry transform as this
    /// effect, but only applies the transform while rendering its view.
    ///
    /// Use this method to disable layout changes during transitions. The view
    /// ignores the transform returned by this method while the view is
    /// performing its layout calculations.
//    @inlinable public func ignoredByLayout() -> _IgnoredByLayoutEffect<Self> { fatalError() }
}

/// A proxy for access to the size and coordinate space (for anchor resolution)
/// of the container view.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct GeometryProxy {

    /// The size of the container view.
    public var size: CGSize { get { fatalError() } }

    /// Resolves the value of `anchor` to the container view.
    public subscript<T>(anchor: Anchor<T>) -> T { get { fatalError() } }

    /// The safe area inset of the container view.
    public var safeAreaInsets: EdgeInsets { get { fatalError() } }

    /// Returns the container view's bounds rectangle, converted to a defined
    /// coordinate space.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    public func frame(in coordinateSpace: CoordinateSpace) -> CGRect { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension GeometryProxy {

    /// Returns the given coordinate space's bounds rectangle, converted to the
    /// local coordinate space.
    public func bounds(of coordinateSpace: NamedCoordinateSpace) -> CGRect? { fatalError() }

    /// Returns the container view's bounds rectangle, converted to a defined
    /// coordinate space.
    public func frame(in coordinateSpace: some CoordinateSpaceProtocol) -> CGRect { fatalError() }
}

/// A container view that defines its content as a function of its own size and
/// coordinate space.
///
/// This view returns a flexible preferred size to its parent layout.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct GeometryReader<Content> : View where Content : View {

    public var content: (GeometryProxy) -> Content { get { fatalError() } }

    @inlinable public init(@ViewBuilder content: @escaping (GeometryProxy) -> Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

/// The global coordinate space at the root of the view hierarchy.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct GlobalCoordinateSpace : CoordinateSpaceProtocol {

    public init() { fatalError() }

    /// The resolved coordinate space.
    public var coordinateSpace: CoordinateSpace { get { fatalError() } }
}

/// A date picker style that displays an interactive calendar or clock.
///
/// You can also use ``DatePickerStyle/graphical`` to construct this style.
@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct GraphicalDatePickerStyle : DatePickerStyle {

    /// Creates an instance of the graphical date picker style.
    public init() { fatalError() }

    /// Returns the appearance and interaction content for a `DatePicker`.
    ///
    /// The system calls this method for each ``DatePicker`` instance in a view
    /// hierarchy where this style is the current date picker style.
    ///
    /// - Parameter configuration : The properties of the date picker.
    @available(iOS 16.0, macOS 13.0, *)
    public func makeBody(configuration: GraphicalDatePickerStyle.Configuration) -> some View { return never() }


    /// A view representing the appearance and interaction of a `DatePicker`.
//    public typealias Body = some View
}

/// A stylized view, with an optional label, that visually collects a logical
/// grouping of content.
///
/// Use a group box when you want to visually distinguish a portion of your
/// user interface with an optional title for the boxed content.
///
/// The following example sets up a `GroupBox` with the label "End-User
/// Agreement", and a long `agreementText` string in a ``SkipUI/Text`` view
/// wrapped by a ``SkipUI/ScrollView``. The box also contains a
/// ``SkipUI/Toggle`` for the user to interact with after reading the text.
///
///     var body: some View {
///         GroupBox(label:
///             Label("End-User Agreement", systemImage: "building.columns")
///         ) {
///             ScrollView(.vertical, showsIndicators: true) {
///                 Text(agreementText)
///                     .font(.footnote)
///             }
///             .frame(height: 100)
///             Toggle(isOn: $userAgreed) {
///                 Text("I agree to the above terms")
///             }
///         }
///     }
///
/// ![An iOS status bar above a gray rounded rectangle region marking the bounds
/// of the group box. At the top of the region, the title End-User Agreement
/// in a large bold font with an icon of a building with columns. Below this,
/// a scroll view with six lines of text visible. At the bottom of the gray
/// group box region, a toggle switch with the label I agree to the above
/// terms.](SkipUI-GroupBox-EULA.png)
///
@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct GroupBox<Label, Content> : View where Label : View, Content : View {

    /// Creates a group box with the provided label and view content.
    /// - Parameters:
    ///   - content: A ``SkipUI/ViewBuilder`` that produces the content for the
    ///     group box.
    ///   - label: A ``SkipUI/ViewBuilder`` that produces a label for the group
    ///     box.
    @available(iOS 14.0, macOS 10.15, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) { fatalError() }

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

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension GroupBox where Label == GroupBoxStyleConfiguration.Label, Content == GroupBoxStyleConfiguration.Content {

    /// Creates a group box based on a style configuration.
    ///
    /// Use this initializer within the ``GroupBoxStyle/makeBody(configuration:)``
    /// method of a ``GroupBoxStyle`` instance to create a styled group box,
    /// with customizations, while preserving its existing style.
    ///
    /// The following example adds a pink border around the group box,
    /// without overriding its current style:
    ///
    ///     struct PinkBorderGroupBoxStyle: GroupBoxStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             GroupBox(configuration)
    ///                 .border(Color.pink)
    ///         }
    ///     }
    /// - Parameter configuration: The properties of the group box instance being created.
    public init(_ configuration: GroupBoxStyleConfiguration) { fatalError() }
}

@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension GroupBox where Label == EmptyView {

    /// Creates an unlabeled group box with the provided view content.
    /// - Parameters:
    ///   - content: A ``SkipUI/ViewBuilder`` that produces the content for
    ///    the group box.
    public init(@ViewBuilder content: () -> Content) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension GroupBox where Label == Text {

    /// Creates a group box with the provided view content and title.
    /// - Parameters:
    ///   - titleKey: The key for the group box's title, which describes the
    ///     content of the group box.
    ///   - content: A ``SkipUI/ViewBuilder`` that produces the content for the
    ///     group box.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a group box with the provided view content.
    /// - Parameters:
    ///   - title: A string that describes the content of the group box.
    ///   - content: A ``SkipUI/ViewBuilder`` that produces the content for the
    ///     group box.
    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol { fatalError() }
}

@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension GroupBox {

    @available(iOS, deprecated: 100000.0, renamed: "GroupBox(content:label:)")
    @available(macOS, deprecated: 100000.0, renamed: "GroupBox(content:label:)")
    @available(xrOS, deprecated: 100000.0, renamed: "GroupBox(content:label:)")
    public init(label: Label, @ViewBuilder content: () -> Content) { fatalError() }
}

/// A type that specifies the appearance and interaction of all group boxes
/// within a view hierarchy.
///
/// To configure the current `GroupBoxStyle` for a view hierarchy, use the
/// ``View/groupBoxStyle(_:)`` modifier.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol GroupBoxStyle {

    /// A view that represents the body of a group box.
    associatedtype Body : View

    /// Creates a view representing the body of a group box.
    ///
    /// SkipUI calls this method for each instance of ``SkipUI/GroupBox``
    /// created within a view hierarchy where this style is the current
    /// group box style.
    ///
    /// - Parameter configuration: The properties of the group box instance being
    ///   created.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a group box instance.
    typealias Configuration = GroupBoxStyleConfiguration
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension GroupBoxStyle where Self == DefaultGroupBoxStyle {

    /// The default style for group box views.
    public static var automatic: DefaultGroupBoxStyle { get { fatalError() } }
}

/// The properties of a group box instance.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct GroupBoxStyleConfiguration {

    /// A type-erased label of a group box.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A type-erased content of a group box.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A view that provides the title of the group box.
    public let label: GroupBoxStyleConfiguration.Label = { fatalError() }()

    /// A view that represents the content of the group box.
    public let content: GroupBoxStyleConfiguration.Content = { fatalError() }()
}

/// An effect applied when the pointer hovers over a view.
@available(iOS 13.4, tvOS 16.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct HoverEffect {

    /// An effect  that attempts to determine the effect automatically.
    /// This is the default effect.
    public static let automatic: HoverEffect = { fatalError() }()

    /// An effect  that morphs the pointer into a platter behind the view
    /// and shows a light source indicating position.
    ///
    /// On tvOS, it applies a projection effect accompanied with a specular
    /// highlight on the view when contained within a focused view. It also
    /// incorporates motion effects to produce a parallax effect by adjusting
    /// the projection matrix and specular offset.
    @available(tvOS 17.0, *)
    public static let highlight: HoverEffect = { fatalError() }()

    /// An effect that slides the pointer under the view and disappears as the
    /// view scales up and gains a shadow.
    public static let lift: HoverEffect = { fatalError() }()
}

/// The current hovering state and value of the pointer.
///
/// When you use the ``View/onContinuousHover(coordinateSpace:perform:)``
/// modifier, you can handle the hovering state using the `action` closure.
/// SkipUI calls the closure with a phase value to indicate the current
/// hovering state. The following example updates `hoverLocation` and
/// `isHovering` based on the phase provided to the closure:
///
///     @State private var hoverLocation: CGPoint = .zero
///     @State private var isHovering = false
///
///     var body: some View {
///         VStack {
///             Color.red
///                 .frame(width: 400, height: 400)
///                 .onContinuousHover { phase in
///                     switch phase {
///                     case .active(let location):
///                         hoverLocation = location
///                         isHovering = true
///                     case .ended:
///                         isHovering = false
///                     }
///                 }
///                 .overlay {
///                     Rectangle()
///                         .frame(width: 50, height: 50)
///                         .foregroundColor(isHovering ? .green : .blue)
///                         .offset(x: hoverLocation.x, y: hoverLocation.y)
///                 }
///         }
///     }
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
@available(watchOS, unavailable)
@frozen public enum HoverPhase : Equatable {

    /// The pointer's location moved to the specified point within the view.
    case active(CGPoint)

    /// The pointer exited the view.
    case ended

    public static func == (a: HoverPhase, b: HoverPhase) -> Bool { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
@available(watchOS, unavailable)
extension HoverPhase : Sendable {
}

/// A label style that only displays the icon of the label.
///
/// You can also use ``LabelStyle/iconOnly`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct IconOnlyLabelStyle : LabelStyle {

    /// Creates an icon-only label style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a label.
    ///
    /// The system calls this method for each ``Label`` instance in a view
    /// hierarchy where this style is the current label style.
    ///
    /// - Parameter configuration: The properties of the label.
    public func makeBody(configuration: IconOnlyLabelStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a label.
//    public typealias Body = some View
}

/// Defines the implementation of all `IndexView` instances within a view
/// hierarchy.
///
/// To configure the current `IndexViewStyle` for a view hierarchy, use the
/// `.indexViewStyle()` modifier.
@available(iOS 14.0, tvOS 14.0, watchOS 8.0, *)
@available(macOS, unavailable)
public protocol IndexViewStyle {
}

@available(iOS 14.0, tvOS 14.0, watchOS 8.0, *)
@available(macOS, unavailable)
extension IndexViewStyle where Self == PageIndexViewStyle {

    /// An index view style that places a page index view over its content.
    public static var page: PageIndexViewStyle { get { fatalError() } }

    /// An index view style that places a page index view over its content.
    ///
    /// - Parameter backgroundDisplayMode: The display mode of the background of
    ///   any page index views receiving this style
    public static func page(backgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode) -> PageIndexViewStyle { fatalError() }
}

/// A collection wrapper that iterates over the indices and identifiers of a
/// collection together.
///
/// You don't use this type directly. Instead SkipUI creates this type on
/// your behalf.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct IndexedIdentifierCollection<Base, ID> : Collection where Base : Collection, ID : Hashable {

    /// A type representing the sequence's elements.
    public struct Element {
    }

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public typealias Index = Base.Index

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: IndexedIdentifierCollection<Base, ID>.Index { get { fatalError() } }

    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    ///
    /// When you need a range that includes the last element of a collection, use
    /// the half-open range operator (`..<`) with `endIndex`. The `..<` operator
    /// creates a range that doesn't include the upper bound, so it's always
    /// safe to use with `endIndex`. For example:
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let index = numbers.firstIndex(of: 30) {
    ///         print(numbers[index ..< numbers.endIndex])
    ///     }
    ///     // Prints "[30, 40, 50]"
    ///
    /// If the collection is empty, `endIndex` is equal to `startIndex`.
    public var endIndex: IndexedIdentifierCollection<Base, ID>.Index { get { fatalError() } }

    /// Accesses the element at the specified position.
    ///
    /// The following example accesses an element of an array through its
    /// subscript to print its value:
    ///
    ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     print(streets[1])
    ///     // Prints "Bryant"
    ///
    /// You can subscript a collection with any valid index other than the
    /// collection's end index. The end index refers to the position one past
    /// the last element of a collection, so it doesn't correspond with an
    /// element.
    ///
    /// - Parameter position: The position of the element to access. `position`
    ///   must be a valid index of the collection that is not equal to the
    ///   `endIndex` property.
    ///
    /// - Complexity: O(1)
    public subscript(position: IndexedIdentifierCollection<Base, ID>.Index) -> IndexedIdentifierCollection<Base, ID>.Element { get { fatalError() } }

    /// Returns the position immediately after the given index.
    ///
    /// The successor of an index must be well defined. For an index `i` into a
    /// collection `c`, calling `c.index(after: i)` returns the same index every
    /// time.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: IndexedIdentifierCollection<Base, ID>.Index) -> IndexedIdentifierCollection<Base, ID>.Index { fatalError() }

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = DefaultIndices<IndexedIdentifierCollection<Base, ID>>

    /// A type that provides the collection's iteration interface and
    /// encapsulates its iteration state.
    ///
    /// By default, a collection conforms to the `Sequence` protocol by
    /// supplying `IndexingIterator` as its associated `Iterator`
    /// type.
    public typealias Iterator = IndexingIterator<IndexedIdentifierCollection<Base, ID>>

    /// A collection representing a contiguous subrange of this collection's
    /// elements. The subsequence shares indices with the original collection.
    ///
    /// The default subsequence type for collections that don't define their own
    /// is `Slice`.
    public typealias SubSequence = Slice<IndexedIdentifierCollection<Base, ID>>
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension IndexedIdentifierCollection : BidirectionalCollection where Base : BidirectionalCollection {

    /// Returns the position immediately before the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    /// - Returns: The index value immediately before `i`.
    public func index(before i: IndexedIdentifierCollection<Base, ID>.Index) -> IndexedIdentifierCollection<Base, ID>.Index { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension IndexedIdentifierCollection : RandomAccessCollection where Base : RandomAccessCollection {
}

/// A `PickerStyle` where each option is displayed inline with other views in
/// the current container.
///
/// You can also use ``PickerStyle/inline`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct InlinePickerStyle : PickerStyle {

    /// Creates an inline picker style.
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

/// The table style that describes the behavior and appearance of a table with
/// its content and selection inset from the table edges.
///
/// You can also use ``TableStyle/inset`` to construct this style.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct InsetTableStyle : TableStyle {

    /// Creates a default inset table style, with alternating row backgrounds.
    public init() { fatalError() }

    /// Creates a view that represents the body of a table.
    ///
    /// The system calls this method for each ``Table`` instance in a view
    /// hierarchy where this style is the current table style.
    ///
    /// - Parameter configuration: The properties of the table.
    public func makeBody(configuration: InsetTableStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a table.
//    public typealias Body = some View
}

/// The orientation of the interface from the user's perspective.
///
/// By default, device previews appear right side up, using orientation
/// ``InterfaceOrientation/portrait``. You can change the orientation
/// with a call to the ``View/previewInterfaceOrientation(_:)`` modifier:
///
///     struct CircleImage_Previews: PreviewProvider {
///         static var previews: some View {
///             CircleImage()
///                 .previewInterfaceOrientation(.landscapeRight)
///         }
///     }
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct InterfaceOrientation : CaseIterable, Identifiable, Equatable, Sendable {

    /// A collection of all values of this type.
    public static var allCases: [InterfaceOrientation] { get { fatalError() } }

    /// The stable identity of the entity associated with this instance.
    public var id: String { get { fatalError() } }

    /// The device is in portrait mode, with the top of the device on top.
    public static let portrait: InterfaceOrientation = { fatalError() }()

    /// The device is in portrait mode, but is upside down.
    public static let portraitUpsideDown: InterfaceOrientation = { fatalError() }()

    /// The device is in landscape mode, with the top of the device on the left.
    public static let landscapeLeft: InterfaceOrientation = { fatalError() }()

    /// The device is in landscape mode, with the top of the device on the right.
    public static let landscapeRight: InterfaceOrientation = { fatalError() }()

    public static func == (a: InterfaceOrientation, b: InterfaceOrientation) -> Bool { fatalError() }

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [InterfaceOrientation]

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    public typealias ID = String
}

/// Key equivalents consist of a letter, punctuation, or function key that can
/// be combined with an optional set of modifier keys to specify a keyboard
/// shortcut.
///
/// Key equivalents are used to establish keyboard shortcuts to app
/// functionality. Any key can be used as a key equivalent as long as pressing
/// it produces a single character value. Key equivalents are typically
/// initialized using a single-character string literal, with constants for
/// unprintable or hard-to-type values.
///
/// The modifier keys necessary to type a key equivalent are factored in to the
/// resulting keyboard shortcut. That is, a key equivalent whose raw value is
/// the capitalized string "A" corresponds with the keyboard shortcut
/// Command-Shift-A. The exact mapping may depend on the keyboard layout—for
/// example, a key equivalent with the character value "}" produces a shortcut
/// equivalent to Command-Shift-] on ANSI keyboards, but would produce a
/// different shortcut for keyboard layouts where punctuation characters are in
/// different locations.
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct KeyEquivalent : Sendable {

    /// Up Arrow (U+F700)
    public static let upArrow: KeyEquivalent = { fatalError() }()

    /// Down Arrow (U+F701)
    public static let downArrow: KeyEquivalent = { fatalError() }()

    /// Left Arrow (U+F702)
    public static let leftArrow: KeyEquivalent = { fatalError() }()

    /// Right Arrow (U+F703)
    public static let rightArrow: KeyEquivalent = { fatalError() }()

    /// Escape (U+001B)
    public static let escape: KeyEquivalent = { fatalError() }()

    /// Delete (U+0008)
    public static let delete: KeyEquivalent = { fatalError() }()

    /// Delete Forward (U+F728)
    public static let deleteForward: KeyEquivalent = { fatalError() }()

    /// Home (U+F729)
    public static let home: KeyEquivalent = { fatalError() }()

    /// End (U+F72B)
    public static let end: KeyEquivalent = { fatalError() }()

    /// Page Up (U+F72C)
    public static let pageUp: KeyEquivalent = { fatalError() }()

    /// Page Down (U+F72D)
    public static let pageDown: KeyEquivalent = { fatalError() }()

    /// Clear (U+F739)
    public static let clear: KeyEquivalent = { fatalError() }()

    /// Tab (U+0009)
    public static let tab: KeyEquivalent = { fatalError() }()

    /// Space (U+0020)
    public static let space: KeyEquivalent = { fatalError() }()

    /// Return (U+000D)
    public static let `return`: KeyEquivalent = { fatalError() }()

    /// The character value that the key equivalent represents.
    public var character: Character { get { fatalError() } }

    /// Creates a new key equivalent from the given character value.
    public init(_ character: Character) { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension KeyEquivalent : Hashable {

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (a: KeyEquivalent, b: KeyEquivalent) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension KeyEquivalent : ExpressibleByExtendedGraphemeClusterLiteral {

    /// Creates an instance initialized to the given value.
    ///
    /// - Parameter value: The value of the new instance.
    public init(extendedGraphemeClusterLiteral: Character) { fatalError() }

    /// A type that represents an extended grapheme cluster literal.
    ///
    /// Valid types for `ExtendedGraphemeClusterLiteralType` are `Character`,
    /// `String`, and `StaticString`.
    public typealias ExtendedGraphemeClusterLiteralType = Character

    /// A type that represents a Unicode scalar literal.
    ///
    /// Valid types for `UnicodeScalarLiteralType` are `Unicode.Scalar`,
    /// `Character`, `String`, and `StaticString`.
    public typealias UnicodeScalarLiteralType = Character
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct KeyPress : Sendable {

    /// The phase of the key-press event (`.down`, `.repeat`, or `.up`).
    public let phase: KeyPress.Phases = { fatalError() }()

    /// The key equivalent value for the pressed key.
    public let key: KeyEquivalent = { fatalError() }()

    /// The characters generated by the pressed key as if no modifier
    /// key applies.
    public let characters: String = { fatalError() }()

    /// The set of modifier keys the user held in addition to the
    /// pressed key.
    public let modifiers: EventModifiers = { fatalError() }()
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension KeyPress : CustomDebugStringConvertible {

    /// Options for matching different phases of a key-press event.
    public struct Phases : OptionSet, Sendable, CustomDebugStringConvertible {

        /// The user pressed down on a key.
        public static let down: KeyPress.Phases = { fatalError() }()

        /// The user held a key down to issue a sequence of repeating events.
        public static let `repeat`: KeyPress.Phases = { fatalError() }()

        /// The user released a key.
        public static let up: KeyPress.Phases = { fatalError() }()

        /// A value that matches all key press phases.
        public static let all: KeyPress.Phases = { fatalError() }()

        /// A textual representation of this instance, suitable for debugging.
        ///
        /// Calling this property directly is discouraged. Instead, convert an
        /// instance of any type to a string by using the `String(reflecting:)`
        /// initializer. This initializer works with any type, and uses the custom
        /// `debugDescription` property for types that conform to
        /// `CustomDebugStringConvertible`:
        ///
        ///     struct Point: CustomDebugStringConvertible {
        ///         let x: Int, y: Int
        ///
        ///         var debugDescription: String {
        ///             return "(\(x), \(y))"
        ///         }
        ///     }
        ///
        ///     let p = Point(x: 21, y: 30)
        ///     let s = String(reflecting: p)
        ///     print(s)
        ///     // Prints "(21, 30)"
        ///
        /// The conversion of `p` to a string in the assignment to `s` uses the
        /// `Point` type's `debugDescription` property.
        public var debugDescription: String { get { fatalError() } }

        /// The corresponding value of the raw type.
        ///
        /// A new instance initialized with `rawValue` will be equivalent to this
        /// instance. For example:
        ///
        ///     enum PaperSize: String {
        ///         case A4, A5, Letter, Legal
        ///     }
        ///
        ///     let selectedSize = PaperSize.Letter
        ///     print(selectedSize.rawValue)
        ///     // Prints "Letter"
        ///
        ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
        ///     // Prints "true"
        public let rawValue: Int = { fatalError() }()

        /// Creates a new option set from the given raw value.
        ///
        /// This initializer always succeeds, even if the value passed as `rawValue`
        /// exceeds the static properties declared as part of the option set. This
        /// example creates an instance of `ShippingOptions` with a raw value beyond
        /// the highest element, with a bit mask that effectively contains all the
        /// declared static members.
        ///
        ///     let extraOptions = ShippingOptions(rawValue: 255)
        ///     print(extraOptions.isStrictSuperset(of: .all))
        ///     // Prints "true"
        ///
        /// - Parameter rawValue: The raw value of the option set to create. Each bit
        ///   of `rawValue` potentially represents an element of the option set,
        ///   though raw values may include bits that are not defined as distinct
        ///   values of the `OptionSet` type.
        public init(rawValue: Int) { fatalError() }

        /// The type of the elements of an array literal.
        public typealias ArrayLiteralElement = KeyPress.Phases

        /// The element type of the option set.
        ///
        /// To inherit all the default implementations from the `OptionSet` protocol,
        /// the `Element` type must be `Self`, the default.
        public typealias Element = KeyPress.Phases

        /// The raw type that can be used to represent all values of the conforming
        /// type.
        ///
        /// Every distinct value of the conforming type has a corresponding unique
        /// value of the `RawValue` type, but there may be values of the `RawValue`
        /// type that don't have a corresponding value of the conforming type.
        public typealias RawValue = Int
    }

    /// A result value returned from a key-press action that indicates whether
    /// the action consumed the event.
    public enum Result : Sendable {

        /// The action consumed the event, preventing dispatch from continuing.
        case handled

        /// The action ignored the event, allowing dispatch to continue.
        case ignored

        public static func == (a: KeyPress.Result, b: KeyPress.Result) -> Bool { fatalError() }

        public func hash(into hasher: inout Hasher) { fatalError() }

        public var hashValue: Int { get { fatalError() } }
    }

    /// A textual representation of this instance, suitable for debugging.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(reflecting:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `debugDescription` property for types that conform to
    /// `CustomDebugStringConvertible`:
    ///
    ///     struct Point: CustomDebugStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var debugDescription: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(reflecting: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `debugDescription` property.
    public var debugDescription: String { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension KeyPress.Result : Equatable {
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension KeyPress.Result : Hashable {
}

/// Keyboard shortcuts describe combinations of keys on a keyboard that the user
/// can press in order to activate a button or toggle.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct KeyboardShortcut : Sendable {

    /// Options for how a keyboard shortcut participates in automatic localization.
    ///
    /// A shortcut's `key` that is defined on an US-English keyboard
    /// layout might not be reachable on international layouts.
    /// For example the shortcut `⌘[` works well for the US layout but is
    /// hard to reach for German users.
    /// On the German keyboard layout, pressing `⌥5` will produce
    /// `[`, which causes the shortcut to become `⌥⌘5`.
    /// If configured, which is the default behavior, automatic shortcut
    /// remapping will convert it to `⌘Ö`.
    ///
    /// In addition to that, some keyboard shortcuts carry information
    /// about directionality.
    /// Right-aligning a block of text or seeking forward in context of music
    /// playback are such examples. These kinds of shortcuts benefit from the option
    /// ``KeyboardShortcut/Localization-swift.struct/withoutMirroring``
    /// to tell the system that they won't be flipped when running in a
    /// right-to-left context.
    @available(iOS 15.0, macOS 12.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public struct Localization : Sendable {

        /// Remap shortcuts to their international counterparts, mirrored for
        /// right-to-left usage if appropriate.
        ///
        /// This is the default configuration.
        public static let automatic: KeyboardShortcut.Localization = { fatalError() }()

        /// Don't mirror shortcuts.
        ///
        /// Use this for shortcuts that always have a specific directionality, like
        /// aligning something on the right.
        ///
        /// Don't use this option for navigational shortcuts like "Go Back" because navigation
        /// is flipped in right-to-left contexts.
        public static let withoutMirroring: KeyboardShortcut.Localization = { fatalError() }()

        /// Don't use automatic shortcut remapping.
        ///
        /// When you use this mode, you have to take care of international use-cases separately.
        public static let custom: KeyboardShortcut.Localization = { fatalError() }()
    }

    /// The standard keyboard shortcut for the default button, consisting of
    /// the Return (↩) key and no modifiers.
    ///
    /// On macOS, the default button is designated with special coloration. If
    /// more than one control is assigned this shortcut, only the first one is
    /// emphasized.
    public static let defaultAction: KeyboardShortcut = { fatalError() }()

    /// The standard keyboard shortcut for cancelling the in-progress action
    /// or dismissing a prompt, consisting of the Escape (⎋) key and no
    /// modifiers.
    public static let cancelAction: KeyboardShortcut = { fatalError() }()

    /// The key equivalent that the user presses in conjunction with any
    /// specified modifier keys to activate the shortcut.
    public var key: KeyEquivalent { get { fatalError() } }

    /// The modifier keys that the user presses in conjunction with a key
    /// equivalent to activate the shortcut.
    public var modifiers: EventModifiers { get { fatalError() } }

    /// The localization strategy to apply to this shortcut.
    @available(iOS 15.0, macOS 12.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var localization: KeyboardShortcut.Localization { get { fatalError() } }

    /// Creates a new keyboard shortcut with the given key equivalent and set of
    /// modifier keys.
    ///
    /// The localization configuration defaults to ``KeyboardShortcut/Localization-swift.struct/automatic``.
    public init(_ key: KeyEquivalent, modifiers: EventModifiers = .command) { fatalError() }

    /// Creates a new keyboard shortcut with the given key equivalent and set of
    /// modifier keys.
    ///
    /// Use the `localization` parameter to specify a localization strategy
    /// for this shortcut.
    @available(iOS 15.0, macOS 12.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public init(_ key: KeyEquivalent, modifiers: EventModifiers = .command, localization: KeyboardShortcut.Localization) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension KeyboardShortcut : Hashable {

    public static func == (lhs: KeyboardShortcut, rhs: KeyboardShortcut) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// A container view that arranges its child views in a grid that
/// grows horizontally, creating items only as needed.
///
/// Use a lazy horizontal grid when you want to display a large, horizontally
/// scrollable collection of views arranged in a two dimensional layout. The
/// first view that you provide to the grid's `content` closure appears in the
/// top row of the column that's on the grid's leading edge. Additional views
/// occupy successive cells in the grid, filling the first column from top to
/// bottom, then the second column, and so on. The number of columns can grow
/// unbounded, but you specify the number of rows by providing a
/// corresponding number of ``GridItem`` instances to the grid's initializer.
///
/// The grid in the following example defines two rows and uses a ``ForEach``
/// structure to repeatedly generate a pair of ``Text`` views for the rows
/// in each column:
///
///     struct HorizontalSmileys: View {
///         let rows = [GridItem(.fixed(30)), GridItem(.fixed(30))]
///
///         var body: some View {
///             ScrollView(.horizontal) {
///                 LazyHGrid(rows: rows) {
///                     ForEach(0x1f600...0x1f679, id: \.self) { value in
///                         Text(String(format: "%x", value))
///                         Text(emoji(value))
///                             .font(.largeTitle)
///                     }
///                 }
///             }
///         }
///
///         private func emoji(_ value: Int) -> String {
///             guard let scalar = UnicodeScalar(value) else { return "?" }
///             return String(Character(scalar))
///         }
///     }
///
/// For each column in the grid, the top row shows a Unicode code point from
/// the "Smileys" group, and the bottom shows its corresponding emoji:
///
/// ![A screenshot of a row of hexadecimal numbers above a row of emoji,
/// with each number and a corresponding emoji making up a column.
/// Half of each of the first and last column are cut off on either end
/// of the image, with eight columns fully visible.](LazyHGrid-1-iOS)
///
/// You can achieve a similar layout using a ``Grid`` container. Unlike a lazy
/// grid, which creates child views only when SkipUI needs to display
/// them, a regular grid creates all of its child views right away. This
/// enables the grid to provide better support for cell spacing and alignment.
/// Only use a lazy grid if profiling your app shows that a ``Grid`` view
/// performs poorly because it tries to load too many views at once.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct LazyHGrid<Content> : View where Content : View {

    /// Creates a grid that grows horizontally.
    ///
    /// - Parameters:
    ///   - rows: An array of grid items that size and position each column of
    ///    the grid.
    ///   - alignment: The alignment of the grid within its parent view.
    ///   - spacing: The spacing between the grid and the next item in its
    ///   parent view.
    ///   - pinnedViews: Views to pin to the bounds of a parent scroll view.
    ///   - content: The content of the grid.
    public init(rows: [GridItem], alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

/// A view that arranges its children in a line that grows horizontally,
/// creating items only as needed.
///
/// The stack is "lazy," in that the stack view doesn't create items until
/// it needs to render them onscreen.
///
/// In the following example, a ``ScrollView`` contains a `LazyHStack` that
/// consists of a horizontal row of text views. The stack aligns to the top
/// of the scroll view and uses 10-point spacing between each text view.
///
///     ScrollView(.horizontal) {
///         LazyHStack(alignment: .top, spacing: 10) {
///             ForEach(1...100, id: \.self) {
///                 Text("Column \($0)")
///             }
///         }
///     }
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct LazyHStack<Content> : View where Content : View {

    /// Creates a lazy horizontal stack view with the given spacing,
    /// vertical alignment, pinning behavior, and content.
    ///
    /// - Parameters:
    ///     - alignment: The guide for aligning the subviews in this stack. All
    ///       child views have the same vertical screen coordinate.
    ///     - spacing: The distance between adjacent subviews, or `nil` if you
    ///       want the stack to choose a default distance for each pair of
    ///       subviews.
    ///     - pinnedViews: The kinds of child views that will be pinned.
    ///     - content: A view builder that creates the content of this stack.
    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

/// A container view that arranges its child views in a grid that
/// grows vertically, creating items only as needed.
///
/// Use a lazy vertical grid when you want to display a large, vertically
/// scrollable collection of views arranged in a two dimensional layout. The
/// first view that you provide to the grid's `content` closure appears in the
/// top row of the column that's on the grid's leading edge. Additional views
/// occupy successive cells in the grid, filling the first row from leading to
/// trailing edges, then the second row, and so on. The number of rows can grow
/// unbounded, but you specify the number of columns by providing a
/// corresponding number of ``GridItem`` instances to the grid's initializer.
///
/// The grid in the following example defines two columns and uses a
/// ``ForEach`` structure to repeatedly generate a pair of ``Text`` views for
/// the columns in each row:
///
///     struct VerticalSmileys: View {
///         let columns = [GridItem(.flexible()), GridItem(.flexible())]
///
///         var body: some View {
///              ScrollView {
///                  LazyVGrid(columns: columns) {
///                      ForEach(0x1f600...0x1f679, id: \.self) { value in
///                          Text(String(format: "%x", value))
///                          Text(emoji(value))
///                              .font(.largeTitle)
///                      }
///                  }
///              }
///         }
///
///         private func emoji(_ value: Int) -> String {
///             guard let scalar = UnicodeScalar(value) else { return "?" }
///             return String(Character(scalar))
///         }
///     }
///
/// For each row in the grid, the first column shows a Unicode code point from
/// the "Smileys" group, and the second shows its corresponding emoji:
///
/// ![A screenshot of a colunb of hexadecimal numbers to the left of a column
/// of emoji, with each number and a corresponding emoji making up a row.
/// Half of the last row is cut off, with seventeen rows fully
/// visible.](LazyVGrid-1-iOS)
///
/// You can achieve a similar layout using a ``Grid`` container. Unlike a lazy
/// grid, which creates child views only when SkipUI needs to display
/// them, a regular grid creates all of its child views right away. This
/// enables the grid to provide better support for cell spacing and alignment.
/// Only use a lazy grid if profiling your app shows that a ``Grid`` view
/// performs poorly because it tries to load too many views at once.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct LazyVGrid<Content> : View where Content : View {

    /// Creates a grid that grows vertically.
    ///
    /// - Parameters:
    ///   - columns: An array of grid items to size and position each row of
    ///    the grid.
    ///   - alignment: The alignment of the grid within its parent view.
    ///   - spacing: The spacing between the grid and the next item in its
    ///   parent view.
    ///   - pinnedViews: Views to pin to the bounds of a parent scroll view.
    ///   - content: The content of the grid.
    public init(columns: [GridItem], alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

/// A view that arranges its children in a line that grows vertically,
/// creating items only as needed.
///
/// The stack is "lazy," in that the stack view doesn't create items until
/// it needs to render them onscreen.
///
/// In the following example, a ``ScrollView`` contains a `LazyVStack` that
/// consists of a vertical row of text views. The stack aligns to the
/// leading edge of the scroll view, and uses default spacing between the
/// text views.
///
///     ScrollView {
///         LazyVStack(alignment: .leading) {
///             ForEach(1...100, id: \.self) {
///                 Text("Row \($0)")
///             }
///         }
///     }
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct LazyVStack<Content> : View where Content : View {

    /// Creates a lazy vertical stack view with the given spacing,
    /// vertical alignment, pinning behavior, and content.
    ///
    /// - Parameters:
    ///     - alignment: The guide for aligning the subviews in this stack. All
    ///     child views have the same horizontal screen coordinate.
    ///     - spacing: The distance between adjacent subviews, or `nil` if you
    ///       want the stack to choose a default distance for each pair of
    ///       subviews.
    ///     - pinnedViews: The kinds of child views that will be pinned.
    ///     - content: A view builder that creates the content of this stack.
    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

/// The Accessibility Bold Text user setting options.
///
/// The app can't override the user's choice before iOS 16, tvOS 16 or
/// watchOS 9.0.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum LegibilityWeight : Hashable, Sendable {

    /// Use regular font weight (no Accessibility Bold).
    case regular

    /// Use heavier font weight (force Accessibility Bold).
    case bold

    public static func == (a: LegibilityWeight, b: LegibilityWeight) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// A type-erased widget configuration.
///
/// You don't use this type directly. Instead SkipUI creates this type on
/// your behalf.
@available(iOS 16.1, macOS 13.0, watchOS 9.1, *)
@available(tvOS, unavailable)
@frozen public struct LimitedAvailabilityConfiguration : WidgetConfiguration {

    /// The type of widget configuration representing the body of
    /// this configuration.
    ///
    /// When you create a custom widget, Swift infers this type from your
    /// implementation of the required `body` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

/// A gauge style that displays bar that fills from leading to trailing
/// edges as the gauge's current value increases.
///
/// Use ``GaugeStyle/linearCapacity`` to construct this style.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public struct LinearCapacityGaugeStyle : GaugeStyle {

    /// Creates a linear capacity gauge style.
    public init() { fatalError() }

    /// Creates a view representing the body of a gauge.
    ///
    /// The system calls this modifier on each instance of gauge within a view
    /// hierarchy where this style is the current gauge style.
    ///
    /// - Parameter configuration: The properties to apply to the gauge instance.
    public func makeBody(configuration: LinearCapacityGaugeStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a gauge.
//    public typealias Body = some View
}

/// The local coordinate space of the current view.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct LocalCoordinateSpace : CoordinateSpaceProtocol {

    public init() { fatalError() }

    /// The resolved coordinate space.
    public var coordinateSpace: CoordinateSpace { get { fatalError() } }
}

/// A set of view properties that may be synchronized between views
/// using the `View.matchedGeometryEffect()` function.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen public struct MatchedGeometryProperties : OptionSet {

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public let rawValue: UInt32

    /// Creates a new option set from the given raw value.
    ///
    /// This initializer always succeeds, even if the value passed as `rawValue`
    /// exceeds the static properties declared as part of the option set. This
    /// example creates an instance of `ShippingOptions` with a raw value beyond
    /// the highest element, with a bit mask that effectively contains all the
    /// declared static members.
    ///
    ///     let extraOptions = ShippingOptions(rawValue: 255)
    ///     print(extraOptions.isStrictSuperset(of: .all))
    ///     // Prints "true"
    ///
    /// - Parameter rawValue: The raw value of the option set to create. Each bit
    ///   of `rawValue` potentially represents an element of the option set,
    ///   though raw values may include bits that are not defined as distinct
    ///   values of the `OptionSet` type.
    @inlinable public init(rawValue: UInt32) { fatalError() }

    /// The view's position, in window coordinates.
    public static let position: MatchedGeometryProperties = { fatalError() }()

    /// The view's size, in local coordinates.
    public static let size: MatchedGeometryProperties = { fatalError() }()

    /// Both the `position` and `size` properties.
    public static let frame: MatchedGeometryProperties = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = MatchedGeometryProperties

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = MatchedGeometryProperties

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = UInt32
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension MatchedGeometryProperties : Sendable {
}

/// A background material type.
///
/// You can apply a blur effect to a view that appears behind another view by
/// adding a material with the ``View/background(_:ignoresSafeAreaEdges:)``
/// modifier:
///
///     ZStack {
///         Color.teal
///         Label("Flag", systemImage: "flag.fill")
///             .padding()
///             .background(.regularMaterial)
///     }
///
/// In the example above, the ``ZStack`` layers a ``Label`` on top of the color
/// ``ShapeStyle/teal``. The background modifier inserts the
/// regular material below the label, blurring the part of
/// the background that the label --- including its padding --- covers:
///
/// ![A screenshot of a label on a teal background, where the area behind
/// the label appears blurred.](Material-1)
///
/// A material isn't a view, but adding a material is like inserting a
/// translucent layer between the modified view and its background:
///
/// ![An illustration that shows a background layer below a material layer,
/// which in turn appears below a foreground layer.](Material-2)
///
/// The blurring effect provided by the material isn't simple opacity. Instead,
/// it uses a platform-specific blending that produces an effect that resembles
/// heavily frosted glass. You can see this more easily with a complex
/// background, like an image:
///
///     ZStack {
///         Image("chili_peppers")
///             .resizable()
///             .aspectRatio(contentMode: .fit)
///         Label("Flag", systemImage: "flag.fill")
///             .padding()
///             .background(.regularMaterial)
///     }
///
/// ![A screenshot of a label on an image background, where the area behind
/// the label appears blurred.](Material-3)
///
/// For physical materials, the degree to which the background colors pass
/// through depends on the thickness. The effect also varies with light and
/// dark appearance:
///
/// ![An array of labels on a teal background. The first column, labeled light
/// appearance, shows a succession of labels on blurred backgrounds where the
/// blur increases from top to bottom, resulting in lighter and lighter blur.
/// The second column, labeled dark appearance, shows a similar succession of
/// labels, except that the blur gets darker from top to bottom. The rows are
/// labeled, from top to bottom: no material, ultra thin, thin, regular, thick,
/// and ultra thick.](Material-4)
///
/// If you need a material to have a particular shape, you can use the
/// ``View/background(_:in:fillStyle:)-20tq5`` modifier. For example, you can
/// create a material with rounded corners:
///
///     ZStack {
///         Color.teal
///         Label("Flag", systemImage: "flag.fill")
///             .padding()
///             .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
///     }
///
/// ![A screenshot of a label on a teal background, where the area behind
/// the label appears blurred. The blurred area has rounded corners.](Material-5)
///
/// When you add a material, foreground elements exhibit vibrancy,
/// a context-specific blend of the foreground and background colors
/// that improves contrast. However using ``View/foregroundStyle(_:)``
/// to set a custom foreground style --- excluding the hierarchical
/// styles, like ``ShapeStyle/secondary`` --- disables vibrancy.
///
/// > Note: A material blurs a background that's part of your app, but not
/// what appears behind your app on the screen.
/// For example, the content on the Home Screen doesn't affect the appearance
/// of a widget.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct Material : Sendable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
extension Material {

    /// A material that's somewhat translucent.
    public static let regular: Material = { fatalError() }()

    /// A material that's more opaque than translucent.
    public static let thick: Material = { fatalError() }()

    /// A material that's more translucent than opaque.
    public static let thin: Material = { fatalError() }()

    /// A mostly translucent material.
    public static let ultraThin: Material = { fatalError() }()

    /// A mostly opaque material.
    public static let ultraThick: Material = { fatalError() }()
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Material {

    /// A material matching the style of system toolbars.
    public static let bar: Material = { fatalError() }()
}

/// A keyframe that immediately moves to the given value without interpolating.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct MoveKeyframe<Value> : KeyframeTrackContent where Value : Animatable {

    /// Creates a new keyframe using the given value.
    ///
    /// - Parameters:
    ///   - to: The value of the keyframe.
    public init(_ to: Value) { fatalError() }

    public typealias Value = Value
    public typealias Body = MoveKeyframe<Value>
    public var body: Body { fatalError() }
}

/// A named coordinate space.
///
/// Use the `coordinateSpace(_:)` modifier to assign a name to the local
/// coordinate space of a  parent view. Child views can then refer to that
/// coordinate space using `.named(_:)`.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct NamedCoordinateSpace : CoordinateSpaceProtocol, Equatable {

    /// The resolved coordinate space.
    public var coordinateSpace: CoordinateSpace { get { fatalError() } }

    public static func == (a: NamedCoordinateSpace, b: NamedCoordinateSpace) -> Bool { fatalError() }
}

/// A dynamic property type that allows access to a namespace defined
/// by the persistent identity of the object containing the property
/// (e.g. a view).
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen @propertyWrapper public struct Namespace : DynamicProperty {

    @inlinable public init() { fatalError() }

    public var wrappedValue: Namespace.ID { get { fatalError() } }

    /// A namespace defined by the persistent identity of an
    /// `@Namespace` dynamic property.
    @frozen public struct ID : Hashable {

        public func hash(into hasher: inout Hasher) { fatalError() }

        public static func == (a: Namespace.ID, b: Namespace.ID) -> Bool { fatalError() }

        public var hashValue: Int { get { fatalError() } }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Namespace : Sendable {
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Namespace.ID : Sendable {
}

/// An index view style that places a page index view over its content.
///
/// You can also use ``IndexViewStyle/page`` to construct this style.
@available(iOS 14.0, tvOS 14.0, watchOS 8.0, *)
@available(macOS, unavailable)
public struct PageIndexViewStyle : IndexViewStyle {

    /// The background style for the page index view.
    public struct BackgroundDisplayMode : Sendable {

        /// Background will use the default for the platform.
        public static let automatic: PageIndexViewStyle.BackgroundDisplayMode = { fatalError() }()

        /// Background is only shown while the index view is interacted with.
        @available(watchOS, unavailable)
        public static let interactive: PageIndexViewStyle.BackgroundDisplayMode = { fatalError() }()

        /// Background is always displayed behind the page index view.
        @available(watchOS, unavailable)
        public static let always: PageIndexViewStyle.BackgroundDisplayMode = { fatalError() }()

        /// Background is never displayed behind the page index view.
        public static let never: PageIndexViewStyle.BackgroundDisplayMode = { fatalError() }()
    }

    /// Creates a page index view style.
    ///
    /// - Parameter backgroundDisplayMode: The display mode of the background of any
    /// page index views receiving this style
    public init(backgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode = .automatic) { fatalError() }
}

/// A `TabViewStyle` that implements a paged scrolling `TabView`.
///
/// You can also use ``TabViewStyle/page`` or
/// ``TabViewStyle/page(indexDisplayMode:)`` to construct this style.
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
@available(macOS, unavailable)
public struct PageTabViewStyle : TabViewStyle {

    /// A style for displaying the page index view
    public struct IndexDisplayMode : Sendable {

        /// Displays an index view when there are more than one page
        public static let automatic: PageTabViewStyle.IndexDisplayMode = { fatalError() }()

        /// Always display an index view regardless of page count
        @available(watchOS 8.0, *)
        public static let always: PageTabViewStyle.IndexDisplayMode = { fatalError() }()

        /// Never display an index view
        @available(watchOS 8.0, *)
        public static let never: PageTabViewStyle.IndexDisplayMode = { fatalError() }()
    }

    /// Creates a new `PageTabViewStyle` with an index display mode
    public init(indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic) { fatalError() }
}

/// The scroll behavior that aligns scroll targets to container-based geometry.
///
/// In the following example, every view in the lazy stack is flexible
/// in both directions and the scroll view settles to container-aligned
/// boundaries.
///
///     ScrollView {
///         LazyVStack(spacing: 0.0) {
///             ForEach(items) { item in
///                 FullScreenItem(item)
///             }
///         }
///     }
///     .scrollTargetBehavior(.paging)
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct PagingScrollTargetBehavior : ScrollTargetBehavior {

    /// Creates a paging scroll behavior.
    public init() { fatalError() }

    /// Updates the proposed target that a scrollable view should scroll to.
    ///
    /// The system calls this method in two main cases:
    /// - When a scroll gesture ends, it calculates where it would naturally
    ///   scroll to using its deceleration rate. The system
    ///   provides this calculated value as the target of this method.
    /// - When a scrollable view's size changes, it calculates where it should
    ///   be scrolled given the new size and provides this calculates value
    ///   as the target of this method.
    ///
    /// You can implement this method to override the calculated target
    /// which will have the scrollable view scroll to a different position
    /// than it would otherwise.
    public func updateTarget(_ target: inout ScrollTarget, context: PagingScrollTargetBehavior.TargetContext) { fatalError() }
}

/// A control group style that presents its content as a palette.
///
/// Use ``ControlGroupStyle/palette`` to construct this style.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PaletteControlGroupStyle : ControlGroupStyle {

    /// Creates a palette control group style.
    public init() { fatalError() }

    /// Creates a view representing the body of a control group.
    ///
    /// - Parameter configuration: The properties of the control group instance
    ///   being created.
    ///
    /// This method will be called for each instance of ``ControlGroup`` created
    /// within a view hierarchy where this style is the current
    /// `ControlGroupStyle`.
    @MainActor public func makeBody(configuration: PaletteControlGroupStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a control group.
//    public typealias Body = some View
}

/// A picker style that presents the options as a row of compact elements.
///
/// You can also use ``PickerStyle/palette`` to construct this style.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PalettePickerStyle : PickerStyle {

    /// Creates a palette picker style.
    public init() { fatalError() }
}

/// The selection effect to apply to a palette item.
///
/// You can configure the selection effect of a palette item by using the
/// ``View/paletteSelectionEffect(_:)`` view modifier.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PaletteSelectionEffect : Sendable, Equatable {

    public static func == (lhs: PaletteSelectionEffect, rhs: PaletteSelectionEffect) -> Bool { fatalError() }

    /// Applies the system's default effect when selected.
    ///
    /// When using un-tinted SF Symbols or template images, the current tint
    /// color is applied to the selected items' image.
    /// If the provided SF Symbols have custom tints, a stroke is drawn around selected items.
    public static var automatic: PaletteSelectionEffect { get { fatalError() } }

    /// Applies the specified symbol variant when selected.
    ///
    /// - Note: This effect only applies to SF Symbols.
    public static func symbolVariant(_ variant: SymbolVariants) -> PaletteSelectionEffect { fatalError() }

    /// Does not apply any system effect when selected.
    ///
    /// - Note: Make sure to manually implement a way to indicate selection when
    /// using this case. For example, you could dynamically resolve the item's
    /// image based on the selection state.
    public static var custom: PaletteSelectionEffect { get { fatalError() } }
}

/// A container that animates its content by automatically cycling through
/// a collection of phases that you provide, each defining a discrete step
/// within an animation.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct PhaseAnimator<Phase, Content> : View where Phase : Equatable, Content : View {

    /// Cycles through the given phases when the trigger value changes,
    /// updating the view builder closure that you supply.
    ///
    /// The phases that you provide specify the individual values that will
    /// be animated to when the trigger value changes.
    ///
    /// When the view first appears, the value from the first phase is provided
    /// to the `content` closure. When the trigger value changes, the content
    /// closure is called with the value from the second phase and its
    /// corresponding animation. This continues until the last phase is
    /// reached, after which the first phase is animated to.
    ///
    /// - Parameters:
    ///   - phases: Phases defining the states that will be cycled through.
    ///     This sequence must not be empty. If an empty sequence is provided,
    ///     a visual warning will be displayed in place of this view, and a
    ///     warning will be logged.
    ///   - trigger: A value to observe for changes.
    ///   - content: A view builder closure.
    ///   - animation: A closure that returns the animation to use when
    ///     transitioning to the next phase. If `nil` is returned, the
    ///     transition will not be animated.
    public init(_ phases: some Sequence<Phase>, trigger: some Equatable, @ViewBuilder content: @escaping (Phase) -> Content, animation: @escaping (Phase) -> Animation? = { _ in .default }) { fatalError() }

    /// Cycles through the given phases continuously, updating the content
    /// using the view builder closure that you supply.
    ///
    /// The phases that you provide define the individual values that will
    /// be animated between.
    ///
    /// When the view first appears, the the first phase is provided
    /// to the `content` closure. The animator then immediately animates
    /// to the second phase, using an animation returned from the `animation`
    /// closure. This continues until the last phase is reached, after which
    /// the animator loops back to the beginning.
    ///
    /// - Parameters:
    ///   - phases: Phases defining the states that will be cycled through.
    ///     This sequence must not be empty. If an empty sequence is provided,
    ///     a visual warning will be displayed in place of this view, and a
    ///     warning will be logged.
    ///   - content: A view builder closure.
    ///   - animation: A closure that returns the animation to use when
    ///     transitioning to the next phase. If `nil` is returned, the
    ///     transition will not be animated.
    public init(_ phases: some Sequence<Phase>, @ViewBuilder content: @escaping (Phase) -> Content, animation: @escaping (Phase) -> Animation? = { _ in .default }) { fatalError() }

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

/// A set of view types that may be pinned to the bounds of a scroll view.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct PinnedScrollableViews : OptionSet, Sendable {

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public let rawValue: UInt32

    /// Creates a new option set from the given raw value.
    ///
    /// This initializer always succeeds, even if the value passed as `rawValue`
    /// exceeds the static properties declared as part of the option set. This
    /// example creates an instance of `ShippingOptions` with a raw value beyond
    /// the highest element, with a bit mask that effectively contains all the
    /// declared static members.
    ///
    ///     let extraOptions = ShippingOptions(rawValue: 255)
    ///     print(extraOptions.isStrictSuperset(of: .all))
    ///     // Prints "true"
    ///
    /// - Parameter rawValue: The raw value of the option set to create. Each bit
    ///   of `rawValue` potentially represents an element of the option set,
    ///   though raw values may include bits that are not defined as distinct
    ///   values of the `OptionSet` type.
    public init(rawValue: UInt32) { fatalError() }

    /// The header view of each `Section` will be pinned.
    public static let sectionHeaders: PinnedScrollableViews = { fatalError() }()

    /// The footer view of each `Section` will be pinned.
    public static let sectionFooters: PinnedScrollableViews = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = PinnedScrollableViews

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = PinnedScrollableViews

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = UInt32
}

/// A placeholder used to construct an inline modifier, transition, or other
/// helper type.
///
/// You don't use this type directly. Instead SkipUI creates this type on
/// your behalf.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct PlaceholderContentView<Value> : View {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

/// The list style that describes the behavior and appearance of a plain list.
///
/// You can also use ``ListStyle/plain`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PlainListStyle : ListStyle {

    /// Creates a plain list style.
    public init() { fatalError() }
}

/// A text editor style with no decoration.
///
/// You can also use ``TextEditorStyle/plain`` to create this style.
@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PlainTextEditorStyle : TextEditorStyle {

    /// Creates a view that represents the body of a text editor.
    ///
    /// The system calls this method for each ``TextEditor`` instance in a view
    /// hierarchy where this style is the current text editor style.
    ///
    /// - Parameter configuration: The properties of the text editor.
    public func makeBody(configuration: PlainTextEditorStyle.Configuration) -> some View { return never() }


    public init() { fatalError() }

    /// A view that represents the body of a text editor.
//    public typealias Body = some View
}

/// A text field style with no decoration.
///
/// You can also use ``TextFieldStyle/plain`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PlainTextFieldStyle : TextFieldStyle {

    public init() { fatalError() }
}

/// An attachment anchor for a popover.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum PopoverAttachmentAnchor {

    /// The anchor point for the popover relative to the source's frame.
    case rect(Anchor<CGRect>.Source)

    /// The anchor point for the popover expressed as a unit point  that
    /// describes possible alignments relative to a SkipUI view.
    case point(UnitPoint)
}

/// A named value produced by a view.
///
/// A view with multiple children automatically combines its values for a given
/// preference into a single value visible to its ancestors.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol PreferenceKey {

    /// The type of value produced by this preference.
    associatedtype Value

    /// The default value of the preference.
    ///
    /// Views that have no explicit value for the key produce this default
    /// value. Combining child views may remove an implicit value produced by
    /// using the default. This means that `reduce(value: &x, nextValue:
    /// {defaultValue})` shouldn't change the meaning of `x`.
    static var defaultValue: Self.Value { get }

    /// Combines a sequence of values by modifying the previously-accumulated
    /// value with the result of a closure that provides the next value.
    ///
    /// This method receives its values in view-tree order. Conceptually, this
    /// combines the preference value from one tree with that of its next
    /// sibling.
    ///
    /// - Parameters:
    ///   - value: The value accumulated through previous calls to this method.
    ///     The implementation should modify this value.
    ///   - nextValue: A closure that returns the next value in the sequence.
    static func reduce(value: inout Self.Value, nextValue: () -> Self.Value)
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension PreferenceKey where Self.Value : ExpressibleByNilLiteral {

    /// Let nil-expressible values default-initialize to nil.
    public static var defaultValue: Self.Value { get { fatalError() } }
}

/// A key for specifying the preferred color scheme.
///
/// Don't use this key directly. Instead, set a preferred color scheme for a
/// view using the ``View/preferredColorScheme(_:)`` view modifier. Get the
/// current color scheme for a view by accessing the
/// ``EnvironmentValues/colorScheme`` value.
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public struct PreferredColorSchemeKey : PreferenceKey {

    /// The type of value produced by this preference.
    public typealias Value = ColorScheme?

    /// Combines a sequence of values by modifying the previously-accumulated
    /// value with the result of a closure that provides the next value.
    ///
    /// This method receives its values in view-tree order. Conceptually, this
    /// combines the preference value from one tree with that of its next
    /// sibling.
    ///
    /// - Parameters:
    ///   - value: The value accumulated through previous calls to this method.
    ///     The implementation should modify this value.
    ///   - nextValue: A closure that returns the next value in the sequence.
    public static func reduce(value: inout PreferredColorSchemeKey.Value, nextValue: () -> PreferredColorSchemeKey.Value) { fatalError() }
}

/// Strategies for adapting a presentation to a different size class.
///
/// Use values of this type with the ``View/presentationCompactAdaptation(_:)``
/// and ``View/presentationCompactAdaptation(horizontal:vertical:)`` modifiers.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct PresentationAdaptation : Sendable {

    /// Use the default presentation adaptation.
    public static var automatic: PresentationAdaptation { get { fatalError() } }

    /// Don't adapt for the size class, if possible.
    public static var none: PresentationAdaptation { get { fatalError() } }

    /// Prefer a popover appearance when adapting for size classes.
    public static var popover: PresentationAdaptation { get { fatalError() } }

    /// Prefer a sheet appearance when adapting for size classes.
    public static var sheet: PresentationAdaptation { get { fatalError() } }

    /// Prefer a full-screen-cover appearance when adapting for size classes.
    public static var fullScreenCover: PresentationAdaptation { get { fatalError() } }
}

/// The kinds of interaction available to views behind a presentation.
///
/// Use values of this type with the
/// ``View/presentationBackgroundInteraction(_:)`` modifier.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct PresentationBackgroundInteraction : Sendable {

    /// The default background interaction for the presentation.
    public static var automatic: PresentationBackgroundInteraction { get { fatalError() } }

    /// People can interact with the view behind a presentation.
    public static var enabled: PresentationBackgroundInteraction { get { fatalError() } }

    /// People can interact with the view behind a presentation up through a
    /// specified detent.
    ///
    /// At detents larger than the one you specify, SkipUI disables
    /// interaction.
    ///
    /// - Parameter detent: The largest detent at which people can interact with
    ///   the view behind the presentation.
    public static func enabled(upThrough detent: PresentationDetent) -> PresentationBackgroundInteraction { fatalError() }

    /// People can't interact with the view behind a presentation.
    public static var disabled: PresentationBackgroundInteraction { get { fatalError() } }
}

/// A behavior that you can use to influence how a presentation responds to
/// swipe gestures.
///
/// Use values of this type with the
/// ``View/presentationContentInteraction(_:)`` modifier.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct PresentationContentInteraction : Equatable, Sendable {

    /// The default swipe behavior for the presentation.
    public static var automatic: PresentationContentInteraction { get { fatalError() } }

    /// A behavior that prioritizes resizing a presentation when swiping, rather
    /// than scrolling the content of the presentation.
    public static var resizes: PresentationContentInteraction { get { fatalError() } }

    /// A behavior that prioritizes scrolling the content of a presentation when
    /// swiping, rather than resizing the presentation.
    public static var scrolls: PresentationContentInteraction { get { fatalError() } }

    public static func == (a: PresentationContentInteraction, b: PresentationContentInteraction) -> Bool { fatalError() }
}

/// A type that represents a height where a sheet naturally rests.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct PresentationDetent : Hashable, Sendable {

    /// The system detent for a sheet that's approximately half the height of
    /// the screen, and is inactive in compact height.
    public static let medium: PresentationDetent = { fatalError() }()

    /// The system detent for a sheet at full height.
    public static let large: PresentationDetent = { fatalError() }()

    /// A custom detent with the specified fractional height.
    public static func fraction(_ fraction: CGFloat) -> PresentationDetent { fatalError() }

    /// A custom detent with the specified height.
    public static func height(_ height: CGFloat) -> PresentationDetent { fatalError() }

    /// A custom detent with a calculated height.
    public static func custom<D>(_ type: D.Type) -> PresentationDetent where D : CustomPresentationDetent { fatalError() }

    /// Information that you use to calculate the presentation's height.
    @dynamicMemberLookup public struct Context {

        /// The height that the presentation appears in.
        public var maxDetentValue: CGFloat { get { fatalError() } }

        /// Returns the value specified by the keyPath from the environment.
        ///
        /// This uses the environment from where the sheet is shown, not the
        /// environment where the presentation modifier is applied.
        public subscript<T>(dynamicMember keyPath: KeyPath<EnvironmentValues, T>) -> T { get { fatalError() } }
    }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (a: PresentationDetent, b: PresentationDetent) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// An indication whether a view is currently presented by another view.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
public struct PresentationMode {

    /// Indicates whether a view is currently presented.
    public var isPresented: Bool { get { fatalError() } }

    /// Dismisses the view if it is currently presented.
    ///
    /// If `isPresented` is false, `dismiss()` is a no-op.
    public mutating func dismiss() { fatalError() }
}

/// A view that represents the content of a presented window.
///
/// You don't create this type directly. ``WindowGroup`` creates values for you.
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PresentedWindowContent<Data, Content> : View where Data : Decodable, Data : Encodable, Data : Hashable, Content : View {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct ProjectionTransform {

    public var m11: CGFloat { get { fatalError() } }

    public var m12: CGFloat { get { fatalError() } }

    public var m13: CGFloat { get { fatalError() } }

    public var m21: CGFloat { get { fatalError() } }

    public var m22: CGFloat { get { fatalError() } }

    public var m23: CGFloat { get { fatalError() } }

    public var m31: CGFloat { get { fatalError() } }

    public var m32: CGFloat { get { fatalError() } }

    public var m33: CGFloat { get { fatalError() } }

    @inlinable public init() { fatalError() }

    @inlinable public init(_ m: CGAffineTransform) { fatalError() }

    @inlinable public init(_ m: CATransform3D) { fatalError() }

    @inlinable public var isIdentity: Bool { get { fatalError() } }

    @inlinable public var isAffine: Bool { get { fatalError() } }

    public mutating func invert() -> Bool { fatalError() }

    public func inverted() -> ProjectionTransform { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ProjectionTransform : Equatable {

    public static func == (a: ProjectionTransform, b: ProjectionTransform) -> Bool { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ProjectionTransform {

    @inlinable public func concatenating(_ rhs: ProjectionTransform) -> ProjectionTransform { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ProjectionTransform : Sendable {
}

/// A type indicating the prominence of a view hierarchy.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum Prominence : Sendable {

    /// The standard prominence.
    case standard

    /// An increased prominence.
    ///
    /// - Note: Not all views will react to increased prominence.
    case increased

    public static func == (a: Prominence, b: Prominence) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Prominence : Equatable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Prominence : Hashable {
}

/// A navigation split style that attempts to maintain the size of the
/// detail content when hiding or showing the leading columns.
///
/// Use ``NavigationSplitViewStyle/prominentDetail`` to construct this style.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ProminentDetailNavigationSplitViewStyle : NavigationSplitViewStyle {

    /// Creates an instance of ``ProminentDetailNavigationSplitViewStyle``.
    ///
    /// You can also use ``NavigationSplitViewStyle/prominentDetail`` to
    /// construct this style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a navigation split view.
    ///
    /// SkipUI calls this method for each instance of ``NavigationSplitView``,
    /// where this style is the current ``NavigationSplitViewStyle``.
    ///
    /// - Parameter configuration: The properties of the instance to create.
    public func makeBody(configuration: ProminentDetailNavigationSplitViewStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a navigation split view.
//    public typealias Body = some View
}

/// A proposal for the size of a view.
///
/// During layout in SkipUI, views choose their own size, but they do that
/// in response to a size proposal from their parent view. When you create
/// a custom layout using the ``Layout`` protocol, your layout container
/// participates in this process using `ProposedViewSize` instances.
/// The layout protocol's methods take a proposed size input that you
/// can take into account when arranging views and calculating the size of
/// the composite container. Similarly, your layout proposes a size to each
/// of its own subviews when it measures and places them.
///
/// Layout containers typically measure their subviews by proposing several
/// sizes and looking at the responses. The container can use this information
/// to decide how to allocate space among its subviews. A
/// layout might try the following special proposals:
///
/// * The ``zero`` proposal; the view responds with its minimum size.
/// * The ``infinity`` proposal; the view responds with its maximum size.
/// * The ``unspecified`` proposal; the view responds with its ideal size.
///
/// A layout might also try special cases for one dimension at a time. For
/// example, an ``HStack`` might measure the flexibility of its subviews'
/// widths, while using a fixed value for the height.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct ProposedViewSize : Equatable {

    /// The proposed horizontal size measured in points.
    ///
    /// A value of `nil` represents an unspecified width proposal, which a view
    /// interprets to mean that it should use its ideal width.
    public var width: CGFloat?

    /// The proposed vertical size measured in points.
    ///
    /// A value of `nil` represents an unspecified height proposal, which a view
    /// interprets to mean that it should use its ideal height.
    public var height: CGFloat?

    /// A size proposal that contains zero in both dimensions.
    ///
    /// Subviews of a custom layout return their minimum size when you propose
    /// this value using the ``LayoutSubview/dimensions(in:)`` method.
    /// A custom layout should also return its minimum size from the
    /// ``Layout/sizeThatFits(proposal:subviews:cache:)`` method for this
    /// value.
    public static let zero: ProposedViewSize = { fatalError() }()

    /// The proposed size with both dimensions left unspecified.
    ///
    /// Both dimensions contain `nil` in this size proposal.
    /// Subviews of a custom layout return their ideal size when you propose
    /// this value using the ``LayoutSubview/dimensions(in:)`` method.
    /// A custom layout should also return its ideal size from the
    /// ``Layout/sizeThatFits(proposal:subviews:cache:)`` method for this
    /// value.
    public static let unspecified: ProposedViewSize = { fatalError() }()

    /// A size proposal that contains infinity in both dimensions.
    ///
    /// Both dimensions contain
    /// in this size proposal.
    /// Subviews of a custom layout return their maximum size when you propose
    /// this value using the ``LayoutSubview/dimensions(in:)`` method.
    /// A custom layout should also return its maximum size from the
    /// ``Layout/sizeThatFits(proposal:subviews:cache:)`` method for this
    /// value.
    public static let infinity: ProposedViewSize = { fatalError() }()

    /// Creates a new proposed size using the specified width and height.
    ///
    /// - Parameters:
    ///   - width: A proposed width in points. Use a value of `nil` to indicate
    ///     that the width is unspecified for this proposal.
    ///   - height: A proposed height in points. Use a value of `nil` to
    ///     indicate that the height is unspecified for this proposal.
    @inlinable public init(width: CGFloat?, height: CGFloat?) { fatalError() }

    /// Creates a new proposed size from a specified size.
    ///
    /// - Parameter size: A proposed size with dimensions measured in points.
    @inlinable public init(_ size: CGSize) { fatalError() }

    /// Creates a new proposal that replaces unspecified dimensions in this
    /// proposal with the corresponding dimension of the specified size.
    ///
    /// Use the default value to prevent a flexible view from disappearing
    /// into a zero-sized frame, and ensure the unspecified value remains
    /// visible during debugging.
    ///
    /// - Parameter size: A set of concrete values to use for the size proposal
    ///   in place of any unspecified dimensions. The default value is `10`
    ///   for both dimensions.
    ///
    /// - Returns: A new, fully specified size proposal.
    @inlinable public func replacingUnspecifiedDimensions(by size: CGSize = CGSize(width: 10, height: 10)) -> CGSize { fatalError() }

    public static func == (a: ProposedViewSize, b: ProposedViewSize) -> Bool { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ProposedViewSize : Sendable {
}

/// The reasons to apply a redaction to data displayed on screen.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct RedactionReasons : OptionSet, Sendable {

    /// The raw value.
    public let rawValue: Int = { fatalError() }()

    /// Creates a new set from a raw value.
    ///
    /// - Parameter rawValue: The raw value with which to create the
    ///   reasons for redaction.
    public init(rawValue: Int) { fatalError() }

    /// Displayed data should appear as generic placeholders.
    ///
    /// Text and images will be automatically masked to appear as
    /// generic placeholders, though maintaining their original size and shape.
    /// Use this to create a placeholder UI without directly exposing
    /// placeholder data to users.
    public static let placeholder: RedactionReasons = { fatalError() }()

    /// Displayed data should be obscured to protect private information.
    ///
    /// Views marked with `privacySensitive` will be automatically redacted
    /// using a standard styling. To apply a custom treatment the redaction
    /// reason can be read out of the environment.
    ///
    ///     struct BankingContentView: View {
    ///         @Environment(\.redactionReasons) var redactionReasons
    ///
    ///         var body: some View {
    ///             if redactionReasons.contains(.privacy) {
    ///                 FullAppCover()
    ///             } else {
    ///                 AppContent()
    ///             }
    ///         }
    ///     }
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static let privacy: RedactionReasons = { fatalError() }()

    /// Displayed data should appear as invalidated and pending a new update.
    ///
    /// Views marked with `invalidatableContent` will be automatically
    /// redacted with a standard styling indicating the content is invalidated
    /// and new content will be available soon.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public static let invalidated: RedactionReasons = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = RedactionReasons

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = RedactionReasons

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int
}

/// A text field style with a system-defined rounded border.
///
/// You can also use ``TextFieldStyle/roundedBorder`` to construct this style.
@available(iOS 13.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct RoundedBorderTextFieldStyle : TextFieldStyle {

    public init() { fatalError() }
}

/// Defines the shape of a rounded rectangle's corners.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum RoundedCornerStyle : Sendable {

    /// Quarter-circle rounded rect corners.
    case circular

    /// Continuous curvature rounded rect corners.
    case continuous

    public static func == (a: RoundedCornerStyle, b: RoundedCornerStyle) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension RoundedCornerStyle : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension RoundedCornerStyle : Hashable {
}

/// A set of symbolic safe area regions.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen public struct SafeAreaRegions : OptionSet {

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public let rawValue: UInt = { fatalError() }()

    /// Creates a new option set from the given raw value.
    ///
    /// This initializer always succeeds, even if the value passed as `rawValue`
    /// exceeds the static properties declared as part of the option set. This
    /// example creates an instance of `ShippingOptions` with a raw value beyond
    /// the highest element, with a bit mask that effectively contains all the
    /// declared static members.
    ///
    ///     let extraOptions = ShippingOptions(rawValue: 255)
    ///     print(extraOptions.isStrictSuperset(of: .all))
    ///     // Prints "true"
    ///
    /// - Parameter rawValue: The raw value of the option set to create. Each bit
    ///   of `rawValue` potentially represents an element of the option set,
    ///   though raw values may include bits that are not defined as distinct
    ///   values of the `OptionSet` type.
    @inlinable public init(rawValue: UInt) { fatalError() }

    /// The safe area defined by the device and containers within the
    /// user interface, including elements such as top and bottom bars.
    public static let container: SafeAreaRegions = { fatalError() }()

    /// The safe area matching the current extent of any software
    /// keyboard displayed over the view content.
    public static let keyboard: SafeAreaRegions = { fatalError() }()

    /// All safe area regions.
    public static let all: SafeAreaRegions = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = SafeAreaRegions

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = SafeAreaRegions

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = UInt
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension SafeAreaRegions : Sendable {
}

/// A dynamic property that scales a numeric value.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@propertyWrapper public struct ScaledMetric<Value> : DynamicProperty where Value : BinaryFloatingPoint {

    /// Creates the scaled metric with an unscaled value and a text style to
    /// scale relative to.
    public init(wrappedValue: Value, relativeTo textStyle: Font.TextStyle) { fatalError() }

    /// Creates the scaled metric with an unscaled value using the default
    /// scaling.
    public init(wrappedValue: Value) { fatalError() }

    /// The value scaled based on the current environment.
    public var wrappedValue: Value { get { fatalError() } }
}

/// A picker style that presents the options in a segmented control.
///
/// You can also use ``PickerStyle/segmented`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
@available(watchOS, unavailable)
public struct SegmentedPickerStyle : PickerStyle {

    /// Creates a segmented picker style.
    public init() { fatalError() }
}

/// Represents a type of haptic and/or audio feedback that can be played.
///
/// This feedback can be passed to `View.sensoryFeedback` to play it.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(xrOS, unavailable)
public struct SensoryFeedback : Equatable, Sendable {

    /// Indicates that a task or action has completed.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let success: SensoryFeedback = { fatalError() }()

    /// Indicates that a task or action has produced a warning of some kind.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let warning: SensoryFeedback = { fatalError() }()

    /// Indicates that an error has occurred.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let error: SensoryFeedback = { fatalError() }()

    /// Indicates that a UI element’s values are changing.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let selection: SensoryFeedback = { fatalError() }()

    /// Indicates that an important value increased above a significant
    /// threshold.
    ///
    /// Only plays feedback on watchOS.
    public static let increase: SensoryFeedback = { fatalError() }()

    /// Indicates that an important value decreased below a significant
    /// threshold.
    ///
    /// Only plays feedback on watchOS.
    public static let decrease: SensoryFeedback = { fatalError() }()

    /// Indicates that an activity started.
    ///
    /// Use this haptic when starting a timer or any other activity that can be
    /// explicitly started and stopped.
    ///
    /// Only plays feedback on watchOS.
    public static let start: SensoryFeedback = { fatalError() }()

    /// Indicates that an activity stopped.
    ///
    /// Use this haptic when stopping a timer or other activity that was
    /// previously started.
    ///
    /// Only plays feedback on watchOS.
    public static let stop: SensoryFeedback = { fatalError() }()

    /// Indicates the alignment of a dragged item.
    ///
    /// For example, use this pattern in a drawing app when the user drags a
    /// shape into alignment with another shape.
    ///
    /// Only plays feedback on macOS.
    public static let alignment: SensoryFeedback = { fatalError() }()

    /// Indicates movement between discrete levels of pressure.
    ///
    /// For example, as the user presses a fast-forward button on a video
    /// player, playback could increase or decrease and haptic feedback could be
    /// provided as different levels of pressure are reached.
    ///
    /// Only plays feedback on macOS.
    public static let levelChange: SensoryFeedback = { fatalError() }()

    /// Provides a physical metaphor you can use to complement a visual
    /// experience.
    ///
    /// Only plays feedback on iOS, watchOS, and macOS.
    public static let impact: SensoryFeedback = { fatalError() }()

    /// Provides a physical metaphor you can use to complement a visual
    /// experience.
    ///
    /// Not all platforms will play different feedback for different weights and
    /// intensities of impact.
    ///
    /// Only plays feedback on iOS, watchOS, and macOS.
    public static func impact(weight: SensoryFeedback.Weight = .medium, intensity: Double = 1.0) -> SensoryFeedback { fatalError() }

    /// Provides a physical metaphor you can use to complement a visual
    /// experience.
    ///
    /// Not all platforms will play different feedback for different
    /// flexibilities and intensities of impact.
    ///
    /// Only plays feedback on iOS, watchOS, and macOS.
    public static func impact(flexibility: SensoryFeedback.Flexibility, intensity: Double = 1.0) -> SensoryFeedback { fatalError() }

    /// The weight to be represented by a type of feedback.
    ///
    /// `Weight` values can be passed to
    /// `SensoryFeedback.impact(weight:intensity:)`.
    public struct Weight : Equatable, Sendable {

        /// Indicates a collision between small or lightweight UI objects.
        public static let light: SensoryFeedback.Weight = { fatalError() }()

        /// Indicates a collision between medium-sized or medium-weight UI
        /// objects.
        public static let medium: SensoryFeedback.Weight = { fatalError() }()

        /// Indicates a collision between large or heavyweight UI objects.
        public static let heavy: SensoryFeedback.Weight = { fatalError() }()

        public static func == (a: SensoryFeedback.Weight, b: SensoryFeedback.Weight) -> Bool { fatalError() }
    }

    /// The flexibility to be represented by a type of feedback.
    ///
    /// `Flexibility` values can be passed to
    /// `SensoryFeedback.impact(flexibility:intensity:)`.
    public struct Flexibility : Equatable, Sendable {

        /// Indicates a collision between hard or inflexible UI objects.
        public static let rigid: SensoryFeedback.Flexibility = { fatalError() }()

        /// Indicates a collision between solid UI objects of medium
        /// flexibility.
        public static let solid: SensoryFeedback.Flexibility = { fatalError() }()

        /// Indicates a collision between soft or flexible UI objects.
        public static let soft: SensoryFeedback.Flexibility = { fatalError() }()

        public static func == (a: SensoryFeedback.Flexibility, b: SensoryFeedback.Flexibility) -> Bool { fatalError() }
    }

    public static func == (a: SensoryFeedback, b: SensoryFeedback) -> Bool { fatalError() }
}

/// A style to use when rendering shadows.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ShadowStyle : Equatable, Sendable {

    /// Creates a custom drop shadow style.
    ///
    /// Drop shadows draw behind the source content by blurring,
    /// tinting and offsetting its per-pixel alpha values.
    ///
    /// - Parameters:
    ///   - color: The shadow's color.
    ///   - radius: The shadow's size.
    ///   - x: A horizontal offset you use to position the shadow
    ///     relative to this view.
    ///   - y: A vertical offset you use to position the shadow
    ///     relative to this view.
    ///
    /// - Returns: A new shadow style.
    public static func drop(color: Color = .init(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> ShadowStyle { fatalError() }

    /// Creates a custom inner shadow style.
    ///
    /// Inner shadows draw on top of the source content by blurring,
    /// tinting, inverting and offsetting its per-pixel alpha values.
    ///
    /// - Parameters:
    ///   - color: The shadow's color.
    ///   - radius: The shadow's size.
    ///   - x: A horizontal offset you use to position the shadow
    ///     relative to this view.
    ///   - y: A vertical offset you use to position the shadow
    ///     relative to this view.
    ///
    /// - Returns: A new shadow style.
    public static func inner(color: Color = .init(.sRGBLinear, white: 0, opacity: 0.55), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> ShadowStyle { fatalError() }

    public static func == (a: ShadowStyle, b: ShadowStyle) -> Bool { fatalError() }
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

/// The standard sizes of sidebar rows.
///
/// On macOS, sidebar rows have three different sizes: small, medium, and large.
/// The size is primarily controlled by the current users' "Sidebar Icon Size"
/// in Appearance settings, and applies to all applications.
///
/// On all other platforms, the only supported sidebar size is `.medium`.
///
/// This size can be read or written in the environment using
/// `EnvironmentValues.sidebarRowSize`.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public enum SidebarRowSize : Sendable {

    /// The standard "small" row size
    case small

    /// The standard "medium" row size
    case medium

    /// The standard "large" row size
    case large

    public static func == (a: SidebarRowSize, b: SidebarRowSize) -> Bool { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SidebarRowSize : Hashable {

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// A navigation view style represented by a view stack that only shows a
/// single top view at a time.
///
/// You can also use ``NavigationViewStyle/stack`` to construct this style.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
@available(macOS, unavailable)
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
@available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
public struct StackNavigationViewStyle : NavigationViewStyle {

    public init() { fatalError() }
}

/// The characteristics of a stroke that traces a path.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct StrokeStyle : Equatable {

    /// The width of the stroked path.
    public var lineWidth: CGFloat { get { fatalError() } }

    /// The endpoint style of a line.
    public var lineCap: CGLineCap { get { fatalError() } }

    /// The join type of a line.
    public var lineJoin: CGLineJoin { get { fatalError() } }

    /// A threshold used to determine whether to use a bevel instead of a
    /// miter at a join.
    public var miterLimit: CGFloat { get { fatalError() } }

    /// The lengths of painted and unpainted segments used to make a dashed line.
    public var dash: [CGFloat]

    /// How far into the dash pattern the line starts.
    public var dashPhase: CGFloat { get { fatalError() } }

    /// Creates a new stroke style from the given components.
    ///
    /// - Parameters:
    ///   - lineWidth: The width of the segment.
    ///   - lineCap: The endpoint style of a segment.
    ///   - lineJoin: The join type of a segment.
    ///   - miterLimit: The threshold used to determine whether to use a bevel
    ///     instead of a miter at a join.
    ///   - dash: The lengths of painted and unpainted segments used to make a
    ///     dashed line.
    ///   - dashPhase: How far into the dash pattern the line starts.
    public init(lineWidth: CGFloat = 1, lineCap: CGLineCap = .butt, lineJoin: CGLineJoin = .miter, miterLimit: CGFloat = 10, dash: [CGFloat] = [CGFloat](), dashPhase: CGFloat = 0) { fatalError() }

    public static func == (a: StrokeStyle, b: StrokeStyle) -> Bool { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension StrokeStyle : Sendable {
}

/// A semantic label describing the label of submission within a view hierarchy.
///
/// A submit label is a description of a submission action provided to a
/// view hierarchy using the ``View/onSubmit(of:_:)`` modifier.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SubmitLabel : Sendable {

    /// Defines a submit label with text of "Done".
    public static var done: SubmitLabel { get { fatalError() } }

    /// Defines a submit label with text of "Go".
    public static var go: SubmitLabel { get { fatalError() } }

    /// Defines a submit label with text of "Send".
    public static var send: SubmitLabel { get { fatalError() } }

    /// Defines a submit label with text of "Join".
    public static var join: SubmitLabel { get { fatalError() } }

    /// Defines a submit label with text of "Route".
    public static var route: SubmitLabel { get { fatalError() } }

    /// Defines a submit label with text of "Search".
    public static var search: SubmitLabel { get { fatalError() } }

    /// Defines a submit label with text of "Return".
    public static var `return`: SubmitLabel { get { fatalError() } }

    /// Defines a submit label with text of "Next".
    public static var next: SubmitLabel { get { fatalError() } }

    /// Defines a submit label with text of "Continue".
    public static var `continue`: SubmitLabel { get { fatalError() } }
}

/// A type that defines various triggers that result in the firing of a
/// submission action.
///
/// These triggers may be provided to the ``View/onSubmit(of:_:)``
/// modifier to alter which types of user behaviors trigger a provided
/// submission action.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SubmitTriggers : OptionSet, Sendable {

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public let rawValue: SubmitTriggers.RawValue = { fatalError() }()

    /// Creates a set of submit triggers.
    public init(rawValue: SubmitTriggers.RawValue) { fatalError() }

    /// Defines triggers originating from text input controls like `TextField`
    /// and `SecureField`.
    public static let text: SubmitTriggers = { fatalError() }()

    /// Defines triggers originating from search fields constructed from
    /// searchable modifiers.
    ///
    /// In the example below, only the search field or search completions
    /// placed by the searchable modifier will trigger the view model to submit
    /// its current search query.
    ///
    ///     @StateObject private var viewModel = ViewModel()
    ///
    ///     NavigationView {
    ///         SidebarView()
    ///         DetailView()
    ///     }
    ///     .searchable(
    ///         text: $viewModel.searchText,
    ///         placement: .sidebar
    ///     ) {
    ///         SuggestionsView()
    ///     }
    ///     .onSubmit(of: .search) {
    ///         viewModel.submitCurrentSearchQuery()
    ///     }
    ///
    public static let search: SubmitTriggers = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = SubmitTriggers

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = SubmitTriggers
}

/// A toggle style that displays a leading label and a trailing switch.
///
/// Use the ``ToggleStyle/switch`` static variable to create this style:
///
///     Toggle("Enhance Sound", isOn: $isEnhanced)
///         .toggleStyle(.switch)
///
@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
public struct SwitchToggleStyle : ToggleStyle {

    /// Creates a switch toggle style.
    ///
    /// Don't call this initializer directly. Instead, use the
    /// ``ToggleStyle/switch`` static variable to create this style:
    ///
    ///     Toggle("Enhance Sound", isOn: $isEnhanced)
    ///         .toggleStyle(.switch)
    ///
    public init() { fatalError() }

    /// Creates a switch style with a tint color.
    @available(iOS, introduced: 14.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    @available(macOS, introduced: 11.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    @available(tvOS, unavailable)
    @available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    public init(tint: Color) { fatalError() }

    /// Creates a view that represents the body of a toggle switch.
    ///
    /// SkipUI implements this required method of the ``ToggleStyle``
    /// protocol to define the behavior and appearance of the
    /// ``ToggleStyle/switch`` toggle style. Don't call this method
    /// directly. Rather, the system calls this method for each
    /// ``Toggle`` instance in a view hierarchy that's styled as
    /// a switch.
    ///
    /// - Parameter configuration: The properties of the toggle, including a
    ///   label and a binding to the toggle's state.
    /// - Returns: A view that represents a switch.
    public func makeBody(configuration: SwitchToggleStyle.Configuration) -> some View { return never() }


    /// A view that represents the appearance and interaction of a toggle.
    ///
    /// SkipUI infers this type automatically based on the ``View``
    /// instance that you return from your implementation of the
    /// ``makeBody(configuration:)`` method.
//    public typealias Body = some View
}

/// A label style that only displays the title of the label.
///
/// You can also use ``LabelStyle/titleOnly`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct TitleOnlyLabelStyle : LabelStyle {

    /// Creates a title-only label style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a label.
    ///
    /// The system calls this method for each ``Label`` instance in a view
    /// hierarchy where this style is the current label style.
    ///
    /// - Parameter configuration: The properties of the label.
    public func makeBody(configuration: TitleOnlyLabelStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a label.
//    public typealias Body = some View
}

/// A View created from a swift tuple of View values.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct TupleView<T> : View {

    public var value: T { get { fatalError() } }

    @inlinable public init(_ value: T) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

/// Defines how typesetting language is determined for text.
///
/// Use ``View/typesettingLanguage(_:isEnabled:)`` or
/// ``Text/typesettingLanguage(_:isEnabled:)`` to specify
/// the typesetting language .
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct TypesettingLanguage : Sendable, Equatable {

    /// Automatic language behavior.
    ///
    /// When determining the language to use for typesetting the current UI
    /// language and preferred languages will be considiered. For example, if
    /// the current UI locale is for English and Thai is included in the
    /// preferred languages then line heights will be taller to accommodate the
    /// taller glyphs used by Thai.
    public static let automatic: TypesettingLanguage = { fatalError() }()

    /// Use explicit language.
    ///
    /// An explicit language will be used for typesetting. For example, if used
    /// with Thai language the line heights will be as tall as needed to
    /// accommodate Thai.
    ///
    /// - Parameters:
    ///   - language: The language to use for typesetting.
    /// - Returns: A `TypesettingLanguage`.
    public static func explicit(_ language: Locale.Language) -> TypesettingLanguage { fatalError() }

    public static func == (a: TypesettingLanguage, b: TypesettingLanguage) -> Bool { fatalError() }
}

/// A  function defined by a two-dimensional curve that maps an input
/// progress in the range [0,1] to an output progress that is also in the
/// range [0,1]. By changing the shape of the curve, the effective speed
/// of an animation or other interpolation can be changed.
///
/// The horizontal (x) axis defines the input progress: a single input
/// progress value in the range [0,1] must be provided when evaluating a
/// curve.
///
/// The vertical (y) axis maps to the output progress: when a curve is
/// evaluated, the y component of the point that intersects the input progress
/// is returned.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct UnitCurve {

    /// Creates a new curve using bezier control points.
    ///
    /// The x components of the control points are clamped to the range [0,1] when
    /// the curve is evaluated.
    ///
    /// - Parameters:
    ///   - startControlPoint: The cubic Bézier control point associated with
    ///     the curve's start point at (0, 0). The tangent vector from the
    ///     start point to its control point defines the initial velocity of
    ///     the timing function.
    ///   - endControlPoint: The cubic Bézier control point associated with the
    ///     curve's end point at (1, 1). The tangent vector from the end point
    ///     to its control point defines the final velocity of the timing
    ///     function.
    public static func bezier(startControlPoint: UnitPoint, endControlPoint: UnitPoint) -> UnitCurve { fatalError() }

    /// Returns the output value (y component) of the curve at the given time.
    ///
    /// - Parameters:
    ///   - time: The input progress (x component). The provided value is
    ///     clamped to the range [0,1].
    ///
    /// - Returns: The output value (y component) of the curve at the given
    ///   progress.
    public func value(at progress: Double) -> Double { fatalError() }

    /// Returns the rate of change (first derivative) of the output value of
    /// the curve at the given time.
    ///
    /// - Parameters:
    ///   - progress: The input progress (x component). The provided value is
    ///     clamped to the range [0,1].
    ///
    /// - Returns: The velocity of the output value (y component) of the curve
    ///   at the given time.
    public func velocity(at progress: Double) -> Double { fatalError() }

    /// Returns a copy of the curve with its x and y components swapped.
    ///
    /// The inverse can be used to solve a curve in reverse: given a
    /// known output (y) value, the corresponding input (x) value can be found
    /// by using `inverse`:
    ///
    ///     let curve = UnitCurve.easeInOut
    ///
    ///     /// The input time for which an easeInOut curve returns 0.6.
    ///     let inputTime = curve.inverse.evaluate(at: 0.6)
    ///
    public var inverse: UnitCurve { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension UnitCurve : Sendable {
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension UnitCurve : Hashable {

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (a: UnitCurve, b: UnitCurve) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension UnitCurve {

    /// A bezier curve that starts out slowly, speeds up over the middle, then
    /// slows down again as it approaches the end.
    ///
    /// The start and end control points are located at (x: 0.42, y: 0) and
    /// (x: 0.58, y: 1).
    @available(*, deprecated, message: "Use easeInOut instead")
    public static let easeInEaseOut: UnitCurve = { fatalError() }()

    /// A bezier curve that starts out slowly, speeds up over the middle, then
    /// slows down again as it approaches the end.
    ///
    /// The start and end control points are located at (x: 0.42, y: 0) and
    /// (x: 0.58, y: 1).
    public static let easeInOut: UnitCurve = { fatalError() }()

    /// A bezier curve that starts out slowly, then speeds up as it finishes.
    ///
    /// The start and end control points are located at (x: 0.42, y: 0) and
    /// (x: 1, y: 1).
    public static let easeIn: UnitCurve = { fatalError() }()

    /// A bezier curve that starts out quickly, then slows down as it
    /// approaches the end.
    ///
    /// The start and end control points are located at (x: 0, y: 0) and
    /// (x: 0.58, y: 1).
    public static let easeOut: UnitCurve = { fatalError() }()

    /// A curve that starts out slowly, then speeds up as it finishes.
    ///
    /// The shape of the curve is equal to the fourth (bottom right) quadrant
    /// of a unit circle.
    public static let circularEaseIn: UnitCurve = { fatalError() }()

    /// A circular curve that starts out quickly, then slows down as it
    /// approaches the end.
    ///
    /// The shape of the curve is equal to the second (top left) quadrant of
    /// a unit circle.
    public static let circularEaseOut: UnitCurve = { fatalError() }()

    /// A circular curve that starts out slowly, speeds up over the middle,
    /// then slows down again as it approaches the end.
    ///
    /// The shape of the curve is defined by a piecewise combination of
    /// `circularEaseIn` and `circularEaseOut`.
    public static let circularEaseInOut: UnitCurve = { fatalError() }()

    /// A linear curve.
    ///
    /// As the linear curve is a straight line from (0, 0) to (1, 1),
    /// the output progress is always equal to the input progress, and
    /// the velocity is always equal to 1.0.
    public static let linear: UnitCurve = { fatalError() }()
}

/// A normalized 2D point in a view's coordinate space.
///
/// Use a unit point to represent a location in a view without having to know
/// the view's rendered size. The point stores a value in each dimension that
/// indicates the fraction of the view's size in that dimension --- measured
/// from the view's origin --- where the point appears. For example, you can
/// create a unit point that represents the center of any view by using the
/// value `0.5` for each dimension:
///
///     let unitPoint = UnitPoint(x: 0.5, y: 0.5)
///
/// To project the unit point into the rendered view's coordinate space,
/// multiply each component of the unit point with the corresponding
/// component of the view's size:
///
///     let projectedPoint = CGPoint(
///         x: unitPoint.x * size.width,
///         y: unitPoint.y * size.height
///     )
///
/// You can perform this calculation yourself if you happen to know a view's
/// size, or if you want to use the unit point for some custom purpose, but
/// SkipUI typically does this for you to carry out operations that
/// you request, like when you:
///
/// * Transform a shape using a shape modifier. For example, to rotate a
///   shape with ``Shape/rotation(_:anchor:)``, you indicate an anchor point
///   that you want to rotate the shape around.
/// * Override the alignment of the view in a ``Grid`` cell using the
///   ``View/gridCellAnchor(_:)`` view modifier. The grid aligns the projection
///   of a unit point onto the view with the projection of the same unit point
///   onto the cell.
/// * Create a gradient that has a center, or start and stop points, relative
///   to the shape that you are styling. See the gradient methods in
///   ``ShapeStyle``.
///
/// You can create custom unit points with explicit values, like the example
/// above, or you can use one of the built-in unit points that SkipUI provides,
/// like ``zero``, ``center``, or ``topTrailing``. The built-in values
/// correspond to the alignment positions of the similarly named, built-in
/// ``Alignment`` types.
///
/// > Note: A unit point with one or more components outside the range `[0, 1]`
/// projects to a point outside of the view.
///
/// ### Layout direction
///
/// When a person configures their device to use a left-to-right language like
/// English, the system places the view's origin in its top-left corner,
/// with positive x toward the right and positive y toward the bottom of the
/// view. In a right-to-left environment, the origin moves to the upper-right
/// corner, and the positive x direction changes to be toward the left. You
/// don't typically need to do anything to handle this change, because SkipUI
/// applies the change to all aspects of the system. For example, see the
/// discussion about layout direction in ``HorizontalAlignment``.
///
/// It’s important to test your app for the different locales that you
/// distribute your app in. For more information about the localization process,
/// see .
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct UnitPoint : Hashable {

    /// The normalized distance from the origin to the point in the horizontal
    /// direction.
    public var x: CGFloat { get { fatalError() } }

    /// The normalized distance from the origin to the point in the vertical
    /// dimension.
    public var y: CGFloat { get { fatalError() } }

    /// Creates a unit point at the origin.
    ///
    /// A view's origin appears in the top-left corner in a left-to-right
    /// language environment, with positive x toward the right. It appears in
    /// the top-right corner in a right-to-left language, with positive x toward
    /// the left. Positive y is always toward the bottom of the view.
    @inlinable public init() { fatalError() }

    /// Creates a unit point with the specified horizontal and vertical offsets.
    ///
    /// Values outside the range `[0, 1]` project to points outside of a view.
    ///
    /// - Parameters:
    ///   - x: The normalized distance from the origin to the point in the
    ///     horizontal direction.
    ///   - y: The normalized distance from the origin to the point in the
    ///     vertical direction.
    @inlinable public init(x: CGFloat, y: CGFloat) { fatalError() }

    /// The origin of a view.
    ///
    /// A view's origin appears in the top-left corner in a left-to-right
    /// language environment, with positive x toward the right. It appears in
    /// the top-right corner in a right-to-left language, with positive x toward
    /// the left. Positive y is always toward the bottom of the view.
    public static let zero: UnitPoint = { fatalError() }()

    /// A point that's centered in a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/center`` alignment.
    public static let center: UnitPoint = { fatalError() }()

    /// A point that's centered vertically on the leading edge of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/leading`` alignment.
    /// The leading edge appears on the left in a left-to-right language
    /// environment and on the right in a right-to-left environment.
    public static let leading: UnitPoint = { fatalError() }()

    /// A point that's centered vertically on the trailing edge of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/trailing`` alignment.
    /// The trailing edge appears on the right in a left-to-right language
    /// environment and on the left in a right-to-left environment.
    public static let trailing: UnitPoint = { fatalError() }()

    /// A point that's centered horizontally on the top edge of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/top`` alignment.
    public static let top: UnitPoint = { fatalError() }()

    /// A point that's centered horizontally on the bottom edge of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/bottom`` alignment.
    public static let bottom: UnitPoint = { fatalError() }()

    /// A point that's in the top, leading corner of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/topLeading`` alignment.
    /// The leading edge appears on the left in a left-to-right language
    /// environment and on the right in a right-to-left environment.
    public static let topLeading: UnitPoint = { fatalError() }()

    /// A point that's in the top, trailing corner of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/topTrailing`` alignment.
    /// The trailing edge appears on the right in a left-to-right language
    /// environment and on the left in a right-to-left environment.
    public static let topTrailing: UnitPoint = { fatalError() }()

    /// A point that's in the bottom, leading corner of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/bottomLeading`` alignment.
    /// The leading edge appears on the left in a left-to-right language
    /// environment and on the right in a right-to-left environment.
    public static let bottomLeading: UnitPoint = { fatalError() }()

    /// A point that's in the bottom, trailing corner of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/bottomTrailing`` alignment.
    /// The trailing edge appears on the right in a left-to-right language
    /// environment and on the left in a right-to-left environment.
    public static let bottomTrailing: UnitPoint = { fatalError() }()

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (a: UnitPoint, b: UnitPoint) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension UnitPoint : Sendable {
}

/// A set of values that indicate the visual size available to the view.
///
/// You receive a size class value when you read either the
/// ``EnvironmentValues/horizontalSizeClass`` or
/// ``EnvironmentValues/verticalSizeClass`` environment value. The value tells
/// you about the amount of space available to your views in a given
/// direction. You can read the size class like any other of the
/// ``EnvironmentValues``, by creating a property with the ``Environment``
/// property wrapper:
///
///     @Environment(\.horizontalSizeClass) private var horizontalSizeClass
///     @Environment(\.verticalSizeClass) private var verticalSizeClass
///
/// SkipUI sets the size class based on several factors, including:
///
/// * The current device type.
/// * The orientation of the device.
/// * The appearance of Slide Over and Split View on iPad.
///
/// Several built-in views change their behavior based on the size class.
/// For example, a ``NavigationView`` presents a multicolumn view when
/// the horizontal size class is ``UserInterfaceSizeClass/regular``,
/// but a single column otherwise. You can also adjust the appearance of
/// custom views by reading the size class and conditioning your views.
/// If you do, be prepared to handle size class changes while
/// your app runs, because factors like device orientation can change at
/// runtime.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum UserInterfaceSizeClass : Sendable {

    /// The compact size class.
    case compact

    /// The regular size class.
    case regular

    public static func == (a: UserInterfaceSizeClass, b: UserInterfaceSizeClass) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension UserInterfaceSizeClass : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension UserInterfaceSizeClass : Hashable {
}

/// The scroll behavior that aligns scroll targets to view-based geometry.
///
/// You use this behavior when a scroll view should always align its
/// scroll targets to a rectangle that's aligned to the geometry of a view. In
/// the following example, the scroll view always picks an item view
/// to settle on.
///
///     ScrollView(.horizontal) {
///         LazyHStack(spacing: 10.0) {
///             ForEach(items) { item in
///               ItemView(item)
///             }
///         }
///         .scrollTargetLayout()
///     }
///     .scrollTargetBehavior(.viewAligned)
///     .padding(.horizontal, 20.0)
///
/// You configure which views should be used for settling using the
/// ``View/scrollTargetLayout()`` modifier. Apply this modifier to a
/// layout container like ``LazyVStack`` or ``HStack`` and each individual
/// view in that layout will be considered for alignment.
///
/// You can also associate invidiual views for alignment using the
/// ``View/scrollTarget()`` modifier.
///
///     ScrollView {
///         HeaderView()
///             .scrollTarget()
///
///         LazyVStack {
///             // other content...
///         }
///         .scrollTargetLayout()
///     }
///     .scrollTargetBehavior(.viewAligned)
///
/// You can customize whether the view aligned behavior limits the
/// number of views that can be scrolled at a time by using the
/// ``ViewAlignedScrollTargetBehavior.LimitBehavior`` type. Provide a value of
/// ``ViewAlignedScrollTargetBehavior.LimitBehavior/always`` to always have
/// the behavior only allow a few views to be scrolled at a time.
///
/// By default, the view aligned behavior will limit the number of views
/// it scrolls when in a compact horizontal size class when scrollable
/// in the horizontal axis, when in a compact vertical size class when
/// scrollable in the vertical axis, and otherwise does not impose any
/// limit on the number of views that can be scrolled.
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ViewAlignedScrollTargetBehavior : ScrollTargetBehavior {

    /// A type that defines the amount of views that can be scrolled at a time.
    public struct LimitBehavior {

        /// The automatic limit behavior.
        ///
        /// By default, the behavior will be limited in compact horizontal
        /// size classes and will not be limited otherwise.
        public static var automatic: ViewAlignedScrollTargetBehavior.LimitBehavior { get { fatalError() } }

        /// The always limit behavior.
        ///
        /// Always limit the amount of views that can be scrolled.
        public static var always: ViewAlignedScrollTargetBehavior.LimitBehavior { get { fatalError() } }

        /// The never limit behavior.
        ///
        /// Never limit the amount of views that can be scrolled.
        public static var never: ViewAlignedScrollTargetBehavior.LimitBehavior { get { fatalError() } }
    }

    /// Creates a view aligned scroll behavior.
    public init(limitBehavior: ViewAlignedScrollTargetBehavior.LimitBehavior = .automatic) { fatalError() }

    /// Updates the proposed target that a scrollable view should scroll to.
    ///
    /// The system calls this method in two main cases:
    /// - When a scroll gesture ends, it calculates where it would naturally
    ///   scroll to using its deceleration rate. The system
    ///   provides this calculated value as the target of this method.
    /// - When a scrollable view's size changes, it calculates where it should
    ///   be scrolled given the new size and provides this calculates value
    ///   as the target of this method.
    ///
    /// You can implement this method to override the calculated target
    /// which will have the scrollable view scroll to a different position
    /// than it would otherwise.
    public func updateTarget(_ target: inout ScrollTarget, context: ViewAlignedScrollTargetBehavior.TargetContext) { fatalError() }
}

/// for each of the top, bottom, leading, and trailing edges,
/// and can also record different values for different kinds of adjacent
/// views. For example, it might contain one value for the spacing to the next
/// text view along the top and bottom edges, other values for the spacing to
/// text views on other edges, and yet other values for other kinds of views.
/// Spacing preferences can also vary by platform.
///
/// Your ``Layout`` type doesn't have to take preferred spacing into
/// account, but if it does, you can use the ``LayoutSubview/spacing``
/// preferences of the subviews in your layout container to:
///
/// * Add space between subviews when you implement the
///   ``Layout/placeSubviews(in:proposal:subviews:cache:)`` method.
/// * Create a spacing preferences instance for the container view by
///   implementing the ``Layout/spacing(subviews:cache:)-86z2e`` method.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ViewSpacing : Sendable {

    /// A view spacing instance that contains zero on all edges.
    ///
    /// You typically only use this value for an empty view.
    public static let zero: ViewSpacing = { fatalError() }()

    /// Initializes an instance with default spacing values.
    ///
    /// Use this initializer to create a spacing preferences instance with
    /// default values. Then use ``formUnion(_:edges:)`` to combine
    /// preferences from other views with the new instance. You typically
    /// do this in a custom layout's implementation of the
    /// ``Layout/spacing(subviews:cache:)-86z2e`` method.
    public init() { fatalError() }

    /// Merges the spacing preferences of another spacing instance with this
    /// instance for a specified set of edges.
    ///
    /// When you merge another spacing preference instance with this one,
    /// this instance ends up with the greater of its original value or the
    /// other instance's value for each of the specified edges.
    /// You can call the method repeatedly with each value in a collection to
    /// merge a collection of preferences. The result has the smallest
    /// preferences on each edge that meets the largest requirements of all
    /// the inputs for that edge.
    ///
    /// If you want to merge preferences without modifying the original
    /// instance, use ``union(_:edges:)`` instead.
    ///
    /// - Parameters:
    ///   - other: Another spacing preferences instances to merge with this one.
    ///   - edges: The edges to merge. Edges that you don't specify are
    ///     unchanged after the method completes.
    public mutating func formUnion(_ other: ViewSpacing, edges: Edge.Set = .all) { fatalError() }

    /// Gets a new value that merges the spacing preferences of another spacing
    /// instance with this instance for a specified set of edges.
    ///
    /// This method behaves like ``formUnion(_:edges:)``, except that it creates
    /// a copy of the original spacing preferences instance before merging,
    /// leaving the original instance unmodified.
    ///
    /// - Parameters:
    ///   - other: Another spacing preferences instance to merge with this one.
    ///   - edges: The edges to merge. Edges that you don't specify are
    ///     unchanged after the method completes.
    ///
    /// - Returns: A new view spacing preferences instance with the merged
    ///   values.
    public func union(_ other: ViewSpacing, edges: Edge.Set = .all) -> ViewSpacing { fatalError() }

    /// Gets the preferred spacing distance along the specified axis to the view
    /// that returns a specified spacing preference.
    ///
    /// Call this method from your implementation of ``Layout`` protocol
    /// methods if you need to measure the default spacing between two
    /// views in a custom layout. Call the method on the first view's
    /// preferences instance, and provide the second view's preferences
    /// instance as input.
    ///
    /// For example, consider two views that appear in a custom horizontal
    /// stack. The following distance call gets the preferred spacing between
    /// these views, where `spacing1` contains the preferences of a first
    /// view, and `spacing2` contains the preferences of a second view:
    ///
    ///     let distance = spacing1.distance(to: spacing2, axis: .horizontal)
    ///
    /// The method first determines, based on the axis and the ordering, that
    /// the views abut on the trailing edge of the first view and the leading
    /// edge of the second. It then gets the spacing preferences for the
    /// corresponding edges of each view, and returns the greater of the two
    /// values. This results in the smallest value that provides enough space
    /// to satisfy the preferences of both views.
    ///
    /// > Note: This method returns the default spacing between views, but a
    /// layout can choose to ignore the value and use custom spacing instead.
    ///
    /// - Parameters:
    ///   - next: The spacing preferences instance of the adjacent view.
    ///   - axis: The axis that the two views align on.
    ///
    /// - Returns: A floating point value that represents the smallest distance
    ///   in points between two views that satisfies the spacing preferences
    ///   of both this view and the adjacent views on their shared edge.
    public func distance(to next: ViewSpacing, along axis: Axis) -> CGFloat { fatalError() }
}

/// A view that adapts to the available space by providing the first
/// child view that fits.
///
/// `ViewThatFits` evaluates its child views in the order you provide them
/// to the initializer. It selects the first child whose ideal size on the
/// constrained axes fits within the proposed size. This means that you
/// provide views in order of preference. Usually this order is largest to
/// smallest, but since a view might fit along one constrained axis but not the
/// other, this isn't always the case. By default, `ViewThatFits` constrains
/// in both the horizontal and vertical axes.
///
/// The following example shows an `UploadProgressView` that uses `ViewThatFits`
/// to display the upload progress in one of three ways. In order, it attempts
/// to display:
///
/// * An ``HStack`` that contains a ``Text`` view and a ``ProgressView``.
/// * Only the `ProgressView`.
/// * Only the `Text` view.
///
/// The progress views are fixed to a 100-point width.
///
///     struct UploadProgressView: View {
///         var uploadProgress: Double
///
///         var body: some View {
///             ViewThatFits(in: .horizontal) {
///                 HStack {
///                     Text("\(uploadProgress.formatted(.percent))")
///                     ProgressView(value: uploadProgress)
///                         .frame(width: 100)
///                 }
///                 ProgressView(value: uploadProgress)
///                     .frame(width: 100)
///                 Text("\(uploadProgress.formatted(.percent))")
///             }
///         }
///     }
///
/// This use of `ViewThatFits` evaluates sizes only on the horizontal axis. The
/// following code fits the `UploadProgressView` to several fixed widths:
///
///     VStack {
///         UploadProgressView(uploadProgress: 0.75)
///             .frame(maxWidth: 200)
///         UploadProgressView(uploadProgress: 0.75)
///             .frame(maxWidth: 100)
///         UploadProgressView(uploadProgress: 0.75)
///             .frame(maxWidth: 50)
///     }
///
/// ![A vertical stack showing three expressions of progress, constrained by
/// the available horizontal space. The first line shows the text, 75%, and a
/// three-quarters-full progress bar. The second line shows only the progress
/// view. The third line shows only the text.](ViewThatFits-1)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct ViewThatFits<Content> : View where Content : View {

    /// Produces a view constrained in the given axes from one of several
    /// alternatives provided by a view builder.
    ///
    /// - Parameters:
    ///     - axes: A set of axes to constrain children to. The set may
    ///       contain ``Axis/horizontal``, ``Axis/vertical``, or both of these.
    ///       `ViewThatFits` chooses the first child whose size fits within the
    ///       proposed size on these axes. If `axes` is an empty set,
    ///       `ViewThatFits` uses the first child view. By default,
    ///       `ViewThatFits` uses both axes.
    ///     - content: A view builder that provides the child views for this
    ///       container, in order of preference. The builder chooses the first
    ///       child view that fits within the proposed width, height, or both,
    ///       as defined by `axes`.
    @inlinable public init(in axes: Axis.Set = [.horizontal, .vertical], @ViewBuilder content: () -> Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

/// The visibility of a UI element, chosen automatically based on
/// the platform, current context, and other factors.
///
/// For example, the preferred visibility of list row separators can be
/// configured using the ``View/listRowSeparator(_:edges:)``.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@frozen public enum Visibility : Hashable, CaseIterable {

    /// The element may be visible or hidden depending on the policies of the
    /// component accepting the visibility configuration.
    ///
    /// For example, some components employ different automatic behavior
    /// depending on factors including the platform, the surrounding container,
    /// user settings, etc.
    case automatic

    /// The element may be visible.
    ///
    /// Some APIs may use this value to represent a hint or preference, rather
    /// than a mandatory assertion. For example, setting list row separator
    /// visibility to `visible` using the
    /// ``View/listRowSeparator(_:edges:)`` modifier may not always
    /// result in any visible separators, especially for list styles that do not
    /// include separators as part of their design.
    case visible

    /// The element may be hidden.
    ///
    /// Some APIs may use this value to represent a hint or preference, rather
    /// than a mandatory assertion. For example, setting confirmation dialog
    /// title visibility to `hidden` using the
    /// ``View/confirmationDialog(_:isPresented:titleVisibility:actions:)-87n66``
    /// modifier may not always hide the dialog title, which is required on
    /// some platforms.
    case hidden

    public static func == (a: Visibility, b: Visibility) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [Visibility]

    /// A collection of all values of this type.
    public static var allCases: [Visibility] { get { fatalError() } }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Visibility : Sendable {
}

/// A date picker style that displays each component as columns in a scrollable
/// wheel.
///
/// You can also use ``DatePickerStyle/wheel`` to construct this style.
@available(iOS 13.0, watchOS 10.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
public struct WheelDatePickerStyle : DatePickerStyle {

    /// Creates an instance of the wheel date picker style.
    public init() { fatalError() }

    /// Returns the appearance and interaction content for a `DatePicker`.
    ///
    /// The system calls this method for each ``DatePicker`` instance in a view
    /// hierarchy where this style is the current date picker style.
    ///
    /// - Parameter configuration : The properties of the date picker.
    @available(iOS 16.0, watchOS 10.0, *)
    public func makeBody(configuration: WheelDatePickerStyle.Configuration) -> Body { return never() }


    /// A view representing the appearance and interaction of a `DatePicker`.
    public typealias Body = Never
}

/// A picker style that presents the options in a scrollable wheel that shows
/// the selected option and a few neighboring options.
///
/// You can also use ``PickerStyle/wheel`` to construct this style.
@available(iOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
public struct WheelPickerStyle : PickerStyle {

    /// Sets the picker style to display an item wheel from which the user makes
    /// a selection.
    public init() { fatalError() }
}


@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Optional : ToolbarContent where Wrapped : ToolbarContent {

    /// The type of content representing the body of this toolbar content.
    public typealias Body = Never
    public var body: Never { return never() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Optional : CustomizableToolbarContent where Wrapped : CustomizableToolbarContent {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Never {

    /// The type for the internal content of this `AccessibilityRotorContent`.
    public typealias Body = Never

    /// The internal content of this `AccessibilityRotorContent`.
    public var body: Never { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGPoint {

    public func applying(_ m: ProjectionTransform) -> CGPoint { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Never : AccessibilityRotorContent {
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Never : TableColumnContent {

    /// The type of sort comparator associated with this table column content.
    public typealias TableColumnSortComparator = Never

    /// The type of content representing the body of this table column content.
    public typealias TableColumnBody = Never

    /// The composition of content that comprise the table column content.
    public var tableColumnBody: Never { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Never : ToolbarContent, CustomizableToolbarContent {
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Never : Scene {
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension Never : WidgetConfiguration {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Optional : View where Wrapped : View {

    public var body: some View { get { return never() } }
}

//extension Preview {
//
//    /// Creates a preview of a SkipUI view.
//    ///
//    /// The `#Preview` macro expands into a declaration that calls this initializer. To create a preview
//    /// that appears in the canvas, you must use the macro, not instantiate a Preview directly.
//    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//    public init(_ name: String? = nil, traits: PreviewTrait<Preview.ViewTraits>..., body: @escaping () -> View) { fatalError() }
//}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Never : View {
}

extension RangeReplaceableCollection where Self : MutableCollection {

    /// Removes all the elements at the specified offsets from the collection.
    ///
    /// - Complexity: O(*n*) where *n* is the length of the collection.
    ///
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public mutating func remove(atOffsets offsets: IndexSet) { fatalError() }
}

extension MutableCollection {

    /// Moves all the elements at the specified offsets to the specified
    /// destination offset, preserving ordering.
    ///
    /// Pass an offset as `destination` to indicate where in the collection the
    /// moved elements should be inserted. Of the elements that are not
    /// represented by the offsets in `source`, those before `destination` are
    /// moved toward the beginning of the collection to make room for the moved
    /// elements, while those at or after `destination` are moved toward the
    /// end.
    ///
    /// In this example, demonstrating moving several elements to different
    /// destination offsets, `lowercaseOffsets` represents the offsets of the
    /// lowercase elements in `letters`:
    ///
    ///     var letters = Array("ABcDefgHIJKlmNO")
    ///     let lowercaseOffsets = IndexSet(...)
    ///     letters.move(fromOffsets: lowercaseOffsets, toOffset: 2)
    ///     // String(letters) == "ABcefglmDHIJKNO"
    ///
    ///     // Reset the `letters` array.
    ///     letters = Array("ABcDefgHIJKlmNO")
    ///     letters.move(fromOffsets: lowercaseOffsets, toOffset: 15)
    ///     // String(letters) == "ABDHIJKNOcefglm"
    ///
    /// If `source` represents a single element, calling this method with its
    /// own offset, or the offset of the following element, as `destination`
    /// has no effect.
    ///
    ///     letters = Array("ABcDefgHIJKlmNO")
    ///     letters.move(fromOffsets: IndexSet(integer: 2), toOffset: 2)
    ///     // String(letters) == "ABcDefgHIJKlmNO"
    ///
    /// - Parameters:
    ///   - source: An index set representing the offsets of all elements that
    ///     should be moved.
    ///   - destination: The offset of the element before which to insert the
    ///     moved elements. `destination` must be in the closed range
    ///     `0...count`.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the collection.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public mutating func move(fromOffsets source: IndexSet, toOffset destination: Int) { fatalError() }
}

//extension AttributeScopes {
//
//    /// A property for accessing the attribute scopes defined by SkipUI.
//    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
//    public var skipUI: AttributeScopes.SkipUIAttributes.Type { get { fatalError() } }
//
//    /// Attribute scopes defined by SkipUI.
//    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
//    public struct SkipUIAttributes : AttributeScope {
//
//        /// A property for accessing a font attribute.
//        public let font: AttributeScopes.SkipUIAttributes.FontAttribute = { fatalError() }()
//
//        /// A property for accessing a foreground color attribute.
//        public let foregroundColor: AttributeScopes.SkipUIAttributes.ForegroundColorAttribute = { fatalError() }()
//
//        /// A property for accessing a background color attribute.
//        public let backgroundColor: AttributeScopes.SkipUIAttributes.BackgroundColorAttribute = { fatalError() }()
//
//        /// A property for accessing a strikethrough style attribute.
//        public let strikethroughStyle: AttributeScopes.SkipUIAttributes.StrikethroughStyleAttribute = { fatalError() }()
//
//        /// A property for accessing an underline style attribute.
//        public let underlineStyle: AttributeScopes.SkipUIAttributes.UnderlineStyleAttribute = { fatalError() }()
//
//        /// A property for accessing a kerning attribute.
//        public let kern: AttributeScopes.SkipUIAttributes.KerningAttribute = { fatalError() }()
//
//        /// A property for accessing a tracking attribute.
//        public let tracking: AttributeScopes.SkipUIAttributes.TrackingAttribute = { fatalError() }()
//
//        /// A property for accessing a baseline offset attribute.
//        public let baselineOffset: AttributeScopes.SkipUIAttributes.BaselineOffsetAttribute = { fatalError() }()
//
//        /// A property for accessing attributes defined by the Accessibility framework.
//        public let accessibility: AttributeScopes.AccessibilityAttributes = { fatalError() }()
//
//        /// A property for accessing attributes defined by the Foundation framework.
//        public let foundation: AttributeScopes.FoundationAttributes = { fatalError() }()
//
//        public typealias DecodingConfiguration = AttributeScopeCodableConfiguration
//
//        public typealias EncodingConfiguration = AttributeScopeCodableConfiguration
//    }
//}

//@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
//extension AttributeDynamicLookup {
//
//    public subscript<T>(dynamicMember keyPath: KeyPath<AttributeScopes.SkipUIAttributes, T>) -> T where T : AttributedStringKey { get { fatalError() } }
//}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Never : Keyframes {
}

extension Never : Widget {
    public init() {
        fatalError()
    }
    
}

extension Never : DynamicViewContent {
    public typealias Data = [Never]

    /// The collection of underlying data.
    public var data: Self.Data { fatalError() }
}

extension Never : KeyframeTrackContent {
}
