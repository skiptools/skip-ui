// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// An opaque value derived from an anchor source and a particular view.
///
/// You can convert the anchor to a `Value` in the coordinate space of a target
/// view by using a ``GeometryProxy`` to specify the target view.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Anchor<Value> {

    /// A type-erased geometry value that produces an anchored value of a given
    /// type.
    ///
    /// SkipUI passes anchored geometry values around the view tree via
    /// preference keys. It then converts them back into the local coordinate
    /// space using a ``GeometryProxy`` value.
    @frozen public struct Source {
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Anchor : Sendable where Value : Sendable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Anchor : Equatable where Value : Equatable {

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Anchor : Hashable where Value : Hashable {


}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Anchor.Source where Value == CGRect {

    /// Returns an anchor source rect defined by `r` in the current view.
    public static func rect(_ r: CGRect) -> Anchor<Value>.Source { fatalError() }

    /// An anchor source rect defined as the entire bounding rect of the current
    /// view.
    public static var bounds: Anchor<CGRect>.Source { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Anchor.Source where Value == CGPoint {

    public static func point(_ p: CGPoint) -> Anchor<Value>.Source { fatalError() }

    public static func unitPoint(_ p: UnitPoint) -> Anchor<Value>.Source { fatalError() }

    public static var topLeading: Anchor<CGPoint>.Source { get { fatalError() } }

    public static var top: Anchor<CGPoint>.Source { get { fatalError() } }

    public static var topTrailing: Anchor<CGPoint>.Source { get { fatalError() } }

    public static var leading: Anchor<CGPoint>.Source { get { fatalError() } }

    public static var center: Anchor<CGPoint>.Source { get { fatalError() } }

    public static var trailing: Anchor<CGPoint>.Source { get { fatalError() } }

    public static var bottomLeading: Anchor<CGPoint>.Source { get { fatalError() } }

    public static var bottom: Anchor<CGPoint>.Source { get { fatalError() } }

    public static var bottomTrailing: Anchor<CGPoint>.Source { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Anchor.Source : Sendable where Value : Sendable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Anchor.Source {

    public init<T>(_ array: [Anchor<T>.Source]) where Value == [T] { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Anchor.Source {

    public init<T>(_ anchor: Anchor<T>.Source?) where Value == T? { fatalError() }
}

#endif
