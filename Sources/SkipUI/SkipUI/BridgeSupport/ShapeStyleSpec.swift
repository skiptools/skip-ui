// Copyright 2025 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE

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

