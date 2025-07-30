// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import skip.model.StateTracking
#endif

// SKIP @bridge
public protocol View {
    #if SKIP
    // Note: We default the body to invoke the deprecated `ComposeContent` function for backwards compatibility
    // with custom pre-Renderable views that overrode `ComposeContent`
    // SKIP DECLARE: fun body(): View = ComposeView({ ComposeContent(it) })
    @ViewBuilder @MainActor var body: any View { get }
    #else
    associatedtype Body : View
    @ViewBuilder @MainActor var body: Body { get }
    #endif
}

#if SKIP
extension View {
    /// Compose this view without an existing context - typically called when integrating a SwiftUI view tree into pure Compose.
    ///
    /// - Seealso: `Compose(context:)`
    @Composable public func Compose() -> ComposeResult {
        return Compose(context: ComposeContext())
    }

    /// Compose this view's content.
    ///
    /// Calls to `Compose` are added by the transpiler.
    @Composable public func Compose(context: ComposeContext) -> ComposeResult {
        if let composer = context.composer {
            let composerContext: (Bool) -> ComposeContext = { retain in
                guard !retain else {
                    return context
                }
                var context = context
                context.composer = nil
                return context
            }
            return composer.Compose(self, composerContext)
        } else {
            _ComposeContent(context: context)
            return ComposeResult.ok
        }
    }

    /// DEPRECATED
    @Composable public func ComposeContent(context: ComposeContext) {
    }

    /// This function provides a non-escaping compose context to avoid excessive recompositions when the calling code
    /// does not need to access the underlying `Renderables`.
    @Composable public func _ComposeContent(context: ComposeContext) {
        for renderable in Evaluate(context: context, options: 0) {
            renderable.Render(context: context)
        }
    }

    /// Evaluate renderable content.
    ///
    /// - Warning: Do not give `options` a default value in this function signature. We have seen it cause bugs in which
    ///     the default version of the function is always invoked, ignoring implementor overrides.
    @Composable public func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        if let renderable = self as? Renderable {
            return listOf(self)
        } else {
            StateTracking.pushBody()
            let renderables = body.Evaluate(context: context, options: options)
            StateTracking.popBody()
            return renderables
        }
    }

    /// Helper for the rare cases that we want to treat a `View` as a `Renderable` without evaluating it.
    ///
    /// - Warning: For special cases only.
    public func asRenderable() -> Renderable {
        return self as? Renderable ?? ViewRenderable(view: self)
    }
}

/// Helper for the rare cases that we want to treat a `View` as a `Renderable` without evaluating it.
///
/// - Warning: For special cases only.
final class ViewRenderable: Renderable {
    let view: View

    init(view: View) {
        // Don't copy
        // SKIP REPLACE: this.view = view
        self.view = view
    }

    @Composable override func Render(context: ComposeContext) {
        view.Compose(context: context)
    }
}

#else

// Stubs needed to compile this package:

extension Optional : View where Wrapped : View {
    public var body: some View {
        stubView()
    }
}

extension Never : View {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Never {
    public typealias Body = NeverView
    public var body: Never { get { fatalError() } }
}

#endif
#endif
