// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if !SKIP
import struct CoreGraphics.CGFloat
#endif

// SKIP @bridge
public final class UIColor {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat

    // SKIP @bridge
    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    #if SKIP
    // We can't resolve actual RGB values unless we're in a @Composable context.
    // Use with `Color(.systemBackground)` to get the adaptive semantic color.
    public static let systemBackground: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    #endif
}

#endif
