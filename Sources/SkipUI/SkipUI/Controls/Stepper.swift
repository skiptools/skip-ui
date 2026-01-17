// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.ContentAlpha
import androidx.compose.material.IconButton
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Remove
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp
#endif

// SKIP @bridge
public struct Stepper : View, Renderable {
    let value: Binding<Double>?
    let label: ComposeBuilder
    let step: Double
    let minValue: Double?
    let maxValue: Double?
    let onIncrement: (() -> Void)?
    let onDecrement: (() -> Void)?
    let onEditingChanged: ((Bool) -> Void)?

    // MARK: - Custom increment/decrement initializers

    public init(@ViewBuilder label: () -> any View, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = nil
        self.label = ComposeBuilder.from(label)
        self.step = 1.0
        self.minValue = nil
        self.maxValue = nil
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
        self.onEditingChanged = onEditingChanged
    }

    public init(_ titleKey: LocalizedStringKey, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(label: { Text(titleKey) }, onIncrement: onIncrement, onDecrement: onDecrement, onEditingChanged: onEditingChanged)
    }

    public init(_ titleResource: LocalizedStringResource, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(label: { Text(titleResource) }, onIncrement: onIncrement, onDecrement: onDecrement, onEditingChanged: onEditingChanged)
    }

    public init(_ title: String, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(label: { Text(verbatim: title) }, onIncrement: onIncrement, onDecrement: onDecrement, onEditingChanged: onEditingChanged)
    }

    // MARK: - Int value initializers (no bounds)

    public init(value intValue: Binding<Int>, step: Int = 1, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        var capturedBinding = intValue
        self.value = Binding(get: { Double(capturedBinding.wrappedValue) }, set: { capturedBinding.wrappedValue = Int($0) })
        self.label = ComposeBuilder.from(label)
        self.step = Double(step)
        self.minValue = nil
        self.maxValue = nil
        self.onIncrement = nil
        self.onDecrement = nil
        self.onEditingChanged = onEditingChanged
    }

    public init(_ titleKey: LocalizedStringKey, value: Binding<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleKey) }, onEditingChanged: onEditingChanged)
    }

    public init(_ titleResource: LocalizedStringResource, value: Binding<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleResource) }, onEditingChanged: onEditingChanged)
    }

    public init(_ title: String, value: Binding<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(verbatim: title) }, onEditingChanged: onEditingChanged)
    }

    // MARK: - Double value initializers (no bounds)

    public init(value: Binding<Double>, step: Double = 1.0, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = value
        self.label = ComposeBuilder.from(label)
        self.step = step
        self.minValue = nil
        self.maxValue = nil
        self.onIncrement = nil
        self.onDecrement = nil
        self.onEditingChanged = onEditingChanged
    }

    public init(_ titleKey: LocalizedStringKey, value: Binding<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleKey) }, onEditingChanged: onEditingChanged)
    }

    public init(_ titleResource: LocalizedStringResource, value: Binding<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleResource) }, onEditingChanged: onEditingChanged)
    }

    public init(_ title: String, value: Binding<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(verbatim: title) }, onEditingChanged: onEditingChanged)
    }

    // MARK: - Int value initializers (with bounds) - Available via Fuse bridging

    @available(*, unavailable)
    public init(value intValue: Binding<Int>, in bounds: ClosedRange<Int>, step: Int = 1, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: intValue, step: step, label: label, onEditingChanged: onEditingChanged)
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, value: Binding<Int>, in bounds: ClosedRange<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleKey) }, onEditingChanged: onEditingChanged)
    }

    @available(*, unavailable)
    public init(_ titleResource: LocalizedStringResource, value: Binding<Int>, in bounds: ClosedRange<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleResource) }, onEditingChanged: onEditingChanged)
    }

    @available(*, unavailable)
    public init(_ title: String, value: Binding<Int>, in bounds: ClosedRange<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(verbatim: title) }, onEditingChanged: onEditingChanged)
    }

    // MARK: - Double value initializers (with bounds) - Available via Fuse bridging

    @available(*, unavailable)
    public init(value: Binding<Double>, in bounds: ClosedRange<Double>, step: Double = 1.0, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: label, onEditingChanged: onEditingChanged)
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, value: Binding<Double>, in bounds: ClosedRange<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleKey) }, onEditingChanged: onEditingChanged)
    }

    @available(*, unavailable)
    public init(_ titleResource: LocalizedStringResource, value: Binding<Double>, in bounds: ClosedRange<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleResource) }, onEditingChanged: onEditingChanged)
    }

    @available(*, unavailable)
    public init(_ title: String, value: Binding<Double>, in bounds: ClosedRange<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(verbatim: title) }, onEditingChanged: onEditingChanged)
    }

    // SKIP @bridge
    public init(getValue: @escaping () -> Double, setValue: @escaping (Double) -> Void, step: Double, minValue: Double?, maxValue: Double?, bridgedOnEditingChanged: ((Bool) -> Void)?, bridgedLabel: any View) {
        self.value = Binding(get: getValue, set: setValue)
        self.label = ComposeBuilder.from { bridgedLabel }
        self.step = step
        self.minValue = minValue
        self.maxValue = maxValue
        self.onIncrement = nil
        self.onDecrement = nil
        self.onEditingChanged = bridgedOnEditingChanged
    }

    // SKIP @bridge
    public init(bridgedOnIncrement: (() -> Void)?, bridgedOnDecrement: (() -> Void)?, bridgedOnEditingChanged: ((Bool) -> Void)?, bridgedLabel: any View) {
        self.value = nil
        self.label = ComposeBuilder.from { bridgedLabel }
        self.step = 1.0
        self.minValue = nil
        self.maxValue = nil
        self.onIncrement = bridgedOnIncrement
        self.onDecrement = bridgedOnDecrement
        self.onEditingChanged = bridgedOnEditingChanged
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        let isEnabled = EnvironmentValues.shared.isEnabled
        let tint = EnvironmentValues.shared._tint ?? Color.accentColor
        let tintColor = tint.colorImpl()
        let disabledColor = tintColor.copy(alpha: ContentAlpha.disabled)

        let currentValue = value?.wrappedValue ?? 0.0
        let canDecrement = isEnabled && (onDecrement != nil || (minValue == nil || currentValue > minValue!))
        let canIncrement = isEnabled && (onIncrement != nil || (maxValue == nil || currentValue + step <= maxValue!))

        let contentContext = context.content()

        if EnvironmentValues.shared._labelsHidden {
            Row(modifier: context.modifier, horizontalArrangement: Arrangement.spacedBy(4.dp), verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                RenderButtons(canDecrement: canDecrement, canIncrement: canIncrement, tintColor: tintColor, disabledColor: disabledColor)
            }
        } else {
            ComposeContainer(modifier: context.modifier, fillWidth: true) { modifier in
                Row(modifier: modifier, horizontalArrangement: Arrangement.spacedBy(8.dp), verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                    Box(modifier: Modifier.weight(Float(1.0))) {
                        label.Compose(context: contentContext)
                    }
                    RenderButtons(canDecrement: canDecrement, canIncrement: canIncrement, tintColor: tintColor, disabledColor: disabledColor)
                }
            }
        }
    }

    @Composable private func RenderButtons(canDecrement: Bool, canIncrement: Bool, tintColor: androidx.compose.ui.graphics.Color, disabledColor: androidx.compose.ui.graphics.Color) {
        let borderColor = tintColor.copy(alpha: Float(0.3))
        let shape = RoundedCornerShape(8.dp)

        Row(
            modifier: Modifier
                .height(36.dp)
                .border(width: 1.dp, color: borderColor, shape: shape)
                .clip(shape),
            verticalAlignment: Alignment.CenterVertically
        ) {
            IconButton(onClick: { performDecrement() }, enabled: canDecrement, modifier: Modifier.size(36.dp)) {
                Icon(imageVector: Icons.Filled.Remove, contentDescription: "Decrement", tint: canDecrement ? tintColor : disabledColor)
            }
            HorizontalDivider(modifier: Modifier.width(1.dp).height(20.dp), color: borderColor)
            IconButton(onClick: { performIncrement() }, enabled: canIncrement, modifier: Modifier.size(36.dp)) {
                Icon(imageVector: Icons.Filled.Add, contentDescription: "Increment", tint: canIncrement ? tintColor : disabledColor)
            }
        }
    }

    private func performIncrement() {
        onEditingChanged?(true)
        if let onIncrement {
            onIncrement()
        } else if let value {
            var newValue = value.wrappedValue + step
            if let maxValue, newValue > maxValue {
                newValue = maxValue
            }
            value.wrappedValue = newValue
        }
        onEditingChanged?(false)
    }

    private func performDecrement() {
        onEditingChanged?(true)
        if let onDecrement {
            onDecrement()
        } else if let value {
            var newValue = value.wrappedValue - step
            if let minValue, newValue < minValue {
                newValue = minValue
            }
            value.wrappedValue = newValue
        }
        onEditingChanged?(false)
    }
    #else
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
    public init<F>(value: Binding<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }

    /// Creates a stepper configured to increment or decrement a binding to a
    /// value using a step value and within a range of values you provide,
    /// displaying its value with an applied format style.
    public init<F>(value: Binding<F.FormatInput>, in bounds: ClosedRange<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension Stepper {

    /// Creates a stepper with a title key and configured to increment and
    /// decrement a binding to a value and step amount you provide,
    /// displaying its value with an applied format style.
    public init<F>(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }

    /// Creates a stepper with a title and configured to increment and
    /// decrement a binding to a value and step amount you provide,
    /// displaying its value with an applied format style.
    public init<S, F>(_ title: S, value: Binding<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where S : StringProtocol, F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }

    /// Creates a stepper instance that increments and decrements a binding to
    /// a value, by a step size and within a closed range that you provide,
    /// displaying its value with an applied format style.
    public init<F>(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput>, in bounds: ClosedRange<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }

    /// Creates a stepper instance that increments and decrements a binding to
    /// a value, by a step size and within a closed range that you provide,
    /// displaying its value with an applied format style.
    public init<S, F>(_ title: S, value: Binding<F.FormatInput>, in bounds: ClosedRange<F.FormatInput>, step: F.FormatInput.Stride = 1, format: F, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where S : StringProtocol, F : ParseableFormatStyle, F.FormatInput : BinaryFloatingPoint, F.FormatOutput == String { fatalError() }
}
*/
#endif
