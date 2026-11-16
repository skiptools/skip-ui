// Copyright 2023–2026 Skip
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.width
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
#endif

// SKIP @bridge
public struct Divider : View, Renderable {
    // SKIP @bridge
    public init() {
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        let dividerColor = Color.separator.colorImpl()
        let modifier: Modifier
        switch EnvironmentValues.shared._layoutAxis {
        case .horizontal:
            // If in a horizontal container, create a vertical divider
            modifier = Modifier.width(1.dp).then(context.modifier.fillHeight())
        case .vertical, nil:
            modifier = context.modifier
        }
        androidx.compose.material3.Divider(modifier: modifier, color: dividerColor)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
