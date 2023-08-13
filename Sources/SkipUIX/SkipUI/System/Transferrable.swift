// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import protocol CoreTransferable.Transferable
import struct Foundation.URL
import class Foundation.NSItemProvider
import struct UniformTypeIdentifiers.UTType
import Foundation // import class Foundation.Predicate // ambiguous

#if canImport(CoreTransferable)
import protocol CoreTransferable.Transferable
import protocol CoreTransferable.TransferRepresentation

/// No-op
@usableFromInline func stubTransferRepresentation() -> some TransferRepresentation {
    return never()
}
#endif



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
    public func dropDestination<T>(for payloadType: T.Type = T.self, action: @escaping ([T], Int) -> Void) -> some DynamicViewContent where T : Transferable { return stubDynamicViewContent() }

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

    @MainActor public var body: some View { get { return stubView() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
//    public typealias Body = some View
}

/// A button that toggles the edit mode environment value.
///
/// An edit button toggles the environment's ``EnvironmentValues/editMode``
/// value for content within a container that supports edit mode.
/// In the following example, an edit button placed inside a ``NavigationView``
/// supports editing of a ``List``:
///
///     @State private var fruits = [
///         "Apple",
///         "Banana",
///         "Papaya",
///         "Mango"
///     ]
///
///     var body: some View {
///         NavigationView {
///             List {
///                 ForEach(fruits, id: \.self) { fruit in
///                     Text(fruit)
///                 }
///                 .onDelete { fruits.remove(atOffsets: $0) }
///                 .onMove { fruits.move(fromOffsets: $0, toOffset: $1) }
///             }
///             .navigationTitle("Fruits")
///             .toolbar {
///                 EditButton()
///             }
///         }
///     }
///
/// Because the ``ForEach`` in the above example defines behaviors for
/// ``DynamicViewContent/onDelete(perform:)`` and
/// ``DynamicViewContent/onMove(perform:)``, the editable list displays the
/// delete and move UI when the user taps Edit. Notice that the Edit button
/// displays the title "Done" while edit mode is active:
///
/// ![A screenshot of an app with an Edit button in the navigation bar.
/// The button is labeled Done to indicate edit mode is active. Below the
/// navigation bar, a list labeled Fruits in edit mode. The list contains
/// four members, each showing a red circle containing a white dash to the
/// left of the item, and an icon composed of three horizontal lines to the
/// right of the item.](EditButton-1)
///
/// You can also create custom views that react to changes in the edit mode
/// state, as described in ``EditMode``.
@available(iOS 13.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct EditButton : View {

    /// Creates an Edit button instance.
    public init() { fatalError() }

    @MainActor public var body: some View { get { return stubView() } }

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
    public func draggable<T>(_ payload: @autoclosure @escaping () -> T) -> some View where T : Transferable { return stubView() }


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
    public func draggable<V, T>(_ payload: @autoclosure @escaping () -> T, @ViewBuilder preview: () -> V) -> some View where V : View, T : Transferable { return stubView() }

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
    public func navigationDocument<D>(_ document: D) -> some View where D : Transferable { return stubView() }


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
    public func navigationDocument<D>(_ document: D, preview: SharePreview<Never, Never>) -> some View where D : Transferable { return stubView() }


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
    public func navigationDocument<D, I>(_ document: D, preview: SharePreview<Never, I>) -> some View where D : Transferable, I : Transferable { return stubView() }


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
    public func navigationDocument<D, I>(_ document: D, preview: SharePreview<I, Never>) -> some View where D : Transferable, I : Transferable { return stubView() }


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
    public func navigationDocument<D, I1, I2>(_ document: D, preview: SharePreview<I1, I2>) -> some View where D : Transferable, I1 : Transferable, I2 : Transferable { return stubView() }

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
    public func fileExporter<T>(isPresented: Binding<Bool>, item: T?, contentTypes: [UTType] = [], defaultFilename: String? = nil, onCompletion: @escaping (Result<URL, Error>) -> Void, onCancellation: @escaping () -> Void = { }) -> some View where T : Transferable { return stubView() }


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
    public func fileExporter<C, T>(isPresented: Binding<Bool>, items: C, contentTypes: [UTType] = [], onCompletion: @escaping (Result<[URL], Error>) -> Void, onCancellation: @escaping () -> Void = { }) -> some View where C : Collection, T : Transferable, T == C.Element { return stubView() }


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
    public func fileExporter<D>(isPresented: Binding<Bool>, document: D?, contentTypes: [UTType] = [], defaultFilename: String? = nil, onCompletion: @escaping (Result<URL, Error>) -> Void, onCancellation: @escaping () -> Void = {}) -> some View where D : FileDocument { return stubView() }


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
    public func fileExporter<D>(isPresented: Binding<Bool>, document: D?, contentTypes: [UTType] = [], defaultFilename: String? = nil, onCompletion: @escaping (Result<URL, Error>) -> Void, onCancellation: @escaping () -> Void = {}) -> some View where D : ReferenceFileDocument { return stubView() }


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
    public func fileExporter<C>(isPresented: Binding<Bool>, documents: C, contentTypes: [UTType] = [], onCompletion: @escaping (Result<[URL], Error>) -> Void, onCancellation: @escaping () -> Void = {}) -> some View where C : Collection, C.Element : FileDocument { return stubView() }


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
    public func fileExporter<C>(isPresented: Binding<Bool>, documents: C, contentTypes: [UTType] = [], onCompletion: @escaping (Result<[URL], Error>) -> Void, onCancellation: @escaping () -> Void = {}) -> some View where C : Collection, C.Element : ReferenceFileDocument { return stubView() }

}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Configures the ``fileExporter``, ``fileImporter``, or ``fileMover`` to
    /// open with the specified default directory.
    ///
    /// - Parameter defaultDirectory: The directory to show when
    ///   the system file dialog launches. If the given file dialog has
    ///   a `fileDialogCustomizationID` if stores the user-chosen directory and subsequently
    ///   opens with it, ignoring the default value provided in this modifier.
    public func fileDialogDefaultDirectory(_ defaultDirectory: URL?) -> some View { return stubView() }


    /// On macOS, configures the `fileExporter`, `fileImporter`,
    /// or `fileMover` to persist and restore the file dialog configuration.
    ///
    /// Among other parameters, it stores the current directory,
    /// view style (e.g., Icons, List, Columns), recent places,
    /// and expanded window size.
    /// It enables a refined user experience; for example,
    /// when importing an image, the user might switch to the Icons view,
    /// but the List view could be more convenient in another context.
    /// The file dialog stores these settings and applies them
    /// every time before presenting the panel.
    /// If not provided, on every launch, the file dialog
    /// uses the default configuration.
    ///
    /// - Parameter id: An identifier of the configuration.
    public func fileDialogCustomizationID(_ id: String) -> some View { return stubView() }


    /// On macOS, configures the the ``fileExporter``, ``fileImporter``, or ``fileMover``
    /// with a custom text that is presented to the user,
    /// similar to a title.
    ///
    /// - Parameter message: The optional text to use as the file dialog message.
    public func fileDialogMessage(_ message: Text?) -> some View { return stubView() }


    /// On macOS, configures the the ``fileExporter``, ``fileImporter``,
    /// or ``fileMover`` with a custom message that is presented to the user,
    /// similar to a title.
    ///
    /// - Parameter messageKey: The key to a localized string to display.
    public func fileDialogMessage(_ messageKey: LocalizedStringKey) -> some View { return stubView() }


    /// On macOS, configures the the ``fileExporter``, ``fileImporter``,
    /// or ``fileMover`` with a custom message that is presented to the user,
    /// similar to a title.
    ///
    /// - Parameter message: The string to use as the file dialog message.
    public func fileDialogMessage<S>(_ message: S) -> some View where S : StringProtocol { return stubView() }


    /// On macOS, configures the the ``fileExporter``, ``fileImporter``,
    /// or ``fileMover`` with a custom confirmation button label.
    ///
    /// - Parameter label: The string to use as the label for the confirmation button.
    public func fileDialogConfirmationLabel<S>(_ label: S) -> some View where S : StringProtocol { return stubView() }


    /// On macOS, configures the the ``fileExporter``, ``fileImporter``,
    /// or ``fileMover`` with custom text as a confirmation button label.
    ///
    /// - Parameter label: The optional text to use as the label for the confirmation button.
    public func fileDialogConfirmationLabel(_ label: Text?) -> some View { return stubView() }


    /// On macOS, configures the the ``fileExporter``, ``fileImporter``,
    /// or ``fileMover`` with a custom confirmation button label.
    ///
    /// - Parameter labelKey: The key to a localized string to display.
    public func fileDialogConfirmationLabel(_ labelKey: LocalizedStringKey) -> some View { return stubView() }


    /// On macOS, configures the ``fileExporter``
    /// with a text to use as a label for the file name field.
    /// - Parameter label: The optional text to use as the label for the file name field.
    public func fileExporterFilenameLabel(_ label: Text?) -> some View { return stubView() }


    /// On macOS, configures the ``fileExporter``
    /// with a label for the file name field.
    /// - Parameter labelKey: The key to a localized string to display.
    public func fileExporterFilenameLabel(_ labelKey: LocalizedStringKey) -> some View { return stubView() }


    /// On macOS, configures the ``fileExporter``
    /// with a label for the file name field.
    /// - Parameter label: The string to use as the label for the file name field.
    public func fileExporterFilenameLabel<S>(_ label: S) -> some View where S : StringProtocol { return stubView() }


    /// On macOS, configures the the ``fileImporter``
    /// or ``fileMover`` to conditionally disable presented URLs.
    ///
    /// - Parameter predicate: The predicate that evaluates the
    ///    URLs presented to the user to conditionally disable them.
    ///    The implementation is expected to have constant complexity
    ///    and should not access the files contents or metadata. A common use case
    ///    is inspecting the path or the file name.
    public func fileDialogURLEnabled(_ predicate: Predicate<URL>) -> some View { return stubView() }


    /// On macOS, configures the ``fileExporter``, ``fileImporter``,
    /// or ``fileMover`` behavior when a user chooses an alias.
    ///
    /// By default, file dialogs resolve aliases and
    /// provide the URL of the item referred to by the chosen alias.
    /// This modifier allows control of this behavior: pass `true` if the
    /// application doesn't want file dialog to resolve aliases.
    /// - Parameter imports: A Boolean value that indicates
    ///     if the application receives unresolved or resolved URLs
    ///     when a user chooses aliases.
    public func fileDialogImportsUnresolvedAliases(_ imports: Bool) -> some View { return stubView() }


    /// On macOS, configures the ``fileExporter``, ``fileImporter``,
    /// or ``fileMover`` to provide a refined URL search experience: include or exclude
    /// hidden files, allow searching by tag, etc.
    ///
    /// - Parameter options: The search options to apply to a given file dialog.
    public func fileDialogBrowserOptions(_ options: FileDialogBrowserOptions) -> some View { return stubView() }

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
    public func onDrop(of supportedContentTypes: [UTType], isTargeted: Binding<Bool>?, perform action: @escaping (_ providers: [NSItemProvider]) -> Bool) -> some View { return stubView() }


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
    public func onDrop(of supportedContentTypes: [UTType], isTargeted: Binding<Bool>?, perform action: @escaping (_ providers: [NSItemProvider], _ location: CGPoint) -> Bool) -> some View { return stubView() }


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
    public func onDrop(of supportedContentTypes: [UTType], delegate: DropDelegate) -> some View { return stubView() }

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
    public func dropDestination<T>(for payloadType: T.Type = T.self, action: @escaping (_ items: [T], _ location: CGPoint) -> Bool, isTargeted: @escaping (Bool) -> Void = { _ in }) -> some View where T : Transferable { return stubView() }

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
    public func onDrop(of supportedTypes: [String], isTargeted: Binding<Bool>?, perform action: @escaping (_ providers: [NSItemProvider]) -> Bool) -> some View { return stubView() }


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
    public func onDrop(of supportedTypes: [String], isTargeted: Binding<Bool>?, perform action: @escaping (_ providers: [NSItemProvider], _ location: CGPoint) -> Bool) -> some View { return stubView() }


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
    public func onDrop(of supportedTypes: [String], delegate: DropDelegate) -> some View { return stubView() }

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
    public func onInsert(of supportedContentTypes: [UTType], perform action: @escaping (Int, [NSItemProvider]) -> Void) -> some DynamicViewContent { return stubDynamicViewContent() }


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
    public func onInsert(of acceptedTypeIdentifiers: [String], perform action: @escaping (Int, [NSItemProvider]) -> Void) -> some DynamicViewContent { return stubDynamicViewContent() }

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
    public func fileImporter(isPresented: Binding<Bool>, allowedContentTypes: [UTType], onCompletion: @escaping (_ result: Result<URL, Error>) -> Void) -> some View { return stubView() }


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
    public func fileImporter(isPresented: Binding<Bool>, allowedContentTypes: [UTType], allowsMultipleSelection: Bool, onCompletion: @escaping (_ result: Result<[URL], Error>) -> Void) -> some View { return stubView() }

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
    public func fileImporter(isPresented: Binding<Bool>, allowedContentTypes: [UTType], allowsMultipleSelection: Bool, onCompletion: @escaping (_ result: Result<[URL], Error>) -> Void, onCancellation: @escaping () -> Void) -> some View { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Provides a closure that vends the drag representation to be used for a
    /// particular data element.
    @inlinable public func itemProvider(_ action: (() -> NSItemProvider?)?) -> some View { return stubView() }

}

@available(iOS 13.4, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Activates this view as the source of a drag and drop operation.
    ///
    /// Applying the `onDrag(_:)` modifier adds the appropriate gestures for
    /// drag and drop to this view. When a drag operation begins, a rendering of
    /// this view is generated and used as the preview image.
    ///
    /// - Parameter data: A closure that returns a single
    ///  that
    /// represents the draggable data from this view.
    ///
    /// - Returns: A view that activates this view as the source of a drag and
    ///   drop operation, beginning with user gesture input.
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func onDrag(_ data: @escaping () -> NSItemProvider) -> some View { return stubView() }

}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Activates this view as the source of a drag and drop operation.
    ///
    /// Applying the `onDrag(_:preview:)` modifier adds the appropriate gestures
    /// for drag and drop to this view. When a drag operation begins,
    /// a rendering of `preview` is generated and used as the preview image.
    ///
    /// - Parameter data: A closure that returns a single
    /// that represents the draggable data from this view.
    /// - Parameter preview: A ``View`` to use as the source for the dragging
    ///   preview, once the drag operation has begun. The preview is centered over
    ///   the source view.
    ///
    /// - Returns: A view that activates this view as the source of a drag-and-
    ///   drop operation, beginning with user gesture input.
    public func onDrag<V>(_ data: @escaping () -> NSItemProvider, @ViewBuilder preview: () -> V) -> some View where V : View { return stubView() }

}

#endif
