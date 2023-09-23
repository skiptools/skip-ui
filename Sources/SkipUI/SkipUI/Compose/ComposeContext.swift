// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.saveable.Saver
import androidx.compose.ui.Modifier

/// Context to provide modifiers, parent, etc to composables.
public struct ComposeContext {
    /// Modifiers to apply.
    public var modifier: Modifier = Modifier

    /// Use in conjunction with `rememberSaveable` to store view state.
    public var stateSaver: Saver<Any, Any> = ComposeStateSaver()

    /// Mechanism for a parent view to change how a child view is composed.
    public var composer: (@Composable (inout View, ComposeContext) -> Void)?

    /// The context to pass to child content of a container view.
    public func content(modifier: Modifier = Modifier, stateSaver: Saver<Any, Any>? = nil, composer: (@Composable (inout View, ComposeContext) -> Void)? = nil) -> ComposeContext {
        var context = self
        context.modifier = modifier
        context.stateSaver = stateSaver ?? self.stateSaver
        context.composer = composer
        return context
    }
}
#endif
