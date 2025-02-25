// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.layout.Box
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.layout.LayoutCoordinates
import androidx.compose.ui.layout.boundsInParent
import androidx.compose.ui.layout.boundsInRoot
import androidx.compose.ui.platform.LocalDensity
#endif

public struct GeometryReader : View {
    public let content: (GeometryProxy) -> any View

    public init(@ViewBuilder content: @escaping (GeometryProxy) -> any View) {
        self.content = content
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let rememberedGlobalFramePx = remember { mutableStateOf<Rect?>(nil) }
        Box(modifier: context.modifier.fillSize().onGloballyPositionedInRoot {
            rememberedGlobalFramePx.value = $0
        }) {
            if let globalFramePx = rememberedGlobalFramePx.value {
                let proxy = GeometryProxy(globalFramePx: globalFramePx, density: LocalDensity.current)
                content(proxy).Compose(context.content())
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
