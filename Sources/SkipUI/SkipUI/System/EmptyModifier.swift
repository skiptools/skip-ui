// Copyright 2023–2026 Skip
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import skip.model.StateTracking
#endif

// SKIP @bridge
public struct EmptyModifier : ViewModifier {
    public static let identity: EmptyModifier = EmptyModifier()

    // SKIP @bridge
    public init() {
    }

    #if SKIP
    public func body(content: Content) -> some View {
        content
    }
    #endif
}

#endif
