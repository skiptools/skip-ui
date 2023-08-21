// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// The possible color schemes, corresponding to the light and dark appearances.
///
/// You receive a color scheme value when you read the
/// ``EnvironmentValues/colorScheme`` environment value. The value tells you if
/// a light or dark appearance currently applies to the view. SkipUI updates
/// the value whenever the appearance changes, and redraws views that
/// depend on the value. For example, the following ``Text`` view automatically
/// updates when the user enables Dark Mode:
///
///     @Environment(\.colorScheme) private var colorScheme
///
///     var body: some View {
///         Text(colorScheme == .dark ? "Dark" : "Light")
///     }
///
/// Set a preferred appearance for a particular view hierarchy to override
/// the user's Dark Mode setting using the ``View/preferredColorScheme(_:)``
/// view modifier.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum ColorScheme : CaseIterable, Sendable {

    /// The color scheme that corresponds to a light appearance.
    case light

    /// The color scheme that corresponds to a dark appearance.
    case dark

    


    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ColorScheme]

    /// A collection of all values of this type.
    public static var allCases: [ColorScheme] { get { fatalError() } }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorScheme : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorScheme : Hashable {
}


#endif
