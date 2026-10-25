// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import android.content.ClipData
import androidx.compose.foundation.gestures.awaitEachGesture
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.graphics.layer.drawLayer
import androidx.compose.ui.graphics.rememberGraphicsLayer
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.input.pointer.PointerEventPass
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.platform.LocalView
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeoutOrNull
import kotlin.math.abs
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.draganddrop.dragAndDropTarget
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.draganddrop.DragAndDropEvent
import androidx.compose.ui.draganddrop.DragAndDropTarget
import androidx.compose.ui.draganddrop.DragAndDropTransferData
import androidx.compose.ui.draganddrop.toAndroidDragEvent
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
#endif

extension View {
    /// Lets the user long-press and drag this view's payload to a drop destination.
    ///
    /// Payloads travel as plain text, so they also drop into other apps; within the app, drops receive the original value.
    /// - Note: The payload is captured when the view renders, as Kotlin has no autoclosures.
    public func draggable<T>(_ payload: T) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: DraggableModifier(payload: { payload as Any }))
        #else
        return self
        #endif
    }

    /// Bridged drag source; in-app drops receive the same payload object.
    // SKIP @bridge
    public func draggable(bridgedPayload: @escaping () -> Any) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: DraggableModifier(payload: bridgedPayload))
        #else
        return self
        #endif
    }

    /// Bridged drop target; items are in-app payloads or other apps' text.
    // SKIP @bridge
    public func dropDestination(bridgedAccepts: @escaping (Any) -> Bool, bridgedAction: @escaping ([Any], CGFloat, CGFloat) -> Bool, isTargeted: @escaping (Bool) -> Void) -> any View {
        #if SKIP
        let modifier = DropTargetModifier(accepts: bridgedAccepts, isTargeted: isTargeted, showsInsertionIndicator: false) { items, location, _ in
            return bridgedAction(Array(items), location.x, location.y)
        }
        return ModifiedContent(content: self, modifier: modifier)
        #else
        return self
        #endif
    }

    /// Accepts dropped payloads of the given type; `location` is in this view's coordinate space.
    // SKIP DECLARE: fun <T: Any> dropDestination(for_: KClass<T>, action: (Array<T>, CGPoint) -> Boolean, isTargeted: (Boolean) -> Unit = { _ -> }): View
    public func dropDestination<T>(for payloadType: T.Type, action: @escaping (_ items: [T], _ location: CGPoint) -> Bool, isTargeted: @escaping (Bool) -> Void = { _ in }) -> any View {
        #if SKIP
        let modifier = DropTargetModifier(accepts: { payloadType.isInstance($0) }, isTargeted: isTargeted, showsInsertionIndicator: false) { items, location, _ in
            return action(Array(items.map { $0 as! T }), location)
        }
        return ModifiedContent(content: self, modifier: modifier)
        #else
        return self
        #endif
    }
}

extension ForEach {
    /// Bridged row drop target.
    // SKIP @bridge
    public func dropDestination(bridgedAccepts: @escaping (Any) -> Bool, bridgedAction: @escaping ([Any], Int) -> Void) -> ForEach {
        #if SKIP
        dropAction = ForEachDropAction(accepts: bridgedAccepts, action: { items, index in bridgedAction(Array(items), index) })
        #endif
        return self
    }

    /// Accepts payloads dropped onto a `List`'s rows, inserting above or below the row under the drop, as on iOS.
    // SKIP DECLARE: fun <T: Any> dropDestination(for_: KClass<T>, action: (Array<T>, Int) -> Unit): ForEach
    public func dropDestination<T>(for payloadType: T.Type, action: @escaping ([T], Int) -> Void) -> ForEach {
        #if SKIP
        dropAction = ForEachDropAction(accepts: { payloadType.isInstance($0) }, action: { items, index in action(Array(items.map { $0 as! T }), index) })
        #endif
        return self
    }
}

#if SKIP
/// A `ForEach` drop destination, applied to each row.
final class ForEachDropAction {
    let accepts: (Any) -> Bool
    let action: (kotlin.collections.List<Any>, Int) -> Void

    init(accepts: @escaping (Any) -> Bool, action: @escaping (kotlin.collections.List<Any>, Int) -> Void) {
        self.accepts = accepts
        self.action = action
    }

    /// Mark the row at `index` as a drop target that inserts at `index` or `index + 1`; `List` applies it to the whole row.
    func applied(to renderable: Renderable, index: Int) -> Renderable {
        let modifier = ListRowDropModifier(accepts: accepts) { items, location, size in
            action(items, location.y < size.height / 2.0 ? index : index + 1)
            return true
        }
        return ModifiedContent.apply(modifiers: listOf(modifier), to: renderable)
    }
}

/// Marks a list row as a drop target, which `List` attaches to the full row rather than its content.
final class ListRowDropModifier: RenderModifier {
    let accepts: (Any) -> Bool
    let onDrop: (kotlin.collections.List<Any>, CGPoint, CGSize) -> Bool

    init(accepts: @escaping (Any) -> Bool, onDrop: @escaping (kotlin.collections.List<Any>, CGPoint, CGSize) -> Bool) {
        self.accepts = accepts
        self.onDrop = onDrop
        super.init()
    }
}

/// In-app drag payloads, keyed by the drag's clip label, so drops receive the original values.
struct DragPayloads {
    static let labelPrefix = "skip.drag:"
    private static var payloads: [String: Any] = [:]

    static func register(_ payload: Any) -> String {
        let label = labelPrefix + UUID().uuidString
        payloads = [label: payload] // Only one drag is in flight at a time
        return label
    }

    /// The dragged values: the registered payload for in-app drags, else the clip's text.
    static func items(in event: DragAndDropEvent) -> kotlin.collections.List<Any> {
        let dragEvent = event.toAndroidDragEvent()
        if let label = dragEvent.clipDescription?.label?.toString(), let payload = payloads[label] {
            return listOf(payload)
        }
        guard let clipData = dragEvent.clipData else {
            return listOf()
        }
        var items: kotlin.collections.MutableList<Any> = mutableListOf()
        for i in 0..<clipData.itemCount {
            if let text = clipData.getItemAt(i).text {
                items.add(text.toString())
            }
        }
        return items
    }
}

final class DraggableModifier: RenderModifier {
    init(payload: @escaping () -> Any) {
        super.init()
        self.action = { renderable, context in
            let view = LocalView.current
            let haptic = LocalHapticFeedback.current
            let snapshot = rememberGraphicsLayer()
            let coroutineScope = rememberCoroutineScope()
            let contentContext = context.content()
            ComposeContainer(eraseAxis: true, modifier: context.modifier) { modifier in
                // Record the content so the drag shadow shows the view being dragged, as on iOS
                // SKIP REPLACE: val recordingModifier = modifier.drawWithContent { snapshot.record { this@drawWithContent.drawContent() }; drawLayer(snapshot) }
                let recordingModifier = modifier
                // Detect the long press on the initial pass, like context menus, so enclosing lists and buttons don't consume it
                let sourceModifier = recordingModifier.pointerInput(true) {
                    let slop = viewConfiguration.touchSlop
                    awaitEachGesture {
                        let down = awaitPointerEvent(pass: PointerEventPass.Initial)
                        guard let start = down.changes.firstOrNull({ $0.pressed })?.position else {
                            return
                        }
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
                        guard longPressed else {
                            return
                        }
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        let value = payload()
                        let clipData = ClipData.newPlainText(DragPayloads.register(value), "\(value)")
                        coroutineScope.launch {
                            let bitmap = snapshot.toImageBitmap().asAndroidBitmap()
                            view.startDragAndDrop(clipData, SnapshotDragShadow(bitmap: bitmap, touchX: Int(start.x), touchY: Int(start.y)), nil, android.view.View.DRAG_FLAG_GLOBAL)
                        }
                    }
                }
                Box(modifier: sourceModifier) {
                    renderable.Render(context: contentContext)
                }
            }
        }
    }
}

/// Draws the dragged view's snapshot under the finger.
final class SnapshotDragShadow: android.view.View.DragShadowBuilder {
    let bitmap: android.graphics.Bitmap
    let touchX: Int
    let touchY: Int

    init(bitmap: android.graphics.Bitmap, touchX: Int, touchY: Int) {
        self.bitmap = bitmap
        self.touchX = touchX
        self.touchY = touchY
        super.init()
    }

    override func onProvideShadowMetrics(outShadowSize: android.graphics.Point, outShadowTouchPoint: android.graphics.Point) {
        outShadowSize.set(max(1, bitmap.width), max(1, bitmap.height))
        outShadowTouchPoint.set(touchX, touchY)
    }

    override func onDrawShadow(canvas: android.graphics.Canvas) {
        canvas.drawBitmap(bitmap, Float(0.0), Float(0.0), nil)
    }
}

/// Receives drops, reporting the drop location in the target's coordinate space in points.
final class DropTarget: DragAndDropTarget {
    let accepts: (Any) -> Bool
    let dropAction: (kotlin.collections.List<Any>, CGPoint, CGSize) -> Bool
    let isTargeted: ((Bool) -> Void)?
    let bounds: MutableState<Rect>
    /// -1 while hovering over the top half, 1 over the bottom half, else 0.
    let hoverEdge: MutableState<Int>
    let density: Float

    init(accepts: @escaping (Any) -> Bool, onDrop: @escaping (kotlin.collections.List<Any>, CGPoint, CGSize) -> Bool, isTargeted: ((Bool) -> Void)?, bounds: MutableState<Rect>, hoverEdge: MutableState<Int>, density: Float) {
        self.accepts = accepts
        self.dropAction = onDrop
        self.isTargeted = isTargeted
        self.bounds = bounds
        self.hoverEdge = hoverEdge
        self.density = density
    }

    private func location(of event: DragAndDropEvent) -> CGPoint {
        let dragEvent = event.toAndroidDragEvent()
        return CGPoint(x: Double(dragEvent.x - bounds.value.left) / Double(density), y: Double(dragEvent.y - bounds.value.top) / Double(density))
    }

    private var size: CGSize {
        return CGSize(width: Double(bounds.value.width) / Double(density), height: Double(bounds.value.height) / Double(density))
    }

    override func onEntered(event: DragAndDropEvent) {
        if let isTargeted {
            isTargeted(true)
        }
    }

    override func onMoved(event: DragAndDropEvent) {
        hoverEdge.value = location(of: event).y < size.height / 2.0 ? -1 : 1
    }

    override func onExited(event: DragAndDropEvent) {
        hoverEdge.value = 0
        if let isTargeted {
            isTargeted(false)
        }
    }

    override func onEnded(event: DragAndDropEvent) {
        hoverEdge.value = 0
    }

    override func onDrop(event: DragAndDropEvent) -> Bool {
        hoverEdge.value = 0
        if let isTargeted {
            isTargeted(false)
        }
        let items = DragPayloads.items(in: event).filter { accepts($0) }
        guard items.size > 0 else {
            return false
        }
        return dropAction(items, location(of: event), size)
    }
}

final class DropTargetModifier: RenderModifier {
    init(accepts: @escaping (Any) -> Bool, isTargeted: ((Bool) -> Void)?, showsInsertionIndicator: Bool, onDrop: @escaping (kotlin.collections.List<Any>, CGPoint, CGSize) -> Bool) {
        super.init()
        self.action = { renderable, context in
            let modifier = context.modifier.then(dropTargetModifier(accepts: accepts, isTargeted: isTargeted, showsInsertionIndicator: showsInsertionIndicator, onDrop: onDrop))
            renderable.Render(context: context.content(modifier: modifier))
        }
    }
}

/// A modifier that receives drops and optionally draws an insertion line above or below the hovered half, as on iOS.
@Composable func dropTargetModifier(accepts: @escaping (Any) -> Bool, isTargeted: ((Bool) -> Void)?, showsInsertionIndicator: Bool, onDrop: @escaping (kotlin.collections.List<Any>, CGPoint, CGSize) -> Bool) -> Modifier {
    let bounds = remember { mutableStateOf(Rect.Zero) }
    let hoverEdge = remember { mutableStateOf(0) }
    let density = LocalDensity.current.density
    let updatedOnDrop = rememberUpdatedState(onDrop)
    let target = remember { DropTarget(accepts: accepts, onDrop: { items, location, size in updatedOnDrop.value(items, location, size) }, isTargeted: isTargeted, bounds: bounds, hoverEdge: hoverEdge, density: density) }
    let indicatorColor = (EnvironmentValues.shared._tint ?? Color.accentColor).colorImpl()
    var modifier: Modifier = Modifier
        .onGloballyPositioned { bounds.value = $0.boundsInWindow() }
        .dragAndDropTarget(shouldStartDragAndDrop: { _ in true }, target: target)
    if showsInsertionIndicator {
        modifier = modifier.drawWithContent {
            drawContent()
            let edge = hoverEdge.value
            if edge != 0 {
                let y = edge < 0 ? Float(0.0) : size.height
                drawLine(indicatorColor, Offset(Float(0.0), y), Offset(size.width, y), 3.dp.toPx())
            }
        }
    }
    return modifier
}
#endif

#endif
