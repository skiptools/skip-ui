// Copyright 2023–2026 Skip
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
