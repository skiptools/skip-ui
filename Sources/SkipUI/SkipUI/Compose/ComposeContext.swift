// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
// SKIP INSERT: import androidx.compose.runtime.Composable
// SKIP INSERT: import androidx.compose.runtime.saveable.Saver
// SKIP INSERT: import androidx.compose.ui.Modifier

/// Context to provide modifiers, environment, etc to composables.
public struct ComposeContext {
    public var modifier: Modifier = Modifier
    public var tag: AnyHashable?

    // TODO: Environment
    public struct Style {
        public var color: Color?
        public var font: Font?
        public var fontWeight: Font.Weight?
        public var isItalic = false
    }
    public var style = Style()

    /// Use in conjunction with `rememberSaveable` to store view state.
    public var stateSaver: Saver<Any, Any> = ComposeStateSaver()

    /// The context to pass to child views.
    public func child() -> ComposeContext {
        return ComposeContext(style: style, stateSaver: stateSaver)
    }
}

/// Used internally by modifiers to apply changes to the context supplied to modified views.
struct ComposeContextView: View {
    let view: View
    let contextTransform: @Composable (inout ComposeContext) -> Void

    init(_ view: any View, contextTransform: @Composable (inout ComposeContext) -> Void) {
        self.view = view
        self.contextTransform = contextTransform
    }

    @Composable override func Compose(ctx: ComposeContext) {
        var ctx = ctx
        contextTransform(&ctx)
        view.Compose(ctx)
    }
}
#endif
