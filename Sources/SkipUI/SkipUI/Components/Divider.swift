// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP INSERT: import androidx.compose.runtime.Composable

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
        let dividerColor = context.style.color?.colorImpl()
        androidx.compose.material3.Divider(modifier: context.modifier, color: dividerColor ?? androidx.compose.ui.graphics.Color.LightGray)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
