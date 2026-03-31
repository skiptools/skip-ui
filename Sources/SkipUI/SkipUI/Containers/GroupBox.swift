// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp
#endif

// SKIP @bridge
public struct GroupBox : View {
    let label: ComposeBuilder?
    let content: ComposeBuilder

    public init(@ViewBuilder content: () -> any View, @ViewBuilder label: () -> any View) {
        self.label = ComposeBuilder.from(label)
        self.content = ComposeBuilder.from(content)
    }

    public init(@ViewBuilder content: () -> any View) {
        self.label = nil
        self.content = ComposeBuilder.from(content)
    }

    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View) {
        self.label = ComposeBuilder.from { Text(titleKey) }
        self.content = ComposeBuilder.from(content)
    }

    public init(_ title: String, @ViewBuilder content: () -> any View) {
        self.label = ComposeBuilder.from { Text(verbatim: title) }
        self.content = ComposeBuilder.from(content)
    }

    public init(label: any View, @ViewBuilder content: () -> any View) {
        self.label = ComposeBuilder.from { label }
        self.content = ComposeBuilder.from(content)
    }

    // SKIP @bridge
    public init(bridgedLabel: (any View)?, bridgedContent: any View) {
        self.label = bridgedLabel == nil ? nil : ComposeBuilder.from { bridgedLabel! }
        self.content = ComposeBuilder.from { bridgedContent }
    }

    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
        let contentContext = context.content()
        let isDark = EnvironmentValues.shared.colorScheme == .dark
        let backgroundColor = isDark
            ? androidx.compose.ui.graphics.Color(0xFF2C2C2E.toLong())
            : androidx.compose.ui.graphics.Color(0xFFF2F2F7.toLong())
        let shape = RoundedCornerShape(10.dp)

        ComposeContainer(axis: .vertical, modifier: context.modifier, fillWidth: true) { modifier in
            Column(
                modifier: modifier
                    .fillMaxWidth()
                    .clip(shape)
                    .background(color: backgroundColor, shape: shape)
                    .padding(16.dp),
                verticalArrangement: Arrangement.spacedBy(8.dp),
                horizontalAlignment: Alignment.Start
            ) {
                if let label = label {
                    Box(modifier: Modifier.fillMaxWidth()) {
                        label.Compose(context: contentContext)
                    }
                }
                content.Compose(context: contentContext)
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

//extension View {
//    @available(*, unavailable)
//    public func groupBoxStyle(_ style: Any) -> some View {
//        return self
//    }
//}

#endif
