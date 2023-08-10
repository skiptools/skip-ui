// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A matrix to use in an RGBA color transformation.
///
/// The matrix has five columns, each with a red, green, blue, and alpha
/// component. You can use the matrix for tasks like creating a color
/// transformation ``GraphicsContext/Filter`` for a ``GraphicsContext`` using
/// the ``GraphicsContext/Filter/colorMatrix(_:)`` method.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@frozen public struct ColorMatrix : Equatable {

    public var r1: Float { get { fatalError() } }

    public var r2: Float { get { fatalError() } }

    public var r3: Float { get { fatalError() } }

    public var r4: Float { get { fatalError() } }

    public var r5: Float { get { fatalError() } }

    public var g1: Float { get { fatalError() } }

    public var g2: Float { get { fatalError() } }

    public var g3: Float { get { fatalError() } }

    public var g4: Float { get { fatalError() } }

    public var g5: Float { get { fatalError() } }

    public var b1: Float { get { fatalError() } }

    public var b2: Float { get { fatalError() } }

    public var b3: Float { get { fatalError() } }

    public var b4: Float { get { fatalError() } }

    public var b5: Float { get { fatalError() } }

    public var a1: Float { get { fatalError() } }

    public var a2: Float { get { fatalError() } }

    public var a3: Float { get { fatalError() } }

    public var a4: Float { get { fatalError() } }

    public var a5: Float { get { fatalError() } }

    /// Creates the identity matrix.
    @inlinable public init() { fatalError() }

    
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ColorMatrix : Sendable {
}


#endif
