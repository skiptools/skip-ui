// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCompositionContext
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.viewinterop.AndroidView
import java.util.UUID
#endif

#if SKIP
/// Gives a subtree its own retained identity and lifecycle on Android.
///
/// Think of the boundary as a separate hosting container. Keeping `id` stable preserves that
/// container and its state. Changing `inputs` updates content inside the existing container;
/// changing `id` disposes it and creates a new one. Change `inputs` whenever a value used to
/// build `content` changes.
// SKIP @bridge
public struct AndroidCompositionBoundary: View, Renderable {
    let id: String
    let inputs: String
    let content: () -> any View
    let bridgedProjectionLifecycle: ((String, Bool) -> any View)?

    /// Creates a retained Android composition boundary around `content`.
    public init(id: String, inputs: String = "", @ViewBuilder content: @escaping () -> any View) {
        self.id = id
        self.inputs = inputs
        self.content = content
        self.bridgedProjectionLifecycle = nil
    }

    /// Creates a retained Android composition boundary around bridged content.
    // SKIP @bridge
    public init(id: String, inputs: String = "", bridgedContent: any View) {
        self.id = id
        self.inputs = inputs
        self.content = { bridgedContent }
        self.bridgedProjectionLifecycle = nil
    }

    /// Creates a lazy bridged boundary whose projection is scoped to one Compose instance.
    ///
    /// The lifecycle callback is called with `isDisposing == false` on every parent render so
    /// native callers can release temporary projection sources. It is called with
    /// `isDisposing == true` when the Compose instance leaves the hierarchy. Prepared projections
    /// are installed only initially and when `inputs` changes.
    // SKIP @bridge
    public init(
        id: String,
        inputs: String = "",
        bridgedProjectionLifecycle: @escaping (String, Bool) -> any View
    ) {
        self.id = id
        self.inputs = inputs
        self.content = { EmptyView() }
        self.bridgedProjectionLifecycle = bridgedProjectionLifecycle
    }

    @Composable override func Render(context: ComposeContext) {
        androidx.compose.runtime.key(id) {
            let parentCompositionContext = rememberCompositionContext()
            let childContext = context.content()
            let projectionInstanceID = remember { UUID.randomUUID().toString() }
            let currentProjectionLifecycle = rememberUpdatedState(bridgedProjectionLifecycle)
            let preparedProjection = bridgedProjectionLifecycle?(projectionInstanceID, false)
            let storage = remember(id) {
                AndroidCompositionBoundaryStorage(
                    inputs: inputs,
                    content: preparedProjection ?? content()
                )
            }

            // Dispose the native projection when this boundary actually leaves the Compose tree.
            DisposableEffect(projectionInstanceID) {
                onDispose {
                    if let projectionLifecycle = currentProjectionLifecycle.value {
                        _ = projectionLifecycle(projectionInstanceID, true)
                    }
                }
            }

            AndroidView(
                factory: { androidContext in
                    return AndroidCompositionBoundaryComposeView(context: androidContext, parentCompositionContext: parentCompositionContext) {
                        storage.content.Compose(context: childContext)
                    }
                },
                modifier: context.modifier,
                update: { composeView in
                    guard storage.inputs != inputs else {
                        return
                    }
                    storage.inputs = inputs
                    storage.content = preparedProjection ?? content()
                    composeView.setContent {
                        storage.content.Compose(context: childContext)
                    }
                }
            )
        }
    }
}

private final class AndroidCompositionBoundaryStorage {
    var inputs: String
    var content: any View

    init(inputs: String, content: any View) {
        self.inputs = inputs
        self.content = content
    }
}
#endif

extension View {
    /// Gives this subtree its own retained identity and lifecycle on Android.
    ///
    /// Keeping `id` stable preserves the host and its state. Changing `inputs` updates content
    /// inside the existing host; changing `id` disposes it and creates a new one. Non-Android
    /// platforms return the original view. Change `inputs` whenever a value used to build this
    /// view changes; the retained content remains unchanged while both arguments are unchanged.
    public func androidCompositionBoundary(id: String, inputs: String = "") -> some View {
        #if SKIP
        return AndroidCompositionBoundary(id: id, inputs: inputs, content: { self })
        #else
        return self
        #endif
    }
}

#endif
