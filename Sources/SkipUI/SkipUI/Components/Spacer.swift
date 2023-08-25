// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import struct CoreGraphics.CGFloat
#endif

// SKIP INSERT: import androidx.compose.foundation.layout.fillMaxHeight
// SKIP INSERT: import androidx.compose.foundation.layout.fillMaxWidth
// SKIP INSERT: import androidx.compose.runtime.Composable
// SKIP INSERT: import androidx.compose.ui.unit.dp

public struct Spacer : View {
    public init() {
    }

    @available(*, unavailable)
    public init(minLength: CGFloat?) {
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation-layout/src/commonMain/kotlin/androidx/compose/foundation/layout/Spacer.kt
     @Composable
     fun Spacer(modifier: Modifier)
     */
    @Composable public override func ComposeContent(context: ComposeContext) {
        var modifier: androidx.compose.ui.Modifier = context.style.fillWidth ?? context.style.fillHeight ?? androidx.compose.ui.Modifier
        modifier = modifier.then(context.modifier)
        androidx.compose.foundation.layout.Spacer(modifier: modifier)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
