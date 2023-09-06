// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
// SKIP INSERT: 
// import androidx.compose.runtime.Composable
// import androidx.compose.runtime.saveable.Saver
// import androidx.compose.ui.Modifier

/// Context to provide modifiers, parent, etc to composables.
public struct ComposeContext {
    /// Mechanism for a parent view to change how a child view is composed.
    public var composer: (@Composable (inout View, ComposeContext) -> Void)?

    /// Modifiers to apply.
    public var modifier: Modifier = Modifier

    /// Use in conjunction with `rememberSaveable` to store view state.
    public var stateSaver: Saver<Any, Any> = ComposeStateSaver()

    /// The context to pass to child content of a container view.
    public func content(modifier: Modifier = Modifier, composer: (@Composable (inout View, ComposeContext) -> Void)? = nil) -> ComposeContext {
        var context = self
        context.modifier = modifier
        context.composer = composer
        return context
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

    @Composable override func ComposeContent(context: ComposeContext) {
        var context = context
        contextTransform(&context)
        view.ComposeContent(context)
    }
}
#endif
