// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.material.ContentAlpha
import androidx.compose.material3.SliderColors
import androidx.compose.material3.SliderDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
#endif

public struct Slider : View {
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
    @Composable public override func ComposeContent(context: ComposeContext) {
        var steps = 0
        if let step, step > 0.0 {
            steps = Int(ceil(bounds.endInclusive - bounds.start) / step)
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
