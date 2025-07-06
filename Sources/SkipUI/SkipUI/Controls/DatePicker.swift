// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.material3.BasicAlertDialog
import androidx.compose.material3.DatePicker
import androidx.compose.material3.DatePickerDefaults
import androidx.compose.material3.DatePickerState
import androidx.compose.material3.DisplayMode
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Surface
import androidx.compose.material3.TimePicker
import androidx.compose.material3.TimePickerDefaults
import androidx.compose.material3.TimePickerState
import androidx.compose.material3.rememberDatePickerState
import androidx.compose.material3.rememberTimePickerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.DialogProperties
#endif

// SKIP @bridge
public struct DatePicker : View {
    public typealias Components = DatePickerComponents

    let selection: Binding<Date>
    let label: ComposeBuilder
    let dateFormatter: DateFormatter?
    let timeFormatter: DateFormatter?

    public init(selection: Binding<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date], @ViewBuilder label: () -> any View) {
        self.selection = selection
        self.label = ComposeBuilder.from(label)
        if displayedComponents.contains(.date) {
            dateFormatter = DateFormatter()
            dateFormatter?.dateStyle = .medium
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

    // SKIP @bridge
    public init(getSelection: @escaping () -> Date, setSelection: @escaping (Date) -> Void, bridgedDisplayedComponents: Int, bridgedLabel: any View) {
        self.init(selection: Binding(get: getSelection, set: setSelection), displayedComponents: DatePickerComponents(rawValue: bridgedDisplayedComponents), label: { bridgedLabel })
    }

    @available(*, unavailable)
    public init(selection: Binding<Date>, in range: Range<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date], @ViewBuilder label: () -> any View) {
        self.selection = selection
        self.dateFormatter = nil
        self.timeFormatter = nil
        self.label = ComposeBuilder.from(label)
    }

    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date]) {
        self.init(selection: selection, displayedComponents: displayedComponents, label: { Text(titleKey) })
    }

    public init(_ titleResource: LocalizedStringResource, selection: Binding<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date]) {
        self.init(selection: selection, displayedComponents: displayedComponents, label: { Text(titleResource) })
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: Range<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date]) {
        self.init(selection: selection, displayedComponents: displayedComponents, label: { Text(titleKey) })
    }

    @available(*, unavailable)
    public init(_ titleResource: LocalizedStringResource, selection: Binding<Date>, in range: Range<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date]) {
        self.init(selection: selection, displayedComponents: displayedComponents, label: { Text(titleResource) })
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
                ComposePickerContent(context: contentContext)
            }
        } else {
            ComposeContainer(modifier: context.modifier, fillWidth: true) { modifier in
                Row(modifier: modifier, horizontalArrangement: horizontalArrangement, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                    Box(modifier: Modifier.weight(Float(1.0))) {
                        label.Compose(context: contentContext)
                    }
                    ComposePickerContent(context: contentContext)
                }
            }
        }
    }

    @Composable private func ComposePickerContent(context: ComposeContext) {
        let isDatePickerPresented = remember { mutableStateOf(false) }
        let isTimePickerPresented = remember { mutableStateOf(false) }
        let isEnabled = EnvironmentValues.shared.isEnabled
        let date = selection.wrappedValue
        let (hour, minute) = hourAndMinute(from: date)
        let currentLocale = Locale(androidx.compose.ui.platform.LocalConfiguration.current.locales[0])
        
        dateFormatter?.locale = currentLocale
        if let dateString = dateFormatter?.string(from: date) {
            let text = Text(verbatim: dateString)
            if isEnabled {
                Button.ComposeTextButton(label: text, context: context) {
                    isDatePickerPresented.value = true
                }
            } else {
                text.Compose(context: context)
            }
        }
        timeFormatter?.locale = currentLocale
        if let timeString = timeFormatter?.string(from: date) {
            let text = Text(verbatim: timeString)
            if isEnabled {
                Button.ComposeTextButton(label: text, context: context) {
                    isTimePickerPresented.value = true
                }
            } else {
                text.Compose(context: context)
            }
        }

        let tintColor = (EnvironmentValues.shared._tint ?? Color.accentColor).colorImpl()
        ComposeDatePicker(context: context, isPresented: isDatePickerPresented, tintColor: tintColor) {
            didSelect(date: $0, hour: hour, minute: minute)
        }
        ComposeTimePicker(context: context, isPresented: isTimePickerPresented, tintColor: tintColor, hour: hour, minute: minute) {
            didSelect(date: date, hour: $0, minute: $1)
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
    @Composable private func ComposeDatePicker(context: ComposeContext, isPresented: MutableState<Bool>, tintColor: androidx.compose.ui.graphics.Color, dateSelected: (Date) -> Void) {
        guard isPresented.value else {
            return
        }
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT())
        let initialSeconds = selection.wrappedValue.timeIntervalSince1970 + timeZoneOffset
        let state = rememberDatePickerState(initialSelectedDateMillis: Long(initialSeconds * 1000.0), initialDisplayMode: EnvironmentValues.shared.verticalSizeClass == .compact ? DisplayMode.Input : DisplayMode.Picker)
        let colors = DatePickerDefaults.colors(selectedDayContainerColor: tintColor, selectedYearContainerColor: tintColor, todayDateBorderColor: tintColor, currentYearContentColor: tintColor)
        SimpleDatePickerDialog(onDismissRequest: { isPresented.value = false }) {
            DatePicker(modifier: context.modifier, state: state, colors: colors)
        }
        if let millis = state.selectedDateMillis {
            dateSelected(Date(timeIntervalSince1970: Double(millis / 1000.0) - timeZoneOffset))
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
    @Composable private func ComposeTimePicker(context: ComposeContext, isPresented: MutableState<Bool>, tintColor: androidx.compose.ui.graphics.Color, hour: Int, minute: Int, timeSelected: (Int, Int) -> Void) {
        guard isPresented.value else {
            return
        }
        let state = rememberTimePickerState(initialHour: hour, initialMinute: minute)
        let containerColor = tintColor.copy(alpha: Float(0.25))
        let colors = TimePickerDefaults.colors(selectorColor: tintColor, periodSelectorSelectedContainerColor: containerColor, timeSelectorSelectedContainerColor: containerColor)
        SimpleDatePickerDialog(onDismissRequest: { isPresented.value = false }) {
            TimePicker(modifier: context.modifier.padding(16.dp), state: state, colors: colors)
        }
        timeSelected(state.hour, state.minute)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif

    private func didSelect(date: Date, hour: Int, minute: Int) {
        // Subtract out any existing hour and minute from the given date, then add the selected values
        let (baseHour, baseMinute) = hourAndMinute(from: date)
        let baseSeconds = date.timeIntervalSince1970 - Double(baseHour * 60 * 60) - Double(baseMinute * 60)
        let selectedSeconds = baseSeconds + Double(hour * 60 * 60) + Double(minute * 60)
        #if SKIP
        if selectedSeconds != selection.wrappedValue.timeIntervalSince1970 {
            // selection is a 'let' constant so Swift would not allow us to assign to it
            selection.wrappedValue = Date(timeIntervalSince1970: selectedSeconds)
        }
        #endif
    }

    private func hourAndMinute(from date: Date) -> (Int, Int) {
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: date)
        return (timeComponents.hour!, timeComponents.minute!)
    }
}

#if SKIP
/// Simplification of the Material 3 `DatePickerDialog` source code.
///
/// We can't use the actual `DatePickerDialog` because it has a fixed size that cuts off content in landscape.
// SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
@Composable func SimpleDatePickerDialog(onDismissRequest: () -> Void, content: @Composable () -> Void) {
    let horizontalPadding = EnvironmentValues.shared.horizontalSizeClass == .compact ? 16.dp : 0.dp
    BasicAlertDialog(modifier: Modifier.wrapContentHeight(), onDismissRequest: onDismissRequest, properties: DialogProperties(usePlatformDefaultWidth: false)) {
        Surface(modifier: Modifier.padding(horizontal: horizontalPadding), shape: DatePickerDefaults.shape) {
            Column(verticalArrangement: Arrangement.SpaceBetween) {
                Box(Modifier.weight(Float(1.0), fill: false)) {
                    content()
                }
            }
        }
    }
}
#endif

public struct DatePickerComponents : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let hourAndMinute = DatePickerComponents(rawValue: 1 << 0) // For bridging
    public static let date = DatePickerComponents(rawValue: 1 << 1) // For bridging
}

public struct DatePickerStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = DatePickerStyle(rawValue: 0) // For bridging

    @available(*, unavailable)
    public static let graphical = DatePickerStyle(rawValue: 1) // For bridging

    @available(*, unavailable)
    public static let wheel = DatePickerStyle(rawValue: 2) // For bridging

    public static let compact = DatePickerStyle(rawValue: 3) // For bridging
}

extension View {
    public func datePickerStyle(_ style: DatePickerStyle) -> any View {
        // We only support .automatic / .compact
        return self
    }

    // SKIP @bridge
    public func datePickerStyle(bridgedStyle: Int) -> any View {
        return datePickerStyle(DatePickerStyle(rawValue: bridgedStyle))
    }
}

#if false
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
#endif
