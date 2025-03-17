// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if !SKIP
#if canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif
#endif

// NOTE: Keep in sync with SkipFuseUI.VerticalAlignment
public struct VerticalAlignment : Equatable {
    let key: String

    init(key: String) {
        self.key = key
    }

    @available(*, unavailable)
    public init(_ id: Any /* AlignmentID.Type */) {
        key = ""
    }

    @available(*, unavailable)
    public func combineExplicit(_ values: any Sequence<CGFloat?>) -> CGFloat? {
        fatalError()
    }

    public static let center = VerticalAlignment(key: "center")
    public static let top = VerticalAlignment(key: "top")
    public static let bottom = VerticalAlignment(key: "bottom")
    public static let firstTextBaseline = VerticalAlignment(key: "firstTextBaseline")
    public static let lastTextBaseline = VerticalAlignment(key: "lastTextBaseline")

    #if SKIP
    /// Return the equivalent Compose alignment.
    public func asComposeAlignment() -> androidx.compose.ui.Alignment.Vertical {
        switch self {
        case .bottom:
            return androidx.compose.ui.Alignment.Bottom
        case .top:
            return androidx.compose.ui.Alignment.Top
        default:
            return androidx.compose.ui.Alignment.CenterVertically
        }
    }
    #endif
}

#endif
