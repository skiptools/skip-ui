// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.ScrollState
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.ScrollableState
import androidx.compose.foundation.gestures.animateScrollBy
import androidx.compose.foundation.gestures.scrollBy
import androidx.compose.foundation.interaction.DragInteraction
import androidx.compose.foundation.interaction.InteractionSource
import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.foundation.lazy.grid.LazyGridState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.snapshotFlow
import androidx.compose.runtime.withFrameNanos
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.layout.LayoutCoordinates
import androidx.compose.ui.unit.IntSize
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
#endif

/// Where a scroll view's content is scrolled to: a view ID, an edge, or a content offset.
// SKIP @bridge
public struct ScrollPosition : Equatable {
    public internal(set) var edge: Edge?
    public internal(set) var viewID: AnyHashable?
    public var isPositionedByUser = false
    /// The content offset on each axis, nil to leave that axis where it is.
    var x: CGFloat?
    var y: CGFloat?
    var anchor: UnitPoint?

    public init(idType: Any.Type? = nil) {
    }

    public init(id: AnyHashable, anchor: UnitPoint? = nil) {
        self.viewID = id
        self.anchor = anchor
    }

    public init(idType: Any.Type? = nil, edge: Edge) {
        self.edge = edge
    }

    public init(idType: Any.Type? = nil, point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }

    public init(idType: Any.Type? = nil, x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }

    public init(idType: Any.Type? = nil, x: CGFloat) {
        self.x = x
    }

    public init(idType: Any.Type? = nil, y: CGFloat, unusedp: Any? = nil) {
        self.y = y
    }

    /// `bridgedEdge` is an `Edge` raw value.
    // SKIP @bridge
    public init(bridgedID: Any?, bridgedEdge: Int?, x: CGFloat?, y: CGFloat?, anchorX: CGFloat?, anchorY: CGFloat?, isPositionedByUser: Bool) {
        self.viewID = bridgedID as? AnyHashable
        self.edge = bridgedEdge == nil ? nil : Edge(rawValue: bridgedEdge!)
        self.x = x
        self.y = y
        self.anchor = anchorX == nil || anchorY == nil ? nil : UnitPoint(x: anchorX!, y: anchorY!)
        self.isPositionedByUser = isPositionedByUser
    }

    /// The content offset, when the position sets both axes.
    public var point: CGPoint? {
        return x == nil || y == nil ? nil : CGPoint(x: x!, y: y!)
    }

    // SKIP DECLARE: fun <T: Any> viewID(type: KClass<T>): T?
    public func viewID<T>(type: T.Type) -> T? where T : Hashable {
        return viewID as? T
    }

    public mutating func scrollTo(id: AnyHashable, anchor: UnitPoint? = nil) {
        self = ScrollPosition(id: id, anchor: anchor)
    }

    public mutating func scrollTo(edge: Edge) {
        self = ScrollPosition(edge: edge)
    }

    public mutating func scrollTo(point: CGPoint) {
        self = ScrollPosition(point: point)
    }

    public mutating func scrollTo(x: CGFloat, y: CGFloat) {
        self = ScrollPosition(x: x, y: y)
    }

    public mutating func scrollTo(x: CGFloat) {
        self = ScrollPosition(x: x)
    }

    public mutating func scrollTo(y: CGFloat, unusedp: Any? = nil) {
        self = ScrollPosition(y: y)
    }

    #if SKIP
    /// The content offset this position asks for along an axis, in points, with the end edge at infinity.
    func offset(isVertical: Bool) -> CGFloat? {
        switch edge {
        case .top: return isVertical ? 0.0 : nil
        case .bottom: return isVertical ? CGFloat.infinity : nil
        case .leading: return isVertical ? nil : 0.0
        case .trailing: return isVertical ? nil : CGFloat.infinity
        default: return isVertical ? y : x
        }
    }
    #endif
}

extension View {
    /// Scrolls the scroll view in this view as `position` changes, and writes back where the user scrolls it to.
    public func scrollPosition(_ position: Binding<ScrollPosition>, anchor: UnitPoint? = nil, unusedp: Any? = nil) -> any View {
        #if SKIP
        let binding = Binding(get: {
            var value = position.wrappedValue
            value.anchor = value.anchor ?? anchor
            return value
        }, set: {
            position.wrappedValue = $0
        })
        return environment(\._scrollPosition, binding, affectsEvaluate: false)
        #else
        return self
        #endif
    }

    /// Bridged position: `onUserScroll` receives the ID of the view at the anchor as the user scrolls.
    // SKIP @bridge
    public func scrollPosition(getPosition: @escaping () -> ScrollPosition, onUserScroll: @escaping (Any?) -> Void, anchorX: CGFloat?, anchorY: CGFloat?) -> any View {
        let anchor = anchorX == nil || anchorY == nil ? nil : UnitPoint(x: anchorX!, y: anchorY!)
        return scrollPosition(Binding<ScrollPosition>(get: getPosition, set: { onUserScroll($0.viewID) }), anchor: anchor)
    }

    // An `out` binding makes `scrollPosition($position)` resolve to the `ScrollPosition` overload in Kotlin
    // SKIP DECLARE: fun scrollPosition(id: Binding<out Hashable?>, anchor: UnitPoint? = null): View
    public func scrollPosition(id: Binding<(some Hashable)?>, anchor: UnitPoint? = nil) -> some View {
        #if SKIP
        return scrollPosition(Binding<ScrollPosition>(get: {
            id.wrappedValue == nil ? ScrollPosition() : ScrollPosition(id: id.wrappedValue!)
        }, set: {
            (id as! Binding<AnyHashable?>).wrappedValue = $0.viewID
        }), anchor: anchor)
        #else
        return self
        #endif
    }
}

#if SKIP
/// A scroll container that the scroll position, `ScrollViewReader`, scroll geometry, and scroll phase APIs drive and observe.
protocol ScrollDriver {
    /// The source of the drags that tell the user's scrolling from the app's.
    var interactionSource: InteractionSource { get }

    /// Whether the content is scrolling. Reading it in a snapshot observes changes.
    var isScrollInProgress: Bool { get }

    /// The geometry in points. Reading it in a snapshot observes scrolling.
    var geometry: ScrollGeometry { get }

    /// The ID of the first view whose middle is past `anchor` in the visible region.
    func id(at anchor: UnitPoint) -> AnyHashable?

    /// Scroll to `position`, returning false when its view isn't laid out.
    // SKIP DECLARE: suspend fun scrollTo(position: ScrollPosition, animated: Boolean): Boolean
    func scrollTo(_ position: ScrollPosition, animated: Bool) -> Bool
}

extension EnvironmentValues {
    /// Clear the values a scroll container acts on, so that the scroll views inside it don't act on them too.
    func clearScrollContainerValues() {
        set_scrollPosition(nil)
        set_onScrollGeometryChange(nil)
        set_onScrollPhaseChange(nil)
    }
}

extension ScrollDriver {
    /// Scroll to `position` once its view is laid out, as it may arrive in the same update.
    // SKIP DECLARE: suspend fun scrollToLaidOut(position: ScrollPosition, animated: Boolean)
    func scrollToLaidOut(_ position: ScrollPosition, animated: Bool) {
        for _ in 0..<3 {
            // SKIP INSERT: withFrameNanos { _ -> }
            if scrollTo(position, animated: animated) {
                return
            }
        }
    }
}

/// The scroll offset that puts a view's `start` and `length` at `anchor` in the `viewport`, or, for a nil anchor, shows
/// all of it with the least scrolling from `current`.
private func alignedOffset(start: Float, length: Float, viewport: Float, current: Float, anchor: Double?) -> Float {
    if let anchor {
        return start - (viewport - length) * Float(anchor)
    }
    if start < current || length > viewport {
        return start
    }
    return max(current, start + length - viewport)
}

/// Connects a scroll container to `ScrollViewReader` and the scroll position, geometry, and phase APIs.
@Composable func ScrollDriverEffects(_ driver: ScrollDriver, context: ComposeContext) {
    let coroutineScope = rememberCoroutineScope()
    PreferenceValues.shared.contribute(context: context, key: ScrollToIDPreferenceKey.self, value: ScrollToIDAction(key: driver) { id, anchor in
        let isAnimated = Animation.isInWithAnimation
        coroutineScope.launch {
            driver.scrollToLaidOut(ScrollPosition(id: id, anchor: anchor), animated: isAnimated)
        }
    })

    if let position = EnvironmentValues.shared._scrollPosition {
        // Observe the position in effects rather than composition, so the app writing it never recomposes the container
        let currentPosition = rememberUpdatedState(position)
        let isScrolledByUser = remember { mutableStateOf(false) }
        LaunchedEffect(driver) {
            // The ID last written for the user's scrolling, which must not scroll the view when it reads back
            var userViewID: AnyHashable? = nil
            launch {
                driver.interactionSource.interactions.collect {
                    if $0 is DragInteraction.Start {
                        isScrolledByUser.value = true
                    }
                }
            }
            // As on iOS, the user's scrolling writes the ID of the view at the anchor, and nothing when views have no IDs
            launch {
                snapshotFlow {
                    isScrolledByUser.value ? driver.id(at: currentPosition.value.wrappedValue.anchor ?? UnitPoint.topLeading) : nil
                }.collect { id in
                    guard let id, id != currentPosition.value.wrappedValue.viewID else {
                        return
                    }
                    userViewID = id
                    currentPosition.value.wrappedValue = ScrollPosition(id: id)
                }
            }
            snapshotFlow { currentPosition.value.wrappedValue }.collectLatest { value in
                let isAnimated = Animation.isInWithAnimation
                guard !value.isPositionedByUser && (value.viewID == nil || value.viewID != userViewID) else {
                    return
                }
                userViewID = nil
                isScrolledByUser.value = false
                driver.scrollToLaidOut(value, animated: isAnimated)
            }
        }
    }

    if let onScrollGeometryChange = EnvironmentValues.shared._onScrollGeometryChange {
        let action = rememberUpdatedState(onScrollGeometryChange)
        LaunchedEffect(driver) {
            snapshotFlow { driver.geometry }.collect { action.value($0) }
        }
    }

    if let onScrollPhaseChange = EnvironmentValues.shared._onScrollPhaseChange {
        let action = rememberUpdatedState(onScrollPhaseChange)
        LaunchedEffect(driver) {
            var phase = ScrollPhase.idle
            var isDragging = false
            var isReleasing = false
            // As on iOS, the velocity is zero except as the user flings the content
            let change: (ScrollPhase, CGVector) -> Void = { newPhase, velocity in
                let oldPhase = phase
                phase = newPhase
                action.value(oldPhase, newPhase, ScrollPhaseChangeContext(geometry: driver.geometry, velocity: velocity))
            }
            // As on iOS, report the idle phase once laid out
            // SKIP INSERT: withFrameNanos { _ -> }
            change(ScrollPhase.idle, CGVector.zero)
            launch {
                driver.interactionSource.interactions.collect {
                    if $0 is DragInteraction.Start {
                        isDragging = true
                        change(ScrollPhase.interacting, CGVector.zero)
                    } else if $0 is DragInteraction.Stop || $0 is DragInteraction.Cancel {
                        isDragging = false
                        isReleasing = true
                        // A fling starts in the frame after the drag stops; its first frame gives its velocity
                        // SKIP INSERT: withFrameNanos { _ -> }
                        let startOffset = driver.geometry.contentOffset
                        let startTime = System.nanoTime()
                        // SKIP INSERT: withFrameNanos { _ -> }
                        isReleasing = false
                        guard driver.isScrollInProgress else {
                            change(ScrollPhase.idle, CGVector.zero)
                            return
                        }
                        let offset = driver.geometry.contentOffset
                        let milliseconds = max(Double(System.nanoTime() - startTime) / 1_000_000.0, 1.0)
                        change(ScrollPhase.decelerating, CGVector(dx: (offset.x - startOffset.x) / milliseconds, dy: (offset.y - startOffset.y) / milliseconds))
                    }
                }
            }
            // Scrolling that isn't the user's drag or fling is the app's animation, if it outlasts the frame that an
            // unanimated scroll ends in
            snapshotFlow { driver.isScrollInProgress }.collectLatest { isScrolling in
                guard !isDragging && !isReleasing else {
                    return
                }
                if !isScrolling && phase != ScrollPhase.idle {
                    change(ScrollPhase.idle, CGVector.zero)
                } else if isScrolling && phase == ScrollPhase.idle {
                    // SKIP INSERT: withFrameNanos { _ -> }
                    if driver.isScrollInProgress && !isDragging && phase == ScrollPhase.idle {
                        change(ScrollPhase.animating, CGVector.zero)
                    }
                }
            }
        }
    }
}

/// A `ScrollView` that scrolls its content itself, whose views with an `id` or `ForEach` identity are targets.
final class ScrollViewDriver: ScrollDriver {
    let state: ScrollState
    let isVertical: Bool
    let density: Float
    /// Laid out views by ID.
    var targets: [AnyHashable: LayoutCoordinates] = [:]
    /// The content, which moves within the viewport as it scrolls.
    var content: LayoutCoordinates?
    let viewportSize = mutableStateOf(IntSize.Zero)
    let contentSize = mutableStateOf(IntSize.Zero)
    /// The space the content reserves at its edges for the bars it scrolls beneath, in points, part of `contentSize`.
    let contentInsets = mutableStateOf(EdgeInsets())

    init(state: ScrollState, isVertical: Bool, density: Float) {
        self.state = state
        self.isVertical = isVertical
        self.density = density
    }

    var interactionSource: InteractionSource {
        return state.interactionSource
    }

    var isScrollInProgress: Bool {
        return state.isScrollInProgress
    }

    var geometry: ScrollGeometry {
        // As on iOS, the offset is -insets.top at the top, and the content size leaves out the insets
        let insets = contentInsets.value
        let offset = Double(state.value) / Double(density)
        var size = points(contentSize.value)
        if isVertical {
            size.height = max(0.0, size.height - insets.top - insets.bottom)
        }
        return ScrollGeometry(contentOffset: isVertical ? CGPoint(x: 0.0, y: offset - insets.top) : CGPoint(x: offset, y: 0.0), contentSize: size, contentInsets: insets, containerSize: points(viewportSize.value))
    }

    func id(at anchor: UnitPoint) -> AnyHashable? {
        let point = Float(state.value) + Float(length(viewportSize.value)) * Float(isVertical ? anchor.y : anchor.x)
        var match: AnyHashable? = nil
        var matchStart = Float.MAX_VALUE
        for (id, target) in targets {
            if let start = offset(of: target), start + Float(length(target.size)) / Float(2.0) >= point, start < matchStart {
                match = id
                matchStart = start
            }
        }
        return match
    }

    // SKIP DECLARE: override suspend fun scrollTo(position: ScrollPosition, animated: Boolean): Boolean
    func scrollTo(_ position: ScrollPosition, animated: Bool) -> Bool {
        let target: Float
        if let id = position.viewID {
            guard let coordinates = targets[id], let start = offset(of: coordinates) else {
                return false
            }
            let anchor = position.anchor
            target = alignedOffset(start: start, length: Float(length(coordinates.size)), viewport: Float(length(viewportSize.value)), current: Float(state.value), anchor: anchor == nil ? nil : isVertical ? anchor!.y : anchor!.x)
        } else if let offset = position.offset(isVertical: isVertical) {
            target = Float(offset) * density
        } else {
            return true
        }
        let value = Int(min(max(target, Float(0.0)), Float(state.maxValue)))
        if animated {
            state.animateScrollTo(value)
        } else {
            state.scrollTo(value)
        }
        return true
    }

    /// The start of a laid out view along the scroll axis, in pixels from the content's start.
    private func offset(of target: LayoutCoordinates) -> Float? {
        guard let content, content.isAttached, target.isAttached else {
            return nil
        }
        let position = content.localPositionOf(target, Offset.Zero)
        return isVertical ? position.y : position.x
    }

    private func length(_ size: IntSize) -> Int {
        return isVertical ? size.height : size.width
    }

    private func points(_ size: IntSize) -> CGSize {
        return CGSize(width: Double(size.width) / Double(density), height: Double(size.height) / Double(density))
    }
}

/// A lazy list or grid, whose items are identified by their `ForEach` IDs.
///
/// Compose measures only the visible items. A list remembers the size of each item it has measured, and assumes the
/// others share the visible items' average size, as a grid assumes for all its items.
final class LazyScrollDriver: ScrollDriver {
    let list: LazyListState?
    let grid: LazyGridState?
    let items: MutableState<LazyItemCollector>
    let density: Float
    /// The space the container reserves at its edges for the bars it scrolls beneath, in points.
    let contentInsets = mutableStateOf(EdgeInsets())
    /// Whether that space is part of the content, as a list's header and footer items are, rather than padding.
    let isInsetInContent: Bool
    /// Sparse Fenwick trees of measured list sizes and measured item counts, keyed by one-based index.
    /// They let geometry use the visible stride for unmeasured items and exact corrections for measured ones.
    private var measuredSizeTree: kotlin.collections.MutableMap<Int, Double> = mutableMapOf()
    private var measuredCountTree: kotlin.collections.MutableMap<Int, Int> = mutableMapOf()
    private var measuredSizes: kotlin.collections.MutableMap<Int, Int> = mutableMapOf()
    private var itemSizesCount = 0
    private var measuredItemsRevision = -1

    init(list: LazyListState? = nil, grid: LazyGridState? = nil, items: MutableState<LazyItemCollector>, density: Float, isInsetInContent: Bool = false) {
        self.list = list
        self.grid = grid
        self.items = items
        self.density = density
        self.isInsetInContent = isInsetInContent
    }

    var interactionSource: InteractionSource {
        return list?.interactionSource ?? grid!.interactionSource
    }

    var isScrollInProgress: Bool {
        return list?.isScrollInProgress ?? grid!.isScrollInProgress
    }

    var geometry: ScrollGeometry {
        let visible = visibleItems
        let stride = stride(of: visible)
        let spacing = list?.layoutInfo.mainAxisItemSpacing ?? grid!.layoutInfo.mainAxisItemSpacing
        let total = list?.layoutInfo.totalItemsCount ?? grid!.layoutInfo.totalItemsCount
        let firstIndex = list?.firstVisibleItemIndex ?? grid!.firstVisibleItemIndex
        let firstOffset = list?.firstVisibleItemScrollOffset ?? grid!.firstVisibleItemScrollOffset
        let viewport = list?.layoutInfo.viewportSize ?? grid!.layoutInfo.viewportSize
        let scale = Double(density)
        let extent: (offset: Double, length: Double)
        if list != nil {
            extent = measuredExtent(visible: visible, total: total, firstIndex: firstIndex, firstOffset: firstOffset, stride: stride)
        } else {
            extent = (offset: Double(firstIndex) * stride + Double(firstOffset), length: Double(total) * stride)
        }
        // As on iOS, the offset is -insets.top at the top, and the content size leaves out the insets
        let insets = contentInsets.value
        let offset = extent.offset / scale - insets.top
        var length = max(0.0, extent.length - Double(spacing)) / scale
        if isInsetInContent {
            length = max(0.0, length - insets.top - insets.bottom)
        }
        let container = CGSize(width: Double(viewport.width) / scale, height: Double(viewport.height) / scale)
        return ScrollGeometry(contentOffset: isVertical ? CGPoint(x: 0.0, y: offset) : CGPoint(x: offset, y: 0.0), contentSize: isVertical ? CGSize(width: container.width, height: length) : CGSize(width: length, height: container.height), contentInsets: insets, containerSize: container)
    }

    /// The estimated offset and length in pixels, corrected by measured item sizes.
    private func measuredExtent(visible: kotlin.collections.List<(index: Int, start: Int, end: Int)>, total: Int, firstIndex: Int, firstOffset: Int, stride: Double) -> (offset: Double, length: Double) {
        // Indexes change meaning when the collected items are rebuilt, even when their count stays the same.
        let itemsRevision = items.value.revision
        if total != itemSizesCount || itemsRevision != measuredItemsRevision {
            measuredSizeTree.clear()
            measuredCountTree.clear()
            measuredSizes.clear()
            itemSizesCount = total
            measuredItemsRevision = itemsRevision
        }
        let spacing = list!.layoutInfo.mainAxisItemSpacing
        for item in visible {
            let size = item.end - item.start + spacing
            let previousSize = measuredSizes[item.index]
            if previousSize == nil || previousSize! != size {
                updateMeasuredSize(index: item.index, delta: Double(size - (previousSize ?? 0)), count: total)
                if previousSize == nil {
                    updateMeasuredCount(index: item.index, count: total)
                }
                measuredSizes[item.index] = size
            }
        }
        let measuredBefore = measuredSizePrefix(endIndex: firstIndex)
        let measuredCountBefore = measuredCountPrefix(endIndex: firstIndex)
        let measuredTotal = measuredSizePrefix(endIndex: total)
        let measuredCountTotal = measuredCountPrefix(endIndex: total)
        let offset = Double(firstOffset) + Double(firstIndex) * stride + measuredBefore - Double(measuredCountBefore) * stride
        let length = Double(total) * stride + measuredTotal - Double(measuredCountTotal) * stride
        return (offset: offset, length: length)
    }

    /// Adds a value to a sparse Fenwick tree in O(log n).
    private func updateMeasuredSize(index: Int, delta: Double, count: Int) {
        var position = index + 1
        while position <= count {
            measuredSizeTree[position] = (measuredSizeTree[position] ?? 0.0) + delta
            position += position & -position
        }
    }

    private func updateMeasuredCount(index: Int, count: Int) {
        var position = index + 1
        while position <= count {
            measuredCountTree[position] = (measuredCountTree[position] ?? 0) + 1
            position += position & -position
        }
    }

    /// Returns the sum of entries before `endIndex` in a sparse Fenwick tree in O(log n).
    private func measuredSizePrefix(endIndex: Int) -> Double {
        var position = endIndex
        var sum = 0.0
        while position > 0 {
            sum += measuredSizeTree[position] ?? 0.0
            position -= position & -position
        }
        return sum
    }

    private func measuredCountPrefix(endIndex: Int) -> Int {
        var position = endIndex
        var sum = 0
        while position > 0 {
            sum += measuredCountTree[position] ?? 0
            position -= position & -position
        }
        return sum
    }

    func id(at anchor: UnitPoint) -> AnyHashable? {
        let start = list?.layoutInfo.viewportStartOffset ?? grid!.layoutInfo.viewportStartOffset
        let point = start + Int(Double(viewportLength) * (isVertical ? anchor.y : anchor.x))
        let visible = visibleItems
        guard let item = visible.firstOrNull({ ($0.start + $0.end) / 2 >= point }) ?? visible.lastOrNull() else {
            return nil
        }
        return items.value.id(for: item.index)
    }

    // SKIP DECLARE: override suspend fun scrollTo(position: ScrollPosition, animated: Boolean): Boolean
    func scrollTo(_ position: ScrollPosition, animated: Bool) -> Bool {
        let viewport = viewportLength
        if let id = position.viewID {
            guard let index = items.value.index(for: id) else {
                return false
            }
            let anchor: Double? = position.anchor == nil ? nil : isVertical ? position.anchor!.y : position.anchor!.x
            if !visibleItems.any({ $0.index == index }) {
                // Jump to the item with an estimated size, toward the end it would show at with the least scrolling
                let firstIndex = list?.firstVisibleItemIndex ?? grid!.firstVisibleItemIndex
                let fraction = anchor ?? (index > firstIndex ? 1.0 : 0.0)
                scrollToItem(index, offset: -Int(Double(viewport - Int(stride(of: visibleItems))) * fraction), animated: animated)
            }
            // Align with the item's measured size, within the space the list's header and footer leave beneath any bars,
            // as iOS aligns within the safe area
            if let item = visibleItems.firstOrNull({ $0.index == index }) {
                let insets = contentInsets.value
                let insetStart = isInsetInContent ? Float(insets.top) * density : Float(0.0)
                let insetEnd = isInsetInContent ? Float(insets.bottom) * density : Float(0.0)
                var padding = Float(0.0)
                if let list {
                    padding = Float(list.layoutInfo.beforeContentPadding + list.layoutInfo.afterContentPadding)
                }
                let delta = alignedOffset(start: Float(item.start) - insetStart, length: Float(item.end - item.start), viewport: Float(viewport) - padding - insetStart - insetEnd, current: Float(0.0), anchor: anchor)
                let state: ScrollableState = list ?? grid!
                if animated {
                    state.animateScrollBy(delta)
                } else {
                    state.scrollBy(delta)
                }
            }
            return true
        }
        let total = list?.layoutInfo.totalItemsCount ?? grid!.layoutInfo.totalItemsCount
        let visible = visibleItems
        let stride = stride(of: visible)
        guard let offset = position.offset(isVertical: isVertical), total > 0, stride > 0.0 else {
            return true
        }
        // Scroll to the first item of the grid line holding the offset
        let lineCount = max(1, visible.count { $0.start == visible.first().start })
        let pixels = Double(offset) * Double(density)
        let index = min(Int(pixels / (stride * Double(lineCount))) * lineCount, total - 1)
        scrollToItem(index, offset: index == total - 1 ? 0 : Int(pixels - Double(index) * stride), animated: animated)
        return true
    }

    private var isVertical: Bool {
        return (list?.layoutInfo.orientation ?? grid!.layoutInfo.orientation) == Orientation.Vertical
    }

    private var viewportLength: Int {
        let size = list?.layoutInfo.viewportSize ?? grid!.layoutInfo.viewportSize
        return isVertical ? size.height : size.width
    }

    /// Each visible item's index, and its start and end along the scroll axis in pixels from the viewport's start.
    private var visibleItems: kotlin.collections.List<(index: Int, start: Int, end: Int)> {
        if let list {
            return list.layoutInfo.visibleItemsInfo.map { (index: $0.index, start: $0.offset, end: $0.offset + $0.size) }
        }
        let vertical = isVertical
        return grid!.layoutInfo.visibleItemsInfo.map {
            let start = vertical ? $0.offset.y : $0.offset.x
            return (index: $0.index, start: start, end: start + (vertical ? $0.size.height : $0.size.width))
        }
    }

    /// The average distance between the starts of consecutive items, in pixels.
    private func stride(of visible: kotlin.collections.List<(index: Int, start: Int, end: Int)>) -> Double {
        guard !visible.isEmpty() else {
            return 0.0
        }
        let spacing = list?.layoutInfo.mainAxisItemSpacing ?? grid!.layoutInfo.mainAxisItemSpacing
        return Double(visible.last().end - visible.first().start + spacing) / Double(visible.size)
    }

    // SKIP DECLARE: private suspend fun scrollToItem(index: Int, offset: Int, animated: Boolean)
    private func scrollToItem(_ index: Int, offset: Int, animated: Bool) {
        if let list {
            if animated {
                list.animateScrollToItem(index, offset)
            } else {
                list.scrollToItem(index, offset)
            }
        } else if let grid {
            if animated {
                grid.animateScrollToItem(index, offset)
            } else {
                grid.scrollToItem(index, offset)
            }
        }
    }
}
#endif
#endif
