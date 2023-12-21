// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
#endif

public struct DatePicker : View {
    public typealias Components = DatePickerComponents

    let selection: Binding<Date>
    let label: any View
    let dateFormatter: DateFormatter?
    let timeFormatter: DateFormatter?

    public init(selection: Binding<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date], @ViewBuilder label: () -> any View) {
        self.selection = selection
        self.label = label()
        if displayedComponents.contains(.date) {
            dateFormatter = DateFormatter()
            dateFormatter?.dateStyle = .short
            dateFormatter?.timeStyle = .none
        } else {
            dateFormatter = nil
        }
        if displayedComponents.contains(.hourAndMinute) {
            timeFormatter = DateFormatter()
            timeFormatter?.dateStyle = .none
            timeFormatter?.timeStyle = .short
        } else {
            timeFormatter = nil
        }
    }

    @available(*, unavailable)
    public init(selection: Binding<Date>, in range: Range<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date], @ViewBuilder label: () -> any View) {
        self.selection = selection
        self.dateFormatter = nil
        self.timeFormatter = nil
        self.label = label()
    }

    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date]) {
        self.init(selection: selection, displayedComponents: displayedComponents, label: { Text(titleKey) })
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: Range<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date]) {
        self.init(selection: selection, displayedComponents: displayedComponents, label: { Text(titleKey) })
    }

    public init(_ title: String, selection: Binding<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date]) {
        self.init(selection: selection, displayedComponents: displayedComponents, label: { Text(verbatim: title) })
    }

    @available(*, unavailable)
    public init(_ title: String, selection: Binding<Date>, in range: Range<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date]) {
        self.init(selection: selection, displayedComponents: displayedComponents, label: { Text(verbatim: title) })
    }

    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
        let contentContext = context.content()
        let horizontalArrangement = Arrangement.spacedBy(8.dp)
        if EnvironmentValues.shared._labelsHidden {
            Row(modifier: context.modifier, horizontalArrangement: horizontalArrangement, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                ComposeDialogButtons(context: contentContext)
            }
        } else {
            ComposeContainer(modifier: context.modifier, fillWidth: true) { modifier in
                Row(modifier: modifier, horizontalArrangement: horizontalArrangement, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                    label.Compose(context: contentContext)
                    androidx.compose.foundation.layout.Spacer(modifier: Modifier.weight(Float(1.0)))
                    ComposeDialogButtons(context: contentContext)
                }
            }
        }
    }

    @Composable private func ComposeDialogButtons(context: ComposeContext) {
        let isEnabled = EnvironmentValues.shared.isEnabled
        let date = selection.wrappedValue
        if let dateString = dateFormatter?.string(from: date) {
            let text = Text(verbatim: dateString)
            if isEnabled {
                ComposeTextButton(label: text, context: context) {
                    //~~~
                }
            } else {
                text.Compose(context: context)
            }
        }
        if let timeString = timeFormatter?.string(from: date) {
            let text = Text(verbatim: timeString)
            if isEnabled {
                ComposeTextButton(label: text, context: context) {
                    //~~~
                }
            } else {
                text.Compose(context: context)
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct DatePickerComponents : OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let hourAndMinute = DatePickerComponents(rawValue: 1 << 0)
    public static let date = DatePickerComponents(rawValue: 1 << 1)
}

public struct DatePickerStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = ButtonStyle(rawValue: 0)

    @available(*, unavailable)
    public static let graphical = ButtonStyle(rawValue: 1)

    @available(*, unavailable)
    public static let wheel = ButtonStyle(rawValue: 2)

    public static let compact = ButtonStyle(rawValue: 3)
}

extension View {
    public func datePickerStyle(_ style: DatePickerStyle) -> some View {
        // We only support .automatic / .compact
        return self
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

import struct Foundation.Date
import struct Foundation.DateComponents
import struct Foundation.DateInterval

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
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A description of the `DatePicker`.
    public let label: DatePickerStyleConfiguration.Label = { fatalError() }()

    /// The date value being displayed and selected.
//    @Binding public var selection: Date { get { fatalError() } nonmutating set { } }

//    public var $selection: Binding<Date> { get { fatalError() } }

    /// The oldest selectable date.
    public var minimumDate: Date?

    /// The most recent selectable date.
    public var maximumDate: Date?

    /// The date components that the user is able to view and edit.
    public var displayedComponents: DatePickerComponents { get { fatalError() } }
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

    @MainActor public var body: some View { get { return stubView() } }

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

#endif
