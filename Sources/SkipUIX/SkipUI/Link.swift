// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

import struct Foundation.URL

/// A control for navigating to a URL.
///
/// Create a link by providing a destination URL and a title. The title
/// tells the user the purpose of the link, and can be a string, a title
/// key that produces a localized string, or a view that acts as a label.
/// The example below creates a link to `example.com` and displays the
/// title string as a link-styled view:
///
///     Link("View Our Terms of Service",
///           destination: URL(string: "https://www.example.com/TOS.html")!)
///
/// When a user taps or clicks a `Link`, the default behavior depends on the
/// contents of the URL. For example, SkipUI opens a Universal Link in the
/// associated app if possible, or in the user's default web browser if not.
/// Alternatively, you can override the default behavior by setting the
/// ``EnvironmentValues/openURL`` environment value with a custom
/// ``OpenURLAction``:
///
///     Link("Visit Our Site", destination: URL(string: "https://www.example.com")!)
///         .environment(\.openURL, OpenURLAction { url in
///             print("Open \(url)")
///             return .handled
///         })
///
/// As with other views, you can style links using standard view modifiers
/// depending on the view type of the link's label. For example, a ``Text``
/// label could be modified with a custom ``View/font(_:)`` or
/// ``View/foregroundColor(_:)`` to customize the appearance of the link in
/// your app's UI.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct Link<Label> : View where Label : View {

    /// Creates a control, consisting of a URL and a label, used to navigate
    /// to the given URL.
    ///
    /// - Parameters:
    ///     - destination: The URL for the link.
    ///     - label: A view that describes the destination of URL.
    public init(destination: URL, @ViewBuilder label: () -> Label) { fatalError() }

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

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Link where Label == Text {

    /// Creates a control, consisting of a URL and a title key, used to
    /// navigate to a URL.
    ///
    /// Use ``Link`` to create a control that your app uses to navigate to a
    /// URL that you provide. The example below creates a link to
    /// `example.com` and uses `Visit Example Co` as the title key to
    /// generate a link-styled view in your app:
    ///
    ///     Link("Visit Example Co",
    ///           destination: URL(string: "https://www.example.com/")!)
    ///
    /// - Parameters:
    ///     - titleKey: The key for the localized title that describes the
    ///       purpose of this link.
    ///     - destination: The URL for the link.
    public init(_ titleKey: LocalizedStringKey, destination: URL) { fatalError() }

    /// Creates a control, consisting of a URL and a title string, used to
    /// navigate to a URL.
    ///
    /// Use ``Link`` to create a control that your app uses to navigate to a
    /// URL that you provide. The example below creates a link to
    /// `example.com` and displays the title string you provide as a
    /// link-styled view in your app:
    ///
    ///     func marketingLink(_ callToAction: String) -> Link {
    ///         Link(callToAction,
    ///             destination: URL(string: "https://www.example.com/")!)
    ///     }
    ///
    /// - Parameters:
    ///     - title: A text string used as the title for describing the
    ///       underlying `destination` URL.
    ///     - destination: The URL for the link.
    public init<S>(_ title: S, destination: URL) where S : StringProtocol { fatalError() }
}

/// A style appropriate for links.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@frozen public struct LinkShapeStyle : ShapeStyle {

    /// Creates a new link shape style instance.
    public init() { fatalError() }

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

#endif
