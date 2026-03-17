// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.Box
import androidx.compose.material3.DropdownMenu
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/// Modifier that wraps content in a long-press-triggered dropdown menu.
class ContextMenuModifier: RenderModifier {
    let menuItems: ComposeBuilder

    init(menuItems: ComposeBuilder) {
        self.menuItems = menuItems
        super.init()
        self.action = { content, context in
            RenderContextMenu(content: content, context: context, menuItems: self.menuItems)
        }
    }
}

@Composable func RenderContextMenu(content: Renderable, context: ComposeContext, menuItems: ComposeBuilder) {
    let isMenuExpanded = remember { mutableStateOf(false) }
    let nestedMenu = remember { mutableStateOf<Menu?>(nil) }
    let coroutineScope = rememberCoroutineScope()
    let contentContext = context.content()
    let replaceMenu: (Menu?) -> Void = { menu in
        coroutineScope.launch {
            delay(200)
            isMenuExpanded.value = false
            delay(100)
            nestedMenu.value = nil
            if let menu {
                nestedMenu.value = menu
                isMenuExpanded.value = true
            }
        }
    }
    ComposeContainer(eraseAxis: true, modifier: context.modifier) { modifier in
        Box(modifier: modifier.combinedClickable(
            onLongClick: { isMenuExpanded.value = true },
            onClick: {}
        )) {
            content.Render(context: contentContext)
            DropdownMenu(expanded: isMenuExpanded.value, onDismissRequest: {
                isMenuExpanded.value = false
                coroutineScope.launch {
                    delay(100)
                    nestedMenu.value = nil
                }
            }) {
                var placement = EnvironmentValues.shared._placement
                EnvironmentValues.shared.setValues {
                    placement.remove(ViewPlacement.toolbar)
                    $0.set_placement(placement)
                    return ComposeResult.ok
                } in: {
                    let renderables = (nestedMenu.value?.content ?? menuItems).Evaluate(context: contentContext, options: 0)
                    Menu.RenderDropdownMenuItems(for: renderables, context: contentContext, replaceMenu: replaceMenu)
                }
            }
        }
    }
}
#endif
