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
            AndroidEquatableStorage(
                recomposeOverride: recomposeOverride,
                areEqual: { lhs, rhs in lhs == rhs }
            )
        }
        for renderable in storage.renderables(
            recomposeOverride: recomposeOverride,
            contentFactory: { content },
            context: context,
            options: 0
        ) {
            renderable.Render(context: context)
        }
    }
}

/// Retains bridged Android child content while its equality-preserving override remains equal.
// SKIP @bridge
public struct AndroidEquatableContent: View, Renderable {
    let recomposeOverride: Any
    let content: () -> any View

    /// Creates retained Android content around lazily bridged child content.
    ///
    /// `recomposeOverride` must provide meaningful JVM `equals` behavior. Native Swift callers
    /// use SkipBridge's `SwiftEquatable` wrapper to preserve the source value's `Equatable`
    /// implementation.
    // SKIP @bridge
    public init(recomposeOverride: Any, bridgedContentFactory: @escaping () -> any View) {
        self.recomposeOverride = recomposeOverride
        self.content = bridgedContentFactory
    }

    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        return listOf(self)
    }

    @Composable override func Render(context: ComposeContext) {
        let storage = remember {
            AndroidEquatableStorage(
                recomposeOverride: recomposeOverride,
                areEqual: { lhs, rhs in lhs.equals(other: rhs) }
            )
        }
        for renderable in storage.renderables(
            recomposeOverride: recomposeOverride,
            contentFactory: content,
            context: context,
            options: 0
        ) {
            renderable.Render(context: context)
        }
    }
}

private final class AndroidEquatableStorage<RecomposeOverride> {
    var recomposeOverride: RecomposeOverride
    var renderables: kotlin.collections.List<Renderable>?
    let areEqual: (RecomposeOverride, RecomposeOverride) -> Bool

    init(
        recomposeOverride: RecomposeOverride,
        areEqual: @escaping (RecomposeOverride, RecomposeOverride) -> Bool
    ) {
        self.recomposeOverride = recomposeOverride
        self.areEqual = areEqual
    }

    @Composable func renderables(
        recomposeOverride: RecomposeOverride,
        contentFactory: () -> any View,
        context: ComposeContext,
        options: Int
    ) -> kotlin.collections.List<Renderable> {
        if renderables == nil || !areEqual(self.recomposeOverride, recomposeOverride) {
            self.recomposeOverride = recomposeOverride
            self.renderables = contentFactory().Evaluate(context: context, options: options)
        }
        return renderables ?? listOf()
    }
}
#endif

extension View where Self: Equatable {
    /// On Android, reuses this view's evaluated content while the view value remains equal.
    ///
    /// State read inside this view's body is not an automatic invalidation input. Hoist any
    /// state that must update the body and include it in this view's `Equatable` implementation.
    /// Non-Android platforms return the original view.
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
    /// parent-driven body evaluation for this subtree. State read inside this view's body is not
    /// an automatic invalidation input, so hoist state that must update the body and include its
    /// value in `recomposeOverride`. Non-Android platforms return the original view.
    public func androidEquatable<RecomposeOverride: Equatable>(recomposeOverride: RecomposeOverride) -> some View {
        #if SKIP
        return AndroidEquatableView(content: self, recomposeOverride: recomposeOverride)
        #else
        return self
        #endif
    }
}

#endif
