// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP INSERT: import androidx.compose.runtime.Composable

public struct Slider : View {
    let value: Binding<Double>
    let bounds: ClosedRange<Double>
    let step: Double?

    public init(value: Binding<Double>, in bounds: ClosedRange<Double> = 0.0...1.0, step: Double? = nil) {
        self.value = value
        self.bounds = bounds
        self.step = step
    }

    @available(*, unavailable)
    public init(value: Binding<Double>, in bounds: ClosedRange<Double> = 0.0...1.0, step: Double? = nil, onEditingChanged: @escaping (Bool) -> Void) {
        self.value = value
        self.bounds = bounds
        self.step = step
    }

    @available(*, unavailable)
    public init(value: Binding<Double>, in bounds: ClosedRange<Double> = 0.0...1.0, step: Double? = nil, @ViewBuilder label: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = value
        self.bounds = bounds
        self.step = step
    }

    @available(*, unavailable)
    public init(value: Binding<Double>, in bounds: ClosedRange<Double> = 0.0...1.0, step: Double? = nil, @ViewBuilder label: () -> any View, @ViewBuilder minimumValueLabel: () -> any View, @ViewBuilder maximumValueLabel: () -> any View, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = value
        self.bounds = bounds
        self.step = step
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/Slider.kt
     @Composable
     fun Slider(
        value: Float,
        onValueChange: (Float) -> Unit,
        modifier: Modifier = Modifier,
        enabled: Boolean = true,
        valueRange: ClosedFloatingPointRange<Float> = 0f..1f,
        @IntRange(from = 0)
        steps: Int = 0,
        onValueChangeFinished: (() -> Unit)? = null,
        colors: SliderColors = SliderDefaults.colors(),
        interactionSource: MutableInteractionSource = remember { MutableInteractionSource() }
     )
     */
    @Composable public override func Compose(ctx: ComposeContext) {
        var steps = 0
        if let step, step > 0.0 {
            steps = Int(ceil(bounds.endInclusive - bounds.start) / step)
        }
        androidx.compose.material3.Slider(value: Float(value.get()), onValueChange: { value.set(Double($0)) }, modifier: ctx.modifier, valueRange: Float(bounds.start)...Float(bounds.endInclusive), steps: steps)
    }
    #else
    public var body: some View {
        Never()
    }
    #endif
}
