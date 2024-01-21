// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize

/// A proxy for access to the size and coordinate space (for anchor resolution)
/// of the container view.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct GeometryProxy {

    /// The size of the container view.
    public var size: CGSize { get { fatalError() } }

    /// Resolves the value of `anchor` to the container view.
    public subscript<T>(anchor: Anchor<T>) -> T { get { fatalError() } }

    /// The safe area inset of the container view.
    public var safeAreaInsets: EdgeInsets { get { fatalError() } }

    /// Returns the container view's bounds rectangle, converted to a defined
    /// coordinate space.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    public func frame(in coordinateSpace: CoordinateSpace) -> CGRect { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension GeometryProxy {

    /// Returns the given coordinate space's bounds rectangle, converted to the
    /// local coordinate space.
    public func bounds(of coordinateSpace: NamedCoordinateSpace) -> CGRect? { fatalError() }

    /// Returns the container view's bounds rectangle, converted to a defined
    /// coordinate space.
    public func frame(in coordinateSpace: some CoordinateSpaceProtocol) -> CGRect { fatalError() }
}

#endif
