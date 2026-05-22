// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE

// NOTE: Keep in sync with SkipSwiftUI.Alignment
public struct Alignment : Equatable, Sendable {
    public var horizontal: HorizontalAlignment
    public var vertical: VerticalAlignment

    public static let center = Alignment(horizontal: .center, vertical: .center)
    public static let leading = Alignment(horizontal: .leading, vertical: .center)
    public static let trailing = Alignment(horizontal: .trailing, vertical: .center)
    public static let top = Alignment(horizontal: .center, vertical: .top)
    public static let bottom = Alignment(horizontal: .center, vertical: .bottom)
    public static let topLeading = Alignment(horizontal: .leading, vertical: .top)
    public static let topTrailing = Alignment(horizontal: .trailing, vertical: .top)
    public static let bottomLeading = Alignment(horizontal: .leading, vertical: .bottom)
    public static let bottomTrailing = Alignment(horizontal: .trailing, vertical: .bottom)

    public static let centerFirstTextBaseline = Alignment(horizontal: .center, vertical: .firstTextBaseline)
    public static let centerLastTextBaseline = Alignment(horizontal: .center, vertical: .lastTextBaseline)
    public static let leadingFirstTextBaseline = Alignment(horizontal: .leading, vertical: .firstTextBaseline)
    public static let leadingLastTextBaseline = Alignment(horizontal: .leading, vertical: .lastTextBaseline)
    public static let trailingFirstTextBaseline = Alignment(horizontal: .trailing, vertical: .firstTextBaseline)
    public static let trailingLastTextBaseline = Alignment(horizontal: .trailing, vertical: .lastTextBaseline)

    #if SKIP
    /// Return the Compose alignment equivalent.
    func asComposeAlignment() -> androidx.compose.ui.Alignment {
        switch self {
        case .leading, .leadingFirstTextBaseline, .leadingLastTextBaseline:
            return androidx.compose.ui.Alignment.CenterStart
        case .trailing, .trailingFirstTextBaseline, .trailingLastTextBaseline:
            return androidx.compose.ui.Alignment.CenterEnd
        case .top:
            return androidx.compose.ui.Alignment.TopCenter
        case .bottom:
            return androidx.compose.ui.Alignment.BottomCenter
        case .topLeading:
            return androidx.compose.ui.Alignment.TopStart
        case .topTrailing:
            return androidx.compose.ui.Alignment.TopEnd
        case .bottomLeading:
            return androidx.compose.ui.Alignment.BottomStart
        case .bottomTrailing:
            return androidx.compose.ui.Alignment.BottomEnd
        default:
            return androidx.compose.ui.Alignment.Center
        }
    }
    #endif
}

#endif
