// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A geometric angle whose value you access in either radians or degrees.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Angle {

    public var radians: Double { get { fatalError() } }

    @inlinable public var degrees: Double { get { fatalError() } }

    @inlinable public init() { fatalError() }

    @inlinable public init(radians: Double) { fatalError() }

    @inlinable public init(degrees: Double) { fatalError() }

    @inlinable public static func radians(_ radians: Double) -> Angle { fatalError() }

    @inlinable public static func degrees(_ degrees: Double) -> Angle { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Angle : Hashable, Comparable {

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func < (lhs: Angle, rhs: Angle) -> Bool { fatalError() }

    


}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Angle : Animatable {

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    @inlinable public static var zero: Angle { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = Double
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Angle : Sendable {
}

#endif
