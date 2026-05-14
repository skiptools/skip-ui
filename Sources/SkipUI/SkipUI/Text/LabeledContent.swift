// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.unit.dp
#endif

// SKIP @bridge
public struct LabeledContent : View, Renderable {
    let content: ComposeBuilder
    let label: ComposeBuilder
    
    public init(@ViewBuilder content: () -> any View, @ViewBuilder label: () -> any View) {
        self.content = ComposeBuilder.from(content)
        self.label = ComposeBuilder.from(label)
    }
    
    // SKIP @bridge
    public init(bridgedContent: any View, bridgedLabel: any View) {
        self.content = ComposeBuilder.from { bridgedContent }
        self.label = ComposeBuilder.from { bridgedLabel  }
    }
    
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View) {
        self.init(content: content) { Text(titleKey) }
    }
    public init(_ title: String, @ViewBuilder content: () -> any View) {
        self.init(content: content) { Text(verbatim: title) }
    }
    public init(_ titleResource: LocalizedStringResource, @ViewBuilder content: () -> any View) {
        self.init(content: content) { Text(titleResource) }
    }
    
    public init(_ titleKey: LocalizedStringKey, value: String) {
        self.init { Text(verbatim: value) } label: { Text(titleKey) }
    }
    public init(_ title: String, value: String) {
        self.init { Text(verbatim: value) } label: { Text(verbatim: title) }
    }
    
    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        var style = EnvironmentValues.shared._labeledContentStyle ?? LabeledContentStyle.automatic
        RenderLabeleledContent(context: context)
    }

    @Composable private func RenderLabeleledContent(context: ComposeContext) {
        Row(modifier: context.modifier.fillWidth(), horizontalArrangement: Arrangement.SpaceBetween, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
            RenderLabel(context: context.content())
            RenderContent(context: context.content())
        }
    }

    /// Render only the label of this labeled content.
    @Composable func RenderLabel(context: ComposeContext, labelColor: Color? = nil) {
        if let labelColor {
            EnvironmentValues.shared.setValues {
                $0.set_foregroundStyle(labelColor)
                return ComposeResult.ok
            } in: {
                label.Compose(context: context)
            }
        } else {
            label.Compose(context: context)
        }
    }

    /// Render only the content of this labeled content.
    @Composable func RenderContent(context: ComposeContext) {
        content.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct LabeledContentStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = LabeledContentStyle(rawValue: 0) // For bridging
}

extension View {
    public func labeledContentStyle(_ style: LabeledContentStyle) -> some View {
        #if SKIP
        return environment(\._labeledContentStyle, style, affectsEvaluate: false)
        #else
        return self
        #endif
    }
}
#endif
