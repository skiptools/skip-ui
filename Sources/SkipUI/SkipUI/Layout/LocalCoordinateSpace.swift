// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// The local coordinate space of the current view.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct LocalCoordinateSpace : CoordinateSpaceProtocol {

    public init() { fatalError() }

    /// The resolved coordinate space.
    public var coordinateSpace: CoordinateSpace { get { fatalError() } }
}

#endif