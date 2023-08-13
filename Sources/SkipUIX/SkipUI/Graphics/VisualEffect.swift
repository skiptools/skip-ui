// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// No-op
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@usableFromInline func stubVisualEffect() -> some VisualEffect {
    return never()
}

/// Visual Effects change the visual appearance of a view without changing its
/// ancestors or descendents.
///
/// Because effects do not impact layout, they are safe to use in situations
/// where layout modification is not allowed. For example, effects may be
/// applied as a function of position, accessed through a geometry proxy:
///
/// ```swift
/// var body: some View {
///     ContentRow()
///         .visualEffect { content, geometryProxy in
///             content.offset(x: geometryProxy.frame(in: .global).origin.y)
///         }
/// }
/// ```
///
/// You don't conform to this protocol yourself. Instead, visual effects are
/// created by calling modifier functions (such as `.offset(x:y:)` on other
/// effects, as seen in the example above.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol VisualEffect : Sendable, Animatable {
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Offsets the view by the horizontal and vertical amount specified in the
    /// offset parameter.
    ///
    /// - Parameter offset: The distance to offset the view.
    ///
    /// - Returns: An effect that offsets the view by `offset`.
//    public func offset(_ offset: CGSize) -> some VisualEffectInsetShape


    /// Offsets the view by the specified horizontal and vertical distances.
    ///
    /// - Parameters:
    ///   - x: The horizontal distance to offset the view.
    ///   - y: The vertical distance to offset the view.
    ///
    /// - Returns: An effect that offsets the view by `x` and `y`.
    public func offset(x: CGFloat = 0, y: CGFloat = 0) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Applies a projection transformation to the view's rendered output.
    ///
    /// Use `transformEffect(_:)` to rotate, scale, translate, or skew the
    /// output of the view according to the provided
    /// .
    ///
    /// - Parameter transform: A
    ///  to
    /// apply to the view.
    ///
    /// - Returns: An effect that applies a projection transformation to the
    ///   view's rendered output.
    public func transformEffect(_ transform: ProjectionTransform) -> some VisualEffect { return stubVisualEffect() }


    /// Applies an affine transformation to the view's rendered output.
    ///
    /// Use `transformEffect(_:)` to rotate, scale, translate, or skew the
    /// output of the view according to the provided
    /// .
    ///
    /// - Parameter transform: A
    ///  to
    /// apply to the view.
    ///
    /// - Returns: An effect that applies an affine transformation to the
    ///   view's rendered output.
    ///
    public func transformEffect(_ transform: CGAffineTransform) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Rotates the view's rendered output around the specified point.
    ///
    /// - Parameters:
    ///   - angle: The angle at which to rotate the view.
    ///   - anchor: The location with a default of ``UnitPoint/center`` that
    ///     defines a point at which the rotation is anchored.
    /// - Returns: An effect that rotates the view's rendered output.
    public func rotationEffect(_ angle: Angle, anchor: UnitPoint = .center) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Scales the view's rendered output by the given vertical and horizontal
    /// size amounts, relative to an anchor point.
    ///
    /// - Parameters:
    ///   - scale: A  that
    ///     represents the horizontal and vertical amount to scale the view.
    ///   - anchor: The point with a default of ``UnitPoint/center`` that
    ///     defines the location within the view from which to apply the
    ///     transformation.
    ///
    /// - Returns: An effect that scales the view's rendered output.
    public func scaleEffect(_ scale: CGSize, anchor: UnitPoint = .center) -> some VisualEffect { return stubVisualEffect() }


    /// Scales the view's rendered output by the given amount in both the
    /// horizontal and vertical directions, relative to an anchor point.
    ///
    /// - Parameters:
    ///   - s: The amount to scale the view in the view in both the horizontal
    ///     and vertical directions.
    ///   - anchor: The point with a default of ``UnitPoint/center`` that
    ///     defines the location within the view from which to apply the
    ///     transformation.
    ///
    /// - Returns: An effect that scales the view's rendered output.
    public func scaleEffect(_ scale: CGFloat, anchor: UnitPoint = .center) -> some VisualEffect { return stubVisualEffect() }


    /// Scales the view's rendered output by the given horizontal and vertical
    /// amounts, relative to an anchor point.
    ///
    /// - Parameters:
    ///   - x: An amount that represents the horizontal amount to scale the
    ///     view. The default value is `1.0`.
    ///   - y: An amount that represents the vertical amount to scale the view.
    ///     The default value is `1.0`.
    ///   - anchor: The point with a default of ``UnitPoint/center`` that
    ///     defines the location within the view from which to apply the
    ///     transformation.
    ///
    /// - Returns: An effect that scales the view's rendered output.
    public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0, anchor: UnitPoint = .center) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Applies a Gaussian blur to the view.
    ///
    /// Use `blur(radius:opaque:)` to apply a gaussian blur effect to the
    /// rendering of the view.
    ///
    /// - Parameters:
    ///   - radius: The radial size of the blur. A blur is more diffuse when its
    ///     radius is large.
    ///   - opaque: A Boolean value that indicates whether the blur renderer
    ///     permits transparency in the blur output. Set to `true` to create an
    ///     opaque blur, or set to `false` to permit transparency.
    ///
    /// - Returns: An effect that blurs the view.
    public func blur(radius: CGFloat, opaque: Bool = false) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Brightens the view by the specified amount.
    ///
    /// - Parameter amount: A value between 0 (no effect) and 1 (full white
    ///   brightening) that represents the intensity of the brightness effect.
    ///
    /// - Returns: An effect that brightens the view by the specified amount.
    public func brightness(_ amount: Double) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Sets the contrast and separation between similar colors in the view.
    ///
    /// Apply contrast to a view to increase or decrease the separation between
    /// similar colors in the view.
    ///
    /// - Parameter amount: The intensity of color contrast to apply. negative
    ///   values invert colors in addition to applying contrast.
    ///
    /// - Returns: An effect that applies color contrast to the view.
    public func contrast(_ amount: Double) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Adds a grayscale effect to the view.
    ///
    /// A grayscale effect reduces the intensity of colors in the view.
    ///
    /// - Parameter amount: The intensity of grayscale to apply from 0.0 to less
    ///   than 1.0. Values closer to 0.0 are more colorful, and values closer to
    ///   1.0 are less colorful.
    ///
    /// - Returns: An effect that reduces the intensity of colors in the view.
    public func grayscale(_ amount: Double) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Applies a hue rotation effect to the view.
    ///
    /// Use hue rotation effect to shift all of the colors in a view according
    /// to the angle you specify.
    ///
    /// - Parameter angle: The hue rotation angle to apply to the colors in the
    ///   view.
    ///
    /// - Returns: An effect that shifts all of the colors in the view.
    public func hueRotation(_ angle: Angle) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Adjusts the color saturation of the view.
    ///
    /// Use color saturation to increase or decrease the intensity of colors in
    /// a view.
    ///
    /// - SeeAlso: `contrast(_:)`
    /// - Parameter amount: The amount of saturation to apply to the view.
    ///
    /// - Returns: An effect that adjusts the saturation of the view.
    public func saturation(_ amount: Double) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension VisualEffect {

    /// Returns a new visual effect that applies `shader` to `self` as
    /// a filter effect on the color of each pixel.
    ///
    /// For a shader function to act as a color filter it must have a
    /// function signature matching:
    ///
    ///     [[ stitchable ]] half4 name(float2 position, half4 color, args...)
    ///
    /// where `position` is the user-space coordinates of the pixel
    /// applied to the shader and `color` its source color, as a
    /// pre-multiplied color in the destination color space. `args...`
    /// should be compatible with the uniform arguments bound to
    /// `shader`. The function should return the modified color value.
    ///
    /// > Important: Views backed by AppKit or UIKit views may not
    ///   render into the filtered layer. Instead, they log a warning
    ///   and display a placeholder image to highlight the error.
    ///
    /// - Parameters:
    ///   - shader: The shader to apply to `self` as a color filter.
    ///   - isEnabled: Whether the effect is enabled or not.
    ///
    /// - Returns: A new view that renders `self` with the shader
    ///   applied as a color filter.
    public func colorEffect(_ shader: Shader, isEnabled: Bool = true) -> some VisualEffect { return stubVisualEffect() }


    /// Returns a new visual effect that applies `shader` to `self` as
    /// a geometric distortion effect on the location of each pixel.
    ///
    /// For a shader function to act as a distortion effect it must
    /// have a function signature matching:
    ///
    ///     [[ stitchable ]] float2 name(float2 position, args...)
    ///
    /// where `position` is the user-space coordinates of the
    /// destination pixel applied to the shader. `args...` should be
    /// compatible with the uniform arguments bound to `shader`. The
    /// function should return the user-space coordinates of the
    /// corresponding source pixel.
    ///
    /// > Important: Views backed by AppKit or UIKit views may not
    ///   render into the filtered layer. Instead, they log a warning
    ///   and display a placeholder image to highlight the error.
    ///
    /// - Parameters:
    ///   - shader: The shader to apply as a distortion effect.
    ///   - maxSampleOffset: The maximum distance in each axis between
    ///     the returned source pixel position and the destination pixel
    ///     position, for all source pixels.
    ///   - isEnabled: Whether the effect is enabled or not.
    ///
    /// - Returns: A new view that renders `self` with the shader
    ///   applied as a distortion effect.
    public func distortionEffect(_ shader: Shader, maxSampleOffset: CGSize, isEnabled: Bool = true) -> some VisualEffect { return stubVisualEffect() }


    /// Returns a new visual effect that applies `shader` to `self` as
    /// a filter on the raster layer created from `self`.
    ///
    /// For a shader function to act as a layer effect it must
    /// have a function signature matching:
    ///
    ///     [[ stitchable ]] half4 name(float2 position,
    ///       SkipUI::Layer layer, args...)
    ///
    /// where `position` is the user-space coordinates of the
    /// destination pixel applied to the shader, and `layer` is a
    /// subregion of the raster contents of `self`. `args...` should be
    /// compatible with the uniform arguments bound to `shader`. The
    /// function should return the color mapping to the destination
    /// pixel, typically by sampling one or more pixels from `layer` at
    /// location(s) derived from `position` and them applying some kind
    /// of transformation to produce a new color.
    ///
    /// > Important: Views backed by AppKit or UIKit views may not
    ///   render into the filtered layer. Instead, they log a warning
    ///   and display a placeholder image to highlight the error.
    ///
    /// - Parameters:
    ///   - shader: The shader to apply as a layer effect.
    ///   - maxSampleOffset: If the shader function samples from the
    ///     layer at locations not equal to the destination position,
    ///     this value must specify the maximum sampling distance in
    ///     each axis, for all source pixels.
    ///   - isEnabled: Whether the effect is enabled or not.
    ///
    /// - Returns: A new view that renders `self` with the shader
    ///   applied as a distortion effect.
    public func layerEffect(_ shader: Shader, maxSampleOffset: CGSize, isEnabled: Bool = true) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Sets the transparency of the view.
    ///
    /// When applying the `opacity(_:)` effect to a view that has already had
    /// its opacity transformed, the effect of the underlying opacity
    /// transformation is multiplied.
    ///
    /// - Parameter opacity: A value between 0 (fully transparent) and 1 (fully
    ///   opaque).
    ///
    /// - Returns: An effect that sets the transparency of the view.
    public func opacity(_ opacity: Double) -> some VisualEffect { return stubVisualEffect() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffect {

    /// Rotates the view's rendered output in three dimensions around the given
    /// axis of rotation.
    ///
    /// Use `rotation3D(_:axis:anchor:anchorZ:perspective:)` to rotate the
    /// view in three dimensions around the given axis of rotation, and
    /// optionally, position the view at a custom display order and perspective.
    ///
    /// - Parameters:
    ///   - angle: The angle at which to rotate the view.
    ///   - axis: The `x`, `y` and `z` elements that specify the axis of
    ///     rotation.
    ///   - anchor: The location with a default of ``UnitPoint/center`` that
    ///     defines a point in 3D space about which the rotation is anchored.
    ///   - anchorZ: The location with a default of `0` that defines a point in
    ///     3D space about which the rotation is anchored.
    ///   - perspective: The relative vanishing point with a default of `1` for
    ///     this rotation.
    ///
    /// - Returns: An effect that rotates the view's rendered output in three
    ///   dimensions.
    public func rotation3D(_ angle: Angle, axis: (x: CGFloat, y: CGFloat, z: CGFloat), anchor: UnitPoint = .center, anchorZ: CGFloat = 0, perspective: CGFloat = 1) -> some VisualEffect { return stubVisualEffect() }

}

/// The base visual effect that you apply additional effect to.
///
/// `EmptyVisualEffect` does not change the appearance of the view
/// that it is applied to.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct EmptyVisualEffect : VisualEffect {

    /// Creates a new empty visual effect.
    public init() { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Applies the given transition, animating between the phases
    /// of the transition as this view appears and disappears within the
    /// visible region of the containing scroll view, or other container
    /// specified using the `coordinateSpace` parameter.
    ///
    /// - Parameters:
    ///   - configuration: The configuration controlling how the
    ///     transition will be applied. The configuration will be applied both
    ///     while the view is coming into view and while it is disappearing (the
    ///     transition is symmetrical).
    ///   - axis: The axis over which the transition should be applied.
    ///   - coordinateSpace: The coordinate space of the container that
    ///     visibility is evaluated within. Defaults to `.scrollView`.
    ///   - transition: A closure that applies visual effects as a function of
    ///     the provided phase.
    public func scrollTransition(_ configuration: ScrollTransitionConfiguration = .interactive, axis: Axis = .vertical, transition: @escaping @Sendable (EmptyVisualEffect, ScrollTransitionPhase) -> some VisualEffect) -> some View { return stubView() }


    /// Applies the given transition, animating between the phases
    /// of the transition as this view appears and disappears within the
    /// visible region of the containing scroll view, or other container
    /// specified using the `coordinateSpace` parameter.
    ///
    /// - Parameters:
    ///   - transition: the transition to apply.
    ///   - topLeading: The configuration that drives the transition when
    ///     the view is about to appear at the top edge of a vertical
    ///     scroll view, or the leading edge of a horizont scroll view.
    ///   - bottomTrailing: The configuration that drives the transition when
    ///     the view is about to appear at the bottom edge of a vertical
    ///     scroll view, or the trailing edge of a horizont scroll view.
    ///   - axis: The axis over which the transition should be applied.
    ///   - transition: A closure that applies visual effects as a function of
    ///     the provided phase.
    public func scrollTransition(topLeading: ScrollTransitionConfiguration, bottomTrailing: ScrollTransitionConfiguration, axis: Axis = .vertical, transition: @escaping @Sendable (EmptyVisualEffect, ScrollTransitionPhase) -> some VisualEffect) -> some View { return stubView() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Applies effects to this view, while providing access to layout information
    /// via `GeometryProxy`.
    ///
    /// You return new effects by calling functions on the first argument
    /// provided to the `effect` closure. In this example, `ContentView` is
    /// offset by its own size, causing its top left corner to appear where the
    /// bottom right corner was originally located:
    /// ```swift
    /// ContentView()
    ///     .visualEffect { content, geometryProxy in
    ///         content.offset(geometryProxy.size)
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - effect: A closure that returns the effect to be applied. The first
    ///     argument provided to the closure is a placeholder representing
    ///     this view. The second argument is a `GeometryProxy`.
    /// - Returns: A view with the effect applied.
    public func visualEffect(_ effect: @escaping @Sendable (EmptyVisualEffect, GeometryProxy) -> some VisualEffect) -> some View { return stubView() }

}

extension Never : VisualEffect {
}

#endif
