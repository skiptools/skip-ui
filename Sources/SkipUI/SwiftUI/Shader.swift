// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import struct Foundation.Data

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

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (a: Shader.Argument, b: Shader.Argument) -> Bool { fatalError() }
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

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: Shader, b: Shader) -> Bool { fatalError() }
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
