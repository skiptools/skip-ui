// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import struct CoreGraphics.CGFloat

/// A style to use when rendering shadows.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ShadowStyle : Equatable, Sendable {

    /// Creates a custom drop shadow style.
    ///
    /// Drop shadows draw behind the source content by blurring,
    /// tinting and offsetting its per-pixel alpha values.
    ///
    /// - Parameters:
    ///   - color: The shadow's color.
    ///   - radius: The shadow's size.
    ///   - x: A horizontal offset you use to position the shadow
    ///     relative to this view.
    ///   - y: A vertical offset you use to position the shadow
    ///     relative to this view.
    ///
    /// - Returns: A new shadow style.
    public static func drop(color: Color = .init(/* .sRGBLinear, */ white: 0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> ShadowStyle { fatalError() }

    /// Creates a custom inner shadow style.
    ///
    /// Inner shadows draw on top of the source content by blurring,
    /// tinting, inverting and offsetting its per-pixel alpha values.
    ///
    /// - Parameters:
    ///   - color: The shadow's color.
    ///   - radius: The shadow's size.
    ///   - x: A horizontal offset you use to position the shadow
    ///     relative to this view.
    ///   - y: A vertical offset you use to position the shadow
    ///     relative to this view.
    ///
    /// - Returns: A new shadow style.
    public static func inner(color: Color = .init(/* .sRGBLinear, */ white: 0, opacity: 0.55), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> ShadowStyle { fatalError() }

    
}

#endif
