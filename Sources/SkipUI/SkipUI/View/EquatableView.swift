// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
#endif

// SKIP @bridge
public struct EquatableView : View {
    public let content: any View

    // SKIP @bridge
    public init(content: any View) {
        self.content = content
    }

    #if SKIP
    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        return content.Evaluate(context: context, options: options)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
/// Retains evaluated Android child content while a caller-provided render identity remains equal.
struct AndroidEquatableView<RecomposeOverride: Equatable>: View, Renderable {
    let content: any View
    let recomposeOverride: RecomposeOverride

    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        return listOf(self)
    }

    @Composable override func Render(context: ComposeContext) {
        let storage = remember {
            AndroidEquatableStorage(recomposeOverride: recomposeOverride)
        }
        for renderable in storage.renderables(
            recomposeOverride: recomposeOverride,
            content: content,
            context: context,
            options: 0
        ) {
            renderable.Render(context: context)
        }
    }
}

/// Retains bridged Android child content while a string render identity remains equal.
// SKIP @bridge
public struct AndroidEquatableContent: View, Renderable {
    let recomposeOverride: String
    let content: () -> any View

    /// Creates retained Android content around lazily bridged child content.
    // SKIP @bridge
    public init(recomposeOverride: String, bridgedContentFactory: @escaping () -> any View) {
        self.recomposeOverride = recomposeOverride
        self.content = bridgedContentFactory
    }

    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        return listOf(self)
    }

    @Composable override func Render(context: ComposeContext) {
        let storage = remember {
            AndroidEquatableStorage(recomposeOverride: recomposeOverride)
        }
        for renderable in storage.renderables(
            recomposeOverride: recomposeOverride,
            content: content(),
            context: context,
            options: 0
        ) {
            renderable.Render(context: context)
        }
    }
}

private final class AndroidEquatableStorage<RecomposeOverride: Equatable> {
    var recomposeOverride: RecomposeOverride
    var renderables: kotlin.collections.List<Renderable>?

    init(recomposeOverride: RecomposeOverride) {
        self.recomposeOverride = recomposeOverride
    }

    @Composable func renderables(
        recomposeOverride: RecomposeOverride,
        content: any View,
        context: ComposeContext,
        options: Int
    ) -> kotlin.collections.List<Renderable> {
        if renderables == nil || self.recomposeOverride != recomposeOverride {
            self.recomposeOverride = recomposeOverride
            self.renderables = content.Evaluate(context: context, options: options)
        }
        return renderables ?? listOf()
    }
}
#endif

extension View where Self: Equatable {
    /// On Android, reuses this view's evaluated content while the view value remains equal.
    public func androidEquatable() -> some View {
        #if SKIP
        return AndroidEquatableView(content: self, recomposeOverride: self)
        #else
        return self
        #endif
    }
}

extension View {
    /// On Android, reuses evaluated content until `recomposeOverride` changes.
    ///
    /// Include every body-affecting external value in `recomposeOverride`; unchanged values skip
    /// parent-driven body evaluation for this subtree.
    public func androidEquatable<RecomposeOverride: Equatable>(recomposeOverride: RecomposeOverride) -> some View {
        #if SKIP
        return AndroidEquatableView(content: self, recomposeOverride: recomposeOverride)
        #else
        return self
        #endif
    }
}

#endif
