// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
#endif

// SKIP @bridge
public struct EmptyView: View, Renderable {
    // SKIP @bridge
    public init() {
    }
    
    #if SKIP
    @Composable override func Render(context: ComposeContext) {
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
