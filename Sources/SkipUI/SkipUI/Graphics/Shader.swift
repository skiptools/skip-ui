// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
/*
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
import struct CoreGraphics.CGVector
import struct Foundation.Data
import struct Foundation.URL
import class Foundation.Bundle

/// A reference to a function in a Metal shader library, along with its
/// bound uniform argument values.
///
/// Shader values can be used as filter effects on views, see the
/// ``View/colorEffect(_:isEnabled:)`, ``View/distortionEffect(_:isEnabled:)`,
/// and ``View/layerEffect(_:isEnabled:)` functions.
///
/// Shaders also conform to the ``ShapeStyle`` protocol, letting their
/// MSL shader function provide per-pixel color to fill any shape or
/// text view. For a shader function to act as a fill pattern it must
/// have a function signature matching:
///
///     [[ stitchable ]] half4 name(float2 position, args...)
///
/// where `position` is the user-space coordinates of the pixel applied
/// to the shader, and `args...` should be compatible with the uniform
/// arguments bound to `shader`. The function should return the
/// premultiplied color value in the color space of the destination
/// (typically extended sRGB).
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct Shader : Equatable, Sendable {

    /// A single uniform argument value to a shader function.
    public struct Argument : Equatable, Sendable {

        /// Returns an argument value representing the MSL value
        /// `float(x)`.
        public static func float<T>(_ x: T) -> Shader.Argument where T : BinaryFloatingPoint { fatalError() }

        /// Returns an argument value representing the MSL value
        /// `float2(x, y)`.
        public static func float2<T>(_ x: T, _ y: T) -> Shader.Argument where T : BinaryFloatingPoint { fatalError() }

        /// Returns an argument value representing the MSL value
        /// `float3(x, y, z)`.
        public static func float3<T>(_ x: T, _ y: T, _ z: T) -> Shader.Argument where T : BinaryFloatingPoint { fatalError() }

        /// Returns an argument value representing the MSL value
        /// `float4(x, y, z, w)`.
        public static func float4<T>(_ x: T, _ y: T, _ z: T, _ w: T) -> Shader.Argument where T : BinaryFloatingPoint { fatalError() }

        /// Returns an argument value representing the MSL value
        /// `float2(point.x, point.y)`.
        public static func float2(_ point: CGPoint) -> Shader.Argument { fatalError() }

        /// Returns an argument value representing the MSL value
        /// `float2(size.width, size.height)`.
        public static func float2(_ size: CGSize) -> Shader.Argument { fatalError() }

        /// Returns an argument value representing the MSL value
        /// `float2(vector.dx, vector.dy)`.
        public static func float2(_ vector: CGVector) -> Shader.Argument { fatalError() }

        /// Returns an argument value defined by the provided array of
        /// floating point numbers. When passed to an MSL function it
        /// will convert to a `device const float *ptr, int count` pair
        /// of parameters.
        public static func floatArray(_ array: [Float]) -> Shader.Argument { fatalError() }

        /// Returns an argument value representing the bounding rect of
        /// the shape or view that the shader is attached to, as
        /// `float4(x, y, width, height)`. This value is undefined for
        /// shaders that do not have a natural bounding rect (e.g.
        /// filter effects drawn into `GraphicsContext`).
        public static var boundingRect: Shader.Argument { get { fatalError() } }

        /// Returns an argument value representing `color`. When passed
        /// to a MSL function it will convert to a `half4` value, as a
        /// premultiplied color in the target color space.
        public static func color(_ color: Color) -> Shader.Argument { fatalError() }

        /// Returns an argument value defined by the provided array of
        /// color values. When passed to an MSL function it will convert
        /// to a `device const half4 *ptr, int count` pair of
        /// parameters.
        public static func colorArray(_ array: [Color]) -> Shader.Argument { fatalError() }

        /// Returns an argument value defined by the provided image.
        /// When passed to an MSL function it will convert to a
        /// `texture2d<half>` value. Currently only one image parameter
        /// is supported per `Shader` instance.
        public static func image(_ image: Image) -> Shader.Argument { fatalError() }

        /// Returns an argument value defined by the provided data
        /// value. When passed to an MSL function it will convert to a
        /// `device const void *ptr, int size_in_bytes` pair of
        /// parameters.
        public static func data(_ data: Data) -> Shader.Argument { fatalError() }

        
    }

    /// The shader function called by the shader.
    public var function: ShaderFunction { get { fatalError() } }

    /// The uniform argument values passed to the shader function.
    public var arguments: [Shader.Argument]

    /// For shader functions that return color values, whether the
    /// returned color has dither noise added to it, or is simply
    /// rounded to the output bit-depth. For shaders generating smooth
    /// gradients, dithering is usually necessary to prevent visible
    /// banding in the result.
    public var dithersColor: Bool { get { fatalError() } }

    /// Creates a new shader from a function and the uniform argument
    /// values to bind to the function.
    public init(function: ShaderFunction, arguments: [Shader.Argument]) { fatalError() }

    
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension Shader {

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

/// A reference to a function in a Metal shader library.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
@dynamicCallable public struct ShaderFunction : Equatable, Sendable {

    /// The shader library storing the function.
    public var library: ShaderLibrary { get { fatalError() } }

    /// The name of the shader function in the library.
    public var name: String { get { fatalError() } }

    /// Creates a new function reference from the provided shader
    /// library and function name string.
    public init(library: ShaderLibrary, name: String) { fatalError() }

    /// Returns a new shader by applying the provided argument values
    /// to the referenced function.
    ///
    /// Typically this subscript is used implicitly via function-call
    /// syntax, for example:
    ///
    ///    let shader = ShaderLibrary.default.myFunction(.float(42))
    ///
    /// which creates a shader passing the value `42` to the first
    /// unbound parameter of `myFunction()`.
    public func dynamicallyCall(withArguments args: [Shader.Argument]) -> Shader { fatalError() }

    
}

/// A Metal shader library.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
@dynamicMemberLookup public struct ShaderLibrary : Equatable, @unchecked Sendable {

    /// The default shader library of the main (i.e. app) bundle.
    public static let `default`: ShaderLibrary = { fatalError() }()

    /// Returns the default shader library of the specified bundle.
    public static func bundle(_ bundle: Bundle) -> ShaderLibrary { fatalError() }

    /// Creates a new Metal shader library from `data`, which must be
    /// the contents of precompiled Metal library. Functions compiled
    /// from the returned library will only be cached as long as the
    /// returned library exists.
    public init(data: Data) { fatalError() }

    /// Creates a new Metal shader library from the contents of `url`,
    /// which must be the location  of precompiled Metal library.
    /// Functions compiled from the returned library will only be
    /// cached as long as the returned library exists.
    public init(url: URL) { fatalError() }

    /// Returns a new shader function representing the stitchable MSL
    /// function called `name` in the default shader library.
    ///
    /// Typically this subscript is used implicitly via the dynamic
    /// member syntax, for example:
    ///
    ///    let fn = ShaderLibrary.myFunction
    ///
    /// which creates a reference to the MSL function called
    /// `myFunction()`.
    public static subscript(dynamicMember name: String) -> ShaderFunction { get { fatalError() } }

    /// Returns a new shader function representing the stitchable MSL
    /// function in the library called `name`.
    ///
    /// Typically this subscript is used implicitly via the dynamic
    /// member syntax, for example:
    ///
    ///    let fn = ShaderLibrary.default.myFunction
    ///
    /// which creates a reference to the MSL function called
    /// `myFunction()`.
    public subscript(dynamicMember name: String) -> ShaderFunction { get { fatalError() } }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension View {

    /// Returns a new view that applies `shader` to `self` as a filter
    /// effect on the color of each pixel.
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
    public func colorEffect(_ shader: Shader, isEnabled: Bool = true) -> some View { return stubView() }


    /// Returns a new view that applies `shader` to `self` as a
    /// geometric distortion effect on the location of each pixel.
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
    public func distortionEffect(_ shader: Shader, maxSampleOffset: CGSize, isEnabled: Bool = true) -> some View { return stubView() }


    /// Returns a new view that applies `shader` to `self` as a filter
    /// on the raster layer created from `self`.
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
    public func layerEffect(_ shader: Shader, maxSampleOffset: CGSize, isEnabled: Bool = true) -> some View { return stubView() }

}
*/
