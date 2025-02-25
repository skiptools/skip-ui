// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if false
/// No-op
func stubDynamicViewContent() -> some DynamicViewContent {
    //return never() // raises warning: “A call to a never-returning function”
    struct NeverDynamicViewContent : DynamicViewContent {
        typealias Body = Never
        var body: Body { fatalError() }
        typealias Data = [Never]
        var data: Data { fatalError() }
    }
    return NeverDynamicViewContent()
}

/// A type of view that generates views from an underlying collection of data.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol DynamicViewContent : View {

    /// The type of the underlying collection of data.
    associatedtype Data : Collection

    /// The collection of underlying data.
    var data: Self.Data { get }
}

extension Never : DynamicViewContent {
    public typealias Data = [Never]

    /// The collection of underlying data.
    public var data: Self.Data { fatalError() }
}
#endif
