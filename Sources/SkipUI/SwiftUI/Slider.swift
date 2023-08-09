// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// A control for selecting a value from a bounded linear range of values.
///
/// A slider consists of a "thumb" image that the user moves between two
/// extremes of a linear "track". The ends of the track represent the minimum
/// and maximum possible values. As the user moves the thumb, the slider
/// updates its bound value.
///
/// The following example shows a slider bound to the value `speed`. As the
/// slider updates this value, a bound ``Text`` view shows the value updating.
/// The `onEditingChanged` closure passed to the slider receives callbacks when
/// the user drags the slider. The example uses this to change the
/// color of the value text.
///
///     @State private var speed = 50.0
///     @State private var isEditing = false
///
///     var body: some View {
///         VStack {
///             Slider(
///                 value: $speed,
///                 in: 0...100,
///                 onEditingChanged: { editing in
///                     isEditing = editing
///                 }
///             )
///             Text("\(speed)")
///                 .foregroundColor(isEditing ? .red : .blue)
///         }
///     }
///
/// ![An unlabeled slider, with its thumb about one third of the way from the
/// minimum extreme. Below, a blue label displays the value
/// 33.045977.](SkipUI-Slider-simple.png)
///
/// You can also use a `step` parameter to provide incremental steps along the
/// path of the slider. For example, if you have a slider with a range of `0` to
/// `100`, and you set the `step` value to `5`, the slider's increments would be
/// `0`, `5`, `10`, and so on. The following example shows this approach, and
/// also adds optional minimum and maximum value labels.
///
///     @State private var speed = 50.0
///     @State private var isEditing = false
///
///     var body: some View {
///         Slider(
///             value: $speed,
///             in: 0...100,
///             step: 5
///         ) {
///             Text("Speed")
///         } minimumValueLabel: {
///             Text("0")
///         } maximumValueLabel: {
///             Text("100")
///         } onEditingChanged: { editing in
///             isEditing = editing
///         }
///         Text("\(speed)")
///             .foregroundColor(isEditing ? .red : .blue)
///     }
///
/// ![A slider with labels show minimum and maximum values of 0 and 100,
/// respectively, with its thumb most of the way to the maximum extreme. Below,
/// a blue label displays the value
/// 85.000000.](SkipUI-Slider-withStepAndLabels.png)
///
/// The slider also uses the `step` to increase or decrease the value when a
/// VoiceOver user adjusts the slider with voice commands.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
public struct Slider<Label, ValueLabel> : View where Label : View, ValueLabel : View {

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

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
extension Slider {

    /// Creates a slider to select a value from a given range, which displays
    /// the provided labels.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, SkipUI
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///   - minimumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - maximumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint { fatalError() }

    /// Creates a slider to select a value from a given range, subject to a
    /// step increment, which displays the provided labels.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - step: The distance between each valid value.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, SkipUI
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///   - minimumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - maximumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint { fatalError() }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
extension Slider where ValueLabel == EmptyView {

    /// Creates a slider to select a value from a given range, which displays
    /// the provided label.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, SkipUI
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint { fatalError() }

    /// Creates a slider to select a value from a given range, subject to a
    /// step increment, which displays the provided label.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - step: The distance between each valid value.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, SkipUI
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint { fatalError() }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
extension Slider where Label == EmptyView, ValueLabel == EmptyView {

    /// Creates a slider to select a value from a given range.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint { fatalError() }

    /// Creates a slider to select a value from a given range, subject to a
    /// step increment.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - step: The distance between each valid value.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint { fatalError() }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
extension Slider {

    /// Creates a slider to select a value from a given range, which displays
    /// the provided labels.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///   - minimumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - maximumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, SkipUI
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    @available(iOS, deprecated: 100000.0, renamed: "Slider(value:in:label:minimumValueLabel:maximumValueLabel:onEditingChanged:)")
    @available(macOS, deprecated: 100000.0, renamed: "Slider(value:in:label:minimumValueLabel:maximumValueLabel:onEditingChanged:)")
    @available(watchOS, deprecated: 100000.0, renamed: "Slider(value:in:label:minimumValueLabel:maximumValueLabel:onEditingChanged:)")
    @available(xrOS, deprecated: 100000.0, renamed: "Slider(value:in:label:minimumValueLabel:maximumValueLabel:onEditingChanged:)")
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }, minimumValueLabel: ValueLabel, maximumValueLabel: ValueLabel, @ViewBuilder label: () -> Label) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint { fatalError() }

    /// Creates a slider to select a value from a given range, subject to a
    /// step increment, which displays the provided labels.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - step: The distance between each valid value.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///   - minimumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - maximumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, SkipUI
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    @available(iOS, deprecated: 100000.0, renamed: "Slider(value:in:step:label:minimumValueLabel:maximumValueLabel:onEditingChanged:)")
    @available(macOS, deprecated: 100000.0, renamed: "Slider(value:in:step:label:minimumValueLabel:maximumValueLabel:onEditingChanged:)")
    @available(watchOS, deprecated: 100000.0, renamed: "Slider(value:in:step:label:minimumValueLabel:maximumValueLabel:onEditingChanged:)")
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }, minimumValueLabel: ValueLabel, maximumValueLabel: ValueLabel, @ViewBuilder label: () -> Label) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint { fatalError() }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
extension Slider where ValueLabel == EmptyView {

    /// Creates a slider to select a value from a given range, which displays
    /// the provided label.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, SkipUI
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    @available(iOS, deprecated: 100000.0, renamed: "Slider(value:in:label:onEditingChanged:)")
    @available(macOS, deprecated: 100000.0, renamed: "Slider(value:in:label:onEditingChanged:)")
    @available(watchOS, deprecated: 100000.0, renamed: "Slider(value:in:label:onEditingChanged:)")
    @available(xrOS, deprecated: 100000.0, renamed: "Slider(value:in:label:onEditingChanged:)")
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }, @ViewBuilder label: () -> Label) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint { fatalError() }

    /// Creates a slider to select a value from a given range, subject to a
    /// step increment, which displays the provided label.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - step: The distance between each valid value.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, SkipUI
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    @available(iOS, deprecated: 100000.0, renamed: "Slider(value:in:step:label:onEditingChanged:)")
    @available(macOS, deprecated: 100000.0, renamed: "Slider(value:in:step:label:onEditingChanged:)")
    @available(watchOS, deprecated: 100000.0, renamed: "Slider(value:in:step:label:onEditingChanged:)")
    @available(xrOS, deprecated: 100000.0, renamed: "Slider(value:in:step:label:onEditingChanged:)")
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }, @ViewBuilder label: () -> Label) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint { fatalError() }
}
