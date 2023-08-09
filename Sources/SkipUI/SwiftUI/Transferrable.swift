// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import CoreTransferable
import struct UniformTypeIdentifiers.UTType


/// An interface that you implement to interact with a drop operation in a view
/// modified to accept drops.
///
/// The ``DropDelegate`` protocol provides a comprehensive and flexible way to
/// interact with a drop operation. Specify a drop delegate when you modify a
/// view to accept drops with the ``View/onDrop(of:delegate:)-6lin8`` method.
///
/// Alternatively, for simple drop cases that don't require the full
/// functionality of a drop delegate, you can modify a view to accept drops
/// using the ``View/onDrop(of:isTargeted:perform:)-f15m`` or the
/// ``View/onDrop(of:isTargeted:perform:)-982eu`` method. These methods handle the
/// drop using a closure you provide as part of the modifier.
@available(iOS 13.4, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@MainActor public protocol DropDelegate {

    /// Tells the delegate that a drop containing items conforming to one of the
    /// expected types entered a view that accepts drops.
    ///
    /// Specify the expected types when you apply the drop modifier to the view.
    /// The default implementation returns `true`.
    @MainActor func validateDrop(info: DropInfo) -> Bool

    /// Tells the delegate it can request the item provider data from the given
    /// information.
    ///
    /// Incorporate the received data into your app's data model as appropriate.
    /// - Returns: A Boolean that is `true` if the drop was successful, `false`
    ///   otherwise.
    @MainActor func performDrop(info: DropInfo) -> Bool

    /// Tells the delegate a validated drop has entered the modified view.
    ///
    /// The default implementation does nothing.
    @MainActor func dropEntered(info: DropInfo)

    /// Tells the delegate that a validated drop moved inside the modified view.
    ///
    /// Use this method to return a drop proposal containing the operation the
    /// delegate intends to perform at the drop ``DropInfo/location``. The
    /// default implementation of this method returns `nil`, which tells the
    /// drop to use the last valid returned value or else
    /// ``DropOperation/copy``.
    @MainActor func dropUpdated(info: DropInfo) -> DropProposal?

    /// Tells the delegate a validated drop operation has exited the modified
    /// view.
    ///
    /// The default implementation does nothing.
    @MainActor func dropExited(info: DropInfo)
}

@available(iOS 13.4, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DropDelegate {

    /// Tells the delegate that a drop containing items conforming to one of the
    /// expected types entered a view that accepts drops.
    ///
    /// Specify the expected types when you apply the drop modifier to the view.
    /// The default implementation returns `true`.
    @MainActor public func validateDrop(info: DropInfo) -> Bool { fatalError() }

    /// Tells the delegate a validated drop has entered the modified view.
    ///
    /// The default implementation does nothing.
    @MainActor public func dropEntered(info: DropInfo) { fatalError() }

    /// Tells the delegate that a validated drop moved inside the modified view.
    ///
    /// Use this method to return a drop proposal containing the operation the
    /// delegate intends to perform at the drop ``DropInfo/location``. The
    /// default implementation of this method returns `nil`, which tells the
    /// drop to use the last valid returned value or else
    /// ``DropOperation/copy``.
    @MainActor public func dropUpdated(info: DropInfo) -> DropProposal? { fatalError() }

    /// Tells the delegate a validated drop operation has exited the modified
    /// view.
    ///
    /// The default implementation does nothing.
    @MainActor public func dropExited(info: DropInfo) { fatalError() }
}

/// The current state of a drop.
@available(iOS 13.4, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DropInfo {

    /// The location of the drag in the coordinate space of the drop view.
    public var location: CGPoint { get { fatalError() } }

    /// Indicates whether at least one item conforms to at least one of the
    /// specified uniform type identifiers.
    ///
    /// - Parameter contentTypes: The uniform type identifiers to query for.
    /// - Returns: Whether at least one item conforms to one of `contentTypes`.
    @available(iOS 14.0, macOS 11.0, *)
    public func hasItemsConforming(to contentTypes: [UTType]) -> Bool { fatalError() }

    /// Finds item providers that conform to at least one of the specified
    /// uniform type identifiers.
    ///
    /// This function is only valid during the `performDrop()` action.
    ///
    /// - Parameter contentTypes: The uniform type identifiers to query for.
    /// - Returns: The item providers that conforms to `contentTypes`.
    @available(iOS 14.0, macOS 11.0, *)
    public func itemProviders(for contentTypes: [UTType]) -> [NSItemProvider] { fatalError() }
}

@available(iOS, introduced: 13.4, deprecated: 100000.0, message: "Provide `UTType`s as the `types` instead.")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Provide `UTType`s as the `types` instead.")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Provide `UTType`s as the `types` instead.")
extension DropInfo {

    /// Returns whether at least one item conforms to at least one of the
    /// specified uniform type identifiers.
    public func hasItemsConforming(to types: [String]) -> Bool { fatalError() }

    /// Returns an Array of items that each conform to at least one of the
    /// specified uniform type identifiers.
    ///
    /// This function is only valid during the performDrop() action.
    public func itemProviders(for types: [String]) -> [NSItemProvider] { fatalError() }
}

/// Operation types that determine how a drag and drop session resolves when the
/// user drops a drag item.
@available(iOS 13.4, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public enum DropOperation : Sendable {

    /// Cancel the drag operation and transfer no data.
    case cancel

    /// The drop activity is not allowed at this time or location.
    case forbidden

    /// Copy the data to the modified view.
    case copy

    /// Move the data represented by the drag items instead of copying it.
    case move

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: DropOperation, b: DropOperation) -> Bool { fatalError() }

    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: In your implementation of `hash(into:)`,
    ///   don't call `finalize()` on the `hasher` instance provided,
    ///   or replace it with a different instance.
    ///   Doing so may become a compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher) { fatalError() }

    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    ///
    /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
    ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
    ///   The compiler provides an implementation for `hashValue` for you.
    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 13.4, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DropOperation : Equatable {
}

@available(iOS 13.4, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DropOperation : Hashable {
}

/// The behavior of a drop.
@available(iOS 13.4, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DropProposal : Sendable {

    /// The drop operation that the drop proposes to perform.
    public let operation: DropOperation = { fatalError() }()

    public init(operation: DropOperation) { fatalError() }
}


/// A view that controls a sharing presentation.
///
/// People tap or click on a share link to present a share interface. The link
/// typically uses a system-standard appearance; you only need to supply the
/// content to share:
///
///     ShareLink(item: URL(string: "https://example.org/")!)
///
/// You can control the appearance of the link by providing view content.
/// For example, you can use a ``Label`` to display a
/// link with a custom icon:
///
///     ShareLink(item: URL(string: "https://example.org/")!) {
///         Label("Share", image: "MyCustomShareIcon")
///     }
///
/// If you only wish to customize the link's title, you can use one of the
/// convenience initializers that takes a string and creates a `Label` for you:
///
///     ShareLink("Share URL", item: URL(string: "https://example.org/")!)
///
/// The link can share any content that is
/// .
/// Many framework types, like
/// ,
/// already conform to this protocol. You can also make your own types
/// transferable.
///
/// For example, you can use
/// 
/// to resolve your own type to a framework type:
///
///     struct Photo: Transferable {
///         static var transferRepresentation: some TransferRepresentation {
///             ProxyRepresentation(\.image)
///         }
///
///         public var image: Image { get { fatalError() } }
///         public var caption: String { get { fatalError() } }
///     }
///
///     struct PhotoView: View {
///         let photo: Photo
///
///         var body: View {
///             photo.image
///                 .toolbar {
///                     ShareLink(
///                         item: photo,
///                         preview: SharePreview(
///                             photo.caption,
///                             image: photo.image))
///                 }
///         }
///     }
///
/// Sometimes the content that your app shares isn't immediately available. You
/// can use
/// 
/// or
/// 
/// when you need an asynchronous operation, like a network request, to
/// retrieve and prepare the content.
///
/// A `Transferable` type also lets you provide multiple content types for a
/// single shareable item. The share interface shows relevant sharing services
/// based on the types that you provide.
///
/// The previous example also shows how you provide a preview of your content
/// to show in the share interface.
///
/// A preview isn't required when sharing URLs or non-attributed strings. When
/// sharing these types of content, the system can automatically determine a
/// preview.
///
/// You can provide a preview even when it's optional. For instance, when
/// sharing URLs, the automatic preview first shows a placeholder link icon
/// alongside the base URL while fetching the link's metadata over the network.
/// The preview updates once the link's icon and title become available. If you
/// provide a preview instead, the preview appears immediately
/// without fetching data over the network.
///
/// Some share activities support subject and message fields. You can
/// pre-populate these fields with the `subject` and `message` parameters:
///
///     ShareLink(
///         item: photo,
///         subject: Text("Cool Photo"),
///         message: Text("Check it out!")
///         preview: SharePreview(
///             photo.caption,
///             image: photo.image))
///
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public struct ShareLink<Data, PreviewImage, PreviewIcon, Label> : View where Data : RandomAccessCollection, PreviewImage : Transferable, PreviewIcon : Transferable, Label : View, Data.Element : Transferable {

    /// Creates an instance that presents the share interface.
    ///
    /// - Parameters:
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - preview: A closure that returns a representation of each item to
    ///     render in a preview.
    ///     - label: A view builder that produces a label that describes the
    ///     share action.
    public init(items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>, @ViewBuilder label: () -> Label) { fatalError() }

    /// The content and behavior of the view.
    ///
    /// When you implement a custom view, you must implement a computed
    /// `body` property to provide the content for your view. Return a view
    /// that's composed of built-in views that SkipUI provides, plus other
    /// composite views that you've already defined:
    ///
    ///     struct MyView: View {
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///         }
    ///     }
    ///
    /// For more information about composing views and a view hierarchy,
    /// see <doc:Declaring-a-Custom-View>.
    @MainActor public var body: some View { get { return never() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
//    public typealias Body = some View
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ShareLink {

    /// Creates an instance that presents the share interface.
    ///
    /// - Parameters:
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - preview: A representation of the item to render in a preview.
    ///     - label: A view builder that produces a label that describes the
    ///     share action.
    public init<I>(item: I, subject: Text? = nil, message: Text? = nil, preview: SharePreview<PreviewImage, PreviewIcon>, @ViewBuilder label: () -> Label) where Data == CollectionOfOne<I>, I : Transferable { fatalError() }
}


@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Data.Element == URL {

    /// Creates an instance that presents the share interface.
    ///
    /// - Parameters:
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - label: A view builder that produces a label that describes the
    ///     share action.
    public init(items: Data, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Data.Element == String {

    /// Creates an instance that presents the share interface.
    ///
    /// - Parameters:
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - label: A view builder that produces a label that describes the
    ///     share action.
    public init(items: Data, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ShareLink where PreviewImage == Never, PreviewIcon == Never {

    /// Creates an instance that presents the share interface.
    ///
    /// - Parameters:
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - label: A view builder that produces a label that describes the
    ///     share action.
    public init(item: URL, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) where Data == CollectionOfOne<URL> { fatalError() }

    /// Creates an instance that presents the share interface.
    ///
    /// - Parameters:
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - label: A view builder that produces a label that describes the
    ///     share action.
    public init(item: String, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) where Data == CollectionOfOne<String> { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ShareLink where Label == DefaultShareLinkLabel {

    /// Creates an instance that presents the share interface.
    ///
    /// Use this initializer when you want the system-standard appearance for
    /// `ShareLink`.
    ///
    /// - Parameters:
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - preview: A closure that returns a representation of each item to
    ///     render in a preview.
    public init(items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>) { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - titleKey: A key identifying the title of the share action.
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - preview: A closure that returns a representation of each item to
    ///     render in a preview.
    public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>) { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - items: The item to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - preview: A closure that returns a representation of each item to
    ///     render in a preview.
    public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>) where S : StringProtocol { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - preview: A closure that returns a representation of each item to
    ///     render in a preview.
    public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ShareLink where Label == DefaultShareLinkLabel {

    /// Creates an instance that presents the share interface.
    ///
    /// Use this initializer when you want the system-standard appearance for
    /// `ShareLink`.
    ///
    /// - Parameters:
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - preview: A representation of the item to render in a preview.
    public init<I>(item: I, subject: Text? = nil, message: Text? = nil, preview: SharePreview<PreviewImage, PreviewIcon>) where Data == CollectionOfOne<I>, I : Transferable { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - titleKey: A key identifying the title of the share action.
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - preview: A representation of the item to render in a preview.
    public init<I>(_ titleKey: LocalizedStringKey, item: I, subject: Text? = nil, message: Text? = nil, preview: SharePreview<PreviewImage, PreviewIcon>) where Data == CollectionOfOne<I>, I : Transferable { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - preview: A representation of the item to render in a preview.
    public init<S, I>(_ title: S, item: I, subject: Text? = nil, message: Text? = nil, preview: SharePreview<PreviewImage, PreviewIcon>) where Data == CollectionOfOne<I>, S : StringProtocol, I : Transferable { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    ///     - preview: A representation of the item to render in a preview.
    public init<I>(_ title: Text, item: I, subject: Text? = nil, message: Text? = nil, preview: SharePreview<PreviewImage, PreviewIcon>) where Data == CollectionOfOne<I>, I : Transferable { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Label == DefaultShareLinkLabel, Data.Element == URL {

    /// Creates an instance that presents the share interface.
    ///
    /// Use this initializer when you want the system-standard appearance for
    /// `ShareLink`.
    ///
    /// - Parameters:
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - titleKey: A key identifying the title of the share action.
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - items: The item to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil) where S : StringProtocol { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Label == DefaultShareLinkLabel, Data.Element == String {

    /// Creates an instance that presents the share interface.
    ///
    /// Use this initializer when you want the system-standard appearance for
    /// `ShareLink`.
    ///
    /// - Parameters:
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - titleKey: A key identifying the title of the share action.
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - items: The item to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil) where S : StringProtocol { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - items: The items to share.
    ///     - subject: A title for the items to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the items to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Label == DefaultShareLinkLabel {

    /// Creates an instance that presents the share interface.
    ///
    /// Use this initializer when you want the system-standard appearance for
    /// `ShareLink`.
    ///
    /// - Parameters:
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL> { fatalError() }

    /// Creates an instance that presents the share interface.
    ///
    /// Use this initializer when you want the system-standard appearance for
    /// `ShareLink`.
    ///
    /// - Parameters:
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String> { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - titleKey: A key identifying the title of the share action.
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(_ titleKey: LocalizedStringKey, item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL> { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - titleKey: A key identifying the title of the share action.
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(_ titleKey: LocalizedStringKey, item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String> { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init<S>(_ title: S, item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL>, S : StringProtocol { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init<S>(_ title: S, item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String>, S : StringProtocol { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(_ title: Text, item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL> { fatalError() }

    /// Creates an instance, with a custom label, that presents the share
    /// interface.
    ///
    /// - Parameters:
    ///     - title: The title of the share action.
    ///     - item: The item to share.
    ///     - subject: A title for the item to show when sharing to activities
    ///     that support a subject field.
    ///     - message: A description of the item to show when sharing to
    ///     activities that support a message field. Activities may
    ///     support attributed text or HTML strings.
    public init(_ title: Text, item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String> { fatalError() }
}

/// A representation of a type to display in a share preview.
///
/// Use this type when sharing content that the system can't preview automatically:
///
///     struct Photo: Transferable {
///         static var transferRepresentation: some TransferRepresentation {
///             ProxyRepresentation(\.image)
///         }
///
///         public var image: Image { get { fatalError() } }
///         public var caption: String { get { fatalError() } }
///     }
///
///     struct PhotoView: View {
///         let photo: Photo
///
///         var body: View {
///             photo.image
///                 .toolbar {
///                     ShareLink(
///                         item: photo,
///                         preview: SharePreview(
///                             photo.caption,
///                             image: photo.image))
///                 }
///         }
///     }
///
/// You can also provide a preview to speed up the sharing process. In the
/// following example the preview appears immediately; if you omit the preview instead,
/// the system fetches the link's metadata over the network:
///
///     ShareLink(
///         item: URL(string: "https://example.org/")!,
///         preview: SharePreview(
///             "SkipUI",
///             image: Image("SkipUI"))
///
/// You can provide unique previews for each item in a collection of items
/// that a `ShareLink` links to:
///
///     ShareLink(items: photos) { photo in
///         SharePreview(photo.caption, image: photo.image)
///     }
///
/// The share interface decides how to combine those previews.
///
/// Each preview specifies text and images that describe an item of the type.
/// The preview's `image` parameter is typically a full-size representation of the item.
/// For instance, if the system prepares a preview for a link to a webpage,
/// the image might be the hero image on that webpage.
///
/// The preview's `icon` parameter is typically a thumbnail-sized representation
/// of the source of the item. For instance, if the system prepares a preview
/// for a link to a webpage, the icon might be an image that represents
/// the website overall.
///
/// The system may reuse a single preview representation for multiple previews,
/// and show different images in each context.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public struct SharePreview<Image, Icon> where Image : Transferable, Icon : Transferable {

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - titleKey: A key identifying a title to show in a preview.
    ///     - image: An image to show in a preview.
    ///     - icon: An icon to show in a preview.
    public init(_ titleKey: LocalizedStringKey, image: Image, icon: Icon) { fatalError() }

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - title: A title to show in a preview.
    ///     - image: An image to show in a preview.
    ///     - icon: An icon to show in a preview.
    public init<S>(_ title: S, image: Image, icon: Icon) where S : StringProtocol { fatalError() }

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - title: A title to show in a preview.
    ///     - image: An image to show in a preview.
    ///     - icon: An icon to show in a preview.
    public init(_ title: Text, image: Image, icon: Icon) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension SharePreview where Image == Never {

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - titleKey: A key identifying a title to show in a preview.
    ///     - icon: An icon to show in a preview.
    public init(_ titleKey: LocalizedStringKey, icon: Icon) { fatalError() }

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - title: A title to show in a preview.
    ///     - icon: An icon to show in a preview.
    public init<S>(_ title: S, icon: Icon) where S : StringProtocol { fatalError() }

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - title: A title to show in a preview.
    ///     - icon: An icon to show in a preview.
    public init(_ title: Text, icon: Icon) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension SharePreview where Icon == Never {

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - titleKey: A key identifying a title to show in a preview.
    ///     - image: An image to show in a preview.
    public init(_ titleKey: LocalizedStringKey, image: Image) { fatalError() }

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - title: A title to show in a preview.
    ///     - image: An image to show in a preview.
    public init<S>(_ title: S, image: Image) where S : StringProtocol { fatalError() }

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - title: A title to show in a preview.
    ///     - image: An image to show in a preview.
    public init(_ title: Text, image: Image) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension SharePreview where Image == Never, Icon == Never {

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - titleKey: A key identifying a title to show in a preview.
    public init(_ titleKey: LocalizedStringKey) { fatalError() }

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - title: A title to show in a preview.
    public init<S>(_ title: S) where S : StringProtocol { fatalError() }

    /// Creates a preview representation.
    ///
    /// - Parameters:
    ///     - title: A title to show in a preview.
    public init(_ title: Text) { fatalError() }
}

extension DynamicViewContent {

    /// Sets the insert action for the dynamic view.
    ///
    ///     struct Profile: Identifiable {
    ///         let givenName: String
    ///         let familyName: String
    ///         let id = UUID()
    ///     }
    ///
    ///     @State private var profiles: [Profile] = [
    ///         Person(givenName: "Juan", familyName: "Chavez"),
    ///         Person(givenName: "Mei", familyName: "Chen"),
    ///         Person(givenName: "Tom", familyName: "Clark"),
    ///         Person(givenName: "Gita", familyName: "Kumar")
    ///     ]
    ///
    ///     var body: some View {
    ///         List {
    ///             ForEach(profiles) { profile in
    ///                 Text(profile.givenName)
    ///             }
    ///             .dropDestination(for: Profile.self) { receivedProfiles, offset in
    ///                 profiles.insert(contentsOf: receivedProfiles, at: offset)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - payloadType: Type of the models that are dropped.
    ///   - action: A closure that SkipUI invokes when elements are added to
    ///     the view. The closure takes two arguments: The first argument is the
    ///     offset relative to the dynamic view's underlying collection of data.
    ///     The second argument is an array of `Transferable` items that
    ///     represents the data that you want to insert.
    ///
    /// - Returns: A view that calls `action` when elements are inserted into
    ///   the original view.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func dropDestination<T>(for payloadType: T.Type = T.self, action: @escaping ([T], Int) -> Void) -> some DynamicViewContent where T : Transferable { return never() }

}

/// A system button that reads items from the pasteboard and delivers it to a
/// closure.
///
/// Use a paste button when you want to provide a button for pasting items from
/// the system pasteboard into your app. The system provides a button
/// appearance and label appropriate to the current environment. However, you
/// can use view modifiers like ``View/buttonBorderShape(_:)``,
/// ``View/labelStyle(_:)``, and ``View/tint(_:)-93mfq`` to customize the button
/// in some contexts.
///
/// You declare what type of items your app will accept; use a type that
/// conforms to the
/// 
/// protocol. When the user taps or clicks the button, your closure receives the
/// pasteboard items in the specified type.
///
/// In the following example, a paste button declares that it accepts a string.
/// When the user taps or clicks the button, the sample's closure receives an
/// array of strings and sets the first as the value of `pastedText`, which
/// updates a nearby ``Text`` view.
///
///     @State private var pastedText: String = ""
///
///     var body: some View {
///         HStack {
///             PasteButton(payloadType: String.self) { strings in
///                 pastedText = strings[0]
///             }
///             Divider()
///             Text(pastedText)
///             Spacer()
///         }
///     }
///
/// ![macOS window titled PasteButton Demo showing (from left to right) a button
/// labeled Paste, a vertical divider, and some pasted
/// text.](SkipUI-PasteButton-pastedText.png)
///
/// A paste button automatically validates and invalidates based on changes to
/// the pasteboard on iOS, but not on macOS.
@available(iOS 16.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PasteButton : View {

    /// Creates a Paste button that accepts specific types of data from the
    /// pasteboard.
    ///
    /// Set the contents of `supportedContentTypes` in order of your app's
    /// preference for its supported types. The Paste button takes the
    /// most-preferred type that the pasteboard source supports and delivers
    /// this to the `payloadAction` closure.
    ///
    /// - Parameters:
    ///   - supportedContentTypes: The exact uniform type identifiers supported
    ///     by the button. If the pasteboard doesn't contain any of the
    ///     supported types, the button becomes disabled.
    ///   - payloadAction: The handler to call when the user clicks the Paste
    ///     button and the pasteboard has items that conform to
    ///     `supportedContentTypes`. This closure receives an array of
    ///     item providers that you use to inspect and load the pasteboard data.
    @available(iOS 16.0, macOS 11.0, *)
    public init(supportedContentTypes: [UTType], payloadAction: @escaping ([NSItemProvider]) -> Void) { fatalError() }

    /// Creates an instance that accepts values of the specified type.
    /// - Parameters:
    ///   - type: The type that you want to paste via the `PasteButton`.
    ///   - onPaste: The handler to call on trigger of the button with at least
    ///     one item of the specified `Transferable` type from the pasteboard.
    @available(iOS 16.0, macOS 13.0, *)
    public init<T>(payloadType: T.Type, onPaste: @escaping ([T]) -> Void) where T : Transferable { fatalError() }

    /// The content and behavior of the view.
    ///
    /// When you implement a custom view, you must implement a computed
    /// `body` property to provide the content for your view. Return a view
    /// that's composed of built-in views that SkipUI provides, plus other
    /// composite views that you've already defined:
    ///
    ///     struct MyView: View {
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///         }
    ///     }
    ///
    /// For more information about composing views and a view hierarchy,
    /// see <doc:Declaring-a-Custom-View>.
    @MainActor public var body: some View { get { return never() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
//    public typealias Body = some View
}


@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Activates this view as the source of a drag and drop operation.
    ///
    /// Applying the `draggable(_:)` modifier adds the appropriate gestures for
    /// drag and drop to this view. When a drag operation begins, a rendering of
    /// this view is generated and used as the preview image.
    ///
    /// - Parameter payload: A closure that returns a single
    /// instance or a value conforming to  that
    /// represents the draggable data from this view.
    ///
    /// - Returns: A view that activates this view as the source of a drag and
    ///   drop operation, beginning with user gesture input.
    public func draggable<T>(_ payload: @autoclosure @escaping () -> T) -> some View where T : Transferable { return never() }


    /// Activates this view as the source of a drag and drop operation.
    ///
    /// Applying the `draggable(_:preview:)` modifier adds the appropriate gestures
    /// for drag and drop to this view. When a drag operation begins,
    /// a rendering of `preview` is generated and used as the preview image.
    ///
    ///     var title: String
    ///     var body: some View {
    ///         Color.pink
    ///             .frame(width: 400, height: 400)
    ///             .draggable(title) {
    ///                  Text("Drop me")
    ///              }
    ///     }
    ///
    /// - Parameter payload: A closure that returns a single
    /// class instance or a value conforming to `Transferable` that
    /// represents the draggable data from this view.
    /// - Parameter preview: A ``View`` to use as the source for the dragging
    /// preview, once the drag operation has begun. The preview is centered over
    /// the source view.
    ///
    /// - Returns: A view that activates this view as the source of a drag and
    ///   drop operation, beginning with user gesture input.
    public func draggable<V, T>(_ payload: @autoclosure @escaping () -> T, @ViewBuilder preview: () -> V) -> some View where V : View, T : Transferable { return never() }

}

extension View {

    /// Configures the view's document for purposes of navigation.
    ///
    /// In iOS, iPadOS, this populates the title menu with a header
    /// previewing the document. In macOS, this populates a proxy icon.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation document modifiers.
    ///
    /// - Parameters:
    ///   - document: The transferable content associated to the
    ///     navigation title.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    public func navigationDocument<D>(_ document: D) -> some View where D : Transferable { return never() }


    /// Configures the view's document for purposes of navigation.
    ///
    /// In iOS, iPadOS, this populates the title menu with a header
    /// previewing the document. In macOS, this populates a proxy icon.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation document modifiers.
    ///
    /// - Parameters:
    ///   - document: The transferable content associated to the
    ///     navigation title.
    ///   - preview: The preview of the document to use when sharing.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
    @available(tvOS, unavailable)
    public func navigationDocument<D>(_ document: D, preview: SharePreview<Never, Never>) -> some View where D : Transferable { return never() }


    /// Configures the view's document for purposes of navigation.
    ///
    /// In iOS, iPadOS, this populates the title menu with a header
    /// previewing the document. In macOS, this populates a proxy icon.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation document modifiers.
    ///
    /// - Parameters:
    ///   - document: The transferable content associated to the
    ///     navigation title.
    ///   - preview: The preview of the document to use when sharing.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
    @available(tvOS, unavailable)
    public func navigationDocument<D, I>(_ document: D, preview: SharePreview<Never, I>) -> some View where D : Transferable, I : Transferable { return never() }


    /// Configures the view's document for purposes of navigation.
    ///
    /// In iOS, iPadOS, this populates the title menu with a header
    /// previewing the document. In macOS, this populates a proxy icon.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation document modifiers.
    ///
    /// - Parameters:
    ///   - document: The transferable content associated to the
    ///     navigation title.
    ///   - preview: The preview of the document to use when sharing.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
    @available(tvOS, unavailable)
    public func navigationDocument<D, I>(_ document: D, preview: SharePreview<I, Never>) -> some View where D : Transferable, I : Transferable { return never() }


    /// Configures the view's document for purposes of navigation.
    ///
    /// In iOS, iPadOS, this populates the title menu with a header
    /// previewing the document. In macOS, this populates a proxy icon.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation document modifiers.
    ///
    /// - Parameters:
    ///   - document: The transferable content associated to the
    ///     navigation title.
    ///   - preview: The preview of the document to use when sharing.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
    @available(tvOS, unavailable)
    public func navigationDocument<D, I1, I2>(_ document: D, preview: SharePreview<I1, I2>) -> some View where D : Transferable, I1 : Transferable, I2 : Transferable { return never() }

}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Presents a system interface allowing the user to export
    /// a `Transferable` item to file on disk.
    ///
    /// In order for the interface to appear `isPresented` must be set to `true`.
    /// When the operation is finished,
    /// `isPresented` will be set to `false` before `onCompletion` is called. If
    /// the user cancels the operation, `isPresented` will be set to `false` and
    /// `onCompletion` will not be called.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - item: The item to be saved on disk.
    ///   - contentTypes: The optional content types to use for the exported file.
    ///     If empty, SkipUI uses the content types from the `transferRepresentation`
    ///     property provided for `Transferable` conformance.
    ///   - onCompletion: A callback that will be invoked when the operation
    ///     has succeeded or failed.
    ///   - onCancellation: A callback that will be invoked
    ///     if the operation was cancelled.
    public func fileExporter<T>(isPresented: Binding<Bool>, item: T?, contentTypes: [UTType] = [], defaultFilename: String? = nil, onCompletion: @escaping (Result<URL, Error>) -> Void, onCancellation: @escaping () -> Void = { }) -> some View where T : Transferable { return never() }


    /// Presents a system interface allowing the user to export
    /// a collection of items to files on disk.
    ///
    /// In order for the interface to appear `isPresented` must be set to `true`.
    /// When the operation is finished,
    /// `isPresented` will be set to `false` before `onCompletion` is called. If
    /// the user cancels the operation, `isPresented` will be set to `false` and
    /// `onCompletion` will not be called.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - items: Collection of values to be saved on disk.
    ///   - contentTypes: The content types to use for the exported file.
    ///     If empty, SkipUI uses the content types from the `transferRepresentation`
    ///     property provided for `Transferable` conformance.
    ///   - allowsOtherContentTypes: A Boolean value that indicates if the users
    ///     are allowed to save the files with a different file extension than
    ///     specified by the `contentType` property.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     has succeeded or failed.
    ///   - onCancellation: A callback that will be invoked
    ///     if the operation was cancelled.
    public func fileExporter<C, T>(isPresented: Binding<Bool>, items: C, contentTypes: [UTType] = [], onCompletion: @escaping (Result<[URL], Error>) -> Void, onCancellation: @escaping () -> Void = { }) -> some View where C : Collection, T : Transferable, T == C.Element { return never() }


    /// Presents a system interface for allowing the user to export a
    /// `FileDocument` to a file on disk.
    ///
    /// In order for the interface to appear, `isPresented` must be `true`. When
    /// the operation is finished, `isPresented` will be set to `false` before
    /// `onCompletion` is called. If the user cancels the operation,
    /// `isPresented` will be set to `false` and `onCancellation` will be
    /// called.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - document: The in-memory document to export.
    ///   - contentTypes: The list of supported content types which can
    ///     be exported. If not provided, `FileDocument.writableContentTypes`
    ///     are used.
    ///   - defaultFilename: If provided, the default name to use
    ///     for the exported file, which will the user will have
    ///     an opportunity to edit prior to the export.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed. The `result` indicates whether
    ///     the operation succeeded or failed.
    ///   - onCancellation: A callback that will be invoked
    ///     if the user cancels the operation.
    public func fileExporter<D>(isPresented: Binding<Bool>, document: D?, contentTypes: [UTType] = [], defaultFilename: String? = nil, onCompletion: @escaping (Result<URL, Error>) -> Void, onCancellation: @escaping () -> Void = {}) -> some View where D : FileDocument { return never() }


    /// Presents a system dialog for allowing the user to export a
    /// `ReferenceFileDocument` to a file on disk.
    ///
    /// In order for the dialog to appear, `isPresented` must be `true`. When
    /// the operation is finished, `isPresented` will be set to `false` before
    /// `onCompletion` is called. If the user cancels the operation,
    /// `isPresented` will be set to `false` and `onCancellation` will be
    /// called.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the dialog should be shown.
    ///   - document: The in-memory document to export.
    ///   - contentTypes: The list of supported content types which can
    ///     be exported. If not provided, `ReferenceFileDocument.writableContentTypes`
    ///     are used.
    ///   - defaultFilename: If provided, the default name to use
    ///     for the exported file, which will the user will have
    ///     an opportunity to edit prior to the export.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed. The `result` indicates whether
    ///     the operation succeeded or failed.
    ///   - onCancellation: A callback that will be invoked
    ///     if the user cancels the operation.
    public func fileExporter<D>(isPresented: Binding<Bool>, document: D?, contentTypes: [UTType] = [], defaultFilename: String? = nil, onCompletion: @escaping (Result<URL, Error>) -> Void, onCancellation: @escaping () -> Void = {}) -> some View where D : ReferenceFileDocument { return never() }


    /// Presents a system dialog for allowing the user to export a
    /// collection of documents that conform to `FileDocument`
    /// to files on disk.
    ///
    /// In order for the dialog to appear, `isPresented` must be `true`. When
    /// the operation is finished, `isPresented` will be set to `false` before
    /// `onCompletion` is called. If the user cancels the operation,
    /// `isPresented` will be set to `false` and `onCancellation` will be
    /// called.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the dialog should be shown.
    ///   - documents: The in-memory documents to export.
    ///   - contentTypes: The list of supported content types which can
    ///     be exported. If not provided, `FileDocument.writableContentTypes`
    ///     are used.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed. The `result` indicates whether
    ///     the operation succeeded or failed.
    ///   - onCancellation: A callback that will be invoked
    ///     if the user cancels the operation.
    public func fileExporter<C>(isPresented: Binding<Bool>, documents: C, contentTypes: [UTType] = [], onCompletion: @escaping (Result<[URL], Error>) -> Void, onCancellation: @escaping () -> Void = {}) -> some View where C : Collection, C.Element : FileDocument { return never() }


    /// Presents a system dialog for allowing the user to export a
    /// collection of documents that conform to `ReferenceFileDocument`
    /// to files on disk.
    ///
    /// In order for the dialog to appear, `isPresented` must be `true`. When
    /// the operation is finished, `isPresented` will be set to `false` before
    /// `onCompletion` is called. If the user cancels the operation,
    /// `isPresented` will be set to `false` and `onCancellation` will be
    /// called.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the dialog should be shown.
    ///   - documents: The in-memory documents to export.
    ///   - contentTypes: The list of supported content types which can
    ///     be exported. If not provided, `ReferenceFileDocument.writableContentTypes`
    ///     are used.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed. The `result` indicates whether
    ///     the operation succeeded or failed.
    ///   - onCancellation: A callback that will be invoked
    ///     if the user cancels the operation.
    public func fileExporter<C>(isPresented: Binding<Bool>, documents: C, contentTypes: [UTType] = [], onCompletion: @escaping (Result<[URL], Error>) -> Void, onCancellation: @escaping () -> Void = {}) -> some View where C : Collection, C.Element : ReferenceFileDocument { return never() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Defines the destination of a drag-and-drop operation that handles the
    /// dropped content with a closure that you specify.
    ///
    /// The drop destination is the same size and position as this view.
    ///
    /// - Parameters:
    ///   - supportedContentTypes: The uniform type identifiers that describe the
    ///     types of content this view can accept through drag and drop.
    ///     If the drag-and-drop operation doesn't contain any of the supported
    ///     types, then this drop destination doesn't activate and `isTargeted`
    ///     doesn't update.
    ///   - isTargeted: A binding that updates when a drag and drop operation
    ///     enters or exits the drop target area. The binding's value is `true` when
    ///     the cursor is inside the area, and `false` when the cursor is outside.
    ///   - action: A closure that takes the dropped content and responds
    ///     appropriately. The parameter to `action` contains the dropped
    ///     items, with types specified by `supportedContentTypes`. Return `true`
    ///     if the drop operation was successful; otherwise, return `false`.
    ///
    /// - Returns: A view that provides a drop destination for a drag
    ///   operation of the specified types.
    public func onDrop(of supportedContentTypes: [UTType], isTargeted: Binding<Bool>?, perform action: @escaping (_ providers: [NSItemProvider]) -> Bool) -> some View { return never() }


    /// Defines the destination of a drag and drop operation that handles the
    /// dropped content with a closure that you specify.
    ///
    /// The drop destination is the same size and position as this view.
    ///
    /// - Parameters:
    ///   - supportedContentTypes: The uniform type identifiers that describe
    ///     the types of content this view can accept through drag and drop.
    ///     If the drag and drop operation doesn't contain any of the supported
    ///     types, then this drop destination doesn't activate and `isTargeted`
    ///     doesn't update.
    ///   - isTargeted: A binding that updates when a drag and drop operation
    ///     enters or exits the drop target area. The binding's value is `true` when
    ///     the cursor is inside the area, and `false` when the cursor is outside.
    ///   - action: A closure that takes the dropped content and responds
    ///     appropriately. The first parameter to `action` contains the dropped
    ///     items, with types specified by `supportedContentTypes`. The second
    ///     parameter contains the drop location in this view's coordinate
    ///     space. Return `true` if the drop operation was successful;
    ///     otherwise, return `false`.
    ///
    /// - Returns: A view that provides a drop destination for a drag
    ///   operation of the specified types.
    public func onDrop(of supportedContentTypes: [UTType], isTargeted: Binding<Bool>?, perform action: @escaping (_ providers: [NSItemProvider], _ location: CGPoint) -> Bool) -> some View { return never() }


    /// Defines the destination of a drag and drop operation using behavior
    /// controlled by the delegate that you provide.
    ///
    /// The drop destination is the same size and position as this view.
    ///
    /// - Parameters:
    ///   - supportedContentTypes: The uniform type identifiers that describe the
    ///     types of content this view can accept through drag and drop.
    ///     If the drag and drop operation doesn't contain any of the supported
    ///     types, then this drop destination doesn't activate and `isTargeted`
    ///     doesn't update.
    ///   - delegate: A type that conforms to the ``DropDelegate`` protocol. You
    ///     have comprehensive control over drop behavior when you use a
    ///     delegate.
    ///
    /// - Returns: A view that provides a drop destination for a drag
    ///   operation of the specified types.
    public func onDrop(of supportedContentTypes: [UTType], delegate: DropDelegate) -> some View { return never() }

}

extension View {

    /// Defines the destination of a drag and drop operation that handles the
    /// dropped content with a closure that you specify.
    ///
    /// The dropped content can be provided as binary data, file URLs, or file promises.
    ///
    /// The drop destination is the same size and position as this view.
    ///
    ///     @State private var isDropTargeted = false
    ///
    ///     var body: some View {
    ///         Color.pink
    ///             .frame(width: 400, height: 400)
    ///             .dropDestination(for: String.self) { receivedTitles, location in
    ///                 animateDrop(at: location)
    ///                 process(titles: receivedTitles)
    ///             } isTargeted: {
    ///                 isDropTargeted = $0
    ///             }
    ///     }
    ///
    ///     func process(titles: [String]) { ... }
    ///     func animateDrop(at: CGPoint) { ... }
    ///
    /// - Parameters:
    ///   - payloadType: The expected type of the dropped models.
    ///   - action: A closure that takes the dropped content and responds
    ///     appropriately. The first parameter to `action` contains the dropped
    ///     items. The second
    ///     parameter contains the drop location in this view's coordinate
    ///     space. Return `true` if the drop operation was successful;
    ///     otherwise, return `false`.
    ///   - isTargeted: A closure that is called when a drag and drop operation
    ///     enters or exits the drop target area. The received value is `true` when
    ///     the cursor is inside the area, and `false` when the cursor is outside.
    ///
    /// - Returns: A view that provides a drop destination for a drag
    ///   operation of the specified type.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func dropDestination<T>(for payloadType: T.Type = T.self, action: @escaping (_ items: [T], _ location: CGPoint) -> Bool, isTargeted: @escaping (Bool) -> Void = { _ in }) -> some View where T : Transferable { return never() }

}

@available(iOS, introduced: 13.4, deprecated: 100000.0, message: "Provide `UTType`s as the `supportedContentTypes` instead.")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Provide `UTType`s as the `supportedContentTypes` instead.")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Provide `UTType`s as the `supportedContentTypes` instead.")
extension View {

    /// Defines the destination for a drag and drop operation, using the same
    /// size and position as this view, handling dropped content with the given
    /// closure.
    ///
    /// - Parameters:
    ///   - supportedTypes: The uniform type identifiers that describe the
    ///     types of content this view can accept through drag and drop.
    ///     If the drag and drop operation doesn't contain any of the supported
    ///     types, then this drop destination doesn't activate and `isTargeted`
    ///     doesn't update.
    ///   - isTargeted: A binding that updates when a drag and drop operation
    ///     enters or exits the drop target area. The binding's value is `true`
    ///     when the cursor is inside the area, and `false` when the cursor is
    ///     outside.
    ///   - action: A closure that takes the dropped content and responds
    ///     appropriately. The parameter to `action` contains the dropped
    ///     items, with types specified by `supportedTypes`. Return `true`
    ///     if the drop operation was successful; otherwise, return `false`.
    /// - Returns: A view that provides a drop destination for a drag
    ///   operation of the specified types.
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func onDrop(of supportedTypes: [String], isTargeted: Binding<Bool>?, perform action: @escaping (_ providers: [NSItemProvider]) -> Bool) -> some View { return never() }


    /// Defines the destination for a drag and drop operation with the same size
    /// and position as this view, handling dropped content and the drop
    /// location with the given closure.
    ///
    /// - Parameters:
    ///   - supportedTypes: The uniform type identifiers that describe the
    ///     types of content this view can accept through drag and drop.
    ///     If the drag and drop operation doesn't contain any of the supported
    ///     types, then this drop destination doesn't activate and `isTargeted`
    ///     doesn't update.
    ///   - isTargeted: A binding that updates when a drag and drop operation
    ///     enters or exits the drop target area. The binding's value is `true`
    ///     when the cursor is inside the area, and `false` when the cursor is
    ///     outside.
    ///   - action: A closure that takes the dropped content and responds
    ///     appropriately. The first parameter to `action` contains the dropped
    ///     items, with types specified by `supportedTypes`. The second
    ///     parameter contains the drop location in this view's coordinate
    ///     space. Return `true` if the drop operation was successful;
    ///     otherwise, return `false`.
    /// - Returns: A view that provides a drop destination for a drag
    ///   operation of the specified types.
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func onDrop(of supportedTypes: [String], isTargeted: Binding<Bool>?, perform action: @escaping (_ providers: [NSItemProvider], _ location: CGPoint) -> Bool) -> some View { return never() }


    /// Defines the destination for a drag and drop operation with the same size
    /// and position as this view, with behavior controlled by the given
    /// delegate.
    ///
    /// - Parameters:
    ///   - supportedTypes: The uniform type identifiers that describe the
    ///     types of content this view can accept through drag and drop.
    ///     If the drag and drop operation doesn't contain any of the supported
    ///     types, then this drop destination doesn't activate and `isTargeted`
    ///     doesn't update.
    ///   - delegate: A type that conforms to the `DropDelegate` protocol. You
    ///     have comprehensive control over drop behavior when you use a
    ///     delegate.
    /// - Returns: A view that provides a drop destination for a drag
    ///   operation of the specified types.
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func onDrop(of supportedTypes: [String], delegate: DropDelegate) -> some View { return never() }

}


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension DynamicViewContent {

    /// Sets the insert action for the dynamic view.
    ///
    /// - Parameters:
    ///   - supportedContentTypes: An array of UTI types that the dynamic
    ///     view supports.
    ///   - action: A closure that SkipUI invokes when elements are added to
    ///     the view. The closure takes two arguments: The first argument is the
    ///     offset relative to the dynamic view's underlying collection of data.
    ///     The second argument is an array of
    ///      items that
    ///     represents the data that you want to insert.
    ///
    /// - Returns: A view that calls `action` when elements are inserted into
    ///   the original view.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public func onInsert(of supportedContentTypes: [UTType], perform action: @escaping (Int, [NSItemProvider]) -> Void) -> some DynamicViewContent { return never() }


    /// Sets the insert action for the dynamic view.
    ///
    /// - Parameters:
    ///   - acceptedTypeIdentifiers: An array of UTI types that the dynamic
    ///     view supports.
    ///   - action: A closure that SkipUI invokes when elements are added to
    ///     the view. The closure takes two arguments: The first argument is the
    ///     offset relative to the dynamic view's underlying collection of data.
    ///     The second argument is an array of `NSItemProvider` that represents
    ///     the data that you want to insert.
    ///
    /// - Returns: A view that calls `action` when elements are inserted into
    ///   the original view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Provide `UTType`s as the `supportedContentTypes` instead.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Provide `UTType`s as the `supportedContentTypes` instead.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Provide `UTType`s as the `supportedContentTypes` instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Provide `UTType`s as the `supportedContentTypes` instead.")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Provide `UTType`s as the `supportedContentTypes` instead.")
    public func onInsert(of acceptedTypeIdentifiers: [String], perform action: @escaping (Int, [NSItemProvider]) -> Void) -> some DynamicViewContent { return never() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Presents a system interface for allowing the user to import an existing
    /// file.
    ///
    /// In order for the interface to appear, `isPresented` must be `true`. When
    /// the operation is finished, `isPresented` will be set to `false` before
    /// `onCompletion` is called. If the user cancels the operation,
    /// `isPresented` will be set to `false` and `onCompletion` will not be
    /// called.
    ///
    /// - Note: This dialog provides security-scoped URLs.
    ///   Call the ``startAccessingSecurityScopedResource`` method to access or bookmark
    ///   the URLs, and the ``stopAccessingSecurityScopedResource`` method
    ///   to release the access.
    ///
    /// For example, an application can have a button that allows the user to choose the default directory
    /// with document templates loaded on every launch. Such a button might look like this:
    ///
    ///      struct PickTemplatesDirectoryButton: View {
    ///          @State private var showFileImporter = false
    ///          var onTemplatesDirectoryPicked: (URL) -> Void
    ///
    ///          var body: some View {
    ///              Button {
    ///                  showFileImporter = true
    ///              } label: {
    ///                  Label("Choose templates directory", systemImage: "folder.circle")
    ///              }
    ///              .fileImporter(
    ///                  isPresented: $showFileImporter,
    ///                  allowedContentTypes: [.directory]
    ///              ) { result in
    ///                   switch result {
    ///                   case .success(let directory):
    ///                       // gain access to the directory
    ///                       let gotAccess = directory.startAccessingSecurityScopedResource()
    ///                       if !gotAccess { return }
    ///                       // access the directory URL
    ///                       // (read templates in the directory, make a bookmark, etc.)
    ///                       onTemplatesDirectoryPicked(directory)
    ///                       // release access
    ///                       directory.stopAccessingSecurityScopedResource()
    ///                   case .failure(let error):
    ///                       // handle error
    ///                       print(error)
    ///                   }
    ///              }
    ///          }
    ///      }
    ///
    /// - Note: Changing `allowedContentTypes` while the file importer is
    ///   presented will have no immediate effect, however will apply the next
    ///   time it is presented.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - allowedContentTypes: The list of supported content types which can
    ///     be imported.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed. To access the received URLs, call `startAccessingSecurityScopedResource`.
    ///     When the access is no longer required, call `stopAccessingSecurityScopedResource`.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
    public func fileImporter(isPresented: Binding<Bool>, allowedContentTypes: [UTType], onCompletion: @escaping (_ result: Result<URL, Error>) -> Void) -> some View { return never() }


    /// Presents a system interface for allowing the user to import multiple
    /// files.
    ///
    /// In order for the interface to appear, `isPresented` must be `true`. When
    /// the operation is finished, `isPresented` will be set to `false` before
    /// `onCompletion` is called. If the user cancels the operation,
    /// `isPresented` will be set to `false` and `onCompletion` will not be
    /// called.
    ///
    /// - Note: This dialog provides security-scoped URLs.
    ///   Call the ``startAccessingSecurityScopedResource`` method to access or bookmark
    ///   the URLs, and the ``stopAccessingSecurityScopedResource`` method
    ///   to release the access.
    ///
    /// For example, a button that allows the user to choose multiple PDF files for the application
    /// to combine them later, might look like this:
    ///
    ///        struct PickPDFsButton: View {
    ///            @State private var showFileImporter = false
    ///            var handlePickedPDF: (URL) -> Void
    ///
    ///            var body: some View {
    ///                Button {
    ///                    showFileImporter = true
    ///                } label: {
    ///                    Label("Choose PDFs to combine", systemImage: "doc.circle")
    ///                }
    ///                .fileImporter(
    ///                    isPresented: $showFileImporter,
    ///                    allowedContentTypes: [.pdf],
    ///                    allowsMultipleSelection: true
    ///                ) { result in
    ///                    switch result {
    ///                    case .success(let files):
    ///                        files.forEach { file in
    ///                            // gain access to the directory
    ///                            let gotAccess = file.startAccessingSecurityScopedResource()
    ///                            if !gotAccess { return }
    ///                            // access the directory URL
    ///                            // (read templates in the directory, make a bookmark, etc.)
    ///                            handlePickedPDF(file)
    ///                            // release access
    ///                            file.stopAccessingSecurityScopedResource()
    ///                        }
    ///                    case .failure(let error):
    ///                        // handle error
    ///                        print(error)
    ///                    }
    ///                }
    ///            }
    ///        }
    ///
    /// - Note: Changing `allowedContentTypes` or `allowsMultipleSelection`
    ///   while the file importer is presented will have no immediate effect,
    ///   however will apply the next time it is presented.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - allowedContentTypes: The list of supported content types which can
    ///     be imported.
    ///   - allowsMultipleSelection: Whether the importer allows the user to
    ///     select more than one file to import.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed. To access the received URLs, call `startAccessingSecurityScopedResource`.
    ///     When the access is no longer required, call `stopAccessingSecurityScopedResource`.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
    public func fileImporter(isPresented: Binding<Bool>, allowedContentTypes: [UTType], allowsMultipleSelection: Bool, onCompletion: @escaping (_ result: Result<[URL], Error>) -> Void) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Presents a system dialog for allowing the user to import multiple
    /// files.
    ///
    /// In order for the dialog to appear, `isPresented` must be `true`. When
    /// the operation is finished, `isPresented` will be set to `false` before
    /// `onCompletion` is called. If the user cancels the operation,
    /// `isPresented` will be set to `false` and `onCompletion` will not be
    /// called.
    ///
    /// - Note: This dialog provides security-scoped URLs.
    ///   Call the ``startAccessingSecurityScopedResource`` method to access or bookmark
    ///   the URLs, and the ``stopAccessingSecurityScopedResource`` method
    ///   to release the access.
    ///
    /// For example, a button that allows the user to choose multiple PDF files for the application
    /// to combine them later, might look like this:
    ///
    ///        struct PickPDFsButton: View {
    ///            @State private var showFileImporter = false
    ///            var handlePickedPDF: (URL) -> Void
    ///
    ///            var body: some View {
    ///                Button {
    ///                    showFileImporter = true
    ///                } label: {
    ///                    Label("Choose PDFs to combine", systemImage: "doc.circle")
    ///                }
    ///                .fileImporter(
    ///                    isPresented: $showFileImporter,
    ///                    allowedContentTypes: [.pdf],
    ///                    allowsMultipleSelection: true
    ///                ) { result in
    ///                    switch result {
    ///                    case .success(let files):
    ///                        files.forEach { file in
    ///                            // gain access to the directory
    ///                            let gotAccess = file.startAccessingSecurityScopedResource()
    ///                            if !gotAccess { return }
    ///                            // access the directory URL
    ///                            // (read templates in the directory, make a bookmark, etc.)
    ///                            handlePickedPDF(file)
    ///                            // release access
    ///                            file.stopAccessingSecurityScopedResource()
    ///                        }
    ///                    case .failure(let error):
    ///                        // handle error
    ///                        print(error)
    ///                    }
    ///                }
    ///            }
    ///        }
    ///
    /// - Note: Changing `allowedContentTypes` or `allowsMultipleSelection`
    ///   while the file importer is presented will have no immediate effect,
    ///   however will apply the next time it is presented.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the dialog should be shown.
    ///   - allowedContentTypes: The list of supported content types which can
    ///     be imported.
    ///   - allowsMultipleSelection: Whether the importer allows the user to
    ///     select more than one file to import.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed. The `result` indicates whether the operation
    ///     succeeded or failed. To access the received URLs, call `startAccessingSecurityScopedResource`.
    ///     When the access is no longer required, call `stopAccessingSecurityScopedResource`.
    ///   - onCancellation: A callback that will be invoked
    ///     if the user cancels the operation.
    public func fileImporter(isPresented: Binding<Bool>, allowedContentTypes: [UTType], allowsMultipleSelection: Bool, onCompletion: @escaping (_ result: Result<[URL], Error>) -> Void, onCancellation: @escaping () -> Void) -> some View { return never() }

}
