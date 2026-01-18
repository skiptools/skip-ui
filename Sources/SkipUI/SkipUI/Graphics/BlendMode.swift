// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public enum BlendMode : Int, Hashable, CaseIterable {
    case normal = 0
    case multiply = 1
    case screen = 2
    case overlay = 3
    case darken = 4
    case lighten = 5
    case colorDodge = 6
    case colorBurn = 7
    case softLight = 8
    case hardLight = 9
    case difference = 10
    case exclusion = 11
    case hue = 12
    case saturation = 13
    case color = 14
    case luminosity = 15
    case sourceAtop = 16
    case destinationOver = 17
    case destinationOut = 18
    case plusDarker = 19
    case plusLighter = 20
}

#if SKIP
extension BlendMode {
    func asComposeBlendMode() -> androidx.compose.ui.graphics.BlendMode {
        switch self {
        case .normal: return androidx.compose.ui.graphics.BlendMode.SrcOver
        case .multiply: return androidx.compose.ui.graphics.BlendMode.Multiply
        case .screen: return androidx.compose.ui.graphics.BlendMode.Screen
        case .overlay: return androidx.compose.ui.graphics.BlendMode.Overlay
        case .darken: return androidx.compose.ui.graphics.BlendMode.Darken
        case .lighten: return androidx.compose.ui.graphics.BlendMode.Lighten
        case .colorDodge: return androidx.compose.ui.graphics.BlendMode.ColorDodge
        case .colorBurn: return androidx.compose.ui.graphics.BlendMode.ColorBurn
        case .softLight: return androidx.compose.ui.graphics.BlendMode.Softlight
        case .hardLight: return androidx.compose.ui.graphics.BlendMode.Hardlight
        case .difference: return androidx.compose.ui.graphics.BlendMode.Difference
        case .exclusion: return androidx.compose.ui.graphics.BlendMode.Exclusion
        case .hue: return androidx.compose.ui.graphics.BlendMode.Hue
        case .saturation: return androidx.compose.ui.graphics.BlendMode.Saturation
        case .color: return androidx.compose.ui.graphics.BlendMode.Color
        case .luminosity: return androidx.compose.ui.graphics.BlendMode.Luminosity
        case .sourceAtop: return androidx.compose.ui.graphics.BlendMode.SrcAtop
        case .destinationOver: return androidx.compose.ui.graphics.BlendMode.DstOver
        case .destinationOut: return androidx.compose.ui.graphics.BlendMode.DstOut
        case .plusDarker, .plusLighter: return androidx.compose.ui.graphics.BlendMode.Plus
        }
    }
}
#endif

#endif
