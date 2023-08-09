// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import struct Foundation.Date
import typealias Foundation.TimeInterval

/// A type that provides a sequence of dates for use as a schedule.
///
/// Types that conform to this protocol implement a particular kind of schedule
/// by defining an ``TimelineSchedule/entries(from:mode:)`` method that returns
/// a sequence of dates. Use a timeline schedule type when you initialize
/// a ``TimelineView``. For example, you can create a timeline view that
/// updates every second, starting from some `startDate`, using a
/// periodic schedule returned by ``TimelineSchedule/periodic(from:by:)``:
///
///     TimelineView(.periodic(from: startDate, by: 1.0)) { context in
///         // View content goes here.
///     }
///
/// You can also create custom timeline schedules.
/// The timeline view updates its content according to the
/// sequence of dates produced by the schedule.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public protocol TimelineSchedule {

    /// An alias for the timeline schedule update mode.
    typealias Mode = TimelineScheduleMode

    /// The sequence of dates within a schedule.
    ///
    /// The ``TimelineSchedule/entries(from:mode:)`` method returns a value
    /// of this type, which is a
    /// of dates in ascending order. A ``TimelineView`` that you create with a
    /// schedule updates its content at the moments in time corresponding to
    /// the dates included in the sequence.
    associatedtype Entries : Sequence where Self.Entries.Element == Date

    /// Provides a sequence of dates starting around a given date.
    ///
    /// A ``TimelineView`` that you create calls this method to figure out
    /// when to update its content. The method returns a sequence of dates in
    /// increasing order that represent points in time when the timeline view
    /// should update. Types that conform to the ``TimelineSchedule`` protocol,
    /// like the one returned by ``TimelineSchedule/periodic(from:by:)``, or a custom schedule that
    /// you define, implement a custom version of this method to implement a
    /// particular kind of schedule.
    ///
    /// One or more dates in the sequence might be before the given
    /// `startDate`, in which case the timeline view performs its first
    /// update at `startDate` using the entry that most closely precedes
    /// that date. For example, if in response to a `startDate` of
    /// `10:09:55`, the method returns a sequence with the values `10:09:00`,
    /// `10:10:00`, `10:11:00`, and so on, the timeline view performs an initial
    /// update at `10:09:55` (using the `10:09:00` entry), followed by another
    /// update at the beginning of every minute, starting at `10:10:00`.
    ///
    /// A type that conforms should adjust its behavior based on the `mode` when
    /// possible. For example, a periodic schedule providing updates
    /// for a timer could restrict updates to once per minute while in the
    /// ``TimelineScheduleMode/lowFrequency`` mode:
    ///
    ///     func entries(
    ///         from startDate: Date, mode: TimelineScheduleMode
    ///     ) -> PeriodicTimelineSchedule {
    ///         .periodic(
    ///             from: startDate, by: (mode == .lowFrequency ? 60.0 : 1.0)
    ///         )
    ///     }
    ///
    /// - Parameters:
    ///   - startDate: The date by which the sequence begins.
    ///   - mode: An indication of whether the schedule updates normally,
    ///     or with some other cadence.
    /// - Returns: A sequence of dates in ascending order.
    func entries(from startDate: Date, mode: Self.Mode) -> Self.Entries
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension TimelineSchedule where Self == AnimationTimelineSchedule {

    /// A pausable schedule of dates updating at a frequency no more quickly
    /// than the provided interval.
    public static var animation: AnimationTimelineSchedule { get { fatalError() } }

    /// A pausable schedule of dates updating at a frequency no more quickly
    /// than the provided interval.
    ///
    /// - Parameters:
    ///     - minimumInterval: The minimum interval to update the schedule at.
    ///     Pass nil to let the system pick an appropriate update interval.
    ///     - paused: If the schedule should stop generating updates.
    public static func animation(minimumInterval: Double? = nil, paused: Bool = false) -> AnimationTimelineSchedule { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension TimelineSchedule where Self == PeriodicTimelineSchedule {

    /// A schedule for updating a timeline view at regular intervals.
    ///
    /// Initialize a ``TimelineView`` with a periodic timeline schedule when
    /// you want to schedule timeline view updates periodically with a custom
    /// interval:
    ///
    ///     TimelineView(.periodic(from: startDate, by: 3.0)) { context in
    ///         Text(context.date.description)
    ///     }
    ///
    /// The timeline view updates its content at the start date, and then
    /// again at dates separated in time by the interval amount, which is every
    /// three seconds in the example above. For a start date in the
    /// past, the view updates immediately, providing as context the date
    /// corresponding to the most recent interval boundary. The view then
    /// refreshes normally at subsequent interval boundaries. For a start date
    /// in the future, the view updates once with the current date, and then
    /// begins regular updates at the start date.
    ///
    /// The schedule defines the ``PeriodicTimelineSchedule/Entries``
    /// structure to return the sequence of dates when the timeline view calls
    /// the ``PeriodicTimelineSchedule/entries(from:mode:)`` method.
    ///
    /// - Parameters:
    ///   - startDate: The date on which to start the sequence.
    ///   - interval: The time interval between successive sequence entries.
    public static func periodic(from startDate: Date, by interval: TimeInterval) -> PeriodicTimelineSchedule { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension TimelineSchedule where Self == EveryMinuteTimelineSchedule {

    /// A schedule for updating a timeline view at the start of every minute.
    ///
    /// Initialize a ``TimelineView`` with an every minute timeline schedule
    /// when you want to schedule timeline view updates at the start of every
    /// minute:
    ///
    ///     TimelineView(.everyMinute) { context in
    ///         Text(context.date.description)
    ///     }
    ///
    /// The schedule provides the first date as the beginning of the minute in
    /// which you use it to initialize the timeline view. For example, if you
    /// create the timeline view at `10:09:38`, the schedule's first entry is
    /// `10:09:00`. In response, the timeline view performs its first update
    /// immediately, providing the beginning of the current minute, namely
    /// `10:09:00`, as context to its content. Subsequent updates happen at the
    /// beginning of each minute that follows.
    ///
    /// The schedule defines the ``EveryMinuteTimelineSchedule/Entries``
    /// structure to return the sequence of dates when the timeline view calls
    /// the ``EveryMinuteTimelineSchedule/entries(from:mode:)`` method.
    public static var everyMinute: EveryMinuteTimelineSchedule { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension TimelineSchedule {

    /// A schedule for updating a timeline view at explicit points in time.
    ///
    /// Initialize a ``TimelineView`` with an explicit timeline schedule when
    /// you want to schedule view updates at particular points in time:
    ///
    ///     let dates = [
    ///         Date(timeIntervalSinceNow: 10), // Update ten seconds from now,
    ///         Date(timeIntervalSinceNow: 12) // and a few seconds later.
    ///     ]
    ///
    ///     struct MyView: View {
    ///         var body: some View {
    ///             TimelineView(.explicit(dates)) { context in
    ///                 Text(context.date.description)
    ///             }
    ///         }
    ///     }
    ///
    /// The timeline view updates its content on exactly the dates that
    /// you specify, until it runs out of dates, after which it stops changing.
    /// If the dates you provide are in the past, the timeline view updates
    /// exactly once with the last entry. If you only provide dates in the
    /// future, the timeline view renders with the current date until the first
    /// date arrives. If you provide one or more dates in the past and one or
    /// more in the future, the view renders the most recent past date,
    /// refreshing normally on all subsequent dates.
    ///
    /// - Parameter dates: The sequence of dates at which a timeline view
    ///   updates. Use a monotonically increasing sequence of dates,
    ///   and ensure that at least one is in the future.
    public static func explicit<S>(_ dates: S) -> ExplicitTimelineSchedule<S> where Self == ExplicitTimelineSchedule<S>, S : Sequence, S.Element == Date { fatalError() }
}

/// A mode of operation for timeline schedule updates.
///
/// A ``TimelineView`` provides a mode when calling its schedule's
/// ``TimelineSchedule/entries(from:mode:)`` method.
/// The view chooses a mode based on the state of the system.
/// For example, a watchOS view might request a lower frequency
/// of updates, using the ``lowFrequency`` mode, when the user
/// lowers their wrist.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum TimelineScheduleMode : Sendable {

    /// A mode that produces schedule updates at the schedule's natural cadence.
    case normal

    /// A mode that produces schedule updates at a reduced rate.
    ///
    /// In this mode, the schedule should generate only
    /// "major" updates, if possible. For example, a timeline providing
    /// updates to a timer might restrict updates to once a minute while in
    /// this mode.
    case lowFrequency

    public static func == (a: TimelineScheduleMode, b: TimelineScheduleMode) -> Bool { fatalError() }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension TimelineScheduleMode : Equatable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension TimelineScheduleMode : Hashable {
}

/// A view that updates according to a schedule that you provide.
///
/// A timeline view acts as a container with no appearance of its own. Instead,
/// it redraws the content it contains at scheduled points in time.
/// For example, you can update the face of an analog timer once per second:
///
///     TimelineView(.periodic(from: startDate, by: 1)) { context in
///         AnalogTimerView(date: context.date)
///     }
///
/// The closure that creates the content receives an input of type ``Context``
/// that you can use to customize the content's appearance. The context includes
/// the ``Context/date`` that triggered the update. In the example above,
/// the timeline view sends that date to an analog timer that you create so the
/// timer view knows how to draw the hands on its face.
///
/// The context also includes a ``Context/cadence-swift.property``
/// property that you can use to hide unnecessary detail. For example, you
/// can use the cadence to decide when it's appropriate to display the
/// timer's second hand:
///
///     TimelineView(.periodic(from: startDate, by: 1.0)) { context in
///         AnalogTimerView(
///             date: context.date,
///             showSeconds: context.cadence <= .seconds)
///     }
///
/// The system might use a cadence that's slower than the schedule's
/// update rate. For example, a view on watchOS might remain visible when the
/// user lowers their wrist, but update less frequently, and thus require
/// less detail.
///
/// You can define a custom schedule by creating a type that conforms to the
/// ``TimelineSchedule`` protocol, or use one of the built-in schedule types:
/// * Use an ``TimelineSchedule/everyMinute`` schedule to update at the
///   beginning of each minute.
/// * Use a ``TimelineSchedule/periodic(from:by:)`` schedule to update
///   periodically with a custom start time and interval between updates.
/// * Use an ``TimelineSchedule/explicit(_:)`` schedule when you need a finite number, or
///   irregular set of updates.
///
/// For a schedule containing only dates in the past,
/// the timeline view shows the last date in the schedule.
/// For a schedule containing only dates in the future,
/// the timeline draws its content using the current date
/// until the first scheduled date arrives.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct TimelineView<Schedule, Content> where Schedule : TimelineSchedule {

    /// Information passed to a timeline view's content callback.
    ///
    /// The context includes both the ``date`` from the schedule that triggered
    /// the callback, and a ``cadence-swift.property`` that you can use
    /// to customize the appearance of your view. For example, you might choose
    /// to display the second hand of an analog clock only when the cadence is
    /// ``Cadence-swift.enum/seconds`` or faster.
    public struct Context {

        /// A rate at which timeline views can receive updates.
        ///
        /// Use the cadence presented to content in a ``TimelineView`` to hide
        /// information that updates faster than the view's current update rate.
        /// For example, you could hide the millisecond component of a digital
        /// timer when the cadence is ``seconds`` or ``minutes``.
        ///
        /// Because this enumeration conforms to the
            /// protocol, you can compare cadences with relational operators.
        /// Slower cadences have higher values, so you could perform the check
        /// described above with the following comparison:
        ///
        ///     let hideMilliseconds = cadence > .live
        ///
        public enum Cadence : Comparable, Sendable {

            /// Updates the view continuously.
            case live

            /// Updates the view approximately once per second.
            case seconds

            /// Updates the view approximately once per minute.
            case minutes

            /// Returns a Boolean value indicating whether two values are equal.
            ///
            /// Equality is the inverse of inequality. For any values `a` and `b`,
            /// `a == b` implies that `a != b` is `false`.
            ///
            /// - Parameters:
            ///   - lhs: A value to compare.
            ///   - rhs: Another value to compare.
            public static func == (a: TimelineView<Schedule, Content>.Context.Cadence, b: TimelineView<Schedule, Content>.Context.Cadence) -> Bool { fatalError() }

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
            public static func < (a: TimelineView<Schedule, Content>.Context.Cadence, b: TimelineView<Schedule, Content>.Context.Cadence) -> Bool { fatalError() }

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

        /// The date from the schedule that triggered the current view update.
        ///
        /// The first time a ``TimelineView`` closure receives this date, it
        /// might be in the past. For example, if you create an
        /// ``TimelineSchedule/everyMinute`` schedule at `10:09:55`, the
        /// schedule creates entries `10:09:00`, `10:10:00`, `10:11:00`, and so
        /// on. In response, the timeline view performs an initial update
        /// immediately, at `10:09:55`, but the context contains the `10:09:00`
        /// date entry. Subsequent entries arrive at their corresponding times.
        public let date: Date = { fatalError() }()

        /// The rate at which the timeline updates the view.
        ///
        /// Use this value to hide information that updates faster than the
        /// view's current update rate. For example, you could hide the
        /// millisecond component of a digital timer when the cadence is
        /// anything slower than ``Cadence-swift.enum/live``.
        ///
        /// Because the ``Cadence-swift.enum`` enumeration conforms to the
            /// protocol, you can compare cadences with relational operators.
        /// Slower cadences have higher values, so you could perform the check
        /// described above with the following comparison:
        ///
        ///     let hideMilliseconds = cadence > .live
        ///
        public let cadence: TimelineView<Schedule, Content>.Context.Cadence = { fatalError() }()
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension TimelineView : View where Content : View {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }

    /// Creates a new timeline view that uses the given schedule.
    ///
    /// - Parameters:
    ///   - schedule: A schedule that produces a sequence of dates that
    ///     indicate the instances when the view should update.
    ///     Use a type that conforms to ``TimelineSchedule``, like
    ///     ``TimelineSchedule/everyMinute``, or a custom timeline schedule
    ///     that you define.
    ///   - content: A closure that generates view content at the moments
    ///     indicated by the schedule. The closure takes an input of type
    ///     ``TimelineViewDefaultContext`` that includes the date from the schedule that
    ///     prompted the update, as well as a ``Context/Cadence-swift.enum``
    ///     value that the view can use to customize its appearance.
    public init(_ schedule: Schedule, @ViewBuilder content: @escaping (TimelineViewDefaultContext) -> Content) { fatalError() }

    /// Creates a new timeline view that uses the given schedule.
    ///
    /// - Parameters:
    ///   - schedule: A schedule that produces a sequence of dates that
    ///     indicate the instances when the view should update.
    ///     Use a type that conforms to ``TimelineSchedule``, like
    ///     ``TimelineSchedule/everyMinute``, or a custom timeline schedule
    ///     that you define.
    ///   - content: A closure that generates view content at the moments
    ///     indicated by the schedule. The closure takes an input of type
    ///     ``Context`` that includes the date from the schedule that
    ///     prompted the update, as well as a ``Context/Cadence-swift.enum``
    ///     value that the view can use to customize its appearance.
    @available(iOS, deprecated, introduced: 15.0, message: "Use TimelineViewDefaultContext for the type of the context parameter passed into TimelineView's content closure to resolve this warning. The new version of this initializer, using TimelineViewDefaultContext, improves compilation performance by using an independent generic type signature, which helps avoid unintended cyclical type dependencies.")
    @available(macOS, deprecated, introduced: 12.0, message: "Use TimelineViewDefaultContext for the type of the context parameter passed into TimelineView's content closure to resolve this warning. The new version of this initializer, using TimelineViewDefaultContext, improves compilation performance by using an independent generic type signature, which helps avoid unintended cyclical type dependencies.")
    @available(watchOS, deprecated, introduced: 8.0, message: "Use TimelineViewDefaultContext for the type of the context parameter passed into TimelineView's content closure to resolve this warning. The new version of this initializer, using TimelineViewDefaultContext, improves compilation performance by using an independent generic type signature, which helps avoid unintended cyclical type dependencies.")
    @available(tvOS, deprecated, introduced: 15.0, message: "Use TimelineViewDefaultContext for the type of the context parameter passed into TimelineView's content closure to resolve this warning. The new version of this initializer, using TimelineViewDefaultContext, improves compilation performance by using an independent generic type signature, which helps avoid unintended cyclical type dependencies.")
    @available(xrOS, deprecated, introduced: 1.0, message: "Use TimelineViewDefaultContext for the type of the context parameter passed into TimelineView's content closure to resolve this warning. The new version of this initializer, using TimelineViewDefaultContext, improves compilation performance by using an independent generic type signature, which helps avoid unintended cyclical type dependencies.")
    public init(_ schedule: Schedule, @ViewBuilder content: @escaping (TimelineView<Schedule, Content>.Context) -> Content) { fatalError() }
}

@available(iOS 16.0, watchOS 8.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension TimelineView.Context {

    /// Resets any pre-rendered views the system has from the timeline.
    ///
    /// When entering Always On Display, the system might pre-render frames. If the
    /// content of these frames must change in a way that isn't reflected by
    /// the schedule or the timeline view's current bindings --- for example, because
    /// the user changes the title of a future calendar event --- call this method to
    /// request that the frames be regenerated.
    public func invalidateTimelineContent() { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension TimelineView.Context.Cadence : Hashable {
}

/// Information passed to a timeline view's content callback.
///
/// The context includes both the date from the schedule that triggered
/// the callback, and a cadence that you can use to customize the appearance of
/// your view. For example, you might choose to display the second hand of an
/// analog clock only when the cadence is
/// ``TimelineView/Context/Cadence-swift.enum/seconds`` or faster.
///
/// > Note: This type alias uses a specific concrete instance of
/// ``TimelineView/Context`` that all timeline views can use.
/// It does this to prevent introducing an unnecessary generic parameter
/// dependency on the context type.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public typealias TimelineViewDefaultContext = TimelineView<EveryMinuteTimelineSchedule, Never>.Context


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
