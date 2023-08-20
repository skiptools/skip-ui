// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// The inset distances for the sides of a rectangle.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct EdgeInsets : Equatable {

    public var top: CGFloat { get { fatalError() } }

    public var leading: CGFloat { get { fatalError() } }

    public var bottom: CGFloat { get { fatalError() } }

    public var trailing: CGFloat { get { fatalError() } }

    @inlinable public init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) { fatalError() }

    @inlinable public init() { fatalError() }

    
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EdgeInsets : Sendable {
}


#endif
