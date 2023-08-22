// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP
/// No-op
@usableFromInline func stub<T>() -> T {
    fatalError("stub")
}

// SkipUI.kt:13:14 'Nothing' return type can't be specified with type alias
public typealias Nothing = Never


/// No-op
@usableFromInline func stubView() -> some View {
    return EmptyView()
}

/// No-op
@usableFromInline func never() -> Nothing {
    stub()
}

public typealias NeverView = Never
#endif

#if SKIP
public typealias CGFloat = Double

public struct CGSize: Hashable {
    public static let zero = CGSize()
    public var width = 0.0
    public var height = 0.0
}
#else

import struct CoreGraphics.CGFloat
public typealias CGFloat = CoreGraphics.CGFloat

import struct CoreGraphics.CGPoint
public typealias CGPoint = CoreGraphics.CGPoint

import struct CoreGraphics.CGSize
public typealias CGSize = CoreGraphics.CGSize

import struct CoreGraphics.CGRect
public typealias CGRect = CoreGraphics.CGRect


import enum CoreGraphics.CGLineCap
public typealias CGLineCap = CoreGraphics.CGLineCap

import enum CoreGraphics.CGLineJoin
public typealias CGLineJoin = CoreGraphics.CGLineJoin

import struct CoreGraphics.CGAffineTransform
public typealias CGAffineTransform = CoreGraphics.CGAffineTransform

import struct QuartzCore.CATransform3D
public typealias CATransform3D = QuartzCore.CATransform3D

import struct CoreGraphics.CGVector
public typealias CGVector = CoreGraphics.CGVector

import class CoreGraphics.CGColor
public typealias CGColor = CoreGraphics.CGColor

import class CoreGraphics.CGContext
public typealias CGContext = CoreGraphics.CGContext

import class CoreGraphics.CGImage
public typealias CGImage = CoreGraphics.CGImage

import class CoreGraphics.CGPath
public typealias CGPath = CoreGraphics.CGPath

import class CoreGraphics.CGMutablePath
public typealias CGMutablePath = CoreGraphics.CGMutablePath
#endif

