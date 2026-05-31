// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
/// The contrast between the app's foreground and background colors.
///
/// You receive a contrast value when you read the
/// ``EnvironmentValues/colorSchemeContrast`` environment value. The value
/// tells you if a standard or increased contrast currently applies to the view.
/// SkipUI updates the value whenever the contrast changes, and redraws
/// views that depend on the value. For example, the following ``Text`` view
/// automatically updates when the user enables increased contrast:
///
///     @Environment(\.colorSchemeContrast) private var colorSchemeContrast
///
///     var body: some View {
///         Text(colorSchemeContrast == .standard ? "Standard" : "Increased")
///     }
///
/// The user sets the contrast by selecting the Increase Contrast option in
/// Accessibility > Display in System Preferences on macOS, or
/// Accessibility > Display & Text Size in the Settings app on iOS.
/// Your app can't override the user's choice.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
// SKIP @bridgeMembers
public enum ColorSchemeContrast : Int, CaseIterable, Sendable {
    case standard = 0 // For bridging
    case increased = 1 // For bridging

    


    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ColorSchemeContrast]

    /// A collection of all values of this type.
    public static var allCases: [ColorSchemeContrast] { get { fatalError() } }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorSchemeContrast : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorSchemeContrast : Hashable {
}
#endif