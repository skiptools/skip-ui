// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A view that shows a value within a range.
///
/// A gauge is a view that shows a current level of a value in relation
/// to a specified finite capacity, very much like a fuel gauge in an
/// automobile. Gauge displays are configurable; they can show
/// any combination of the gauge's current value, the range the gauge can
/// display, and a label describing the purpose of the gauge itself.
///
/// In its most basic form, a gauge displays a single value along the path of
/// the gauge mapped into a range from 0 to 100 percent. The example below sets
/// the gauge's indicator to a position 40 percent along the gauge's path:
///
///     struct SimpleGauge: View {
///         @State private var batteryLevel = 0.4
///
///         var body: some View {
///             Gauge(value: batteryLevel) {
///                 Text("Battery Level")
///             }
///         }
///     }
///
/// ![A linear gauge displaying a current value set to 40 percent in a range of 0
///  to 1.](SkipUI-Gauge-ValueLabelLinear.png)
///
/// You can make a gauge more descriptive by describing its purpose, showing
/// its current value and its start and end values. This example shows the
/// gauge variant that accepts a range and adds labels using multiple
/// trailing closures describing the current value and the minimum
/// and maximum values of the gauge:
///
///     struct LabeledGauge: View {
///         @State private var current = 67.0
///         @State private var minValue = 0.0
///         @State private var maxValue = 170.0
///
///         var body: some View {
///             Gauge(value: current, in: minValue...maxValue) {
///                 Text("BPM")
///             } currentValueLabel: {
///                 Text("\(Int(current))")
///             } minimumValueLabel: {
///                 Text("\(Int(minValue))")
///             } maximumValueLabel: {
///                 Text("\(Int(maxValue))")
///             }
///         }
///     }
///
/// ![A linear gauge describing heart-rate in beats per minute with its
/// value set to 67 in a range of 0 to
/// 170.](SkipUI-Gauge-Label-CurrentValueLinear.png)
///
/// As shown above, the default style for gauges is a linear, continuous bar
/// with an indicator showing the current value, and optional labels describing
/// the gauge's purpose, current, minimum, and maximum values.
///
/// > Note: Some visual presentations of `Gauge` don't display all the
///   labels required by the API. However, the accessibility system does use
///   the label content and you should use these labels to fully describe
///   the gauge for accessibility users.
///
/// To change the style of a gauge, use the ``SkipUI/Gauge/gaugeStyle(_:)``
/// view modifier and supply an initializer for a specific gauge style. For
/// example, to display the same gauge in a circular style, apply the
/// ``GaugeStyle/circular`` style to the view:
///
///     struct LabeledGauge: View {
///         @State private var current = 67.0
///         @State private var minValue = 0.0
///         @State private var maxValue = 170.0
///
///         var body: some View {
///             Gauge(value: current, in: minValue...maxValue) {
///                 Text("BPM")
///             } currentValueLabel: {
///                 Text("\(Int(current))")
///             } minimumValueLabel: {
///                 Text("\(Int(minValue))")
///             } maximumValueLabel: {
///                 Text("\(Int(maxValue))")
///             }
///             .gaugeStyle(.circular)
///         }
///     }
///
/// ![A circular gauge describing heart rate in beats per minute with its
/// value set to 67 in a range of 0 to 170.](SkipUI-Gauge-LabeledCircular.png)
///
/// To style elements of a gauge's presentation, you apply view modifiers to
/// the elements that you want to change. In the example below, the current
/// value, minimum and maximum value labels have custom colors:
///
///     struct StyledGauge: View {
///         @State private var current = 67.0
///         @State private var minValue = 50.0
///         @State private var maxValue = 170.0
///
///         var body: some View {
///             Gauge(value: current, in: minValue...maxValue) {
///                 Image(systemName: "heart.fill")
///                     .foregroundColor(.red)
///             } currentValueLabel: {
///                 Text("\(Int(current))")
///                     .foregroundColor(Color.green)
///             } minimumValueLabel: {
///                 Text("\(Int(minValue))")
///                     .foregroundColor(Color.green)
///             } maximumValueLabel: {
///                 Text("\(Int(maxValue))")
///                     .foregroundColor(Color.red)
///             }
///             .gaugeStyle(.circular)
///         }
///     }
///
/// ![A circular gauge describing heart rate in beats per minute with its
/// value set to 67 on a range of 0 to 170. The style of each label is
/// individually set showing custom label
/// colors.](SkipUI-Gauge-CircularStyled.png)
///
/// You can further style a gauge's appearance by supplying a tint color or
/// a gradient to the style's initializer. The following example shows the
/// effect of a gradient in the initialization of a ``CircularGaugeStyle``
/// gauge with a colorful gradient across the length of the gauge:
///
///     struct StyledGauge: View {
///         @State private var current = 67.0
///         @State private var minValue = 50.0
///         @State private var maxValue = 170.0
///         let gradient = Gradient(colors: [.green, .yellow, .orange, .red])
///
///         var body: some View {
///             Gauge(value: current, in: minValue...maxValue) {
///                 Image(systemName: "heart.fill")
///                     .foregroundColor(.red)
///             } currentValueLabel: {
///                 Text("\(Int(current))")
///                     .foregroundColor(Color.green)
///             } minimumValueLabel: {
///                 Text("\(Int(minValue))")
///                     .foregroundColor(Color.green)
///             } maximumValueLabel: {
///                 Text("\(Int(maxValue))")
///                     .foregroundColor(Color.red)
///             }
///             .gaugeStyle(CircularGaugeStyle(tint: gradient))
///         }
///     }
/// ![A screenshot showing a circular gauge with a gradient
///  tint.](SkipUI-Gauge-Circular-Gradient.png)
///
@available(iOS 16.0, macOS 13.0, watchOS 7.0, *)
@available(tvOS, unavailable)
public struct Gauge<Label, CurrentValueLabel, BoundsLabel, MarkedValueLabels> : View where Label : View, CurrentValueLabel : View, BoundsLabel : View, MarkedValueLabels : View {

    /// Creates a gauge showing a value within a range and describes the
    /// gauge's purpose and current value.
    ///
    /// Use this modifier to create a gauge that shows the value at its
    /// relative position along the gauge and a label describing the gauge's
    /// purpose. In the example below, the gauge has a range of `0...1`, the
    /// indicator is set to `0.4`, or 40 percent of the distance along the
    /// gauge:
    ///
    ///     struct SimpleGauge: View {
    ///         @State private var batteryLevel = 0.4
    ///
    ///         var body: some View {
    ///             Gauge(value: batteryLevel) {
    ///                 Text("Battery Level")
    ///             }
    ///         }
    ///     }
    ///
    /// ![A linear gauge that shows an indicator at 40 percent along the length
    /// of the gauge.](SkipUI-Gauge-ValueLabelLinear.png)
    ///
    /// - Parameters:
    ///     - value: The value to show in the gauge.
    ///     - bounds: The range of the valid values. Defaults to `0...1`.
    ///     - label: A view that describes the purpose of the gauge.
    public init<V>(value: V, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label) where CurrentValueLabel == EmptyView, BoundsLabel == EmptyView, MarkedValueLabels == EmptyView, V : BinaryFloatingPoint { fatalError() }

    /// Creates a gauge showing a value within a range and that describes the
    /// gauge's purpose and current value.
    ///
    /// Use this method to create a gauge that displays a value within a range
    /// you supply with labels that describe the purpose of the gauge and its
    /// current value. In the example below, a gauge using the
    /// ``GaugeStyle/circular`` style shows its current value of `67` along with a
    /// label describing the (BPM) for the gauge:
    ///
    ///     struct SimpleGauge: View {
    ///         @State private var current = 67.0
    ///
    ///         var body: some View {
    ///             Gauge(value: currrent, in: 0...170) {
    ///                 Text("BPM")
    ///             } currentValueLabel: {
    ///                 Text("\(current)")
    ///             }
    ///             .gaugeStyle(.circular)
    ///        }
    ///     }
    ///
    /// ![A screenshot showing a circular gauge describing heart rate in beats
    /// per minute, with the indicator and the current value label indicating a
    /// value of 67.](SkipUI-Gauge-LabelCurrentValueCircular.png)
    ///
    /// - Parameters:
    ///     - value: The value to show on the gauge.
    ///     - bounds: The range of the valid values. Defaults to `0...1`.
    ///     - label: A view that describes the purpose of the gauge.
    ///     - currentValueLabel: A view that describes the current value of
    ///       the gauge.
    public init<V>(value: V, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> CurrentValueLabel) where BoundsLabel == EmptyView, MarkedValueLabels == EmptyView, V : BinaryFloatingPoint { fatalError() }

    /// Creates a gauge showing a value within a range and describes the
    /// gauge's current, minimum, and maximum values.
    ///
    /// Use this method to create a gauge that shows a value within a
    /// prescribed bounds. The gauge has labels that describe its purpose,
    /// and for the gauge's current, minimum, and maximum values.
    ///
    ///     struct LabeledGauge: View {
    ///         @State private var current = 67.0
    ///         @State private var minValue = 0.0
    ///         @State private var maxValue = 170.0
    ///
    ///         var body: some View {
    ///             Gauge(value: current, in: minValue...maxValue) {
    ///                 Text("BPM")
    ///             } currentValueLabel: {
    ///                 Text("\(Int(current))")
    ///             } minimumValueLabel: {
    ///                 Text("\(Int(minValue))")
    ///             } maximumValueLabel: {
    ///                 Text("\(Int(maxValue))")
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot of a gauge, labeled BPM, that's represented by a
    /// semicircle showing its current value of 67 along a range of 0
    /// to 170.](SkipUI-Gauge-LabeledCircular.png)
    ///
    /// - Parameters:
    ///     - value: The value to show on the gauge.
    ///     - bounds: The range of the valid values. Defaults to `0...1`.
    ///     - label: A view that describes the purpose of the gauge.
    ///     - currentValueLabel: A view that describes the current value of
    ///       the gauge.
    ///     - minimumValueLabel: A view that describes the lower bounds of the
    ///       gauge.
    ///     - maximumValueLabel: A view that describes the upper bounds of the
    ///       gauge.
    public init<V>(value: V, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> CurrentValueLabel, @ViewBuilder minimumValueLabel: () -> BoundsLabel, @ViewBuilder maximumValueLabel: () -> BoundsLabel) where MarkedValueLabels == EmptyView, V : BinaryFloatingPoint { fatalError() }

    /// Creates a gauge representing a value within a range.
    ///
    /// - Parameters:
    ///     - value: The value to show in the instance.
    ///     - bounds: The range of the valid values. Defaults to `0...1`.
    ///     - label: A view that describes the purpose of the gauge.
    ///     - currentValueLabel: A view that describes the current value of
    ///       the gauge.
    ///     - minimumValueLabel: A view that describes the lower bounds of the
    ///       gauge.
    ///     - maximumValueLabel: A view that describes the upper bounds of the
    ///       gauge.
    ///     - markedValueLabels: A view builder containing tagged views,
    ///       each of which describes a particular value of the gauge.
    ///       The method ignores this parameter.
    public init<V>(value: V, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> CurrentValueLabel, @ViewBuilder markedValueLabels: () -> MarkedValueLabels) where BoundsLabel == EmptyView, V : BinaryFloatingPoint { fatalError() }

    /// Creates a gauge representing a value within a range.
    ///
    /// - Parameters:
    ///     - value: The value to show in the gauge.
    ///     - bounds: The range of the valid values. Defaults to `0...1`.
    ///     - label: A view that describes the purpose of the gauge.
    ///     - currentValueLabel: A view that describes the current value of
    ///       the gauge.
    ///     - minimumValueLabel: A view that describes the lower bounds of the
    ///       gauge.
    ///     - maximumValueLabel: A view that describes the upper bounds of the
    ///       gauge.
    ///     - markedValueLabels: A view builder containing tagged views.
    ///       each of which describes a particular value of the gauge.
    ///       The method ignores this parameter.
    public init<V>(value: V, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> CurrentValueLabel, @ViewBuilder minimumValueLabel: () -> BoundsLabel, @ViewBuilder maximumValueLabel: () -> BoundsLabel, @ViewBuilder markedValueLabels: () -> MarkedValueLabels) where V : BinaryFloatingPoint { fatalError() }

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

/// Defines the implementation of all gauge instances within a view
/// hierarchy.
///
/// To configure the style for all the ``Gauge`` instances in a view hierarchy,
/// use the ``View/gaugeStyle(_:)`` modifier. For example, you can configure
/// a gauge to use the ``circular`` style:
///
///     Gauge(value: batteryLevel, in: 0...100) {
///         Text("Battery Level")
///     }
///     .gaugeStyle(.circular)
///
@available(iOS 16.0, macOS 13.0, watchOS 7.0, *)
@available(tvOS, unavailable)
public protocol GaugeStyle {

    /// A view representing the body of a gauge.
    associatedtype Body : View

    /// Creates a view representing the body of a gauge.
    ///
    /// The system calls this modifier on each instance of gauge within a view
    /// hierarchy where this style is the current gauge style.
    ///
    /// - Parameter configuration: The properties to apply to the gauge instance.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a gauge instance.
    typealias Configuration = GaugeStyleConfiguration
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension GaugeStyle where Self == AccessoryCircularCapacityGaugeStyle {

    /// A gauge style that displays a closed ring that's partially filled in to
    /// indicate the gauge's current value.
    ///
    /// Apply this style to a ``Gauge`` or to a view hierarchy that contains
    /// gauges using the ``View/gaugeStyle(_:)`` modifier:
    ///
    ///     Gauge(value: batteryLevel, in: 0...100) {
    ///         Text("Battery Level")
    ///     }
    ///     .gaugeStyle(.accessoryCircularCapacity)
    ///
    /// This style displays the gauge's `currentValueLabel` value at the center
    /// of the gauge.
    public static var accessoryCircularCapacity: AccessoryCircularCapacityGaugeStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension GaugeStyle where Self == AccessoryLinearCapacityGaugeStyle {

    /// A gauge style that displays bar that fills from leading to trailing
    /// edges as the gauge's current value increases.
    ///
    /// Apply this style to a ``Gauge`` or to a view hierarchy that contains
    /// gauges using the ``View/gaugeStyle(_:)`` modifier:
    ///
    ///     Gauge(value: batteryLevel, in: 0...100) {
    ///         Text("Battery Level")
    ///     }
    ///     .gaugeStyle(.accessoryLinearCapacity)
    ///
    /// If you provide `minimumValueLabel` and `maximumValueLabel`
    /// parameters when you create the gauge, they appear on leading and
    /// trailing edges of the bar, respectively. The `label` appears above
    /// the gauge, and the `currentValueLabel` appears below.
    public static var accessoryLinearCapacity: AccessoryLinearCapacityGaugeStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension GaugeStyle where Self == AccessoryCircularGaugeStyle {

    /// A gauge style that displays an open ring with a marker that appears at a
    /// point along the ring to indicate the gauge's current value.
    ///
    /// Apply this style to a ``Gauge`` or to a view hierarchy that contains
    /// gauges using the ``View/gaugeStyle(_:)`` modifier:
    ///
    ///     Gauge(value: batteryLevel, in: 0...100) {
    ///         Text("Battery Level")
    ///     }
    ///     .gaugeStyle(.accessoryCircular)
    ///
    /// This style displays the gauge's `currentValueLabel` value at the center
    /// of the gauge. If you provide `minimumValueLabel` and `maximumValueLabel`
    /// parameters when you create the gauge, they appear in the opening at the
    /// bottom of the ring. Otherwise, the gauge places its label in that
    /// location.
    public static var accessoryCircular: AccessoryCircularGaugeStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, watchOS 7.0, *)
@available(tvOS, unavailable)
extension GaugeStyle where Self == DefaultGaugeStyle {

    /// The default gauge view style in the current context of the view being
    /// styled.
    public static var automatic: DefaultGaugeStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension GaugeStyle where Self == LinearCapacityGaugeStyle {

    /// A gauge style that displays a bar that fills from leading to trailing
    /// edges as the gauge's current value increases.
    ///
    /// Apply this style to a ``Gauge`` or to a view hierarchy that contains
    /// gauges using the ``View/gaugeStyle(_:)`` modifier:
    ///
    ///     Gauge(value: batteryLevel, in: 0...100) {
    ///         Text("Battery Level")
    ///     }
    ///     .gaugeStyle(.linearCapacity)
    ///
    /// If you provide `minimumValueLabel` and `maximumValueLabel`
    /// parameters when you create the gauge, they appear on leading and
    /// trailing edges of the bar, respectively. The `label` appears above
    /// the gauge, and the `currentValueLabel` appears below.
    public static var linearCapacity: LinearCapacityGaugeStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension GaugeStyle where Self == AccessoryLinearGaugeStyle {

    /// A gauge style that displays bar with a marker that appears at a
    /// point along the bar to indicate the gauge's current value.
    ///
    /// Apply this style to a ``Gauge`` or to a view hierarchy that contains
    /// gauges using the ``View/gaugeStyle(_:)`` modifier:
    ///
    ///     Gauge(value: batteryLevel, in: 0...100) {
    ///         Text("Battery Level")
    ///     }
    ///     .gaugeStyle(.accessoryLinear)
    ///
    /// If you provide `minimumValueLabel` and `maximumValueLabel`
    /// parameters when you create the gauge, they appear on leading and
    /// trailing edges of the bar, respectively. Otherwise, the gauge displays
    /// the `currentValueLabel` value on the leading edge.
    public static var accessoryLinear: AccessoryLinearGaugeStyle { get { fatalError() } }
}

/// The properties of a gauge instance.
@available(iOS 16.0, macOS 13.0, watchOS 7.0, *)
@available(tvOS, unavailable)
public struct GaugeStyleConfiguration {

    /// A type-erased label of a gauge, describing its purpose.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A type-erased value label of a gauge that contains the current value.
    public struct CurrentValueLabel : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A type-erased value label of a gauge describing the minimum value.
    public struct MinimumValueLabel : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A type-erased value label of a gauge describing the maximum value.
    public struct MaximumValueLabel : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A type-erased label describing a specific value of a gauge.
    public struct MarkedValueLabel : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// The current value of the gauge.
    ///
    /// The valid range is  `0.0...1.0`.
    public var value: Double { get { fatalError() } }

    /// A view that describes the purpose of the gauge.
    public var label: GaugeStyleConfiguration.Label { get { fatalError() } }

    /// A view that describes the current value.
    public var currentValueLabel: GaugeStyleConfiguration.CurrentValueLabel?

    /// A view that describes the minimum of the range for the current value.
    public var minimumValueLabel: GaugeStyleConfiguration.MinimumValueLabel?

    /// A view that describes the maximum of the range for the current value.
    public var maximumValueLabel: GaugeStyleConfiguration.MaximumValueLabel?
}

/// A gauge style that displays bar that fills from leading to trailing
/// edges as the gauge's current value increases.
///
/// Use ``GaugeStyle/linearCapacity`` to construct this style.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public struct LinearCapacityGaugeStyle : GaugeStyle {

    /// Creates a linear capacity gauge style.
    public init() { fatalError() }

    /// Creates a view representing the body of a gauge.
    ///
    /// The system calls this modifier on each instance of gauge within a view
    /// hierarchy where this style is the current gauge style.
    ///
    /// - Parameter configuration: The properties to apply to the gauge instance.
    public func makeBody(configuration: LinearCapacityGaugeStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a gauge.
//    public typealias Body = some View
}

/// The default gauge view style in the current context of the view being
/// styled.
///
/// You can also use ``GaugeStyle/automatic`` to construct this style.
@available(iOS 16.0, macOS 13.0, watchOS 7.0, *)
@available(tvOS, unavailable)
public struct DefaultGaugeStyle : GaugeStyle {

    /// Creates a default gauge style.
    public init() { fatalError() }

    /// Creates a view representing the body of a gauge.
    ///
    /// The system calls this modifier on each instance of gauge within a view
    /// hierarchy where this style is the current gauge style.
    ///
    /// - Parameter configuration: The properties to apply to the gauge instance.
    public func makeBody(configuration: DefaultGaugeStyle.Configuration) -> some View { return never() }


    /// A view representing the body of a gauge.
//    public typealias Body = some View
}

#endif
