// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A resolved coordinate space created by `CoordinateSpaceProtocol`.
///
/// You don't typically use `CoordinateSpace` directly. Instead, use the static
/// properties and functions of `CoordinateSpaceProtocol` such as `.global`,
/// `.local`, and `.named(_:)`.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum CoordinateSpace {

    /// The global coordinate space at the root of the view hierarchy.
    case global

    /// The local coordinate space of the current view.
    case local

    /// A named reference to a view's local coordinate space.
    case named(AnyHashable)
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CoordinateSpace {

    public var isGlobal: Bool { get { fatalError() } }

    public var isLocal: Bool { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CoordinateSpace : Equatable, Hashable {


}

/// A frame of reference within the layout system.
///
/// All geometric properties of a view, including size, position, and
/// transform, are defined within the local coordinate space of the view's
/// parent. These values can be converted into other coordinate spaces
/// by passing types conforming to this protocol into functions such as
/// `GeometryProxy.frame(in:)`.
///
/// For example, a named coordinate space allows you to convert the frame
/// of a view into the local coordinate space of an ancestor view by defining
/// a named coordinate space using the `coordinateSpace(_:)` modifier, then
/// passing that same named coordinate space into the `frame(in:)` function.
///
///     VStack {
///         GeometryReader { geometryProxy in
///             let distanceFromTop = geometryProxy.frame(in: "container").origin.y
///             Text("This view is \(distanceFromTop) points from the top of the VStack")
///         }
///         .padding()
///     }
///     .coordinateSpace(.named("container"))
///
/// You don't typically create types conforming to this protocol yourself.
/// Instead, use the system-provided `.global`, `.local`, and `.named(_:)`
/// implementations.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol CoordinateSpaceProtocol {

    /// The resolved coordinate space.
    var coordinateSpace: CoordinateSpace { get }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == NamedCoordinateSpace {

    /// The named coordinate space that is added by the system for the innermost
    /// containing scroll view that allows scrolling along the provided axis.
    public static func scrollView(axis: Axis) -> Self { fatalError() }

    /// The named coordinate space that is added by the system for the innermost
    /// containing scroll view.
    public static var scrollView: NamedCoordinateSpace { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == NamedCoordinateSpace {

    /// Creates a named coordinate space using the given value.
    ///
    /// Use the `coordinateSpace(_:)` modifier to assign a name to the local
    /// coordinate space of a  parent view. Child views can then refer to that
    /// coordinate space using `.named(_:)`.
    ///
    /// - Parameter name: A unique value that identifies the coordinate space.
    ///
    /// - Returns: A named coordinate space identified by the given value.
    public static func named(_ name: some Hashable) -> NamedCoordinateSpace { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == LocalCoordinateSpace {

    /// The local coordinate space of the current view.
    public static var local: LocalCoordinateSpace { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == GlobalCoordinateSpace {

    /// The global coordinate space at the root of the view hierarchy.
    public static var global: GlobalCoordinateSpace { get { fatalError() } }
}

#endif
