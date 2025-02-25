// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.unit.Density
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
#endif

public struct GeometryProxy {
    #if SKIP
    let globalFramePx: Rect
    let density: Density
    #endif

    public var size: CGSize {
        #if SKIP
        return with(density) {
            CGSize(width: Double(globalFramePx.width.toDp().value), height: Double(globalFramePx.height.toDp().value))
        }
        #else
        return .zero
        #endif
    }

    @available(*, unavailable)
    public subscript<T>(anchor: Any /* Anchor<T> */) -> T {
        fatalError()
    }

    @available(*, unavailable)
    public var safeAreaInsets: EdgeInsets {
        fatalError()
    }

    @available(*, unavailable)
    public func bounds(of coordinateSpace: NamedCoordinateSpace) -> CGRect? {
        fatalError()
    }

    public func frame(in coordinateSpace: some CoordinateSpaceProtocol) -> CGRect {
        #if SKIP
        if coordinateSpace.coordinateSpace.isGlobal {
            return with(density) {
                CGRect(x: Double(globalFramePx.left.toDp().value), y: Double(globalFramePx.top.toDp().value), width: Double(globalFramePx.width.toDp().value), height: Double(globalFramePx.height.toDp().value))
            }
        } else {
            return CGRect(origin: .zero, size: size)
        }
        #else
        return .zero
        #endif
    }
}

#endif
