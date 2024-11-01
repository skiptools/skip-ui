// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
