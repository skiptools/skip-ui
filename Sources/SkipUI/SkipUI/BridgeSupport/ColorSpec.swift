// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

/// Specify a  `SwiftUI.Color` in bridgable form.
// SKIP @bridge
public enum ColorSpec {
    case primary
    case secondary

    case red
    case orange
    case yellow
    case green
    case mint
    case teal
    case cyan
    case blue
    case indigo
    case purple
    case pink
    case brown
    case white
    case gray
    case black
    case clear

    func asColor() -> Color {
        switch self {
        case .primary:
            return Color.primary
        case .secondary:
            return Color.secondary

        case .red:
            return Color.red
        case .orange:
            return Color.orange
        case .yellow:
            return Color.yellow
        case .green:
            return Color.green
        case .mint:
            return Color.mint
        case .teal:
            return Color.teal
        case .cyan:
            return Color.cyan
        case .blue:
            return Color.blue
        case .indigo:
            return Color.indigo
        case .purple:
            return Color.purple
        case .pink:
            return Color.pink
        case .brown:
            return Color.brown
        case .white:
            return Color.white
        case .gray:
            return Color.gray
        case .black:
            return Color.black
        case .clear:
            return Color.clear
        }
    }
}

#endif
