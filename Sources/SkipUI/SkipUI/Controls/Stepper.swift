// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation

public struct Stepper : View {
    @available(*, unavailable)
    public init(@ViewBuilder label: () -> any View, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(value: Binding<Int>, step: Int = 1, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(value: Binding<Double>, step: Double = 1.0, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(value: Binding<Int>, in bounds: Range<Int>, step: Int = 1, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(value: Binding<Double>, in bounds: Range<Double>, step: Double = 1.0, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ titleResource: LocalizedStringResource, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ title: String, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, value: Binding<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ titleResource: LocalizedStringResource, value: Binding<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, value: Binding<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ titleResource: LocalizedStringResource, value: Binding<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ title: String, value: Binding<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ title: String, value: Binding<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, value: Binding<Int>, in bounds: Range<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ titleResource: LocalizedStringResource, value: Binding<Int>, in bounds: Range<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, value: Binding<Double>, in bounds: Range<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ titleResource: LocalizedStringResource, value: Binding<Double>, in bounds: Range<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ title: String, value: Binding<Int>, in bounds: Range<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    @available(*, unavailable)
    public init(_ title: String, value: Binding<Double>, in bounds: Range<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}

/*
import class Foundation.Formatter
import protocol Foundation.ParseableFormatStyle

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension Stepper {

    /// Creates a stepper configured to increment or decrement a binding to a
    /// value using a step value you provide, displaying its value with an
    /// applied format style.
    ///
    /// Use this initializer to create a stepper that increments or decrements
    /// a bound value by a specific amount each time the user clicks or taps
    /// the stepper's increment or decrement buttons, while displaying the
    /// current value.
    ///
    /// In the example below, a stepper increments or decrements `value` by the
    /// `step` value of 5 at each click or tap of the control's increment or
    /// decrement button:
    ///
    ///     struct StepperView: View {
    ///         @State private var value = 1
    ///         let step = 5
    ///         var body: some View {
    ///             Stepper(value: $value,
    ///                     step: step,
    ///                     format: .number) {
    ///                 Text("Current value: \(value), step: \(step)")
    ///             }
    ///                 .padding(10)
    ///         }
    ///     }
    ///
    /// ![A view displaying a stepper that increments or decrements a value by
    ///   a specified amount each time the user clicks or taps the stepper's
    ///   increment or decrement buttons.](SkipUI-Stepper-value-step.png)
    ///
    /// - Parameters:
    ///   - value: The ``Binding`` to a value that you provide.
    ///   - step: The amount to increment or decrement `value` each time the
    ///     user clicks or taps the stepper's increment or decrement buttons.
    ///     Defaults to `1`.
    ///   - format: A format style of type `F` to use when converting between
    ///     the string the user edits and the underlying value of type
    ///     `F.FormatInput`. If `format` can't perform the conversion, the
    ///     stepper leaves `value` unchanged. If the user stops editing the
    ///     text in an invalid state, the stepper updates the text to the last
    ///     known valid value.
    ///   - label: A view describing the purpose of this stepper.
    ///   - onEditingChanged: A closure that's called when editing begins and
    ///     ends. For example, on iOS, the user may touch and hold the increment
    ///     or decrement buttons on a stepper which causes the execution
    ///     of the `onEditingChanged` closure at the start and end of
    ///     the gesture.
    public init<F>(value: Binding<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }

    /// Creates a stepper configured to increment or decrement a binding to a
    /// value using a step value and within a range of values you provide,
    /// displaying its value with an applied format style.
    ///
    /// Use this initializer to create a stepper that increments or decrements
    /// a binding to value by the step size you provide within the given bounds.
    /// By setting the bounds, you ensure that the value never goes below or
    /// above the lowest or highest value, respectively.
    ///
    /// The example below shows a stepper that displays the effect of
    /// incrementing or decrementing a value with the step size of `step`
    /// with the bounds defined by `range`:
    ///
    ///     struct StepperView: View {
    ///         @State private var value = 0
    ///         let step = 5
    ///         let range = 1...50
    ///
    ///         var body: some View {
    ///             Stepper(value: $value,
    ///                     in: range,
    ///                     step: step,
    ///                     format: .number) {
    ///                 Text("Current: \(value) in \(range.description) " +
    ///                      "stepping by \(step)")
    ///             }
    ///                 .padding(10)
    ///         }
    ///     }
    ///
    /// ![A view displaying a stepper with a step size of five, and a
    /// prescribed range of 1 though 50.](SkipUI-Stepper-value-step-range.png)
    ///
    /// - Parameters:
    ///   - value: A ``Binding`` to a value that you provide.
    ///   - bounds: A closed range that describes the upper and lower bounds
    ///     permitted by the stepper.
    ///   - step: The amount to increment or decrement the stepper when the
    ///     user clicks or taps the stepper's increment or decrement buttons,
    ///     respectively.
    ///   - format: A format style of type `F` to use when converting between
    ///     the string the user edits and the underlying value of type
    ///     `F.FormatInput`. If `format` can't perform the conversion, the
    ///     stepper leaves `value` unchanged. If the user stops editing the
    ///     text in an invalid state, the stepper updates the text to the last
    ///     known valid value.
    ///   - label: A view describing the purpose of this stepper.
    ///   - onEditingChanged: A closure that's called when editing begins and
    ///     ends. For example, on iOS, the user may touch and hold the increment
    ///     or decrement buttons on a stepper which causes the execution
    ///     of the `onEditingChanged` closure at the start and end of
    ///     the gesture.
    public init<F>(value: Binding<F.FormatInput>, in bounds: ClosedRange<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension Stepper {

    /// Creates a stepper with a title key and configured to increment and
    /// decrement a binding to a value and step amount you provide,
    /// displaying its value with an applied format style.
    ///
    /// Use `Stepper(_:value:step:onEditingChanged:)` to create a stepper with a
    /// custom title that increments or decrements a binding to value by the
    /// step size you specify, while displaying the current value.
    ///
    /// In the example below, the stepper increments or decrements the binding
    /// value by `5` each time the user clicks or taps on the control's
    /// increment or decrement buttons, respectively:
    ///
    ///     struct StepperView: View {
    ///         @State private var value = 1
    ///
    ///         var body: some View {
    ///             Stepper("Stepping by \(step)",
    ///                 value: $value,
    ///                 step: 5,
    ///                 format: .number
    ///             )
    ///             .padding(10)
    ///         }
    ///     }
    ///
    /// ![A view displaying a stepper that increments or decrements by 5 each
    ///   time the user clicks or taps on the control's increment or decrement
    ///   buttons, respectively.](SkipUI-Stepper-value-step.png)
    ///
    /// - Parameters:
    ///     - titleKey: The key for the stepper's localized title describing
    ///       the purpose of the stepper.
    ///     - value: A ``Binding`` to a value that you provide.
    ///     - step: The amount to increment or decrement `value` each time the
    ///       user clicks or taps the stepper's plus or minus button,
    ///       respectively.  Defaults to `1`.
    ///     - format: A format style of type `F` to use when converting between
    ///       the string the user edits and the underlying value of type
    ///       `F.FormatInput`. If `format` can't perform the conversion, the
    ///       stepper leaves `value` unchanged. If the user stops editing the
    ///       text in an invalid state, the stepper updates the text to the last
    ///       known valid value.
    ///     - onEditingChanged: A closure that's called when editing begins and
    ///       ends. For example, on iOS, the user may touch and hold the
    ///       increment or decrement buttons on a `Stepper` which causes the
    ///       execution of the `onEditingChanged` closure at the start and end
    ///       of the gesture.
    public init<F>(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }

    /// Creates a stepper with a title and configured to increment and
    /// decrement a binding to a value and step amount you provide,
    /// displaying its value with an applied format style.
    ///
    /// Use `Stepper(_:value:step:format:onEditingChanged:)` to create a stepper
    /// with a custom title that increments or decrements a binding to value by
    /// the step size you specify, while displaying the current value.
    ///
    /// In the example below, the stepper increments or decrements the binding
    /// value by `5` each time one of the user clicks or taps the control's
    /// increment or decrement buttons:
    ///
    ///     struct StepperView: View {
    ///         let title: String
    ///         @State private var value = 1
    ///
    ///         var body: some View {
    ///             Stepper(title, value: $value, step: 5, format: .number)
    ///                 .padding(10)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - title: A string describing the purpose of the stepper.
    ///     - value: The ``Binding`` to a value that you provide.
    ///     - step: The amount to increment or decrement `value` each time the
    ///       user clicks or taps the stepper's increment or decrement button,
    ///       respectively. Defaults to `1`.
    ///     - format: A format style of type `F` to use when converting between
    ///       the string the user edits and the underlying value of type
    ///       `F.FormatInput`. If `format` can't perform the conversion, the
    ///       stepper leaves `value` unchanged. If the user stops editing the
    ///       text in an invalid state, the stepper updates the text to the last
    ///       known valid value.
    ///     - onEditingChanged: A closure that's called when editing begins and
    ///       ends. For example, on iOS, the user may touch and hold the
    ///       increment or decrement buttons on a `Stepper` which causes the
    ///       execution of the `onEditingChanged` closure at the start and end
    ///       of the gesture.
    public init<S, F>(_ title: S, value: Binding<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where S : StringProtocol, F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }

    /// Creates a stepper instance that increments and decrements a binding to
    /// a value, by a step size and within a closed range that you provide,
    /// displaying its value with an applied format style.
    ///
    /// Use `Stepper(_:value:in:step:format:onEditingChanged:)` to create a
    /// stepper that increments or decrements a value within a specific range
    /// of values by a specific step size, while displaying the current value.
    /// In the example below, a stepper increments or decrements a binding to
    /// value over a range of `1...50` by `5` each time the user clicks or taps
    /// the stepper's increment or decrement buttons:
    ///
    ///     struct StepperView: View {
    ///         @State private var value = 0
    ///
    ///         var body: some View {
    ///             Stepper("Stepping by \(step) in \(range.description)",
    ///                 value: $value,
    ///                 in: 1...50,
    ///                 step: 5,
    ///                 format: .number
    ///             )
    ///             .padding()
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - titleKey: The key for the stepper's localized title describing
    ///       the purpose of the stepper.
    ///     - value: A ``Binding`` to a value that your provide.
    ///     - bounds: A closed range that describes the upper and lower bounds
    ///       permitted by the stepper.
    ///     - step: The amount to increment or decrement `value` each time the
    ///       user clicks or taps the stepper's increment or decrement button,
    ///       respectively. Defaults to `1`.
    ///     - format: A format style of type `F` to use when converting between
    ///       the string the user edits and the underlying value of type
    ///       `F.FormatInput`. If `format` can't perform the conversion, the
    ///       stepper leaves `value` unchanged. If the user stops editing the
    ///       text in an invalid state, the stepper updates the text to the last
    ///       known valid value.
    ///     - onEditingChanged: A closure that's called when editing begins and
    ///       ends. For example, on iOS, the user may touch and hold the increment
    ///       or decrement buttons on a `Stepper` which causes the execution
    ///       of the `onEditingChanged` closure at the start and end of
    ///       the gesture.
    public init<F>(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput>, in bounds: ClosedRange<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }

    /// Creates a stepper instance that increments and decrements a binding to
    /// a value, by a step size and within a closed range that you provide,
    /// displaying its value with an applied format style.
    ///
    /// Use `Stepper(_:value:in:step:format:onEditingChanged:)` to create a
    /// stepper that increments or decrements a value within a specific range
    /// of values by a specific step size, while displaying the current value.
    /// In the example below, a stepper increments or decrements a binding to
    /// value over a range of `1...50` by `5` each time the user clicks or taps
    /// the stepper's increment or decrement buttons:
    ///
    ///     struct StepperView: View {
    ///         let title: String
    ///         @State private var value = 0
    ///
    ///         let step = 5
    ///         let range = 1...50
    ///
    ///         var body: some View {
    ///             Stepper(title,
    ///                 value: $value,
    ///                 in: 1...50,
    ///                 step: 5,
    ///                 format: .number
    ///             )
    ///             .padding()
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - title: A string describing the purpose of the stepper.
    ///     - value: A ``Binding`` to a value that your provide.
    ///     - bounds: A closed range that describes the upper and lower bounds
    ///       permitted by the stepper.
    ///     - step: The amount to increment or decrement `value` each time the
    ///       user clicks or taps the stepper's increment or decrement button,
    ///       respectively. Defaults to `1`.
    ///     - format: A format style of type `F` to use when converting between
    ///       the string the user edits and the underlying value of type
    ///       `F.FormatInput`. If `format` can't perform the conversion, the
    ///       stepper leaves `value` unchanged. If the user stops editing the
    ///       text in an invalid state, the stepper updates the text to the last
    ///       known valid value.
    ///     - onEditingChanged: A closure that's called when editing begins and
    ///       ends. For example, on iOS, the user may touch and hold the increment
    ///       or decrement buttons on a `Stepper` which causes the execution
    ///       of the `onEditingChanged` closure at the start and end of
    ///       the gesture.
    public init<S, F>(_ title: S, value: Binding<F.FormatInput>, in bounds: ClosedRange<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where S : StringProtocol, F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }
}
*/
#endif
