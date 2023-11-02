// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

public struct Divider : View {
    public init() {
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/Divider.kt
     @Composable
     fun Divider(
        modifier: Modifier = Modifier,
        thickness: Dp = DividerDefaults.Thickness,
        color: Color = DividerDefaults.color,
     )
     */
    @Composable public override func ComposeContent(context: ComposeContext) {
        //~~~ TODO: Can we use .background modifier with Brush?
        let dividerColor = EnvironmentValues.shared._foregroundStyle?.asColor(opacity: 1.0) ?? androidx.compose.ui.graphics.Color.LightGray
        androidx.compose.material3.Divider(modifier: context.modifier, color: dividerColor)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
