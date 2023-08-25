// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import class CoreGraphics.CGColor

/// A control used to select a color from the system color picker UI.
///
/// The color picker provides a color well that shows the currently selected
/// color, and displays the larger system color picker that allows users to
/// select a new color.
///
/// By default color picker supports colors with opacity; to disable opacity
/// support, set the `supportsOpacity` parameter to `false`.
/// In this mode the color picker won't show controls for adjusting the opacity
/// of the selected color, and strips out opacity from any color set
/// programmatically or selected from the user's system favorites.
///
/// You use `ColorPicker` by embedding it inside a view hierarchy and
/// initializing it with a title string and a ``Binding`` to a ``Color``:
///
///     struct FormattingControls: View {
///         @State private var bgColor =
///             Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
///
///         var body: some View {
///             VStack {
///                 ColorPicker("Alignment Guides", selection: $bgColor)
///             }
///         }
///     }
///
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct ColorPicker<Label> : View where Label : View {

    /// Creates an instance that selects a color.
    ///
    /// - Parameters:
    ///     - selection: A ``Binding`` to the variable that displays the
    ///       selected ``Color``.
    ///     - supportsOpacity: A Boolean value that indicates whether the color
    ///       picker allows adjusting the selected color's opacity; the default
    ///       is `true`.
    ///     - label: A view that describes the use of the selected color.
    ///        The system color picker UI sets it's title using the text from
    ///        this view.
    ///
    public init(selection: Binding<Color>, supportsOpacity: Bool = true, @ViewBuilder label: () -> Label) { fatalError() }

    /// Creates an instance that selects a color.
    ///
    /// - Parameters:
    ///     - selection: A ``Binding`` to the variable that displays the
    ///       selected ``CGColor``.
    ///     - supportsOpacity: A Boolean value that indicates whether the color
    ///       picker allows adjusting the selected color's opacity; the default
    ///       is `true`.
    ///     - label: A view that describes the use of the selected color.
    ///        The system color picker UI sets it's title using the text from
    ///        this view.
    ///
    public init(selection: Binding<CGColor>, supportsOpacity: Bool = true, @ViewBuilder label: () -> Label) { fatalError() }

    @MainActor public var body: some View { get { return stubView() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
//    public typealias Body = some View
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ColorPicker where Label == Text {

    /// Creates a color picker with a text label generated from a title string key.
    ///
    /// Use ``ColorPicker`` to create a color well that your app uses to allow
    /// the selection of a ``Color``. The example below creates a color well
    /// using a ``Binding`` to a property stored in a settings object and title
    /// you provide:
    ///
    ///     final class Settings: ObservableObject {
    ///         @Published var alignmentGuideColor =
    ///             Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    ///     }
    ///
    ///     struct FormattingControls: View {
    ///         @State private var settings = Settings()
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 // Other formatting controls.
    ///                 ColorPicker("Alignment Guides",
    ///                     selection: $settings.alignmentGuideColor
    ///                 )
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the picker.
    ///   - selection: A ``Binding`` to the variable that displays the
    ///     selected ``Color``.
    ///   - supportsOpacity: A Boolean value that indicates whether the color
    ///     picker allows adjustments to the selected color's opacity; the
    ///     default is `true`.
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Color>, supportsOpacity: Bool = true) { fatalError() }

    /// Creates a color picker with a text label generated from a title string.
    ///
    /// Use ``ColorPicker`` to create a color well that your app uses to allow
    /// the selection of a ``Color``. The example below creates a color well
    /// using a ``Binding`` and title you provide:
    ///
    ///     func showColorPicker(_ title: String, color: Binding<Color>) {
    ///         ColorPicker(title, selection: color)
    ///     }
    ///
    /// - Parameters:
    ///   - title: The title displayed by the color picker.
    ///   - selection: A ``Binding`` to the variable containing a ``Color``.
    ///   - supportsOpacity: A Boolean value that indicates whether the color
    ///     picker allows adjustments to the selected color's opacity; the
    ///     default is `true`.
    public init<S>(_ title: S, selection: Binding<Color>, supportsOpacity: Bool = true) where S : StringProtocol { fatalError() }

    /// Creates a color picker with a text label generated from a title string key.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the picker.
    ///   - selection: A ``Binding`` to the variable that displays the
    ///     selected ``CGColor``.
    ///   - supportsOpacity: A Boolean value that indicates whether the color
    ///     picker allows adjustments to the selected color's opacity; the
    ///     default is `true`.
    public init(_ titleKey: LocalizedStringKey, selection: Binding<CGColor>, supportsOpacity: Bool = true) { fatalError() }

    /// Creates a color picker with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - title: The title displayed by the color picker.
    ///   - selection: A ``Binding`` to the variable containing a ``CGColor``.
    ///   - supportsOpacity: A Boolean value that indicates whether the color
    ///     picker allows adjustments to the selected color's opacity; the
    ///     default is `true`.
    public init<S>(_ title: S, selection: Binding<CGColor>, supportsOpacity: Bool = true) where S : StringProtocol { fatalError() }
}

#endif
