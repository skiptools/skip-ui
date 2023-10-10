// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import struct CoreGraphics.CGFloat

/// Strategies for adapting a presentation to a different size class.
///
/// Use values of this type with the ``View/presentationCompactAdaptation(_:)``
/// and ``View/presentationCompactAdaptation(horizontal:vertical:)`` modifiers.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct PresentationAdaptation : Sendable {

    /// Use the default presentation adaptation.
    public static var automatic: PresentationAdaptation { get { fatalError() } }

    /// Don't adapt for the size class, if possible.
    public static var none: PresentationAdaptation { get { fatalError() } }

    /// Prefer a popover appearance when adapting for size classes.
    public static var popover: PresentationAdaptation { get { fatalError() } }

    /// Prefer a sheet appearance when adapting for size classes.
    public static var sheet: PresentationAdaptation { get { fatalError() } }

    /// Prefer a full-screen-cover appearance when adapting for size classes.
    public static var fullScreenCover: PresentationAdaptation { get { fatalError() } }
}

/// The kinds of interaction available to views behind a presentation.
///
/// Use values of this type with the
/// ``View/presentationBackgroundInteraction(_:)`` modifier.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct PresentationBackgroundInteraction : Sendable {

    /// The default background interaction for the presentation.
    public static var automatic: PresentationBackgroundInteraction { get { fatalError() } }

    /// People can interact with the view behind a presentation.
    public static var enabled: PresentationBackgroundInteraction { get { fatalError() } }

    /// People can interact with the view behind a presentation up through a
    /// specified detent.
    ///
    /// At detents larger than the one you specify, SkipUI disables
    /// interaction.
    ///
    /// - Parameter detent: The largest detent at which people can interact with
    ///   the view behind the presentation.
    public static func enabled(upThrough detent: PresentationDetent) -> PresentationBackgroundInteraction { fatalError() }

    /// People can't interact with the view behind a presentation.
    public static var disabled: PresentationBackgroundInteraction { get { fatalError() } }
}

/// A behavior that you can use to influence how a presentation responds to
/// swipe gestures.
///
/// Use values of this type with the
/// ``View/presentationContentInteraction(_:)`` modifier.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct PresentationContentInteraction : Equatable, Sendable {

    /// The default swipe behavior for the presentation.
    public static var automatic: PresentationContentInteraction { get { fatalError() } }

    /// A behavior that prioritizes resizing a presentation when swiping, rather
    /// than scrolling the content of the presentation.
    public static var resizes: PresentationContentInteraction { get { fatalError() } }

    /// A behavior that prioritizes scrolling the content of a presentation when
    /// swiping, rather than resizing the presentation.
    public static var scrolls: PresentationContentInteraction { get { fatalError() } }

    
}

/// A type that represents a height where a sheet naturally rests.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct PresentationDetent : Hashable, Sendable {

    /// The system detent for a sheet that's approximately half the height of
    /// the screen, and is inactive in compact height.
    public static let medium: PresentationDetent = { fatalError() }()

    /// The system detent for a sheet at full height.
    public static let large: PresentationDetent = { fatalError() }()

    /// A custom detent with the specified fractional height.
    public static func fraction(_ fraction: CGFloat) -> PresentationDetent { fatalError() }

    /// A custom detent with the specified height.
    public static func height(_ height: CGFloat) -> PresentationDetent { fatalError() }

    /// A custom detent with a calculated height.
    public static func custom<D>(_ type: D.Type) -> PresentationDetent where D : CustomPresentationDetent { fatalError() }

    /// Information that you use to calculate the presentation's height.
    @dynamicMemberLookup public struct Context {

        /// The height that the presentation appears in.
        public var maxDetentValue: CGFloat { get { fatalError() } }

        /// Returns the value specified by the keyPath from the environment.
        ///
        /// This uses the environment from where the sheet is shown, not the
        /// environment where the presentation modifier is applied.
        public subscript<T>(dynamicMember keyPath: KeyPath<EnvironmentValues, T>) -> T { get { fatalError() } }
    }
}


/// The definition of a custom detent with a calculated height.
///
/// You can create and use a custom detent with built-in detents.
///
///     extension PresentationDetent {
///         static let bar = Self.custom(BarDetent.self)
///         static let small = Self.height(100)
///         static let extraLarge = Self.fraction(0.75)
///     }
///
///     private struct BarDetent: CustomPresentationDetent {
///         static func height(in context: Context) -> CGFloat? {
///             max(44, context.maxDetentValue * 0.1)
///         }
///     }
///
///     struct ContentView: View {
///         @State private var showSettings = false
///         @State private var selectedDetent = PresentationDetent.bar
///
///         var body: some View {
///             Button("View Settings") {
///                 showSettings = true
///             }
///             .sheet(isPresented: $showSettings) {
///                 SettingsView(selectedDetent: $selectedDetent)
///                     .presentationDetents(
///                         [.bar, .small, .medium, .large, .extraLarge],
///                         selection: $selectedDetent)
///             }
///         }
///     }
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public protocol CustomPresentationDetent {

    /// Calculates and returns a height based on the context.
    ///
    /// - Parameter context: Information that can help to determine the
    ///   height of the detent.
    ///
    /// - Returns: The height of the detent, or `nil` if the detent should be
    ///   inactive based on the `contenxt` input.
    static func height(in context: Self.Context) -> CGFloat?
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension CustomPresentationDetent {

    /// Information that you can use to calculate the height of a custom detent.
    public typealias Context = PresentationDetent.Context
}

/// An indication whether a view is currently presented by another view.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
public struct PresentationMode {

    /// Indicates whether a view is currently presented.
    public var isPresented: Bool { get { fatalError() } }

    /// Dismisses the view if it is currently presented.
    ///
    /// If `isPresented` is false, `dismiss()` is a no-op.
    public mutating func dismiss() { fatalError() }
}

/// A view that represents the content of a presented window.
///
/// You don't create this type directly. ``WindowGroup`` creates values for you.
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PresentedWindowContent<Data, Content> : View where Data : Decodable, Data : Encodable, Data : Hashable, Content : View {

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

extension View {
    public func presentationDetents(_ detents: Set<PresentationDetent>) -> some View {
        return self
    }

    public func presentationDetents(_ detents: Set<PresentationDetent>, selection: Binding<PresentationDetent>) -> some View {
        return self
    }

    public func presentationDragIndicator(_ visibility: Visibility) -> some View {
        return self
    }
}

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension View {

    /// Controls whether people can interact with the view behind a
    /// presentation.
    ///
    /// On many platforms, SkipUI automatically disables the view behind a
    /// sheet that you present, so that people can't interact with the backing
    /// view until they dismiss the sheet. Use this modifier if you want to
    /// enable interaction.
    ///
    /// The following example enables people to interact with the view behind
    /// the sheet when the sheet is at the smallest detent, but not at the other
    /// detents:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents(
    ///                         [.height(120), .medium, .large])
    ///                     .presentationBackgroundInteraction(
    ///                         .enabled(upThrough: .height(120)))
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - interaction: A specification of how people can interact with the
    ///     view behind a presentation.
    public func presentationBackgroundInteraction(_ interaction: PresentationBackgroundInteraction) -> some View { return stubView() }


    /// Specifies how to adapt a presentation to compact size classes.
    ///
    /// Some presentations adapt their appearance depending on the context. For
    /// example, a sheet presentation over a vertically-compact view uses a
    /// full-screen-cover appearance by default. Use this modifier to indicate
    /// a custom adaptation preference. For example, the following code
    /// uses a presentation adaptation value of ``PresentationAdaptation/none``
    /// to request that the system not adapt the sheet in compact size classes:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents([.medium, .large])
    ///                     .presentationCompactAdaptation(.none)
    ///             }
    ///         }
    ///     }
    ///
    /// If you want to specify different adaptations for each dimension,
    /// use the ``View/presentationCompactAdaptation(horizontal:vertical:)``
    /// method instead.
    ///
    /// - Parameter adaptation: The adaptation to use in either a horizontally
    ///   or vertically compact size class.
    public func presentationCompactAdaptation(_ adaptation: PresentationAdaptation) -> some View { return stubView() }


    /// Specifies how to adapt a presentation to horizontally and vertically
    /// compact size classes.
    ///
    /// Some presentations adapt their appearance depending on the context. For
    /// example, a popover presentation over a horizontally-compact view uses a
    /// sheet appearance by default. Use this modifier to indicate a custom
    /// adaptation preference.
    ///
    ///     struct ContentView: View {
    ///         @State private var showInfo = false
    ///
    ///         var body: some View {
    ///             Button("View Info") {
    ///                 showInfo = true
    ///             }
    ///             .popover(isPresented: $showInfo) {
    ///                 InfoView()
    ///                     .presentationCompactAdaptation(
    ///                         horizontal: .popover,
    ///                         vertical: .sheet)
    ///             }
    ///         }
    ///     }
    ///
    /// If you want to specify the same adaptation for both dimensions,
    /// use the ``View/presentationCompactAdaptation(_:)`` method instead.
    ///
    /// - Parameters:
    ///   - horizontalAdaptation: The adaptation to use in a horizontally
    ///     compact size class.
    ///   - verticalAdaptation: The adaptation to use in a vertically compact
    ///     size class. In a size class that is both horizontally and vertically
    ///     compact, SkipUI uses the `verticalAdaptation` value.
    public func presentationCompactAdaptation(horizontal horizontalAdaptation: PresentationAdaptation, vertical verticalAdaptation: PresentationAdaptation) -> some View { return stubView() }


    /// Requests that the presentation have a specific corner radius.
    ///
    /// Use this modifier to change the corner radius of a presentation.
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents([.medium, .large])
    ///                     .presentationCornerRadius(21)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter cornerRadius: The corner radius, or `nil` to use the system
    ///   default.
    public func presentationCornerRadius(_ cornerRadius: CGFloat?) -> some View { return stubView() }


    /// Configures the behavior of swipe gestures on a presentation.
    ///
    /// By default, when a person swipes up on a scroll view in a resizable
    /// presentation, the presentation grows to the next detent. A scroll view
    /// embedded in the presentation only scrolls after the presentation
    /// reaches its largest size. Use this modifier to control which action
    /// takes precedence.
    ///
    /// For example, you can request that swipe gestures scroll content first,
    /// resizing the sheet only after hitting the end of the scroll view, by
    /// passing the ``PresentationContentInteraction/scrolls`` value to this
    /// modifier:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents([.medium, .large])
    ///                     .presentationContentInteraction(.scrolls)
    ///             }
    ///         }
    ///     }
    ///
    /// People can always resize your presentation using the drag indicator.
    ///
    /// - Parameter behavior: The requested behavior.
    public func presentationContentInteraction(_ behavior: PresentationContentInteraction) -> some View { return stubView() }

}

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension View {

    /// Sets the presentation background of the enclosing sheet using a shape
    /// style.
    ///
    /// The following example uses the ``Material/thick`` material as the sheet
    /// background:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationBackground(.thickMaterial)
    ///             }
    ///         }
    ///     }
    ///
    /// The `presentationBackground(_:)` modifier differs from the
    /// ``View/background(_:ignoresSafeAreaEdges:)`` modifier in several key
    /// ways. A presentation background:
    ///
    /// * Automatically fills the entire presentation.
    /// * Allows views behind the presentation to show through translucent
    ///   styles.
    ///
    /// - Parameter style: The shape style to use as the presentation
    ///   background.
    public func presentationBackground<S>(_ style: S) -> some View where S : ShapeStyle { return stubView() }


    /// Sets the presentation background of the enclosing sheet to a custom
    /// view.
    ///
    /// The following example uses a yellow view as the sheet background:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationBackground {
    ///                         Color.yellow
    ///                     }
    ///             }
    ///         }
    ///     }
    ///
    /// The `presentationBackground(alignment:content:)` modifier differs from
    /// the ``View/background(alignment:content:)`` modifier in several key
    /// ways. A presentation background:
    ///
    /// * Automatically fills the entire presentation.
    /// * Allows views behind the presentation to show through translucent
    ///   areas of the `content`.
    ///
    /// - Parameters:
    ///   - alignment: The alignment that the modifier uses to position the
    ///     implicit ``ZStack`` that groups the background views. The default is
    ///     ``Alignment/center``.
    ///   - content: The view to use as the background of the presentation.
    public func presentationBackground<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View { return stubView() }
}

#endif
