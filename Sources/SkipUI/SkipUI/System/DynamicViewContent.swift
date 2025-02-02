// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
