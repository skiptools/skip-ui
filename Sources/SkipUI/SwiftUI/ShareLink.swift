// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import protocol CoreTransferable.Transferable
import struct Foundation.URL
import struct UniformTypeIdentifiers.UTType

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


/// The default label used for a share link.
///
/// You don't use this type directly. Instead, ``ShareLink`` uses it
/// automatically depending on how you create a share link.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public struct DefaultShareLinkLabel : View {

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

#endif
