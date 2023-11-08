// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
#else
import struct CoreGraphics.CGFloat
#endif

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
        let fillModifier: Modifier
        switch EnvironmentValues.shared._layoutAxis {
        case .horizontal:
            fillModifier = EnvironmentValues.shared._fillWidth?(true) ?? Modifier
        case .vertical:
            fillModifier = EnvironmentValues.shared._fillHeight?(true) ?? Modifier
        case nil:
            fillModifier = Modifier
        }
        let modifier = fillModifier.then(context.modifier)
        androidx.compose.foundation.layout.Spacer(modifier: modifier)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
