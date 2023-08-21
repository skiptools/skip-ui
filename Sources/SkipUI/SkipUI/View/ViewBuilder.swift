// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// Note: @ViewBuilder support is built into the Skip transpiler.
// This file does not need SKIP support. This stub is maintained
// to allow this package to compile in Swift.

#if !SKIP

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@resultBuilder public struct ViewBuilder {
    public static func buildBlock<Content: View >(_ content: Content) -> Content{
        fatalError()
    }
}

#endif
