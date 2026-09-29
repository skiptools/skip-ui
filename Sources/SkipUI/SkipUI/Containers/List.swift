// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.expandHorizontally
import androidx.compose.animation.expandVertically
import androidx.compose.animation.shrinkHorizontally
import androidx.compose.animation.shrinkVertically
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.animate
import androidx.compose.foundation.LocalOverscrollFactory
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.AnchoredDraggableState
import androidx.compose.foundation.gestures.DraggableAnchors
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.anchoredDraggable
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.gestures.detectVerticalDragGestures
import androidx.compose.foundation.gestures.animateTo
import androidx.compose.foundation.gestures.snapTo
import androidx.compose.animation.core.tween
import androidx.compose.animation.core.exponentialDecay
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.requiredHeightIn
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.requiredWidth
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.layout.wrapContentWidth
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.GenericShape
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.pullrefresh.PullRefreshIndicator
import androidx.compose.material.pullrefresh.PullRefreshState
import androidx.compose.material.pullrefresh.pullRefresh
import androidx.compose.material.pullrefresh.rememberPullRefreshState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.outlined.KeyboardArrowLeft
import androidx.compose.material.icons.outlined.KeyboardArrowRight
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.SwipeToDismissBox
import androidx.compose.material3.SwipeToDismissBoxValue
import androidx.compose.material3.SwipeToDismissBoxDefaults
import androidx.compose.material3.rememberSwipeToDismissBoxState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.snapshotFlow
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.Stable
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.clipToBounds
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.onSizeChanged
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.RoundRect
import androidx.compose.ui.graphics.Path.Companion.combine
import androidx.compose.ui.graphics.PathOperation
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.zIndex
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.burnoutcrew.reorderable.ReorderableItem
import org.burnoutcrew.reorderable.ReorderableLazyListState
import org.burnoutcrew.reorderable.detectReorderAfterLongPress
import org.burnoutcrew.reorderable.rememberReorderableLazyListState
import org.burnoutcrew.reorderable.reorderable
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

/// Corner radius for list sections.
let listSectionCornerRadius = 8.0

#if SKIP
/// Discrete rest positions for a row's swipe gesture. Used as the value
/// type for the row's AnchoredDraggableState.
enum SwipeAnchor {
    case closed
    case leadingOpen
    case leadingFull
    case trailingOpen
    case trailingFull
}
#endif

// SKIP @bridge
// SKIP INSERT: @Stable // Otherwise Compose recomposes all internal @Composable funcs because 'this' is unstable
public final class List : View, Renderable {
    let fixedContent: ComposeBuilder?
    let forEach: ForEach?
    let itemTransformer: ((any Renderable) -> any Renderable)?
    /// A single-value or `Set` selection binding; rows are identified by their tags.
    let selection: Binding<Any>?

    init(fixedContent: (any View)? = nil, identifier: ((Any) -> AnyHashable?)? = nil, itemTransformer: ((any Renderable) -> any Renderable)? = nil, indexRange: Range<Int>? = nil, indexedContent: ((Int) -> any View)? = nil, objects: (any RandomAccessCollection<Any>)? = nil, objectContent: ((Any) -> any View)? = nil, objectsBinding: Binding<any RandomAccessCollection<Any>>? = nil, objectsBindingContent: ((Binding<any RandomAccessCollection<Any>>, Int) -> any View)? = nil, editActions: EditActions = [], selection: Binding<Any>? = nil) {
        if let fixedContent {
            self.fixedContent = fixedContent as? ComposeBuilder ?? ComposeBuilder(view: fixedContent)
        } else {
            self.fixedContent = nil
        }
        if let indexRange {
            self.forEach = ForEach(identifier: identifier, indexRange: { indexRange }, indexedContent: indexedContent)
        } else if let objects {
            self.forEach = ForEach(identifier: identifier, objects: objects, objectContent: objectContent)
        } else if let objectsBinding {
            self.forEach = ForEach(identifier: identifier, objectsBinding: objectsBinding, objectsBindingContent: objectsBindingContent, editActions: editActions)
        } else {
            self.forEach = nil
        }
        self.itemTransformer = itemTransformer
        self.selection = selection
    }

    public convenience init(@ViewBuilder content: () -> any View) {
        self.init(fixedContent: content())
    }

    // SKIP @bridge
    public convenience init(bridgedContent: any View) {
        self.init(bridgedContent: bridgedContent, getSelection: nil, setSelection: nil)
    }

    /// Bridged selection: a single row tag, or a `Set` of row tags.
    // SKIP @bridge
    public init(bridgedContent: any View, getSelection: (() -> Any?)?, setSelection: ((Any?) -> Void)?) {
        if let forEach = bridgedContent as? ForEach {
            self.fixedContent = nil
            self.forEach = forEach
        } else {
            self.fixedContent = ComposeBuilder.from { bridgedContent }
            self.forEach = nil
        }
        self.itemTransformer = nil
        if let getSelection, let setSelection {
            self.selection = Binding<Any?>(get: getSelection, set: setSelection) as! Binding<Any>
        } else {
            self.selection = nil
        }
    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalMaterialApi::class)
    @Composable public override func Render(context: ComposeContext) {
        let style = EnvironmentValues.shared._listStyle ?? DefaultListStyle()
        let backgroundVisibility = EnvironmentValues.shared._scrollContentBackground ?? Visibility.visible
        let styling = ListStyling(kind: ListStyleKind.of(style), backgroundVisibility: backgroundVisibility, sectionSpacing: EnvironmentValues.shared._listSectionSpacing)
        let itemContext = context.content()

        // When we layout, extend into safe areas that are due to system bars, not into any app chrome
        let safeArea = EnvironmentValues.shared._safeArea
        var ignoresSafeAreaEdges: Edge.Set = [.top, .bottom]
        ignoresSafeAreaEdges.formIntersection(safeArea?.absoluteSystemBarEdges ?? [])
        ComposeContainer(scrollAxes: .vertical, modifier: context.modifier, fillWidth: true, fillHeight: true, then: Modifier.background(BackgroundColor(styling: styling, isItem: false))) { modifier in
            IgnoresSafeAreaLayout(expandInto: ignoresSafeAreaEdges, checkEdges: [.bottom], modifier: modifier, logTag: "List") { safeAreaExpansion, safeAreaEdges in
                var containerModifier: Modifier
                let refreshing = remember { mutableStateOf(false) }
                let refreshAction = EnvironmentValues.shared.refresh
                let refreshState: PullRefreshState?
                if let refreshAction {
                    let refreshScope = rememberCoroutineScope()
                    let updatedAction = rememberUpdatedState(refreshAction)
                    refreshState = rememberPullRefreshState(refreshing.value, {
                        refreshScope.launch {
                            refreshing.value = true
                            updatedAction.value()
                            refreshing.value = false
                        }
                    })
                    containerModifier = modifier.pullRefresh(refreshState!)
                } else {
                    refreshState = nil
                    containerModifier = modifier
                }
                containerModifier = containerModifier.scrollDismissesKeyboardMode(EnvironmentValues.shared.scrollDismissesKeyboardMode)
                
                Box(modifier: containerModifier) {
                    let density = LocalDensity.current
                    let headerSafeAreaHeight = with(density) { safeAreaExpansion.top.toDp() }
                    let footerSafeAreaHeight = with(density) { safeAreaExpansion.bottom.toDp() }
                    RenderList(context: itemContext, styling: styling, arguments: ListArguments(headerSafeAreaHeight: headerSafeAreaHeight, footerSafeAreaHeight: footerSafeAreaHeight, safeAreaEdges: safeAreaEdges))
                    if let refreshState {
                        PullRefreshIndicator(refreshing.value, refreshState, Modifier.align(androidx.compose.ui.Alignment.TopCenter))
                    }
                }
            }
        }
    }

    @Composable private func RenderList(context: ComposeContext, styling: ListStyling, arguments: ListArguments) {
        let contentRenderables: kotlin.collections.List<Renderable>
        if let forEach {
            contentRenderables = forEach.EvaluateLazyItems(level: 0, context: context)
        } else if let fixedContent {
            contentRenderables = fixedContent.EvaluateLazyItems(level: 0, context: context)
        } else {
            contentRenderables = listOf()
        }
        let searchableState = EnvironmentValues.shared._searchableState
        let renderables = EvaluateSearchSuggestions(state: searchableState, context: context) ?? contentRenderables

        var modifier = context.modifier
        if styling.isInset {
            modifier = modifier.padding(start: Self.horizontalInset.dp, end: Self.horizontalInset.dp)
        }
        modifier = modifier.fillMaxSize()

        let isSearchable = searchableState?.isOnNavigationStack == false

        let hasHeader = !styling.isPlain || (!isSearchable && arguments.headerSafeAreaHeight.value > 0)
        let hasFooter = !styling.isPlain || arguments.footerSafeAreaHeight.value > 0
        // Indices of collapsed sections in a collapsible (sidebar) list
        let collapsedSections = remember { mutableStateOf(Set<Int>()) }

        // Remember the factory because we use it in the remembered reorderable state
        let itemCollector = remember { mutableStateOf(LazyItemCollector()) }
        let moveTrigger = remember { mutableStateOf(0) }
        let listState = rememberLazyListState(initialFirstVisibleItemIndex = isSearchable && arguments.headerSafeAreaHeight.value <= 0 ? 1 : 0)
        let reorderableState = rememberReorderableLazyListState(listState: listState, onMove: { from, to in
            // Trigger recompose on move, but don't read the trigger state until we're inside the list content to limit its scope
            itemCollector.value.move(from: from.index, to: to.index, trigger: { moveTrigger.value = $0 })
        }, onDragEnd: { _, _ in
            itemCollector.value.commitMove()
        }, canDragOver: { candidate, dragging in
            itemCollector.value.canMove(from: dragging.index, to: candidate.index)
        })
        modifier = modifier.reorderable(reorderableState)

        // Integrate with our scroll-to-top and ScrollViewReader
        let coroutineScope = rememberCoroutineScope()
        PreferenceValues.shared.contribute(context: context, key: ScrollToTopPreferenceKey.self, value: ScrollToTopAction(key: reorderableState.listState) {
            coroutineScope.launch {
                reorderableState.listState.animateScrollToItem(0)
            }
        })
        let scrollToID = ScrollToIDAction(key: reorderableState.listState) { id in
            if let itemIndex = itemCollector.value.index(for: id) {
                coroutineScope.launch {
                    if Animation.isInWithAnimation {
                        reorderableState.listState.animateScrollToItem(itemIndex)
                    } else {
                        reorderableState.listState.scrollToItem(itemIndex)
                    }
                }
            }
        }
        PreferenceValues.shared.contribute(context: context, key: ScrollToIDPreferenceKey.self, value: scrollToID)
        let isSystemBackground = styling.isGroupedBackground && styling.backgroundVisibility != Visibility.hidden
        // We contribute top bar preferences even without knowing we're safe area-adjacent for multiple reasons:
        // - When there is a search bar we may not be adjacent to the top safe area, but we should act like it
        // - An expanding nav bar can causes issues detecting safe area adjacency
        // - It is unlikely that anyone will use a grouped-style list that is not top-bar adjacent, so the top
        //   bar should always have the grouped-style system color
        PreferenceValues.shared.contribute(context: context, key: ToolbarPreferenceKey.self, value: ToolbarPreferences(isSystemBackground: isSystemBackground, scrollableState: listState, for: [ToolbarPlacement.navigationBar]))
        if arguments.safeAreaEdges.contains(Edge.Set.bottom) {
            PreferenceValues.shared.contribute(context: context, key: ToolbarPreferenceKey.self, value: ToolbarPreferences(isSystemBackground: isSystemBackground, scrollableState: listState, for: [ToolbarPlacement.bottomBar]))
            PreferenceValues.shared.contribute(context: context, key: TabBarPreferenceKey.self, value: ToolbarBarPreferences(isSystemBackground: isSystemBackground, scrollableState: listState))
        }

        // List item animations in Compose work by setting the `animateItemPlacement` modifier on the items. Critically,
        // this must be done when the items are composed *prior* to any animated change. So by default we compose all items
        // with `animateItemPlacement`. If the entire List is recomposed without an animation in progress (e.g. an unanimated
        // data change), we recompose without animation, then after some time to complete the recompose we flip back to the
        // animated state in anticipation of the next, potentially animated, update
        let forceUnanimatedItems = remember { mutableStateOf(false) }
        if Animation.current(isAnimating: false) == nil {
            forceUnanimatedItems.value = true
            LaunchedEffect(System.currentTimeMillis()) {
                delay(300)
                forceUnanimatedItems.value = false
            }
        } else {
            forceUnanimatedItems.value = false
        }

        let itemContext = context.content()
        /* Tracks which row currently has its swipe actions revealed. When one
           opens, all others observe this state and animate closed. Matches
           iOS list behavior of "only one row's swipe actions visible at once". */
        let activeSwipeKey = remember { mutableStateOf<String?>(nil) }
        // Combine contentPadding with contentMargins additively
        var contentPadding = EnvironmentValues.shared._contentPadding.asPaddingValues()
        if let contentMargins = EnvironmentValues.shared._contentMargins?.asComposePaddingValues(for: .automatic) {
            contentPadding = contentPadding.adding(contentMargins)
        }
        let listRowSpacing = EnvironmentValues.shared._listRowSpacing
        let listVerticalArrangement = listRowSpacing != nil ? Arrangement.spacedBy(listRowSpacing!.dp) : Arrangement.Top
        // Section index labels and their header item indices, gathered while producing lazy items
        let sectionIndexEntries = remember { mutableStateOf([SectionIndexEntry]()) }
        if (EnvironmentValues.shared._defaultScrollAnchor?.y ?? 0.0) >= 1.0 {
            let listState = reorderableState.listState
            LaunchedEffect(true) {
                var previousCount = 0
                // Start at the end, and stay there while the end is visible as rows are added or the viewport resizes
                snapshotFlow { [listState.layoutInfo.totalItemsCount, listState.layoutInfo.viewportSize.height] }.collect { layout in
                    let count = layout[0]
                    let lastVisible = listState.layoutInfo.visibleItemsInfo.lastOrNull()?.index ?? 0
                    if count > 0 && (previousCount == 0 || lastVisible >= previousCount - 2) {
                        listState.scrollToItem(count - 1)
                    }
                    previousCount = count
                }
            }
        }
        if let onScrollGeometryChange = EnvironmentValues.shared._onScrollGeometryChange {
            let listState = reorderableState.listState
            let density = LocalDensity.current
            let updatedAction = rememberUpdatedState(onScrollGeometryChange)
            LaunchedEffect(true) {
                snapshotFlow { Self.scrollGeometry(of: listState, density: density.density) }.collect { geometry in
                    updatedAction.value(geometry)
                }
            }
        }
        // scrollBounceBehavior(.basedOnSize) removes the overscroll stretch when rows fit
        let isOverscrollDisabled = EnvironmentValues.shared._scrollBounceBehavior == ScrollBounceBehavior.basedOnSize && !reorderableState.listState.canScrollForward && !reorderableState.listState.canScrollBackward
        Box(modifier: Modifier.fillMaxSize()) {
        // SKIP INSERT: val providedOverscrollFactory = LocalOverscrollFactory provides (if (isOverscrollDisabled) null else LocalOverscrollFactory.current)
        CompositionLocalProvider(providedOverscrollFactory) {
        let edgeEffectModifier = EnvironmentValues.shared._scrollEdgeEffect?.modifier(isScrolledPastTop: reorderableState.listState.canScrollBackward, isScrolledPastBottom: reorderableState.listState.canScrollForward) ?? Modifier
        LazyColumn(state: reorderableState.listState, modifier: modifier.then(edgeEffectModifier), contentPadding: contentPadding, verticalArrangement: listVerticalArrangement) {
            // Read move trigger here so that a move will recompose list content
            let _ = moveTrigger.value
            let shouldAnimateItems: @Composable () -> Bool = {
                // We disable animation to prevent filtered items from animating when they return
                // Collapsible sections animate their rows with AnimatedVisibility instead
                let animate = !forceUnanimatedItems.value && !styling.isCollapsible && EnvironmentValues.shared._searchableState?.isSearching.value != true
                return animate
            }

            // Initialize the factory context with closures that use the LazyListScope to generate items
            var startItemIndex = hasHeader ? 1 : 0 // Header inset
            if isSearchable {
                startItemIndex += 1 // Search field
            }
            var sectionIndex = -1 // Section of the items being produced; -1 before the first section
            var hasProducedItems = false // Whether rows precede the current section
            var sectionExpansion: Binding<Bool>? = nil // The current section's isExpanded binding
            var producerIndex = 0 // Scopes item keys per ForEach, since SwiftUI allows the same ID in different ForEach
            var sectionEnds: [Int: String] = [:] // "producer:position" of each section's last row, for section separators
            var indexEntries: [SectionIndexEntry] = []
            itemCollector.value.initialize(
                startItemIndex: startItemIndex,
                item: { renderable, level in
                    let section = sectionIndex
                    let expansion = sectionExpansion
                    hasProducedItems = true
                    let producer = producerIndex
                    producerIndex += 1
                    sectionEnds[section] = "\(producer):0"
                    item {
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItem() : Modifier
                        RenderSectionContent(section: section, expansion: expansion, collapsedSections: collapsedSections, styling: styling) {
                            RenderItem(content: Self.markingSectionEnd(renderable, isSectionEnd: sectionEnds[section] == "\(producer):0"), level: level, context: itemContext, modifier: itemModifier, styling: styling)
                        }
                    }
                },
                indexedItems: { range, identifier, offset, onDelete, onMove, level, factory in
                    let count = range.endExclusive - range.start
                    let section = sectionIndex
                    let expansion = sectionExpansion
                    hasProducedItems = true
                    let producer = producerIndex
                    let keyPrefix = "\(producer):"
                    producerIndex += 1
                    sectionEnds[section] = "\(producer):\(count - 1)"
                    let key: ((Int) -> String)? = identifier == nil ? nil : { keyPrefix + composeBundleString(for: identifier!(range.start + itemCollector.value.remapIndex($0, from: offset))) }
                    items(count: count, key: key) { index in
                        let isSectionEnd = sectionEnds[section] == "\(producer):\(index)"
                        let keyValue = key?(index) // Key closure already remaps index
                        let index = itemCollector.value.remapIndex(index, from: offset)
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItem() : Modifier
                        let renderable = factory(index + range.start, itemContext)
                        RenderSectionContent(section: section, expansion: expansion, collapsedSections: collapsedSections, styling: styling) {
                            RenderEditableItem(content: Self.markingSectionEnd(renderable, isSectionEnd: isSectionEnd), level: level, context: itemContext, modifier: itemModifier, styling: styling, key: keyValue, index: index, onDelete: onDelete, onMove: onMove, reorderableState: reorderableState, activeSwipeKey: activeSwipeKey)
                        }
                    }
                },
                objectItems: { objects, identifier, offset, onDelete, onMove, level, factory in
                    let section = sectionIndex
                    let expansion = sectionExpansion
                    hasProducedItems = true
                    let producer = producerIndex
                    let keyPrefix = "\(producer):"
                    producerIndex += 1
                    sectionEnds[section] = "\(producer):\(objects.count - 1)"
                    let key: (Int) -> String = { keyPrefix + composeBundleString(for: identifier(objects[itemCollector.value.remapIndex($0, from: offset)])) }
                    items(count: objects.count, key: key) { index in
                        let isSectionEnd = sectionEnds[section] == "\(producer):\(index)"
                        let keyValue = key(index) // Key closure already remaps index
                        let index = itemCollector.value.remapIndex(index, from: offset)
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItem() : Modifier
                        let renderable = factory(objects[index], itemContext)
                        RenderSectionContent(section: section, expansion: expansion, collapsedSections: collapsedSections, styling: styling) {
                            RenderEditableItem(content: Self.markingSectionEnd(renderable, isSectionEnd: isSectionEnd), level: level, context: itemContext, modifier: itemModifier, styling: styling, key: keyValue, index: index, onDelete: onDelete, onMove: onMove, reorderableState: reorderableState, activeSwipeKey: activeSwipeKey)
                        }
                    }
                },
                objectBindingItems: { objectsBinding, identifier, offset, editActions, onDelete, onMove, level, factory in
                    let section = sectionIndex
                    let expansion = sectionExpansion
                    hasProducedItems = true
                    let producer = producerIndex
                    let keyPrefix = "\(producer):"
                    producerIndex += 1
                    sectionEnds[section] = "\(producer):\(objectsBinding.wrappedValue.count - 1)"
                    let key: (Int) -> String = { keyPrefix + composeBundleString(for: identifier(objectsBinding.wrappedValue[itemCollector.value.remapIndex($0, from: offset)])) }
                    items(count: objectsBinding.wrappedValue.count, key: key) { index in
                        let isSectionEnd = sectionEnds[section] == "\(producer):\(index)"
                        let keyValue = key(index) // Key closure already remaps index
                        let index = itemCollector.value.remapIndex(index, from: offset)
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItem() : Modifier
                        let renderable = factory(objectsBinding, index, itemContext)
                        RenderSectionContent(section: section, expansion: expansion, collapsedSections: collapsedSections, styling: styling) {
                            RenderEditableItem(content: Self.markingSectionEnd(renderable, isSectionEnd: isSectionEnd), level: level, context: itemContext, modifier: itemModifier, styling: styling, objectsBinding: objectsBinding, key: keyValue, index: index, editActions: editActions, onDelete: onDelete, onMove: onMove, reorderableState: reorderableState, activeSwipeKey: activeSwipeKey)
                        }
                    }
                },
                sectionHeader: { content in
                    sectionIndex += 1
                    let section = sectionIndex
                    if let label = content.firstOrNull()?.forEachModifier({ ($0 as? SectionIndexLabelModifier)?.label }) {
                        indexEntries.append(SectionIndexEntry(label: label, itemIndex: startItemIndex + itemCollector.value.count))
                    }
                    sectionExpansion = itemCollector.value.sectionExpansion
                    let expansion = sectionExpansion
                    let headerRenderables = content.size == 0 ? listOf(EmptyView()) : content
                    let firstRenderable = (renderables.firstOrNull() as? LazySectionHeader)?.content.firstOrNull()
                    // The first section is top even when it has no header or comes from a ForEach
                    let isTop = firstRenderable === headerRenderables.firstOrNull() || (section == 0 && !hasProducedItems)
                    // Section(isExpanded:) always collapses; sidebar sections collapse when they have a visible header
                    let isCollapsible = expansion != nil || (styling.isCollapsible && content.size > 0)
                    for renderable in headerRenderables {
                        if styling.isPlain {
                            stickyHeader { _ in
                                RenderSectionHeader(content: renderable, context: itemContext, styling: styling, isTop: isTop)
                            }
                        } else if isCollapsible {
                            item {
                                RenderSectionHeader(content: renderable, context: itemContext, styling: styling, isTop: isTop, isExpanded: expansion?.wrappedValue ?? !collapsedSections.value.contains(section)) {
                                    if let expansion {
                                        expansion.wrappedValue = !expansion.wrappedValue
                                        return
                                    }
                                    var collapsed = collapsedSections.value
                                    if collapsed.contains(section) {
                                        collapsed.remove(section)
                                    } else {
                                        collapsed.insert(section)
                                    }
                                    collapsedSections.value = collapsed
                                }
                            }
                        } else {
                            item {
                                RenderSectionHeader(content: renderable, context: itemContext, styling: styling, isTop: isTop)
                            }
                        }
                    }
                },
                sectionFooter: { content in
                    let section = sectionIndex
                    let expansion = sectionExpansion
                    let footerRenderables = content.size == 0 ? listOf(EmptyView()) : content
                    for renderable in footerRenderables {
                        item {
                            RenderSectionFooter(content: renderable, context: itemContext, styling: styling, isExpanded: expansion?.wrappedValue ?? !collapsedSections.value.contains(section))
                        }
                    }
                }
            )

            if isSearchable {
                if searchableState!.isAlwaysVisible {
                    // navigationBarDrawer(displayMode: .always) keeps the field visible while rows scroll
                    stickyHeader { _ in
                        RenderSearchField(state: searchableState!, context: context, styling: styling, safeAreaHeight: arguments.headerSafeAreaHeight)
                    }
                } else {
                    item {
                        RenderSearchField(state: searchableState!, context: context, styling: styling, safeAreaHeight: arguments.headerSafeAreaHeight)
                    }
                }
            }
            if hasHeader {
                let hasTopSection = renderables.firstOrNull() is LazySectionHeader
                item {
                    RenderHeader(styling: styling, safeAreaHeight: isSearchable ? 0.dp : arguments.headerSafeAreaHeight, hasTopSection: hasTopSection)
                }
            }
            for renderable in renderables {
                if let factory = renderable as? LazyItemFactory, factory.shouldProduceLazyItems() {
                    factory.produceLazyItems(collector: itemCollector.value, modifiers: listOf(), level: 0)
                } else {
                    itemCollector.value.item(renderable, 0)
                }
            }
            if hasFooter {
                let hasBottomSection = renderables.lastOrNull() is LazySectionFooter
                item {
                    RenderFooter(styling: styling, safeAreaHeight: arguments.footerSafeAreaHeight, hasBottomSection: hasBottomSection)
                }
            }
            if indexEntries.map({ $0.itemIndex }) != sectionIndexEntries.value.map({ $0.itemIndex }) {
                sectionIndexEntries.value = indexEntries
            }
        }
        }
        let indicatorVisibility = EnvironmentValues.shared._scrollIndicatorVisibility
        if indicatorVisibility != ScrollIndicatorVisibility.hidden && indicatorVisibility != ScrollIndicatorVisibility.never {
            RenderScrollIndicator(listState: reorderableState.listState, flashTrigger: EnvironmentValues.shared._scrollIndicatorsFlashTrigger, isAlwaysVisible: indicatorVisibility == ScrollIndicatorVisibility.visible, modifier: Modifier.align(androidx.compose.ui.Alignment.CenterEnd))
        }
        if sectionIndexEntries.value.count > 0 && EnvironmentValues.shared._listSectionIndexVisibility != Visibility.hidden {
            RenderSectionIndex(entries: sectionIndexEntries.value, listState: reorderableState.listState, context: context, modifier: Modifier.align(androidx.compose.ui.Alignment.CenterEnd))
        }
        }
    }

    /// The scroll geometry of a lazy list, in points.
    ///
    /// Compose measures only visible rows, so offset and content size assume off-screen rows share the visible rows' average height.
    static func scrollGeometry(of listState: LazyListState, density: Float) -> ScrollGeometry {
        let layoutInfo = listState.layoutInfo
        var visibleHeight = 0
        for item in layoutInfo.visibleItemsInfo {
            visibleHeight += item.size
        }
        let visibleCount = layoutInfo.visibleItemsInfo.size
        let averageHeight = visibleCount > 0 ? Double(visibleHeight) / Double(visibleCount) : 0.0
        let scale = Double(density)
        let offsetY = (Double(listState.firstVisibleItemIndex) * averageHeight + Double(listState.firstVisibleItemScrollOffset)) / scale
        let contentHeight = Double(layoutInfo.totalItemsCount) * averageHeight / scale
        let containerSize = CGSize(width: Double(layoutInfo.viewportSize.width) / scale, height: Double(layoutInfo.viewportSize.height) / scale)
        return ScrollGeometry(contentOffset: CGPoint(x: 0.0, y: offsetY), contentSize: CGSize(width: containerSize.width, height: contentHeight), contentInsets: EdgeInsets(), containerSize: containerSize)
    }

    /// Render an iOS-style scroll indicator that shows while the list scrolls or flashes, then fades out.
    @Composable private func RenderScrollIndicator(listState: LazyListState, flashTrigger: Any?, isAlwaysVisible: Bool, modifier: Modifier) {
        let isFlashing = remember { mutableStateOf(false) }
        if let flashTrigger {
            LaunchedEffect(flashTrigger) {
                isFlashing.value = true
                delay(800)
                isFlashing.value = false
            }
        }
        let layoutInfo = listState.layoutInfo
        let totalCount = layoutInfo.totalItemsCount
        let visibleCount = layoutInfo.visibleItemsInfo.size
        guard totalCount > 0 && visibleCount < totalCount else {
            return
        }
        let isShown = isAlwaysVisible || listState.isScrollInProgress || isFlashing.value
        let alpha = animateFloatAsState(targetValue: isShown ? Float(1.0) : Float(0.0), animationSpec: tween(durationMillis: isShown ? 150 : 500, delayMillis: isShown ? 0 : 300), label: "scrollIndicator")
        let viewportHeight = with(LocalDensity.current) { layoutInfo.viewportSize.height.toDp() }
        let thumbHeight = max(36.dp, viewportHeight * (Float(visibleCount) / Float(totalCount)))
        let firstItemSize = layoutInfo.visibleItemsInfo.firstOrNull()?.size ?? 1
        let position = (Float(listState.firstVisibleItemIndex) + Float(listState.firstVisibleItemScrollOffset) / Float(max(1, firstItemSize))) / Float(max(1, totalCount - visibleCount))
        let offset = (viewportHeight - thumbHeight) * min(Float(1.0), max(Float(0.0), position))
        Box(modifier: modifier.fillMaxHeight().padding(end: 2.dp).width(3.dp)) {
            Box(modifier: Modifier
                .offset(y: offset)
                .height(thumbHeight)
                .width(3.dp)
                .alpha(alpha.value)
                .background(Color.secondary.opacity(0.6).colorImpl(), androidx.compose.foundation.shape.RoundedCornerShape(50)))
        }
    }

    /// Render the trailing section index, which jumps to a section when a label is tapped or dragged over, as on iOS.
    @Composable private func RenderSectionIndex(entries: [SectionIndexEntry], listState: LazyListState, context: ComposeContext, modifier: Modifier) {
        let coroutineScope = rememberCoroutineScope()
        let heightPx = remember { mutableStateOf(0) }
        let tint = EnvironmentValues.shared._tint ?? Color.accentColor
        let scrollToEntry: (Float) -> Void = { y in
            guard heightPx.value > 0 else {
                return
            }
            let index = min(entries.count - 1, max(0, Int(y / Float(heightPx.value) * Float(entries.count))))
            coroutineScope.launch {
                listState.scrollToItem(entries[index].itemIndex)
            }
        }
        let contentContext = context.content()
        Column(modifier: modifier
            .padding(end: 4.dp)
            .onSizeChanged { heightPx.value = $0.height }
            .pointerInput(entries.count) { detectTapGestures(onTap: { scrollToEntry($0.y) }) }
            .pointerInput(entries.count) { detectVerticalDragGestures(onDragStart: { scrollToEntry($0.y) }, onVerticalDrag: { change, _ in scrollToEntry(change.position.y) }) },
            horizontalAlignment: androidx.compose.ui.Alignment.CenterHorizontally) {
            for entry in entries {
                entry.label
                    .font(Font.caption2.bold())
                    .foregroundStyle(tint)
                    .padding(.horizontal, 4.0)
                    .padding(.vertical, 1.0)
                    .Compose(context: contentContext)
            }
        }
    }
    
    private static let horizontalInset = 16.0
    private static let verticalInset = 16.0
    private static let minimumItemHeight = 32.0
    private static let horizontalItemInset = 16.0
    private static let verticalItemInset = 8.0
    private static let levelInset = 24.0
    
    /// Seconds of velocity-based projection used when picking the snap anchor.
    private static let swipeVelocityProjectionSeconds: Float = Float(0.15)
    /// Fraction of the row width past which a full swipe fires the destructive action.
    private static let swipeFullSwipeFraction: Float = Float(0.65)
    /// Cap on the gray scrim alpha applied to the foreground during a swipe.
    private static let swipeScrimMaxAlpha: Float = Float(0.18)
    /// Minimum width for a single reveal button; grows to fit longer labels.
    private static let swipeButtonMinWidth: Dp = 80.dp

    /// - Parameters:
    ///   - insets: Row insets from `listRowInsets`, replacing the default padding.
    ///   - minRowHeight: The minimum row height, including vertical insets.
    static func contentModifier(level: Int, insets: EdgeInsets? = nil, minRowHeight: CGFloat = minimumItemHeight + verticalItemInset * 2) -> Modifier {
        let insets = insets ?? EdgeInsets(top: verticalItemInset, leading: horizontalItemInset, bottom: verticalItemInset, trailing: horizontalItemInset)
        let minContentHeight = max(0.0, minRowHeight - insets.top - insets.bottom)
        return Modifier.padding(start: (insets.leading + level * levelInset).dp, end: insets.trailing.dp, top: insets.top.dp, bottom: insets.bottom.dp).fillMaxWidth().requiredHeightIn(min: minContentHeight.dp)
    }

    /// - Parameters:
    ///   - leading: The separator's leading inset, defaulting to the row's content inset.
    ///   - tint: The separator color from `listRowSeparatorTint`.
    ///   - trailing: The separator's trailing inset from the row's trailing edge.
    @Composable static func RenderSeparator(level: Int, leading: CGFloat? = nil, trailing: CGFloat = 0.0, tint: Color? = nil) {
        androidx.compose.material3.Divider(modifier: Modifier.padding(start: ((leading ?? horizontalItemInset) + level * levelInset).dp, end: max(0.0, trailing).dp).fillMaxWidth(), color: (tint ?? Color.separator).colorImpl())
    }

    @Composable static func RenderItemContent(item: Renderable, context: ComposeContext, modifier: Modifier) {
        let badgeModifier = BadgeModifier.combined(for: item)
        let badge = badgeModifier.badge
        let (isListItem, listItemAction) = item.shouldRenderListItem(context: context)
        if isListItem {
            let actionModifier: Modifier
            if let listItemAction {
                let isDisabled = !EnvironmentValues.shared.isEnabled || item.forEachModifier { ($0 as? DisabledModifier)?.disabled } == true
                actionModifier = Modifier.clickable(onClick: listItemAction, enabled: !isDisabled)
            } else {
                actionModifier = Modifier
            }
            if let badge {
                Row(modifier: actionModifier.then(modifier), horizontalArrangement: Arrangement.SpaceBetween, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                    Box(modifier: Modifier.weight(Float(1.0)), contentAlignment: androidx.compose.ui.Alignment.CenterStart) {
                        item.RenderListItem(context: context, modifiers: listOf())
                    }
                    RenderBadge(badge: badge, prominence: badgeModifier.prominence ?? .standard, context: context)
                }
            } else {
                Box(modifier: actionModifier.then(modifier), contentAlignment: androidx.compose.ui.Alignment.CenterStart) {
                    item.RenderListItem(context: context, modifiers: listOf())
                }
            }
        } else {
            if let badge {
                Row(modifier: modifier, horizontalArrangement: Arrangement.SpaceBetween, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                    Box(modifier: Modifier.weight(Float(1.0)), contentAlignment: androidx.compose.ui.Alignment.CenterStart) {
                        item.Render(context: context)
                    }
                    RenderBadge(badge: badge, prominence: badgeModifier.prominence ?? .standard, context: context)
                }
            } else {
                Box(modifier: modifier, contentAlignment: androidx.compose.ui.Alignment.CenterStart) {
                    item.Render(context: context)
                }
            }
        }
    }

    @Composable private static func RenderBadge(badge: Text, prominence: BadgeProminence, context: ComposeContext) {
        let badgeColor: androidx.compose.ui.graphics.Color
        switch prominence {
        case .increased:
            badgeColor = Color.red.colorImpl()
        case .decreased:
            badgeColor = Color.secondary.colorImpl()
        default:
            badgeColor = Color.secondary.colorImpl()
        }
        EnvironmentValues.shared.setValues {
            $0.set_foregroundStyle(Color(colorImpl: { badgeColor }))
            return ComposeResult.ok
        } in: {
            badge.Compose(context: context)
        }
    }

    /// Mark a section's last row, whose separator is the section's bottom separator.
    static func markingSectionEnd(_ renderable: Renderable, isSectionEnd: Bool) -> Renderable {
        return isSectionEnd ? ModifiedContent.apply(modifiers: listOf(ListItemModifier(isSectionEnd: true)), to: renderable) : renderable
    }

    @Composable private func RenderItem(content: Renderable, level: Int, context: ComposeContext, modifier: Modifier = Modifier, styling: ListStyling, isItem: Bool = true) {
        guard !content.isSwiftUIEmptyView else {
            return
        }

        var itemRenderable = itemTransformer?(content) ?? content
        let listItemModifier = ListItemModifier.combined(for: itemRenderable)
        var itemModifier: Modifier = Modifier
        if listItemModifier?.background == nil {
            itemModifier = itemModifier.background(BackgroundColor(styling: styling.withKind(.plain), isItem: isItem))
        }

        // Selection: rows are identified by their tags, like SwiftUI
        let selectionTag: Any? = isItem ? TagModifier.on(content: itemRenderable, role: .tag)?.value : nil
        let selectionSet = selection?.wrappedValue as? Set<AnyHashable>
        let isEditing = EnvironmentValues.shared.editMode?.wrappedValue.isEditing == true
        // Multiple selection requires edit mode, as on iOS
        let showsSelectionIndicator = selection != nil && selectionSet != nil && isEditing && selectionTag != nil
        let isSelectable = selection != nil && selectionTag != nil && listItemModifier?.selectionDisabled != true && (selectionSet == nil || isEditing)
        let isSelected = selectionTag != nil && (selectionSet != nil ? selectionSet!.contains(selectionTag as! AnyHashable) : selection?.wrappedValue == selectionTag)
        if isSelected && (selectionSet == nil || isEditing) {
            itemModifier = itemModifier.background(Color.primary.opacity(0.12).colorImpl())
        }
        let selectionContextMenu = selectionTag != nil ? EnvironmentValues.shared._selectionContextMenu : nil
        if isSelectable || selectionContextMenu?.primaryAction != nil {
            let selectionBinding = selection
            itemModifier = itemModifier.clickable {
                if isSelectable, let selectionBinding {
                    Self.toggleSelection(selectionBinding, tag: selectionTag!)
                }
                if !isEditing, let primaryAction = selectionContextMenu?.primaryAction {
                    primaryAction(Set<AnyHashable>([selectionTag as! AnyHashable]))
                }
            }
        }
        if let selectionContextMenu {
            // Act on the whole selection when the pressed row is part of it, else on the pressed row
            let ids: Set<AnyHashable> = isSelected && selectionSet != nil ? selectionSet! : Set<AnyHashable>([selectionTag as! AnyHashable])
            itemRenderable = ModifiedContent.apply(modifiers: listOf(ContextMenuModifier(menuItems: ComposeBuilder.from { selectionContextMenu.menu(ids) })), to: itemRenderable)
        }

        // ForEach.dropDestination rows accept drops across the whole row
        if let rowDrop = itemRenderable.forEachModifier({ $0 as? ListRowDropModifier }) {
            itemModifier = itemModifier.then(dropTargetModifier(accepts: rowDrop.accepts, isTargeted: nil, showsInsertionIndicator: true, onDrop: rowDrop.onDrop))
        }

        // The given modifiers include elevation shadow for dragging, etc that need to go before the others
        let containerContext = context.content(modifier: modifier.then(itemModifier).then(context.modifier))
        let contentContext = context.content()
        let contentModifier = Self.contentModifier(level: level, insets: listItemModifier?.insets, minRowHeight: EnvironmentValues.shared.defaultMinListRowHeight)
        // Measured row content size, for separator alignment guides
        let contentSize = remember { mutableStateOf(CGSize.zero) }
        let density = LocalDensity.current
        let rowInsets = listItemModifier?.insets ?? EdgeInsets(top: Self.verticalItemInset, leading: Self.horizontalItemInset, bottom: Self.verticalItemInset, trailing: Self.horizontalItemInset)
        let renderContainer: @Composable (ComposeContext) -> Void = { context in
            Column(modifier: context.modifier.onSizeChanged {
                let size = CGSize(width: Double($0.width) / Double(density.density) - rowInsets.leading - rowInsets.trailing - Double(level) * Self.levelInset, height: Double($0.height) / Double(density.density))
                if contentSize.value != size {
                    contentSize.value = size
                }
            }) {
                let placement = EnvironmentValues.shared._placement
                EnvironmentValues.shared.setValues {
                    $0.set_placement(placement.union(ViewPlacement.listItem))
                    return ComposeResult.ok
                } in: {
                    Row(verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                        AnimatedVisibility(visible: showsSelectionIndicator, enter: expandHorizontally(), exit: shrinkHorizontally()) {
                            Self.RenderSelectionIndicator(isSelected: isSelected)
                        }
                        Box(modifier: Modifier.weight(Float(1.0))) {
                            Self.RenderItemContent(item: itemRenderable, context: contentContext, modifier: contentModifier)
                        }
                    }
                }
                // A section's last row draws the section separator, which the section's modifiers may style
                let isSectionEnd = listItemModifier?.isSectionEnd == true
                let separator = isSectionEnd ? listItemModifier?.sectionSeparator ?? listItemModifier?.separator : listItemModifier?.separator
                let separatorTint = isSectionEnd ? listItemModifier?.sectionSeparatorTint ?? listItemModifier?.separatorTint : listItemModifier?.separatorTint
                if separator != Visibility.hidden {
                    let dimensions = ViewDimensions(width: contentSize.value.width, height: contentSize.value.height)
                    let leading = listItemModifier?.separatorLeading.map { rowInsets.leading + $0(dimensions) } ?? listItemModifier?.insets?.leading
                    let trailing = listItemModifier?.separatorTrailing.map { contentSize.value.width + rowInsets.trailing - $0(dimensions) } ?? 0.0
                    Self.RenderSeparator(level: level, leading: leading, trailing: trailing, tint: separatorTint)
                }
            }
        }

        if let background = listItemModifier?.background {
            TargetViewLayout(context: containerContext, isOverlay: false, alignment: Alignment.center, target: renderContainer, dependent: {
                background.Compose(context: $0)
            })
        } else {
            renderContainer(containerContext)
        }
    }

    /// Select a row in a single-value selection, or toggle it in a `Set` selection.
    static func toggleSelection(_ selection: Binding<Any>, tag: Any) {
        if var selectionSet = selection.wrappedValue as? Set<AnyHashable> {
            let id = tag as! AnyHashable
            if selectionSet.contains(id) {
                selectionSet.remove(id)
            } else {
                selectionSet.insert(id)
            }
            selection.wrappedValue = selectionSet
        } else {
            selection.wrappedValue = tag
        }
    }

    /// The leading checkmark circle of a row in an editing multi-selection list, as on iOS.
    @Composable static func RenderSelectionIndicator(isSelected: Bool) {
        let modifier = Modifier.padding(start: horizontalItemInset.dp).size(22.dp)
        if isSelected {
            Icon(imageVector: Icons.Filled.CheckCircle, contentDescription: nil, modifier: modifier, tint: (EnvironmentValues.shared._tint ?? Color.accentColor).colorImpl())
        } else {
            Box(modifier: modifier.border(1.5.dp, Color.secondary.colorImpl(), CircleShape))
        }
    }

    @Composable private func RenderEditableItem(content: Renderable, level: Int, context: ComposeContext, modifier: Modifier, styling: ListStyling, objectsBinding: Binding<RandomAccessCollection<Any>>? = nil, key: String?, index: Int, editActions: EditActions = [], onDelete: ((IndexSet) -> Void)?, onMove: ((IndexSet, Int) -> Void)?, reorderableState: ReorderableLazyListState, activeSwipeKey: MutableState<String?>) {
        guard !content.isSwiftUIEmptyView else {
            return
        }
        guard let key else {
            RenderItem(content: content, level: level, context: context, modifier: modifier, styling: styling)
            return
        }
        let editActionsModifier = EditActionsModifier.combined(for: content)
        let swipeConfigs = SwipeActionsModifier.combined(for: content)
        let leadingSwipe = swipeConfigs.leading
        let trailingSwipe = swipeConfigs.trailing
        let hasUserSwipe = leadingSwipe != nil || trailingSwipe != nil
        let isDeleteEnabled = (editActions.contains(.delete) || onDelete != nil) && editActionsModifier.isDeleteDisabled != true
        let isMoveEnabled = (editActions.contains(.move) || onMove != nil) && editActionsModifier.isMoveDisabled != true
        guard isDeleteEnabled || isMoveEnabled || hasUserSwipe else {
            RenderItem(content: content, level: level, context: context, modifier: modifier, styling: styling)
            return
        }

        /* Build the inner swipe + content composable. User-provided .swipeActions
           wins over the implicit onDelete trash. If neither swipe path applies
           we just render the row (caller still handles reorder wrapping). */
        let itemContent: @Composable (Modifier) -> Void
        if hasUserSwipe {
            /* Mirror iOS: a destructive button's full-swipe both fires the
               user's action AND removes the row from the underlying data, so
               the row visibly disappears via LazyColumn's animateItem. We pass
               an `onDestructiveDelete` closure to RenderSwipeableItem; it is
               only invoked when (a) the destructive full-swipe fires AND
               (b) the List has either an onDelete handler or a deletable
               objectsBinding to remove from. */
            let canAutoDelete = isDeleteEnabled
            let onDestructiveDelete: (() -> Void)? = canAutoDelete ? {
                if let onDelete {
                    withAnimation { onDelete(IndexSet(integer: index)) }
                } else if let objectsBinding, objectsBinding.wrappedValue.count > index {
                    withAnimation { (objectsBinding.wrappedValue as? RangeReplaceableCollection<Any>)?.remove(at: index) }
                }
            } : nil
            itemContent = { rowModifier in
                RenderSwipeableItem(content: content, level: level, context: context, modifier: rowModifier, styling: styling, leadingConfig: leadingSwipe, trailingConfig: trailingSwipe, rowKey: key, activeSwipeKey: activeSwipeKey, onDestructiveDelete: onDestructiveDelete)
            }
        } else if isDeleteEnabled {
            let rememberedOnDelete = rememberUpdatedState({
                if let onDelete {
                    withAnimation { onDelete(IndexSet(integer: index)) }
                } else if let objectsBinding, objectsBinding.wrappedValue.count > index {
                    withAnimation { (objectsBinding.wrappedValue as? RangeReplaceableCollection<Any>)?.remove(at: index) }
                }
            })
            let coroutineScope = rememberCoroutineScope()
            let positionalThreshold = with(LocalDensity.current) { 164.dp.toPx() }
            let dismissState = rememberSwipeToDismissBoxState(confirmValueChange: {
                if $0 == SwipeToDismissBoxValue.EndToStart {
                    coroutineScope.launch {
                        rememberedOnDelete.value()
                    }
                }
                return false
            }, positionalThreshold = SwipeToDismissBoxDefaults.positionalThreshold)

            itemContent = {
                SwipeToDismissBox(state: dismissState, enableDismissFromEndToStart: true, enableDismissFromStartToEnd: false, modifier: $0, backgroundContent: {
                    /* Red background unconditional (destructive cue); icon only
                       if the trash vector resolves — force-unwrapping inside a LazyColumn item would crash measurement. */
                    Box(modifier: Modifier.background(androidx.compose.ui.graphics.Color.Red).fillMaxSize(), contentAlignment: androidx.compose.ui.Alignment.CenterEnd) {
                        if let trashVector = Image.composeImageVector(named: "trash") {
                            Icon(imageVector: trashVector, contentDescription: "Delete", modifier = Modifier.padding(end: 24.dp), tint: androidx.compose.ui.graphics.Color.White)
                        }
                    }
                }, content: {
                    RenderItem(content: content, level: level, context: context, styling: styling)
                })
            }
        } else {
            itemContent = { rowModifier in
                RenderItem(content: content, level: level, context: context, modifier: rowModifier, styling: styling)
            }
        }

        if isMoveEnabled {
            RenderReorderableItem(reorderableState: reorderableState, key: key, modifier: modifier, content: itemContent)
        } else {
            itemContent(modifier)
        }
    }

    /// Render a row wrapped in a horizontal-drag swipe container that reveals
    /// user-provided action Buttons on the leading and/or trailing edge.
    /// The foreground row determines the cell's height; reveal buttons match it
    /// via `Modifier.matchParentSize()` so we never propagate unbounded height
    /// constraints up into the surrounding LazyColumn.
    @Composable private func RenderSwipeableItem(content: Renderable, level: Int, context: ComposeContext, modifier: Modifier, styling: ListStyling, leadingConfig: SwipeActionsConfig?, trailingConfig: SwipeActionsConfig?, rowKey: String, activeSwipeKey: MutableState<String?>, onDestructiveDelete: (() -> Void)? = nil) {
        let coroutineScope = rememberCoroutineScope()

        /* Extract Buttons and per-button .tint(_:) values from each edge's
           rendered content. .tint() is implemented as an env modifier with
           affectsEvaluate=false, so it wraps the Button via ModifiedContent
           but doesn't appear in the EnvironmentValues during Evaluate. We
           walk each renderable's modifier chain, run any EnvironmentModifier
           actions in a scoped env, and capture the resulting _tint. The
           innermost matching modifier wins (matches SwiftUI). */
        let trailingRenderables = trailingConfig?.content.Evaluate(context: context, options: 0) ?? listOf()
        let leadingRenderables = leadingConfig?.content.Evaluate(context: context, options: 0) ?? listOf()
        let trailingTintMap: kotlin.collections.MutableMap<Button, Color> = mutableMapOf()
        let leadingTintMap: kotlin.collections.MutableMap<Button, Color> = mutableMapOf()
        let trailingButtonsRawMutable: kotlin.collections.MutableList<Button> = mutableListOf()
        for renderable in trailingRenderables {
            if let button = renderable.strip() as? Button {
                trailingButtonsRawMutable.add(button)
                if let tint = ExtractEnvironmentTint(from: renderable) {
                    trailingTintMap[button] = tint
                }
            }
        }
        let leadingButtonsRawMutable: kotlin.collections.MutableList<Button> = mutableListOf()
        for renderable in leadingRenderables {
            if let button = renderable.strip() as? Button {
                leadingButtonsRawMutable.add(button)
                if let tint = ExtractEnvironmentTint(from: renderable) {
                    leadingTintMap[button] = tint
                }
            }
        }
        let trailingButtonsRaw: kotlin.collections.List<Button> = trailingButtonsRawMutable
        let leadingButtonsRaw: kotlin.collections.List<Button> = leadingButtonsRawMutable
        /* iOS displays trailing swipe actions in the opposite visual order from
           their declaration so the first declared action sits on the swipe edge.
           Leading actions keep declaration order. iOS also reorders .destructive
           Buttons to the swipe-from edge regardless of declaration order. For
           trailing swipes that means pinned to the right (last in the Row laid
           out with Arrangement.End); for leading, pinned to the left (first with
           Arrangement.Start). The destructive button also becomes the full-swipe
           target. */
        let trailingDestructive = trailingButtonsRaw.firstOrNull { $0.role == ButtonRole.destructive }
        let trailingNonDestructive = trailingButtonsRaw.filter { $0.role != ButtonRole.destructive }
        let trailingButtons: kotlin.collections.List<Button>
        if let trailingDestructive {
            trailingButtons = (trailingNonDestructive.reversed() + listOf(trailingDestructive))
        } else {
            trailingButtons = trailingButtonsRaw.reversed()
        }
        let leadingDestructive = leadingButtonsRaw.firstOrNull { $0.role == ButtonRole.destructive }
        let leadingNonDestructive = leadingButtonsRaw.filter { $0.role != ButtonRole.destructive }
        let leadingButtons: kotlin.collections.List<Button>
        if let leadingDestructive {
            leadingButtons = (listOf(leadingDestructive) + leadingNonDestructive)
        } else {
            leadingButtons = leadingButtonsRaw
        }
        /* The full-swipe gesture should fire the destructive action when one
           exists, otherwise the edge-most action. */
        let trailingFullSwipeTarget = trailingDestructive ?? trailingButtons.lastOrNull()
        let leadingFullSwipeTarget = leadingDestructive ?? leadingButtons.firstOrNull()
        let allowsTrailingFullSwipe = trailingConfig?.allowsFullSwipe == true && trailingButtons.size > 0
        let allowsLeadingFullSwipe = leadingConfig?.allowsFullSwipe == true && leadingButtons.size > 0

        /* Measured buttons-row width per edge drives the open-anchor distance.
           swipeButtonMinWidth is the floor. */
        let minButtonWidthDp = swipeButtonMinWidth
        let density = LocalDensity.current
        let minButtonWidthPx = with(density) { minButtonWidthDp.toPx() }

        /* AnchoredDraggableState owns the horizontal offset and runs both the
           live drag and the snap-back animation. Anchors are populated below
           via updateAnchors once the row width has been measured; until then
           the state has only the .closed anchor at 0f so it behaves as a
           no-op draggable. */
        let velocityThresholdPx = with(density) { 125.dp.toPx() }
        let anchoredState = remember {
            AnchoredDraggableState<SwipeAnchor>(
                initialValue: SwipeAnchor.closed,
                positionalThreshold: { distance in distance * Float(0.5) },
                velocityThreshold: { velocityThresholdPx },
                snapAnimationSpec: tween(durationMillis: 300),
                decayAnimationSpec: exponentialDecay<Float>()
            )
        }
        let rowWidthPxState = remember { mutableFloatStateOf(Float(0)) }
        /* Natural (content-sized) buttons-row width per edge, captured via
           onSizeChanged when the reveal is in natural-layout mode. Defaults
           to count × minButtonWidth until the first measurement lands. */
        let trailingNaturalState = remember { mutableFloatStateOf(Float(0)) }
        let leadingNaturalState = remember { mutableFloatStateOf(Float(0)) }

        /* When a *different* row's swipe opens, animate this row closed.
           Matches iOS list behavior of one open swipe at a time. */
        let currentlyOpen = activeSwipeKey.value
        LaunchedEffect(currentlyOpen) {
            if currentlyOpen != rowKey && anchoredState.currentValue != SwipeAnchor.closed {
                anchoredState.animateTo(SwipeAnchor.closed)
            }
        }

        /* Sync activeSwipeKey from this row's currentValue: when the user
           commits to an open anchor we register ourselves so siblings close;
           when we settle back to closed we clear the key. */
        LaunchedEffect(anchoredState.currentValue) {
            let cur = anchoredState.currentValue
            if cur == SwipeAnchor.closed {
                if activeSwipeKey.value == rowKey {
                    activeSwipeKey.value = nil
                }
            } else if cur != SwipeAnchor.trailingFull && cur != SwipeAnchor.leadingFull {
                activeSwipeKey.value = rowKey
            }
        }

        /* When the row actually settles on a full-swipe anchor, fire the
           primary action (and optional auto-delete for destructive), then
           snap back to closed. */
        LaunchedEffect(anchoredState.settledValue) {
            let settled = anchoredState.settledValue
            if settled == SwipeAnchor.trailingFull {
                if let action = trailingFullSwipeTarget?.action {
                    action()
                }
                if trailingFullSwipeTarget?.role == ButtonRole.destructive, let onDestructiveDelete {
                    onDestructiveDelete()
                }
                anchoredState.snapTo(SwipeAnchor.closed)
                if activeSwipeKey.value == rowKey {
                    activeSwipeKey.value = nil
                }
            } else if settled == SwipeAnchor.leadingFull {
                if let action = leadingFullSwipeTarget?.action {
                    action()
                }
                if leadingFullSwipeTarget?.role == ButtonRole.destructive, let onDestructiveDelete {
                    onDestructiveDelete()
                }
                anchoredState.snapTo(SwipeAnchor.closed)
                if activeSwipeKey.value == rowKey {
                    activeSwipeKey.value = nil
                }
            }
        }

        Box(modifier: modifier.onSizeChanged { rowWidthPxState.value = Float($0.width) }.clipToBounds()) {
            let rowWidthPx = rowWidthPxState.value
            /* Natural buttons-row width is the measured content width (each
               button sized to its label), captured below in natural-layout
               mode. Before the first measurement lands the fallback is
               count × minButtonWidth so the open anchor is never zero on
               frame zero. */
            let trailingNaturalFallback = Float(trailingButtons.size) * minButtonWidthPx
            let leadingNaturalFallback = Float(leadingButtons.size) * minButtonWidthPx
            let trailingNaturalPx = trailingNaturalState.value > Float(0) ? trailingNaturalState.value : trailingNaturalFallback
            let leadingNaturalPx = leadingNaturalState.value > Float(0) ? leadingNaturalState.value : leadingNaturalFallback
            let trailingOpenPx = -trailingNaturalPx
            let leadingOpenPx = leadingNaturalPx

            /* Current revealed width per edge (positive). When the user drags
               further than the natural buttons-row width, the reveal area
               stretches: the row's width follows the foreground so the
               buttons grow to track the row edge instead of leaving a gap. */
            let rawOffset = anchoredState.offset
            let curOffset: Float = rawOffset.isNaN() ? Float(0) : rawOffset
            let revealedTrailingPx = curOffset < Float(0) ? -curOffset : Float(0)
            let revealedLeadingPx = curOffset > Float(0) ? curOffset : Float(0)

            /* Past the full-swipe trigger, the destructive (or otherwise
               edge-most) action takes over and expands to fill the entire
               revealed width while the other actions shrink to zero. The
               transition is animated to smooth out the moment of takeover. */
            let trailingFullSwipeActive = allowsTrailingFullSwipe && revealedTrailingPx > rowWidthPx * swipeFullSwipeFraction
            let leadingFullSwipeActive = allowsLeadingFullSwipe && revealedLeadingPx > rowWidthPx * swipeFullSwipeFraction
            let trailingFullSwipeAnim = animateFloatAsState(targetValue: trailingFullSwipeActive ? Float(1) : Float(0)).value
            let leadingFullSwipeAnim = animateFloatAsState(targetValue: leadingFullSwipeActive ? Float(1) : Float(0)).value

            /* Reveal area sits beneath the row content. Buttons are sized to
               share the row's current revealed (stretched) width. The primary
               action (destructive if present, else the edge-most) absorbs all
               additional width during full-swipe takeover; other buttons
               proportionally shrink to zero. The direction guards ensure only
               one edge's reveal renders at any non-zero offset. */
            let leadingUseStretch = leadingButtons.size > 0 && revealedLeadingPx > leadingNaturalPx + Float(1)
            let trailingUseStretch = trailingButtons.size > 0 && revealedTrailingPx > trailingNaturalPx + Float(1)
            let leadingCount = Float(leadingButtons.size)
            let trailingCount = Float(trailingButtons.size)

            if leadingButtons.size > 0 && curOffset >= Float(0) {
                Box(modifier: Modifier.matchParentSize(), contentAlignment: androidx.compose.ui.Alignment.CenterStart) {
                    if leadingUseStretch {
                        let rowWidthDp = with(density) { revealedLeadingPx.toDp() }
                        Row(modifier: Modifier.fillMaxHeight().width(rowWidthDp)) {
                            for button in leadingButtons {
                                let isPrimary = button === leadingFullSwipeTarget
                                let primaryWeight = Float(1) + (leadingCount - Float(1)) * leadingFullSwipeAnim
                                let otherWeight = Float(1) - leadingFullSwipeAnim
                                let weight = isPrimary ? primaryWeight : otherWeight
                                if weight <= Float(0.01) {
                                    continue
                                }
                                Box(modifier: Modifier.weight(weight).fillMaxHeight()) {
                                    RenderSwipeRevealButton(button: button, sizeModifier: Modifier.fillMaxSize(), context: context, tintOverride: leadingTintMap[button], onTap: {
                                        button.action()
                                        if button.role == ButtonRole.destructive, let onDestructiveDelete {
                                            onDestructiveDelete()
                                        }
                                        coroutineScope.launch {
                                            anchoredState.animateTo(SwipeAnchor.closed)
                                        }
                                    })
                                }
                            }
                        }
                    } else {
                        Row(modifier: Modifier.fillMaxHeight().wrapContentWidth().onSizeChanged { leadingNaturalState.value = Float($0.width) }) {
                            for button in leadingButtons {
                                RenderSwipeRevealButton(button: button, sizeModifier: Modifier.fillMaxHeight().widthIn(min: minButtonWidthDp), context: context, tintOverride: leadingTintMap[button], onTap: {
                                    button.action()
                                    if button.role == ButtonRole.destructive, let onDestructiveDelete {
                                        onDestructiveDelete()
                                    }
                                    coroutineScope.launch {
                                        anchoredState.animateTo(SwipeAnchor.closed)
                                    }
                                })
                            }
                        }
                    }
                }
            }
            if trailingButtons.size > 0 && curOffset <= Float(0) {
                Box(modifier: Modifier.matchParentSize(), contentAlignment: androidx.compose.ui.Alignment.CenterEnd) {
                    if trailingUseStretch {
                        let rowWidthDp = with(density) { revealedTrailingPx.toDp() }
                        Row(modifier: Modifier.fillMaxHeight().width(rowWidthDp)) {
                            for button in trailingButtons {
                                let isPrimary = button === trailingFullSwipeTarget
                                let primaryWeight = Float(1) + (trailingCount - Float(1)) * trailingFullSwipeAnim
                                let otherWeight = Float(1) - trailingFullSwipeAnim
                                let weight = isPrimary ? primaryWeight : otherWeight
                                if weight <= Float(0.01) {
                                    continue
                                }
                                Box(modifier: Modifier.weight(weight).fillMaxHeight()) {
                                    RenderSwipeRevealButton(button: button, sizeModifier: Modifier.fillMaxSize(), context: context, tintOverride: trailingTintMap[button], onTap: {
                                        button.action()
                                        if button.role == ButtonRole.destructive, let onDestructiveDelete {
                                            onDestructiveDelete()
                                        }
                                        coroutineScope.launch {
                                            anchoredState.animateTo(SwipeAnchor.closed)
                                        }
                                    })
                                }
                            }
                        }
                    } else {
                        Row(modifier: Modifier.fillMaxHeight().wrapContentWidth().onSizeChanged { trailingNaturalState.value = Float($0.width) }) {
                            for button in trailingButtons {
                                RenderSwipeRevealButton(button: button, sizeModifier: Modifier.fillMaxHeight().widthIn(min: minButtonWidthDp), context: context, tintOverride: trailingTintMap[button], onTap: {
                                    button.action()
                                    if button.role == ButtonRole.destructive, let onDestructiveDelete {
                                        onDestructiveDelete()
                                    }
                                    coroutineScope.launch {
                                        anchoredState.animateTo(SwipeAnchor.closed)
                                    }
                                })
                            }
                        }
                    }
                }
            }

            /*
             Foreground row content sizes itself naturally (no fillMaxSize)
             so the parent Box adopts its height and the LazyColumn item is
             measurable.
             On release, project the current position forward by the gesture's
             velocity and snap to whichever anchor (closed / leading-open /
             trailing-open / full-swipe) the projected position is closest to.
             This guarantees the row always lands on a defined state — never
             stops mid-track — and naturally handles reversing direction:
             dragging back from open toward closed projects past closed and
             snaps shut, even if the finger lifted while still partially open.
             Full-swipe checks ACTUAL drag distance, not the projected position,
             so a fast flick alone can't trigger the destructive action.
             */

            /* Anchor refresh: rebuilt whenever the measured sizes or
               allowsXxxFullSwipe flags change. Anchors are defined via
               Compose's DraggableAnchors DSL inside a SKIP INSERT block
               because Skip's transpiler doesn't model Kotlin lambdas with
               receiver-type extensions like `T.at(Float)`. */
            LaunchedEffect(rowWidthPx, trailingNaturalPx, leadingNaturalPx, allowsTrailingFullSwipe, allowsLeadingFullSwipe, trailingButtons.size, leadingButtons.size) {
                let hasTrailing = trailingButtons.size > 0
                let hasLeading = leadingButtons.size > 0
                let trailingOpenPos = -trailingNaturalPx
                let leadingOpenPos = leadingNaturalPx
                let trailingFullPos = -rowWidthPx
                let leadingFullPos = rowWidthPx
                // SKIP INSERT: val newAnchors = androidx.compose.foundation.gestures.DraggableAnchors<skip.ui.SwipeAnchor> {
                // SKIP INSERT:     skip.ui.SwipeAnchor.closed at 0f
                // SKIP INSERT:     if (hasTrailing) skip.ui.SwipeAnchor.trailingOpen at trailingOpenPos
                // SKIP INSERT:     if (allowsTrailingFullSwipe) skip.ui.SwipeAnchor.trailingFull at trailingFullPos
                // SKIP INSERT:     if (hasLeading) skip.ui.SwipeAnchor.leadingOpen at leadingOpenPos
                // SKIP INSERT:     if (allowsLeadingFullSwipe) skip.ui.SwipeAnchor.leadingFull at leadingFullPos
                // SKIP INSERT: }
                // SKIP INSERT: anchoredState.updateAnchors(newAnchors)
            }
            Box(modifier: Modifier
                .fillMaxWidth()
                .offset {
                    let o = anchoredState.offset
                    IntOffset(o.isNaN() ? 0 : o.toInt(), 0)
                }
                .anchoredDraggable(state: anchoredState, orientation: Orientation.Horizontal)
            ) {
                RenderItem(content: content, level: level, context: context, styling: styling)
                /* Subtle scrim that intensifies with swipe progress so the row
                   visually recedes as actions appear.*/
                let rawScrimOffset = anchoredState.offset
                let scrimOffset: Float = rawScrimOffset.isNaN() ? Float(0) : rawScrimOffset
                let curAbs = scrimOffset < Float(0) ? -scrimOffset : scrimOffset
                let openMag: Float
                if scrimOffset < Float(0) {
                    openMag = -trailingOpenPx
                } else if scrimOffset > Float(0) {
                    openMag = leadingOpenPx
                } else {
                    openMag = Float(1) // unused; progress stays 0
                }
                let progressRaw = openMag > Float(0) ? curAbs / openMag : Float(0)
                let progress: Float = progressRaw > Float(1) ? Float(1) : progressRaw
                if progress > Float(0) {
                    let scrimAlpha = progress * swipeScrimMaxAlpha
                    Box(modifier: Modifier.matchParentSize().background(androidx.compose.ui.graphics.Color.LightGray.copy(alpha: scrimAlpha)))
                }
            }
        }
    }

    /// Walk the renderable's ModifiedContent chain, run any
    /// EnvironmentModifier action in a scoped EnvironmentValues, and
    /// return whatever ._tint it sets. We walk manually (instead of
    /// forEachModifier) because the action is @Composable and so is
    /// setValuesWithReturn — both must be invoked from a @Composable
    /// scope, which forEachModifier's plain callback isn't. Outermost
    /// modifier processed first so the innermost wins (matches SwiftUI).
    @Composable private func ExtractEnvironmentTint(from renderable: Renderable) -> Color? {
        var captured: Color? = nil
        var current: Renderable? = renderable
        while let mod = current as? ModifiedContent {
            if let envMod = mod.modifier as? EnvironmentModifier, let action = envMod.action {
                let scoped: Color? = EnvironmentValues.shared.setValuesWithReturn(action) {
                    return EnvironmentValues.shared._tint
                }
                if scoped != nil {
                    captured = scoped
                }
            }
            current = mod.renderable
        }
        return captured
    }

    /// Render a single action button inside the swipe reveal area.
    /// Sizing is supplied by the caller: in natural mode this is
    /// widthIn(min:).fillMaxHeight() so the button hugs its label; in
    /// stretch mode it's fillMaxSize() inside a weighted Box so the button
    /// expands with the row. Padding around the label keeps icon/text from
    /// touching the cell edges.
    @Composable private func RenderSwipeRevealButton(button: Button, sizeModifier: Modifier, context: ComposeContext, tintOverride: Color? = nil, onTap: () -> Void) {
        let backgroundColor: androidx.compose.ui.graphics.Color
        let contentColor: androidx.compose.ui.graphics.Color
        if button.role == ButtonRole.destructive {
            /* Match the red used by the implicit onDelete SwipeToDismissBox so
               destructive actions look the same whether triggered via .onDelete
               or an explicit .swipeActions { Button(role: .destructive) }. */
            backgroundColor = androidx.compose.ui.graphics.Color.Red
            contentColor = androidx.compose.ui.graphics.Color.White
        } else {
            /* Per-button .tint(_:) wins over the surrounding env tint. */
            let tint = (tintOverride ?? EnvironmentValues.shared._tint)?.colorImpl()
            if let tint {
                backgroundColor = tint
                contentColor = androidx.compose.ui.graphics.Color.White
            } else {
                backgroundColor = MaterialTheme.colorScheme.secondaryContainer
                contentColor = MaterialTheme.colorScheme.onSecondaryContainer
            }
        }
        /* Render the user's label view (Text, Image, Label, or any custom
           composition). clipToBounds on the button means the label can
           safely use Modifier.width(IntrinsicSize.Max) — Text stays on one
           line at its intrinsic width and any overflow is clipped instead
           of wrapping mid-animation when full-swipe takeover squeezes a
           non-primary button's width below the natural content width. */
        Row(modifier: sizeModifier
            .clipToBounds()
            .background(backgroundColor)
            .clickable(onClick: onTap)
            .padding(horizontal: 12.dp, vertical: 8.dp),
            horizontalArrangement: Arrangement.Center,
            verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
            let contentSwiftColor = Color(colorImpl: { contentColor })
            EnvironmentValues.shared.setValues({
                $0.set_foregroundStyle(contentSwiftColor)
                return ComposeResult.ok
            }) {
                /* Apply the font via the .font() View modifier which routes
                   through environment(\.font, ...). Setting the font property
                   on EnvironmentValues directly isn't exposed as a Kotlin
                   setter by Skip's transpilation. */
                /* requiredWidth(IntrinsicSize.Max) overrides parent's max
                   width constraint so Text always lays out at its one-line
                   intrinsic width. An extra 8dp horizontal pad gives a tiny
                   measurement headroom so subpixel rounding can't trigger
                   a one-line→two-line→one-line flicker during the
                   takeover animation. The button Row's clipToBounds
                   clips the resulting overflow visually. */
                button.label.font(Font.footnote).Compose(context: context.content(modifier: Modifier.requiredWidth(IntrinsicSize.Max).padding(horizontal: 4.dp)))
            }
        }
    }

    @Composable private func RenderReorderableItem(reorderableState: ReorderableLazyListState, key: String, modifier: Modifier, content: @Composable (Modifier) -> Void) {
        ReorderableItem(state: reorderableState, key: key, defaultDraggingModifier: modifier) { dragging in
            var itemModifier = Modifier.detectReorderAfterLongPress(reorderableState)
            if dragging {
                let elevation = animateDpAsState(8.dp)
                itemModifier = itemModifier.shadow(elevation.value)
            }
            content(itemModifier)
        }
    }

    /// - Parameters:
    ///   - isExpanded: Whether a collapsible section is expanded, or nil if the section does not collapse.
    ///   - onToggle: Toggles a collapsible section.
    @Composable private func RenderSectionHeader(content: Renderable, context: ComposeContext, styling: ListStyling, isTop: Bool, isExpanded: Bool? = nil, onToggle: (() -> Void)? = nil) {
        if !isTop && !styling.isPlain {
            // Vertical padding
            RenderFooter(styling: styling, safeAreaHeight: 0.dp, hasBottomSection: true, spacing: styling.sectionSpacing ?? Self.verticalInset)
        }
        let backgroundColor = BackgroundColor(styling: styling, isItem: false)
        let modifier = Modifier
            .heightIn(min: (EnvironmentValues.shared.defaultMinListHeaderHeight ?? 0.0).dp)
            .zIndex(Float(0.5))
            .background(backgroundColor)
            .then(context.modifier)
        var contentModifier = Modifier.fillMaxWidth()
        if isTop && !styling.isPlain {
            contentModifier = contentModifier.padding(start: Self.horizontalItemInset.dp, top: 0.dp, end: Self.horizontalItemInset.dp, bottom: Self.verticalItemInset.dp)
        } else {
            contentModifier = contentModifier.padding(horizontal: Self.horizontalItemInset.dp, vertical: Self.verticalItemInset.dp)
        }
        Box(modifier: modifier, contentAlignment: androidx.compose.ui.Alignment.BottomCenter) {
            Column(modifier: Modifier.fillMaxWidth()) {
                EnvironmentValues.shared.setValues {
                    $0.set_listSectionHeaderStyle(styling.kind)
                    return ComposeResult.ok
                } in: {
                    if let isExpanded, let onToggle {
                        RenderCollapsibleSectionHeader(content: content, context: context, modifier: contentModifier, isExpanded: isExpanded, onToggle: onToggle)
                    } else {
                        content.Render(context: context.content(modifier: contentModifier))
                    }
                }
            }
            if styling.isInset {
                RenderRoundedCorners(isTop: true, fill: backgroundColor)
            }
        }
    }

    /// Render a sidebar section header whose trailing chevron rotates as the section expands, as on iOS.
    @Composable private func RenderCollapsibleSectionHeader(content: Renderable, context: ComposeContext, modifier: Modifier, isExpanded: Bool, onToggle: () -> Void) {
        let contentContext = context.content()
        let rotationAngle = Float(isExpanded ? 90 : 0).asAnimatable(context: contentContext)
        let isRTL = EnvironmentValues.shared.layoutDirection == .rightToLeft
        let tint = EnvironmentValues.shared._tint?.colorImpl() ?? Color.accentColor.colorImpl()
        Row(modifier: Modifier.clickable(onClick: onToggle).then(modifier), verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
            Box(modifier: Modifier.padding(end: 8.dp).weight(Float(1.0))) {
                content.Render(context: contentContext)
            }
            Icon(imageVector: isRTL ? Icons.Outlined.KeyboardArrowLeft : Icons.Outlined.KeyboardArrowRight, contentDescription: nil, modifier: Modifier.rotate(rotationAngle.value), tint: tint)
        }
    }

    /// Render a section's rows, hiding them while their collapsible section is collapsed.
    ///
    /// - Parameters:
    ///   - expansion: The section's `Section(isExpanded:)` binding, which takes precedence over sidebar collapsing.
    @Composable private func RenderSectionContent(section: Int, expansion: Binding<Bool>?, collapsedSections: MutableState<Set<Int>>, styling: ListStyling, content: @Composable () -> Void) {
        guard expansion != nil || (styling.isCollapsible && section >= 0) else {
            content()
            return
        }
        AnimatedVisibility(visible: expansion?.wrappedValue ?? !collapsedSections.value.contains(section), enter: expandVertically(), exit: shrinkVertically()) {
            content()
        }
    }

    /// - Parameters:
    ///   - isExpanded: Whether the footer's section is expanded; collapsed sections hide their footer.
    @Composable private func RenderSectionFooter(content: Renderable, context: ComposeContext, styling: ListStyling, isExpanded: Bool = true) {
        if styling.isPlain {
            let footerContent: Renderable
            if let lazySectionFooter = content as? LazySectionFooter, !lazySectionFooter.content.any({ !$0.isSwiftUIEmptyView }) {
                // Replace an empty footer with an empty view for RenderItem handling
                footerContent = EmptyView()
            } else {
                footerContent = content
            }
            RenderItem(content: footerContent, level: 0, context: context, styling: styling, isItem: false)
        } else {
            let backgroundColor = BackgroundColor(styling: styling, isItem: false)
            let modifier = Modifier.offset(y: -1.dp) // Cover last row's divider
                .zIndex(Float(0.5))
                .background(backgroundColor)
                .then(context.modifier)
            let contentModifier = Modifier.fillMaxWidth().padding(horizontal: Self.horizontalItemInset.dp, vertical: Self.verticalItemInset.dp)
            Box(modifier: modifier, contentAlignment: androidx.compose.ui.Alignment.TopCenter) {
                AnimatedVisibility(visible: isExpanded, enter: expandVertically(), exit: shrinkVertically()) {
                    Column(modifier: Modifier.fillMaxWidth().heightIn(min: 1.dp)) {
                        EnvironmentValues.shared.setValues {
                            $0.set_listSectionFooterStyle(styling.kind)
                            return ComposeResult.ok
                        } in: {
                            content.Render(context: context.content(modifier: contentModifier))
                        }
                    }
                }
                if styling.isInset {
                    RenderRoundedCorners(isTop: false, fill: backgroundColor)
                }
            }
        }
    }

    /// - Warning: Only call for non-.plain styles or with a positive safe area height. This is distinct from having this function detect
    /// .plain and zero-height and return without rendering. That causes .plain style lists to have a weird rubber banding effect on overscroll.
    @Composable private func RenderHeader(styling: ListStyling, safeAreaHeight: Dp, hasTopSection: Bool) {
        var height = safeAreaHeight
        if !styling.isPlain {
            height += Self.verticalInset.dp
        }
        let backgroundColor = BackgroundColor(styling: styling, isItem: false)
        let modifier = Modifier.fillMaxWidth()
            .height(height)
            .zIndex(Float(0.5))
            .background(backgroundColor)
        Box(modifier: modifier, contentAlignment: androidx.compose.ui.Alignment.BottomCenter) {
            if !hasTopSection && styling.isInset {
                RenderRoundedCorners(isTop: true, fill: backgroundColor)
            }
        }
    }

    /// - Warning: Only call for non-.plain styles or with a positive safe area height. This is distinct from having this function detect
    /// .plain and zero-height and return without rendering. That causes .plain style lists to have a weird rubber banding effect on overscroll.
    @Composable private func RenderFooter(styling: ListStyling, safeAreaHeight: Dp, hasBottomSection: Bool, spacing: CGFloat = verticalInset) {
        var height = safeAreaHeight
        var offset = 0.dp
        if !styling.isPlain {
            height += spacing.dp
            offset = -1.dp // Cover last row's divider
        }
        let backgroundColor = BackgroundColor(styling: styling, isItem: false)
        let modifier = Modifier.fillMaxWidth()
            .height(height)
            .offset(y: offset)
            .zIndex(Float(0.5))
            .background(backgroundColor)
        Box(modifier: modifier, contentAlignment: androidx.compose.ui.Alignment.TopCenter) {
            if !hasBottomSection && styling.isInset {
                RenderRoundedCorners(isTop: false, fill: backgroundColor)
            }
        }
    }

    @Composable private func RenderRoundedCorners(isTop: Bool, fill: androidx.compose.ui.graphics.Color) {
        let shape = GenericShape { size, _ in
            let rect = Rect(left: Float(0.0), top: Float(0.0), right: size.width, bottom: size.height)
            let rectPath = androidx.compose.ui.graphics.Path()
            rectPath.addRect(rect)
            let roundRect: RoundRect
            if isTop {
                roundRect = RoundRect(rect, topLeft: CornerRadius(size.height), topRight: CornerRadius(size.height))
            } else {
                roundRect = RoundRect(rect, bottomLeft: CornerRadius(size.height), bottomRight: CornerRadius(size.height))
            }
            let roundedRectPath = androidx.compose.ui.graphics.Path()
            roundedRectPath.addRoundRect(roundRect)
            addPath(combine(PathOperation.Difference, rectPath, roundedRectPath))
        }
        let offset = isTop ? listSectionCornerRadius.dp : -listSectionCornerRadius.dp
        let modifier = Modifier
            .fillMaxWidth()
            .height(listSectionCornerRadius.dp)
            .offset(y: offset)
            .clip(shape)
            .background(fill)
        Box(modifier: modifier)
    }

    /// Suggestion rows that replace the list's rows while its search field is focused, as on iOS, or nil.
    @Composable private func EvaluateSearchSuggestions(state: SearchableState?, context: ComposeContext) -> kotlin.collections.List<Renderable>? {
        guard let state, state.isFocused.value, EnvironmentValues.shared._searchSuggestionsVisibility != Visibility.hidden, let suggestions = EnvironmentValues.shared._searchSuggestions else {
            return nil
        }
        let renderables = suggestions.Evaluate(context: context, options: 0).filter { !$0.isSwiftUIEmptyView }
        guard renderables.size > 0 else {
            return nil
        }
        let focusManager = LocalFocusManager.current
        return renderables.map { renderable in
            guard let completion = renderable.forEachModifier({ ($0 as? SearchCompletionModifier)?.completion }) else {
                return renderable
            }
            // Completing fills the search text and submits, which dismisses the suggestions
            return renderable.asView()
                .frame(maxWidth: CGFloat.infinity, alignment: Alignment.leading)
                .onTapGesture { _ in
                    state.text.wrappedValue = completion
                    focusManager.clearFocus()
                    state.submitState?.onSubmit(trigger: SubmitTriggers.search)
                }
                .asRenderable()
        }
    }

    @Composable private func RenderSearchField(state: SearchableState, context: ComposeContext, styling: ListStyling, safeAreaHeight: Dp) {
        var modifier = Modifier.background(BackgroundColor(styling: styling, isItem: false))
        // Inset lists are already padded horizontally
        let horizontalPadding = styling.isInset ? 0.0 : Self.horizontalInset
        let bottomPadding = styling.isPlain ? Self.verticalInset : 0.0
        modifier = modifier.padding(top: Self.verticalInset.dp + safeAreaHeight, start: horizontalPadding.dp, end: horizontalPadding.dp, bottom: bottomPadding.dp)
        modifier = modifier.fillMaxWidth()
        SearchField(state: state, context: context.content(modifier: modifier))
    }

    @Composable private func BackgroundColor(styling: ListStyling, isItem: Bool) -> androidx.compose.ui.graphics.Color {
        if !isItem && styling.backgroundVisibility == Visibility.hidden {
            return Color.clear.colorImpl()
        } else if !styling.isGroupedBackground {
            return Color.background.colorImpl()
        } else {
            return Color.systemBarBackground.colorImpl()
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
// Kotlin does not support generic constructor parameters, so we have to model many List constructors as functions

//extension List {
//    public init<Data, RowContent>(_ data: Data, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable
//}
public func List<ObjectType>(_ data: any RandomAccessCollection<ObjectType>, @ViewBuilder rowContent: (ObjectType) -> any View) -> List {
    return List(identifier: { ($0 as! Identifiable<Hashable>).id }, objects: data as! RandomAccessCollection<Any>, objectContent: { rowContent($0 as! ObjectType) })
}

//extension List {
//    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View
//}
public func List<ObjectType>(_ data: any RandomAccessCollection<ObjectType>, id: (ObjectType) -> AnyHashable?, @ViewBuilder rowContent: (ObjectType) -> any View) -> List where ObjectType: Any {
    return List(identifier: { id($0 as! ObjectType) }, objects: data as! RandomAccessCollection<Any>, objectContent: { rowContent($0 as! ObjectType) })
}
/// A list whose rows select into a single optional value, or into a `Set` while editing, as on iOS.
public func List<SelectionValue>(selection: Binding<SelectionValue>, @ViewBuilder content: () -> any View) -> List {
    return List(fixedContent: content(), selection: selection as! Binding<Any>)
}

public func List<ObjectType, SelectionValue>(_ data: any RandomAccessCollection<ObjectType>, selection: Binding<SelectionValue>, @ViewBuilder rowContent: @escaping (ObjectType) -> any View) -> List {
    return List(identifier: { ($0 as! Identifiable<Hashable>).id }, objects: data as! RandomAccessCollection<Any>, objectContent: { rowContent($0 as! ObjectType) }, selection: selection as! Binding<Any>)
}

public func List<ObjectType, SelectionValue>(_ data: any RandomAccessCollection<ObjectType>, id: (ObjectType) -> AnyHashable?, selection: Binding<SelectionValue>, @ViewBuilder rowContent: @escaping (ObjectType) -> any View) -> List {
    return List(identifier: { id($0 as! ObjectType) }, objects: data as! RandomAccessCollection<Any>, objectContent: { rowContent($0 as! ObjectType) }, selection: selection as! Binding<Any>)
}

/// A hierarchical list whose rows with children expand like iOS outlines.
// SKIP INSERT: @JvmName("ListWithChildren")
public func List<ObjectType>(_ data: any RandomAccessCollection<ObjectType>, children: @escaping (ObjectType) -> (any RandomAccessCollection<ObjectType>)?, @ViewBuilder rowContent: @escaping (ObjectType) -> any View) -> List {
    return List(fixedContent: OutlineGroup(data, children: children, content: rowContent))
}

public func List<ObjectType>(_ data: any RandomAccessCollection<ObjectType>, id: @escaping (ObjectType) -> AnyHashable?, children: @escaping (ObjectType) -> (any RandomAccessCollection<ObjectType>)?, @ViewBuilder rowContent: @escaping (ObjectType) -> any View) -> List {
    return List(fixedContent: OutlineGroup(data, id: id, children: children, content: rowContent))
}

public func List(_ data: Range<Int>, id: ((Int) -> AnyHashable?)? = nil, @ViewBuilder rowContent: (Int) -> any View) -> List {
    return List(identifier: id == nil ? nil : { id!($0 as! Int) }, indexRange: data, indexedContent: rowContent)
}

//extension List {
//  public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions /* <Data> */, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable
//}
public func List<Data, ObjectType>(_ data: Binding<Data>, editActions: EditActions = [], @ViewBuilder rowContent: (Binding<ObjectType>) -> any View) -> List where Data: RandomAccessCollection<ObjectType> {
    return List(identifier: { ($0 as! Identifiable<Hashable>).id }, objectsBinding: data as! Binding<RandomAccessCollection<Any>>, objectsBindingContent: { data, index in
        let binding = Binding<ObjectType>(get: { data.wrappedValue[index] as! ObjectType }, set: { (data.wrappedValue as! skip.lib.MutableCollection<ObjectType>)[index] = $0 })
        return rowContent(binding)
    }, editActions: editActions)
}

//extension List {
//  public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions /* <Data> */, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable
//}
public func List<Data, ObjectType>(_ data: Binding<Data>, id: (ObjectType) -> AnyHashable?, editActions: EditActions = [], @ViewBuilder rowContent: (Binding<ObjectType>) -> any View) -> List where Data: RandomAccessCollection<ObjectType> {
    return List(identifier: { id($0 as! ObjectType) }, objectsBinding: data as! Binding<RandomAccessCollection<Any>>, objectsBindingContent: { data, index in
        let binding = Binding<ObjectType>(get: { data.wrappedValue[index] as! ObjectType }, set: { (data.wrappedValue as! skip.lib.MutableCollection<ObjectType>)[index] = $0 })
        return rowContent(binding)
    }, editActions: editActions)
}
#endif

struct ListStyling: Equatable {
    let kind: ListStyleKind
    let backgroundVisibility: Visibility
    /// Spacing between grouped sections, or nil for the default.
    var sectionSpacing: CGFloat? = nil

    func withKind(_ kind: ListStyleKind) -> ListStyling {
        return ListStyling(kind: kind, backgroundVisibility: backgroundVisibility, sectionSpacing: sectionSpacing)
    }

    /// Full-width rows, pinned section headers, and footers rendered as rows.
    var isPlain: Bool {
        return kind == .plain
    }

    /// Rows inset from the list edges, with rounded section corners.
    var isInset: Bool {
        return kind == .insetGrouped || kind == .inset || kind == .sidebar
    }

    /// Rows sit on the grouped system background rather than the plain background.
    var isGroupedBackground: Bool {
        return kind == .grouped || kind == .insetGrouped || kind == .sidebar
    }

    /// Section headers toggle their section's rows.
    var isCollapsible: Bool {
        return kind == .sidebar
    }
}

#if SKIP
@Stable struct ListArguments: Equatable {
    let headerSafeAreaHeight: Dp
    let footerSafeAreaHeight: Dp
    let safeAreaEdges: Edge.Set
}
#endif

/// A protocol that describes the behavior and appearance of a list.
///
/// To configure the list style for a view hierarchy, use the `listStyle(_:)` modifier.
public protocol ListStyle {
}

/// The list style that describes a platform's default behavior and appearance for a list.
public struct DefaultListStyle : ListStyle {
    public init() {
    }
}

/// The list style that describes the behavior and appearance of a plain list.
public struct PlainListStyle : ListStyle {
    public init() {
    }
}

/// The list style that describes the behavior and appearance of a grouped list.
public struct GroupedListStyle : ListStyle {
    public init() {
    }
}

/// The list style that describes the behavior and appearance of an inset grouped list.
public struct InsetGroupedListStyle : ListStyle {
    public init() {
    }
}

/// The list style that describes the behavior and appearance of an inset list.
public struct InsetListStyle : ListStyle {
    public init() {
    }
}

/// The list style that describes the behavior and appearance of a sidebar list, whose sections collapse.
public struct SidebarListStyle : ListStyle {
    public init() {
    }
}

extension ListStyle where Self == DefaultListStyle {
    public static var automatic: DefaultListStyle { DefaultListStyle() }
}

extension ListStyle where Self == PlainListStyle {
    public static var plain: PlainListStyle { PlainListStyle() }
}

extension ListStyle where Self == GroupedListStyle {
    public static var grouped: GroupedListStyle { GroupedListStyle() }
}

extension ListStyle where Self == InsetGroupedListStyle {
    public static var insetGrouped: InsetGroupedListStyle { InsetGroupedListStyle() }
}

extension ListStyle where Self == InsetListStyle {
    public static var inset: InsetListStyle { InsetListStyle() }
}

extension ListStyle where Self == SidebarListStyle {
    public static var sidebar: SidebarListStyle { SidebarListStyle() }
}

/// The built-in appearance a `ListStyle` renders as.
enum ListStyleKind {
    case plain
    case grouped
    case insetGrouped
    case inset
    case sidebar

    /// Resolve a style; `.automatic` matches iOS, which uses `.insetGrouped`.
    static func of(_ style: any ListStyle) -> ListStyleKind {
        switch style {
        case is PlainListStyle: return .plain
        case is GroupedListStyle: return .grouped
        case is InsetListStyle: return .inset
        case is SidebarListStyle: return .sidebar
        default: return .insetGrouped
        }
    }
}

public enum ListItemTint {
    case fixed(Color)
    case preferred(Color)
    case monochrome
}

public enum ListSectionSpacing {
    case `default`
    case compact
    case custom(CGFloat)
}

extension View {
    // SKIP @bridge
    public func listRowBackground(_ view: (any View)?) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: ListItemModifier(background: view))
        #else
        return self
        #endif
    }
    
    /// - Note: Rows draw only their bottom separator, so the `.top` edge alone has no effect.
    public func listRowSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> some View {
        #if SKIP
        guard edges.contains(.bottom) else {
            return self
        }
        return ModifiedContent(content: self, modifier: ListItemModifier(separator: visibility))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func listRowSeparator(bridgedVisibility: Int, bridgedEdges: Int) -> any View {
        return listRowSeparator(Visibility(rawValue: bridgedVisibility) ?? .automatic, edges: VerticalEdge.Set(rawValue: bridgedEdges))
    }

    // SKIP @bridge
    public func listRowSeparatorTint(_ color: Color?, bridgedEdges: Int) -> any View {
        return listRowSeparatorTint(color, edges: VerticalEdge.Set(rawValue: bridgedEdges))
    }

    public func listRowSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> any View {
        #if SKIP
        guard edges.contains(.bottom) else {
            return self
        }
        return ModifiedContent(content: self, modifier: ListItemModifier(separatorTint: color))
        #else
        return self
        #endif
    }

    /// Shows or hides the trailing section index built from `sectionIndexLabel`; `.automatic` shows it when sections have labels.
    // SKIP @bridge
    public func listSectionIndexVisibility(bridgedVisibility: Int) -> any View {
        return listSectionIndexVisibility(Visibility(rawValue: bridgedVisibility) ?? .automatic)
    }

    public func listSectionIndexVisibility(_ visibility: Visibility) -> any View {
        #if SKIP
        return environment(\._listSectionIndexVisibility, visibility, affectsEvaluate: false)
        #else
        return self
        #endif
    }

    /// - Note: Sections draw only their bottom separator, below the last row, so the `.top` edge alone has no effect.
    // SKIP @bridge
    public func listSectionSeparator(bridgedVisibility: Int, bridgedEdges: Int) -> any View {
        return listSectionSeparator(Visibility(rawValue: bridgedVisibility) ?? .automatic, edges: VerticalEdge.Set(rawValue: bridgedEdges))
    }

    public func listSectionSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> any View {
        #if SKIP
        guard edges.contains(.bottom) else {
            return self
        }
        return ModifiedContent(content: self, modifier: ListItemModifier(sectionSeparator: visibility))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func listSectionSeparatorTint(_ color: Color?, bridgedEdges: Int) -> any View {
        return listSectionSeparatorTint(color, edges: VerticalEdge.Set(rawValue: bridgedEdges))
    }

    public func listSectionSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> any View {
        #if SKIP
        guard edges.contains(.bottom) else {
            return self
        }
        return ModifiedContent(content: self, modifier: ListItemModifier(sectionSeparatorTint: color))
        #else
        return self
        #endif
    }

    public func listStyle(_ style: any ListStyle) -> any View {
        #if SKIP
        return environment(\._listStyle, style, affectsEvaluate: false)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func listStyle(bridgedStyle: Int) -> any View {
        switch bridgedStyle {
        case 1:
            return listStyle(SidebarListStyle())
        case 2:
            return listStyle(InsetGroupedListStyle())
        case 3:
            return listStyle(GroupedListStyle())
        case 4:
            return listStyle(InsetListStyle())
        case 5:
            return listStyle(PlainListStyle())
        default:
            return listStyle(DefaultListStyle())
        }
    }

    public func listItemTint(_ tint: ListItemTint?) -> any View {
        switch tint {
        case .fixed(let color):
            return listItemTint(color)
        case .preferred(let color):
            return listItemTint(color)
        case .monochrome:
            return listItemTint(Color.secondary)
        case nil:
            return listItemTint(nil as Color?)
        }
    }

    // SKIP @bridge
    public func listItemTint(_ tint: Color?) -> any View {
        #if SKIP
        return environment(\._listItemTint, tint, affectsEvaluate: false)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func listRowInsets(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> any View {
        return listRowInsets(EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }

    public func listRowInsets(_ insets: EdgeInsets?) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: ListItemModifier(insets: insets))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func listRowSpacing(_ spacing: CGFloat?) -> any View {
        #if SKIP
        return environment(\._listRowSpacing, spacing, affectsEvaluate: false)
        #else
        return self
        #endif
    }

    public func listSectionSpacing(_ spacing: ListSectionSpacing) -> any View {
        switch spacing {
        case .default:
            return listSectionSpacingValue(nil)
        case .compact:
            return listSectionSpacingValue(8.0)
        case .custom(let length):
            return listSectionSpacingValue(length)
        }
    }

    public func listSectionSpacing(_ spacing: CGFloat) -> any View {
        return listSectionSpacingValue(spacing)
    }

    /// Bridged section spacing; `nil` restores the default.
    // SKIP @bridge
    public func listSectionSpacingValue(_ spacing: CGFloat?) -> any View {
        #if SKIP
        return environment(\._listSectionSpacing, spacing, affectsEvaluate: false)
        #else
        return self
        #endif
    }

}

#if SKIP
/// A labelled section in a list's section index.
struct SectionIndexEntry {
    let label: Text
    /// The lazy item index of the section's header.
    let itemIndex: Int
}

/// Carries a section's `sectionIndexLabel`.
final class SectionIndexLabelModifier: RenderModifier {
    let label: Text

    init(label: Text) {
        self.label = label
        super.init()
    }
}

final class ListItemModifier: RenderModifier {
    let background: View?
    let separator: Visibility?
    let separatorTint: Color?
    let insets: EdgeInsets?
    let sectionSeparator: Visibility?
    let sectionSeparatorTint: Color?
    let isSectionEnd: Bool
    let selectionDisabled: Bool?
    /// Separator edge guides from `alignmentGuide(.listRowSeparatorLeading/Trailing)`, in row content coordinates.
    let separatorLeading: ((ViewDimensions) -> CGFloat)?
    let separatorTrailing: ((ViewDimensions) -> CGFloat)?

    init(background: View? = nil, separator: Visibility? = nil, separatorTint: Color? = nil, insets: EdgeInsets? = nil, sectionSeparator: Visibility? = nil, sectionSeparatorTint: Color? = nil, isSectionEnd: Bool = false, selectionDisabled: Bool? = nil, separatorLeading: ((ViewDimensions) -> CGFloat)? = nil, separatorTrailing: ((ViewDimensions) -> CGFloat)? = nil) {
        self.background = background
        self.separator = separator
        self.separatorTint = separatorTint
        self.insets = insets
        self.sectionSeparator = sectionSeparator
        self.sectionSeparatorTint = sectionSeparatorTint
        self.isSectionEnd = isSectionEnd
        self.selectionDisabled = selectionDisabled
        self.separatorLeading = separatorLeading
        self.separatorTrailing = separatorTrailing
        super.init()
    }

    /// Merge all list item modifiers on the renderable; the innermost value of each property wins.
    static func combined(for renderable: Renderable) -> ListItemModifier {
        var background: View? = nil
        var separator: Visibility? = nil
        var separatorTint: Color? = nil
        var insets: EdgeInsets? = nil
        var sectionSeparator: Visibility? = nil
        var sectionSeparatorTint: Color? = nil
        var isSectionEnd = false
        var selectionDisabled: Bool? = nil
        var separatorLeading: ((ViewDimensions) -> CGFloat)? = nil
        var separatorTrailing: ((ViewDimensions) -> CGFloat)? = nil
        renderable.forEachModifier {
            if let listItemModifier = $0 as? ListItemModifier {
                background = background ?? listItemModifier.background
                separator = separator ?? listItemModifier.separator
                separatorTint = separatorTint ?? listItemModifier.separatorTint
                insets = insets ?? listItemModifier.insets
                sectionSeparator = sectionSeparator ?? listItemModifier.sectionSeparator
                sectionSeparatorTint = sectionSeparatorTint ?? listItemModifier.sectionSeparatorTint
                isSectionEnd = isSectionEnd || listItemModifier.isSectionEnd
                selectionDisabled = selectionDisabled ?? listItemModifier.selectionDisabled
                separatorLeading = separatorLeading ?? listItemModifier.separatorLeading
                separatorTrailing = separatorTrailing ?? listItemModifier.separatorTrailing
            }
            return nil
        }
        return ListItemModifier(background: background, separator: separator, separatorTint: separatorTint, insets: insets, sectionSeparator: sectionSeparator, sectionSeparatorTint: sectionSeparatorTint, isSectionEnd: isSectionEnd, selectionDisabled: selectionDisabled, separatorLeading: separatorLeading, separatorTrailing: separatorTrailing)
    }
}
#endif

#if false
/*
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Data, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a list that computes its views on demand over a constant range,
    /// optionally allowing users to select multiple rows.
    ///
    /// This instance only reads the initial value of `data` and doesn't need to
    /// identify views across updates. To compute views on demand over a dynamic
    /// range, use ``List/init(_:id:selection:rowContent:)-9a28m``.
    ///
    /// - Parameters:
    ///   - data: A constant range of data to populate the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<RowContent>(_ data: Range<Int>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS 10.0, *)
//    @MainActor public init<Data, RowContent>(_ data: Data, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS 10.0, *)
//    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a list that computes its views on demand over a constant range,
    /// optionally allowing users to select a single row.
    ///
    /// This instance only reads the initial value of `data` and doesn't need to
    /// identify views across updates. To compute views on demand over a dynamic
    /// range, use ``List/init(_:id:selection:rowContent:)-2r2u9``.
    ///
    /// - Parameters:
    ///   - data: A constant range of data to populate the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<RowContent>(_ data: Range<Int>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, RowContent>, RowContent : View { fatalError() }
}

//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension List where SelectionValue == Never {
    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data.
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
//}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension List {

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data, optionally
    /// allowing users to select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data, optionally
    /// allowing users to select a single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
}

//@available(iOS 15.0, macOS 12.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension List where SelectionValue == Never {

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data.
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
//}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable, allows to edit the collection, and
    /// optionally allows users to select multiple rows.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select multiple elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFoods
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing and to be edited by
    ///     the list.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions /* <Data> */, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable, allows to edit the collection, and
    /// optionally allows users to select multiple rows.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select multiple elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFoods
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing and to be edited by
    ///     the list.
    ///   - id: The key path to the data model's identifier.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions /* <Data> */, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, allows to edit the collection, and
    /// optionally allowing users to select a single row.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select a single elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFood
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions /* <Data> */, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, allows to edit the collection, and
    /// optionally allowing users to select a single row.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select a single elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFood
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - id: The key path to the data model's identifier.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions /* <Data> */, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}
 */
#endif
#endif
