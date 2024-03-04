// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clipToBounds
import androidx.compose.ui.draw.scale
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.LinearGradientShader
import androidx.compose.ui.graphics.RadialGradientShader
import androidx.compose.ui.graphics.Shader
import androidx.compose.ui.graphics.ShaderBrush
import androidx.compose.ui.graphics.TileMode
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp
#else
import struct CoreGraphics.CGFloat
#endif

public struct Gradient : ShapeStyle, Hashable {
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
    @Composable func asBrush(opacity: Double, animatable: Bool) -> Brush? {
        return AnyGradient(gradient: self).asBrush(opacity: opacity, animatable: animatable)
    }

    @Composable func colorStops(opacity: Double = 1.0) -> kotlin.collections.List<Pair<Float, androidx.compose.ui.graphics.Color>> {
        let list = mutableListOf<Pair<Float, androidx.compose.ui.graphics.Color>>()
        for stop in stops {
            list.add(Pair(Float(stop.location), stop.color.opacity(opacity).colorImpl()))
        }
        return list
    }
    #endif

    public struct ColorSpace : Hashable, Sendable {
        public static let device = Gradient.ColorSpace()
        public static let perceptual = Gradient.ColorSpace()
    }

    public func colorSpace(_ space: Gradient.ColorSpace) -> AnyGradient {
        return AnyGradient(gradient: self)
    }
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

    @Composable override func asBrush(opacity: Double, animatable: Bool) -> Brush? {
        return gradient.asBrush(opacity: opacity, animatable: animatable)
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

    public init(stops: [Gradient.Stop], startPoint: UnitPoint, endPoint: UnitPoint) {
        self.init(gradient: Gradient(stops: stops), startPoint: startPoint, endPoint: endPoint)
    }

    public init(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) {
        self.init(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let modifier = context.modifier.background(asBrush(opacity: 1.0, animatable: false)!).fillSize(expandContainer: false)
        Box(modifier: modifier)
    }

    // MARK: - ShapeStyle

    @Composable override func asBrush(opacity: Double, animatable: Bool) -> Brush? {
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

public struct EllipticalGradient : ShapeStyle, View, Sendable {
    let gradient: Gradient
    let center: UnitPoint
    let startFraction: CGFloat
    let endFraction: CGFloat

    public init(gradient: Gradient, center: UnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) {
        self.gradient = gradient
        self.center = center
        self.startFraction = startRadiusFraction
        self.endFraction = endRadiusFraction
    }

    public init(colors: [Color], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) {
        self.init(gradient: Gradient(colors: colors), center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }

    public init(stops: [Gradient.Stop], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) {
        self.init(gradient: Gradient(stops: stops), center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        // Trick to scale our (circular) radial brush into an ellipse when this gradient is used as a view
        BoxWithConstraints(modifier: context.modifier.fillSize(expandContainer = false).clipToBounds()) {
            let aspectRatio = maxWidth / maxHeight
            let modifier = Modifier.fillMaxSize().scale(max(aspectRatio, Float(1.0)), max(Float(1.0) / aspectRatio, Float(1.0))).background(asBrush(opacity = 1.0, animatable: false)!!)
            Box(modifier: modifier)
        }
    }

    // MARK: - ShapeStyle

    @Composable override func asBrush(opacity: Double, animatable: Bool) -> Brush? {
        let stops = gradient.colorStops(opacity: opacity)
        let brush = remember { RadialGradientShaderBrush(colorStops: stops, center: center, startFraction: startFraction, endFraction: endFraction) }
        return brush
    }

    private struct RadialGradientShaderBrush: ShaderBrush {
        let colorStops: kotlin.collections.List<Pair<Float, androidx.compose.ui.graphics.Color>>
        let center: UnitPoint
        let startFraction: CGFloat
        let endFraction: CGFloat

        override func createShader(size: androidx.compose.ui.geometry.Size) -> Shader {
            // TODO: We are not creating an ellipitcal gradient (which appears to be impossible in Android).
            // Rather, this is just a normal RadialGradient that fills the smallest dimension
            let center = Offset(x = size.width * Float(center.x), y = size.height * Float(center.y))
            let radius = Float(min(size.width, size.height) * endFraction)
            return RadialGradientShader(center: center, radius: radius, colors: colorStops.map { $0.second }, colorStops: colorStops.map { Float(startFraction) + $0.first * Float(1.0 - startFraction) }, tileMode: TileMode.Clamp)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct RadialGradient : ShapeStyle, View, Sendable {
    let gradient: Gradient
    let center: UnitPoint
    let startRadius: CGFloat
    let endRadius: CGFloat

    public init(gradient: Gradient, center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
        self.gradient = gradient
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }

    public init(colors: [Color], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
        self.init(gradient: Gradient(colors: colors), center: center, startRadius: startRadius, endRadius: endRadius)
    }

    public init(stops: [Gradient.Stop], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
        self.init(gradient: Gradient(stops: stops), center: center, startRadius: startRadius, endRadius: endRadius)
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let modifier = context.modifier.background(asBrush(opacity: 1.0, animatable: false)!).fillSize(expandContainer: false)
        Box(modifier: modifier)
    }

    // MARK: - ShapeStyle

    @Composable override func asBrush(opacity: Double, animatable: Bool) -> Brush? {
        let density = LocalDensity.current
        let start = with(density) { startRadius.dp.toPx() }
        let end = with(density) { endRadius.dp.toPx() }
        let stops = gradient.colorStops(opacity: opacity)
        let brush = remember { RadialGradientShaderBrush(colorStops: stops, center: center, startRadius: start, endRadius: end) }
        return brush
    }

    private struct RadialGradientShaderBrush: ShaderBrush {
        let colorStops: kotlin.collections.List<Pair<Float, androidx.compose.ui.graphics.Color>>
        let center: UnitPoint
        let startRadius: Float
        let endRadius: Float

        override func createShader(size: androidx.compose.ui.geometry.Size) -> Shader {
            let center = Offset(x = size.width * Float(center.x), y = size.height * Float(center.y))
            let startFraction = endRadius == Float(0.0) ? Float(0.0) : startRadius / endRadius
            return RadialGradientShader(center: center, radius: endRadius, colors: colorStops.map { $0.second }, colorStops: colorStops.map { startFraction + $0.first * (Float(1.0) - startFraction) }, tileMode: TileMode.Clamp)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct AngularGradient : ShapeStyle, View, Sendable {
    @available(*, unavailable)
    public init(gradient: Gradient, center: UnitPoint, startAngle: Angle = .zero, endAngle: Angle = .zero) {
    }

    @available(*, unavailable)
    public init(colors: [Color], center: UnitPoint, startAngle: Angle, endAngle: Angle) {
    }

    @available(*, unavailable)
    public init(stops: [Gradient.Stop], center: UnitPoint, startAngle: Angle, endAngle: Angle) {
    }

    @available(*, unavailable)
    public init(gradient: Gradient, center: UnitPoint, angle: Angle = .zero) {
    }

    @available(*, unavailable)
    public init(colors: [Color], center: UnitPoint, angle: Angle = .zero) {
    }

    @available(*, unavailable)
    public init(stops: [Gradient.Stop], center: UnitPoint, angle: Angle = .zero) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}

extension ShapeStyle where Self == LinearGradient {
    public static func linearGradient(_ gradient: Gradient, startPoint: UnitPoint, endPoint: UnitPoint) -> LinearGradient {
        return LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
    }

    public static func linearGradient(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) -> LinearGradient {
        return LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
    }

    public static func linearGradient(stops: [Gradient.Stop], startPoint: UnitPoint, endPoint: UnitPoint) -> LinearGradient {
        return LinearGradient(stops: stops, startPoint: startPoint, endPoint: endPoint)
    }
}

extension ShapeStyle where Self == RadialGradient {
    public static func radialGradient(_ gradient: Gradient, center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) -> RadialGradient {
        return RadialGradient(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius)
    }

    public static func radialGradient(colors: [Color], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) -> RadialGradient {
        return RadialGradient(colors: colors, center: center, startRadius: startRadius, endRadius: endRadius)
    }

    public static func radialGradient(stops: [Gradient.Stop], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) -> RadialGradient {
        return RadialGradient(stops: stops, center: center, startRadius: startRadius, endRadius: endRadius)
    }
}

extension ShapeStyle where Self == EllipticalGradient {
    public static func ellipticalGradient(_ gradient: Gradient, center: UnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> EllipticalGradient {
        return EllipticalGradient(gradient: gradient, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }

    public static func ellipticalGradient(colors: [Color], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> EllipticalGradient {
        return EllipticalGradient(colors: colors, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }

    public static func ellipticalGradient(stops: [Gradient.Stop], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> EllipticalGradient {
        return EllipticalGradient(stops: stops, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
}

extension ShapeStyle where Self == AngularGradient {
    @available(*, unavailable)
    public static func angularGradient(_ gradient: Gradient, center: UnitPoint, startAngle: Angle, endAngle: Angle) -> AngularGradient {
        fatalError()
    }

    @available(*, unavailable)
    public static func angularGradient(colors: [Color], center: UnitPoint, startAngle: Angle, endAngle: Angle) -> AngularGradient {
        fatalError()
    }

    @available(*, unavailable)
    public static func angularGradient(stops: [Gradient.Stop], center: UnitPoint, startAngle: Angle, endAngle: Angle) -> AngularGradient {
        fatalError()
    }

    @available(*, unavailable)
    public static func conicGradient(_ gradient: Gradient, center: UnitPoint, angle: Angle = .zero) -> AngularGradient {
        fatalError()
    }

    @available(*, unavailable)
    public static func conicGradient(colors: [Color], center: UnitPoint, angle: Angle = .zero) -> AngularGradient {
        fatalError()
    }

    @available(*, unavailable)
    public static func conicGradient(stops: [Gradient.Stop], center: UnitPoint, angle: Angle = .zero) -> AngularGradient {
        fatalError()
    }
}
