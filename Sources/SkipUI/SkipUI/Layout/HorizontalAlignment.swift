// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if !SKIP
#if canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif
#endif

// NOTE: Keep in sync with SkipSwiftUI.HorizontalAlignment
public struct HorizontalAlignment : Equatable, Sendable {
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

    public static let center: HorizontalAlignment = HorizontalAlignment(key: "center")
    public static let leading: HorizontalAlignment = HorizontalAlignment(key: "leading")
    public static let trailing: HorizontalAlignment = HorizontalAlignment(key: "trailing")
    public static let listRowSeparatorLeading = HorizontalAlignment(key: "listRowSeparatorLeading")
    public static let listRowSeparatorTrailing = HorizontalAlignment(key: "listRowSeparatorTrailing")

    #if SKIP
    /// Return the equivalent Compose alignment.
    public func asComposeAlignment() -> androidx.compose.ui.Alignment.Horizontal {
        switch self {
        case .leading:
            return androidx.compose.ui.Alignment.Start
        case .trailing:
            return androidx.compose.ui.Alignment.End
        default:
            return androidx.compose.ui.Alignment.CenterHorizontally
        }
    }
    #endif
}

#endif
