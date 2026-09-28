// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.layout.onSizeChanged
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

public struct SafeAreaRegions : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let container = SafeAreaRegions(rawValue: 1)
    public static let keyboard = SafeAreaRegions(rawValue: 2)
    public static let all = SafeAreaRegions(rawValue: 3)
}

#if SKIP
import androidx.compose.ui.geometry.Rect

/// Track safe area.
struct SafeArea: Equatable, CustomStringConvertible {
    /// Total bounds of presentation root.
    let presentationBoundsPx: Rect

    /// Safe bounds of presentation root.
    let safeBoundsPx: Rect

    /// The edges whose safe area is solely due to system bars.
    let absoluteSystemBarEdges: Edge.Set

    init(presentation: Rect, safe: Rect, absoluteSystemBars: Edge.Set = []) {
        self.presentationBoundsPx = presentation
        self.safeBoundsPx = safe
        self.absoluteSystemBarEdges = absoluteSystemBars
    }

    /// Update the safe area.
    @Composable func insetting(_ edge: Edge, to value: Float) -> SafeArea {
        guard value > Float(0.0) else {
            return self
        }
        var systemBarEdges = absoluteSystemBarEdges
        var (safeLeft, safeTop, safeRight, safeBottom) = safeBoundsPx
        switch edge {
        case .top:
            safeTop = value
            systemBarEdges.remove(.top)
        case .bottom:
            safeBottom = value
            systemBarEdges.remove(.bottom)
        case .leading:
            safeLeft = value
            systemBarEdges.remove(.leading)
        case .trailing:
            safeRight = value
            systemBarEdges.remove(.trailing)
        }
        return SafeArea(presentation: presentationBoundsPx, safe: Rect(top: safeTop, left: safeLeft, bottom: safeBottom, right: safeRight), absoluteSystemBars: systemBarEdges)
    }
    
    var description: String {
        "SafeArea(presentationBoundsPx: \(presentationBoundsPx), safeBoundsPx: \(safeBoundsPx), absoluteSystemBarEdges: \(absoluteSystemBarEdges))"
    }
}
#endif

extension View {
    public func safeAreaInset(edge: VerticalEdge, alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: SafeAreaInsetModifier(edge: edge == .top ? Edge.top : Edge.bottom, alignment: Alignment(horizontal: alignment, vertical: .center), spacing: spacing, inset: ComposeBuilder.from(content)))
        #else
        return self
        #endif
    }

    public func safeAreaInset(edge: HorizontalEdge, alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: SafeAreaInsetModifier(edge: edge == .leading ? Edge.leading : Edge.trailing, alignment: Alignment(horizontal: .center, vertical: alignment), spacing: spacing, inset: ComposeBuilder.from(content)))
        #else
        return self
        #endif
    }

    public func safeAreaPadding(_ insets: EdgeInsets) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: SafeAreaPaddingModifier(insets: insets))
        #else
        return self
        #endif
    }

    public func safeAreaPadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> any View {
        let length = length ?? 16.0
        return safeAreaPadding(EdgeInsets(top: edges.contains(.top) ? length : 0.0, leading: edges.contains(.leading) ? length : 0.0, bottom: edges.contains(.bottom) ? length : 0.0, trailing: edges.contains(.trailing) ? length : 0.0))
    }

    public func safeAreaPadding(_ length: CGFloat) -> any View {
        return safeAreaPadding(.all, length)
    }

    @available(*, unavailable)
    public func safeAreaBar(edge: VerticalEdge, alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> some View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func safeAreaBar(edge: HorizontalEdge, alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> some View) -> some View {
        return self
    }
}

#if SKIP
/// Whether the renderable scrolls its content and applies `_contentPadding` itself, so insets let content scroll beneath them.
private func appliesContentPadding(_ renderable: Renderable) -> Bool {
    let stripped = renderable.strip()
    return stripped is List || stripped is LazyVStack || stripped is LazyHStack || stripped is LazyVGrid || stripped is LazyHGrid
}

/// Render content inset by the given amounts: scrolling content scrolls beneath the insets, other content is padded.
@Composable private func RenderInset(_ renderable: Renderable, insets: EdgeInsets, context: ComposeContext) {
    if appliesContentPadding(renderable) {
        let padding = EnvironmentValues.shared._contentPadding
        EnvironmentValues.shared.setValues {
            $0.set_contentPadding(EdgeInsets(top: padding.top + insets.top, leading: padding.leading + insets.leading, bottom: padding.bottom + insets.bottom, trailing: padding.trailing + insets.trailing))
            return ComposeResult.ok
        } in: {
            renderable.Render(context: context)
        }
    } else {
        renderable.Render(context: context.content(modifier: Modifier.padding(start: insets.leading.dp, top: insets.top.dp, end: insets.trailing.dp, bottom: insets.bottom.dp)))
    }
}

/// Places a view along an edge and insets the modified content by its measured size.
final class SafeAreaInsetModifier: RenderModifier {
    init(edge: Edge, alignment: Alignment, spacing: CGFloat?, inset: ComposeBuilder) {
        super.init()
        self.action = { renderable, context in
            let insetLength = remember { mutableStateOf(0.0) }
            let density = LocalDensity.current
            let length = insetLength.value + (spacing ?? 0.0)
            let insets: EdgeInsets
            let insetModifier: Modifier
            let insetAlignment: androidx.compose.ui.Alignment
            switch edge {
            case .top:
                insets = EdgeInsets(top: length)
                insetModifier = Modifier.fillMaxWidth().onSizeChanged { size in insetLength.value = Double(size.height) / Double(density.density) }
                insetAlignment = androidx.compose.ui.Alignment.TopCenter
            case .bottom:
                insets = EdgeInsets(bottom: length)
                insetModifier = Modifier.fillMaxWidth().onSizeChanged { size in insetLength.value = Double(size.height) / Double(density.density) }
                insetAlignment = androidx.compose.ui.Alignment.BottomCenter
            case .leading:
                insets = EdgeInsets(leading: length)
                insetModifier = Modifier.fillMaxHeight().onSizeChanged { size in insetLength.value = Double(size.width) / Double(density.density) }
                insetAlignment = androidx.compose.ui.Alignment.CenterStart
            case .trailing:
                insets = EdgeInsets(trailing: length)
                insetModifier = Modifier.fillMaxHeight().onSizeChanged { size in insetLength.value = Double(size.width) / Double(density.density) }
                insetAlignment = androidx.compose.ui.Alignment.CenterEnd
            }
            Box(modifier: context.modifier) {
                RenderInset(renderable, insets: insets, context: context.content())
                Box(modifier: Modifier.align(insetAlignment).then(insetModifier), contentAlignment: alignment.asComposeAlignment()) {
                    inset.Compose(context: context.content())
                }
            }
        }
    }
}

/// Insets scrolling content without clipping it, or pads other content.
final class SafeAreaPaddingModifier: RenderModifier {
    init(insets: EdgeInsets) {
        super.init()
        self.action = { renderable, context in
            RenderInset(renderable, insets: insets, context: context)
        }
    }
}
#endif

#endif
