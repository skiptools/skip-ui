// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import struct Foundation.Date
import struct Foundation.DateComponents
import struct Foundation.DateInterval

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

/// The default picker style, based on the picker's context.
///
/// You can also use ``PickerStyle/automatic`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct DefaultPickerStyle : PickerStyle {

    /// Creates a default picker style.
    public init() { fatalError() }
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

#endif
