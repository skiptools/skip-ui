// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A view that can display and edit long-form text.
///
/// A text editor view allows you to display and edit multiline, scrollable
/// text in your app's user interface. By default, the text editor view styles
/// the text using characteristics inherited from the environment, like
/// ``View/font(_:)``, ``View/foregroundColor(_:)``, and
/// ``View/multilineTextAlignment(_:)``.
///
/// You create a text editor by adding a `TextEditor` instance to the
/// body of your view, and initialize it by passing in a
/// ``Binding`` to a string variable in your app:
///
///     struct TextEditingView: View {
///         @State private var fullText: String = "This is some editable text..."
///
///         var body: some View {
///             TextEditor(text: $fullText)
///         }
///     }
///
/// To style the text, use the standard view modifiers to configure a system
/// font, set a custom font, or change the color of the view's text.
///
/// In this example, the view renders the editor's text in gray with a
/// custom font:
///
///     struct TextEditingView: View {
///         @State private var fullText: String = "This is some editable text..."
///
///         var body: some View {
///             TextEditor(text: $fullText)
///                 .foregroundColor(Color.gray)
///                 .font(.custom("HelveticaNeue", size: 13))
///         }
///     }
///
/// If you want to change the spacing or font scaling aspects of the text, you
/// can use modifiers like ``View/lineLimit(_:)-513mb``,
/// ``View/lineSpacing(_:)``, and ``View/minimumScaleFactor(_:)`` to configure
/// how the view displays text depending on the space constraints. For example,
/// here the ``View/lineSpacing(_:)`` modifier sets the spacing between lines
/// to 5 points:
///
///     struct TextEditingView: View {
///         @State private var fullText: String = "This is some editable text..."
///
///         var body: some View {
///             TextEditor(text: $fullText)
///                 .foregroundColor(Color.gray)
///                 .font(.custom("HelveticaNeue", size: 13))
///                 .lineSpacing(5)
///         }
///     }
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TextEditor : View {

    /// Creates a plain text editor.
    ///
    /// Use a ``TextEditor`` instance to create a view in which users can enter
    /// and edit long-form text.
    ///
    /// In this example, the text editor renders gray text using the 13
    /// point Helvetica Neue font with 5 points of spacing between each line:
    ///
    ///     struct TextEditingView: View {
    ///         @State private var fullText: String = "This is some editable text..."
    ///
    ///         var body: some View {
    ///             TextEditor(text: $fullText)
    ///                 .foregroundColor(Color.gray)
    ///                 .font(.custom("HelveticaNeue", size: 13))
    ///                 .lineSpacing(5)
    ///         }
    ///     }
    ///
    /// You can define the styling for the text within the view, including the
    /// text color, font, and line spacing. You define these styles by applying
    /// standard view modifiers to the view.
    ///
    /// The default text editor doesn't support rich text, such as styling of
    /// individual elements within the editor's view. The styles you set apply
    /// globally to all text in the view.
    ///
    /// - Parameter text: A ``Binding`` to the variable containing the
    ///    text to edit.
    public init(text: Binding<String>) { fatalError() }

    @MainActor public var body: some View { get { return stubView() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
//    public typealias Body = some View
}

/// A specification for the appearance and interaction of a text editor.
@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol TextEditorStyle {

    /// A view that represents the body of a text editor.
    associatedtype Body : View

    /// Creates a view that represents the body of a text editor.
    ///
    /// The system calls this method for each ``TextEditor`` instance in a view
    /// hierarchy where this style is the current text editor style.
    ///
    /// - Parameter configuration: The properties of the text editor.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a text editor.
    typealias Configuration = TextEditorStyleConfiguration
}

@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TextEditorStyle where Self == AutomaticTextEditorStyle {

    /// The default text editor style, based on the text editor's context.
    ///
    /// The default style represents the recommended style based on the
    /// current platform and the text editor's context within the view hierarchy.
    public static var automatic: AutomaticTextEditorStyle { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TextEditorStyle where Self == PlainTextEditorStyle {

    /// A text editor style with no decoration.
    public static var plain: PlainTextEditorStyle { get { fatalError() } }
}

/// The properties of a text editor.
@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TextEditorStyleConfiguration {
}

/// A text editor style with no decoration.
///
/// You can also use ``TextEditorStyle/plain`` to create this style.
@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PlainTextEditorStyle : TextEditorStyle {

    /// Creates a view that represents the body of a text editor.
    ///
    /// The system calls this method for each ``TextEditor`` instance in a view
    /// hierarchy where this style is the current text editor style.
    ///
    /// - Parameter configuration: The properties of the text editor.
    public func makeBody(configuration: PlainTextEditorStyle.Configuration) -> some View { return stubView() }


    public init() { fatalError() }

    /// A view that represents the body of a text editor.
//    public typealias Body = some View
}

/// The default text editor style, based on the text editor's context.
///
/// You can also use ``TextEditorStyle/automatic`` to construct this style.
@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct AutomaticTextEditorStyle : TextEditorStyle {

    /// Creates a view that represents the body of a text editor.
    ///
    /// The system calls this method for each ``TextEditor`` instance in a view
    /// hierarchy where this style is the current text editor style.
    ///
    /// - Parameter configuration: The properties of the text editor.
    public func makeBody(configuration: AutomaticTextEditorStyle.Configuration) -> AutomaticTextEditorStyle.Body { Body() }

    public init() { fatalError() }

    /// A view that represents the body of a text editor.
    public struct Body : View {

        @MainActor public var body: NeverView { get { return NeverView() } }

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
    }
}

#endif
