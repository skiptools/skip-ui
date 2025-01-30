// Copyright 2025 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if canImport(CoreGraphics)
import CoreGraphics
#endif

// SKIP @bridge
public func borderViewModifier(bridgedTarget: Any?, styleSpec: ShapeStyleSpec, width: CGFloat) -> any View {
    guard let target = bridgedTarget as? any View else {
        return EmptyView()
    }
    let style = styleSpec.asShapeStyle()
    return target.border(style, width: width)
}

// SKIP @bridge
public func foregroundColorViewModifier(bridgedTarget: Any?, styleSpec: ShapeStyleSpec?) -> any View {
    guard let target = bridgedTarget as? any View else {
        return EmptyView()
    }
    let color = styleSpec?.asShapeStyle() as? Color
    return target.foregroundColor(color)
}

// SKIP @bridge
public func foregroundStyleViewModifier(bridgedTarget: Any?, styleSpec: ShapeStyleSpec) -> any View {
    guard let target = bridgedTarget as? any View else {
        return EmptyView()
    }
    let style = styleSpec.asShapeStyle()
    return target.foregroundStyle(style)
}

#endif
