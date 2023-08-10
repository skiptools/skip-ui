// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import struct UniformTypeIdentifiers.UTType
import class Foundation.FileWrapper
import struct Foundation.URL
import protocol Combine.ObservableObject

@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DocumentConfiguration {

    /// A Boolean value that indicates whether you can edit the document.
    ///
    /// On macOS, the document could be non-editable if the user lacks write permissions,
    /// the parent directory or volume is read-only,
    /// or the document couldn't be autosaved.
    ///
    /// On iOS, the document is not editable if there was
    /// an error reading or saving it, there's an unresolved conflict,
    /// the document is being uploaded or downloaded,
    /// or otherwise, it is currently busy and unsafe for user edits.
    public var isEditable: Bool { get { fatalError() } }

    /// A URL of an open document.
    ///
    /// If the document has never been saved, returns `nil`.
    public var fileURL: URL? { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DocumentConfiguration : Sendable {
}

/// A scene that enables support for opening, creating, and saving documents.
///
/// Use a `DocumentGroup` scene to tell SkipUI what kinds of documents your
/// app can open when you declare your app using the ``App`` protocol.
///
/// Initialize a document group scene by passing in the document model and a
/// view capable of displaying the document type. The document types you supply
/// to `DocumentGroup` must conform to ``FileDocument`` or
/// ``ReferenceFileDocument``. SkipUI uses the model to add document support
/// to your app. In macOS this includes document-based menu support, including
/// the ability to open multiple documents. On iOS this includes a document
/// browser that can navigate to the documents stored on the file system
/// and multiwindow support:
///
///     @main
///     struct MyApp: App {
///         var body: some Scene {
///             DocumentGroup(newDocument: TextFile()) { configuration in
///                 ContentView(document: configuration.$document)
///             }
///         }
///     }
///
/// Any time the configuration changes, SkipUI updates the contents
/// with that new configuration, similar to other parameterized builders.
///
/// ### Viewing documents
///
/// If your app only needs to display but not modify a specific
/// document type, you can use the file viewer document group scene. You
/// supply the file type of the document, and a view that displays the
/// document type that you provide:
///
///     @main
///     struct MyApp: App {
///         var body: some Scene {
///             DocumentGroup(viewing: MyImageFormatDocument.self) {
///                 MyImageFormatViewer(image: $0.document)
///             }
///         }
///     }
///
/// ### Supporting multiple document types
///
/// Your app can support multiple document types by adding additional
/// document group scenes:
///
///     @main
///     struct MyApp: App {
///         var body: some Scene {
///             DocumentGroup(newDocument: TextFile()) { group in
///                 ContentView(document: group.$document)
///             }
///             DocumentGroup(viewing: MyImageFormatDocument.self) { group in
///                 MyImageFormatViewer(image: group.document)
///             }
///         }
///     }
///
/// ### Accessing the document's URL
///
/// If your app needs to know the document's URL, you can read it from the `editor`
/// closure's `configuration` parameter, along with the binding to the document.
/// When you create a new document, the configuration's `fileURL` property is `nil`.
/// Every time it changes, it is passed over to the `DocumentGroup` builder
/// in the updated `configuration`.
/// This ensures that the view you define in the closure always knows
/// the URL of the document it hosts.
///
///     @main
///     struct MyApp: App {
///         var body: some Scene {
///             DocumentGroup(newDocument: TextFile()) { configuration in
///                 ContentView(
///                     document: configuration.$document,
///                     fileURL: configuration.fileURL
///                 )
///             }
///         }
///     }
///
/// The URL can be used, for example, to present the file path of the file name
/// in the user interface.
/// Don't access the document's contents or metadata using the URL because that
/// can conflict with the management of the file that SkipUI performs.
/// Instead, use the methods that ``FileDocument`` and ``ReferenceFileDocument``
/// provide to perform read and write operations.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DocumentGroup<Document, Content> : Scene where Content : View {

    /// The content and behavior of the scene.
    ///
    /// For any scene that you create, provide a computed `body` property that
    /// defines the scene as a composition of other scenes. You can assemble a
    /// scene from built-in scenes that SkipUI provides, as well as other
    /// scenes that you've defined.
    ///
    /// Swift infers the scene's ``SkipUI/Scene/Body-swift.associatedtype``
    /// associated type based on the contents of the `body` property.
    @MainActor public var body: Body { get { return never() } }

    /// The type of scene that represents the body of this scene.
    ///
    /// When you create a custom scene, Swift infers this type from your
    /// implementation of the required ``SkipUI/Scene/body-swift.property``
    /// property.
    public typealias Body = Never
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DocumentGroup where Document : FileDocument {

    /// Creates a document group for creating and editing file documents.
    ///
    /// Use a ``DocumentGroup`` scene to tell SkipUI what kinds of documents
    /// your app can open when you declare your app using the ``App`` protocol.
    /// You initialize a document group scene by passing in the document model
    /// and a view capable of displaying the document's contents. The document
    /// types you supply to ``DocumentGroup`` must conform to ``FileDocument``
    /// or ``ReferenceFileDocument``. SkipUI uses the model to add document
    /// support to your app. In macOS this includes document-based menu support
    /// including the ability to open multiple documents. On iOS this includes
    /// a document browser that can navigate to the documents stored on the
    /// file system and multiwindow support:
    ///
    ///     @main
    ///     struct MyApp: App {
    ///         var body: some Scene {
    ///             DocumentGroup(newDocument: TextFile()) { file in
    ///                 ContentView(document: file.$document)
    ///             }
    ///         }
    ///     }
    ///
    /// The document types you supply to ``DocumentGroup`` must conform to
    /// ``FileDocument`` or ``ReferenceFileDocument``. Your app can support
    ///  multiple document types by adding additional ``DocumentGroup`` scenes.
    ///
    /// - Parameters:
    ///   - newDocument: The initial document to use when a user creates
    ///     a new document.
    ///   - editor: The editing UI for the provided document.
    public init(newDocument: @autoclosure @escaping () -> Document, @ViewBuilder editor: @escaping (FileDocumentConfiguration<Document>) -> Content) { fatalError() }

    /// Creates a document group capable of viewing file documents.
    ///
    /// Use this method to create a document group that can view files of a
    /// specific type. The example below creates a new document viewer for
    /// `MyImageFormatDocument` and displays them with `MyImageFormatViewer`:
    ///
    ///     @main
    ///     struct MyApp: App {
    ///         var body: some Scene {
    ///             DocumentGroup(viewing: MyImageFormatDocument.self) { file in
    ///                 MyImageFormatViewer(image: file.document)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - documentType: The type of document your app can view.
    ///   - viewer: The viewing UI for the provided document.
    ///
    /// You tell the system about the app's role with respect to the document
    /// type by setting the
    ///  
    ///   `Info.plist` key with a value of `Viewer`.
    ///
    public init(viewing documentType: Document.Type, @ViewBuilder viewer: @escaping (FileDocumentConfiguration<Document>) -> Content) { fatalError() }
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DocumentGroup where Document : ReferenceFileDocument {

    /// Creates a document group that is able to create and edit reference file
    /// documents.
    ///
    /// - Parameters:
    ///   - newDocument: The initial document used when the user creates
    ///     a new document. The argument should create a new instance, such that
    ///     a new document is created on each invocation of the closure.
    ///   - editor: The editing UI for the provided document.
    ///
    /// The current document for a given editor instance is also provided as an
    /// environment object for its subhierarchy.
    ///
    /// Undo support is not automatically provided for this construction of
    /// a `DocumentGroup`, and any updates to the document by the editor view
    /// hierarchy are expected to register undo operations when appropriate.
    public init(newDocument: @escaping () -> Document, @ViewBuilder editor: @escaping (ReferenceFileDocumentConfiguration<Document>) -> Content) { fatalError() }

    /// Creates a document group that is able to view reference file documents.
    ///
    /// - Parameters:
    ///   - documentType: The type of document being viewed.
    ///   - viewer: The viewing UI for the provided document.
    ///
    /// The current document for a given editor instance is also provided as an
    /// environment object for its subhierarchy.
    ///
    /// - See Also: `CFBundleTypeRole` with a value of "Viewer"
    public init(viewing documentType: Document.Type, @ViewBuilder viewer: @escaping (ReferenceFileDocumentConfiguration<Document>) -> Content) { fatalError() }
}


/// A type that you use to serialize documents to and from file.
///
/// To store a document as a value type --- like a structure --- create a type
/// that conforms to the `FileDocument` protocol and implement the
/// required methods and properties. Your implementation:
///
/// * Provides a list of the content types that the document can read from and
///   write to by defining ``readableContentTypes``. If the list of content
///   types that the document can write to is different from those that it reads
///   from, you can optionally also define ``writableContentTypes-2opfc``.
/// * Loads documents from file in the ``init(configuration:)`` initializer.
/// * Stores documents to file by serializing their content in the
///   ``fileWrapper(configuration:)`` method.
///
/// > Important: If you store your document as a reference type --- like a
///   class --- use ``ReferenceFileDocument`` instead.
///
/// Ensure that types that conform to this protocol are thread-safe.
/// In particular, SkipUI calls the protocol's methods on a background
/// thread. Don't use that thread to perform user interface updates.
/// Use it only to serialize and deserialize the document data.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol FileDocument {

    /// The file and data types that the document reads from.
    ///
    /// Define this list to indicate the content types that your document can
    /// read. By default, SkipUI assumes that your document can also write
    /// the same set of content types. If you need to indicate a different set
    /// of types for writing files, define the ``writableContentTypes-2opfc``
    /// property in addition to this property.
    static var readableContentTypes: [UTType] { get }

    /// The file types that the document supports saving or exporting to.
    ///
    /// By default, SkipUI assumes that your document reads and writes the
    /// same set of content types. Only define this property if you need to
    /// indicate a different set of types for writing files. Otherwise, the
    /// default implementation of this property returns the list that you
    /// specify in your implementation of ``readableContentTypes``.
    static var writableContentTypes: [UTType] { get }

    /// Creates a document and initializes it with the contents of a file.
    ///
    /// SkipUI calls this initializer when someone opens a file type
    /// that matches one of those that your document type supports.
    /// Use the ``FileDocumentReadConfiguration/file`` property of the
    /// `configuration` input to get document's data. Deserialize the data,
    /// and store it in your document's data structure:
    ///
    ///     init(configuration: ReadConfiguration) throws {
    ///         guard let data = configuration.file.regularFileContents
    ///         else { /* Throw an error. */ }
    ///         model = try JSONDecoder().decode(Model.self, from: data)
    ///     }
    ///
    /// The above example assumes that you define `Model` to contain
    /// the document's data, that `Model` conforms to the
    ///  protocol,
    /// and that you store a `model` property of that type inside your document.
    ///
    /// > Note: SkipUI calls this method on a background thread. Don't
    ///   make user interface changes from that thread.
    ///
    /// - Parameter configuration: Information about the file that you read
    ///   document data from.
    init(configuration: Self.ReadConfiguration) throws

    /// The configuration for reading document contents.
    ///
    /// This type is an alias for ``FileDocumentReadConfiguration``, which
    /// contains a content type and a file wrapper that you use to access the
    /// contents of a document file. You get a value of this type as an input
    /// to the ``init(configuration:)`` initializer. Use it to load a
    /// document from a file.
    typealias ReadConfiguration = FileDocumentReadConfiguration

    /// Serializes a document snapshot to a file wrapper.
    ///
    /// To store a document --- for example, in response to a Save command ---
    /// SkipUI calls this method. Use it to serialize the document's data and
    /// create or modify a file wrapper with the serialized data:
    ///
    ///     func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    ///         let data = try JSONEncoder().encode(model)
    ///         return FileWrapper(regularFileWithContents: data)
    ///     }
    ///
    /// > Note: SkipUI calls this method on a background thread. Don't
    ///   make user interface changes from that thread.
    ///
    /// - Parameters:
    ///   - configuration: Information about a file that already exists for the
    ///     document, if any.
    ///
    /// - Returns: The destination to serialize the document contents to. The
    ///   value can be a newly created
    ///   
    ///   or an update of the one provided in the `configuration` input.
    func fileWrapper(configuration: Self.WriteConfiguration) throws -> FileWrapper

    /// The configuration for writing document contents.
    ///
    /// This type is an alias for ``FileDocumentWriteConfiguration``, which
    /// contains a content type and a file wrapper that you use to access the
    /// contents of a document file, if one already exists. You get a value
    /// of this type as an input to the ``fileWrapper(configuration:)``
    /// method.
    typealias WriteConfiguration = FileDocumentWriteConfiguration
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension FileDocument {

    /// The file types that the document supports saving or exporting to.
    ///
    /// By default, SkipUI assumes that your document reads and writes the
    /// same set of content types. Only define this property if you need to
    /// indicate a different set of types for writing files. Otherwise, the
    /// default implementation of this property returns the list that you
    /// specify in your implementation of ``readableContentTypes``.
    public static var writableContentTypes: [UTType] { get { fatalError() } }
}

/// The properties of an open file document.
///
/// You receive an instance of this structure when you create a
/// ``DocumentGroup`` with a value file type. Use it to access the
/// document in your viewer or editor.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct FileDocumentConfiguration<Document> where Document : FileDocument {

    /// The current document model.
    ///
    /// Setting a new value marks the document as having changes for later
    /// saving and registers an undo action to restore the model to its
    /// previous value.
    ///
    /// If ``isEditable`` is `false`, setting a new value has no effect
    /// because the document is in viewing mode.
//    @Binding public var document: Document { get { fatalError() } nonmutating set { fatalError() } }

//    public var $document: Binding<Document> { get { fatalError() } }

    /// The URL of the open file document.
    public var fileURL: URL?

    /// A Boolean that indicates whether you can edit the document.
    ///
    /// This value is `false` if the document is in viewing mode, or if the
    /// file is not writable.
    public var isEditable: Bool { get { fatalError() } }
}

/// The configuration for reading file contents.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct FileDocumentReadConfiguration {

    /// The expected uniform type of the file contents.
    public let contentType: UTType = { fatalError() }()

    /// The file wrapper containing the document content.
    public let file: FileWrapper = { fatalError() }()
}

/// The configuration for serializing file contents.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct FileDocumentWriteConfiguration {

    /// The expected uniform type of the file contents.
    public let contentType: UTType = { fatalError() }()

    /// The file wrapper containing the current document content.
    /// `nil` if the document is unsaved.
    public let existingFile: FileWrapper?
}


/// A type that you use to serialize reference type documents to and from file.
///
/// To store a document as a reference type --- like a class --- create a type
/// that conforms to the `ReferenceFileDocument` protocol and implement the
/// required methods and properties. Your implementation:
///
/// * Provides a list of the content types that the document can read from and
///   write to by defining ``readableContentTypes``. If the list of content
///   types that the document can write to is different from those that it reads
///   from, you can optionally also define ``writableContentTypes-6x6w9``.
/// * Loads documents from file in the ``init(configuration:)`` initializer.
/// * Stores documents to file by providing a snapshot of the document's
///   content in the ``snapshot(contentType:)`` method, and then serializing
///   that content in the ``fileWrapper(snapshot:configuration:)`` method.
///
/// > Important: If you store your document as a value type --- like a
///   structure --- use ``FileDocument`` instead.
///
/// Ensure that types that conform to this protocol are thread-safe.
/// In particular, SkipUI calls the protocol's methods on a background
/// thread. Don't use that thread to perform user interface updates.
/// Use it only to serialize and deserialize the document data.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol ReferenceFileDocument : ObservableObject {

    /// A type that represents the document's stored content.
    ///
    /// Define this type to represent all the data that your document stores.
    /// When someone issues a Save command, SkipUI asks your document for a
    /// value of this type by calling the document's ``snapshot(contentType:)``
    /// method. SkipUI sends the snapshot that you provide to the document's
    /// ``fileWrapper(snapshot:configuration:)`` method, where you serialize
    /// the contents of the snapshot into a file wrapper.
    associatedtype Snapshot

    /// The file and data types that the document reads from.
    ///
    /// Define this list to indicate the content types that your document can
    /// read. By default, SkipUI assumes that your document can also write
    /// the same set of content types. If you need to indicate a different set
    /// of types for writing files, define the ``writableContentTypes-6x6w9``
    /// property in addition to this property.
    static var readableContentTypes: [UTType] { get }

    /// The file types that the document supports saving or exporting to.
    ///
    /// By default, SkipUI assumes that your document reads and writes the
    /// same set of content types. Only define this property if you need to
    /// indicate a different set of types for writing files. Otherwise, the
    /// default implementation of this property returns the list that you
    /// specify in your implementation of ``readableContentTypes``.
    static var writableContentTypes: [UTType] { get }

    /// Creates a document and initializes it with the contents of a file.
    ///
    /// SkipUI calls this initializer when someone opens a file type
    /// that matches one of those that your document type supports.
    /// Use the ``FileDocumentReadConfiguration/file`` property of the
    /// `configuration` input to get document's data. Deserialize the data,
    /// and store it in your document's data structure:
    ///
    ///     init(configuration: ReadConfiguration) throws {
    ///         guard let data = configuration.file.regularFileContents
    ///         else { /* Throw an error. */ }
    ///         model = try JSONDecoder().decode(Model.self, from: data)
    ///     }
    ///
    /// The above example assumes that you define `Model` to contain
    /// the document's data, that `Model` conforms to the
    ///  protocol,
    /// and that you store a `model` property of that type inside your document.
    ///
    /// > Note: SkipUI calls this method on a background thread. Don't
    ///   make user interface changes from that thread.
    ///
    /// - Parameter configuration: Information about the file that you read
    ///   document data from.
    init(configuration: Self.ReadConfiguration) throws

    /// The configuration for reading document contents.
    ///
    /// This type is an alias for ``FileDocumentReadConfiguration``, which
    /// contains a content type and a file wrapper that you use to access the
    /// contents of a document file. You get a value of this type as an input
    /// to the ``init(configuration:)`` initializer. Use it to load a
    /// document from a file.
    typealias ReadConfiguration = FileDocumentReadConfiguration

    /// Creates a snapshot that represents the current state of the document.
    ///
    /// To store a document --- for example, in response to a Save command ---
    /// SkipUI begins by calling this method. Return a copy of the document's
    /// content from your implementation of the method. For example, you might
    /// define an initializer for your document's model object that copies the
    /// contents of the document's instance, and return that:
    ///
    ///     func snapshot(contentType: UTType) throws -> Snapshot {
    ///         Model(from: model) // Creates a copy.
    ///     }
    ///
    /// SkipUI prevents document edits during the snapshot operation to ensure
    /// that the model state remains coherent. After the call completes, SkipUI
    /// reenables edits, and then calls the
    /// ``fileWrapper(snapshot:configuration:)`` method, where you serialize
    /// the snapshot and store it to a file.
    ///
    /// > Note: SkipUI calls this method on a background thread. Don't
    ///   make user interface changes from that thread.
    ///
    /// - Parameter contentType: The content type that you create the
    ///   document snapshot for.
    ///
    /// - Returns: A snapshot of the document content that the system
    ///   provides to the ``fileWrapper(snapshot:configuration:)`` method
    ///   for serialization.
    func snapshot(contentType: UTType) throws -> Self.Snapshot

    /// Serializes a document snapshot to a file wrapper.
    ///
    /// To store a document --- for example, in response to a Save command ---
    /// SkipUI begins by calling the ``snapshot(contentType:)`` method to get
    /// a copy of the document data in its current state. Then SkipUI passes
    /// that snapshot to this method, where you serialize it and create or
    /// modify a file wrapper with the serialized data:
    ///
    ///     func fileWrapper(snapshot: Snapshot, configuration: WriteConfiguration) throws -> FileWrapper {
    ///         let data = try JSONEncoder().encode(snapshot)
    ///         return FileWrapper(regularFileWithContents: data)
    ///     }
    ///
    /// SkipUI disables document edits during the snapshot to ensure that the
    /// document's data remains coherent, but reenables edits during the
    /// serialization operation.
    ///
    /// > Note: SkipUI calls this method on a background thread. Don't
    ///   make user interface changes from that thread.
    ///
    /// - Parameters:
    ///   - snapshot: The document snapshot to save.
    ///   - configuration: Information about a file that already exists for the
    ///     document, if any.
    ///
    /// - Returns: The destination to serialize the document contents to. The
    ///   value can be a newly created
    ///   
    ///   or an update of the one provided in the `configuration` input.
    func fileWrapper(snapshot: Self.Snapshot, configuration: Self.WriteConfiguration) throws -> FileWrapper

    /// The configuration for writing document contents.
    ///
    /// This type is an alias for ``FileDocumentWriteConfiguration``, which
    /// contains a content type and a file wrapper that you use to access the
    /// contents of a document file, if one already exists. You get a value
    /// of this type as an input to the ``fileWrapper(snapshot:configuration:)``
    /// method.
    typealias WriteConfiguration = FileDocumentWriteConfiguration
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ReferenceFileDocument {

    /// The file types that the document supports saving or exporting to.
    ///
    /// By default, SkipUI assumes that your document reads and writes the
    /// same set of content types. Only define this property if you need to
    /// indicate a different set of types for writing files. Otherwise, the
    /// default implementation of this property returns the list that you
    /// specify in your implementation of ``readableContentTypes``.
    public static var writableContentTypes: [UTType] { get { fatalError() } }
}

/// The properties of an open reference file document.
///
/// You receive an instance of this structure when you create a
/// ``DocumentGroup`` with a reference file type. Use it to access the
/// document in your viewer or editor.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@MainActor public struct ReferenceFileDocumentConfiguration<Document> where Document : ReferenceFileDocument {

    /// The current document model.
    ///
    /// Changes to the document dirty the document state, indicating that it
    /// needs to be saved. SkipUI doesn't automatically register undo actions.
    //@ObservedObject @MainActor public var document: Document { get { fatalError() } }

    //@MainActor public var $document: ObservedObject<Document>.Wrapper { get { fatalError() } }

    /// The URL of the open file document.
    @MainActor public var fileURL: URL?

    /// A Boolean that indicates whether you can edit the document.
    ///
    /// The value is `false` if the document is in viewing mode, or if the
    /// file is not writable.
    @MainActor public var isEditable: Bool { get { fatalError() } }
}


@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Presents a system interface for exporting a document that's stored in
    /// a value type, like a structure, to a file on disk.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `document` must not be `nil`. When the operation is finished,
    /// `isPresented` will be set to `false` before `onCompletion` is called. If
    /// the user cancels the operation, `isPresented` will be set to `false` and
    /// `onCompletion` will not be called.
    ///
    /// The `contentType` provided must be included within the document type's
    /// `writableContentTypes`, otherwise the first valid writable content type
    /// will be used instead.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - document: The in-memory document to export.
    ///   - contentType: The content type to use for the exported file.
    ///   - defaultFilename: If provided, the default name to use for the
    ///     exported file, which will the user will have an opportunity to edit
    ///     prior to the export.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     has succeeded or failed.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
    public func fileExporter<D>(isPresented: Binding<Bool>, document: D?, contentType: UTType, defaultFilename: String? = nil, onCompletion: @escaping (_ result: Result<URL, Error>) -> Void) -> some View where D : FileDocument { return never() }


    /// Presents a system interface for exporting a collection of value type
    /// documents to files on disk.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `documents` must not be empty. When the operation is finished,
    /// `isPresented` will be set to `false` before `onCompletion` is called. If
    /// the user cancels the operation, `isPresented` will be set to `false` and
    /// `onCompletion` will not be called.
    ///
    /// The `contentType` provided must be included within the document type's
    /// `writableContentTypes`, otherwise the first valid writable content type
    /// will be used instead.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - documents: The collection of in-memory documents to export.
    ///   - contentType: The content type to use for the exported file.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     has succeeded or failed.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
    public func fileExporter<C>(isPresented: Binding<Bool>, documents: C, contentType: UTType, onCompletion: @escaping (_ result: Result<[URL], Error>) -> Void) -> some View where C : Collection, C.Element : FileDocument { return never() }


    /// Presents a system interface for exporting a document that's stored in
    /// a reference type, like a class, to a file on disk.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `document` must not be `nil`. When the operation is finished,
    /// `isPresented` will be set to `false` before `onCompletion` is called. If
    /// the user cancels the operation, `isPresented` will be set to `false` and
    /// `onCompletion` will not be called.
    ///
    /// The `contentType` provided must be included within the document type's
    /// `writableContentTypes`, otherwise the first valid writable content type
    /// will be used instead.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - document: The in-memory document to export.
    ///   - contentType: The content type to use for the exported file.
    ///   - defaultFilename: If provided, the default name to use for the
    ///     exported file, which will the user will have an opportunity to edit
    ///     prior to the export.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     has succeeded or failed.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
    public func fileExporter<D>(isPresented: Binding<Bool>, document: D?, contentType: UTType, defaultFilename: String? = nil, onCompletion: @escaping (_ result: Result<URL, Error>) -> Void) -> some View where D : ReferenceFileDocument { return never() }


    /// Presents a system interface for exporting a collection of reference type
    /// documents to files on disk.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `documents` must not be empty. When the operation is finished,
    /// `isPresented` will be set to `false` before `onCompletion` is called. If
    /// the user cancels the operation, `isPresented` will be set to `false` and
    /// `onCompletion` will not be called.
    ///
    /// The `contentType` provided must be included within the document type's
    /// `writableContentTypes`, otherwise the first valid writable content type
    /// will be used instead.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - documents: The collection of in-memory documents to export.
    ///   - contentType: The content type to use for the exported file.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     has succeeded or failed.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
    public func fileExporter<C>(isPresented: Binding<Bool>, documents: C, contentType: UTType, onCompletion: @escaping (_ result: Result<[URL], Error>) -> Void) -> some View where C : Collection, C.Element : ReferenceFileDocument { return never() }

}

