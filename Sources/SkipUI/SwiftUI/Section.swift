// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// A container view that you can use to add hierarchy to certain collection views.
///
/// Use `Section` instances in views like ``List``, ``Picker``, and
/// ``Form`` to organize content into separate sections. Each section has
/// custom content that you provide on a per-instance basis. You can also
/// provide headers and footers for each section.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Section<Parent, Content, Footer> {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Section : View where Parent : View, Content : View, Footer : View {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Section where Parent : View, Content : View, Footer : View {

    /// Creates a section with a header, footer, and the provided section
    /// content.
    ///
    /// - Parameters:
    ///   - content: The section's content.
    ///   - header: A view to use as the section's header.
    ///   - footer: A view to use as the section's footer.
    public init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent, @ViewBuilder footer: () -> Footer) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Section where Parent == EmptyView, Content : View, Footer : View {

    /// Creates a section with a footer and the provided section content.
    /// - Parameters:
    ///   - content: The section's content.
    ///   - footer: A view to use as the section's footer.
    public init(@ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Section where Parent : View, Content : View, Footer == EmptyView {

    /// Creates a section with a header and the provided section content.
    /// - Parameters:
    ///   - content: The section's content.
    ///   - header: A view to use as the section's header.
    public init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Section where Parent == EmptyView, Content : View, Footer == EmptyView {

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - content: The section's content.
    public init(@ViewBuilder content: () -> Content) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Section where Parent == Text, Content : View, Footer == EmptyView {

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - titleKey: The key for the section's localized title, which describes
    ///     the contents of the section.
    ///   - content: The section's content.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - title: A string that describes the contents of the section.
    ///   - content: The section's content.
    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, xrOS 1.0, *)
extension Section where Parent == Text, Content : View, Footer == EmptyView {

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - titleKey: The key for the section's localized title, which describes
    ///     the contents of the section.
    ///   - isExpanded: A binding to a Boolean value that determines the section's
    ///    expansion state (expanded or collapsed).
    ///   - content: The section's content.
    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - title: A string that describes the contents of the section.
    ///   - isExpanded: A binding to a Boolean value that determines the section's
    ///    expansion state (expanded or collapsed).
    ///   - content: The section's content.
    public init<S>(_ title: S, isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content) where S : StringProtocol { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, xrOS 1.0, *)
extension Section where Parent : View, Content : View, Footer == EmptyView {

    /// Creates a section with a header, the provided section content, and a binding
    /// representing the section's expansion state.
    ///
    /// - Parameters:
    ///   - isExpanded: A binding to a Boolean value that determines the section's
    ///    expansion state (expanded or collapsed).
    ///   - content: The section's content.
    ///   - header: A view to use as the section's header.
    public init(isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Section where Parent : View, Content : View, Footer : View {

    /// Creates a section with a header, footer, and the provided section content.
    /// - Parameters:
    ///   - header: A view to use as the section's header.
    ///   - footer: A view to use as the section's footer.
    ///   - content: The section's content.
    @available(iOS, deprecated: 100000.0, renamed: "Section(content:header:footer:)")
    @available(macOS, deprecated: 100000.0, renamed: "Section(content:header:footer:)")
    @available(tvOS, deprecated: 100000.0, renamed: "Section(content:header:footer:)")
    @available(watchOS, deprecated: 100000.0, renamed: "Section(content:header:footer:)")
    @available(xrOS, deprecated: 100000.0, renamed: "Section(content:header:footer:)")
    public init(header: Parent, footer: Footer, @ViewBuilder content: () -> Content) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Section where Parent == EmptyView, Content : View, Footer : View {

    /// Creates a section with a footer and the provided section content.
    /// - Parameters:
    ///   - footer: A view to use as the section's footer.
    ///   - content: The section's content.
    @available(iOS, deprecated: 100000.0, renamed: "Section(content:footer:)")
    @available(macOS, deprecated: 100000.0, renamed: "Section(content:footer:)")
    @available(tvOS, deprecated: 100000.0, renamed: "Section(content:footer:)")
    @available(watchOS, deprecated: 100000.0, renamed: "Section(content:footer:)")
    @available(xrOS, deprecated: 100000.0, renamed: "Section(content:footer:)")
    public init(footer: Footer, @ViewBuilder content: () -> Content) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Section where Parent : View, Content : View, Footer == EmptyView {

    /// Creates a section with a header and the provided section content.
    /// - Parameters:
    ///   - header: A view to use as the section's header.
    ///   - content: The section's content.
    @available(iOS, deprecated: 100000.0, renamed: "Section(content:header:)")
    @available(macOS, deprecated: 100000.0, renamed: "Section(content:header:)")
    @available(tvOS, deprecated: 100000.0, renamed: "Section(content:header:)")
    @available(watchOS, deprecated: 100000.0, renamed: "Section(content:header:)")
    @available(xrOS, deprecated: 100000.0, renamed: "Section(content:header:)")
    public init(header: Parent, @ViewBuilder content: () -> Content) { fatalError() }
}
