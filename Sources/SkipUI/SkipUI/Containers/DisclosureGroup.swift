// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// Erase the generic Label to facilitate specialized constructor support.
// SKIP DECLARE: class DisclosureGroup<Content>: View where Content: View
public struct DisclosureGroup<Label, Content> : View where Label : View, Content : View {
    @available(*, unavailable)
    public init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> any View) {
    }

    @available(*, unavailable)
    public init(isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
    }

    @available(*, unavailable)
    public init(_ label: String, @ViewBuilder content: @escaping () -> Content) {
    }

    @available(*, unavailable)
    public init(_ label: String, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}

public struct DisclosureGroupStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = DisclosureGroupStyle(rawValue: 0)
}

extension View {
    public func disclosureGroupStyle(_ style: DisclosureGroupStyle) -> some View {
        // We only support the single .automatic style
        return self
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

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
//    @Binding public var isExpanded: Bool { get { fatalError() } nonmutating set { } }

//    public var $isExpanded: Binding<Bool> { get { fatalError() } }
}

#endif
