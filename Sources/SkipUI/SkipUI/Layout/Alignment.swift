// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE

public struct Alignment : Equatable, Sendable {
    public var horizontal: HorizontalAlignment
    public var vertical: VerticalAlignment

    public static let center = Alignment(horizontal: .center, vertical: .center)
    public static let leading = Alignment(horizontal: .leading, vertical: .center)
    public static let trailing = Alignment(horizontal: .trailing, vertical: .center)
    public static let top = Alignment(horizontal: .center, vertical: .top)
    public static let bottom = Alignment(horizontal: .leading, vertical: .bottom)
    public static let topLeading = Alignment(horizontal: .leading, vertical: .top)
    public static let topTrailing = Alignment(horizontal: .trailing, vertical: .top)
    public static let bottomLeading = Alignment(horizontal: .leading, vertical: .bottom)
    public static let bottomTrailing = Alignment(horizontal: .trailing, vertical: .bottom)

    public static var centerFirstTextBaseline = Alignment(horizontal: .center, vertical: .firstTextBaseline)
    public static var centerLastTextBaseline = Alignment(horizontal: .center, vertical: .lastTextBaseline)
    public static var leadingFirstTextBaseline = Alignment(horizontal: .leading, vertical: .firstTextBaseline)
    public static var leadingLastTextBaseline = Alignment(horizontal: .leading, vertical: .lastTextBaseline)
    public static var trailingFirstTextBaseline = Alignment(horizontal: .trailing, vertical: .firstTextBaseline)
    public static var trailingLastTextBaseline = Alignment(horizontal: .trailing, vertical: .lastTextBaseline)

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
