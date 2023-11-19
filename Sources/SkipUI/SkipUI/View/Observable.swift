// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

extension View {
    @available(*, unavailable)
    public func onReceive<P>(_ publisher: P, perform action: @escaping (Any /* P.Output */) -> Void) -> some View /* where P : Publisher, P.Failure == Never */ {
        return self
    }
}

public struct SubscriptionView<PublisherType, Content> : View where /* PublisherType : Publisher, */ Content : View /*, PublisherType.Failure == Never */ {
    public let content: Content
    public let publisher: PublisherType
    public let action: (Any /* PublisherType.Output */) -> Void

    @available(*, unavailable)
    public init(content: Content, publisher: PublisherType, action: @escaping (Any /* PublisherType.Output */) -> Void) {
        self.content = content
        self.publisher = publisher
        self.action = action
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}
