// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// An effect applied when the pointer hovers over a view.
@available(iOS 13.4, tvOS 16.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct HoverEffect {

    /// An effect  that attempts to determine the effect automatically.
    /// This is the default effect.
    public static let automatic: HoverEffect = { fatalError() }()

    /// An effect  that morphs the pointer into a platter behind the view
    /// and shows a light source indicating position.
    ///
    /// On tvOS, it applies a projection effect accompanied with a specular
    /// highlight on the view when contained within a focused view. It also
    /// incorporates motion effects to produce a parallax effect by adjusting
    /// the projection matrix and specular offset.
    @available(tvOS 17.0, *)
    public static let highlight: HoverEffect = { fatalError() }()

    /// An effect that slides the pointer under the view and disappears as the
    /// view scales up and gains a shadow.
    public static let lift: HoverEffect = { fatalError() }()
}


#endif
