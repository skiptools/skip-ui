// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if false


/// Defines the implementation of all `IndexView` instances within a view
/// hierarchy.
///
/// To configure the current `IndexViewStyle` for a view hierarchy, use the
/// `.indexViewStyle()` modifier.
@available(iOS 14.0, tvOS 14.0, watchOS 8.0, *)
@available(macOS, unavailable)
public protocol IndexViewStyle {
}

@available(iOS 14.0, tvOS 14.0, watchOS 8.0, *)
@available(macOS, unavailable)
extension IndexViewStyle where Self == PageIndexViewStyle {

    /// An index view style that places a page index view over its content.
    public static var page: PageIndexViewStyle { get { fatalError() } }

    /// An index view style that places a page index view over its content.
    ///
    /// - Parameter backgroundDisplayMode: The display mode of the background of
    ///   any page index views receiving this style
    public static func page(backgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode) -> PageIndexViewStyle { fatalError() }
}

@available(iOS 14.0, tvOS 14.0, watchOS 8.0, *)
@available(macOS, unavailable)
extension View {

    /// Sets the style for the index view within the current environment.
    ///
    /// - Parameter style: The style to apply to this view.
    public func indexViewStyle<S>(_ style: S) -> some View where S : IndexViewStyle { return stubView() }

}

#endif
