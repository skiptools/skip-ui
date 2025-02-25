// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

/// Specify a  `SwiftUI.ShapeStyle` in bridgable form.
// SKIP @bridge
public enum ShapeStyleSpec {
    case color(ColorSpec)

    func asShapeStyle() -> any ShapeStyle {
        switch self {
        case .color(let spec):
            return spec.asColor()
        }
    }
}

#endif

