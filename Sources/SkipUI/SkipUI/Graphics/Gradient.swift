// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.LinearGradientShader
import androidx.compose.ui.graphics.Shader
import androidx.compose.ui.graphics.ShaderBrush
import androidx.compose.ui.graphics.TileMode
#else
import struct CoreGraphics.CGFloat
#endif

public struct Gradient : Hashable {
    public struct Stop : Hashable, Sendable {
        public let color: Color
        public let location: CGFloat

        public init(color: Color, location: CGFloat) {
            self.color = color
            self.location = location
        }
    }

    public var stops: [Gradient.Stop]

    public init(stops: [Gradient.Stop]) {
        self.stops = stops
    }

    public init(colors: [Color]) {
        if colors.isEmpty {
            self.stops = []
        } else {
            let step = colors.count == 1 ? 0.0 : 1.0 / Double(colors.count - 1)
            self.stops = colors.enumerated().map { Gradient.Stop(color: $0.1, location: step * Double($0.0)) }
        }
    }

    #if SKIP
    @Composable func colorStops(opacity: Double = 1.0) -> kotlin.collections.List<Pair<Float, androidx.compose.ui.graphics.Color>> {
        let list = mutableListOf<Pair<Float, androidx.compose.ui.graphics.Color>>()
        for stop in stops {
            list.add(Pair(Float(stop.location), stop.color.opacity(opacity).colorImpl()))
        }
        return list
    }
    #endif
}

public struct AnyGradient : ShapeStyle, View, Sendable {
    let gradient: LinearGradient

    public init(gradient: Gradient) {
        self.gradient = LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: UnitPoint(x: 0.5, y: 1.0))
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let _ = gradient.Compose(context: context)
    }

    // MARK: - ShapeStyle

    @Composable override func asBrush(opacity: Double) -> Brush? {
        return gradient.asBrush(opacity: opacity)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct LinearGradient : ShapeStyle, View, Sendable {
    let gradient: Gradient
    let startPoint: UnitPoint
    let endPoint: UnitPoint

    public init(gradient: Gradient, startPoint: UnitPoint, endPoint: UnitPoint) {
        self.gradient = gradient
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    public init(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) {
        self.init(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }

    public init(stops: [Gradient.Stop], startPoint: UnitPoint, endPoint: UnitPoint) {
        self.init(gradient: Gradient(stops: stops), startPoint: startPoint, endPoint: endPoint)
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let modifier = context.modifier.background(asBrush(opacity: 1.0)!).fillSize(expandContainer: false)
        Box(modifier: modifier)
    }

    // MARK: - ShapeStyle

    @Composable override func asBrush(opacity: Double) -> Brush? {
        let stops = gradient.colorStops(opacity: opacity)
        let brush = remember { LinearGradientShaderBrush(colorStops: stops, startPoint: startPoint, endPoint: endPoint) }
        return brush
    }

    private struct LinearGradientShaderBrush: ShaderBrush {
        let colorStops: kotlin.collections.List<Pair<Float, androidx.compose.ui.graphics.Color>>
        let startPoint: UnitPoint
        let endPoint: UnitPoint

        override func createShader(size: androidx.compose.ui.geometry.Size) -> Shader {
            let from = Offset(x: size.width * Float(startPoint.x), y: size.height * Float(startPoint.y))
            let to = Offset(x: size.width * Float(endPoint.x), y: size.height * Float(endPoint.y))
            return LinearGradientShader(from, to, colors: colorStops.map { $0.second }, colorStops: colorStops.map { $0.first }, tileMode: TileMode.Clamp)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if !SKIP

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Gradient : ShapeStyle {

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

extension Gradient {

    /// A method of interpolating between the colors in a gradient.
    public struct ColorSpace : Hashable, Sendable {

        /// Interpolates gradient colors in the output color space.
        public static let device: Gradient.ColorSpace = { fatalError() }()

        /// Interpolates gradient colors in a perceptual color space.
        public static let perceptual: Gradient.ColorSpace = { fatalError() }()
    }

    /// Returns a version of the gradient that will use a specified
    /// color space for interpolating between its colors.
    ///
    ///     Rectangle().fill(.linearGradient(
    ///         colors: [.white, .blue]).colorSpace(.perceptual))
    ///
    /// - Parameters:
    ///   - space: The color space the new gradient will use to
    ///     interpolate its constituent colors.
    ///
    /// - Returns: A new gradient that interpolates its colors in the
    ///   specified color space.
    ///
    public func colorSpace(_ space: Gradient.ColorSpace) -> AnyGradient { fatalError() }
}

// TODO: Process for use in SkipUI

/// An angular gradient.
///
/// An angular gradient is also known as a "conic" gradient. This gradient
/// applies the color function as the angle changes, relative to a center
/// point and defined start and end angles. If `endAngle - startAngle > 2π`,
/// the gradient only draws the last complete turn. If
/// `endAngle - startAngle < 2π`, the gradient fills the missing area with
/// the colors defined by gradient locations one and zero, transitioning
/// between the two halfway across the missing area. The gradient maps the
/// unit space center point into the bounding rectangle of each shape filled
/// with the gradient.
///
/// When using an angular gradient as a shape style, you can also use
/// ``ShapeStyle/angularGradient(_:center:startAngle:endAngle:)-378tu``,
/// ``ShapeStyle/conicGradient(_:center:angle:)-e0rd``, or similar methods.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct AngularGradient : ShapeStyle, View, Sendable {

    /// Creates an angular gradient.
    public init(gradient: Gradient, center: UnitPoint, startAngle: Angle = .zero, endAngle: Angle = .zero) { fatalError() }

    /// Creates an angular gradient from a collection of colors.
    public init(colors: [Color], center: UnitPoint, startAngle: Angle, endAngle: Angle) { fatalError() }

    /// Creates an angular gradient from a collection of color stops.
    public init(stops: [Gradient.Stop], center: UnitPoint, startAngle: Angle, endAngle: Angle) { fatalError() }

    /// Creates a conic gradient that completes a full turn.
    public init(gradient: Gradient, center: UnitPoint, angle: Angle = .zero) { fatalError() }

    /// Creates a conic gradient from a collection of colors that completes
    /// a full turn.
    public init(colors: [Color], center: UnitPoint, angle: Angle = .zero) { fatalError() }

    /// Creates a conic gradient from a collection of color stops that
    /// completes a full turn.
    public init(stops: [Gradient.Stop], center: UnitPoint, angle: Angle = .zero) { fatalError() }

    public typealias Body = NeverView
    public var body: Body { fatalError() }

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

/// A radial gradient that draws an ellipse.
///
/// The gradient maps its coordinate space to the unit space square
/// in which its center and radii are defined, then stretches that
/// square to fill its bounding rect, possibly also stretching the
/// circular gradient to have elliptical contours.
///
/// For example, an elliptical gradient centered on the view, filling
/// its bounds:
///
///     EllipticalGradient(gradient: .init(colors: [.red, .yellow]))
///
/// When using an elliptical gradient as a shape style, you can also use
/// ``ShapeStyle/ellipticalGradient(_:center:startRadiusFraction:endRadiusFraction:)-fmox``.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@frozen public struct EllipticalGradient : ShapeStyle, View, Sendable {

    /// Creates an elliptical gradient.
    ///
    /// For example, an elliptical gradient centered on the top-leading
    /// corner of the view:
    ///
    ///     EllipticalGradient(
    ///         gradient: .init(colors: [.blue, .green]),
    ///         center: .topLeading,
    ///         startRadiusFraction: 0,
    ///         endRadiusFraction: 1)
    ///
    /// - Parameters:
    ///  - gradient: The colors and their parametric locations.
    ///  - center: The center of the circle, in [0, 1] coordinates.
    ///  - startRadiusFraction: The start radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    ///  - endRadiusFraction: The end radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    public init(gradient: Gradient, center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) { fatalError() }

    /// Creates an elliptical gradient from a collection of colors.
    ///
    /// For example, an elliptical gradient centered on the top-leading
    /// corner of the view:
    ///
    ///     EllipticalGradient(
    ///         colors: [.blue, .green],
    ///         center: .topLeading,
    ///         startRadiusFraction: 0,
    ///         endRadiusFraction: 1)
    ///
    /// - Parameters:
    ///  - colors: The colors, evenly distributed throughout the gradient.
    ///  - center: The center of the circle, in [0, 1] coordinates.
    ///  - startRadiusFraction: The start radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    ///  - endRadiusFraction: The end radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    public init(colors: [Color], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) { fatalError() }

    /// Creates an elliptical gradient from a collection of color stops.
    ///
    /// For example, an elliptical gradient centered on the top-leading
    /// corner of the view, with some extra green area:
    ///
    ///     EllipticalGradient(
    ///         stops: [
    ///             .init(color: .blue, location: 0.0),
    ///             .init(color: .green, location: 0.9),
    ///             .init(color: .green, location: 1.0),
    ///         ],
    ///         center: .topLeading,
    ///         startRadiusFraction: 0,
    ///         endRadiusFraction: 1)
    ///
    /// - Parameters:
    ///  - stops: The colors and their parametric locations.
    ///  - center: The center of the circle, in [0, 1] coordinates.
    ///  - startRadiusFraction: The start radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    ///  - endRadiusFraction: The end radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    public init(stops: [Gradient.Stop], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) { fatalError() }

    public typealias Body = NeverView
    public var body: Body { fatalError() }

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

/// A radial gradient.
///
/// The gradient applies the color function as the distance from a center
/// point, scaled to fit within the defined start and end radii. The
/// gradient maps the unit space center point into the bounding rectangle of
/// each shape filled with the gradient.
///
/// When using a radial gradient as a shape style, you can also use
/// ``ShapeStyle/radialGradient(_:center:startRadius:endRadius:)-49kel``.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct RadialGradient : ShapeStyle, View, Sendable {

    /// Creates a radial gradient from a base gradient.
    public init(gradient: Gradient, center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) { fatalError() }

    /// Creates a radial gradient from a collection of colors.
    public init(colors: [Color], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) { fatalError() }

    /// Creates a radial gradient from a collection of color stops.
    public init(stops: [Gradient.Stop], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) { fatalError() }

    public typealias Body = NeverView

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
    public var body: Body { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension AnyGradient {

    /// Returns a version of the gradient that will use a specified
    /// color space for interpolating between its colors.
    ///
    ///     Rectangle().fill(.linearGradient(
    ///         colors: [.white, .blue]).colorSpace(.perceptual))
    ///
    /// - Parameters:
    ///   - space: The color space the new gradient will use to
    ///     interpolate its constituent colors.
    ///
    /// - Returns: A new gradient that interpolates its colors in the
    ///   specified color space.
    ///
    public func colorSpace(_ space: Gradient.ColorSpace) -> AnyGradient { fatalError() }
}

#endif
