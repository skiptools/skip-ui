// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP


/// A stylized view, with an optional label, that visually collects a logical
/// grouping of content.
///
/// Use a group box when you want to visually distinguish a portion of your
/// user interface with an optional title for the boxed content.
///
/// The following example sets up a `GroupBox` with the label "End-User
/// Agreement", and a long `agreementText` string in a ``SkipUI/Text`` view
/// wrapped by a ``SkipUI/ScrollView``. The box also contains a
/// ``SkipUI/Toggle`` for the user to interact with after reading the text.
///
///     var body: some View {
///         GroupBox(label:
///             Label("End-User Agreement", systemImage: "building.columns")
///         ) {
///             ScrollView(.vertical, showsIndicators: true) {
///                 Text(agreementText)
///                     .font(.footnote)
///             }
///             .frame(height: 100)
///             Toggle(isOn: $userAgreed) {
///                 Text("I agree to the above terms")
///             }
///         }
///     }
///
/// ![An iOS status bar above a gray rounded rectangle region marking the bounds
/// of the group box. At the top of the region, the title End-User Agreement
/// in a large bold font with an icon of a building with columns. Below this,
/// a scroll view with six lines of text visible. At the bottom of the gray
/// group box region, a toggle switch with the label I agree to the above
/// terms.](SkipUI-GroupBox-EULA.png)
///
@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct GroupBox<Label, Content> : View where Label : View, Content : View {

    /// Creates a group box with the provided label and view content.
    /// - Parameters:
    ///   - content: A ``SkipUI/ViewBuilder`` that produces the content for the
    ///     group box.
    ///   - label: A ``SkipUI/ViewBuilder`` that produces a label for the group
    ///     box.
    @available(iOS 14.0, macOS 10.15, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) { fatalError() }

    @MainActor public var body: some View { get { return stubView() } }

//    public typealias Body = some View
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension GroupBox where Label == GroupBoxStyleConfiguration.Label, Content == GroupBoxStyleConfiguration.Content {

    /// Creates a group box based on a style configuration.
    ///
    /// Use this initializer within the ``GroupBoxStyle/makeBody(configuration:)``
    /// method of a ``GroupBoxStyle`` instance to create a styled group box,
    /// with customizations, while preserving its existing style.
    ///
    /// The following example adds a pink border around the group box,
    /// without overriding its current style:
    ///
    ///     struct PinkBorderGroupBoxStyle: GroupBoxStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             GroupBox(configuration)
    ///                 .border(Color.pink)
    ///         }
    ///     }
    /// - Parameter configuration: The properties of the group box instance being created.
    public init(_ configuration: GroupBoxStyleConfiguration) { fatalError() }
}

@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension GroupBox where Label == EmptyView {

    /// Creates an unlabeled group box with the provided view content.
    /// - Parameters:
    ///   - content: A ``SkipUI/ViewBuilder`` that produces the content for
    ///    the group box.
    public init(@ViewBuilder content: () -> Content) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension GroupBox where Label == Text {

    /// Creates a group box with the provided view content and title.
    /// - Parameters:
    ///   - titleKey: The key for the group box's title, which describes the
    ///     content of the group box.
    ///   - content: A ``SkipUI/ViewBuilder`` that produces the content for the
    ///     group box.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a group box with the provided view content.
    /// - Parameters:
    ///   - title: A string that describes the content of the group box.
    ///   - content: A ``SkipUI/ViewBuilder`` that produces the content for the
    ///     group box.
    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol { fatalError() }
}

@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension GroupBox {

    @available(iOS, deprecated: 100000.0, renamed: "GroupBox(content:label:)")
    @available(macOS, deprecated: 100000.0, renamed: "GroupBox(content:label:)")
    @available(xrOS, deprecated: 100000.0, renamed: "GroupBox(content:label:)")
    public init(label: Label, @ViewBuilder content: () -> Content) { fatalError() }
}

/// A type that specifies the appearance and interaction of all group boxes
/// within a view hierarchy.
///
/// To configure the current `GroupBoxStyle` for a view hierarchy, use the
/// ``View/groupBoxStyle(_:)`` modifier.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol GroupBoxStyle {

    /// A view that represents the body of a group box.
    associatedtype Body : View

    /// Creates a view representing the body of a group box.
    ///
    /// SkipUI calls this method for each instance of ``SkipUI/GroupBox``
    /// created within a view hierarchy where this style is the current
    /// group box style.
    ///
    /// - Parameter configuration: The properties of the group box instance being
    ///   created.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a group box instance.
    typealias Configuration = GroupBoxStyleConfiguration
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Sets the style for group boxes within this view.
    ///
    /// - Parameter style: The style to apply to boxes within this view.
    public func groupBoxStyle<S>(_ style: S) -> some View where S : GroupBoxStyle { return stubView() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension GroupBoxStyle where Self == DefaultGroupBoxStyle {

    /// The default style for group box views.
    public static var automatic: DefaultGroupBoxStyle { get { fatalError() } }
}

/// The properties of a group box instance.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct GroupBoxStyleConfiguration {

    /// A type-erased label of a group box.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A type-erased content of a group box.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A view that provides the title of the group box.
    public let label: GroupBoxStyleConfiguration.Label = { fatalError() }()

    /// A view that represents the content of the group box.
    public let content: GroupBoxStyleConfiguration.Content = { fatalError() }()
}

/// The default style for group box views.
///
/// You can also use ``GroupBoxStyle/automatic`` to construct this style.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DefaultGroupBoxStyle : GroupBoxStyle {

    public init() { fatalError() }

    /// Creates a view representing the body of a group box.
    ///
    /// SkipUI calls this method for each instance of ``SkipUI/GroupBox``
    /// created within a view hierarchy where this style is the current
    /// group box style.
    ///
    /// - Parameter configuration: The properties of the group box instance being
    ///   created.
    public func makeBody(configuration: DefaultGroupBoxStyle.Configuration) -> some View { return stubView() }


    /// A view that represents the body of a group box.
//    public typealias Body = some View
}

#endif
