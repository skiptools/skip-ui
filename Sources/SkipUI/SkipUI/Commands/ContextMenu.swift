// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.foundation.gestures.awaitEachGesture
import androidx.compose.foundation.layout.Box
import androidx.compose.material3.DropdownMenu
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.pointer.PointerEventPass
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalHapticFeedback
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeoutOrNull
import kotlin.math.abs

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
    let haptic = LocalHapticFeedback.current
    let isMenuExpanded = remember { mutableStateOf(false) }
    let nestedMenu = remember { mutableStateOf<Menu?>(nil) }
    let coroutineScope = rememberCoroutineScope()
    let contentContext = context.content()
    let isContextMenuEnabled = EnvironmentValues.shared.isEnabled && EnvironmentValues.shared._isHitTestingEnabled
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
        let interactionModifier: Modifier
        if isContextMenuEnabled {
            // Use pointerInput on the Initial pass to detect long press without consuming
            // events, so that child clickable handlers (e.g. Buttons) still receive taps.
            // Standard APIs like combinedClickable consume the down event on the Main pass,
            // which prevents nested clickables from firing.
            interactionModifier = modifier.pointerInput(true) {
                let slop = viewConfiguration.touchSlop
                awaitEachGesture {
                    let down = awaitPointerEvent(pass: PointerEventPass.Initial)
                    if let start = down.changes.firstOrNull({ $0.pressed })?.position {
                        let longPressed = withTimeoutOrNull(viewConfiguration.longPressTimeoutMillis) {
                            var active = true
                            while active {
                                if let c = awaitPointerEvent(pass: PointerEventPass.Initial).changes.firstOrNull() {
                                    active = c.pressed && abs(c.position.x - start.x) <= slop && abs(c.position.y - start.y) <= slop
                                } else {
                                    active = false
                                }
                            }
                        } == nil
                        if longPressed {
                            haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                            isMenuExpanded.value = true
                            // Consume remaining pointer events so the child's tap handler
                            // does not fire when the finger lifts
                            var pressed = true
                            while pressed {
                                let event = awaitPointerEvent(pass: PointerEventPass.Initial)
                                event.changes.forEach { $0.consume() }
                                pressed = event.changes.any({ $0.pressed })
                            }
                        }
                    }
                }
            }
        } else {
            interactionModifier = modifier
        }
        Box(modifier: interactionModifier) {
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
