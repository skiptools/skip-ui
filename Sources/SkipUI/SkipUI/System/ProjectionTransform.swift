// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if false

import struct CoreGraphics.CGAffineTransform
import struct CoreGraphics.CGFloat
import struct QuartzCore.CATransform3D

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct ProjectionTransform {

    public var m11: CGFloat { get { fatalError() } }

    public var m12: CGFloat { get { fatalError() } }

    public var m13: CGFloat { get { fatalError() } }

    public var m21: CGFloat { get { fatalError() } }

    public var m22: CGFloat { get { fatalError() } }

    public var m23: CGFloat { get { fatalError() } }

    public var m31: CGFloat { get { fatalError() } }

    public var m32: CGFloat { get { fatalError() } }

    public var m33: CGFloat { get { fatalError() } }

    @inlinable public init() { fatalError() }

    @inlinable public init(_ m: CGAffineTransform) { fatalError() }

    @inlinable public init(_ m: CATransform3D) { fatalError() }

    @inlinable public var isIdentity: Bool { get { fatalError() } }

    @inlinable public var isAffine: Bool { get { fatalError() } }

    public mutating func invert() -> Bool { fatalError() }

    public func inverted() -> ProjectionTransform { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ProjectionTransform : Equatable {

    
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ProjectionTransform {

    public func concatenating(_ rhs: ProjectionTransform) -> ProjectionTransform { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ProjectionTransform : Sendable {
}

#endif
