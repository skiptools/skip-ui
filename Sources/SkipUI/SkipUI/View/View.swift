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
    // SKIP DECLARE: fun body(): View = EmptyView()
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
            for renderable in Evaluate(context: context) {
                renderable.Render(context: context)
            }
            return ComposeResult.ok
        }
    }

    /// Evaluate renderable content.
    @Composable public func Evaluate(context: ComposeContext, options: Int = 0) -> kotlin.collections.List<Renderable> {
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

private final class ViewRenderable: Renderable {
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
