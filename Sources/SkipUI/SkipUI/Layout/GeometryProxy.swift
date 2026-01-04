// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.unit.Density
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
#endif

// SKIP @bridge
public struct GeometryProxy {
    #if SKIP
    let globalFramePx: Rect
    let density: Density
    let safeArea: SafeArea?
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

    // SKIP @bridge
    public var bridgedSize: (CGFloat, CGFloat) {
        let size = self.size
        return (size.width, size.height)
    }

    // SKIP @bridge
    public var bridgedSafeAreaInsets: (CGFloat, CGFloat, CGFloat, CGFloat) {
        let insets = self.safeAreaInsets
        return (insets.top, insets.leading, insets.bottom, insets.trailing)
    }

    @available(*, unavailable)
    public subscript<T>(anchor: Any /* Anchor<T> */) -> T {
        fatalError()
    }

    public var safeAreaInsets: EdgeInsets {
        #if SKIP
        guard let safeArea = safeArea else {
            return EdgeInsets()
        }
        return with(density) {
            let presentation = safeArea.presentationBoundsPx
            let safe = safeArea.safeBoundsPx
            return EdgeInsets(
                top: Double((safe.top - presentation.top).toDp().value),
                leading: Double((safe.left - presentation.left).toDp().value),
                bottom: Double((presentation.bottom - safe.bottom).toDp().value),
                trailing: Double((presentation.right - safe.right).toDp().value)
            )
        }
        #else
        return EdgeInsets()
        #endif
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

    // SKIP @bridge
    public func frame(bridgedCoordinateSpace: Int, name: Any?) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let coordinateSpace = CoordinateSpaceProtocolFrom(bridged: bridgedCoordinateSpace, name: name as? AnyHashable)
        let frame = self.frame(in: coordinateSpace)
        return (frame.origin.x, frame.origin.y, frame.width, frame.height)
    }
}

#endif
