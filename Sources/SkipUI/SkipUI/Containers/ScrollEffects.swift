// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import struct CoreGraphics.CGVector
#endif

/// The geometry of a scroll view's content and container.
public struct ScrollGeometry : Equatable {
    public var contentOffset: CGPoint
    public var contentSize: CGSize
    public var contentInsets: EdgeInsets
    public var containerSize: CGSize

    public init(contentOffset: CGPoint, contentSize: CGSize, contentInsets: EdgeInsets, containerSize: CGSize) {
        self.contentOffset = contentOffset
        self.contentSize = contentSize
        self.contentInsets = contentInsets
        self.containerSize = containerSize
    }

    /// The content rectangle currently visible in the container.
    public var visibleRect: CGRect {
        return CGRect(origin: contentOffset, size: containerSize)
    }

    public var bounds: CGRect {
        return CGRect(origin: CGPoint(x: -contentInsets.leading, y: -contentInsets.top), size: containerSize)
    }

    /// Content offset, content size, insets (top, leading, bottom, trailing), and container size.
    var bridgedValues: [Double] {
        return [contentOffset.x, contentOffset.y, contentSize.width, contentSize.height, contentInsets.top, contentInsets.leading, contentInsets.bottom, contentInsets.trailing, containerSize.width, containerSize.height]
    }
}

/// The phase of a scroll view's scrolling.
public enum ScrollPhase : Int, Hashable {
    case idle = 0 // For bridging
    case tracking = 1 // For bridging
    case interacting = 2 // For bridging
    case decelerating = 3 // For bridging
    case animating = 4 // For bridging

    public var isScrolling: Bool {
        return self != .idle
    }
}

/// The geometry and velocity of a scroll view when its scroll phase changes.
public struct ScrollPhaseChangeContext {
    public let geometry: ScrollGeometry
    /// The velocity of the content in points per millisecond, which is zero except as the user flings it.
    public let velocity: CGVector?
}

#if SKIP
/// A two-dimensional vector, which SkipLib's CoreGraphics types don't include.
public struct CGVector : Hashable {
    public static let zero = CGVector()
    public var dx: CGFloat
    public var dy: CGFloat

    public init(dx: CGFloat = 0.0, dy: CGFloat = 0.0) {
        self.dx = dx
        self.dy = dy
    }
}
#endif

extension View {
    /// Calls `action` when the value that `transform` derives from a scroll view's geometry changes.
    // SKIP DECLARE: fun <T: Any> onScrollGeometryChange(for_: KClass<T>, of: (ScrollGeometry) -> T, action: (T, T) -> Unit): View
    public func onScrollGeometryChange<T>(for type: T.Type, of transform: @escaping (ScrollGeometry) -> T, action: @escaping (_ oldValue: T, _ newValue: T) -> Void) -> any View where T : Equatable {
        #if SKIP
        return ModifiedContent(content: self, modifier: ScrollGeometryModifier(transform: { transform($0) }, action: { action($0 as! T, $1 as! T) }))
        #else
        return self
        #endif
    }

    /// Bridged geometry change; `bridgedTransform` receives `ScrollGeometry.bridgedValues` and returns a comparable value.
    // SKIP @bridge
    public func onScrollGeometryChange(bridgedTransform: @escaping ([Double]) -> Any, bridgedAction: @escaping (Any, Any) -> Void) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: ScrollGeometryModifier(transform: { bridgedTransform($0.bridgedValues) }, action: bridgedAction))
        #else
        return self
        #endif
    }

    public func onScrollPhaseChange(_ action: @escaping (_ oldPhase: ScrollPhase, _ newPhase: ScrollPhase) -> Void) -> any View {
        return onScrollPhaseChange { oldPhase, newPhase, _ in
            action(oldPhase, newPhase)
        }
    }

    /// Calls `action` as a scroll view in this view starts and stops scrolling: when the user drags or flings it, and
    /// when the app scrolls it with animation.
    public func onScrollPhaseChange(_ action: @escaping (_ oldPhase: ScrollPhase, _ newPhase: ScrollPhase, _ context: ScrollPhaseChangeContext) -> Void) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: ScrollPhaseModifier(action: action))
        #else
        return self
        #endif
    }

    /// Bridged phase change: `values` are the old and new phases' raw values, `ScrollGeometry.bridgedValues`, and the
    /// velocity's `dx` and `dy`. A single parameter keeps Kotlin from confusing this with the other overloads.
    // SKIP @bridge
    public func onScrollPhaseChange(bridgedAction: @escaping (_ values: [Double]) -> Void) -> any View {
        return onScrollPhaseChange { oldPhase, newPhase, context in
            bridgedAction([Double(oldPhase.rawValue), Double(newPhase.rawValue)] + context.geometry.bridgedValues + [context.velocity?.dx ?? 0.0, context.velocity?.dy ?? 0.0])
        }
    }
}

#if SKIP
/// Reports a derived value of the modified scroll view's geometry when it changes.
final class ScrollGeometryModifier: RenderModifier {
    init(transform: @escaping (ScrollGeometry) -> Any, action: @escaping (Any, Any) -> Void) {
        super.init()
        self.action = { renderable, context in
            let lastValue = remember { mutableStateOf<Any?>(nil) }
            let onChange: (ScrollGeometry) -> Void = { geometry in
                let value = transform(geometry)
                if let oldValue = lastValue.value {
                    if oldValue != value {
                        lastValue.value = value
                        action(oldValue, value)
                    }
                } else {
                    lastValue.value = value
                }
            }
            EnvironmentValues.shared.setValues {
                $0.set_onScrollGeometryChange(onChange)
                return ComposeResult.ok
            } in: {
                renderable.Render(context: context)
            }
        }
    }
}

/// Adds an action to those the scroll views in the modified view call as their scroll phase changes.
final class ScrollPhaseModifier: RenderModifier {
    init(action: @escaping (ScrollPhase, ScrollPhase, ScrollPhaseChangeContext) -> Void) {
        super.init()
        self.action = { renderable, context in
            let outer = EnvironmentValues.shared._onScrollPhaseChange
            EnvironmentValues.shared.setValues {
                $0.set_onScrollPhaseChange(outer == nil ? action : { outer!($0, $1, $2); action($0, $1, $2) })
                return ComposeResult.ok
            } in: {
                renderable.Render(context: context)
            }
        }
    }
}
#endif

#endif
