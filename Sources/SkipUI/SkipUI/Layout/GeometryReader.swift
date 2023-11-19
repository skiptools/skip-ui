// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP


/// A container view that defines its content as a function of its own size and
/// coordinate space.
///
/// This view returns a flexible preferred size to its parent layout.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct GeometryReader<Content> : View where Content : View {

    public var content: (GeometryProxy) -> Content { get { fatalError() } }

    @inlinable public init(@ViewBuilder content: @escaping (GeometryProxy) -> Content) { fatalError() }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

#endif
