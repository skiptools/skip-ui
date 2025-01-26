// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if !SKIP
#if canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif
#endif

public struct VerticalAlignment : Equatable, Sendable {
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

    public static let top = VerticalAlignment(key: "top")
    public static let center = VerticalAlignment(key: "center")
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
