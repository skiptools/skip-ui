// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP


/// A type that can serve as the animatable data of an animatable type.
///
/// `VectorArithmetic` extends the `AdditiveArithmetic` protocol with scalar
/// multiplication and a way to query the vector magnitude of the value. Use
/// this type as the `animatableData` associated type of a type that conforms to
/// the ``Animatable`` protocol.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol VectorArithmetic : AdditiveArithmetic {

    /// Multiplies each component of this value by the given value.
    mutating func scale(by rhs: Double)

    /// Returns the dot-product of this vector arithmetic instance with itself.
    var magnitudeSquared: Double { get }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension VectorArithmetic {

    /// Returns a value with each component of this value multiplied by the
    /// given value.
    public func scaled(by rhs: Double) -> Self { fatalError() }

    /// Interpolates this value with `other` by the specified `amount`.
    ///
    /// This is equivalent to `self = self + (other - self) * amount`.
    public mutating func interpolate(towards other: Self, amount: Double) { fatalError() }

    /// Returns this value interpolated with `other` by the specified `amount`.
    ///
    /// This result is equivalent to `self + (other - self) * amount`.
    public func interpolated(towards other: Self, amount: Double) -> Self { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Float : VectorArithmetic {

    /// Multiplies each component of this value by the given value.
    public mutating func scale(by rhs: Double) { fatalError() }

    /// Returns the dot-product of this vector arithmetic instance with itself.
    public var magnitudeSquared: Double { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Double : VectorArithmetic {

    /// Multiplies each component of this value by the given value.
    public mutating func scale(by rhs: Double) { fatalError() }

    /// Returns the dot-product of this vector arithmetic instance with itself.
    public var magnitudeSquared: Double { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGFloat : VectorArithmetic {

    /// Multiplies each component of this value by the given value.
    public mutating func scale(by rhs: Double) { fatalError() }

    /// Returns the dot-product of this vector arithmetic instance with itself.
    public var magnitudeSquared: Double { get { fatalError() } }
}

extension Never : VectorArithmetic {
    public static func - (lhs: Never, rhs: Never) -> Never { fatalError() }
    public static func + (lhs: Never, rhs: Never) -> Never { fatalError() }
    public mutating func scale(by rhs: Double) { fatalError() }
    public var magnitudeSquared: Double { fatalError() }
    public static var zero: Never { fatalError() }
}

#endif
