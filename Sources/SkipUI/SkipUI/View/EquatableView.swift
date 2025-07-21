// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
#endif

// SKIP @bridge
public struct EquatableView : View {
    public let content: any View

    // SKIP @bridge
    public init(content: any View) {
        self.content = content
    }

    #if SKIP
    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        return content.Evaluate(context: context, options: options)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
