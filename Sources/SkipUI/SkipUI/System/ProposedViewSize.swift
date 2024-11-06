// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
#if canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
#endif
#endif

public struct ProposedViewSize : Equatable, Sendable {
    public var width: CGFloat?
    public var height: CGFloat?

    public static let zero: ProposedViewSize = ProposedViewSize(width: 0.0, height: 0.0)
    public static let unspecified: ProposedViewSize = ProposedViewSize(width: nil, height: nil)
    public static let infinity: ProposedViewSize = ProposedViewSize(width: .infinity, height: .infinity)

    public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }

    public init(_ size: CGSize) {
        self.init(width: size.width, height: size.height)
    }

    public func replacingUnspecifiedDimensions(by size: CGSize = CGSize(width: 10.0, height: 10.0)) -> CGSize {
        return CGSize(width: width == nil ? size.width : width!, height: height == nil ? size.height : height!)
    }
}
