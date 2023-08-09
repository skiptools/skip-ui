// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import protocol Foundation.LocalizedError
import class Foundation.Formatter
import class Foundation.NSObject
import class Foundation.Bundle
import struct Foundation.LocalizedStringResource
import protocol Foundation.FormatStyle
import protocol Foundation.ParseableFormatStyle
import protocol Foundation.ReferenceConvertible
import class Foundation.Progress
import struct Foundation.AttributedString
import enum Foundation.AttributeScopes
import enum Foundation.AttributeDynamicLookup
import protocol Foundation._FormatSpecifiable

import struct UniformTypeIdentifiers.UTType
import struct Foundation.Data
import struct Foundation.URL
import struct Foundation.Date
import struct Foundation.DateComponents
import struct Foundation.DateInterval
import struct Foundation.CharacterSet
import struct Foundation.Locale
import struct Foundation.IndexSet
import typealias Foundation.TimeInterval

import class Accessibility.AXCustomContent
import class Foundation.FileWrapper
import class Foundation.NSItemProvider
import class Foundation.NSUserActivity

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

/// A property wrapper type that supports creating bindings to the mutable
/// properties of observable objects.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@dynamicMemberLookup @propertyWrapper public struct Bindable<Value> {

    /// The wrapped object.
    public var wrappedValue: Value { get { fatalError() } }

    /// The bindable wrapper for the object that creates bindings to its
    /// properties using dynamic member lookup.
    public var projectedValue: Bindable<Value> { get { fatalError() } }

    public init(wrappedValue: Value) { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Bindable where Value : AnyObject {

    /// Returns a binding to the value of a given key path.
    public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>) -> Binding<Subject> { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Bindable : Identifiable where Value : Identifiable {

    /// The stable identity of the entity associated with this instance.
    public var id: Value.ID { get { fatalError() } }

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    public typealias ID = Value.ID
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Bindable : Sendable where Value : Sendable {
}

/// A property wrapper type that can read and write a value owned by a source of
/// truth.
///
/// Use a binding to create a two-way connection between a property that stores
/// data, and a view that displays and changes the data. A binding connects a
/// property to a source of truth stored elsewhere, instead of storing data
/// directly. For example, a button that toggles between play and pause can
/// create a binding to a property of its parent view using the `Binding`
/// property wrapper.
///
///     struct PlayButton: View {
///         @Binding var isPlaying: Bool
///
///         var body: some View {
///             Button(isPlaying ? "Pause" : "Play") {
///                 isPlaying.toggle()
///             }
///         }
///     }
///
/// The parent view declares a property to hold the playing state, using the
/// ``State`` property wrapper to indicate that this property is the value's
/// source of truth.
///
///     struct PlayerView: View {
///         var episode: Episode
///         @State private var isPlaying: Bool = false
///
///         var body: some View {
///             VStack {
///                 Text(episode.title)
///                     .foregroundStyle(isPlaying ? .primary : .secondary)
///                 PlayButton(isPlaying: $isPlaying) // Pass a binding.
///             }
///         }
///     }
///
/// When `PlayerView` initializes `PlayButton`, it passes a binding of its state
/// property into the button's binding property. Applying the `$` prefix to a
/// property wrapped value returns its ``State/projectedValue``, which for a
/// state property wrapper returns a binding to the value.
///
/// Whenever the user taps the `PlayButton`, the `PlayerView` updates its
/// `isPlaying` state.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen @propertyWrapper @dynamicMemberLookup public struct Binding<Value> {

    /// The binding's transaction.
    ///
    /// The transaction captures the information needed to update the view when
    /// the binding value changes.
    public var transaction: Transaction { get { fatalError() } }

    /// Creates a binding with closures that read and write the binding value.
    ///
    /// - Parameters:
    ///   - get: A closure that retrieves the binding value. The closure has no
    ///     parameters, and returns a value.
    ///   - set: A closure that sets the binding value. The closure has the
    ///     following parameter:
    ///       - newValue: The new value of the binding value.
    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) { fatalError() }

    /// Creates a binding with a closure that reads from the binding value, and
    /// a closure that applies a transaction when writing to the binding value.
    ///
    /// - Parameters:
    ///   - get: A closure to retrieve the binding value. The closure has no
    ///     parameters, and returns a value.
    ///   - set: A closure to set the binding value. The closure has the
    ///     following parameters:
    ///       - newValue: The new value of the binding value.
    ///       - transaction: The transaction to apply when setting a new value.
    public init(get: @escaping () -> Value, set: @escaping (Value, Transaction) -> Void) { fatalError() }

    /// Creates a binding with an immutable value.
    ///
    /// Use this method to create a binding to a value that cannot change.
    /// This can be useful when using a ``PreviewProvider`` to see how a view
    /// represents different values.
    ///
    ///     // Example of binding to an immutable value.
    ///     PlayButton(isPlaying: Binding.constant(true))
    ///
    /// - Parameter value: An immutable value.
    public static func constant(_ value: Value) -> Binding<Value> { fatalError() }

    /// The underlying value referenced by the binding variable.
    ///
    /// This property provides primary access to the value's data. However, you
    /// don't access `wrappedValue` directly. Instead, you use the property
    /// variable created with the ``Binding`` attribute. In the
    /// following code example, the binding variable `isPlaying` returns the
    /// value of `wrappedValue`:
    ///
    ///     struct PlayButton: View {
    ///         @Binding var isPlaying: Bool
    ///
    ///         var body: some View {
    ///             Button(isPlaying ? "Pause" : "Play") {
    ///                 isPlaying.toggle()
    ///             }
    ///         }
    ///     }
    ///
    /// When a mutable binding value changes, the new value is immediately
    /// available. However, updates to a view displaying the value happens
    /// asynchronously, so the view may not show the change immediately.
    public var wrappedValue: Value { get { fatalError() } nonmutating set { fatalError() } }

    /// A projection of the binding value that returns a binding.
    ///
    /// Use the projected value to pass a binding value down a view hierarchy.
    /// To get the `projectedValue`, prefix the property variable with `$`. For
    /// example, in the following code example `PlayerView` projects a binding
    /// of the state property `isPlaying` to the `PlayButton` view using
    /// `$isPlaying`.
    ///
    ///     struct PlayerView: View {
    ///         var episode: Episode
    ///         @State private var isPlaying: Bool = false
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                     .foregroundStyle(isPlaying ? .primary : .secondary)
    ///                 PlayButton(isPlaying: $isPlaying)
    ///             }
    ///         }
    ///     }
    ///
    public var projectedValue: Binding<Value> { get { fatalError() } }

    /// Creates a binding from the value of another binding.
    public init(projectedValue: Binding<Value>) { fatalError() }

    /// Returns a binding to the resulting value of a given key path.
    ///
    /// - Parameter keyPath: A key path to a specific resulting value.
    ///
    /// - Returns: A new binding.
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Binding {

    /// Creates a binding by projecting the base value to an optional value.
    ///
    /// - Parameter base: A value to project to an optional value.
    public init<V>(_ base: Binding<V>) where Value == V? { fatalError() }

    /// Creates a binding by projecting the base value to an unwrapped value.
    ///
    /// - Parameter base: A value to project to an unwrapped value.
    ///
    /// - Returns: A new binding or `nil` when `base` is `nil`.
    public init?(_ base: Binding<Value?>) { fatalError() }

    /// Creates a binding by projecting the base value to a hashable value.
    ///
    /// - Parameters:
    ///   - base: A `Hashable` value to project to an `AnyHashable` value.
    public init<V>(_ base: Binding<V>) where Value == AnyHashable, V : Hashable { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : Identifiable where Value : Identifiable {

    /// The stable identity of the entity associated with this instance,
    /// corresponding to the `id` of the binding's wrapped value.
    public var id: Value.ID { get { fatalError() } }

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    public typealias ID = Value.ID
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : Sequence where Value : MutableCollection {

    /// A type representing the sequence's elements.
    public typealias Element = Binding<Value.Element>

    /// A type that provides the sequence's iteration interface and
    /// encapsulates its iteration state.
    public typealias Iterator = IndexingIterator<Binding<Value>>

    /// A collection representing a contiguous subrange of this collection's
    /// elements. The subsequence shares indices with the original collection.
    ///
    /// The default subsequence type for collections that don't define their own
    /// is `Slice`.
    public typealias SubSequence = Slice<Binding<Value>>
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : Collection where Value : MutableCollection {

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public typealias Index = Value.Index

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = Value.Indices

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: Binding<Value>.Index { get { fatalError() } }

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
    public var endIndex: Binding<Value>.Index { get { fatalError() } }

    /// The indices that are valid for subscripting the collection, in ascending
    /// order.
    ///
    /// A collection's `indices` property can hold a strong reference to the
    /// collection itself, causing the collection to be nonuniquely referenced.
    /// If you mutate the collection while iterating over its indices, a strong
    /// reference can result in an unexpected copy of the collection. To avoid
    /// the unexpected copy, use the `index(after:)` method starting with
    /// `startIndex` to produce indices instead.
    ///
    ///     var c = MyFancyCollection([10, 20, 30, 40, 50])
    ///     var i = c.startIndex
    ///     while i != c.endIndex {
    ///         c[i] /= 5
    ///         i = c.index(after: i)
    ///     }
    ///     // c == MyFancyCollection([2, 4, 6, 8, 10])
    public var indices: Value.Indices { get { fatalError() } }

    /// Returns the position immediately after the given index.
    ///
    /// The successor of an index must be well defined. For an index `i` into a
    /// collection `c`, calling `c.index(after: i)` returns the same index every
    /// time.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Binding<Value>.Index) -> Binding<Value>.Index { fatalError() }

    /// Replaces the given index with its successor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    public func formIndex(after i: inout Binding<Value>.Index) { fatalError() }

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
    public subscript(position: Binding<Value>.Index) -> Binding<Value>.Element { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : BidirectionalCollection where Value : BidirectionalCollection, Value : MutableCollection {

    /// Returns the position immediately before the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    /// - Returns: The index value immediately before `i`.
    public func index(before i: Binding<Value>.Index) -> Binding<Value>.Index { fatalError() }

    /// Replaces the given index with its predecessor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    public func formIndex(before i: inout Binding<Value>.Index) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : RandomAccessCollection where Value : MutableCollection, Value : RandomAccessCollection {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Binding {

    /// Specifies a transaction for the binding.
    ///
    /// - Parameter transaction  : An instance of a ``Transaction``.
    ///
    /// - Returns: A new binding.
    public func transaction(_ transaction: Transaction) -> Binding<Value> { fatalError() }

    /// Specifies an animation to perform when the binding value changes.
    ///
    /// - Parameter animation: An animation sequence performed when the binding
    ///   value changes.
    ///
    /// - Returns: A new binding.
    public func animation(_ animation: Animation? = .default) -> Binding<Value> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Binding : DynamicProperty {
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

/// A capsule shape aligned inside the frame of the view containing it.
///
/// A capsule shape is equivalent to a rounded rectangle where the corner radius
/// is chosen as half the length of the rectangle's smallest edge.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Capsule : Shape {
    public var style: RoundedCornerStyle { get { fatalError() } }

    /// Creates a new capsule shape.
    ///
    /// - Parameters:
    ///   - style: the style of corners drawn by the shape.
    @inlinable public init(style: RoundedCornerStyle = .continuous) { fatalError() }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in r: CGRect) -> Path { fatalError() }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Capsule : InsettableShape {
    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> InsetShape { return never() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

/// A circle centered on the frame of the view containing it.
///
/// The circle's radius equals half the length of the frame rectangle's smallest
/// edge.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Circle : Shape {

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// Creates a new circle shape.
    @inlinable public init() { fatalError() }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Circle {

    /// Returns the size of the view that will render the shape, given
    /// a proposed size.
    ///
    /// Implement this method to tell the container of the shape how
    /// much space the shape needs to render itself, given a size
    /// proposal.
    ///
    /// See ``Layout/sizeThatFits(proposal:subviews:cache:)``
    /// for more details about how the layout system chooses the size of
    /// views.
    ///
    /// - Parameters:
    ///   - proposal: A size proposal for the container.
    ///
    /// - Returns: A size that indicates how much space the shape needs.
    public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Circle : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

/// A progress view that uses a circular gauge to indicate the partial
/// completion of an activity.
///
/// On watchOS, and in widgets and complications, a circular progress view
/// appears as a gauge with the ``GaugeStyle/accessoryCircularCapacity``
/// style. If the progress view is indeterminate, the gauge is empty.
///
/// In cases where no determinate circular progress view style is available,
/// circular progress views use an indeterminate style.
///
/// Use ``ProgressViewStyle/circular`` to construct the circular progress view
/// style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct CircularProgressViewStyle : ProgressViewStyle {

    /// Creates a circular progress view style.
    public init() { fatalError() }

    /// Creates a circular progress view style with a tint color.
    @available(iOS, introduced: 14.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    @available(macOS, introduced: 11.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    @available(tvOS, introduced: 14.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    @available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    public init(tint: Color) { fatalError() }

    /// Creates a view representing the body of a progress view.
    ///
    /// - Parameter configuration: The properties of the progress view being
    ///   created.
    ///
    /// The view hierarchy calls this method for each progress view where this
    /// style is the current progress view style.
    ///
    /// - Parameter configuration: The properties of the progress view, such as
    ///  its preferred progress type.
    public func makeBody(configuration: CircularProgressViewStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a progress view.
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

/// A control used to select a color from the system color picker UI.
///
/// The color picker provides a color well that shows the currently selected
/// color, and displays the larger system color picker that allows users to
/// select a new color.
///
/// By default color picker supports colors with opacity; to disable opacity
/// support, set the `supportsOpacity` parameter to `false`.
/// In this mode the color picker won't show controls for adjusting the opacity
/// of the selected color, and strips out opacity from any color set
/// programmatically or selected from the user's system favorites.
///
/// You use `ColorPicker` by embedding it inside a view hierarchy and
/// initializing it with a title string and a ``Binding`` to a ``Color``:
///
///     struct FormattingControls: View {
///         @State private var bgColor =
///             Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
///
///         var body: some View {
///             VStack {
///                 ColorPicker("Alignment Guides", selection: $bgColor)
///             }
///         }
///     }
///
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct ColorPicker<Label> : View where Label : View {

    /// Creates an instance that selects a color.
    ///
    /// - Parameters:
    ///     - selection: A ``Binding`` to the variable that displays the
    ///       selected ``Color``.
    ///     - supportsOpacity: A Boolean value that indicates whether the color
    ///       picker allows adjusting the selected color's opacity; the default
    ///       is `true`.
    ///     - label: A view that describes the use of the selected color.
    ///        The system color picker UI sets it's title using the text from
    ///        this view.
    ///
    public init(selection: Binding<Color>, supportsOpacity: Bool = true, @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates an instance that selects a color.
    ///
    /// - Parameters:
    ///     - selection: A ``Binding`` to the variable that displays the
    ///       selected ``CGColor``.
    ///     - supportsOpacity: A Boolean value that indicates whether the color
    ///       picker allows adjusting the selected color's opacity; the default
    ///       is `true`.
    ///     - label: A view that describes the use of the selected color.
    ///        The system color picker UI sets it's title using the text from
    ///        this view.
    ///
    public init(selection: Binding<CGColor>, supportsOpacity: Bool = true, @ViewBuilder label: () -> Label) { fatalError() }

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
extension ColorPicker where Label == Text {

    /// Creates a color picker with a text label generated from a title string key.
    ///
    /// Use ``ColorPicker`` to create a color well that your app uses to allow
    /// the selection of a ``Color``. The example below creates a color well
    /// using a ``Binding`` to a property stored in a settings object and title
    /// you provide:
    ///
    ///     final class Settings: ObservableObject {
    ///         @Published var alignmentGuideColor =
    ///             Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    ///     }
    ///
    ///     struct FormattingControls: View {
    ///         @State private var settings = Settings()
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 // Other formatting controls.
    ///                 ColorPicker("Alignment Guides",
    ///                     selection: $settings.alignmentGuideColor
    ///                 )
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the picker.
    ///   - selection: A ``Binding`` to the variable that displays the
    ///     selected ``Color``.
    ///   - supportsOpacity: A Boolean value that indicates whether the color
    ///     picker allows adjustments to the selected color's opacity; the
    ///     default is `true`.
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Color>, supportsOpacity: Bool = true) { fatalError() }

    /// Creates a color picker with a text label generated from a title string.
    ///
    /// Use ``ColorPicker`` to create a color well that your app uses to allow
    /// the selection of a ``Color``. The example below creates a color well
    /// using a ``Binding`` and title you provide:
    ///
    ///     func showColorPicker(_ title: String, color: Binding<Color>) {
    ///         ColorPicker(title, selection: color)
    ///     }
    ///
    /// - Parameters:
    ///   - title: The title displayed by the color picker.
    ///   - selection: A ``Binding`` to the variable containing a ``Color``.
    ///   - supportsOpacity: A Boolean value that indicates whether the color
    ///     picker allows adjustments to the selected color's opacity; the
    ///     default is `true`.
    public init<S>(_ title: S, selection: Binding<Color>, supportsOpacity: Bool = true) where S : StringProtocol { fatalError() }

    /// Creates a color picker with a text label generated from a title string key.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the picker.
    ///   - selection: A ``Binding`` to the variable that displays the
    ///     selected ``CGColor``.
    ///   - supportsOpacity: A Boolean value that indicates whether the color
    ///     picker allows adjustments to the selected color's opacity; the
    ///     default is `true`.
    public init(_ titleKey: LocalizedStringKey, selection: Binding<CGColor>, supportsOpacity: Bool = true) { fatalError() }

    /// Creates a color picker with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - title: The title displayed by the color picker.
    ///   - selection: A ``Binding`` to the variable containing a ``CGColor``.
    ///   - supportsOpacity: A Boolean value that indicates whether the color
    ///     picker allows adjustments to the selected color's opacity; the
    ///     default is `true`.
    public init<S>(_ title: S, selection: Binding<CGColor>, supportsOpacity: Bool = true) where S : StringProtocol { fatalError() }
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

/// A shape that is replaced by an inset version of the current
/// container shape. If no container shape was defined, is replaced by
/// a rectangle.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen public struct ContainerRelativeShape : Shape {

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    @inlinable public init() { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ContainerRelativeShape : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
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

/// A keyframe that uses a cubic curve to smoothly interpolate between values.
///
/// If you don't specify a start or end velocity, SkipUI automatically
/// computes a curve that maintains smooth motion between keyframes.
///
/// Adjacent cubic keyframes result in a Catmull-Rom spline.
///
/// If a cubic keyframe follows a different type of keyframe, such as a linear
/// keyframe, the end velocity of the segment defined by the previous keyframe
/// will be used as the starting velocity.
///
/// Likewise, if a cubic keyframe is followed by a different type of keyframe,
/// the initial velocity of the next segment is used as the end velocity of the
/// segment defined by this keyframe.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct CubicKeyframe<Value> : KeyframeTrackContent where Value : Animatable {

    /// Creates a new keyframe using the given value and timestamp.
    ///
    /// - Parameters:
    ///   - to: The value of the keyframe.
    ///   - startVelocity: The velocity of the value at the beginning of the
    ///     segment, or `nil` to automatically compute the velocity to maintain
    ///     smooth motion.
    ///   - endVelocity: The velocity of the value at the end of the segment,
    ///     or `nil` to automatically compute the velocity to maintain smooth
    ///     motion.
    ///   - duration: The duration of the segment defined by this keyframe.
    public init(_ to: Value, duration: TimeInterval, startVelocity: Value? = nil, endVelocity: Value? = nil) { fatalError() }

    public typealias Value = Value
    public typealias Body = CubicKeyframe<Value>
    public var body: Body { fatalError() }
}

/// A type that defines how an animatable value changes over time.
///
/// Use this protocol to create a type that changes an animatable value over
/// time, which produces a custom visual transition of a view. For example, the
/// follow code changes an animatable value using an elastic ease-in ease-out
/// function:
///
///     struct ElasticEaseInEaseOutAnimation: CustomAnimation {
///         let duration: TimeInterval
///
///         func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
///             if time > duration { return nil } // The animation has finished.
///
///             let p = time / duration
///             let s = sin((20 * p - 11.125) * ((2 * Double.pi) / 4.5))
///             if p < 0.5 {
///                 return value.scaled(by: -(pow(2, 20 * p - 10) * s) / 2)
///             } else {
///                 return value.scaled(by: (pow(2, -20 * p + 10) * s) / 2 + 1)
///             }
///         }
///     }
///
/// > Note: To maintain state during the life span of a custom animation, use
/// the ``AnimationContext/state`` property available on the `context`
/// parameter value. You can also use context's
/// ``AnimationContext/environment`` property to retrieve environment values
/// from the view that created the custom animation. For more information, see
/// ``AnimationContext``.
///
/// To create an ``Animation`` instance of a custom animation, use the
/// ``Animation/init(_:)`` initializer, passing in an instance of a custom
/// animation; for example:
///
///     Animation(ElasticEaseInEaseOutAnimation(duration: 5.0))
///
/// To help make view code more readable, extend ``Animation`` and add a static
/// property and function that returns an `Animation` instance of a custom
/// animation. For example, the following code adds the static property
/// `elasticEaseInEaseOut` that returns the elastic ease-in ease-out animation
/// with a default duration of `0.35` seconds. Next, the code adds a method
/// that returns the animation with a specified duration.
///
///     extension Animation {
///         static var elasticEaseInEaseOut: Animation { elasticEaseInEaseOut(duration: 0.35) }
///         static func elasticEaseInEaseOut(duration: TimeInterval) -> Animation {
///             Animation(ElasticEaseInEaseOutAnimation(duration: duration))
///         }
///     }
///
/// To animate a view with the elastic ease-in ease-out animation, a view calls
/// either `.elasticEaseInEaseOut` or `.elasticEaseInEaseOut(duration:)`. For
/// example, the follow code includes an Animate button that, when clicked,
/// animates a circle as it moves from one edge of the view to the other,
/// using the elastic ease-in ease-out animation with a duration of `5`
/// seconds:
///
///     struct ElasticEaseInEaseOutView: View {
///         @State private var isActive = false
///
///         var body: some View {
///             VStack(alignment: isActive ? .trailing : .leading) {
///                 Circle()
///                     .frame(width: 100.0)
///                     .foregroundColor(.accentColor)
///
///                 Button("Animate") {
///                     withAnimation(.elasticEaseInEaseOut(duration: 5.0)) {
///                         isActive.toggle()
///                     }
///                 }
///                 .frame(maxWidth: .infinity)
///             }
///             .padding()
///         }
///     }
///
/// @Video(source: "animation-20-elastic.mp4", poster: "animation-20-elastic.png", alt: "A video that shows a circle that moves from one edge of the view to the other using an elastic ease-in ease-out animation. The circle's initial position is near the leading edge of the view. The circle begins moving slightly towards the leading, then towards trail edges of the view before it moves off the leading edge showing only two-thirds of the circle. The circle then moves quickly to the trailing edge of the view, going slightly beyond the edge so that only two-thirds of the circle is visible. The circle bounces back into full view before settling into position near the trailing edge of the view. The circle repeats this animation in reverse, going from the trailing edge of the view to the leading edge.")
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol CustomAnimation : Hashable {

    /// Calculates the value of the animation at the specified time.
    ///
    /// Implement this method to calculate and return the value of the
    /// animation at a given point in time. If the animation has finished,
    /// return `nil` as the value. This signals to the system that it can
    /// remove the animation.
    ///
    /// If your custom animation needs to maintain state between calls to the
    /// `animate(value:time:context:)` method, store the state data in
    /// `context`. This makes the data available to the method next time
    /// the system calls it. To learn more about managing state data in a
    /// custom animation, see ``AnimationContext``.
    ///
    /// - Parameters:
    ///   - value: The vector to animate towards.
    ///   - time: The elapsed time since the start of the animation.
    ///   - context: An instance of ``AnimationContext`` that provides access
    ///   to state and the animation environment.
    /// - Returns: The current value of the animation, or `nil` if the
    ///   animation has finished.
    func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic

    /// Calculates the velocity of the animation at a specified time.
    ///
    /// Implement this method to provide the velocity of the animation at a
    /// given time. Should subsequent animations merge with the animation,
    /// the system preserves continuity of the velocity between animations.
    ///
    /// The default implementation of this method returns `nil`.
    ///
    /// > Note: State and environment data is available to this method via the
    /// `context` parameter, but `context` is read-only. This behavior is
    /// different than with ``animate(value:time:context:)`` and
    /// ``shouldMerge(previous:value:time:context:)-7f4ts`` where `context` is
    /// an `inout` parameter, letting you change the context including state
    /// data of the animation. For more information about managing state data
    /// in a custom animation, see ``AnimationContext``.
    ///
    /// - Parameters:
    ///   - value: The vector to animate towards.
    ///   - time: The amount of time since the start of the animation.
    ///   - context: An instance of ``AnimationContext`` that provides access
    ///   to state and the animation environment.
    /// - Returns: The current velocity of the animation, or `nil` if the
    ///   animation has finished.
    func velocity<V>(value: V, time: TimeInterval, context: AnimationContext<V>) -> V? where V : VectorArithmetic

    /// Determines whether an instance of the animation can merge with other
    /// instance of the same type.
    ///
    /// When a view creates a new animation on an animatable value that already
    /// has a running animation of the same animation type, the system calls
    /// the `shouldMerge(previous:value:time:context:)` method on the new
    /// instance to determine whether it can merge the two instance. Implement
    /// this method if the animation can merge with another instance. The
    /// default implementation returns `false`.
    ///
    /// If `shouldMerge(previous:value:time:context:)` returns `true`, the
    /// system merges the new animation instance with the previous animation.
    /// The system provides to the new instance the state and elapsed time from
    /// the previous one. Then it removes the previous animation.
    ///
    /// If this method returns `false`, the system doesn't merge the animation
    /// with the previous one. Instead, both animations run together and the
    /// system combines their results.
    ///
    /// If your custom animation needs to maintain state between calls to the
    /// `shouldMerge(previous:value:time:context:)` method, store the state
    /// data in `context`. This makes the data available to the method next
    /// time the system calls it. To learn more, see ``AnimationContext``.
    ///
    /// - Parameters:
    ///   - previous: The previous running animation.
    ///   - value: The vector to animate towards.
    ///   - time: The amount of time since the start of the previous animation.
    ///   - context: An instance of ``AnimationContext`` that provides access
    ///   to state and the animation environment.
    /// - Returns: A Boolean value of `true` if the animation should merge with
    ///   the previous animation; otherwise, `false`.
    func shouldMerge<V>(previous: Animation, value: V, time: TimeInterval, context: inout AnimationContext<V>) -> Bool where V : VectorArithmetic
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CustomAnimation {

    /// Calculates the velocity of the animation at a specified time.
    ///
    /// Implement this method to provide the velocity of the animation at a
    /// given time. Should subsequent animations merge with the animation,
    /// the system preserves continuity of the velocity between animations.
    ///
    /// The default implementation of this method returns `nil`.
    ///
    /// > Note: State and environment data is available to this method via the
    /// `context` parameter, but `context` is read-only. This behavior is
    /// different than with ``animate(value:time:context:)`` and
    /// ``shouldMerge(previous:value:time:context:)-7f4ts`` where `context` is
    /// an `inout` parameter, letting you change the context including state
    /// data of the animation. For more information about managing state data
    /// in a custom animation, see ``AnimationContext``.
    ///
    /// - Parameters:
    ///   - value: The vector to animate towards.
    ///   - time: The amount of time since the start of the animation.
    ///   - context: An instance of ``AnimationContext`` that provides access
    ///   to state and the animation environment.
    /// - Returns: The current velocity of the animation, or `nil` if the
    ///   animation has finished.
    public func velocity<V>(value: V, time: TimeInterval, context: AnimationContext<V>) -> V? where V : VectorArithmetic { fatalError() }

    /// Determines whether an instance of the animation can merge with other
    /// instance of the same type.
    ///
    /// When a view creates a new animation on an animatable value that already
    /// has a running animation of the same animation type, the system calls
    /// the `shouldMerge(previous:value:time:context:)` method on the new
    /// instance to determine whether it can merge the two instance. Implement
    /// this method if the animation can merge with another instance. The
    /// default implementation returns `false`.
    ///
    /// If `shouldMerge(previous:value:time:context:)` returns `true`, the
    /// system merges the new animation instance with the previous animation.
    /// The system provides to the new instance the state and elapsed time from
    /// the previous one. Then it removes the previous animation.
    ///
    /// If this method returns `false`, the system doesn't merge the animation
    /// with the previous one. Instead, both animations run together and the
    /// system combines their results.
    ///
    /// If your custom animation needs to maintain state between calls to the
    /// `shouldMerge(previous:value:time:context:)` method, store the state
    /// data in `context`. This makes the data available to the method next
    /// time the system calls it. To learn more, see ``AnimationContext``.
    ///
    /// - Parameters:
    ///   - previous: The previous running animation.
    ///   - value: The vector to animate towards.
    ///   - time: The amount of time since the start of the previous animation.
    ///   - context: An instance of ``AnimationContext`` that provides access
    ///   to state and the animation environment.
    /// - Returns: A Boolean value of `true` if the animation should merge with
    ///   the previous animation; otherwise, `false`.
    public func shouldMerge<V>(previous: Animation, value: V, time: TimeInterval, context: inout AnimationContext<V>) -> Bool where V : VectorArithmetic { fatalError() }
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

/// A control for selecting an absolute date.
///
/// Use a `DatePicker` when you want to provide a view that allows the user to
/// select a calendar date, and optionally a time. The view binds to a
///  instance.
///
/// The following example creates a basic `DatePicker`, which appears on iOS as
/// text representing the date. This example limits the display to only the
/// calendar date, not the time. When the user taps or clicks the text, a
/// calendar view animates in, from which the user can select a date. When the
/// user dismisses the calendar view, the view updates the bound
/// .
///
///     @State private var date = Date()
///
///     var body: some View {
///         DatePicker(
///             "Start Date",
///             selection: $date,
///             displayedComponents: [.date]
///         )
///     }
///
/// ![An iOS date picker, consisting of a label that says Start Date, and a
/// label showing the date Apr 1, 1976.](SkipUI-DatePicker-basic.png)
///
/// You can limit the `DatePicker` to specific ranges of dates, allowing
/// selections only before or after a certain date, or between two dates. The
/// following example shows a date-and-time picker that only permits selections
/// within the year 2021 (in the `UTC` time zone).
///
///     @State private var date = Date()
///     let dateRange: ClosedRange<Date> = {
///         let calendar = Calendar.current
///         let startComponents = DateComponents(year: 2021, month: 1, day: 1)
///         let endComponents = DateComponents(year: 2021, month: 12, day: 31, hour: 23, minute: 59, second: 59)
///         return calendar.date(from:startComponents)!
///             ...
///             calendar.date(from:endComponents)!
///     }()
///
///     var body: some View {
///         DatePicker(
///             "Start Date",
///              selection: $date,
///              in: dateRange,
///              displayedComponents: [.date, .hourAndMinute]
///         )
///     }
///
/// ![A SkipUI standard date picker on iOS, with the label Start Date, and
/// buttons for the time 5:15 PM and the date Jul 31,
/// 2021.](SkipUI-DatePicker-selectFromRange.png)
///
/// ### Styling date pickers
///
/// To use a different style of date picker, use the
/// ``View/datePickerStyle(_:)`` view modifier. The following example shows the
/// graphical date picker style.
///
///     @State private var date = Date()
///
///     var body: some View {
///         DatePicker(
///             "Start Date",
///             selection: $date,
///             displayedComponents: [.date]
///         )
///         .datePickerStyle(.graphical)
///     }
///
/// ![A SkipUI date picker using the graphical style, with the label Start Date
/// and wheels for the month, day, and year, showing the selection
/// October 22, 2021.](SkipUI-DatePicker-graphicalStyle.png)
///
@available(iOS 13.0, macOS 10.15, watchOS 10.0, *)
@available(tvOS, unavailable)
public struct DatePicker<Label> : View where Label : View {

    public typealias Components = DatePickerComponents

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

@available(iOS 13.0, macOS 10.15, watchOS 10.0, *)
@available(tvOS, unavailable)
extension DatePicker {

    /// Creates an instance that selects a `Date` with an unbounded range.
    ///
    /// - Parameters:
    ///   - selection: The date value being displayed and selected.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    ///   - label: A view that describes the use of the date.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init(selection: Binding<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates an instance that selects a `Date` in a closed range.
    ///
    /// - Parameters:
    ///   - selection: The date value being displayed and selected.
    ///   - range: The inclusive range of selectable dates.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    ///   - label: A view that describes the use of the date.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init(selection: Binding<Date>, in range: ClosedRange<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates an instance that selects a `Date` on or after some start date.
    ///
    /// - Parameters:
    ///   - selection: The date value being displayed and selected.
    ///   - range: The open range from some selectable start date.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    ///   - label: A view that describes the use of the date.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init(selection: Binding<Date>, in range: PartialRangeFrom<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates an instance that selects a `Date` on or before some end date.
    ///
    /// - Parameters:
    ///   - selection: The date value being displayed and selected.
    ///   - range: The open range before some selectable end date.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    ///   - label: A view that describes the use of the date.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init(selection: Binding<Date>, in range: PartialRangeThrough<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, watchOS 10.0, *)
@available(tvOS, unavailable)
extension DatePicker where Label == Text {

    /// Creates an instance that selects a `Date` with an unbounded range.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of `self`, describing
    ///     its purpose.
    ///   - selection: The date value being displayed and selected.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) { fatalError() }

    /// Creates an instance that selects a `Date` in a closed range.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of `self`, describing
    ///     its purpose.
    ///   - selection: The date value being displayed and selected.
    ///   - range: The inclusive range of selectable dates.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: ClosedRange<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) { fatalError() }

    /// Creates an instance that selects a `Date` on or after some start date.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of `self`, describing
    ///     its purpose.
    ///   - selection: The date value being displayed and selected.
    ///   - range: The open range from some selectable start date.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: PartialRangeFrom<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) { fatalError() }

    /// Creates an instance that selects a `Date` on or before some end date.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of `self`, describing
    ///     its purpose.
    ///   - selection: The date value being displayed and selected.
    ///   - range: The open range before some selectable end date.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: PartialRangeThrough<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) { fatalError() }

    /// Creates an instance that selects a `Date` within the given range.
    ///
    /// - Parameters:
    ///   - title: The title of `self`, describing its purpose.
    ///   - selection: The date value being displayed and selected.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init<S>(_ title: S, selection: Binding<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol { fatalError() }

    /// Creates an instance that selects a `Date` in a closed range.
    ///
    /// - Parameters:
    ///   - title: The title of `self`, describing its purpose.
    ///   - selection: The date value being displayed and selected.
    ///   - range: The inclusive range of selectable dates.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init<S>(_ title: S, selection: Binding<Date>, in range: ClosedRange<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol { fatalError() }

    /// Creates an instance that selects a `Date` on or after some start date.
    ///
    /// - Parameters:
    ///   - title: The title of `self`, describing its purpose.
    ///   - selection: The date value being displayed and selected.
    ///   - range: The open range from some selectable start date.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init<S>(_ title: S, selection: Binding<Date>, in range: PartialRangeFrom<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol { fatalError() }

    /// Creates an instance that selects a `Date` on or before some end date.
    ///
    /// - Parameters:
    ///   - title: The title of `self`, describing its purpose.
    ///   - selection: The date value being displayed and selected.
    ///   - range: The open range before some selectable end date.
    ///   - displayedComponents: The date components that user is able to
    ///     view and edit. Defaults to `[.hourAndMinute, .date]`. On watchOS,
    ///     if `.hourAndMinute` or `.hourMinuteAndSecond` are included with
    ///     `.date`, only `.date` is displayed.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init<S>(_ title: S, selection: Binding<Date>, in range: PartialRangeThrough<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol { fatalError() }
}

@available(iOS 13.0, macOS 10.15, watchOS 10.0, *)
@available(tvOS, unavailable)
public struct DatePickerComponents : OptionSet, Sendable {

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
    public let rawValue: UInt

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
    public init(rawValue: UInt) { fatalError() }

    /// Displays hour and minute components based on the locale
    public static let hourAndMinute: DatePickerComponents = { fatalError() }()

    /// Displays day, month, and year based on the locale
    public static let date: DatePickerComponents = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = DatePickerComponents

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = DatePickerComponents

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = UInt
}

/// A type that specifies the appearance and interaction of all date pickers
/// within a view hierarchy.
///
/// To configure the current date picker style for a view hierarchy, use the
/// ``View/datePickerStyle(_:)`` modifier.
@available(iOS 13.0, macOS 10.15, watchOS 10.0, *)
@available(tvOS, unavailable)
public protocol DatePickerStyle {

    /// A view representing the appearance and interaction of a `DatePicker`.
    associatedtype Body : View

    /// Returns the appearance and interaction content for a `DatePicker`.
    ///
    /// The system calls this method for each ``DatePicker`` instance in a view
    /// hierarchy where this style is the current date picker style.
    ///
    /// - Parameter configuration : The properties of the date picker.
    @available(iOS 16.0, macOS 13.0, *)
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// A type alias for the properties of a `DatePicker`.
    @available(iOS 16.0, macOS 13.0, *)
    typealias Configuration = DatePickerStyleConfiguration
}

@available(iOS 13.0, macOS 10.15, watchOS 10.0, *)
@available(tvOS, unavailable)
extension DatePickerStyle where Self == DefaultDatePickerStyle {

    /// The default style for date pickers.
    public static var automatic: DefaultDatePickerStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DatePickerStyle where Self == GraphicalDatePickerStyle {

    /// A date picker style that displays an interactive calendar or clock.
    ///
    /// This style is useful when you want to allow browsing through days in a
    /// calendar, or when the look of a clock face is appropriate.
    public static var graphical: GraphicalDatePickerStyle { get { fatalError() } }
}

@available(iOS 13.0, watchOS 10.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension DatePickerStyle where Self == WheelDatePickerStyle {

    /// A date picker style that displays each component as columns in a
    /// scrollable wheel.
    public static var wheel: WheelDatePickerStyle { get { fatalError() } }
}

@available(iOS 14.0, macCatalyst 13.4, macOS 10.15.4, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DatePickerStyle where Self == CompactDatePickerStyle {

    /// A date picker style that displays the components in a compact, textual
    /// format.
    ///
    /// Use this style when space is constrained and users expect to make
    /// specific date and time selections. Some variants may include rich
    /// editing controls in a pop up.
    public static var compact: CompactDatePickerStyle { get { fatalError() } }
}

/// The properties of a `DatePicker`.
@available(iOS 16.0, macOS 13.0, watchOS 10.0, *)
@available(tvOS, unavailable)
public struct DatePickerStyleConfiguration {

    /// A type-erased label of a `DatePicker`.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A description of the `DatePicker`.
    public let label: DatePickerStyleConfiguration.Label = { fatalError() }()

    /// The date value being displayed and selected.
//    @Binding public var selection: Date { get { fatalError() } nonmutating set { fatalError() } }

//    public var $selection: Binding<Date> { get { fatalError() } }

    /// The oldest selectable date.
    public var minimumDate: Date?

    /// The most recent selectable date.
    public var maximumDate: Date?

    /// The date components that the user is able to view and edit.
    public var displayedComponents: DatePickerComponents { get { fatalError() } }
}

/// The default style for date pickers.
///
/// You can also use ``DatePickerStyle/automatic`` to construct this style.
@available(iOS 13.0, macOS 10.15, watchOS 10.0, *)
@available(tvOS, unavailable)
public struct DefaultDatePickerStyle : DatePickerStyle {

    /// Creates an instance of the default date picker style.
    public init() { fatalError() }

    /// Returns the appearance and interaction content for a `DatePicker`.
    ///
    /// The system calls this method for each ``DatePicker`` instance in a view
    /// hierarchy where this style is the current date picker style.
    ///
    /// - Parameter configuration : The properties of the date picker.
    @available(iOS 16.0, macOS 13.0, *)
    public func makeBody(configuration: DefaultDatePickerStyle.Configuration) -> some View { return never() }


    /// A view representing the appearance and interaction of a `DatePicker`.
//    public typealias Body = some View
}

/// The default type of the current value label when used by a date-relative
/// progress view.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct DefaultDateProgressLabel : View {

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

/// The default progress view style in the current context of the view being
/// styled.
///
/// Use ``ProgressViewStyle/automatic`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct DefaultProgressViewStyle : ProgressViewStyle {

    /// Creates a default progress view style.
    public init() { fatalError() }

    /// Creates a view representing the body of a progress view.
    ///
    /// - Parameter configuration: The properties of the progress view being
    ///   created.
    ///
    /// The view hierarchy calls this method for each progress view where this
    /// style is the current progress view style.
    ///
    /// - Parameter configuration: The properties of the progress view, such as
    ///  its preferred progress type.
    public func makeBody(configuration: DefaultProgressViewStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a progress view.
//    public typealias Body = some View
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

/// A kind of table row that shows or hides additional rows based on the state
/// of a disclosure control.
///
/// A disclosure group row consists of a label row that is always visible, and
/// some content rows that are conditionally visible depending on the state.
/// Toggling the control will flip the state between "expanded" and "collapsed".
///
/// In the following example, a disclosure group has `allDevices` as the label
/// row, and exposes its expanded state with the bound property, `expanded`.
/// Upon toggling the disclosure control, the user can update the expanded state
/// which will in turn show or hide the three content rows for `iPhone`, `iPad`,
/// and `Mac`.
///
///     private struct DeviceStats: Identifiable {
///         // ...
///     }
///     @State private var expanded: Bool = true
///     @State private var allDevices: DeviceStats = /* ... */
///     @State private var iPhone: DeviceStats = /* ... */
///     @State private var iPad: DeviceStats = /* ... */
///     @State private var Mac: DeviceStats = /* ... */
///
///     var body: some View {
///         Table(of: DeviceStats.self) {
///             // ...
///         } rows: {
///             DisclosureTableRow(allDevices, isExpanded: $expanded) {
///                 TableRow(iPhone)
///                 TableRow(iPad)
///                 TableRow(Mac)
///             }
///         }
///     }
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DisclosureTableRow<Label, Content> : TableRowContent where Label : TableRowContent, Content : TableRowContent, Label.TableRowValue == Content.TableRowValue {

    /// The type of value represented by this table row content.
    public typealias TableRowValue = Label.TableRowValue

    /// Creates a disclosure group with the given value and table rows, and a
    /// binding to the expansion state (expanded or collapsed).
    ///
    /// - Parameters:
    ///   - value: The value of the discloseable table row.
    ///   - isExpanded: A binding to a Boolean value that determines the group's
    ///    expansion state (expanded or collapsed).
    ///   - content: The table row shown when the disclosure group expands.
    public init<Value>(_ value: Value, isExpanded: Binding<Bool>? = nil, @TableRowBuilder<Value> content: @escaping () -> Content) where Label == TableRow<Value>, Value == Content.TableRowValue { fatalError() }

    /// The composition of content that comprise the table row content.
    public var tableRowBody: TableRowBody { get { return never() } }

    /// The type of content representing the body of this table row content.
    public typealias TableRowBody = Never
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

/// A type of table row content that generates table rows from an underlying
/// collection of data.
///
/// This table row content type provides drag-and-drop support for tables. Use
/// the ``DynamicTableRowContent/onInsert(of:perform:)`` modifier to add an
/// action to call when the table inserts new contents into its underlying
/// collection.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol DynamicTableRowContent : TableRowContent {

    /// The type of the underlying collection of data.
    associatedtype Data : Collection

    /// The collection of underlying data.
    var data: Self.Data { get }
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DynamicTableRowContent {

    /// Sets the insert action for the dynamic table rows.
    ///
    ///     struct Profile: Identifiable {
    ///         let givenName: String
    ///         let familyName: String
    ///         let id = UUID()
    ///     }
    ///
    ///     @State private var profiles: [Profile] = [
    ///         Person(givenName: "Juan", familyName: "Chavez"),
    ///         Person(givenName: "Mei", familyName: "Chen"),
    ///         Person(givenName: "Tom", familyName: "Clark"),
    ///         Person(givenName: "Gita", familyName: "Kumar")
    ///     ]
    ///
    ///     var body: some View {
    ///         Table {
    ///             TableColumn("Given Name", value: \.givenName)
    ///             TableColumn("Family Name", value: \.familyName)
    ///         } rows: {
    ///             ForEach(profiles) {
    ///                 TableRow($0)
    ///             }
    ///             .dropDestination(
    ///                 for: Profile.self
    ///             ) { offset, receivedProfiles in
    ///                 people.insert(contentsOf: receivedProfiles, at: offset)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - payloadType: Type of the models that are dropped.
    ///   - action: A closure that SkipUI invokes when elements are added to
    ///     the collection of rows.
    ///     The closure takes two arguments: The first argument is the
    ///     offset relative to the dynamic view's underlying collection of data.
    ///     The second argument is an array of `Transferable` items that
    ///     represents the data that you want to insert.
    ///
    /// - Returns: A view that calls `action` when elements are inserted into
    ///   the original view.
//    @available(iOS 16.0, macOS 13.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    public func dropDestination<T>(for payloadType: T.Type = T.self, action: @escaping (Int, [T]) -> Void) -> ModifiedContent<Self, OnInsertTableRowModifier> where T : Transferable { fatalError() }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DynamicTableRowContent {

    /// Sets the insert action for the dynamic table rows.
    ///
    /// - Parameters:
    ///   - supportedContentTypes: An array of universal type identifiers types that the rows supports.
    ///   - action: A closure that SkipUI invokes when adding elements to
    ///     the collection of rows.
    ///     The closure takes two arguments. The first argument is the
    ///     offset relative to the dynamic view's underlying collection of data.
    ///     The second argument is an array of
    ///     
    ///     items that represents the data that you want to insert.
    ///
    /// - Returns: A view that calls `action` when inserting elements into
    ///   the original view.
//    public func onInsert(of supportedContentTypes: [UTType], perform action: @escaping (Int, [NSItemProvider]) -> Void) -> ModifiedContent<Self, OnInsertTableRowModifier> { fatalError() }
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
extension EdgeInsets : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
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

/// An ellipse aligned inside the frame of the view containing it.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Ellipse : Shape {

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// Creates a new ellipse shape.
    @inlinable public init() { fatalError() }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Ellipse : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

/// An empty type for animatable data.
///
/// This type is suitable for use as the `animatableData` property of
/// types that do not have any animatable properties.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct EmptyAnimatableData : VectorArithmetic {

    @inlinable public init() { fatalError() }

    /// The zero value.
    ///
    /// Zero is the identity element for addition. For any value,
    /// `x + .zero == x` and `.zero + x == x`.
    @inlinable public static var zero: EmptyAnimatableData { get { fatalError() } }

    /// Adds two values and stores the result in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    @inlinable public static func += (lhs: inout EmptyAnimatableData, rhs: EmptyAnimatableData) { fatalError() }

    /// Subtracts the second value from the first and stores the difference in the
    /// left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from `lhs`.
    @inlinable public static func -= (lhs: inout EmptyAnimatableData, rhs: EmptyAnimatableData) { fatalError() }

    /// Adds two values and produces their sum.
    ///
    /// The addition operator (`+`) calculates the sum of its two arguments. For
    /// example:
    ///
    ///     1 + 2                   // 3
    ///     -10 + 15                // 5
    ///     -15 + -5                // -20
    ///     21.5 + 3.25             // 24.75
    ///
    /// You cannot use `+` with arguments of different types. To add values of
    /// different types, convert one of the values to the other value's type.
    ///
    ///     let x: Int8 = 21
    ///     let y: Int = 1000000
    ///     Int(x) + y              // 1000021
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    @inlinable public static func + (lhs: EmptyAnimatableData, rhs: EmptyAnimatableData) -> EmptyAnimatableData { fatalError() }

    /// Subtracts one value from another and produces their difference.
    ///
    /// The subtraction operator (`-`) calculates the difference of its two
    /// arguments. For example:
    ///
    ///     8 - 3                   // 5
    ///     -10 - 5                 // -15
    ///     100 - -5                // 105
    ///     10.5 - 100.0            // -89.5
    ///
    /// You cannot use `-` with arguments of different types. To subtract values
    /// of different types, convert one of the values to the other value's type.
    ///
    ///     let x: UInt8 = 21
    ///     let y: UInt = 1000000
    ///     y - UInt(x)             // 999979
    ///
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from `lhs`.
    @inlinable public static func - (lhs: EmptyAnimatableData, rhs: EmptyAnimatableData) -> EmptyAnimatableData { fatalError() }

    /// Multiplies each component of this value by the given value.
    @inlinable public mutating func scale(by rhs: Double) { fatalError() }

    /// The dot-product of this animatable data instance with itself.
    @inlinable public var magnitudeSquared: Double { get { fatalError() } }

    public static func == (a: EmptyAnimatableData, b: EmptyAnimatableData) -> Bool { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EmptyAnimatableData : Sendable {
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

/// A table row content that doesn't produce any rows.
///
/// You will rarely, if ever, need to create an `EmptyTableRowContent` directly.
/// Instead, `EmptyTableRowContent` represents the absence of a row.
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct EmptyTableRowContent<Value> where Value : Identifiable {

    /// The type of value represented by this table row content.
    public typealias TableRowValue = Value

    /// The type of content representing the body of this table row content.
    public typealias TableRowBody = Never
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EmptyTableRowContent : TableRowContent {
    public var tableRowBody: Never { fatalError() }
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

/// A schedule for updating a timeline view at the start of every minute.
///
/// You can also use ``TimelineSchedule/everyMinute`` to construct this
/// schedule.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct EveryMinuteTimelineSchedule : TimelineSchedule, Sendable {

    /// The sequence of dates in an every minute schedule.
    ///
    /// The ``EveryMinuteTimelineSchedule/entries(from:mode:)`` method returns
    /// a value of this type, which is a
    /// of dates, one per minute, in ascending order. A ``TimelineView`` that
    /// you create updates its content at the moments in time corresponding to
    /// the dates included in the sequence.
    public struct Entries : Sequence, IteratorProtocol, Sendable {

        /// Advances to the next element and returns it, or `nil` if no next element
        /// exists.
        ///
        /// Repeatedly calling this method returns, in order, all the elements of the
        /// underlying sequence. As soon as the sequence has run out of elements, all
        /// subsequent calls return `nil`.
        ///
        /// You must not call this method if any other copy of this iterator has been
        /// advanced with a call to its `next()` method.
        ///
        /// The following example shows how an iterator can be used explicitly to
        /// emulate a `for`-`in` loop. First, retrieve a sequence's iterator, and
        /// then call the iterator's `next()` method until it returns `nil`.
        ///
        ///     let numbers = [2, 3, 5, 7]
        ///     var numbersIterator = numbers.makeIterator()
        ///
        ///     while let num = numbersIterator.next() {
        ///         print(num)
        ///     }
        ///     // Prints "2"
        ///     // Prints "3"
        ///     // Prints "5"
        ///     // Prints "7"
        ///
        /// - Returns: The next element in the underlying sequence, if a next element
        ///   exists; otherwise, `nil`.
        public mutating func next() -> Date? { fatalError() }

        /// A type representing the sequence's elements.
        public typealias Element = Date

        /// A type that provides the sequence's iteration interface and
        /// encapsulates its iteration state.
        public typealias Iterator = EveryMinuteTimelineSchedule.Entries
    }

    /// Creates a per-minute update schedule.
    ///
    /// Use the ``EveryMinuteTimelineSchedule/entries(from:mode:)`` method
    /// to get the sequence of dates.
    public init() { fatalError() }

    /// Provides a sequence of per-minute dates starting from a given date.
    ///
    /// A ``TimelineView`` that you create with an every minute schedule
    /// calls this method to ask the schedule when to update its content.
    /// The method returns a sequence of per-minute dates in increasing
    /// order, from earliest to latest, that represents
    /// when the timeline view updates.
    ///
    /// For a `startDate` that's exactly minute-aligned, the
    /// schedule's sequence of dates starts at that time. Otherwise, it
    /// starts at the beginning of the specified minute. For
    /// example, for start dates of both `10:09:32` and `10:09:00`, the first
    /// entry in the sequence is `10:09:00`.
    ///
    /// - Parameters:
    ///   - startDate: The date from which the sequence begins.
    ///   - mode: The mode for the update schedule.
    /// - Returns: A sequence of per-minute dates in ascending order.
    public func entries(from startDate: Date, mode: TimelineScheduleMode) -> EveryMinuteTimelineSchedule.Entries { fatalError() }
}

/// A gesture that consists of two gestures where only one of them can succeed.
///
/// The `ExclusiveGesture` gives precedence to its first gesture.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct ExclusiveGesture<First, Second> : Gesture where First : Gesture, Second : Gesture {

    /// The value of an exclusive gesture that indicates which of two gestures
    /// succeeded.
    @frozen public enum Value {

        /// The first of two gestures succeeded.
        case first(First.Value)

        /// The second of two gestures succeeded.
        case second(Second.Value)
    }

    /// The first of two gestures.
    public var first: First { get { fatalError() } }

    /// The second of two gestures.
    public var second: Second { get { fatalError() } }

    /// Creates a gesture from two gestures where only one of them succeeds.
    ///
    /// - Parameters:
    ///   - first: The first of two gestures. This gesture has precedence over
    ///     the other gesture.
    ///   - second: The second of two gestures.
    @inlinable public init(_ first: First, _ second: Second) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ExclusiveGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ExclusiveGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {

    public static func == (a: ExclusiveGesture<First, Second>.Value, b: ExclusiveGesture<First, Second>.Value) -> Bool { fatalError() }
}

/// A schedule for updating a timeline view at explicit points in time.
///
/// You can also use ``TimelineSchedule/explicit(_:)`` to construct this
/// schedule.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ExplicitTimelineSchedule<Entries> : TimelineSchedule where Entries : Sequence, Entries.Element == Date {

    /// Creates a schedule composed of an explicit sequence of dates.
    ///
    /// Use the ``ExplicitTimelineSchedule/entries(from:mode:)`` method
    /// to get the sequence of dates.
    ///
    /// - Parameter dates: The sequence of dates at which a timeline view
    ///   updates. Use a monotonically increasing sequence of dates,
    ///   and ensure that at least one is in the future.
    public init(_ dates: Entries) { fatalError() }

    /// Provides the sequence of dates with which you initialized the schedule.
    ///
    /// A ``TimelineView`` that you create with a schedule calls this
    /// ``TimelineSchedule`` method to ask the schedule when to update its
    /// content. The explicit timeline schedule implementation
    /// of this method returns the unmodified sequence of dates that you
    /// provided when you created the schedule with
    /// ``TimelineSchedule/explicit(_:)``. As a result, this particular
    /// implementation ignores the `startDate` and `mode` parameters.
    ///
    /// - Parameters:
    ///   - startDate: The date from which the sequence begins. This
    ///     particular implementation of the protocol method ignores the start
    ///     date.
    ///   - mode: The mode for the update schedule. This particular
    ///     implementation of the protocol method ignores the mode.
    /// - Returns: The sequence of dates that you provided at initialization.
    public func entries(from startDate: Date, mode: TimelineScheduleMode) -> Entries { fatalError() }
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

/// A shape style that maps to one of the numbered content styles.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@frozen public struct HierarchicalShapeStyle : ShapeStyle {

    /// A shape style that maps to the first level of the current
    /// content style.
    public static let primary: HierarchicalShapeStyle = { fatalError() }()

    /// A shape style that maps to the second level of the current
    /// content style.
    public static let secondary: HierarchicalShapeStyle = { fatalError() }()

    /// A shape style that maps to the third level of the current
    /// content style.
    public static let tertiary: HierarchicalShapeStyle = { fatalError() }()

    /// A shape style that maps to the fourth level of the current
    /// content style.
    public static let quaternary: HierarchicalShapeStyle = { fatalError() }()

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

/// Styles that you can apply to hierarchical shapes.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@frozen public struct HierarchicalShapeStyleModifier<Base> : ShapeStyle where Base : ShapeStyle {

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

/// An alignment position along the horizontal axis.
///
/// Use horizontal alignment guides to tell SkipUI how to position views
/// relative to one another horizontally, like when you place views vertically
/// in an ``VStack``. The following example demonstrates common built-in
/// horizontal alignments:
///
/// ![Three columns of content. Each column contains a string
/// inside a box with a vertical line above and below the box. The
/// lines are aligned horizontally with the text in a different way for each
/// column. The lines for the left-most string, labeled Leading, align with
/// the left edge of the string. The lines for the middle string, labeled
/// Center, align with the center of the string. The lines for the right-most
/// string, labeled Trailing, align with the right edge of the
/// string.](HorizontalAlignment-1-iOS)
///
/// You can generate the example above by creating a series of columns
/// implemented as vertical stacks, where you configure each stack with a
/// different alignment guide:
///
///     private struct HorizontalAlignmentGallery: View {
///         var body: some View {
///             HStack(spacing: 30) {
///                 column(alignment: .leading, text: "Leading")
///                 column(alignment: .center, text: "Center")
///                 column(alignment: .trailing, text: "Trailing")
///             }
///             .frame(height: 150)
///         }
///
///         private func column(alignment: HorizontalAlignment, text: String) -> some View {
///             VStack(alignment: alignment, spacing: 0) {
///                 Color.red.frame(width: 1)
///                 Text(text).font(.title).border(.gray)
///                 Color.red.frame(width: 1)
///             }
///         }
///     }
///
/// During layout, SkipUI aligns the views inside each stack by bringing
/// together the specified guides of the affected views. SkipUI calculates
/// the position of a guide for a particular view based on the characteristics
/// of the view. For example, the ``HorizontalAlignment/center`` guide appears
/// at half the width of the view. You can override the guide calculation for a
/// particular view using the ``View/alignmentGuide(_:computeValue:)-9mdoh``
/// view modifier.
///
/// ### Layout direction
///
/// When a user configures their device to use a left-to-right language like
/// English, the system places the leading alignment on the left and the
/// trailing alignment on the right, as the example from the previous section
/// demonstrates. However, in a right-to-left language, the system reverses
/// these. You can see this by using the ``View/environment(_:_:)`` view
/// modifier to explicitly override the ``EnvironmentValues/layoutDirection``
/// environment value for the view defined above:
///
///     HorizontalAlignmentGallery()
///         .environment(\.layoutDirection, .rightToLeft)
///
/// ![Three columns of content. Each column contains a string
/// inside a box with a vertical line above and below the box. The
/// lines are aligned horizontally with the text in a different way for each
/// column. The lines for the left-most string, labeled Trailing, align with
/// the left edge of the string. The lines for the middle string, labeled
/// Center, align with the center of the string. The lines for the right-most
/// string, labeled Leading, align with the right edge of the
/// string.](HorizontalAlignment-2-iOS)
///
/// This automatic layout adjustment makes it easier to localize your app,
/// but it's still important to test your app for the different locales that
/// you ship into. For more information about the localization process, see
/// .
///
/// ### Custom alignment guides
///
/// You can create a custom horizontal alignment by creating a type that
/// conforms to the ``AlignmentID`` protocol, and then using that type to
/// initalize a new static property on `HorizontalAlignment`:
///
///     private struct OneQuarterAlignment: AlignmentID {
///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
///             context.width / 4
///         }
///     }
///
///     extension HorizontalAlignment {
///         static let oneQuarter = HorizontalAlignment(OneQuarterAlignment.self)
///     }
///
/// You implement the ``AlignmentID/defaultValue(in:)`` method to calculate
/// a default value for the custom alignment guide. The method receives a
/// ``ViewDimensions`` instance that you can use to calculate an appropriate
/// value based on characteristics of the view. The example above places
/// the guide at one quarter of the width of the view, as measured from the
/// view's origin.
///
/// You can then use the custom alignment guide like any built-in guide. For
/// example, you can use it as the `alignment` parameter to a ``VStack``,
/// or you can change it for a specific view using the
/// ``View/alignmentGuide(_:computeValue:)-9mdoh`` view modifier.
/// Custom alignment guides also automatically reverse in a right-to-left
/// environment, just like built-in guides.
///
/// ### Composite alignment
///
/// Combine a ``VerticalAlignment`` with a `HorizontalAlignment` to create a
/// composite ``Alignment`` that indicates both vertical and horizontal
/// positioning in one value. For example, you could combine your custom
/// `oneQuarter` horizontal alignment from the previous section with a built-in
/// ``VerticalAlignment/center`` vertical alignment to use in a ``ZStack``:
///
///     struct LayeredVerticalStripes: View {
///         var body: some View {
///             ZStack(alignment: Alignment(horizontal: .oneQuarter, vertical: .center)) {
///                 verticalStripes(color: .blue)
///                     .frame(width: 300, height: 150)
///                 verticalStripes(color: .green)
///                     .frame(width: 180, height: 80)
///             }
///         }
///
///         private func verticalStripes(color: Color) -> some View {
///             HStack(spacing: 1) {
///                 ForEach(0..<4) { _ in color }
///             }
///         }
///     }
///
/// The example above uses widths and heights that generate two mismatched sets
/// of four vertical stripes. The ``ZStack`` centers the two sets vertically and
/// aligns them horizontally one quarter of the way from the leading edge of
/// each set. In a left-to-right locale, this aligns the right edges of the
/// left-most stripes of each set:
///
/// ![Two sets of four rectangles. The first set is blue. The
/// second set is green, is smaller, and is layered on top of the first set.
/// The two sets are centered vertically, but align horizontally at the right
/// edge of each set's left-most rectangle.](HorizontalAlignment-3-iOS)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct HorizontalAlignment : Equatable {

    /// Creates a custom horizontal alignment of the specified type.
    ///
    /// Use this initializer to create a custom horizontal alignment. Define
    /// an ``AlignmentID`` type, and then use that type to create a new
    /// static property on ``HorizontalAlignment``:
    ///
    ///     private struct OneQuarterAlignment: AlignmentID {
    ///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
    ///             context.width / 4
    ///         }
    ///     }
    ///
    ///     extension HorizontalAlignment {
    ///         static let oneQuarter = HorizontalAlignment(OneQuarterAlignment.self)
    ///     }
    ///
    /// Every horizontal alignment instance that you create needs a unique
    /// identifier. For more information, see ``AlignmentID``.
    ///
    /// - Parameter id: The type of an identifier that uniquely identifies a
    ///   horizontal alignment.
    public init(_ id: AlignmentID.Type) { fatalError() }

    public static func == (a: HorizontalAlignment, b: HorizontalAlignment) -> Bool { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension HorizontalAlignment {

    /// Merges a sequence of explicit alignment values produced by
    /// this instance.
    ///
    /// For built-in horizontal alignment types, this method returns the mean
    /// of all non-`nil` values.
    public func combineExplicit<S>(_ values: S) -> CGFloat? where S : Sequence, S.Element == CGFloat? { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension HorizontalAlignment {

    /// A guide that marks the leading edge of the view.
    ///
    /// Use this guide to align the leading edges of views.
    /// For a device that uses a left-to-right language, the leading edge
    /// is on the left:
    ///
    /// ![A box that contains the word, Leading. Vertical
    /// lines appear above and below the box. The lines align horizontally
    /// with the left edge of the box.](HorizontalAlignment-leading-1-iOS)
    ///
    /// The following code generates the image above using a ``VStack``:
    ///
    ///     struct HorizontalAlignmentLeading: View {
    ///         var body: some View {
    ///             VStack(alignment: .leading, spacing: 0) {
    ///                 Color.red.frame(width: 1)
    ///                 Text("Leading").font(.title).border(.gray)
    ///                 Color.red.frame(width: 1)
    ///             }
    ///         }
    ///     }
    ///
    public static let leading: HorizontalAlignment = { fatalError() }()

    /// A guide that marks the horizontal center of the view.
    ///
    /// Use this guide to align the centers of views:
    ///
    /// ![A box that contains the word, Center. Vertical
    /// lines appear above and below the box. The lines align horizontally
    /// with the center of the box.](HorizontalAlignment-center-1-iOS)
    ///
    /// The following code generates the image above using a ``VStack``:
    ///
    ///     struct HorizontalAlignmentCenter: View {
    ///         var body: some View {
    ///             VStack(alignment: .center, spacing: 0) {
    ///                 Color.red.frame(width: 1)
    ///                 Text("Center").font(.title).border(.gray)
    ///                 Color.red.frame(width: 1)
    ///             }
    ///         }
    ///     }
    ///
    public static let center: HorizontalAlignment = { fatalError() }()

    /// A guide that marks the trailing edge of the view.
    ///
    /// Use this guide to align the trailing edges of views.
    /// For a device that uses a left-to-right language, the trailing edge
    /// is on the right:
    ///
    /// ![A box that contains the word, Trailing. Vertical
    /// lines appear above and below the box. The lines align horizontally
    /// with the right edge of the box.](HorizontalAlignment-trailing-1-iOS)
    ///
    /// The following code generates the image above using a ``VStack``:
    ///
    ///     struct HorizontalAlignmentTrailing: View {
    ///         var body: some View {
    ///             VStack(alignment: .trailing, spacing: 0) {
    ///                 Color.red.frame(width: 1)
    ///                 Text("Trailing").font(.title).border(.gray)
    ///                 Color.red.frame(width: 1)
    ///             }
    ///         }
    ///     }
    ///
    public static let trailing: HorizontalAlignment = { fatalError() }()
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension HorizontalAlignment {

    /// A guide marking the leading edge of a `List` row separator.
    ///
    /// Use this guide to align the leading end of the bottom `List` row
    /// separator with any other horizontal guide of a view that is part of the
    /// cell content.
    ///
    /// The following example shows the row separator aligned with the leading
    /// edge of the `Text` containing the name of food:
    ///
    ///     List {
    ///         ForEach(favoriteFoods) { food in
    ///             HStack {
    ///                 Text(food.emoji)
    ///                     .font(.system(size: 40))
    ///                 Text(food.name)
    ///                     .alignmentGuide(.listRowSeparatorLeading) {
    ///                         $0[.leading]
    ///                     }
    ///             }
    ///         }
    ///     }
    ///
    /// To change the visibility or tint of the row separator use respectively
    /// ``View/listRowSeparator(_:edges:)`` and
    /// ``View/listRowSeparatorTint(_:edges:)``.
    ///
    public static let listRowSeparatorLeading: HorizontalAlignment = { fatalError() }()

    /// A guide marking the trailing edge of a `List` row separator.
    ///
    /// Use this guide to align the trailing end of the bottom `List` row
    /// separator with any other horizontal guide of a view that is part of the
    /// cell content.
    ///
    /// To change the visibility or tint of the row separator use respectively
    /// ``View/listRowSeparator(_:edges:)`` and
    /// ``View/listRowSeparatorTint(_:edges:)``.
    ///
    public static let listRowSeparatorTrailing: HorizontalAlignment = { fatalError() }()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension HorizontalAlignment : Sendable {
}

/// An edge on the horizontal axis.
///
/// Use a horizontal edge for tasks like setting a swipe action with the
/// ``View/swipeActions(edge:allowsFullSwipe:content:)``
/// view modifier. The positions of the leading and trailing edges
/// depend on the locale chosen by the user.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@frozen public enum HorizontalEdge : Int8, CaseIterable, Codable {

    /// The leading edge.
    case leading

    /// The trailing edge.
    case trailing

    /// An efficient set of `HorizontalEdge`s.
    @frozen public struct Set : OptionSet {

        /// The element type of the option set.
        ///
        /// To inherit all the default implementations from the `OptionSet` protocol,
        /// the `Element` type must be `Self`, the default.
        public typealias Element = HorizontalEdge.Set

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

        /// A set containing only the leading horizontal edge.
        public static let leading: HorizontalEdge.Set = { fatalError() }()

        /// A set containing only the trailing horizontal edge.
        public static let trailing: HorizontalEdge.Set = { fatalError() }()

        /// A set containing the leading and trailing horizontal edges.
        public static let all: HorizontalEdge.Set = { fatalError() }()

        /// Creates an instance containing just `e`.
        public init(_ edge: HorizontalEdge) { fatalError() }

        /// The type of the elements of an array literal.
        public typealias ArrayLiteralElement = HorizontalEdge.Set.Element

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
    public typealias AllCases = [HorizontalEdge]

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int8

    /// A collection of all values of this type.
    public static var allCases: [HorizontalEdge] { get { fatalError() } }

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

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension HorizontalEdge : Equatable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension HorizontalEdge : Hashable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension HorizontalEdge : RawRepresentable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension HorizontalEdge : Sendable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension HorizontalEdge.Set : Sendable {
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

/// A shape type that is able to inset itself to produce another shape.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol InsettableShape : Shape {

    /// The type of the inset shape.
    associatedtype InsetShape : InsettableShape

    /// Returns `self` inset by `amount`.
    func inset(by amount: CGFloat) -> Self.InsetShape
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension InsettableShape {

    /// Returns a view that is the result of insetting `self` by
    /// `style.lineWidth / 2`, stroking the resulting shape with
    /// `style`, and then filling with `content`.
    @inlinable public func strokeBorder<S>(_ content: S, style: StrokeStyle, antialiased: Bool = true) -> some View where S : ShapeStyle { return never() }


    /// Returns a view that is the result of insetting `self` by
    /// `style.lineWidth / 2`, stroking the resulting shape with
    /// `style`, and then filling with the foreground color.
    @inlinable public func strokeBorder(style: StrokeStyle, antialiased: Bool = true) -> some View { return never() }


    /// Returns a view that is the result of filling the `lineWidth`-sized
    /// border (aka inner stroke) of `self` with `content`. This is
    /// equivalent to insetting `self` by `lineWidth / 2` and stroking the
    /// resulting shape with `lineWidth` as the line-width.
    @inlinable public func strokeBorder<S>(_ content: S, lineWidth: CGFloat = 1, antialiased: Bool = true) -> some View where S : ShapeStyle { return never() }


    /// Returns a view that is the result of filling the `lineWidth`-sized
    /// border (aka inner stroke) of `self` with the foreground color.
    /// This is equivalent to insetting `self` by `lineWidth / 2` and
    /// stroking the resulting shape with `lineWidth` as the line-width.
    @inlinable public func strokeBorder(lineWidth: CGFloat = 1, antialiased: Bool = true) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension InsettableShape {

    /// Returns a view that is the result of insetting `self` by
    /// `style.lineWidth / 2`, stroking the resulting shape with
    /// `style`, and then filling with `content`.
    public func strokeBorder<S>(_ content: S = .foreground, style: StrokeStyle, antialiased: Bool = true) -> StrokeBorderShapeView<Self, S, EmptyView> where S : ShapeStyle { fatalError() }

    /// Returns a view that is the result of filling the `lineWidth`-sized
    /// border (aka inner stroke) of `self` with `content`. This is
    /// equivalent to insetting `self` by `lineWidth / 2` and stroking the
    /// resulting shape with `lineWidth` as the line-width.
    public func strokeBorder<S>(_ content: S = .foreground, lineWidth: CGFloat = 1, antialiased: Bool = true) -> StrokeBorderShapeView<Self, S, EmptyView> where S : ShapeStyle { fatalError() }
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

/// A table row modifier that associates an item provider with some base
/// row content.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct ItemProviderTableRowModifier {

//    public var body: some _TableRowContentModifier { get { fatalError() } }

//    public typealias Body = some _TableRowContentModifier
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

/// A container that animates its content with keyframes.
///
/// The `content` closure updates every frame while
/// animating, so avoid performing any expensive operations directly within
/// `content`.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct KeyframeAnimator<Value, KeyframePath, Content> : View where Value == KeyframePath.Value, KeyframePath : Keyframes, Content : View {

    /// Plays the given keyframes when the given trigger value changes, updating
    /// the view using the modifiers you apply in `body`.
    ///
    /// Note that the `content` closure will be updated on every frame while
    /// animating, so avoid performing any expensive operations directly within
    /// `content`.
    ///
    /// If the trigger value changes while animating, the `keyframes` closure
    /// will be called with the current interpolated value, and the keyframes
    /// that you return define a new animation that replaces the old one. The
    /// previous velocity will be preserved, so cubic or spring keyframes will
    /// maintain continuity from the previous animation if they do not specify
    /// a custom initial velocity.
    ///
    /// When a keyframe animation finishes, the animator will remain at the
    /// end value, which becomes the initial value for the next animation.
    ///
    /// - Parameters:
    ///   - initialValue: The initial value that the keyframes will animate
    ///     from.
    ///   - trigger: A value to observe for changes.
    ///   - content: A view builder closure that takes the interpolated value
    ///     generated by the keyframes as its single argument.
    ///   - keyframes: Keyframes defining how the value changes over time. The
    ///     current value of the animator is the single argument, which is
    ///     equal to `initialValue` when the view first appears, then is equal
    ///     to the end value of the previous keyframe animation on subsequent
    ///     calls.
    public init(initialValue: Value, trigger: some Equatable, @ViewBuilder content: @escaping (Value) -> Content, @KeyframesBuilder<Value> keyframes: @escaping (Value) -> KeyframePath) { fatalError() }

    /// Loops the given keyframes continuously, updating
    /// the view using the modifiers you apply in `body`.
    ///
    /// Note that the `content` closure will be updated on every frame while
    /// animating, so avoid performing any expensive operations directly within
    /// `content`.
    ///
    /// - Parameters:
    ///   - initialValue: The initial value that the keyframes will animate
    ///     from.
    ///   - repeating: Whether the keyframes are currently repeating. If false,
    ///     the value at the beginning of the keyframe timeline will be
    ///     provided to the content closure.
    ///   - content: A view builder closure that takes the interpolated value
    ///     generated by the keyframes as its single argument.
    ///   - keyframes: Keyframes defining how the value changes over time. The
    ///     current value of the animator is the single argument, which is
    ///     equal to `initialValue` when the view first appears, then is equal
    ///     to the end value of the previous keyframe animation on subsequent
    ///     calls.
    public init(initialValue: Value, repeating: Bool = true, @ViewBuilder content: @escaping (Value) -> Content, @KeyframesBuilder<Value> keyframes: @escaping (Value) -> KeyframePath) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

/// A description of how a value changes over time, modeled using keyframes.
///
/// Unlike other animations in SkipUI (using ``Animation``), keyframes
/// don't interpolate between from and to values that SkipUI provides as
/// state changes. Instead, keyframes fully define the path that a value
/// takes over time using the tracks that make up their body.
///
/// `Keyframes` values are roughly analogous to video clips;
/// they have a set duration, and you can scrub and evaluate them for any
/// time within the duration.
///
/// The `Keyframes` structure also allows you to compute an interpolated
/// value at a specific time, which you can use when integrating keyframes
/// into custom use cases.
///
/// For example, you can use a `Keyframes` instance to define animations for a
/// type conforming to `Animatable:`
///
///     let keyframes = KeyframeTimeline(initialValue: CGPoint.zero) {
///         CubcKeyframe(.init(x: 0, y: 100), duration: 0.3)
///         CubicKeyframe(.init(x: 0, y: 0), duration: 0.7)
///     }
///
///     let value = keyframes.value(time: 0.45
///
/// For animations that involve multiple coordinated changes, you can include
/// multiple nested tracks:
///
///     struct Values {
///         var rotation = Angle.zero
///         var scale = 1.0
///     }
///
///     let keyframes = KeyframeTimeline(initialValue: Values()) {
///         KeyframeTrack(\.rotation) {
///             CubicKeyframe(.zero, duration: 0.2)
///             CubicKeyframe(.degrees(45), duration: 0.3)
///         }
///         KeyframeTrack(\.scale) {
///             CubicKeyframe(value: 1.2, duration: 0.5)
///             CubicKeyframe(value: 0.9, duration: 0.2)
///             CubicKeyframe(value: 1.0, duration: 0.3)
///         }
///     }
///
/// Multiple nested tracks update the initial value in the order that they are
/// declared. This means that if multiple nested plans change the same property
/// of the root value, the value from the last competing track will be used.
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct KeyframeTimeline<Value> {

    /// Creates a new instance using the initial value and content that you
    /// provide.
    public init(initialValue: Value, @KeyframesBuilder<Value> content: () -> some Keyframes<Value>) { fatalError() }

    /// The duration of the content in seconds.
    public var duration: TimeInterval { get { fatalError() } }

    /// Returns the interpolated value at the given time.
    public func value(time: Double) -> Value { fatalError() }

    /// Returns the interpolated value at the given progress in the range zero to one.
    public func value(progress: Double) -> Value { fatalError() }
}

/// A sequence of keyframes animating a single property of a root type.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct KeyframeTrack<Root, Value, Content> : Keyframes where Value == Content.Value, Content : KeyframeTrackContent {

    /// Creates an instance that animates the entire value from the root of the key path.
    ///
    /// - Parameter keyframes: A keyframe collection builder closure containing
    ///   the keyframes that control the interpolation curve.
    public init(@KeyframeTrackContentBuilder<Root> content: () -> Content) where Root == Value { fatalError() }

    /// Creates an instance that animates the property of the root value
    /// at the given key path.
    ///
    /// - Parameter keyPath: The property to animate.
    /// - Parameter keyframes: A keyframe collection builder closure containing
    ///   the keyframes that control the interpolation curve.
    public init(_ keyPath: WritableKeyPath<Root, Value>, @KeyframeTrackContentBuilder<Value> content: () -> Content) { fatalError() }

    /// The type of keyframes representing the body of this type.
    ///
    /// When you create a custom keyframes type, Swift infers this type from your
    /// implementation of the required
    /// ``Keyframes/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { return never() }
}

/// A group of keyframes that define an interpolation curve of an animatable
/// value.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol KeyframeTrackContent<Value> {

    associatedtype Value : Animatable = Self.Body.Value

    associatedtype Body : KeyframeTrackContent

    /// The composition of content that comprise the keyframe track.
//    @KeyframeTrackContentBuilder<Self.Value> var body: Self.Body { get }
}

/// The builder that creates keyframe track content from the keyframes
/// that you define within a closure.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@resultBuilder public struct KeyframeTrackContentBuilder<Value> where Value : Animatable {

    public static func buildExpression<K>(_ expression: K) -> K where Value == K.Value, K : KeyframeTrackContent { fatalError() }

//    public static func buildArray(_ components: [some KeyframeTrackContent<Value>]) -> some KeyframeTrackContent<Value> { return never() }


    public static func buildEither<First, Second>(first component: First) -> KeyframeTrackContentBuilder<Value>.Conditional<Value, First, Second> where Value == First.Value, First : KeyframeTrackContent, Second : KeyframeTrackContent, First.Value == Second.Value { fatalError() }

    public static func buildEither<First, Second>(second component: Second) -> KeyframeTrackContentBuilder<Value>.Conditional<Value, First, Second> where Value == First.Value, First : KeyframeTrackContent, Second : KeyframeTrackContent, First.Value == Second.Value { fatalError() }

    public static func buildPartialBlock<K>(first: K) -> K where Value == K.Value, K : KeyframeTrackContent { fatalError() }

//    public static func buildPartialBlock(accumulated: some KeyframeTrackContent<Value>, next: some KeyframeTrackContent<Value>) -> some KeyframeTrackContent<Value> { return never() }


    public static func buildBlock() -> Never { return never() }

}

extension KeyframeTrackContentBuilder {

    /// A conditional result from the result builder.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public struct Conditional<Value, First, Second> : KeyframeTrackContent where Value == First.Value, First : KeyframeTrackContent, Second : KeyframeTrackContent, First.Value == Second.Value {
        public typealias Value = Value
        public typealias Body = KeyframeTrackContentBuilder<Value>.Conditional<Value, First, Second>
        public var body: Body { fatalError() }
    }
}

/// A type that defines changes to a value over time.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol Keyframes<Value> {

    /// The type of value animated by this keyframes type
    associatedtype Value = Self.Body.Value

    /// The type of keyframes representing the body of this type.
    ///
    /// When you create a custom keyframes type, Swift infers this type from your
    /// implementation of the required
    /// ``Keyframes/body-swift.property`` property.
    associatedtype Body : Keyframes

    /// The composition of content that comprise the keyframes.
    @KeyframesBuilder<Self.Value> var body: Self.Body { get }
}

/// A builder that combines keyframe content values into a single value.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@resultBuilder public struct KeyframesBuilder<Value> {

    public static func buildExpression<K>(_ expression: K) -> K where Value == K.Value, K : KeyframeTrackContent { fatalError() }

//    public static func buildArray(_ components: [some KeyframeTrackContent<Value>]) -> some KeyframeTrackContent<Value> { fatalError() }


    public static func buildEither<First, Second>(first component: First) -> KeyframeTrackContentBuilder<Value>.Conditional<Value, First, Second> where Value == First.Value, First : KeyframeTrackContent, Second : KeyframeTrackContent, First.Value == Second.Value { fatalError() }

    public static func buildEither<First, Second>(second component: Second) -> KeyframeTrackContentBuilder<Value>.Conditional<Value, First, Second> where Value == First.Value, First : KeyframeTrackContent, Second : KeyframeTrackContent, First.Value == Second.Value { fatalError() }

    public static func buildPartialBlock<K>(first: K) -> K where Value == K.Value, K : KeyframeTrackContent { fatalError() }

//    public static func buildPartialBlock(accumulated: some KeyframeTrackContent<Value>, next: some KeyframeTrackContent<Value>) -> some KeyframeTrackContent<Value> { return never() }


    public static func buildBlock() -> Never where Value : Animatable { return never() }


    public static func buildFinalResult<Content>(_ component: Content) -> KeyframeTrack<Value, Value, Content> where Value == Content.Value, Content : KeyframeTrackContent { fatalError() }

    /// Keyframes
    public static func buildExpression<Content>(_ expression: Content) -> Content where Value == Content.Value, Content : Keyframes { fatalError() }

    public static func buildPartialBlock<Content>(first: Content) -> Content where Value == Content.Value, Content : Keyframes { fatalError() }

//    public static func buildPartialBlock(accumulated: some Keyframes<Value>, next: some Keyframes<Value>) -> some Keyframes<Value> { return never() }


//    public static func buildBlock() -> some Keyframes<Value> { return never() }


    public static func buildFinalResult<Content>(_ component: Content) -> Content where Value == Content.Value, Content : Keyframes { fatalError() }
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

/// A keyframe that uses simple linear interpolation.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct LinearKeyframe<Value> : KeyframeTrackContent where Value : Animatable {

    /// Creates a new keyframe using the given value and timestamp.
    ///
    /// - Parameters:
    ///   - to: The value of the keyframe.
    ///   - duration: The duration of the segment defined by this keyframe.
    ///   - timingCurve: A unit curve that controls the speed of interpolation.
    public init(_ to: Value, duration: TimeInterval, timingCurve: UnitCurve = .linear) { fatalError() }

    public typealias Value = Value
    public typealias Body = LinearKeyframe<Value>
    public var body: Body { fatalError() }
}

/// A progress view that visually indicates its progress using a horizontal bar.
///
/// Use ``ProgressViewStyle/linear`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct LinearProgressViewStyle : ProgressViewStyle {

    /// Creates a linear progress view style.
    public init() { fatalError() }

    /// Creates a linear progress view style with a tint color.
    @available(iOS, introduced: 14.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    @available(macOS, introduced: 11.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    @available(tvOS, introduced: 14.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    @available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use ``View/tint(_)`` instead.")
    public init(tint: Color) { fatalError() }

    /// Creates a view representing the body of a progress view.
    ///
    /// - Parameter configuration: The properties of the progress view being
    ///   created.
    ///
    /// The view hierarchy calls this method for each progress view where this
    /// style is the current progress view style.
    ///
    /// - Parameter configuration: The properties of the progress view, such as
    ///  its preferred progress type.
    public func makeBody(configuration: LinearProgressViewStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a progress view.
//    public typealias Body = some View
}

/// A control for navigating to a URL.
///
/// Create a link by providing a destination URL and a title. The title
/// tells the user the purpose of the link, and can be a string, a title
/// key that produces a localized string, or a view that acts as a label.
/// The example below creates a link to `example.com` and displays the
/// title string as a link-styled view:
///
///     Link("View Our Terms of Service",
///           destination: URL(string: "https://www.example.com/TOS.html")!)
///
/// When a user taps or clicks a `Link`, the default behavior depends on the
/// contents of the URL. For example, SkipUI opens a Universal Link in the
/// associated app if possible, or in the user's default web browser if not.
/// Alternatively, you can override the default behavior by setting the
/// ``EnvironmentValues/openURL`` environment value with a custom
/// ``OpenURLAction``:
///
///     Link("Visit Our Site", destination: URL(string: "https://www.example.com")!)
///         .environment(\.openURL, OpenURLAction { url in
///             print("Open \(url)")
///             return .handled
///         })
///
/// As with other views, you can style links using standard view modifiers
/// depending on the view type of the link's label. For example, a ``Text``
/// label could be modified with a custom ``View/font(_:)`` or
/// ``View/foregroundColor(_:)`` to customize the appearance of the link in
/// your app's UI.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct Link<Label> : View where Label : View {

    /// Creates a control, consisting of a URL and a label, used to navigate
    /// to the given URL.
    ///
    /// - Parameters:
    ///     - destination: The URL for the link.
    ///     - label: A view that describes the destination of URL.
    public init(destination: URL, @ViewBuilder label: () -> Label) { fatalError() }

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

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Link where Label == Text {

    /// Creates a control, consisting of a URL and a title key, used to
    /// navigate to a URL.
    ///
    /// Use ``Link`` to create a control that your app uses to navigate to a
    /// URL that you provide. The example below creates a link to
    /// `example.com` and uses `Visit Example Co` as the title key to
    /// generate a link-styled view in your app:
    ///
    ///     Link("Visit Example Co",
    ///           destination: URL(string: "https://www.example.com/")!)
    ///
    /// - Parameters:
    ///     - titleKey: The key for the localized title that describes the
    ///       purpose of this link.
    ///     - destination: The URL for the link.
    public init(_ titleKey: LocalizedStringKey, destination: URL) { fatalError() }

    /// Creates a control, consisting of a URL and a title string, used to
    /// navigate to a URL.
    ///
    /// Use ``Link`` to create a control that your app uses to navigate to a
    /// URL that you provide. The example below creates a link to
    /// `example.com` and displays the title string you provide as a
    /// link-styled view in your app:
    ///
    ///     func marketingLink(_ callToAction: String) -> Link {
    ///         Link(callToAction,
    ///             destination: URL(string: "https://www.example.com/")!)
    ///     }
    ///
    /// - Parameters:
    ///     - title: A text string used as the title for describing the
    ///       underlying `destination` URL.
    ///     - destination: The URL for the link.
    public init<S>(_ title: S, destination: URL) where S : StringProtocol { fatalError() }
}

/// A style appropriate for links.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@frozen public struct LinkShapeStyle : ShapeStyle {

    /// Creates a new link shape style instance.
    public init() { fatalError() }

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

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

/// The local coordinate space of the current view.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct LocalCoordinateSpace : CoordinateSpaceProtocol {

    public init() { fatalError() }

    /// The resolved coordinate space.
    public var coordinateSpace: CoordinateSpace { get { fatalError() } }
}

/// The key used to look up an entry in a strings file or strings dictionary
/// file.
///
/// Initializers for several SkipUI types -- such as ``Text``, ``Toggle``,
/// ``Picker`` and others --  implicitly look up a localized string when you
/// provide a string literal. When you use the initializer `Text("Hello")`,
/// SkipUI creates a `LocalizedStringKey` for you and uses that to look up a
/// localization of the `Hello` string. This works because `LocalizedStringKey`
/// conforms to
/// .
///
/// Types whose initializers take a `LocalizedStringKey` usually have
/// a corresponding initializer that accepts a parameter that conforms to
/// . Passing
/// a `String` variable to these initializers avoids localization, which is
/// usually appropriate when the variable contains a user-provided value.
///
/// As a general rule, use a string literal argument when you want
/// localization, and a string variable argument when you don't. In the case
/// where you want to localize the value of a string variable, use the string to
/// create a new `LocalizedStringKey` instance.
///
/// The following example shows how to create ``Text`` instances both
/// with and without localization. The title parameter provided to the
/// ``Section`` is a literal string, so SkipUI creates a
/// `LocalizedStringKey` for it. However, the string entries in the
/// `messageStore.today` array are `String` variables, so the ``Text`` views
/// in the list use the string values verbatim.
///
///     List {
///         Section(header: Text("Today")) {
///             ForEach(messageStore.today) { message in
///                 Text(message.title)
///             }
///         }
///     }
///
/// If the app is localized into Japanese with the following
/// translation of its `Localizable.strings` file:
///
/// ```other
/// "Today" = "今日";
/// ```
///
/// When run in Japanese, the example produces a
/// list like the following, localizing "Today" for the section header, but not
/// the list items.
///
/// ![A list with a single section header displayed in Japanese.
/// The items in the list are all in English: New for Monday, Account update,
/// and Server
/// maintenance.](SkipUI-LocalizedStringKey-Today-List-Japanese.png)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct LocalizedStringKey : Equatable, ExpressibleByStringInterpolation {

    /// Creates a localized string key from the given string value.
    ///
    /// - Parameter value: The string to use as a localization key.
    public init(_ value: String) { fatalError() }

    /// Creates a localized string key from the given string literal.
    ///
    /// - Parameter value: The string literal to use as a localization key.
    public init(stringLiteral value: String) { fatalError() }

    /// Creates a localized string key from the given string interpolation.
    ///
    /// To create a localized string key from a string interpolation, use
    /// the `\()` string interpolation syntax. Swift matches the parameter
    /// types in the expression to one of the `appendInterpolation` methods
    /// in ``LocalizedStringKey/StringInterpolation``. The interpolated
    /// types can include numeric values, Foundation types, and SkipUI
    /// ``Text`` and ``Image`` instances.
    ///
    /// The following example uses a string interpolation with two arguments:
    /// an unlabeled
    /// and a ``Text/DateStyle`` labeled `style`. The compiler maps these to the
    /// method
    /// ``LocalizedStringKey/StringInterpolation/appendInterpolation(_:style:)``
    /// as it builds the string that it creates the
    /// ``LocalizedStringKey`` with.
    ///
    ///     let key = LocalizedStringKey("Date is \(company.foundedDate, style: .offset)")
    ///     let text = Text(key) // Text contains "Date is +45 years"
    ///
    /// You can write this example more concisely, implicitly creating a
    /// ``LocalizedStringKey`` as the parameter to the ``Text``
    /// initializer:
    ///
    ///     let text = Text("Date is \(company.foundedDate, style: .offset)")
    ///
    /// - Parameter stringInterpolation: The string interpolation to use as the
    ///   localization key.
    public init(stringInterpolation: LocalizedStringKey.StringInterpolation) { fatalError() }

    /// Represents the contents of a string literal with interpolations
    /// while it’s being built, for use in creating a localized string key.
    public struct StringInterpolation : StringInterpolationProtocol {

        /// Creates an empty instance ready to be filled with string literal content.
        ///
        /// Don't call this initializer directly. Instead, initialize a variable or
        /// constant using a string literal with interpolated expressions.
        ///
        /// Swift passes this initializer a pair of arguments specifying the size of
        /// the literal segments and the number of interpolated segments. Use this
        /// information to estimate the amount of storage you will need.
        ///
        /// - Parameter literalCapacity: The approximate size of all literal segments
        ///   combined. This is meant to be passed to `String.reserveCapacity(_:)`;
        ///   it may be slightly larger or smaller than the sum of the counts of each
        ///   literal segment.
        /// - Parameter interpolationCount: The number of interpolations which will be
        ///   appended. Use this value to estimate how much additional capacity will
        ///   be needed for the interpolated segments.
        public init(literalCapacity: Int, interpolationCount: Int) { fatalError() }

        /// Appends a literal string.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameter literal: The literal string to append.
        public mutating func appendLiteral(_ literal: String) { fatalError() }

        /// Appends a literal string segment to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameter string: The literal string to append.
        public mutating func appendInterpolation(_ string: String) { fatalError() }

        /// Appends an optionally-formatted instance of a Foundation type
        /// to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameters:
        ///   - subject: The Foundation object to append.
        ///   - formatter: A formatter to convert `subject` to a string
        ///     representation.
        public mutating func appendInterpolation<Subject>(_ subject: Subject, formatter: Formatter? = nil) where Subject : ReferenceConvertible { fatalError() }

        /// Appends an optionally-formatted instance of an Objective-C subclass
        /// to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// The following example shows how to use a
            /// value and a
            /// to create a ``LocalizedStringKey`` that uses the formatter
        /// style
            /// when generating the measurement's string representation. Rather than
        /// calling `appendInterpolation(_:formatter)` directly, the code
        /// gets the formatting behavior implicitly by using the `\()`
        /// string interpolation syntax.
        ///
        ///     let siResistance = Measurement(value: 640, unit: UnitElectricResistance.ohms)
        ///     let formatter = MeasurementFormatter()
        ///     formatter.unitStyle = .long
        ///     let key = LocalizedStringKey ("Resistance: \(siResistance, formatter: formatter)")
        ///     let text1 = Text(key) // Text contains "Resistance: 640 ohms"
        ///
        /// - Parameters:
        ///   - subject: An 
        ///     to append.
        ///   - formatter: A formatter to convert `subject` to a string
        ///     representation.
        public mutating func appendInterpolation<Subject>(_ subject: Subject, formatter: Formatter? = nil) where Subject : NSObject { fatalError() }

        /// Appends the formatted representation  of a nonstring type
        /// supported by a corresponding format style.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// The following example shows how to use a string interpolation to
        /// format a
            /// with a
        ///  and
        /// append it to static text. The resulting interpolation implicitly
        /// creates a ``LocalizedStringKey``, which a ``Text`` uses to provide
        /// its content.
        ///
        ///     Text("The time is \(myDate, format: Date.FormatStyle(date: .omitted, time:.complete))")
        ///
        /// - Parameters:
        ///   - input: The instance to format and append.
        ///   - format: A format style to use when converting `input` into a string
        ///   representation.
        @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
        public mutating func appendInterpolation<F>(_ input: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String { fatalError() }

        /// Appends a type, convertible to a string by using a default format
        /// specifier, to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameters:
        ///   - value: A primitive type to append, such as
        ///     ,
        ///     , or
        ///     .
        public mutating func appendInterpolation<T>(_ value: T) where T : _FormatSpecifiable { fatalError() }

        /// Appends a type, convertible to a string with a format specifier,
        /// to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameters:
        ///   - value: The value to append.
        ///   - specifier: A format specifier to convert `subject` to a string
        ///     representation, like `%f`
        public mutating func appendInterpolation<T>(_ value: T, specifier: String) where T : _FormatSpecifiable { fatalError() }

        /// Appends the string displayed by a text view to a string
        /// interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameters:
        ///   - value: A ``Text`` instance to append.
        @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
        public mutating func appendInterpolation(_ text: Text) { fatalError() }

        /// Appends an attributed string to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// The following example shows how to use a string interpolation to
        /// format an
            /// and append it to static text. The resulting interpolation implicitly
        /// creates a ``LocalizedStringKey``, which a ``Text`` view uses to provide
        /// its content.
        ///
        ///     struct ContentView: View {
        ///
        ///         var nextDate: AttributedString {
        ///             var result = Calendar.current
        ///                 .nextWeekend(startingAfter: Date.now)!
        ///                 .start
        ///                 .formatted(
        ///                     .dateTime
        ///                     .month(.wide)
        ///                     .day()
        ///                     .attributed
        ///                 )
        ///             result.backgroundColor = .green
        ///             result.foregroundColor = .white
        ///             return result
        ///         }
        ///
        ///         var body: some View {
        ///             Text("Our next catch-up is on \(nextDate)!")
        ///         }
        ///     }
        ///
        /// For this example, assume that the app runs on a device set to a
        /// Russian locale, and has the following entry in a Russian-localized
        /// `Localizable.strings` file:
        ///
        ///     "Our next catch-up is on %@!" = "Наша следующая встреча состоится %@!";
        ///
        /// The attributed string `nextDate` replaces the format specifier
        /// `%@`,  maintaining its color and date-formatting attributes, when
        /// the ``Text`` view renders its contents:
        ///
        /// ![A text view with Russian text, ending with a date that uses white
        /// text on a green
        /// background.](LocalizedStringKey-AttributedString-Russian)
        ///
        /// - Parameter attributedString: The attributed string to append.
        @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
        public mutating func appendInterpolation(_ attributedString: AttributedString) { fatalError() }

        /// The type that should be used for literal segments.
        public typealias StringLiteralType = String
    }

    public static func == (a: LocalizedStringKey, b: LocalizedStringKey) -> Bool { fatalError() }

    /// A type that represents an extended grapheme cluster literal.
    ///
    /// Valid types for `ExtendedGraphemeClusterLiteralType` are `Character`,
    /// `String`, and `StaticString`.
    public typealias ExtendedGraphemeClusterLiteralType = String

    /// A type that represents a string literal.
    ///
    /// Valid types for `StringLiteralType` are `String` and `StaticString`.
    public typealias StringLiteralType = String

    /// A type that represents a Unicode scalar literal.
    ///
    /// Valid types for `UnicodeScalarLiteralType` are `Unicode.Scalar`,
    /// `Character`, `String`, and `StaticString`.
    public typealias UnicodeScalarLiteralType = String
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LocalizedStringKey.StringInterpolation {

    /// Appends an image to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameter image: The image to append.
    public mutating func appendInterpolation(_ image: Image) { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LocalizedStringKey.StringInterpolation {

    /// Appends a formatted date to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameters:
    ///   - date: The date to append.
    ///   - style: A predefined style to format the date with.
    public mutating func appendInterpolation(_ date: Date, style: Text.DateStyle) { fatalError() }

    /// Appends a date range to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameter dates: The closed range of dates to append.
    public mutating func appendInterpolation(_ dates: ClosedRange<Date>) { fatalError() }

    /// Appends a date interval to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameter interval: The date interval to append.
    public mutating func appendInterpolation(_ interval: DateInterval) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension LocalizedStringKey.StringInterpolation {

    /// Appends a timer interval to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameters:
    ///     - timerInterval: The interval between where to run the timer.
    ///     - pauseTime: If present, the date at which to pause the timer.
    ///         The default is `nil` which indicates to never pause.
    ///     - countsDown: Whether to count up or down. The default is `true`.
    ///     - showsHours: Whether to include an hours component if there are
    ///         more than 60 minutes left on the timer. The default is `true`.
    public mutating func appendInterpolation(timerInterval: ClosedRange<Date>, pauseTime: Date? = nil, countsDown: Bool = true, showsHours: Bool = true) { fatalError() }
}

extension LocalizedStringKey.StringInterpolation {

    /// Appends the localized string resource to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameters:
    ///   - value: The localized string resource to append.
    @available(iOS 16.0, macOS 13, tvOS 16.0, watchOS 9.0, *)
    public mutating func appendInterpolation(_ resource: LocalizedStringResource) { fatalError() }
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

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Material : ShapeStyle {

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

/// A control for presenting a menu of actions.
///
/// The following example presents a menu of three buttons and a submenu, which
/// contains three buttons of its own.
///
///     Menu("Actions") {
///         Button("Duplicate", action: duplicate)
///         Button("Rename", action: rename)
///         Button("Delete…", action: delete)
///         Menu("Copy") {
///             Button("Copy", action: copy)
///             Button("Copy Formatted", action: copyFormatted)
///             Button("Copy Library Path", action: copyPath)
///         }
///     }
///
/// You can create the menu's title with a ``LocalizedStringKey``, as seen in
/// the previous example, or with a view builder that creates multiple views,
/// such as an image and a text view:
///
///     Menu {
///         Button("Open in Preview", action: openInPreview)
///         Button("Save as PDF", action: saveAsPDF)
///     } label: {
///         Label("PDF", systemImage: "doc.fill")
///     }
///
/// ### Primary action
///
/// Menus can be created with a custom primary action. The primary action will
/// be performed when the user taps or clicks on the body of the control, and
/// the menu presentation will happen on a secondary gesture, such as on
/// long press or on click of the menu indicator. The following example creates
/// a menu that adds bookmarks, with advanced options that are presented in a
/// menu.
///
///     Menu {
///         Button(action: addCurrentTabToReadingList) {
///             Label("Add to Reading List", systemImage: "eyeglasses")
///         }
///         Button(action: bookmarkAll) {
///             Label("Add Bookmarks for All Tabs", systemImage: "book")
///         }
///         Button(action: show) {
///             Label("Show All Bookmarks", systemImage: "books.vertical")
///         }
///     } label: {
///         Label("Add Bookmark", systemImage: "book")
///     } primaryAction: {
///         addBookmark()
///     }
///
/// ### Styling menus
///
/// Use the ``View/menuStyle(_:)`` modifier to change the style of all menus
/// in a view. The following example shows how to apply a custom style:
///
///     Menu("Editing") {
///         Button("Set In Point", action: setInPoint)
///         Button("Set Out Point", action: setOutPoint)
///     }
///     .menuStyle(EditingControlsMenuStyle())
///
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct Menu<Label, Content> : View where Label : View, Content : View {

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

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension Menu {

    /// Creates a menu with a custom label.
    ///
    /// - Parameters:
    ///     - content: A group of menu items.
    ///     - label: A view describing the content of the menu.
    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates a menu that generates its label from a localized string key.
    ///
    /// - Parameters:
    ///     - titleKey: The key for the link's localized title, which describes
    ///         the contents of the menu.
    ///     - content: A group of menu items.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) where Label == Text { fatalError() }

    /// Creates a menu that generates its label from a string.
    ///
    /// To create the label with a localized string key, use
    /// ``Menu/init(_:content:)-7v768`` instead.
    ///
    /// - Parameters:
    ///     - title: A string that describes the contents of the menu.
    ///     - content: A group of menu items.
    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where Label == Text, S : StringProtocol { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension Menu {

    /// Creates a menu with a custom primary action and custom label.
    ///
    /// - Parameters:
    ///     - content: A group of menu items.
    ///     - label: A view describing the content of the menu.
    ///     - primaryAction: The action to perform on primary
    ///         interaction with the menu.
    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label, primaryAction: @escaping () -> Void) { fatalError() }

    /// Creates a menu with a custom primary action that generates its label
    /// from a localized string key.
    ///
    /// - Parameters:
    ///     - titleKey: The key for the link's localized title, which describes
    ///         the contents of the menu.
    ///     - primaryAction: The action to perform on primary
    ///         interaction with the menu.
    ///     - content: A group of menu items.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content, primaryAction: @escaping () -> Void) where Label == Text { fatalError() }

    /// Creates a menu with a custom primary action that generates its label
    /// from a string.
    ///
    /// To create the label with a localized string key, use
    /// `Menu(_:primaryAction:content:)` instead.
    ///
    /// - Parameters:
    ///     - title: A string that describes the contents of the menu.
    ///     - primaryAction: The action to perform on primary
    ///         interaction with the menu.
    ///     - content: A group of menu items.
    public init<S>(_ title: S, @ViewBuilder content: () -> Content, primaryAction: @escaping () -> Void) where Label == Text, S : StringProtocol { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension Menu where Label == MenuStyleConfiguration.Label, Content == MenuStyleConfiguration.Content {

    /// Creates a menu based on a style configuration.
    ///
    /// Use this initializer within the ``MenuStyle/makeBody(configuration:)``
    /// method of a ``MenuStyle`` instance to create an instance of the menu
    /// being styled. This is useful for custom menu styles that modify the
    /// current menu style.
    ///
    /// For example, the following code creates a new, custom style that adds a
    /// red border around the current menu style:
    ///
    ///     struct RedBorderMenuStyle: MenuStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             Menu(configuration)
    ///                 .border(Color.red)
    ///         }
    ///     }
    ///
    public init(_ configuration: MenuStyleConfiguration) { fatalError() }
}

/// The set of menu dismissal behavior options.
///
/// Configure the menu dismissal behavior for a view hierarchy using the
/// ``View/menuActionDismissBehavior(_:)`` view modifier.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct MenuActionDismissBehavior : Equatable {

    /// Use the a dismissal behavior that's appropriate for the given context.
    ///
    /// In most cases, the default behavior is ``enabled``. There are some
    /// cases, like ``Stepper``, that use ``disabled`` by default.
    public static let automatic: MenuActionDismissBehavior = { fatalError() }()

    /// Always dismiss the presented menu after performing an action.
    public static let enabled: MenuActionDismissBehavior = { fatalError() }()

    /// Never dismiss the presented menu after performing an action.
    @available(tvOS 17.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public static let disabled: MenuActionDismissBehavior = { fatalError() }()

    public static func == (a: MenuActionDismissBehavior, b: MenuActionDismissBehavior) -> Bool { fatalError() }
}

/// A control group style that presents its content as a menu when the user
/// presses the control, or as a submenu when nested within a larger menu.
///
/// Use ``ControlGroupStyle/menu`` to construct this style.
@available(iOS 16.4, macOS 13.3, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct MenuControlGroupStyle : ControlGroupStyle {

    /// Creates a menu control group style.
    public init() { fatalError() }

    /// Creates a view representing the body of a control group.
    ///
    /// - Parameter configuration: The properties of the control group instance
    ///   being created.
    ///
    /// This method will be called for each instance of ``ControlGroup`` created
    /// within a view hierarchy where this style is the current
    /// `ControlGroupStyle`.
    @MainActor public func makeBody(configuration: MenuControlGroupStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a control group.
//    public typealias Body = some View
}

/// The order in which a menu presents its content.
///
/// You can configure the preferred menu order using the
/// ``View/menuOrder(_:)`` view modifier.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct MenuOrder : Equatable, Hashable, Sendable {

    /// The ordering of the menu chosen by the system for the current context.
    ///
    /// On iOS, this order resolves to ``fixed`` for menus
    /// presented within scrollable content. Pickers that use the
    /// ``PickerStyle/menu`` style also default to ``fixed`` order. In all
    /// other cases, menus default to ``priority`` order.
    ///
    /// On macOS, tvOS and watchOS, the `automatic` order always resolves to
    /// ``fixed`` order.
    public static let automatic: MenuOrder = { fatalError() }()

    /// Keep the first items closest to user's interaction point.
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let priority: MenuOrder = { fatalError() }()

    /// Order items from top to bottom.
    public static let fixed: MenuOrder = { fatalError() }()

    public static func == (a: MenuOrder, b: MenuOrder) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// A picker style that presents the options as a menu when the user presses a
/// button, or as a submenu when nested within a larger menu.
///
/// You can also use ``PickerStyle/menu`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct MenuPickerStyle : PickerStyle {

    /// Creates a menu picker style.
    public init() { fatalError() }
}

/// A type that applies standard interaction behavior and a custom appearance
/// to all menus within a view hierarchy.
///
/// To configure the current menu style for a view hierarchy, use the
/// ``View/menuStyle(_:)`` modifier.
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public protocol MenuStyle {

    /// A view that represents the body of a menu.
    associatedtype Body : View

    /// Creates a view that represents the body of a menu.
    ///
    /// - Parameter configuration: The properties of the menu.
    ///
    /// The system calls this method for each ``Menu`` instance in a view
    /// hierarchy where this style is the current menu style.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a menu.
    typealias Configuration = MenuStyleConfiguration
}

@available(iOS, introduced: 14.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(macOS, introduced: 11.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(tvOS, introduced: 17.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
extension MenuStyle where Self == BorderlessButtonMenuStyle {

    /// A menu style that displays a borderless button that toggles the display of
    /// the menu's contents when pressed.
    ///
    /// On macOS, the button optionally displays an arrow indicating that it
    /// presents a menu.
    ///
    /// Pressing and then dragging into the contents triggers the chosen action on
    /// release.
    public static var borderlessButton: BorderlessButtonMenuStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension MenuStyle where Self == DefaultMenuStyle {

    /// The default menu style, based on the menu's context.
    ///
    /// The default menu style can vary by platform. By default, macOS uses the
    /// bordered button style.
    ///
    /// If you create a menu inside a container, the style resolves to the
    /// recommended style for menus inside that container for that specific
    /// platform. For example, a menu nested within another menu will resolve to
    /// a submenu:
    ///
    ///     Menu("Edit") {
    ///         Menu("Arrange") {
    ///             Button("Bring to Front", action: moveSelectionToFront)
    ///             Button("Send to Back", action: moveSelectionToBack)
    ///         }
    ///         Button("Delete", action: deleteSelection)
    ///     }
    ///
    /// You can override a menu's style. To apply the default style to a menu,
    /// or to a view that contains a menu, use the ``View/menuStyle(_:)``
    /// modifier.
    public static var automatic: DefaultMenuStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension MenuStyle where Self == ButtonMenuStyle {

    /// A menu style that displays a button that toggles the display of
    /// the menu's contents when pressed.
    ///
    /// On macOS, the button displays an arrow to indicate that it presents a
    /// menu.
    ///
    /// Pressing and then dragging into the contents activates the selected
    /// action on release.
    public static var button: ButtonMenuStyle { get { fatalError() } }
}

/// A configuration of a menu.
///
/// Use the ``Menu/init(_:)`` initializer of ``Menu`` to create an
/// instance using the current menu style, which you can modify to create a
/// custom style.
///
/// For example, the following code creates a new, custom style that adds a red
/// border to the current menu style:
///
///     struct RedBorderMenuStyle: MenuStyle {
///         func makeBody(configuration: Configuration) -> some View {
///             Menu(configuration)
///                 .border(Color.red)
///         }
///     }
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct MenuStyleConfiguration {

    /// A type-erased label of a menu.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A type-erased content of a menu.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }
}

/// A value with a modifier applied to it.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct ModifiedContent<Content, Modifier> {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never

    /// The content that the modifier transforms into a new view or new
    /// view modifier.
    public var content: Content { get { fatalError() } }

    /// The view modifier.
    public var modifier: Modifier { get { fatalError() } }

    /// A structure that the defines the content and modifier needed to produce
    /// a new view or view modifier.
    ///
    /// If `content` is a ``View`` and `modifier` is a ``ViewModifier``, the
    /// result is a ``View``. If `content` and `modifier` are both view
    /// modifiers, then the result is a new ``ViewModifier`` combining them.
    ///
    /// - Parameters:
    ///     - content: The content that the modifier changes.
    ///     - modifier: The modifier to apply to the content.
    @inlinable public init(content: Content, modifier: Modifier) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a `.default` action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction(_ actionKind: AccessibilityActionKind = .default, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a custom action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction(named: Text("New Message")) {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction(named name: Text, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a custom action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction(named: "New Message") {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction(named nameKey: LocalizedStringKey, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a custom action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction(named: "New Message") {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction<S>(named name: S, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier> where S : StringProtocol { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent : Equatable where Content : Equatable, Modifier : Equatable {

    public static func == (a: ModifiedContent<Content, Modifier>, b: ModifiedContent<Content, Modifier>) -> Bool { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent : View where Content : View, Modifier : ViewModifier {

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
    @MainActor public var body: ModifiedContent<Content, Modifier>.Body { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent : ViewModifier where Content : ViewModifier, Modifier : ViewModifier {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent : DynamicViewContent where Content : DynamicViewContent, Modifier : ViewModifier {

    /// The collection of underlying data.
    public var data: Content.Data { get { fatalError() } }

    /// The type of the underlying collection of data.
    public typealias Data = Content.Data
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example, `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter key: Key used to specify the identifier and label of the
    ///   of the additional accessibility information entry.
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape." A value of `nil` will remove
    ///   any entry of additional information added earlier for any `key` with
    ///   the same identifier.
    /// - Note: Repeated calls of `accessibilityCustomContent` with `key`s
    ///   having different identifiers will create new entries of
    ///   additional information.
    ///   Calling `accessibilityAdditionalContent` repeatedly with `key`s
    ///   having matching identifiers will replace the previous entry.
    public func accessibilityCustomContent(_ key: AccessibilityCustomContentKey, _ value: Text?, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example, `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter key: Key used to specify the identifier and label of the
    ///   of the additional accessibility information entry.
    /// - Parameter valueKey: Text value for the additional accessibility
    ///   information. For example: "landscape." A value of `nil` will remove
    ///   any entry of additional information added earlier for any `key` with
    ///   the same identifier.
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with `key`s
    ///   having different identifiers will create new entries of
    ///   additional information.
    ///   Calling `accessibilityAdditionalContent` repeatedly with `key`s
    ///   having matching identifiers will replace the previous entry.
    public func accessibilityCustomContent(_ key: AccessibilityCustomContentKey, _ valueKey: LocalizedStringKey, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example, `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter key: Key used to specify the identifier and label of the
    ///   of the additional accessibility information entry.
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape." A value of `nil` will remove
    ///   any entry of additional information added earlier for any `key` with
    ///   the same identifier.
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with `key`s
    ///   having different identifiers will create new entries of
    ///   additional information.
    ///   Calling `accessibilityAdditionalContent` repeatedly with `key`s
    ///   having matching identifiers will replace the previous entry.
    public func accessibilityCustomContent<V>(_ key: AccessibilityCustomContentKey, _ value: V, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> where V : StringProtocol { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example: `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter label: Localized text describing to the user what
    ///   is contained in this additional information entry. For example:
    ///   "orientation".
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape."
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with different
    ///   labels will create new entries of additional information. Calling
    ///   `accessibilityAdditionalContent` repeatedly with the same label will
    ///   instead replace the previous value and importance.
    public func accessibilityCustomContent(_ label: Text, _ value: Text, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example: `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter label: Localized text describing to the user what
    ///   is contained in this additional information entry. For example:
    ///   "orientation".
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape."
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with different
    ///   labels will create new entries of additional information. Calling
    ///   `accessibilityAdditionalContent` repeatedly with the same label will
    ///   instead replace the previous value and importance.
    public func accessibilityCustomContent(_ labelKey: LocalizedStringKey, _ value: Text, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example, `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter labelKey: Localized text describing to the user what
    ///   is contained in this additional information entry. For example:
    ///   "orientation".
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape."
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with different
    ///   labels will create new entries of additional information. Calling
    ///   `accessibilityAdditionalContent` repeatedly with the same label will
    ///   instead replace the previous value and importance.
    public func accessibilityCustomContent(_ labelKey: LocalizedStringKey, _ valueKey: LocalizedStringKey, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example, `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter labelKey: Localized text describing to the user what
    ///   is contained in this additional information entry. For example:
    ///   "orientation".
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape."
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with different
    ///   labels will create new entries of additional information. Calling
    ///   `accessibilityAdditionalContent` repeatedly with the same label will
    ///   instead replace the previous value and importance.
    public func accessibilityCustomContent<V>(_ labelKey: LocalizedStringKey, _ value: V, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> where V : StringProtocol { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Uses the string you specify to identify the view.
    ///
    /// Use this value for testing. It isn't visible to the user.
    public func accessibilityIdentifier(_ identifier: String) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds an accessibility zoom action to the view. Actions allow
    /// assistive technologies, such as VoiceOver, to interact with the
    /// view by invoking the action.
    ///
    /// For example, this is how a zoom action is used to transform the scale
    /// of a shape which has a `MagnificationGesture`.
    ///
    ///     var body: some View {
    ///         Circle()
    ///             .scaleEffect(magnifyBy)
    ///             .gesture(magnification)
    ///             .accessibilityLabel("Circle Magnifier")
    ///             .accessibilityZoomAction { action in
    ///                 switch action.direction {
    ///                 case .zoomIn:
    ///                     magnifyBy += 0.5
    ///                 case .zoomOut:
    ///                      magnifyBy -= 0.5
    ///                 }
    ///             }
    ///     }
    ///
    public func accessibilityZoomAction(_ handler: @escaping (AccessibilityZoomGestureAction) -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    public func accessibilityLabel(_ label: Text) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    public func accessibilityLabel(_ labelKey: LocalizedStringKey) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    public func accessibilityLabel<S>(_ label: S) -> ModifiedContent<Content, Modifier> where S : StringProtocol { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Specifies whether to hide this view from system accessibility features.
    public func accessibilityHidden(_ hidden: Bool) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Explicitly set whether this accessibility element is a direct touch
    /// area. Direct touch areas passthrough touch events to the app rather
    /// than being handled through an assistive technology, such as VoiceOver.
    /// The modifier accepts an optional `AccessibilityDirectTouchOptions`
    /// option set to customize the functionality of the direct touch area.
    ///
    /// For example, this is how a direct touch area would allow a VoiceOver
    /// user to interact with a view with a `rotationEffect` controlled by a
    /// `RotationGesture`. The direct touch area would require a user to
    /// activate the area before using the direct touch area.
    ///
    ///     var body: some View {
    ///         Rectangle()
    ///             .frame(width: 200, height: 200, alignment: .center)
    ///             .rotationEffect(angle)
    ///             .gesture(rotation)
    ///             .accessibilityDirectTouch(options: .requiresActivation)
    ///     }
    ///
    public func accessibilityDirectTouch(_ isDirectTouchArea: Bool = true, options: AccessibilityDirectTouchOptions = []) -> ModifiedContent<Content, Modifier> { fatalError() }
}

//@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//extension ModifiedContent : Scene where Content : Scene, Modifier : _SceneModifier {
//
//    /// The content and behavior of the scene.
//    ///
//    /// For any scene that you create, provide a computed `body` property that
//    /// defines the scene as a composition of other scenes. You can assemble a
//    /// scene from built-in scenes that SkipUI provides, as well as other
//    /// scenes that you've defined.
//    ///
//    /// Swift infers the scene's ``SkipUI/Scene/Body-swift.associatedtype``
//    /// associated type based on the contents of the `body` property.
//    @MainActor public var body: ModifiedContent<Content, Modifier>.Body { get { fatalError() } }
//}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Explicitly set whether this Accessibility element responds to user
    /// interaction and would thus be interacted with by technologies such as
    /// Switch Control, Voice Control or Full Keyboard Access.
    ///
    /// If this is not set, the value is inferred from the traits of the
    /// Accessibility element, the presence of Accessibility actions on the
    /// element, or the presence of gestures on the element or containing views.
    public func accessibilityRespondsToUserInteraction(_ respondsToUserInteraction: Bool = true) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// The activation point for an element is the location
    /// assistive technologies use to initiate gestures.
    ///
    /// Use this modifier to ensure that the activation point for a
    /// small element remains accurate even if you present a larger
    /// version of the element to VoiceOver.
    ///
    /// If an activation point is not provided, an activation point
    /// will be derrived from one of the accessibility elements
    /// decendents or from the center of the accessibility frame.
    public func accessibilityActivationPoint(_ activationPoint: CGPoint) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// The activation point for an element is the location
    /// assistive technologies use to initiate gestures.
    ///
    /// Use this modifier to ensure that the activation point for a
    /// small element remains accurate even if you present a larger
    /// version of the element to VoiceOver.
    ///
    /// If an activation point is not provided, an activation point
    /// will be derrived from one of the accessibility elements
    /// decendents or from the center of the accessibility frame.
    public func accessibilityActivationPoint(_ activationPoint: UnitPoint) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    ///
    /// > Note: On macOS, if the view does not have an action and it has been
    ///   made into a container with ``accessibilityElement(children: .contain)``,
    ///   this will be used to describe the container. For example, if the container is
    ///   for a graph, the hint could be "graph".
    public func accessibilityHint(_ hint: Text) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// If you don't specify any input labels, the user can still refer to the view using the accessibility
    /// label that you add with the accessibilityLabel() modifier. Provide labels in descending order
    /// of importance. Voice Control and Full Keyboard Access use the input labels.
    public func accessibilityInputLabels(_ inputLabels: [Text]) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    public func accessibilityHint(_ hintKey: LocalizedStringKey) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    public func accessibilityHint<S>(_ hint: S) -> ModifiedContent<Content, Modifier> where S : StringProtocol { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   `accessibilityLabel()` modifier.
    public func accessibilityInputLabels(_ inputLabelKeys: [LocalizedStringKey]) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   `accessibilityLabel()` modifier.
    public func accessibilityInputLabels<S>(_ inputLabels: [S]) -> ModifiedContent<Content, Modifier> where S : StringProtocol { fatalError() }
}

extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Specifies whether to hide this view from system accessibility features.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    public func accessibility(hidden: Bool) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    public func accessibility(label: Text) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    public func accessibility(hint: Text) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// If you don't specify any input labels, the user can still refer to the view using the accessibility
    /// label that you add with the accessibilityLabel() modifier. Provide labels in descending order
    /// of importance. Voice Control and Full Keyboard Access use the input labels.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    public func accessibility(inputLabels: [Text]) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Uses the specified string to identify the view.
    ///
    /// Use this value for testing. It isn't visible to the user.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    public func accessibility(identifier: String) -> ModifiedContent<Content, Modifier> { fatalError() }

    @available(iOS, deprecated, introduced: 13.0)
    @available(macOS, deprecated, introduced: 10.15)
    @available(tvOS, deprecated, introduced: 13.0)
    @available(watchOS, deprecated, introduced: 6)
    @available(xrOS, introduced: 1.0, deprecated: 1.0)
    public func accessibility(selectionIdentifier: AnyHashable) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Sets the sort priority order for this view's accessibility
    /// element, relative to other elements at the same level.
    ///
    /// Higher numbers are sorted first. The default sort priority is zero.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    public func accessibility(sortPriority: Double) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Specifies the point where activations occur in the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    public func accessibility(activationPoint: CGPoint) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Specifies the unit point where activations occur in the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    public func accessibility(activationPoint: UnitPoint) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Sets the sort priority order for this view's accessibility
    /// element, relative to other elements at the same level.
    ///
    /// Higher numbers are sorted first. The default sort priority is zero.
    public func accessibilitySortPriority(_ sortPriority: Double) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds the given traits to the view.
    public func accessibilityAddTraits(_ traits: AccessibilityTraits) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Removes the given traits from this view.
    public func accessibilityRemoveTraits(_ traits: AccessibilityTraits) -> ModifiedContent<Content, Modifier> { fatalError() }
}

extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds the given traits to the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    public func accessibility(addTraits traits: AccessibilityTraits) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Removes the given traits from this view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    public func accessibility(removeTraits traits: AccessibilityTraits) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds an accessibility scroll action to the view. Actions allow
    /// assistive technologies, such as the VoiceOver, to interact with the
    /// view by invoking the action.
    ///
    /// For example, this is how a scroll action to trigger
    /// a refresh could be added to a view.
    ///
    ///     var body: some View {
    ///         ScrollView {
    ///             ContentView()
    ///         }
    ///         .accessibilityScrollAction { edge in
    ///             if edge == .top {
    ///                 // Refresh content
    ///             }
    ///         }
    ///     }
    ///
    public func accessibilityScrollAction(_ handler: @escaping (Edge) -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }
}

//@available(iOS 16.0, macOS 12.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension ModifiedContent : TableRowContent where Content : TableRowContent, Modifier : _TableRowContentModifier {
//
//    /// The type of value represented by this table row content.
//    public typealias TableRowValue = Content.TableRowValue
//
//    /// The type of content representing the body of this table row content.
//    public typealias TableRowBody = Never
//
//    /// The composition of content that comprise the table row content.
//    public var tableRowBody: Never { get { fatalError() } }
//}

//@available(iOS 16.0, macOS 12.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension ModifiedContent : DynamicTableRowContent where Content : DynamicTableRowContent, Modifier : _TableRowContentModifier {
//
//    /// The collection of underlying data.
//    public var data: Content.Data { get { fatalError() } }
//
//    /// The type of the underlying collection of data.
//    public typealias Data = Content.Data
//}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds an accessibility adjustable action to the view. Actions allow
    /// assistive technologies, such as the VoiceOver, to interact with the
    /// view by invoking the action.
    ///
    /// For example, this is how an adjustable action to navigate
    /// through pages could be added to a view.
    ///
    ///     var body: some View {
    ///         PageControl()
    ///             .accessibilityAdjustableAction { direction in
    ///                 switch direction {
    ///                 case .increment:
    ///                     // Go to next page
    ///                 case .decrement:
    ///                     // Go to previous page
    ///                 }
    ///             }
    ///     }
    ///
    public func accessibilityAdjustableAction(_ handler: @escaping (AccessibilityAdjustmentDirection) -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Sets an accessibility text content type.
    ///
    /// Use this modifier to set the content type of this accessibility
    /// element. Assistive technologies can use this property to choose
    /// an appropriate way to output the text. For example, when
    /// encountering a source coding context, VoiceOver could
    /// choose to speak all punctuation.
    ///
    /// The default content type ``AccessibilityTextContentType/plain``.
    ///
    /// - Parameter value: The accessibility content type from the available
    /// ``AccessibilityTextContentType`` options.
    public func accessibilityTextContentType(_ textContentType: AccessibilityTextContentType) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Set the level of this heading.
    ///
    /// Use this modifier to set the level of this heading in relation to other headings. The system speaks
    ///  the level number of levels ``AccessibilityHeadingLevel/h1``
    ///  through ``AccessibilityHeadingLevel/h6`` alongside the text.
    ///
    /// The default heading level if you don’t use this modifier
    /// is ``AccessibilityHeadingLevel/unspecified``.
    ///
    /// - Parameter level: The heading level to associate with this element
    ///   from the available ``AccessibilityHeadingLevel`` levels.
    public func accessibilityHeading(_ level: AccessibilityHeadingLevel) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue(_ valueDescription: Text) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue(_ valueKey: LocalizedStringKey) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue<S>(_ value: S) -> ModifiedContent<Content, Modifier> where S : StringProtocol { fatalError() }
}

extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibility(label:),
    /// you can provide the current volume setting, like "60%", using accessibility(value:).
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    public func accessibility(value: Text) -> ModifiedContent<Content, Modifier> { fatalError() }
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

/// A control for picking multiple dates.
///
/// Use a `MultiDatePicker` when you want to provide a view that allows the
/// user to select multiple dates.
///
/// The following example creates a basic `MultiDatePicker`, which appears as a
/// calendar view representing the selected dates:
///
///     @State private var dates: Set<DateComponents> = []
///
///     var body: some View {
///         MultiDatePicker("Dates Available", selection: $dates)
///     }
///
/// You can limit the `MultiDatePicker` to specific ranges of dates
/// allowing selections only before or after a certain date or between two
/// dates. The following example shows a multi-date picker that only permits
/// selections within the 6th and (excluding) the 16th of December 2021
/// (in the `UTC` time zone):
///
///     @Environment(\.calendar) var calendar
///     @Environment(\.timeZone) var timeZone
///
///     var bounds: Range<Date> {
///         let start = calendar.date(from: DateComponents(
///             timeZone: timeZone, year: 2022, month: 6, day: 6))!
///         let end = calendar.date(from: DateComponents(
///             timeZone: timeZone, year: 2022, month: 6, day: 16))!
///         return start ..< end
///     }
///
///     @State private var dates: Set<DateComponents> = []
///
///     var body: some View {
///         MultiDatePicker("Dates Available", selection: $dates, in: bounds)
///     }
///
/// You can also specify an alternative locale, calendar and time zone through
/// environment values. This can be useful when using a ``PreviewProvider`` to
/// see how your multi-date picker behaves in environments that differ from
/// your own.
///
/// The following example shows a multi-date picker with a custom locale,
/// calendar and time zone:
///
///     struct ContentView_Previews: PreviewProvider {
///         static var previews: some View {
///             MultiDatePicker("Dates Available", selection: .constant([]))
///                 .environment(\.locale, Locale.init(identifier: "zh"))
///                 .environment(
///                     \.calendar, Calendar.init(identifier: .chinese))
///                 .environment(\.timeZone, TimeZone(abbreviation: "HKT")!)
///         }
///     }
///
@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MultiDatePicker<Label> : View where Label : View {

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

@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension MultiDatePicker {

    /// Creates an instance that selects multiple dates with an unbounded
    /// range.
    ///
    /// - Parameters:
    ///   - selection: The date values being displayed and selected.
    ///   - label: A view that describes the use of the dates.
    public init(selection: Binding<Set<DateComponents>>, @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates an instance that selects multiple dates in a range.
    ///
    /// - Parameters:
    ///   - selection: The date values being displayed and selected.
    ///   - bounds: The exclusive range of selectable dates.
    ///   - label: A view that describes the use of the dates.
    public init(selection: Binding<Set<DateComponents>>, in bounds: Range<Date>, @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates an instance that selects multiple dates on or after some
    /// start date.
    ///
    /// - Parameters:
    ///   - selection: The date values being displayed and selected.
    ///   - bounds: The open range from some selectable start date.
    ///   - label: A view that describes the use of the dates.
    public init(selection: Binding<Set<DateComponents>>, in bounds: PartialRangeFrom<Date>, @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates an instance that selects multiple dates before some end date.
    ///
    /// - Parameters:
    ///   - selection: The date values being displayed and selected.
    ///   - bounds: The open range before some end date.
    ///   - label: A view that describes the use of the dates.
    public init(selection: Binding<Set<DateComponents>>, in bounds: PartialRangeUpTo<Date>, @ViewBuilder label: () -> Label) { fatalError() }
}

@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension MultiDatePicker where Label == Text {

    /// Creates an instance that selects multiple dates with an unbounded
    /// range.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of `self`, describing
    ///     its purpose.
    ///   - selection: The date values being displayed and selected.
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Set<DateComponents>>) { fatalError() }

    /// Creates an instance that selects multiple dates in a range.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of `self`, describing
    ///     its purpose.
    ///   - selection: The date values being displayed and selected.
    ///   - bounds: The exclusive range of selectable dates.
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Set<DateComponents>>, in bounds: Range<Date>) { fatalError() }

    /// Creates an instance that selects multiple dates on or after some
    /// start date.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of `self`, describing
    ///     its purpose.
    ///   - selection: The date values being displayed and selected.
    ///   - bounds: The open range from some selectable start date.
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Set<DateComponents>>, in bounds: PartialRangeFrom<Date>) { fatalError() }

    /// Creates an instance that selects multiple dates before some end date.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of `self`, describing
    ///     its purpose.
    ///   - selection: The date values being displayed and selected.
    ///   - bounds: The open range before some end date.
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Set<DateComponents>>, in bounds: PartialRangeUpTo<Date>) { fatalError() }
}

@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension MultiDatePicker where Label == Text {

    /// Creates an instance that selects multiple dates with an unbounded
    /// range.
    ///
    /// - Parameters:
    ///   - title: The title of `self`, describing its purpose.
    ///   - selection: The date values being displayed and selected.
    public init<S>(_ title: S, selection: Binding<Set<DateComponents>>) where S : StringProtocol { fatalError() }

    /// Creates an instance that selects multiple dates in a range.
    ///
    /// - Parameters:
    ///   - title: The title of `self`, describing its purpose.
    ///   - selection: The date values being displayed and selected.
    ///   - bounds: The exclusive range of selectable dates.
    public init<S>(_ title: S, selection: Binding<Set<DateComponents>>, in bounds: Range<Date>) where S : StringProtocol { fatalError() }

    /// Creates an instance that selects multiple dates on or after some
    /// start date.
    ///
    /// - Parameters:
    ///   - title: The title of `self`, describing its purpose.
    ///   - selection: The date values being displayed and selected.
    ///   - bounds: The open range from some selectable start date.
    public init<S>(_ title: S, selection: Binding<Set<DateComponents>>, in bounds: PartialRangeFrom<Date>) where S : StringProtocol { fatalError() }

    /// Creates an instance that selects multiple dates before some end date.
    ///
    /// - Parameters:
    ///   - title: The title of `self`, describing its purpose.
    ///   - selection: The date values being displayed and selected.
    ///   - bounds: The open range before some end date.
    public init<S>(_ title: S, selection: Binding<Set<DateComponents>>, in bounds: PartialRangeUpTo<Date>) where S : StringProtocol { fatalError() }
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

/// A shape with a translation offset transform applied to it.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct OffsetShape<Content> : Shape where Content : Shape {

    public var shape: Content { get { fatalError() } }

    public var offset: CGSize { get { fatalError() } }

    @inlinable public init(shape: Content, offset: CGSize) { fatalError() }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// An indication of how to style a shape.
    ///
    /// SkipUI looks at a shape's role when deciding how to apply a
    /// ``ShapeStyle`` at render time. The ``Shape`` protocol provides a
    /// default implementation with a value of ``ShapeRole/fill``. If you
    /// create a composite shape, you can provide an override of this property
    /// to return another value, if appropriate.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static var role: ShapeRole { get { fatalError() } }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<Content.AnimatableData, CGSize.AnimatableData>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension OffsetShape : InsettableShape where Content : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> OffsetShape<Content.InsetShape> { fatalError() }

    /// The type of the inset shape.
    public typealias InsetShape = OffsetShape<Content.InsetShape>
}

///// A table row modifier that adds the ability to insert data in some base
///// row content.
//@available(iOS 16.0, macOS 12.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//public struct OnInsertTableRowModifier {
//
//    public var body: some _TableRowContentModifier { get { fatalError() } }
//
//    public typealias Body = some _TableRowContentModifier
//}

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

/// A schedule for updating a timeline view at regular intervals.
///
/// You can also use ``TimelineSchedule/periodic(from:by:)`` to construct this
/// schedule.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct PeriodicTimelineSchedule : TimelineSchedule, Sendable {

    /// The sequence of dates in periodic schedule.
    ///
    /// The ``PeriodicTimelineSchedule/entries(from:mode:)`` method returns
    /// a value of this type, which is a
    /// of periodic dates in ascending order. A ``TimelineView`` that you
    /// create updates its content at the moments in time corresponding to the
    /// dates included in the sequence.
    public struct Entries : Sequence, IteratorProtocol, Sendable {

        /// Advances to the next element and returns it, or `nil` if no next element
        /// exists.
        ///
        /// Repeatedly calling this method returns, in order, all the elements of the
        /// underlying sequence. As soon as the sequence has run out of elements, all
        /// subsequent calls return `nil`.
        ///
        /// You must not call this method if any other copy of this iterator has been
        /// advanced with a call to its `next()` method.
        ///
        /// The following example shows how an iterator can be used explicitly to
        /// emulate a `for`-`in` loop. First, retrieve a sequence's iterator, and
        /// then call the iterator's `next()` method until it returns `nil`.
        ///
        ///     let numbers = [2, 3, 5, 7]
        ///     var numbersIterator = numbers.makeIterator()
        ///
        ///     while let num = numbersIterator.next() {
        ///         print(num)
        ///     }
        ///     // Prints "2"
        ///     // Prints "3"
        ///     // Prints "5"
        ///     // Prints "7"
        ///
        /// - Returns: The next element in the underlying sequence, if a next element
        ///   exists; otherwise, `nil`.
        public mutating func next() -> Date? { fatalError() }

        /// A type representing the sequence's elements.
        public typealias Element = Date

        /// A type that provides the sequence's iteration interface and
        /// encapsulates its iteration state.
        public typealias Iterator = PeriodicTimelineSchedule.Entries
    }

    /// Creates a periodic update schedule.
    ///
    /// Use the ``PeriodicTimelineSchedule/entries(from:mode:)`` method
    /// to get the sequence of dates.
    ///
    /// - Parameters:
    ///   - startDate: The date on which to start the sequence.
    ///   - interval: The time interval between successive sequence entries.
    public init(from startDate: Date, by interval: TimeInterval) { fatalError() }

    /// Provides a sequence of periodic dates starting from around a given date.
    ///
    /// A ``TimelineView`` that you create with a schedule calls this method
    /// to ask the schedule when to update its content. The method returns
    /// a sequence of equally spaced dates in increasing order that represent
    /// points in time when the timeline view should update.
    ///
    /// The schedule defines its periodicity and phase aligment based on the
    /// parameters you pass to its ``init(from:by:)`` initializer.
    /// For example, for a `startDate` and `interval` of `10:09:30` and
    /// `60` seconds, the schedule prepares to issue dates half past each
    /// minute. The `startDate` that you pass to the `entries(from:mode:)`
    /// method then dictates the first date of the sequence as the beginning of
    /// the interval that the start date overlaps. Continuing the example above,
    /// a start date of `10:34:45` causes the first sequence entry to be
    /// `10:34:30`, because that's the start of the interval in which the
    /// start date appears.
    public func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries { fatalError() }
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

/// A style appropriate for placeholder text.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@frozen public struct PlaceholderTextShapeStyle : ShapeStyle {

    /// Creates a new placeholder text shape style.
    public init() { fatalError() }

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
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

/// A view that shows the progress toward completion of a task.
///
/// Use a progress view to show that a task is incomplete but advancing toward
/// completion. A progress view can show both determinate (percentage complete)
/// and indeterminate (progressing or not) types of progress.
///
/// Create a determinate progress view by initializing a `ProgressView` with
/// a binding to a numeric value that indicates the progress, and a `total`
/// value that represents completion of the task. By default, the progress is
/// `0.0` and the total is `1.0`.
///
/// The example below uses the state property `progress` to show progress in
/// a determinate `ProgressView`. The progress view uses its default total of
/// `1.0`, and because `progress` starts with an initial value of `0.5`,
/// the progress view begins half-complete. A "More" button below the progress
/// view allows people to increment the progress in increments of five percent:
///
///     struct LinearProgressDemoView: View {
///         @State private var progress = 0.5
///
///         var body: some View {
///             VStack {
///                 ProgressView(value: progress)
///                 Button("More") { progress += 0.05 }
///             }
///         }
///     }
///
/// ![A horizontal bar that represents progress, with a More button
/// placed underneath. The progress bar is at 50 percent from the leading
/// edge.](ProgressView-1-macOS)
///
/// To create an indeterminate progress view, use an initializer that doesn't
/// take a progress value:
///
///     var body: some View {
///         ProgressView()
///     }
///
/// ![An indeterminate progress view, presented as a spinning set of gray lines
/// emanating from the center of a circle, with opacity varying from fully
/// opaque to transparent. An animation rotates which line is most opaque,
/// creating the spinning effect.](ProgressView-2-macOS)
///
/// You can also create a progress view that covers a closed range of
///  values. As long
/// as the current date is within the range, the progress view automatically
/// updates, filling or depleting the progress view as it nears the end of the
/// range. The following example shows a five-minute timer whose start time is
/// that of the progress view's initialization:
///
///     struct DateRelativeProgressDemoView: View {
///         let workoutDateRange = Date()...Date().addingTimeInterval(5*60)
///
///         var body: some View {
///              ProgressView(timerInterval: workoutDateRange) {
///                  Text("Workout")
///              }
///         }
///     }
///
/// ![A horizontal progress view that shows a bar partially filled with as it
/// counts a five-minute duration.](ProgressView-3-macOS)
///
/// ### Styling progress views
///
/// You can customize the appearance and interaction of progress views by
/// creating styles that conform to the ``ProgressViewStyle`` protocol. To set a
/// specific style for all progress view instances within a view, use the
/// ``View/progressViewStyle(_:)`` modifier. In the following example, a custom
/// style adds a rounded pink border to all progress views within the enclosing
/// ``VStack``:
///
///     struct BorderedProgressViews: View {
///         var body: some View {
///             VStack {
///                 ProgressView(value: 0.25) { Text("25% progress") }
///                 ProgressView(value: 0.75) { Text("75% progress") }
///             }
///             .progressViewStyle(PinkBorderedProgressViewStyle())
///         }
///     }
///
///     struct PinkBorderedProgressViewStyle: ProgressViewStyle {
///         func makeBody(configuration: Configuration) -> some View {
///             ProgressView(configuration)
///                 .padding(4)
///                 .border(.pink, width: 3)
///                 .cornerRadius(4)
///         }
///     }
///
/// ![Two horizontal progress views, one at 25 percent complete and the other at 75 percent,
/// each rendered with a rounded pink border.](ProgressView-4-macOS)
///
/// SkipUI provides two built-in progress view styles,
/// ``ProgressViewStyle/linear`` and ``ProgressViewStyle/circular``, as well as
/// an automatic style that defaults to the most appropriate style in the
/// current context. The following example shows a circular progress view that
/// starts at 60 percent completed.
///
///     struct CircularProgressDemoView: View {
///         @State private var progress = 0.6
///
///         var body: some View {
///             VStack {
///                 ProgressView(value: progress)
///                     .progressViewStyle(.circular)
///             }
///         }
///     }
///
/// ![A ring shape, filled to 60 percent completion with a blue
/// tint.](ProgressView-5-macOS)
///
/// On platforms other than macOS, the circular style may appear as an
/// indeterminate indicator instead.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ProgressView<Label, CurrentValueLabel> : View where Label : View, CurrentValueLabel : View {

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

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ProgressView {

    /// Creates a progress view for showing continuous progress as time passes,
    /// with descriptive and current progress labels.
    ///
    /// Use this initializer to create a view that shows continuous progress
    /// within a date range. The following example initializes a progress view
    /// with a range of `start...end`, where `start` is 30 seconds in the past
    /// and `end` is 90 seconds in the future. As a result, the progress view
    /// begins at 25 percent complete. This example also provides custom views
    /// for a descriptive label (Progress) and a current value label that shows
    /// the date range.
    ///
    ///     struct ContentView: View {
    ///         let start = Date().addingTimeInterval(-30)
    ///         let end = Date().addingTimeInterval(90)
    ///
    ///         var body: some View {
    ///             ProgressView(interval: start...end,
    ///                          countsDown: false) {
    ///                 Text("Progress")
    ///             } currentValueLabel: {
    ///                 Text(start...end)
    ///              }
    ///          }
    ///     }
    ///
    /// ![A horizontal bar that represents progress, partially filled in from
    /// the leading edge. The title, Progress, appears above the bar, and the
    /// date range, 1:43 to 1:45 PM, appears below the bar. These values represent
    /// the time progress began and when it ends, given a current time of
    /// 1:44.](ProgressView-6-macOS)
    ///
    /// By default, the progress view empties as time passes from the start of
    /// the date range to the end, but you can use the `countsDown` parameter to
    /// create a progress view that fills as time passes, as the above example
    /// demonstrates.
    ///
    /// > Note: Date-relative progress views, such as those created with this
    ///   initializer, don't support custom styles.
    ///
    /// - Parameters:
    ///     - timerInterval: The date range over which the view should progress.
    ///     - countsDown: A Boolean value that determines whether the view
    ///       empties or fills as time passes. If `true` (the default), the
    ///       view empties.
    ///     - label: An optional view that describes the purpose of the progress
    ///       view.
    ///     - currentValueLabel: A view that displays the current value of the
    ///       timer.
    public init(timerInterval: ClosedRange<Date>, countsDown: Bool = true, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> CurrentValueLabel) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ProgressView where CurrentValueLabel == DefaultDateProgressLabel {

    /// Creates a progress view for showing continuous progress as time passes,
    /// with a descriptive label.
    ///
    /// Use this initializer to create a view that shows continuous progress
    /// within a date range. The following example initializes a progress view
    /// with a range of `start...end`, where `start` is 30 seconds in the past
    /// and `end` is 90 seconds in the future. As a result, the progress view
    /// begins at 25 percent complete. This example also provides a custom
    /// descriptive label.
    ///
    ///     struct ContentView: View {
    ///         let start = Date().addingTimeInterval(-30)
    ///         let end = Date().addingTimeInterval(90)
    ///
    ///         var body: some View {
    ///             ProgressView(interval: start...end,
    ///                          countsDown: false) {
    ///                 Text("Progress")
    ///              }
    ///         }
    ///     }
    ///
    /// ![A horizontal bar that represents progress, partially filled in from
    /// the leading edge. The title, Progress, appears above the bar, and the
    /// elapsed time, 0:34, appears below the bar.](ProgressView-7-macOS)
    ///
    /// By default, the progress view empties as time passes from the start of
    /// the date range to the end, but you can use the `countsDown` parameter to
    /// create a progress view that fills as time passes, as the above example
    /// demonstrates.
    ///
    /// The progress view provided by this initializer uses a text label that
    /// automatically updates to describe the current time remaining. To provide
    /// a custom label to show the current value, use
    /// ``init(value:total:label:currentValueLabel:)`` instead.
    ///
    /// > Note: Date-relative progress views, such as those created with this
    ///   initializer, don't support custom styles.
    ///
    /// - Parameters:
    ///     - timerInterval: The date range over which the view progresses.
    ///     - countsDown: A Boolean value that determines whether the view
    ///       empties or fills as time passes. If `true` (the default), the
    ///       view empties.
    ///     - label: An optional view that describes the purpose of the progress
    ///       view.
    public init(timerInterval: ClosedRange<Date>, countsDown: Bool = true, @ViewBuilder label: () -> Label) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ProgressView where Label == EmptyView, CurrentValueLabel == DefaultDateProgressLabel {

    /// Creates a progress view for showing continuous progress as time passes.
    ///
    /// Use this initializer to create a view that shows continuous progress
    /// within a date range. The following example initializes a progress view
    /// with a range of `start...end`, where `start` is 30 seconds in the past
    /// and `end` is 90 seconds in the future. As a result, the progress view
    /// begins at 25 percent complete.
    ///
    ///     struct ContentView: View {
    ///         let start = Date().addingTimeInterval(-30)
    ///         let end = Date().addingTimeInterval(90)
    ///
    ///         var body: some View {
    ///             ProgressView(interval: start...end
    ///                          countsDown: false)
    ///         }
    ///     }
    ///
    /// ![A horizontal bar that represents progress, partially filled in from
    /// the leading edge. The elapsed time, 0:34, appears below the
    /// bar.](ProgressView-8-macOS)
    ///
    /// By default, the progress view empties as time passes from the start of
    /// the date range to the end, but you can use the `countsDown` parameter to
    /// create a progress view that fills as time passes, as the above example
    /// demonstrates.
    ///
    /// The progress view provided by this initializer omits a descriptive
    /// label and provides a text label that automatically updates to describe
    /// the current time remaining. To provide custom views for these labels,
    /// use ``init(value:total:label:currentValueLabel:)`` instead.
    ///
    /// > Note: Date-relative progress views, such as those created with this
    ///   initializer, don't support custom styles.
    ///
    /// - Parameters:
    ///     - timerInterval: The date range over which the view progresses.
    ///     - countsDown: If `true` (the default), the view empties as time passes.
    public init(timerInterval: ClosedRange<Date>, countsDown: Bool = true) { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ProgressView where CurrentValueLabel == EmptyView {

    /// Creates a progress view for showing indeterminate progress, without a
    /// label.
    public init() where Label == EmptyView { fatalError() }

    /// Creates a progress view for showing indeterminate progress that displays
    /// a custom label.
    ///
    /// - Parameters:
    ///     - label: A view builder that creates a view that describes the task
    ///       in progress.
    public init(@ViewBuilder label: () -> Label) { fatalError() }

    /// Creates a progress view for showing indeterminate progress that
    /// generates its label from a localized string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings. To initialize a
    /// indeterminate progress view with a string variable, use
    /// the corresponding initializer that takes a `StringProtocol` instance.
    ///
    /// - Parameters:
    ///     - titleKey: The key for the progress view's localized title that
    ///       describes the task in progress.
    public init(_ titleKey: LocalizedStringKey) where Label == Text { fatalError() }

    /// Creates a progress view for showing indeterminate progress that
    /// generates its label from a string.
    ///
    /// - Parameters:
    ///     - title: A string that describes the task in progress.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(verbatim:)``. See ``Text`` for more
    /// information about localizing strings. To initialize a progress view with
    /// a localized string key, use the corresponding initializer that takes a
    /// `LocalizedStringKey` instance.
    public init<S>(_ title: S) where Label == Text, S : StringProtocol { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ProgressView {

    /// Creates a progress view for showing determinate progress.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// - Parameters:
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    public init<V>(value: V?, total: V = 1.0) where Label == EmptyView, CurrentValueLabel == EmptyView, V : BinaryFloatingPoint { fatalError() }

    /// Creates a progress view for showing determinate progress, with a
    /// custom label.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// - Parameters:
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    ///     - label: A view builder that creates a view that describes the task
    ///       in progress.
    public init<V>(value: V?, total: V = 1.0, @ViewBuilder label: () -> Label) where CurrentValueLabel == EmptyView, V : BinaryFloatingPoint { fatalError() }

    /// Creates a progress view for showing determinate progress, with a
    /// custom label.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// - Parameters:
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    ///     - label: A view builder that creates a view that describes the task
    ///       in progress.
    ///     - currentValueLabel: A view builder that creates a view that
    ///       describes the level of completed progress of the task.
    public init<V>(value: V?, total: V = 1.0, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> CurrentValueLabel) where V : BinaryFloatingPoint { fatalError() }

    /// Creates a progress view for showing determinate progress that generates
    /// its label from a localized string.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings. To initialize a
    ///  determinate progress view with a string variable, use
    ///  the corresponding initializer that takes a `StringProtocol` instance.
    ///
    /// - Parameters:
    ///     - titleKey: The key for the progress view's localized title that
    ///       describes the task in progress.
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is
    ///       indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    public init<V>(_ titleKey: LocalizedStringKey, value: V?, total: V = 1.0) where Label == Text, CurrentValueLabel == EmptyView, V : BinaryFloatingPoint { fatalError() }

    /// Creates a progress view for showing determinate progress that generates
    /// its label from a string.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(verbatim:)``. See ``Text`` for more
    /// information about localizing strings. To initialize a determinate
    /// progress view with a localized string key, use the corresponding
    /// initializer that takes a `LocalizedStringKey` instance.
    ///
    /// - Parameters:
    ///     - title: The string that describes the task in progress.
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is
    ///       indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    public init<S, V>(_ title: S, value: V?, total: V = 1.0) where Label == Text, CurrentValueLabel == EmptyView, S : StringProtocol, V : BinaryFloatingPoint { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ProgressView {

    /// Creates a progress view for visualizing the given progress instance.
    ///
    /// The progress view synthesizes a default label using the
    /// `localizedDescription` of the given progress instance.
    public init(_ progress: Progress) where Label == EmptyView, CurrentValueLabel == EmptyView { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ProgressView {

    /// Creates a progress view based on a style configuration.
    ///
    /// You can use this initializer within the
    /// ``ProgressViewStyle/makeBody(configuration:)`` method of a
    /// ``ProgressViewStyle`` to create an instance of the styled progress view.
    /// This is useful for custom progress view styles that only modify the
    /// current progress view style, as opposed to implementing a brand new
    /// style. Because this modifier style can't know how the current style
    /// represents progress, avoid making assumptions about the view's contents,
    /// such as whether it uses bars or other shapes.
    ///
    /// The following example shows a style that adds a rounded pink border to a
    /// progress view, but otherwise preserves the progress view's current
    /// style:
    ///
    ///     struct PinkBorderedProgressViewStyle: ProgressViewStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             ProgressView(configuration)
    ///                 .padding(4)
    ///                 .border(.pink, width: 3)
    ///                 .cornerRadius(4)
    ///         }
    ///     }
    ///
    /// ![Two horizontal progress views, one at 25 percent complete and the
    /// other at 75 percent, each rendered with a rounded pink
    /// border.](ProgressView-4-macOS)
    ///
    /// - Note: Progress views in widgets don't apply custom styles.
    public init(_ configuration: ProgressViewStyleConfiguration) where Label == ProgressViewStyleConfiguration.Label, CurrentValueLabel == ProgressViewStyleConfiguration.CurrentValueLabel { fatalError() }
}

/// A type that applies standard interaction behavior to all progress views
/// within a view hierarchy.
///
/// To configure the current progress view style for a view hierarchy, use the
/// ``View/progressViewStyle(_:)`` modifier.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol ProgressViewStyle {

    /// A view representing the body of a progress view.
    associatedtype Body : View

    /// Creates a view representing the body of a progress view.
    ///
    /// - Parameter configuration: The properties of the progress view being
    ///   created.
    ///
    /// The view hierarchy calls this method for each progress view where this
    /// style is the current progress view style.
    ///
    /// - Parameter configuration: The properties of the progress view, such as
    ///  its preferred progress type.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// A type alias for the properties of a progress view instance.
    typealias Configuration = ProgressViewStyleConfiguration
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ProgressViewStyle where Self == DefaultProgressViewStyle {

    /// The default progress view style in the current context of the view being
    /// styled.
    ///
    /// The default style represents the recommended style based on the original
    /// initialization parameters of the progress view, and the progress view's
    /// context within the view hierarchy.
    public static var automatic: DefaultProgressViewStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ProgressViewStyle where Self == CircularProgressViewStyle {

    /// The style of a progress view that uses a circular gauge to indicate the
    /// partial completion of an activity.
    ///
    /// On watchOS, and in widgets and complications, a circular progress view
    /// appears as a gauge with the ``GaugeStyle/accessoryCircularCapacity``
    /// style. If the progress view is indeterminate, the gauge is empty.
    ///
    /// In cases where no determinate circular progress view style is available,
    /// circular progress views use an indeterminate style.
    public static var circular: CircularProgressViewStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ProgressViewStyle where Self == LinearProgressViewStyle {

    /// A progress view that visually indicates its progress using a horizontal
    /// bar.
    public static var linear: LinearProgressViewStyle { get { fatalError() } }
}

/// The properties of a progress view instance.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ProgressViewStyleConfiguration {

    /// A type-erased label describing the task represented by the progress
    /// view.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// A type-erased label that describes the current value of a progress view.
    public struct CurrentValueLabel : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = Never
        public var body: Body { fatalError() }
    }

    /// The completed fraction of the task represented by the progress view,
    /// from `0.0` (not yet started) to `1.0` (fully complete), or `nil` if the
    /// progress is indeterminate or relative to a date interval.
    public let fractionCompleted: Double?

    /// A view that describes the task represented by the progress view.
    ///
    /// If `nil`, then the task is self-evident from the surrounding context,
    /// and the style does not need to provide any additional description.
    ///
    /// If the progress view is defined using a `Progress` instance, then this
    /// label is equivalent to its `localizedDescription`.
    public var label: ProgressViewStyleConfiguration.Label?

    /// A view that describes the current value of a progress view.
    ///
    /// If `nil`, then the value of the progress view is either self-evident
    /// from the surrounding context or unknown, and the style does not need to
    /// provide any additional description.
    ///
    /// If the progress view is defined using a `Progress` instance, then this
    /// label is equivalent to its `localizedAdditionalDescription`.
    public var currentValueLabel: ProgressViewStyleConfiguration.CurrentValueLabel?
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

/// A gesture that's a sequence of two gestures.
///
/// Read <doc:Composing-SkipUI-Gestures> to learn how you can create a sequence
/// of two gestures.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct SequenceGesture<First, Second> : Gesture where First : Gesture, Second : Gesture {

    /// The value of a sequence gesture that helps to detect whether the first
    /// gesture succeeded, so the second gesture can start.
    @frozen public enum Value {

        /// The first gesture hasn't ended.
        case first(First.Value)

        /// The first gesture has ended.
        case second(First.Value, Second.Value?)
    }

    /// The first gesture in a sequence of two gestures.
    public var first: First { get { fatalError() } }

    /// The second gesture in a sequence of two gestures.
    public var second: Second { get { fatalError() } }

    /// Creates a sequence gesture with two gestures.
    ///
    /// - Parameters:
    ///   - first: The first gesture of the sequence.
    ///   - second: The second gesture of the sequence.
    @inlinable public init(_ first: First, _ second: Second) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SequenceGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SequenceGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {

    public static func == (a: SequenceGesture<First, Second>.Value, b: SequenceGesture<First, Second>.Value) -> Bool { fatalError() }
}

/// A reference to a function in a Metal shader library.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
@dynamicCallable public struct ShaderFunction : Equatable, Sendable {

    /// The shader library storing the function.
    public var library: ShaderLibrary { get { fatalError() } }

    /// The name of the shader function in the library.
    public var name: String { get { fatalError() } }

    /// Creates a new function reference from the provided shader
    /// library and function name string.
    public init(library: ShaderLibrary, name: String) { fatalError() }

    /// Returns a new shader by applying the provided argument values
    /// to the referenced function.
    ///
    /// Typically this subscript is used implicitly via function-call
    /// syntax, for example:
    ///
    ///    let shader = ShaderLibrary.default.myFunction(.float(42))
    ///
    /// which creates a shader passing the value `42` to the first
    /// unbound parameter of `myFunction()`.
    public func dynamicallyCall(withArguments args: [Shader.Argument]) -> Shader { fatalError() }

    public static func == (a: ShaderFunction, b: ShaderFunction) -> Bool { fatalError() }
}

/// A Metal shader library.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
@dynamicMemberLookup public struct ShaderLibrary : Equatable, @unchecked Sendable {

    /// The default shader library of the main (i.e. app) bundle.
    public static let `default`: ShaderLibrary = { fatalError() }()

    /// Returns the default shader library of the specified bundle.
    public static func bundle(_ bundle: Bundle) -> ShaderLibrary { fatalError() }

    /// Creates a new Metal shader library from `data`, which must be
    /// the contents of precompiled Metal library. Functions compiled
    /// from the returned library will only be cached as long as the
    /// returned library exists.
    public init(data: Data) { fatalError() }

    /// Creates a new Metal shader library from the contents of `url`,
    /// which must be the location  of precompiled Metal library.
    /// Functions compiled from the returned library will only be
    /// cached as long as the returned library exists.
    public init(url: URL) { fatalError() }

    /// Returns a new shader function representing the stitchable MSL
    /// function called `name` in the default shader library.
    ///
    /// Typically this subscript is used implicitly via the dynamic
    /// member syntax, for example:
    ///
    ///    let fn = ShaderLibrary.myFunction
    ///
    /// which creates a reference to the MSL function called
    /// `myFunction()`.
    public static subscript(dynamicMember name: String) -> ShaderFunction { get { fatalError() } }

    /// Returns a new shader function representing the stitchable MSL
    /// function in the library called `name`.
    ///
    /// Typically this subscript is used implicitly via the dynamic
    /// member syntax, for example:
    ///
    ///    let fn = ShaderLibrary.default.myFunction
    ///
    /// which creates a reference to the MSL function called
    /// `myFunction()`.
    public subscript(dynamicMember name: String) -> ShaderFunction { get { fatalError() } }

    public static func == (lhs: ShaderLibrary, rhs: ShaderLibrary) -> Bool { fatalError() }
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

/// A gesture containing two gestures that can happen at the same time with
/// neither of them preceding the other.
///
/// A simultaneous gesture is a container-event handler that evaluates its two
/// child gestures at the same time. Its value is a struct with two optional
/// values, each representing the phases of one of the two gestures.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct SimultaneousGesture<First, Second> : Gesture where First : Gesture, Second : Gesture {

    /// The value of a simultaneous gesture that indicates which of its two
    /// gestures receives events.
    @frozen public struct Value {

        /// The value of the first gesture.
        public var first: First.Value?

        /// The value of the second gesture.
        public var second: Second.Value?
    }

    /// The first of two gestures that can happen simultaneously.
    public var first: First { get { fatalError() } }

    /// The second of two gestures that can happen simultaneously.
    public var second: Second { get { fatalError() } }

    /// Creates a gesture with two gestures that can receive updates or succeed
    /// independently of each other.
    ///
    /// - Parameters:
    ///   - first: The first of two gestures that can happen simultaneously.
    ///   - second: The second of two gestures that can happen simultaneously.
    @inlinable public init(_ first: First, _ second: Second) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SimultaneousGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SimultaneousGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {

    public static func == (a: SimultaneousGesture<First, Second>.Value, b: SimultaneousGesture<First, Second>.Value) -> Bool { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SimultaneousGesture.Value : Hashable where First.Value : Hashable, Second.Value : Hashable {

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// A collection of events that target a specific view.
///
/// You can look up a specific event using its `ID`
/// or iterate over all touches in the collection to apply logic depending
/// on the touch's states.
@available(xrOS 1.0, iOS 17.0, macOS 14.0, watchOS 10.0, *)
@available(tvOS, unavailable)
public struct SpatialEventCollection : Collection {

    /// A spatial event generated from a finger, pointing device, or other input mechanism
    /// that can drive gestures in the system.
    @available(xrOS 1.0, iOS 17.0, macOS 14.0, watchOS 10.0, *)
    @available(tvOS, unavailable)
    public struct Event : Identifiable {

        /// A value that uniquely identifies an event over the course of its lifetime.
        public struct ID : Hashable {

            /// Hashes the essential components of this value by feeding them into the
            /// given hasher.
            ///
            /// Implement this method to conform to the `Hashable` protocol. The
            /// components used for hashing must be the same as the components compared
            /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
            /// with each of these components.
            ///
            /// - Important: In your implementation of `hash(into:)`,
            ///   don't call `finalize()` on the `hasher` instance provided,
            ///   or replace it with a different instance.
            ///   Doing so may become a compile-time error in the future.
            ///
            /// - Parameter hasher: The hasher to use when combining the components
            ///   of this instance.
            public func hash(into hasher: inout Hasher) { fatalError() }

            /// Returns a Boolean value indicating whether two values are equal.
            ///
            /// Equality is the inverse of inequality. For any values `a` and `b`,
            /// `a == b` implies that `a != b` is `false`.
            ///
            /// - Parameters:
            ///   - lhs: A value to compare.
            ///   - rhs: Another value to compare.
            public static func == (a: SpatialEventCollection.Event.ID, b: SpatialEventCollection.Event.ID) -> Bool { fatalError() }

            /// The hash value.
            ///
            /// Hash values are not guaranteed to be equal across different executions of
            /// your program. Do not save hash values to use during a future execution.
            ///
            /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
            ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
            ///   The compiler provides an implementation for `hashValue` for you.
            public var hashValue: Int { get { fatalError() } }
        }

        /// A kind of spatial event used to differentiate between different
        /// input sources or modes.
        public enum Kind : Hashable {

            /// An event generated from a touch directly targeting content.
            case touch

            /// An event generated from a pencil making contact with content.
            @available(iOS 17.0, *)
            @available(macOS, unavailable)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            @available(xrOS, unavailable)
            case pencil

            /// An event representing a click-based, indirect input device
            /// describing the input sequence from click to click release.
            @available(xrOS 1.0, iOS 17.0, macOS 14.0, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            case pointer

            /// Returns a Boolean value indicating whether two values are equal.
            ///
            /// Equality is the inverse of inequality. For any values `a` and `b`,
            /// `a == b` implies that `a != b` is `false`.
            ///
            /// - Parameters:
            ///   - lhs: A value to compare.
            ///   - rhs: Another value to compare.
            public static func == (a: SpatialEventCollection.Event.Kind, b: SpatialEventCollection.Event.Kind) -> Bool { fatalError() }

            /// Hashes the essential components of this value by feeding them into the
            /// given hasher.
            ///
            /// Implement this method to conform to the `Hashable` protocol. The
            /// components used for hashing must be the same as the components compared
            /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
            /// with each of these components.
            ///
            /// - Important: In your implementation of `hash(into:)`,
            ///   don't call `finalize()` on the `hasher` instance provided,
            ///   or replace it with a different instance.
            ///   Doing so may become a compile-time error in the future.
            ///
            /// - Parameter hasher: The hasher to use when combining the components
            ///   of this instance.
            public func hash(into hasher: inout Hasher) { fatalError() }

            /// The hash value.
            ///
            /// Hash values are not guaranteed to be equal across different executions of
            /// your program. Do not save hash values to use during a future execution.
            ///
            /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
            ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
            ///   The compiler provides an implementation for `hashValue` for you.
            public var hashValue: Int { get { fatalError() } }
        }

        /// The phase of a particular state of the event.
        public enum Phase {

            /// The phase is active and the state associated with it is
            /// guaranteed to produce at least one more update.
            case active

            /// The state associated with this phase ended normally
            /// and won't produce any more updates.
            case ended

            /// The state associated with this phase was canceled
            /// and won't produce any more updates.
            case cancelled

            /// Returns a Boolean value indicating whether two values are equal.
            ///
            /// Equality is the inverse of inequality. For any values `a` and `b`,
            /// `a == b` implies that `a != b` is `false`.
            ///
            /// - Parameters:
            ///   - lhs: A value to compare.
            ///   - rhs: Another value to compare.
            public static func == (a: SpatialEventCollection.Event.Phase, b: SpatialEventCollection.Event.Phase) -> Bool { fatalError() }

            /// Hashes the essential components of this value by feeding them into the
            /// given hasher.
            ///
            /// Implement this method to conform to the `Hashable` protocol. The
            /// components used for hashing must be the same as the components compared
            /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
            /// with each of these components.
            ///
            /// - Important: In your implementation of `hash(into:)`,
            ///   don't call `finalize()` on the `hasher` instance provided,
            ///   or replace it with a different instance.
            ///   Doing so may become a compile-time error in the future.
            ///
            /// - Parameter hasher: The hasher to use when combining the components
            ///   of this instance.
            public func hash(into hasher: inout Hasher) { fatalError() }

            /// The hash value.
            ///
            /// Hash values are not guaranteed to be equal across different executions of
            /// your program. Do not save hash values to use during a future execution.
            ///
            /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
            ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
            ///   The compiler provides an implementation for `hashValue` for you.
            public var hashValue: Int { get { fatalError() } }
        }

        /// A pose describing the input device such as a pencil
        /// or hand controlling the event.
        public struct InputDevicePose {

            /// Altitude angle.
            ///
            /// An angle of zero indicates that the device is parallel to the content,
            /// while 90 degrees indicates that it is normal to the content surface.
            public var altitude: Angle { get { fatalError() } }

            /// Azimuth angle.
            ///
            /// An angle of zero points along the content's positive X axis.
            public var azimuth: Angle { get { fatalError() } }
        }

        /// An identifier that uniquely identifies this event over its lifetime.
        public var id: SpatialEventCollection.Event.ID { get { fatalError() } }

        /// The time this `Event` was processed.
        public var timestamp: TimeInterval { get { fatalError() } }

        /// Indicates what input source generated this event.
        public var kind: SpatialEventCollection.Event.Kind { get { fatalError() } }

        /// The 2D location of the touch.
        public var location: CGPoint { get { fatalError() } }

        /// The phase of the event.
        public var phase: SpatialEventCollection.Event.Phase { get { fatalError() } }

        /// The set of active modifier keys at the time of this event.
        public var modifierKeys: EventModifiers { get { fatalError() } }

        /// The 3D position and orientation of the device controlling the touch, if one exists.
        @available(xrOS 1.0, iOS 17.0, *)
        @available(macOS, unavailable)
        @available(watchOS, unavailable)
        @available(tvOS, unavailable)
        public var inputDevicePose: SpatialEventCollection.Event.InputDevicePose?
    }

    /// Retrieves an event using its unique identifier.
    ///
    /// Returns `nil` if the `Event` no longer exists in the collection.
    public subscript(index: SpatialEventCollection.Event.ID) -> SpatialEventCollection.Event? { get { fatalError() } }

    /// An iterator over all events in the collection.
    public struct Iterator : IteratorProtocol {

        /// The next `Event` in the sequence, if one exists.
        public mutating func next() -> SpatialEventCollection.Event? { fatalError() }

        /// The type of element traversed by the iterator.
        public typealias Element = SpatialEventCollection.Event
    }

    /// Makes an iterator over all events in the collection.
    public func makeIterator() -> SpatialEventCollection.Iterator { fatalError() }

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public struct Index : Comparable {

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
        public static func < (lhs: SpatialEventCollection.Index, rhs: SpatialEventCollection.Index) -> Bool { fatalError() }

        public static func == (a: SpatialEventCollection.Index, b: SpatialEventCollection.Index) -> Bool { fatalError() }
    }

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: SpatialEventCollection.Index { get { fatalError() } }

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
    public var endIndex: SpatialEventCollection.Index { get { fatalError() } }

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
    public subscript(position: SpatialEventCollection.Index) -> SpatialEventCollection.Event { get { fatalError() } }

    /// Returns the position immediately after the given index.
    ///
    /// The successor of an index must be well defined. For an index `i` into a
    /// collection `c`, calling `c.index(after: i)` returns the same index every
    /// time.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: SpatialEventCollection.Index) -> SpatialEventCollection.Index { fatalError() }

    /// A type representing the sequence's elements.
    public typealias Element = SpatialEventCollection.Event

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = DefaultIndices<SpatialEventCollection>

    /// A collection representing a contiguous subrange of this collection's
    /// elements. The subsequence shares indices with the original collection.
    ///
    /// The default subsequence type for collections that don't define their own
    /// is `Slice`.
    public typealias SubSequence = Slice<SpatialEventCollection>
}

extension SpatialEventCollection.Event {

    @available(xrOS 1.0, iOS 17.0, macOS 14.0, watchOS 10.0, *)
    @available(tvOS, unavailable)
    public static func == (lhs: SpatialEventCollection.Event, rhs: SpatialEventCollection.Event) -> Bool { fatalError() }
}

@available(xrOS 1.0, iOS 17.0, macOS 14.0, watchOS 10.0, *)
@available(tvOS, unavailable)
extension SpatialEventCollection.Event.Phase : Equatable {
}

@available(xrOS 1.0, iOS 17.0, macOS 14.0, watchOS 10.0, *)
@available(tvOS, unavailable)
extension SpatialEventCollection.Event.Phase : Hashable {
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
extension StrokeStyle : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
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

/// A symbol rendering mode.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SymbolRenderingMode : Sendable {

    /// A mode that renders symbols as a single layer filled with the
    /// foreground style.
    ///
    /// For example, you can render a filled exclamation mark triangle in
    /// purple:
    ///
    ///     Image(systemName: "exclamationmark.triangle.fill")
    ///         .symbolRenderingMode(.monochrome)
    ///         .foregroundStyle(Color.purple)
    public static let monochrome: SymbolRenderingMode = { fatalError() }()

    /// A mode that renders symbols as multiple layers with their inherit
    /// styles.
    ///
    /// The layers may be filled with their own inherent styles, or the
    /// foreground style. For example, you can render a filled exclamation
    /// mark triangle in its inherent colors, with yellow for the triangle and
    /// white for the exclamation mark:
    ///
    ///     Image(systemName: "exclamationmark.triangle.fill")
    ///         .symbolRenderingMode(.multicolor)
    public static let multicolor: SymbolRenderingMode = { fatalError() }()

    /// A mode that renders symbols as multiple layers, with different opacities
    /// applied to the foreground style.
    ///
    /// SkipUI fills the first layer with the foreground style, and the others
    /// the secondary, and tertiary variants of the foreground style. You can
    /// specify these styles explicitly using the ``View/foregroundStyle(_:_:)``
    /// and ``View/foregroundStyle(_:_:_:)`` modifiers. If you only specify
    /// a primary foreground style, SkipUI automatically derives
    /// the others from that style. For example, you can render a filled
    /// exclamation mark triangle with purple as the tint color for the
    /// exclamation mark, and lower opacity purple for the triangle:
    ///
    ///     Image(systemName: "exclamationmark.triangle.fill")
    ///         .symbolRenderingMode(.hierarchical)
    ///         .foregroundStyle(Color.purple)
    public static let hierarchical: SymbolRenderingMode = { fatalError() }()

    /// A mode that renders symbols as multiple layers, with different styles
    /// applied to the layers.
    ///
    /// In this mode SkipUI maps each successively defined layer in the image
    /// to the next of the primary, secondary, and tertiary variants of the
    /// foreground style. You can specify these styles explicitly using the
    /// ``View/foregroundStyle(_:_:)`` and ``View/foregroundStyle(_:_:_:)``
    /// modifiers. If you only specify a primary foreground style, SkipUI
    /// automatically derives the others from that style. For example, you can
    /// render a filled exclamation mark triangle with yellow as the tint color
    /// for the exclamation mark, and fill the triangle with cyan:
    ///
    ///     Image(systemName: "exclamationmark.triangle.fill")
    ///         .symbolRenderingMode(.palette)
    ///         .foregroundStyle(Color.yellow, Color.cyan)
    ///
    /// You can also omit the symbol rendering mode, as specifying multiple
    /// foreground styles implies switching to palette rendering mode:
    ///
    ///     Image(systemName: "exclamationmark.triangle.fill")
    ///         .foregroundStyle(Color.yellow, Color.cyan)
    public static let palette: SymbolRenderingMode = { fatalError() }()
}

/// A variant of a symbol.
///
/// Many of the symbols
/// that you can add to your app using an ``Image`` or a ``Label`` instance
/// have common variants, like a filled version or a version that's
/// contained within a circle. The symbol's name indicates the variant:
///
///     VStack(alignment: .leading) {
///         Label("Default", systemImage: "heart")
///         Label("Fill", systemImage: "heart.fill")
///         Label("Circle", systemImage: "heart.circle")
///         Label("Circle Fill", systemImage: "heart.circle.fill")
///     }
///
/// ![A screenshot showing an outlined heart, a filled heart, a heart in
/// a circle, and a filled heart in a circle, each with a text label
/// describing the symbol.](SymbolVariants-1)
///
/// You can configure a part of your view hierarchy to use a particular variant
/// for all symbols in that view and its child views using `SymbolVariants`.
/// Add the ``View/symbolVariant(_:)`` modifier to a view to set a variant
/// for that view's environment. For example, you can use the modifier to
/// create the same set of labels as in the example above, using only the
/// base name of the symbol in the label declarations:
///
///     VStack(alignment: .leading) {
///         Label("Default", systemImage: "heart")
///         Label("Fill", systemImage: "heart")
///             .symbolVariant(.fill)
///         Label("Circle", systemImage: "heart")
///             .symbolVariant(.circle)
///         Label("Circle Fill", systemImage: "heart")
///             .symbolVariant(.circle.fill)
///     }
///
/// Alternatively, you can set the variant in the environment directly by
/// passing the ``EnvironmentValues/symbolVariants`` environment value to the
/// ``View/environment(_:_:)`` modifier:
///
///     Label("Fill", systemImage: "heart")
///         .environment(\.symbolVariants, .fill)
///
/// SkipUI sets a variant for you in some environments. For example, SkipUI
/// automatically applies the ``SymbolVariants/fill-swift.type.property``
/// symbol variant for items that appear in the `content` closure of the
/// ``View/swipeActions(edge:allowsFullSwipe:content:)``
/// method, or as the tab bar items of a ``TabView``.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SymbolVariants : Hashable, Sendable {

    /// No variant for a symbol.
    ///
    /// Using this variant with the ``View/symbolVariant(_:)`` modifier doesn't
    /// have any effect. Instead, to show a symbol that ignores the current
    /// variant, directly set the ``EnvironmentValues/symbolVariants``
    /// environment value to `none` using the ``View/environment(_:_:)``
    /// modifer:
    ///
    ///     HStack {
    ///         Image(systemName: "heart")
    ///         Image(systemName: "heart")
    ///             .environment(\.symbolVariants, .none)
    ///     }
    ///     .symbolVariant(.fill)
    ///
    /// ![A screenshot of two heart symbols. The first is filled while the
    /// second is outlined.](SymbolVariants-none-1)
    public static let none: SymbolVariants = { fatalError() }()

    /// A variant that encapsulates the symbol in a circle.
    ///
    /// Use this variant with a call to the ``View/symbolVariant(_:)`` modifier
    /// to draw symbols in a circle, for those symbols that have a circle
    /// variant:
    ///
    ///     VStack(spacing: 20) {
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         .symbolVariant(.circle)
    ///     }
    ///
    /// ![A screenshot showing two rows of four symbols each. Both rows contain
    /// a flag, a heart, a bolt, and a star. The symbols in the second row are
    /// versions of the symbols in the first row, but each is enclosed in a
    /// circle.](SymbolVariants-circle-1)
    public static let circle: SymbolVariants = { fatalError() }()

    /// A variant that encapsulates the symbol in a square.
    ///
    /// Use this variant with a call to the ``View/symbolVariant(_:)`` modifier
    /// to draw symbols in a square, for those symbols that have a square
    /// variant:
    ///
    ///     VStack(spacing: 20) {
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         .symbolVariant(.square)
    ///     }
    ///
    /// ![A screenshot showing two rows of four symbols each. Both rows contain
    /// a flag, a heart, a bolt, and a star. The symbols in the second row are
    /// versions of the symbols in the first row, but each is enclosed in a
    /// square.](SymbolVariants-square-1)
    public static let square: SymbolVariants = { fatalError() }()

    /// A variant that encapsulates the symbol in a rectangle.
    ///
    /// Use this variant with a call to the ``View/symbolVariant(_:)`` modifier
    /// to draw symbols in a rectangle, for those symbols that have a rectangle
    /// variant:
    ///
    ///     VStack(spacing: 20) {
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "plus")
    ///             Image(systemName: "minus")
    ///             Image(systemName: "xmark")
    ///             Image(systemName: "checkmark")
    ///         }
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "plus")
    ///             Image(systemName: "minus")
    ///             Image(systemName: "xmark")
    ///             Image(systemName: "checkmark")
    ///         }
    ///         .symbolVariant(.rectangle)
    ///     }
    ///
    /// ![A screenshot showing two rows of four symbols each. Both rows contain
    /// a plus sign, a minus sign, a multiplication sign, and a check mark.
    /// The symbols in the second row are versions of the symbols in the first
    /// row, but each is enclosed in a rectangle.](SymbolVariants-rectangle-1)
    public static let rectangle: SymbolVariants = { fatalError() }()

    /// A version of the variant that's encapsulated in a circle.
    ///
    /// Use this property to modify a variant like ``fill-swift.property``
    /// so that it's also contained in a circle:
    ///
    ///     Label("Fill Circle", systemImage: "bolt")
    ///         .symbolVariant(.fill.circle)
    ///
    /// ![A screenshot of a label that shows a bolt in a filled circle
    /// beside the words Fill Circle.](SymbolVariants-circle-2)
    public var circle: SymbolVariants { get { fatalError() } }

    /// A version of the variant that's encapsulated in a square.
    ///
    /// Use this property to modify a variant like ``fill-swift.property``
    /// so that it's also contained in a square:
    ///
    ///     Label("Fill Square", systemImage: "star")
    ///         .symbolVariant(.fill.square)
    ///
    /// ![A screenshot of a label that shows a star in a filled square
    /// beside the words Fill Square.](SymbolVariants-square-2)
    public var square: SymbolVariants { get { fatalError() } }

    /// A version of the variant that's encapsulated in a rectangle.
    ///
    /// Use this property to modify a variant like ``fill-swift.property``
    /// so that it's also contained in a rectangle:
    ///
    ///     Label("Fill Rectangle", systemImage: "plus")
    ///         .symbolVariant(.fill.rectangle)
    ///
    /// ![A screenshot of a label that shows a plus sign in a filled rectangle
    /// beside the words Fill Rectangle.](SymbolVariants-rectangle-2)
    public var rectangle: SymbolVariants { get { fatalError() } }

    /// A variant that fills the symbol.
    ///
    /// Use this variant with a call to the ``View/symbolVariant(_:)`` modifier
    /// to draw filled symbols, for those symbols that have a filled variant:
    ///
    ///     VStack(spacing: 20) {
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         .symbolVariant(.fill)
    ///     }
    ///
    /// ![A screenshot showing two rows of four symbols each. Both rows contain
    /// a flag, a heart, a bolt, and a star. The symbols in the second row are
    /// filled version of the symbols in the first row.](SymbolVariants-fill-1)
    public static let fill: SymbolVariants = { fatalError() }()

    /// A filled version of the variant.
    ///
    /// Use this property to modify a shape variant like
    /// ``circle-swift.type.property`` so that it's also filled:
    ///
    ///     Label("Circle Fill", systemImage: "flag")
    ///         .symbolVariant(.circle.fill)
    ///
    /// ![A screenshot of a label that shows a flag in a filled circle
    /// beside the words Circle Fill.](SymbolVariants-fill-2)
    public var fill: SymbolVariants { get { fatalError() } }

    /// A variant that draws a slash through the symbol.
    ///
    /// Use this variant with a call to the ``View/symbolVariant(_:)`` modifier
    /// to draw symbols with a slash, for those symbols that have such a
    /// variant:
    ///
    ///     VStack(spacing: 20) {
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "flag")
    ///             Image(systemName: "heart")
    ///             Image(systemName: "bolt")
    ///             Image(systemName: "star")
    ///         }
    ///         .symbolVariant(.slash)
    ///     }
    ///
    /// ![A screenshot showing two rows of four symbols each. Both rows contain
    /// a flag, a heart, a bolt, and a star. A slash is superimposed over
    /// all the symbols in the second row.](SymbolVariants-slash-1)
    public static let slash: SymbolVariants = { fatalError() }()

    /// A slashed version of the variant.
    ///
    /// Use this property to modify a shape variant like
    /// ``circle-swift.type.property`` so that it's also covered by a slash:
    ///
    ///     Label("Circle Slash", systemImage: "flag")
    ///         .symbolVariant(.circle.slash)
    ///
    /// ![A screenshot of a label that shows a flag in a circle with a
    /// slash over it beside the words Circle Slash.](SymbolVariants-slash-2)
    public var slash: SymbolVariants { get { fatalError() } }

    /// Returns a Boolean value that indicates whether the current variant
    /// contains the specified variant.
    ///
    /// - Parameter other: A variant to look for in this variant.
    /// - Returns: `true` if this variant contains `other`; otherwise,
    ///   `false`.
    public func contains(_ other: SymbolVariants) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (a: SymbolVariants, b: SymbolVariants) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// A view that switches between multiple child views using interactive user
/// interface elements.
///
/// To create a user interface with tabs, place views in a `TabView` and apply
/// the ``View/tabItem(_:)`` modifier to the contents of each tab. On iOS, you
/// can also use one of the badge modifiers, like ``View/badge(_:)-84e43``, to
/// assign a badge to each of the tabs.
///
/// The following example creates a tab view with three tabs, each presenting a
/// custom child view. The first tab has a numeric badge and the third has a
/// string badge.
///
///     TabView {
///         ReceivedView()
///             .badge(2)
///             .tabItem {
///                 Label("Received", systemImage: "tray.and.arrow.down.fill")
///             }
///         SentView()
///             .tabItem {
///                 Label("Sent", systemImage: "tray.and.arrow.up.fill")
///             }
///         AccountView()
///             .badge("!")
///             .tabItem {
///                 Label("Account", systemImage: "person.crop.circle.fill")
///             }
///     }
///
/// ![A tab bar with three tabs, each with an icon image and a text label.
/// The first and third tabs have badges.](TabView-1)
///
/// Use a ``Label`` for each tab item, or optionally a ``Text``, an ``Image``,
/// or an image followed by text. Passing any other type of view results in a
/// visible but empty tab item.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
public struct TabView<SelectionValue, Content> : View where SelectionValue : Hashable, Content : View {

    /// Creates an instance that selects from content associated with
    /// `Selection` values.
    public init(selection: Binding<SelectionValue>?, @ViewBuilder content: () -> Content) { fatalError() }

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

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
extension TabView where SelectionValue == Int {

    public init(@ViewBuilder content: () -> Content) { fatalError() }
}

/// A specification for the appearance and interaction of a `TabView`.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol TabViewStyle {
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
@available(macOS, unavailable)
extension TabViewStyle where Self == PageTabViewStyle {

    /// A `TabViewStyle` that implements a paged scrolling `TabView`.
    public static var page: PageTabViewStyle { get { fatalError() } }

    /// A `TabViewStyle` that implements a paged scrolling `TabView` with an
    /// index display mode.
    public static func page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode) -> PageTabViewStyle { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension TabViewStyle where Self == DefaultTabViewStyle {

    /// The default `TabView` style.
    public static var automatic: DefaultTabViewStyle { get { fatalError() } }
}

/// A type that applies a custom appearance to all tables within a view.
///
/// To configure the current table style for a view hierarchy, use the
/// ``View/tableStyle(_:)`` modifier.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol TableStyle {

    /// A view that represents the body of a table.
    associatedtype Body : View

    /// Creates a view that represents the body of a table.
    ///
    /// The system calls this method for each ``Table`` instance in a view
    /// hierarchy where this style is the current table style.
    ///
    /// - Parameter configuration: The properties of the table.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a table.
    typealias Configuration = TableStyleConfiguration
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableStyle where Self == AutomaticTableStyle {

    /// The default table style in the current context.
    public static var automatic: AutomaticTableStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TableStyle where Self == InsetTableStyle {

    /// The table style that describes the behavior and appearance of a table
    /// with its content and selection inset from the table edges.
    ///
    /// To customize whether the rows of the table should alternate their
    /// backgrounds, use ``View/alternatingRowBackgrounds(_:)``.
    public static var inset: InsetTableStyle { get { fatalError() } }
}

/// The properties of a table.
@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TableStyleConfiguration {
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
extension UnitPoint : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
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

/// A type that can serve as the animatable data of an animatable type.
///
/// `VectorArithmetic` extends the `AdditiveArithmetic` protocol with scalar
/// multiplication and a way to query the vector magnitude of the value. Use
/// this type as the `animatableData` associated type of a type that conforms to
/// the ``Animatable`` protocol.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol VectorArithmetic : AdditiveArithmetic {

    /// Multiplies each component of this value by the given value.
    mutating func scale(by rhs: Double)

    /// Returns the dot-product of this vector arithmetic instance with itself.
    var magnitudeSquared: Double { get }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension VectorArithmetic {

    /// Returns a value with each component of this value multiplied by the
    /// given value.
    public func scaled(by rhs: Double) -> Self { fatalError() }

    /// Interpolates this value with `other` by the specified `amount`.
    ///
    /// This is equivalent to `self = self + (other - self) * amount`.
    public mutating func interpolate(towards other: Self, amount: Double) { fatalError() }

    /// Returns this value interpolated with `other` by the specified `amount`.
    ///
    /// This result is equivalent to `self + (other - self) * amount`.
    public func interpolated(towards other: Self, amount: Double) -> Self { fatalError() }
}

/// An alignment position along the vertical axis.
///
/// Use vertical alignment guides to position views
/// relative to one another vertically, like when you place views side-by-side
/// in an ``HStack`` or when you create a row of views in a ``Grid`` using
/// ``GridRow``. The following example demonstrates common built-in
/// vertical alignments:
///
/// ![Five rows of content. Each row contains text inside
/// a box with horizontal lines to the left and the right of the box. The
/// lines are aligned vertically with the text in a different way for each
/// row, corresponding to the content of the text in that row. The text strings
/// are, in order, top, center, bottom, first text baseline, and last text
/// baseline.](VerticalAlignment-1-iOS)
///
/// You can generate the example above by creating a series of rows
/// implemented as horizontal stacks, where you configure each stack with a
/// different alignment guide:
///
///     private struct VerticalAlignmentGallery: View {
///         var body: some View {
///             VStack(spacing: 30) {
///                 row(alignment: .top, text: "Top")
///                 row(alignment: .center, text: "Center")
///                 row(alignment: .bottom, text: "Bottom")
///                 row(alignment: .firstTextBaseline, text: "First Text Baseline")
///                 row(alignment: .lastTextBaseline, text: "Last Text Baseline")
///             }
///         }
///
///         private func row(alignment: VerticalAlignment, text: String) -> some View {
///             HStack(alignment: alignment, spacing: 0) {
///                 Color.red.frame(height: 1)
///                 Text(text).font(.title).border(.gray)
///                 Color.red.frame(height: 1)
///             }
///         }
///     }
///
/// During layout, SkipUI aligns the views inside each stack by bringing
/// together the specified guides of the affected views. SkipUI calculates
/// the position of a guide for a particular view based on the characteristics
/// of the view. For example, the ``VerticalAlignment/center`` guide appears
/// at half the height of the view. You can override the guide calculation for a
/// particular view using the ``View/alignmentGuide(_:computeValue:)-6y3u2``
/// view modifier.
///
/// ### Text baseline alignment
///
/// Use the ``VerticalAlignment/firstTextBaseline`` or
/// ``VerticalAlignment/lastTextBaseline`` guide to match the bottom of either
/// the top- or bottom-most line of text that a view contains, respectively.
/// Text baseline alignment excludes the parts of characters that descend
/// below the baseline, like the tail on lower case g and j:
///
///     row(alignment: .firstTextBaseline, text: "fghijkl")
///
/// If you use a text baseline alignment on a view that contains no text,
/// SkipUI applies the equivalent of ``VerticalAlignment/bottom`` alignment
/// instead. For the row in the example above, SkipUI matches the bottom of
/// the horizontal lines with the baseline of the text:
///
/// ![A string containing the lowercase letters f, g, h, i, j, and
/// k. The string is inside a box, and horizontal lines appear to the left and
/// to the right of the box. The lines align with the bottom of the text,
/// excluding the descenders of letters g and j, which extend below the
/// baseline.](VerticalAlignment-2-iOS)
///
/// Aligning a text view to its baseline rather than to the bottom of its frame
/// produces the best layout effect in many cases, like when creating forms.
/// For example, you can align the baseline of descriptive text in
/// one ``GridRow`` cell with the baseline of a text field, or the label
/// of a checkbox, in another cell in the same row.
///
/// ### Custom alignment guides
///
/// You can create a custom vertical alignment guide by first creating a type
/// that conforms to the ``AlignmentID`` protocol, and then using that type to
/// initalize a new static property on `VerticalAlignment`:
///
///     private struct FirstThirdAlignment: AlignmentID {
///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
///             context.height / 3
///         }
///     }
///
///     extension VerticalAlignment {
///         static let firstThird = VerticalAlignment(FirstThirdAlignment.self)
///     }
///
/// You implement the ``AlignmentID/defaultValue(in:)`` method to calculate
/// a default value for the custom alignment guide. The method receives a
/// ``ViewDimensions`` instance that you can use to calculate a
/// value based on characteristics of the view. The example above places
/// the guide at one-third of the height of the view as measured from the
/// view's origin.
///
/// You can then use the custom alignment guide like any built-in guide. For
/// example, you can use it as the `alignment` parameter to an ``HStack``,
/// or to alter the guide calculation for a specific view using the
/// ``View/alignmentGuide(_:computeValue:)-6y3u2`` view modifier.
///
/// ### Composite alignment
///
/// Combine a `VerticalAlignment` with a ``HorizontalAlignment`` to create a
/// composite ``Alignment`` that indicates both vertical and horizontal
/// positioning in one value. For example, you could combine your custom
/// `firstThird` vertical alignment from the previous section with a built-in
/// ``HorizontalAlignment/center`` horizontal alignment to use in a ``ZStack``:
///
///     struct LayeredHorizontalStripes: View {
///         var body: some View {
///             ZStack(alignment: Alignment(horizontal: .center, vertical: .firstThird)) {
///                 horizontalStripes(color: .blue)
///                     .frame(width: 180, height: 90)
///                 horizontalStripes(color: .green)
///                     .frame(width: 70, height: 60)
///             }
///         }
///
///         private func horizontalStripes(color: Color) -> some View {
///             VStack(spacing: 1) {
///                 ForEach(0..<3) { _ in color }
///             }
///         }
///     }
///
/// The example above uses widths and heights that generate two mismatched
/// sets of three vertical stripes. The ``ZStack`` centers the two sets
/// horizontally and aligns them vertically one-third from the top
/// of each set. This aligns the bottom edges of the top stripe from each set:
///
/// ![Two sets of three vertically stacked rectangles. The first
/// set is blue. The second set of rectangles are green, smaller, and layered
/// on top of the first set. The two sets are centered horizontally, but align
/// vertically at the bottom edge of each set's top-most
/// rectangle.](VerticalAlignment-3-iOS)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct VerticalAlignment : Equatable {

    /// Creates a custom vertical alignment of the specified type.
    ///
    /// Use this initializer to create a custom vertical alignment. Define
    /// an ``AlignmentID`` type, and then use that type to create a new
    /// static property on ``VerticalAlignment``:
    ///
    ///     private struct FirstThirdAlignment: AlignmentID {
    ///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
    ///             context.height / 3
    ///         }
    ///     }
    ///
    ///     extension VerticalAlignment {
    ///         static let firstThird = VerticalAlignment(FirstThirdAlignment.self)
    ///     }
    ///
    /// Every vertical alignment instance that you create needs a unique
    /// identifier. For more information, see ``AlignmentID``.
    ///
    /// - Parameter id: The type of an identifier that uniquely identifies a
    ///   vertical alignment.
    public init(_ id: AlignmentID.Type) { fatalError() }

    public static func == (a: VerticalAlignment, b: VerticalAlignment) -> Bool { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension VerticalAlignment {

    /// Merges a sequence of explicit alignment values produced by
    /// this instance.
    ///
    /// For most alignment types, this method returns the mean of all non-`nil`
    /// values. However, some types use other rules. For example,
    /// ``VerticalAlignment/firstTextBaseline`` returns the minimum value,
    /// while ``VerticalAlignment/lastTextBaseline`` returns the maximum value.
    public func combineExplicit<S>(_ values: S) -> CGFloat? where S : Sequence, S.Element == CGFloat? { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension VerticalAlignment {

    /// A guide that marks the top edge of the view.
    ///
    /// Use this guide to align the top edges of views:
    ///
    /// ![A box that contains the word, Top. A horizontal
    /// line appears on either side of the box. The lines align vertically
    /// with the top edge of the box.](VerticalAlignment-top-1-iOS)
    ///
    /// The following code generates the image above using an ``HStack``:
    ///
    ///     struct VerticalAlignmentTop: View {
    ///         var body: some View {
    ///             HStack(alignment: .top, spacing: 0) {
    ///                 Color.red.frame(height: 1)
    ///                 Text("Top").font(.title).border(.gray)
    ///                 Color.red.frame(height: 1)
    ///             }
    ///         }
    ///     }
    ///
    public static let top: VerticalAlignment = { fatalError() }()

    /// A guide that marks the vertical center of the view.
    ///
    /// Use this guide to align the centers of views:
    ///
    /// ![A box that contains the word, Center. A horizontal
    /// line appears on either side of the box. The lines align vertically
    /// with the center of the box.](VerticalAlignment-center-1-iOS)
    ///
    /// The following code generates the image above using an ``HStack``:
    ///
    ///     struct VerticalAlignmentCenter: View {
    ///         var body: some View {
    ///             HStack(alignment: .center, spacing: 0) {
    ///                 Color.red.frame(height: 1)
    ///                 Text("Center").font(.title).border(.gray)
    ///                 Color.red.frame(height: 1)
    ///             }
    ///         }
    ///     }
    ///
    public static let center: VerticalAlignment = { fatalError() }()

    /// A guide that marks the bottom edge of the view.
    ///
    /// Use this guide to align the bottom edges of views:
    ///
    /// ![A box that contains the word, Bottom. A horizontal
    /// line appears on either side of the box. The lines align vertically
    /// with the bottom edge of the box.](VerticalAlignment-bottom-1-iOS)
    ///
    /// The following code generates the image above using an ``HStack``:
    ///
    ///     struct VerticalAlignmentBottom: View {
    ///         var body: some View {
    ///             HStack(alignment: .bottom, spacing: 0) {
    ///                 Color.red.frame(height: 1)
    ///                 Text("Bottom").font(.title).border(.gray)
    ///                 Color.red.frame(height: 1)
    ///             }
    ///         }
    ///     }
    ///
    public static let bottom: VerticalAlignment = { fatalError() }()

    /// A guide that marks the top-most text baseline in a view.
    ///
    /// Use this guide to align with the baseline of the top-most text in a
    /// view. The guide aligns with the bottom of a view that contains no text:
    ///
    /// ![A box that contains the text, First Text Baseline.
    /// A horizontal line appears on either side of the box. The lines align
    /// vertically with the baseline of the first line of
    /// text.](VerticalAlignment-firstTextBaseline-1-iOS)
    ///
    /// The following code generates the image above using an ``HStack``:
    ///
    ///     struct VerticalAlignmentFirstTextBaseline: View {
    ///         var body: some View {
    ///             HStack(alignment: .firstTextBaseline, spacing: 0) {
    ///                 Color.red.frame(height: 1)
    ///                 Text("First Text Baseline").font(.title).border(.gray)
    ///                 Color.red.frame(height: 1)
    ///             }
    ///         }
    ///     }
    public static let firstTextBaseline: VerticalAlignment = { fatalError() }()

    /// A guide that marks the bottom-most text baseline in a view.
    ///
    /// Use this guide to align with the baseline of the bottom-most text in a
    /// view. The guide aligns with the bottom of a view that contains no text.
    ///
    /// ![A box that contains the text, Last Text Baseline.
    /// A horizontal line appears on either side of the box. The lines align
    /// vertically with the baseline of the last line of
    /// text.](VerticalAlignment-lastTextBaseline-1-iOS)
    ///
    /// The following code generates the image above using an ``HStack``:
    ///
    ///     struct VerticalAlignmentLastTextBaseline: View {
    ///         var body: some View {
    ///             HStack(alignment: .lastTextBaseline, spacing: 0) {
    ///                 Color.red.frame(height: 1)
    ///                 Text("Last Text Baseline").font(.title).border(.gray)
    ///                 Color.red.frame(height: 1)
    ///             }
    ///         }
    ///     }
    ///
    public static let lastTextBaseline: VerticalAlignment = { fatalError() }()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension VerticalAlignment : Sendable {
}

/// An edge on the vertical axis.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@frozen public enum VerticalEdge : Int8, CaseIterable, Codable {

    /// The top edge.
    case top

    /// The bottom edge.
    case bottom

    /// An efficient set of `VerticalEdge`s.
    @frozen public struct Set : OptionSet {

        /// The element type of the option set.
        ///
        /// To inherit all the default implementations from the `OptionSet` protocol,
        /// the `Element` type must be `Self`, the default.
        public typealias Element = VerticalEdge.Set

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

        /// A set containing only the top vertical edge.
        public static let top: VerticalEdge.Set = { fatalError() }()

        /// A set containing only the bottom vertical edge.
        public static let bottom: VerticalEdge.Set = { fatalError() }()

        /// A set containing the top and bottom vertical edges.
        public static let all: VerticalEdge.Set = { fatalError() }()

        /// Creates an instance containing just `e`
        public init(_ e: VerticalEdge) { fatalError() }

        /// The type of the elements of an array literal.
        public typealias ArrayLiteralElement = VerticalEdge.Set.Element

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
    public typealias AllCases = [VerticalEdge]

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int8

    /// A collection of all values of this type.
    public static var allCases: [VerticalEdge] { get { fatalError() } }

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

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension VerticalEdge : Equatable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension VerticalEdge : Hashable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension VerticalEdge : RawRepresentable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension VerticalEdge : Sendable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension VerticalEdge.Set : Sendable {
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

/// A view's size and alignment guides in its own coordinate space.
///
/// This structure contains the size and alignment guides of a view.
/// You receive an instance of this structure to use in a variety of
/// layout calculations, like when you:
///
/// * Define a default value for a custom alignment guide;
///   see ``AlignmentID/defaultValue(in:)``.
/// * Modify an alignment guide on a view;
///   see ``View/alignmentGuide(_:computeValue:)-9mdoh``.
/// * Ask for the dimensions of a subview of a custom view layout;
///   see ``LayoutSubview/dimensions(in:)``.
///
/// ### Custom alignment guides
///
/// You receive an instance of this structure as the `context` parameter to
/// the ``AlignmentID/defaultValue(in:)`` method that you implement to produce
/// the default offset for an alignment guide, or as the first argument to the
/// closure you provide to the ``View/alignmentGuide(_:computeValue:)-6y3u2``
/// view modifier to override the default calculation for an alignment guide.
/// In both cases you can use the instance, if helpful, to calculate the
/// offset for the guide. For example, you could compute a default offset
/// for a custom ``VerticalAlignment`` as a fraction of the view's ``height``:
///
///     private struct FirstThirdAlignment: AlignmentID {
///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
///             context.height / 3
///         }
///     }
///
///     extension VerticalAlignment {
///         static let firstThird = VerticalAlignment(FirstThirdAlignment.self)
///     }
///
/// As another example, you could use the view dimensions instance to look
/// up the offset of an existing guide and modify it:
///
///     struct ViewDimensionsOffset: View {
///         var body: some View {
///             VStack(alignment: .leading) {
///                 Text("Default")
///                 Text("Indented")
///                     .alignmentGuide(.leading) { context in
///                         context[.leading] - 10
///                     }
///             }
///         }
///     }
///
/// The example above indents the second text view because the subtraction
/// moves the second text view's leading guide in the negative x direction,
/// which is to the left in the view's coordinate space. As a result,
/// SkipUI moves the second text view to the right, relative to the first
/// text view, to keep their leading guides aligned:
///
/// ![A screenshot of two strings. The first says Default and the second,
/// which appears below the first, says Indented. The left side of the second
/// string appears horizontally offset to the right from the left side of the
/// first string by about the width of one character.](ViewDimensions-1-iOS)
///
/// ### Layout direction
///
/// The discussion above describes a left-to-right language environment,
/// but you don't change your guide calculation to operate in a right-to-left
/// environment. SkipUI moves the view's origin from the left to the right side
/// of the view and inverts the positive x direction. As a result,
/// the existing calculation produces the same effect, but in the opposite
/// direction.
///
/// You can see this if you use the ``View/environment(_:_:)``
/// modifier to set the ``EnvironmentValues/layoutDirection`` property for the
/// view that you defined above:
///
///     ViewDimensionsOffset()
///         .environment(\.layoutDirection, .rightToLeft)
///
/// With no change in your guide, this produces the desired effect ---
/// it indents the second text view's right side, relative to the
/// first text view's right side. The leading edge is now on the right,
/// and the direction of the offset is reversed:
///
/// ![A screenshot of two strings. The first says Default and the second,
/// which appears below the first, says Indented. The right side of the second
/// string appears horizontally offset to the left from the right side of the
/// first string by about the width of one character.](ViewDimensions-2-iOS)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ViewDimensions {

    /// The view's width.
    public var width: CGFloat { get { fatalError() } }

    /// The view's height.
    public var height: CGFloat { get { fatalError() } }

    /// Gets the value of the given horizontal guide.
    ///
    /// Find the offset of a particular guide in the corresponding view by
    /// using that guide as an index to read from the context:
    ///
    ///     .alignmentGuide(.leading) { context in
    ///         context[.leading] - 10
    ///     }
    ///
    /// For information about using subscripts in Swift to access member
    /// elements of a collection, list, or, sequence, see
    /// [Subscripts](https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html)
    /// in _The Swift Programming Language_.
    public subscript(guide: HorizontalAlignment) -> CGFloat { get { fatalError() } }

    /// Gets the value of the given vertical guide.
    ///
    /// Find the offset of a particular guide in the corresponding view by
    /// using that guide as an index to read from the context:
    ///
    ///     .alignmentGuide(.top) { context in
    ///         context[.top] - 10
    ///     }
    ///
    /// For information about using subscripts in Swift to access member
    /// elements of a collection, list, or, sequence, see
    /// [Subscripts](https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html)
    /// in _The Swift Programming Language_.
    public subscript(guide: VerticalAlignment) -> CGFloat { get { fatalError() } }

    /// Gets the explicit value of the given horizontal alignment guide.
    ///
    /// Find the horizontal offset of a particular guide in the corresponding
    /// view by using that guide as an index to read from the context:
    ///
    ///     .alignmentGuide(.leading) { context in
    ///         context[.leading] - 10
    ///     }
    ///
    /// This subscript returns `nil` if no value exists for the guide.
    ///
    /// For information about using subscripts in Swift to access member
    /// elements of a collection, list, or, sequence, see
    /// [Subscripts](https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html)
    /// in _The Swift Programming Language_.
    public subscript(explicit guide: HorizontalAlignment) -> CGFloat? { get { fatalError() } }

    /// Gets the explicit value of the given vertical alignment guide
    ///
    /// Find the vertical offset of a particular guide in the corresponding
    /// view by using that guide as an index to read from the context:
    ///
    ///     .alignmentGuide(.top) { context in
    ///         context[.top] - 10
    ///     }
    ///
    /// This subscript returns `nil` if no value exists for the guide.
    ///
    /// For information about using subscripts in Swift to access member
    /// elements of a collection, list, or, sequence, see
    /// [Subscripts](https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html)
    /// in _The Swift Programming Language_.
    public subscript(explicit guide: VerticalAlignment) -> CGFloat? { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewDimensions : Equatable {

    public static func == (lhs: ViewDimensions, rhs: ViewDimensions) -> Bool { fatalError() }
}

/// A modifier that you apply to a view or another view modifier, producing a
/// different version of the original value.
///
/// Adopt the ``ViewModifier`` protocol when you want to create a reusable
/// modifier that you can apply to any view. The example below combines several
/// modifiers to create a new modifier that you can use to create blue caption
/// text surrounded by a rounded rectangle:
///
///     struct BorderedCaption: ViewModifier {
///         func body(content: Content) -> some View {
///             content
///                 .font(.caption2)
///                 .padding(10)
///                 .overlay(
///                     RoundedRectangle(cornerRadius: 15)
///                         .stroke(lineWidth: 1)
///                 )
///                 .foregroundColor(Color.blue)
///         }
///     }
///
/// You can apply ``View/modifier(_:)`` directly to a view, but a more common
/// and idiomatic approach uses ``View/modifier(_:)`` to define an extension to
/// ``View`` itself that incorporates the view modifier:
///
///     extension View {
///         func borderedCaption() -> some View {
///             modifier(BorderedCaption())
///         }
///     }
///
/// You can then apply the bordered caption to any view, similar to this:
///
///     Image(systemName: "bus")
///         .resizable()
///         .frame(width:50, height:50)
///     Text("Downtown Bus")
///         .borderedCaption()
///
/// ![A screenshot showing the image of a bus with a caption reading
/// Downtown Bus. A view extension, using custom a modifier, renders the
///  caption in blue text surrounded by a rounded
///  rectangle.](SkipUI-View-ViewModifier.png)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol ViewModifier {

    /// The type of view representing the body.
    associatedtype Body : View

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    @ViewBuilder @MainActor func body(content: Self.Content) -> Self.Body

    /// The content view type passed to `body()`.
    associatedtype Content
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewModifier where Self.Body == Never {

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: Self.Content) -> Self.Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewModifier {

    /// Returns a new modifier that is the result of concatenating
    /// `self` with `modifier`.
    @inlinable public func concat<T>(_ modifier: T) -> ModifiedContent<Self, T> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewModifier {

    /// Returns a new version of the modifier that will apply the
    /// transaction mutation function `transform` to all transactions
    /// within the modifier.
//    @inlinable public func transaction(_ transform: @escaping (inout Transaction) -> Void) -> some ViewModifier { fatalError() }


    /// Returns a new version of the modifier that will apply
    /// `animation` to all animatable values within the modifier.
//    @inlinable public func animation(_ animation: Animation?) -> some ViewModifier { fatalError() }

}

/// A collection of the geometric spacing preferences of a view.
///
/// This type represents how much space a view prefers to have between it and
/// the next view in a layout. The type stores independent values
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


/// A view that overlays its subviews, aligning them in both axes.
///
/// The `ZStack` assigns each successive subview a higher z-axis value than
/// the one before it, meaning later subviews appear "on top" of earlier ones.
///
/// The following example creates a `ZStack` of 100 x 100 point ``Rectangle``
/// views filled with one of six colors, offsetting each successive subview
/// by 10 points so they don't completely overlap:
///
///     let colors: [Color] =
///         [.red, .orange, .yellow, .green, .blue, .purple]
///
///     var body: some View {
///         ZStack {
///             ForEach(0..<colors.count) {
///                 Rectangle()
///                     .fill(colors[$0])
///                     .frame(width: 100, height: 100)
///                     .offset(x: CGFloat($0) * 10.0,
///                             y: CGFloat($0) * 10.0)
///             }
///         }
///     }
///
/// ![Six squares of different colors, stacked atop each other, with a 10-point
/// offset in both the x and y axes for each layer so they can be
/// seen.](SkipUI-ZStack-offset-rectangles.png)
///
/// The `ZStack` uses an ``Alignment`` to set the x- and y-axis coordinates of
/// each subview, defaulting to a ``Alignment/center`` alignment. In the following
/// example, the `ZStack` uses a ``Alignment/bottomLeading`` alignment to lay
/// out two subviews, a red 100 x 50 point rectangle below, and a blue 50 x 100
/// point rectangle on top. Because of the alignment value, both rectangles
/// share a bottom-left corner with the `ZStack` (in locales where left is the
/// leading side).
///
///     var body: some View {
///         ZStack(alignment: .bottomLeading) {
///             Rectangle()
///                 .fill(Color.red)
///                 .frame(width: 100, height: 50)
///             Rectangle()
///                 .fill(Color.blue)
///                 .frame(width:50, height: 100)
///         }
///         .border(Color.green, width: 1)
///     }
///
/// ![A green 100 by 100 square containing two overlapping rectangles: on the
/// bottom, a red 100 by 50 rectangle, and atop it, a blue 50 by 100 rectangle.
/// The rectangles share their bottom left point with the containing green
/// square.](SkipUI-ZStack-alignment.png)
///
/// > Note: If you need a version of this stack that conforms to the ``Layout``
/// protocol, like when you want to create a conditional layout using
/// ``AnyLayout``, use ``ZStackLayout`` instead.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct ZStack<Content> : View where Content : View {

    /// Creates an instance with the given alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack on both
    ///     the x- and y-axes.
    ///   - content: A view builder that creates the content of this stack.
    @inlinable public init(alignment: Alignment = .center, @ViewBuilder content: () -> Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never

    public var body: Body { fatalError() }
}

/// An overlaying container that you can use in conditional layouts.
///
/// This layout container behaves like a ``ZStack``, but conforms to the
/// ``Layout`` protocol so you can use it in the conditional layouts that you
/// construct with ``AnyLayout``. If you don't need a conditional layout, use
/// ``ZStack`` instead.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct ZStackLayout : Layout {
    /// The alignment of subviews.
    public var alignment: Alignment { get { fatalError() } }
    
    /// Creates a stack with the specified alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack
    ///     on both the x- and y-axes.
    @inlinable public init(alignment: Alignment = .center) { fatalError() }
    
    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
    
    /// Cached values associated with the layout instance.
    ///
    /// If you create a cache for your custom layout, you can use
    /// a type alias to define this type as your data storage type.
    /// Alternatively, you can refer to the data storage type directly in all
    /// the places where you work with the cache.
    ///
    /// See ``makeCache(subviews:)-23agy`` for more information.
    public typealias Cache = Void

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        fatalError()
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        fatalError()
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ZStackLayout : Sendable {
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

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Never {

    /// The type of value of rows presented by this column content.
    public typealias TableRowValue = Never
}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Never : TableRowContent {

    /// The type of content representing the body of this table row content.
    public typealias TableRowBody = Never

    /// The composition of content that comprise the table row content.
    public var tableRowBody: Never { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Never : Gesture {

    /// The type representing the gesture's value.
    public typealias Value = Never
}

/// Extends `T?` to conform to `Gesture` type if `T` also conforms to
/// `Gesture`. A nil value is mapped to an empty (i.e. failing)
/// gesture.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Optional : Gesture where Wrapped : Gesture {

    /// The type representing the gesture's value.
    public typealias Value = Wrapped.Value

    public typealias Body = Never
    public var body: Never { return never() }
}


@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Never : Scene {
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension Never : WidgetConfiguration {
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Double : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = Double
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CGFloat : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = CGFloat
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Optional : View where Wrapped : View {

    public var body: some View { get { return never() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Never : ShapeStyle {

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
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

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGPoint : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGSize : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGRect : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = Never // AnimatablePair<CGPoint.AnimatableData, CGSize.AnimatableData>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Float : VectorArithmetic {

    /// Multiplies each component of this value by the given value.
    public mutating func scale(by rhs: Double) { fatalError() }

    /// Returns the dot-product of this vector arithmetic instance with itself.
    public var magnitudeSquared: Double { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Double : VectorArithmetic {

    /// Multiplies each component of this value by the given value.
    public mutating func scale(by rhs: Double) { fatalError() }

    /// Returns the dot-product of this vector arithmetic instance with itself.
    public var magnitudeSquared: Double { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGFloat : VectorArithmetic {

    /// Multiplies each component of this value by the given value.
    public mutating func scale(by rhs: Double) { fatalError() }

    /// Returns the dot-product of this vector arithmetic instance with itself.
    public var magnitudeSquared: Double { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Optional : TableRowContent where Wrapped : TableRowContent {

    /// The type of value represented by this table row content.
    public typealias TableRowValue = Wrapped.TableRowValue

    /// The type of content representing the body of this table row content.
    public typealias TableRowBody = Never
    public var tableRowBody: TableRowBody { fatalError() }
}

extension AttributeScopes {
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
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension AttributeDynamicLookup {

//    public subscript<T>(dynamicMember keyPath: KeyPath<AttributeScopes.SkipUIAttributes, T>) -> T where T : AttributedStringKey { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Never : Keyframes {
}

extension Never : Widget {
    public init() {
        fatalError()
    }
    
}

extension Never : Shape {
    public typealias AnimatableData = Never
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    public func path(in rect: CGRect) -> Path {
        fatalError()
    }
}

extension Never : DynamicViewContent {
    public typealias Data = [Never]

    /// The collection of underlying data.
    public var data: Self.Data { fatalError() }
}

extension Never : InsettableShape {
    public func inset(by amount: CGFloat) -> Never {
        fatalError()
    }
}

extension Never : VectorArithmetic {
    public static func - (lhs: Never, rhs: Never) -> Never { fatalError() }
    public static func + (lhs: Never, rhs: Never) -> Never { fatalError() }
    public mutating func scale(by rhs: Double) { fatalError() }
    public var magnitudeSquared: Double { fatalError() }
    public static var zero: Never { fatalError() }
}

extension Never : KeyframeTrackContent {
}
