// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A view that shows or hides another content view, based on the state of a
/// disclosure control.
///
/// A disclosure group view consists of a label to identify the contents, and a
/// control to show and hide the contents. Showing the contents puts the
/// disclosure group into the "expanded" state, and hiding them makes the
/// disclosure group "collapsed".
///
/// In the following example, a disclosure group contains two toggles and
/// an embedded disclosure group. The top level disclosure group exposes its
/// expanded state with the bound property, `topLevelExpanded`. By expanding
/// the disclosure group, the user can use the toggles to update the state of
/// the `toggleStates` structure.
///
///     struct ToggleStates {
///         var oneIsOn: Bool = false
///         var twoIsOn: Bool = true
///     }
///     @State private var toggleStates = ToggleStates()
///     @State private var topExpanded: Bool = true
///
///     var body: some View {
///         DisclosureGroup("Items", isExpanded: $topExpanded) {
///             Toggle("Toggle 1", isOn: $toggleStates.oneIsOn)
///             Toggle("Toggle 2", isOn: $toggleStates.twoIsOn)
///             DisclosureGroup("Sub-items") {
///                 Text("Sub-item 1")
///             }
///         }
///     }
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DisclosureGroup<Label, Content> : View where Label : View, Content : View {

    /// Creates a disclosure group with the given label and content views.
    ///
    /// - Parameters:
    ///   - content: The content shown when the disclosure group expands.
    ///   - label: A view that describes the content of the disclosure group.
    public init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates a disclosure group with the given label and content views, and
    /// a binding to the expansion state (expanded or collapsed).
    ///
    /// - Parameters:
    ///   - isExpanded: A binding to a Boolean value that determines the group's
    ///    expansion state (expanded or collapsed).
    ///   - content: The content shown when the disclosure group expands.
    ///   - label: A view that describes the content of the disclosure group.
    public init(isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> Label) { fatalError() }

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

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DisclosureGroup where Label == Text {

    /// Creates a disclosure group, using a provided localized string key to
    /// create a text view for the label.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized label of `self` that describes
    ///     the content of the disclosure group.
    ///   - content: The content shown when the disclosure group expands.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) { fatalError() }

    /// Creates a disclosure group, using a provided localized string key to
    /// create a text view for the label, and a binding to the expansion state
    /// (expanded or collapsed).
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized label of `self` that describes
    ///     the content of the disclosure group.
    ///   - isExpanded: A binding to a Boolean value that determines the group's
    ///    expansion state (expanded or collapsed).
    ///   - content: The content shown when the disclosure group expands.
    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) { fatalError() }

    /// Creates a disclosure group, using a provided string to create a
    /// text view for the label.
    ///
    /// - Parameters:
    ///   - label: A description of the content of the disclosure group.
    ///   - content: The content shown when the disclosure group expands.
    public init<S>(_ label: S, @ViewBuilder content: @escaping () -> Content) where S : StringProtocol { fatalError() }

    /// Creates a disclosure group, using a provided string to create a
    /// text view for the label, and a binding to the expansion state (expanded
    /// or collapsed).
    ///
    /// - Parameters:
    ///   - label: A description of the content of the disclosure group.
    ///   - isExpanded: A binding to a Boolean value that determines the group's
    ///    expansion state (expanded or collapsed).
    ///   - content: The content shown when the disclosure group expands.
    public init<S>(_ label: S, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) where S : StringProtocol { fatalError() }
}

/// A type that specifies the appearance and interaction of disclosure groups
/// within a view hierarchy.
///
/// To configure the disclosure group style for a view hierarchy, use the
/// ``View/disclosureGroupStyle(_:)`` modifier.
///
/// To create a custom disclosure group style, declare a type that conforms
/// to `DisclosureGroupStyle`. Implement the
/// ``DisclosureGroupStyle/makeBody(configuration:)`` method to return a view
/// that composes the elements of the `configuration` that SkipUI provides to
/// your method.
///
///     struct MyDisclosureStyle: DisclosureGroupStyle {
///         func makeBody(configuration: Configuration) -> some View {
///             VStack {
///                 Button {
///                     withAnimation {
///                         configuration.isExpanded.toggle()
///                     }
///                 } label: {
///                     HStack(alignment: .firstTextBaseline) {
///                         configuration.label
///                         Spacer()
///                         Text(configuration.isExpanded ? "hide" : "show")
///                             .foregroundColor(.accentColor)
///                             .font(.caption.lowercaseSmallCaps())
///                             .animation(nil, value: configuration.isExpanded)
///                     }
///                     .contentShape(Rectangle())
///                 }
///                 .buttonStyle(.plain)
///                 if configuration.isExpanded {
///                     configuration.content
///                 }
///             }
///         }
///     }
///
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol DisclosureGroupStyle {

    /// A view that represents the body of a disclosure group.
    associatedtype Body : View

    /// Creates a view that represents the body of a disclosure group.
    ///
    /// SkipUI calls this method for each instance of ``DisclosureGroup``
    /// that you create within a view hierarchy where this style is the current
    /// ``DisclosureGroupStyle``.
    ///
    /// - Parameter configuration: The properties of the instance being created.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a disclosure group instance.
    typealias Configuration = DisclosureGroupStyleConfiguration
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DisclosureGroupStyle where Self == AutomaticDisclosureGroupStyle {

    /// A disclosure group style that resolves its appearance automatically
    /// based on the current context.
    public static var automatic: AutomaticDisclosureGroupStyle { get { fatalError() } }
}

/// The properties of a disclosure group instance.
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DisclosureGroupStyleConfiguration {

    /// A type-erased label of a disclosure group.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// The label for the disclosure group.
    public let label: DisclosureGroupStyleConfiguration.Label = { fatalError() }()

    /// A type-erased content of a disclosure group.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// The content of the disclosure group.
    public let content: DisclosureGroupStyleConfiguration.Content = { fatalError() }()

    /// A binding to a Boolean that indicates whether the disclosure
    /// group is expanded.
//    @Binding public var isExpanded: Bool { get { fatalError() } nonmutating set { fatalError() } }

//    public var $isExpanded: Binding<Bool> { get { fatalError() } }
}

/// A disclosure group style that resolves its appearance automatically
/// based on the current context.
///
/// Use ``DisclosureGroupStyle/automatic`` to construct this style.
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct AutomaticDisclosureGroupStyle : DisclosureGroupStyle {

    /// Creates an automatic disclosure group style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a disclosure group.
    ///
    /// SkipUI calls this method for each instance of ``DisclosureGroup``
    /// that you create within a view hierarchy where this style is the current
    /// ``DisclosureGroupStyle``.
    ///
    /// - Parameter configuration: The properties of the instance being created.
    public func makeBody(configuration: AutomaticDisclosureGroupStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a disclosure group.
//    public typealias Body = some View
}

#endif
