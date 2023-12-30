// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct ControlGroup : View {
    @available(*, unavailable)
    public init(@ViewBuilder content: () -> ComposeView) {
    }

    @available(*, unavailable)
    public init(@ViewBuilder content: () -> ComposeView, @ViewBuilder label: () -> ComposeView) /* where Content == LabeledControlGroupContent<C, L>, C : View, L : View */ {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> ComposeView) /* where Content == LabeledControlGroupContent<C, Text>, C : View */ {
    }

    @available(*, unavailable)
    public init(_ title: String, @ViewBuilder content: () -> ComposeView) /* where Content == LabeledControlGroupContent<C, Text> */ {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}

public struct ControlGroupStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = ControlGroupStyle(rawValue: 0)

    @available(*, unavailable)
    public static let navigation = ControlGroupStyle(rawValue: 1)

    @available(*, unavailable)
    public static let palette = ControlGroupStyle(rawValue: 2)

    @available(*, unavailable)
    public static let menu = ControlGroupStyle(rawValue: 3)

    @available(*, unavailable)
    public static let compactMenu = ControlGroupStyle(rawValue: 4)
}

extension View {
    public func controlGroupStyle(_ style: ControlGroupStyle) -> some View {
        return self
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

//@available(watchOS, unavailable)
//extension ControlGroup where Content == ControlGroupStyleConfiguration.Content {
//
//    /// Creates a control group based on a style configuration.
//    ///
//    /// Use this initializer within the
//    /// ``ControlGroupStyle/makeBody(configuration:)`` method of a
//    /// ``ControlGroupStyle`` instance to create an instance of the control group
//    /// being styled. This is useful for custom control group styles that modify
//    /// the current control group style.
//    ///
//    /// For example, the following code creates a new, custom style that places a
//    /// red border around the current control group:
//    ///
//    ///     struct RedBorderControlGroupStyle: ControlGroupStyle {
//    ///         func makeBody(configuration: Configuration) -> some View {
//    ///             ControlGroup(configuration)
//    ///                 .border(Color.red)
//    ///         }
//    ///     }
//    ///
//    public init(_ configuration: ControlGroupStyleConfiguration) { fatalError() }
//}

/// The properties of a control group.
@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct ControlGroupStyleConfiguration {

    /// A type-erased content of a `ControlGroup`.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A view that represents the content of the `ControlGroup`.
    public let content: ControlGroupStyleConfiguration.Content = { fatalError() }()

    /// A type-erased label of a ``ControlGroup``.
    @available(iOS 16.0, macOS 13.0, *)
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A view that provides the optional label of the ``ControlGroup``.
    @available(iOS 16.0, macOS 13.0, *)
    public let label: ControlGroupStyleConfiguration.Label = { fatalError() }()
}

#endif
