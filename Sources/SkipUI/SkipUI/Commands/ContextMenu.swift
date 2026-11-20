// Copyright 2023–2026 Skip
#if SKIP
import androidx.compose.foundation.gestures.awaitEachGesture
import androidx.compose.foundation.layout.Box
import androidx.compose.material3.DropdownMenu
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.key.Key
import androidx.compose.ui.input.key.KeyEventType
import androidx.compose.ui.input.key.key
import androidx.compose.ui.input.key.onKeyEvent
import androidx.compose.ui.input.key.onPreviewKeyEvent
import androidx.compose.ui.input.key.type
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
    // Set when a select key (D-pad center / Enter) has been held past the long-press timeout
    let isSelectKeyLongPressed = remember { mutableStateOf(false) }
    let nestedMenu = remember { mutableStateOf<Menu?>(nil) }
    let coroutineScope = rememberCoroutineScope()
    let contentContext = context.content()
    let primaryMenuItems = menuItems.Evaluate(context: contentContext, options: 0).filter { !$0.isSwiftUIEmptyView }
    let isContextMenuEnabled = EnvironmentValues.shared.isEnabled && EnvironmentValues.shared._isHitTestingEnabled && primaryMenuItems.size > 0
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
            // Keyboard / remote input (e.g. Android TV): holding the select key or pressing the Menu key opens the menu.
            .onKeyEvent { keyEvent in
                if isSelectKey(keyEvent.key) {
                    // The focused child (e.g. a Button) ignores repeated key downs and lets them bubble up here.
                    // A repeat means the key has been held past the long-press timeout.
                    if keyEvent.type == KeyEventType.KeyDown && keyEvent.nativeKeyEvent.repeatCount > 0 {
                        isSelectKeyLongPressed.value = true
                        return true
                    }
                    return false
                }
                if keyEvent.key == Key.Menu {
                    if keyEvent.type == KeyEventType.KeyUp {
                        isMenuExpanded.value = true
                    }
                    return true
                }
                return false
            }
            .onPreviewKeyEvent { keyEvent in
                guard isSelectKey(keyEvent.key) else {
                    return false
                }
                if keyEvent.type == KeyEventType.KeyDown && keyEvent.nativeKeyEvent.repeatCount == 0 {
                    isSelectKeyLongPressed.value = false
                } else if keyEvent.type == KeyEventType.KeyUp && isSelectKeyLongPressed.value {
                    // Open on release rather than while held: once the menu has focus, further repeats would land on
                    // its first item, which would then be clicked on release. Consuming the key up also keeps the
                    // focused child from being clicked; it cancels its pending press when the menu takes focus.
                    isSelectKeyLongPressed.value = false
                    isMenuExpanded.value = true
                    return true
                }
                return false
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
                    let renderables = nestedMenu.value?.content.Evaluate(context: contentContext, options: 0) ?? primaryMenuItems
                    Menu.RenderDropdownMenuItems(for: renderables, context: contentContext, replaceMenu: replaceMenu)
                }
            }
        }
    }
}
private func isSelectKey(_ key: Key) -> Bool {
    return key == Key.DirectionCenter || key == Key.Enter || key == Key.NumPadEnter
}
#endif
