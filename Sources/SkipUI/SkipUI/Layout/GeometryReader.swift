// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
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
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalDensity
#endif

// SKIP @bridge
public struct GeometryReader : View, Renderable {
    public let content: (GeometryProxy) -> any View

    // SKIP @bridge
    public init(@ViewBuilder content: @escaping (GeometryProxy) -> any View) {
        self.content = content
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        let geometry = remember { GeometryReaderState() }
        UpdateGeometryReaderSafeArea(geometry)
        Box(modifier: context.modifier.fillSize().onGloballyPositioned {
            geometry.update(size: $0.size, frame: $0.boundsInRoot())
        }) {
            if geometry.isPositioned {
                // Constructing the proxy must not read its frame or safe area. The content decides
                // which properties it needs, including across the native Swift bridge.
                let proxy = GeometryProxy(geometry: geometry, density: LocalDensity.current)
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
