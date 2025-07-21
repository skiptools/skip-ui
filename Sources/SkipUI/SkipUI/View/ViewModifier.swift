// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
#endif

// SKIP @bridge
public protocol ViewModifier {
    #if SKIP
    // SKIP DECLARE: fun body(content: View): View = content
    @ViewBuilder @MainActor func body(content: View) -> any View
    typealias Content = View
    #else
//    associatedtype Body : View
//    @ViewBuilder @MainActor func body(content: Self.Content) -> Self.Body
//    associatedtype Content
    #endif
}

#if SKIP
extension ViewModifier {
    /// Evaluate renderable content.
    ///
    /// - Seealso: `View.Evaluate(context:options:)`
    @Composable public func Evaluate(content: Content, context: ComposeContext, options: Int = 0) -> kotlin.collections.List<Renderable> {
        return body(content: content).Evaluate(context: context, options: options)
    }
}

final class ViewModifierView: View {
    let view: View
    let modifier: ViewModifier

    init(view: View, modifier: ViewModifier) {
        // Don't copy
        // SKIP REPLACE: this.view = view
        self.view = view
        // SKIP REPLACE: this.modifier = modifier
        self.modifier = modifier
    }

    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        return modifier.Evaluate(content: view, context: context, options: options)
    }
}
#endif

extension View {
    // SKIP @bridge
    public func modifier(_ viewModifier: any ViewModifier) -> any View {
        #if SKIP
        return ViewModifierView(view: self, modifier: viewModifier)
        #else
        return self
        #endif
    }
}

#endif
