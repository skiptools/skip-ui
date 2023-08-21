// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import struct Foundation.Date
import class Foundation.Progress

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

    @MainActor public var body: some View { get { return stubView() } }

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
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A type-erased label that describes the current value of a progress view.
    public struct CurrentValueLabel : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
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
    public func makeBody(configuration: CircularProgressViewStyle.Configuration) -> some View { return stubView() }


    /// A view representing the body of a progress view.
//    public typealias Body = some View
}

/// The default type of the current value label when used by a date-relative
/// progress view.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct DefaultDateProgressLabel : View {

    @MainActor public var body: some View { get { return stubView() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
//    public typealias Body = some View
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
    public func makeBody(configuration: DefaultProgressViewStyle.Configuration) -> some View { return stubView() }


    /// A view representing the body of a progress view.
//    public typealias Body = some View
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
    public func makeBody(configuration: LinearProgressViewStyle.Configuration) -> some View { return stubView() }


    /// A view representing the body of a progress view.
//    public typealias Body = some View
}

#endif
