// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// No-op
func stubWidget() -> some Widget {
    //return never() // raises warning: “A call to a never-returning function”
    struct NeverWidget : Widget {
        typealias Body = Never
        var body: Body { fatalError() }
    }
    return NeverWidget()
}

/// No-op
func stubWidgetConfiguration() -> some WidgetConfiguration {
    //return never() // raises warning: “A call to a never-returning function”
    struct NeverWidgetConfiguration : WidgetConfiguration {
        typealias Body = Never
        var body: Body { fatalError() }
    }
    return NeverWidgetConfiguration()
}

/// The configuration and content of a widget to display on the Home screen or
/// in Notification Center.
///
/// Widgets show glanceable and relevant content from your app right on the iOS
/// Home screen or in Notification Center on macOS. Users can add, configure, and
/// arrange widgets to suit their individual needs. You can provide multiple
/// types of widgets, each presenting a specific kind of information. When
/// users want more information, like to read the full article for a headline
/// or to see the details of a package delivery, the widget lets them get to
/// the information in your app quickly.
///
/// There are three key components to a widget:
///
/// * A configuration that determines whether the widget is configurable,
///   identifies the widget, and defines the SkipUI views that show the
///   widget's content.
/// * A timeline provider that drives the process of updating the widget's view
///   over time.
/// * SkipUI views used by WidgetKit to display the widget.
///
/// For information about adding a widget extension to your app, and keeping
/// your widget up to date, see
/// 
/// and
/// ,
/// respectively.
///
/// By adding a custom SiriKit intent definition, you can let users customize
/// their widgets to show the information that's most relevant to them. If
/// you've already added support for Siri or Shortcuts, you're well on your way
/// to supporting customizable widgets. For more information, see
/// .
@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public protocol Widget {

    /// The type of configuration representing the content of the widget.
    ///
    /// When you create a custom widget, Swift infers this type from your
    /// implementation of the required ``Widget/body-swift.property`` property.
    associatedtype Body : WidgetConfiguration

    /// Creates a widget using `body` as its content.
    init()

    /// The content and behavior of the widget.
    ///
    /// For any widgets that you create, provide a computed `body` property that
    /// defines the widget as a composition of SkipUI views.
    ///
    /// Swift infers the widget's ``SkipUI/Scene/Body-swift.associatedtype``
    /// associated type based on the contents of the `body` property.
    var body: Self.Body { get }
}

/// A container used to expose multiple widgets from a single widget extension.
///
/// To support multiple types of widgets, add the `@main` attribute to a
/// structure that conforms to `WidgetBundle`. For example, a game might have
/// one widget to display summary information about the game and a second
/// widget to display detailed information about individual characters.
///
///     @main
///     struct GameWidgets: WidgetBundle {
///        var body: some Widget {
///            GameStatusWidget()
///            CharacterDetailWidget()
///        }
///     }
///
@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public protocol WidgetBundle {

    /// The type of widget that represents the content of the bundle.
    ///
    /// When you support more than one widget, Swift infers this type from your
    /// implementation of the required ``WidgetBundle/body-swift.property``
    /// property.
    associatedtype Body : Widget

    /// Creates a widget bundle using the bundle's body as its content.
    init()

    /// Declares the group of widgets that an app supports.
    ///
    /// The order that the widgets appear in this property determines the order
    /// they are shown to the user when adding a widget. The following example
    /// shows how to use a widget bundle builder to define a body showing
    /// a game status widget first and a character detail widget second:
    ///
    ///     @main
    ///     struct GameWidgets: WidgetBundle {
    ///        var body: some Widget {
    ///            GameStatusWidget()
    ///            CharacterDetailWidget()
    ///        }
    ///     }
    ///
    @WidgetBundleBuilder var body: Self.Body { get }
}

/// A custom attribute that constructs a widget bundle's body.
///
/// Use the `@WidgetBundleBuilder` attribute to group multiple widgets listed
/// in the ``WidgetBundle/body-swift.property`` property of a widget bundle.
/// For example, the following code defines a widget bundle that consists of
/// two widgets.
///
///     @main
///     struct GameWidgets: WidgetBundle {
///        @WidgetBundleBuilder
///        var body: some Widget {
///            GameStatusWidget()
///            CharacterDetailWidget()
///        }
///     }
@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@resultBuilder public struct WidgetBundleBuilder {

    /// Builds an expression within the builder.
    public static func buildExpression<Content>(_ content: Content) -> Content where Content : Widget { fatalError() }

    /// Builds an empty Widget from a block containing no statements, `{ }`.
    public static func buildBlock() -> some Widget { stubWidget() }


    /// Builds a single Widget written as a child view (e..g, `{ MyWidget() }`)
    /// through unmodified.
    public static func buildBlock<Content>(_ content: Content) -> some Widget where Content : Widget { stubWidget() }

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension WidgetBundleBuilder {

    /// Provides support for "if" statements in multi-statement closures,
    /// producing an optional widget that is visible only when the condition
    /// evaluates to `true`.
    ///
    /// "if" statement in a ``WidgetBundleBuilder`` are limited to only
    /// `#available()` clauses.
//    public static func buildOptional(_ widget: (Widget & _LimitedAvailabilityWidgetMarker)?) -> some Widget { fatalError() }


    /// Provides support for "if" statements with `#available()` clauses in
    /// multi-statement closures, producing conditional content for the "then"
    /// branch, i.e. the conditionally-available branch.
//    public static func buildLimitedAvailability(_ widget: some Widget) -> Widget & _LimitedAvailabilityWidgetMarker { fatalError() }
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension WidgetBundleBuilder {

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> some Widget where C0 : Widget, C1 : Widget { stubWidget() }

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension WidgetBundleBuilder {

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> some Widget where C0 : Widget, C1 : Widget, C2 : Widget { stubWidget() }

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension WidgetBundleBuilder {

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> some Widget where C0 : Widget, C1 : Widget, C2 : Widget, C3 : Widget { stubWidget() }

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension WidgetBundleBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> some Widget where C0 : Widget, C1 : Widget, C2 : Widget, C3 : Widget, C4 : Widget { stubWidget() }

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension WidgetBundleBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> some Widget where C0 : Widget, C1 : Widget, C2 : Widget, C3 : Widget, C4 : Widget, C5 : Widget { stubWidget() }

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension WidgetBundleBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> some Widget where C0 : Widget, C1 : Widget, C2 : Widget, C3 : Widget, C4 : Widget, C5 : Widget, C6 : Widget { stubWidget() }

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension WidgetBundleBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> some Widget where C0 : Widget, C1 : Widget, C2 : Widget, C3 : Widget, C4 : Widget, C5 : Widget, C6 : Widget, C7 : Widget { stubWidget() }

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension WidgetBundleBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> some Widget where C0 : Widget, C1 : Widget, C2 : Widget, C3 : Widget, C4 : Widget, C5 : Widget, C6 : Widget, C7 : Widget, C8 : Widget { stubWidget() }

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension WidgetBundleBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> some Widget where C0 : Widget, C1 : Widget, C2 : Widget, C3 : Widget, C4 : Widget, C5 : Widget, C6 : Widget, C7 : Widget, C8 : Widget, C9 : Widget { stubWidget() }

}

/// A type that describes a widget's content.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public protocol WidgetConfiguration {

    /// The type of widget configuration representing the body of
    /// this configuration.
    ///
    /// When you create a custom widget, Swift infers this type from your
    /// implementation of the required `body` property.
    associatedtype Body : WidgetConfiguration

    /// The content and behavior of this widget.
    var body: Self.Body { get }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension WidgetConfiguration {

    /// Runs the given action when the system provides a background task.
    ///
    /// When the system wakes your app or extension for one or more background
    /// tasks, it will call any actions associated with matching tasks. When your
    /// async actions return, the system will put your app back into a suspended
    /// state. In Widget Extensions, this modifier can be used to handle URL Session
    /// background tasks with ``BackgroundTask/urlSession``.
    ///
    /// - Parameters:
    ///    - task: The type of task the action responds to.
    ///    - action: The closure that is called when the system provides
    ///      a task matching the provided task.
    public func backgroundTask<D, R>(_ task: BackgroundTask<D, R>, action: @escaping @Sendable (D) async -> R) -> some WidgetConfiguration where D : Sendable, R : Sendable { stubWidgetConfiguration() }

}

/// An empty widget configuration.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@frozen public struct EmptyWidgetConfiguration : WidgetConfiguration {

    @inlinable public init() { fatalError() }

    /// The type of widget configuration representing the body of
    /// this configuration.
    ///
    /// When you create a custom widget, Swift infers this type from your
    /// implementation of the required `body` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension EmptyWidgetConfiguration : Sendable {
}


@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension Never : WidgetConfiguration {
}


extension Never : Widget {
    public init() {
        fatalError()
    }

}

#endif
