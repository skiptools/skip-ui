// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.draw.scale
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.dp
#else
import struct CoreGraphics.CGAffineTransform
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
#endif

public protocol View {
    #if SKIP
    // SKIP DECLARE: fun body(): View = EmptyView()
    @ViewBuilder var body: any View { get }
    #else
    associatedtype Body : View
    @ViewBuilder @MainActor var body: Body { get }
    #endif
}

#if SKIP
extension View {
    /// Compose this view without an existing context - typically called when integrating a SwiftUI view tree into pure Compose.
    @Composable public func Compose() {
        Compose(context: ComposeContext())
    }

    /// Calls to `Compose` are added by the transpiler.
    @Composable public func Compose(context: ComposeContext) {
        if let composer = context.composer {
            var context = context
            context.composer = nil
            composer(&self, context)
        } else {
            ComposeContent(context: context)
        }
    }

    /// Compose this view's content.
    @Composable public func ComposeContent(context: ComposeContext) -> Void {
        body.ComposeContent(context)
    }

    /// Strip modifier views unless they have one of the given roles.
    public func strippingModifiers<R>(whileRole: (ComposeModifierRole) -> Bool = { _ in true}, perform: (any View?) -> R) -> R {
        return perform(self)
    }
}
#endif

extension View {
    public func background(_ color: Color) -> some View {
        #if SKIP
        return ComposeModifierView(contextView: self) {
            $0.modifier = $0.modifier.background(color.colorImpl())
        }
        #else
        return self
        #endif
    }

    public func border(_ color: Color, width: CGFloat = 1.0) -> some View {
        #if SKIP
        return ComposeModifierView(contextView: self) {
            $0.modifier = $0.modifier.border(width: width.dp, color: color.colorImpl())
        }
        #else
        return self
        #endif
    }

    public func foregroundColor(_ color: Color?) -> some View {
        #if SKIP
        return environment(\._color, color)
        #else
        return self
        #endif
    }

    public func foregroundStyle(_ color: Color) -> some View {
        return foregroundColor(color)
    }

    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            var context = context
            if let width {
                context.modifier = context.modifier.width(width.dp)
            }
            if let height {
                context.modifier = context.modifier.height(height.dp)
            }
            EnvironmentValues.shared.setValues {
                if width != nil {
                    $0.set_fillWidth(nil)
                }
                if height != nil {
                    $0.set_fillHeight(nil)
                }
            } in: {
                view.ComposeContent(context: context)
            }
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment) -> some View {
        return frame(width: width, height: height)
    }

    @available(*, unavailable)
    public func frame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        return self
    }

    public func labelsHidden() -> some View {
        #if SKIP
        return environment(\._labelsHidden, true)
        #else
        return self
        #endif
    }

    public func opacity(_ opacity: Double) -> some View {
        #if SKIP
        return ComposeModifierView(contextView: self) {
            $0.modifier = $0.modifier.alpha(Float(opacity))
        }
        #else
        return self
        #endif
    }

    public func padding(_ insets: EdgeInsets) -> some View {
        #if SKIP
        return ComposeModifierView(contextView: self, role: .spacing) {
            $0.modifier = $0.modifier.padding(start: insets.leading.dp, top: insets.top.dp, end: insets.trailing.dp, bottom: insets.bottom.dp)
        }
        #else
        return self
        #endif
    }

    public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        #if SKIP
        let amount = (length ?? CGFloat(16.0)).dp
        let start = edges.contains(.leading) ? amount : 0.dp
        let end = edges.contains(.trailing) ? amount : 0.dp
        let top = edges.contains(.top) ? amount : 0.dp
        let bottom = edges.contains(.bottom) ? amount : 0.dp
        return ComposeModifierView(contextView: self, role: .spacing) {
            $0.modifier = $0.modifier.padding(start: start, top: top, end: end, bottom: bottom)
        }
        #else
        return self
        #endif
    }

    public func padding(_ length: CGFloat) -> some View {
        return padding(.all, length)
    }

    public func rotationEffect(_ angle: Angle) -> some View {
        #if SKIP
        return ComposeModifierView(contextView: self) {
            $0.modifier = $0.modifier.rotate(Float(angle.degrees))
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func rotationEffect(_ angle: Angle, anchor: UnitPoint) -> some View {
        #if SKIP
        fatalError()
        #else
        return self
        #endif
    }

    public func scaleEffect(_ scale: CGSize) -> some View {
        return scaleEffect(x: scale.width, y: scale.height)
    }

    @available(*, unavailable)
    public func scaleEffect(_ scale: CGSize, anchor: UnitPoint) -> some View {
        return scaleEffect(x: scale.width, y: scale.height)
    }

    public func scaleEffect(_ s: CGFloat) -> some View {
        return scaleEffect(x: s, y: s)
    }

    @available(*, unavailable)
    public func scaleEffect(_ s: CGFloat, anchor: UnitPoint) -> some View {
        return scaleEffect(x: s, y: s)
    }

    public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0) -> some View {
        #if SKIP
        return ComposeModifierView(contextView: self) {
            $0.modifier = $0.modifier.scale(scaleX: Float(x), scaleY: Float(y))
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0, anchor: UnitPoint) -> some View {
        return scaleEffect(x: x, y: y)
    }

    public func task(priority: TaskPriority = .userInitiated, _ action: @escaping () async -> Void) -> some View {
        return task(id: 0, priority: priority, action)
    }

    public func task(id value: Any, priority: TaskPriority = .userInitiated, _ action: @escaping () async -> Void) -> some View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            let handler = rememberUpdatedState(action)
            LaunchedEffect(value) {
                handler.value()
            }
            view.Compose(context: context)
        }
        #else
        return self
        #endif
    }
}

#if !SKIP

// Stubs needed to compile this package:

extension Optional : View where Wrapped : View {
    public var body: some View {
        stubView()
    }
}

extension Never : View {
}
#endif
