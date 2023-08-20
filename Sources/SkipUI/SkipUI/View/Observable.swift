// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import protocol Combine.Publisher

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds an action to perform when this view detects data emitted by the
    /// given publisher.
    ///
    /// - Parameters:
    ///   - publisher: The publisher to subscribe to.
    ///   - action: The action to perform when an event is emitted by
    ///     `publisher`. The event emitted by publisher is passed as a
    ///     parameter to `action`.
    ///
    /// - Returns: A view that triggers `action` when `publisher` emits an
    ///   event.
    @inlinable public func onReceive<P>(_ publisher: P, perform action: @escaping (P.Output) -> Void) -> some View where P : Publisher, P.Failure == Never { return stubView() }

}

/// A view that subscribes to a publisher with an action.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct SubscriptionView<PublisherType, Content> : View where PublisherType : Publisher, Content : View, PublisherType.Failure == Never {

    /// The content view.
    public var content: Content { get { fatalError() } }

    /// The `Publisher` that is being subscribed.
    public var publisher: PublisherType { get { fatalError() } }

    /// The `Action` executed when `publisher` emits an event.
    public var action: (PublisherType.Output) -> Void { get { fatalError() } }

    @inlinable public init(content: Content, publisher: PublisherType, action: @escaping (PublisherType.Output) -> Void) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

#endif
