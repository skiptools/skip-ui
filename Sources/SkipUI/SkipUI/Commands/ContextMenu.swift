// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.foundation.gestures.awaitEachGesture
import androidx.compose.foundation.gestures.awaitFirstDown
import androidx.compose.foundation.gestures.waitForUpOrCancellation
import androidx.compose.foundation.layout.Box
import androidx.compose.material3.DropdownMenu
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.pointer.PointerEvent
import androidx.compose.ui.input.pointer.PointerEventPass
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalViewConfiguration
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeoutOrNull

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
    let viewConfig = LocalViewConfiguration.current

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

    let gestureModifier = Modifier.pointerInput(Unit) {
        awaitEachGesture {
            let down = awaitFirstDown(pass: PointerEventPass.Initial)
            let longPressTimeout = viewConfig.longPressTimeoutMillis
            var isCancelled = false

            let success = withTimeoutOrNull(longPressTimeout) {
                while true {
                    let event = awaitPointerEvent(pass: PointerEventPass.Initial)
                    if event.changes.any({ $0.isConsumed || (!$0.pressed && $0.previousPressed) }) {
                        isCancelled = true
                        break
                    }

                    let totalChange = event.changes[0].position.minus(down.position)
                    if totalChange.getDistance() > viewConfig.touchSlop {
                        isCancelled = true
                        break
                    }
                }
                waitForUpOrCancellation(pass: PointerEventPass.Initial)
            }

            if success == nil && !isCancelled {
                isMenuExpanded.value = true
                var event: PointerEvent
                repeat {
                    event = awaitPointerEvent(pass: PointerEventPass.Initial)
                    event.changes.forEach { $0.consume() }
                } while event.changes.any { $0.pressed }
            }
        }
    }

    ComposeContainer(eraseAxis: true, modifier: context.modifier.then(gestureModifier)) { modifier in
        Box(modifier: modifier, propagateMinConstraints: true) {
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
