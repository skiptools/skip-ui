// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
#endif

/// Renders content via Compose.
public protocol Renderable {
    #if SKIP
    @Composable func Render(context: ComposeContext)
    #endif
}

#if SKIP
extension Renderable {
    /// Whether this renderable specializes for list items.
    ///
    /// - Returns: A tuple containing whether this item specializes rendering for list items and any list item action it applies.
    ///     The given action will become a tap action on the entire list item cell.
    @Composable public func shouldRenderListItem(context: ComposeContext) -> (Bool, (() -> Void)?) {
        return (false, nil)
    }

    /// Render as a list item.
    @Composable public func RenderListItem(context: ComposeContext, modifiers: kotlin.collections.List<ModifierProtocol>) {
    }

    /// Whether this is an empty view.
    public final var isSwiftUIEmptyView: Bool {
        return strip() is EmptyView
    }

    /// Strip enclosing modifiers, etc.
    public func strip() -> Renderable {
        return self
    }

    /// Perform an action for every modifier.
    ///
    /// The first non-nil value will be returned.
    public func forEachModifier<R>(perform action: (ModifierProtocol) -> R?) -> R? {
        return nil
    }

    /// Represent this `Renderable` as a `View`.
    public func asView() -> View {
        return self as? View ?? ComposeView(content: { self.Render($0) })
    }
}

#endif
#endif

