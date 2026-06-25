// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCompositionContext
import androidx.compose.ui.viewinterop.AndroidView
#endif

#if SKIP
/// Hosts a subtree in a retained Android composition root.
///
/// Use this for heavyweight Android-only branches that should not be re-entered when an ancestor
/// recomposes for unrelated sibling motion. The boundary uses its own `ComposeView` composition and
/// updates its child content only when `inputs` changes, so callers must include every parent-driven
/// value that should refresh the subtree in that string.
// SKIP @bridge
public struct AndroidCompositionBoundary: View, Renderable {
    let id: String
    let inputs: String
    let content: () -> any View

    /// Creates a retained Android composition boundary around `content`.
    public init(id: String, inputs: String = "", @ViewBuilder content: @escaping () -> any View) {
        self.id = id
        self.inputs = inputs
        self.content = content
    }

    /// Creates a retained Android composition boundary around bridged content.
    // SKIP @bridge
    public init(id: String, inputs: String = "", bridgedContent: any View) {
        self.id = id
        self.inputs = inputs
        self.content = { bridgedContent }
    }

    /// Creates a retained Android composition boundary around lazily bridged content.
    ///
    /// Use this bridge entry point when constructing the child view is expensive. The factory is
    /// evaluated only for the retained child composition's initial content and when `inputs`
    /// changes.
    // SKIP @bridge
    public init(id: String, inputs: String = "", bridgedContentFactory: @escaping () -> any View) {
        self.id = id
        self.inputs = inputs
        self.content = bridgedContentFactory
    }

    @Composable override func Render(context: ComposeContext) {
        androidx.compose.runtime.key(id) {
            let parentCompositionContext = rememberCompositionContext()
            let childContext = context.content()
            let storage = remember(id) {
                AndroidCompositionBoundaryStorage(inputs: inputs, content: content())
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
                    storage.content = content()
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
    /// Isolates this subtree in a retained Android composition root.
    ///
    /// Non-Android platforms return the original view. On Android, the detached root updates its
    /// child content only when `inputs` changes.
    public func androidCompositionBoundary(id: String, inputs: String = "") -> some View {
        #if SKIP
        return AndroidCompositionBoundary(id: id, inputs: inputs, content: { self })
        #else
        return self
        #endif
    }
}

#endif
