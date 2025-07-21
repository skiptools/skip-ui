// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.material.ContentAlpha
import androidx.compose.material3.SliderColors
import androidx.compose.material3.SliderDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
#endif

// SKIP @bridge
public struct Slider : View, Renderable {
    let value: Binding<Double>
    let bounds: ClosedRange<Double>
    let step: Double?

    public init(value: Binding<Double>, in bounds: Any? = nil, step: Double? = nil) {
        self.value = value
        self.bounds = Self.bounds(for: bounds)
        self.step = step
    }

    @available(*, unavailable)
    public init(value: Binding<Double>, in bounds: Any? = nil, step: Double? = nil, onEditingChanged: @escaping (Bool) -> Void) {
        self.value = value
        self.bounds = Self.bounds(for: bounds)
        self.step = step
    }

    public init(value: Binding<Double>, in bounds: Any? = nil, step: Double? = nil, @ViewBuilder label: () -> any View) {
        self.init(value: value, in: bounds, step: step)
    }

    // SKIP @bridge
    public init(getValue: @escaping () -> Double, setValue: @escaping (Double) -> Void, min: Double, max: Double, step: Double?, bridgedLabel: (any View)?) {
        self.value = Binding(get: getValue, set: setValue)
        self.bounds = min...max
        self.step = step
        // Note: label is ignored
    }

    @available(*, unavailable)
    public init(value: Binding<Double>, in bounds: Any? = nil, step: Double? = nil, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void) {
        self.value = value
        self.bounds = Self.bounds(for: bounds)
        self.step = step
    }

    @available(*, unavailable)
    public init(value: Binding<Double>, in bounds: Any? = nil, step: Double? = nil, @ViewBuilder label: () -> any View, @ViewBuilder minimumValueLabel: () -> any View, @ViewBuilder maximumValueLabel: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = value
        self.bounds = Self.bounds(for: bounds)
        self.step = step
    }

    private static func bounds(for bounds: Any?) -> ClosedRange<Double> {
        #if SKIP
        guard let range = bounds as? ClosedRange else {
            return 0.0...1.0
        }
        return Double(range.start as! kotlin.Number)...Double(range.endInclusive as! kotlin.Number)
        #else
        return 0.0...1.0
        #endif
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        var steps = 0
        if let step, step > 0.0 {
            steps = max(0, Int(ceil(bounds.endInclusive - bounds.start) / step) - 1)
        }
        let colors: SliderColors
        if let tint = EnvironmentValues.shared._tint {
            let activeColor = tint.colorImpl()
            let disabledColor = activeColor.copy(alpha: ContentAlpha.disabled)
            colors = SliderDefaults.colors(thumbColor: activeColor, activeTrackColor: activeColor, disabledThumbColor: disabledColor, disabledActiveTrackColor: disabledColor)
        } else {
            colors = SliderDefaults.colors()
        }
        let modifier = Modifier.fillWidth().then(context.modifier)
        androidx.compose.material3.Slider(modifier: modifier, value: Float(value.get()), onValueChange: { value.set(Double($0)) }, enabled: EnvironmentValues.shared.isEnabled, valueRange: Float(bounds.start)...Float(bounds.endInclusive), steps: steps, colors: colors)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
