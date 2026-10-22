// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.ContentAlpha
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.KeyboardArrowLeft
import androidx.compose.material.icons.outlined.KeyboardArrowRight
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.unit.dp
#endif

// SKIP @bridge
public struct Section : View {
    let header: ComposeBuilder?
    let footer: ComposeBuilder?
    let content: ComposeBuilder
    let expandedBinding: Binding<Bool>?

    public init(@ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View, @ViewBuilder footer: () -> any View) {
        self.header = ComposeBuilder.from(header)
        self.footer = ComposeBuilder.from(footer)
        self.content = ComposeBuilder.from(content)
        self.expandedBinding = nil
    }

    public init(@ViewBuilder content: () -> any View, @ViewBuilder footer: () -> any View) {
        self.header = nil
        self.footer = ComposeBuilder.from(footer)
        self.content = ComposeBuilder.from(content)
        self.expandedBinding = nil
    }

    public init(@ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View) {
        self.header = ComposeBuilder.from(header)
        self.footer = nil
        self.content = ComposeBuilder.from(content)
        self.expandedBinding = nil
    }

    public init(header: any View, @ViewBuilder content: () -> any View) {
        self.header = ComposeBuilder.from({ header })
        self.footer = nil
        self.content = ComposeBuilder.from(content)
        self.expandedBinding = nil
    }

    public init(@ViewBuilder content: () -> any View) {
        self.header = nil
        self.footer = nil
        self.content = ComposeBuilder.from(content)
        self.expandedBinding = nil
    }

    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View) {
        self.init(content: content, header: { Text(titleKey) })
    }

    public init(_ titleResource: LocalizedStringResource, @ViewBuilder content: () -> any View) {
        self.init(content: content, header: { Text(titleResource) })
    }

    public init(_ title: String, @ViewBuilder content: () -> any View) {
        self.init(content: content, header: { Text(verbatim: title) })
    }

    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
        self.init(isExpanded: isExpanded, content: content, header: { Text(titleKey) })
    }

    public init(_ titleResource: LocalizedStringResource, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
        self.init(isExpanded: isExpanded, content: content, header: { Text(titleResource) })
    }

    public init(_ title: String, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
        self.init(isExpanded: isExpanded, content: content, header: { Text(verbatim: title) })
    }

    public init(isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View) {
        self.header = ComposeBuilder.from(header)
        self.footer = nil
        self.content = ComposeBuilder.from(content)
        self.expandedBinding = isExpanded
    }

    // SKIP @bridge
    public init(bridgedContent: any View, bridgedHeader: (any View)?, bridgedFooter: (any View)?) {
        self.content = ComposeBuilder.from { bridgedContent }
        self.header = bridgedHeader == nil ? nil : ComposeBuilder.from { bridgedHeader! }
        self.footer = bridgedFooter == nil ? nil : ComposeBuilder.from { bridgedFooter! }
        self.expandedBinding = nil
    }

    // SKIP @bridge
    public init(getExpanded: @escaping () -> Bool, setExpanded: @escaping (Bool) -> Void, bridgedContent: any View, bridgedHeader: any View) {
        self.content = ComposeBuilder.from { bridgedContent }
        self.header = ComposeBuilder.from { bridgedHeader }
        self.footer = nil
        self.expandedBinding = Binding(get: getExpanded, set: setExpanded)
    }

    #if SKIP
    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        let isLazy = EvaluateOptions(options).lazyItemLevel != nil
        var renderables: kotlin.collections.MutableList<Renderable> = mutableListOf()
        var headerRenderables = header?.Evaluate(context: context, options: 0)
        if let expandedBinding, let header {
            headerRenderables = listOf(ExpandableSectionHeader(label: header, isExpanded: expandedBinding))
        }
        if isLazy {
            renderables.add(LazySectionHeader(content: headerRenderables ?? listOf()))
        } else if let headerRenderables {
            renderables.addAll(headerRenderables)
        }
        if expandedBinding?.wrappedValue != false {
            renderables.addAll(content.Evaluate(context: context, options: options))
        }
        let footerRenderables = footer?.Evaluate(context: context, options: 0)
        if isLazy {
            renderables.add(LazySectionFooter(content: footerRenderables ?? listOf()))
        } else if let footerRenderables {
            renderables.addAll(footerRenderables)
        }
        return renderables
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
/// Section header that toggles the expansion of its section's content.
struct ExpandableSectionHeader: View, Renderable {
    let label: ComposeBuilder
    let isExpanded: Binding<Bool>

    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        return listOf(self)
    }

    @Composable override func Render(context: ComposeContext) {
        let contentContext = context.content()
        let isEnabled = EnvironmentValues.shared.isEnabled
        var accessoryColor = EnvironmentValues.shared._tint?.colorImpl() ?? Color.accentColor.colorImpl()
        if !isEnabled {
            accessoryColor = accessoryColor.copy(alpha: ContentAlpha.disabled)
        }
        let rotationAngle = Float(isExpanded.wrappedValue ? 90 : 0).asAnimatable(context: contentContext)
        let isRTL = EnvironmentValues.shared.layoutDirection == .rightToLeft
        let baseModifier = context.modifier.fillMaxWidth()
        let modifier: Modifier = isEnabled ? baseModifier.clickable(onClick: {
            withAnimation {
                isExpanded.wrappedValue = !isExpanded.wrappedValue
            }
        }) : baseModifier
        Row(modifier: modifier, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
            Box(modifier: Modifier.padding(end: 8.dp).weight(Float(1.0))) {
                label.Compose(context: contentContext)
            }
            Icon(modifier = Modifier.rotate(rotationAngle.value), imageVector: isRTL ? Icons.Outlined.KeyboardArrowLeft : Icons.Outlined.KeyboardArrowRight, contentDescription: nil, tint: accessoryColor)
        }
    }
}
#endif

extension View {
    @available(*, unavailable)
    public func sectionIndexLabel(_ label: Text?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func sectionIndexLabel(_ label: String?) -> some View {
        return self
    }
}

#endif
