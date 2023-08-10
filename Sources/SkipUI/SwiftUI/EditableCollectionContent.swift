// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// An opaque wrapper view that adds editing capabilities to a row in a list.
///
/// You don't use this type directly. Instead SkipUI creates this type on
/// your behalf.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct EditableCollectionContent<Content, Data> {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EditableCollectionContent : PlatformView where Content : PlatformView {
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EditableCollectionContent : View where Content : View {

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

#endif
