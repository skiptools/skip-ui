// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.requiredHeightIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.GenericShape
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.pullrefresh.PullRefreshIndicator
import androidx.compose.material.pullrefresh.PullRefreshState
import androidx.compose.material.pullrefresh.pullRefresh
import androidx.compose.material.pullrefresh.rememberPullRefreshState
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.SwipeToDismissBox
import androidx.compose.material3.SwipeToDismissBoxValue
import androidx.compose.material3.SwipeToDismissBoxDefaults
import androidx.compose.material3.rememberSwipeToDismissBoxState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.Stable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.RoundRect
import androidx.compose.ui.graphics.Path.Companion.combine
import androidx.compose.ui.graphics.PathOperation
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.zIndex
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.Dp
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
let listSectionnCornerRadius = 8.0

// SKIP INSERT: @Stable // Otherwise Compose recomposes all internal @Composable funcs because 'this' is unstable
@available(iOS 16.0, macOS 14.0, *)
public final class List : View {
    let fixedContent: ComposeBuilder?
    let forEach: ForEach?
    let itemTransformer: ((any View) -> any View)?

    init(fixedContent: (any View)? = nil, identifier: ((Any) -> AnyHashable?)? = nil, itemTransformer: ((any View) -> any View)? = nil, indexRange: Range<Int>? = nil, indexedContent: ((Int) -> any View)? = nil, objects: (any RandomAccessCollection<Any>)? = nil, objectContent: ((Any) -> any View)? = nil, objectsBinding: Binding<any RandomAccessCollection<Any>>? = nil, objectsBindingContent: ((Binding<any RandomAccessCollection<Any>>, Int) -> any View)? = nil, editActions: EditActions = []) {
        if let fixedContent {
            self.fixedContent = fixedContent as? ComposeBuilder ?? ComposeBuilder(view: fixedContent)
        } else {
            self.fixedContent = nil
        }
        if let indexRange {
            self.forEach = ForEach(identifier: identifier, indexRange: indexRange, indexedContent: indexedContent)
        } else if let objects {
            self.forEach = ForEach(identifier: identifier, objects: objects, objectContent: objectContent)
        } else if let objectsBinding {
            self.forEach = ForEach(identifier: identifier, objectsBinding: objectsBinding, objectsBindingContent: objectsBindingContent, editActions: editActions)
        } else {
            self.forEach = nil
        }
        self.itemTransformer = itemTransformer
    }

    public convenience init(@ViewBuilder content: () -> any View) {
        self.init(fixedContent: content())
    }

    @available(*, unavailable)
    public convenience init(selection: Binding<Any>, @ViewBuilder content: () -> any View) {
        self.init(fixedContent: content())
    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalMaterialApi::class)
    @Composable public override func ComposeContent(context: ComposeContext) {
        let style = EnvironmentValues.shared._listStyle ?? ListStyle.automatic
        let backgroundVisibility = EnvironmentValues.shared._scrollContentBackground ?? Visibility.visible
        let styling = ListStyling(style: style, backgroundVisibility: backgroundVisibility)
        let itemContext = context.content()

        // When we layout, extend into safe areas that are due to system bars, not into any app chrome
        let safeArea = EnvironmentValues.shared._safeArea
        var ignoresSafeAreaEdges: Edge.Set = [.top, .bottom]
        ignoresSafeAreaEdges.formIntersection(safeArea?.absoluteSystemBarEdges ?? [])
        IgnoresSafeAreaLayout(edges: ignoresSafeAreaEdges, context: context) { context in
            ComposeContainer(scrollAxes: .vertical, modifier: context.modifier, fillWidth: true, fillHeight: true, then: Modifier.background(BackgroundColor(styling: styling, isItem: false))) { modifier in
                let containerModifier: Modifier
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
                Box(modifier: containerModifier) {
                    let density = LocalDensity.current
                    let headerSafeAreaHeight = headerSafeAreaHeight(safeArea, density: density)
                    let footerSafeAreaHeight = footerSafeAreaHeight(safeArea, density: density)
                    ComposeList(context: itemContext, styling: styling, headerSafeAreaHeight: headerSafeAreaHeight, footerSafeAreaHeight: footerSafeAreaHeight)
                    if let refreshState {
                        PullRefreshIndicator(refreshing.value, refreshState, Modifier.align(androidx.compose.ui.Alignment.TopCenter))
                    }
                }
            }
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalFoundationApi::class)
    @Composable private func ComposeList(context: ComposeContext, styling: ListStyling, headerSafeAreaHeight: Dp, footerSafeAreaHeight: Dp) {
        // Collect all top-level views to compose. The LazyColumn itself is not a composable context, so we have to execute
        // our content's Compose function to collect its views before entering the LazyColumn body, then use LazyColumn's
        // LazyListScope functions to compose individual items
        let collectingComposer = LazyItemCollectingComposer()
        let viewsCollector = context.content(composer: collectingComposer)
        if let forEach {
            forEach.appendLazyItemViews(to: collectingComposer, appendingContext: viewsCollector)
        } else if let fixedContent {
            fixedContent.Compose(context: viewsCollector)
        }

        var modifier = context.modifier
        if styling.style != .plain {
            modifier = modifier.padding(start: Self.horizontalInset.dp, end: Self.horizontalInset.dp)
        }
        modifier = modifier.fillMaxWidth()

        let searchableState = EnvironmentValues.shared._searchableState
        let isSearchable = searchableState?.isOnNavigationStack() == false

        let hasHeader = styling.style != ListStyle.plain || (!isSearchable && headerSafeAreaHeight.value > 0)
        let hasFooter = styling.style != ListStyle.plain || footerSafeAreaHeight.value > 0

        // Remember the factory because we use it in the remembered reorderable state
        let factoryContext = remember { mutableStateOf(LazyItemFactoryContext()) }
        let moveTrigger = remember { mutableStateOf(0) }
        let listState = rememberLazyListState(initialFirstVisibleItemIndex = isSearchable && headerSafeAreaHeight.value <= 0 ? 1 : 0)
        let reorderableState = rememberReorderableLazyListState(listState: listState, onMove: { from, to in
            // Trigger recompose on move, but don't read the trigger state until we're inside the list content to limit its scope
            factoryContext.value.move(from: from.index, to: to.index, trigger: { moveTrigger.value = $0 })
        }, onDragEnd: { _, _ in
            factoryContext.value.commitMove()
        }, canDragOver: { candidate, dragging in
            factoryContext.value.canMove(from: dragging.index, to: candidate.index)
        })
        modifier = modifier.reorderable(reorderableState)

        // Integrate with our scroll-to-top and ScrollViewReader
        let coroutineScope = rememberCoroutineScope()
        PreferenceValues.shared.contribute(context: context, key: ScrollToTopPreferenceKey.self, value: {
            coroutineScope.launch {
                reorderableState.listState.animateScrollToItem(0)
            }
        })
        let scrollToID: (Any) -> Void = { id in
            if let itemIndex = factoryContext.value.index(for: id) {
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
        let isSystemBackground = styling.style != ListStyle.plain && styling.backgroundVisibility != Visibility.hidden
        PreferenceValues.shared.contribute(context: context, key: ToolbarPreferenceKey.self, value: ToolbarPreferences(isSystemBackground: isSystemBackground, scrollableState: listState, for: [ToolbarPlacement.navigationBar, ToolbarPlacement.bottomBar]))
        PreferenceValues.shared.contribute(context: context, key: TabBarPreferenceKey.self, value: ToolbarBarPreferences(isSystemBackground: isSystemBackground, scrollableState: listState))

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

        let isTagging = EnvironmentValues.shared._placement.contains(ViewPlacement.tagged)
        LazyColumn(state: reorderableState.listState, modifier: modifier) {
            let sectionHeaderContext = context.content(composer: RenderingComposer { view, context in
                ComposeSectionHeader(view: view, context: context(false), styling: styling, isTop: false)
            })
            let topSectionHeaderContext = context.content(composer: RenderingComposer { view, context in
                ComposeSectionHeader(view: view, context: context(false), styling: styling, isTop: true)
            })
            let sectionFooterContext = context.content(composer: RenderingComposer { view, context in
                ComposeSectionFooter(view: view, context: context(false), styling: styling)
            })

            // Read move trigger here so that a move will recompose list content
            let _ = moveTrigger.value
            let shouldAnimateItems: @Composable () -> Bool = {
                // We disable animation to prevent filtered items from animating when they return
                let animate = !forceUnanimatedItems.value && EnvironmentValues.shared._searchableState?.isFiltering() != true
                return animate
            }

            // Initialize the factory context with closures that use the LazyListScope to generate items
            var startItemIndex = hasHeader ? 1 : 0 // Header inset
            if isSearchable {
                startItemIndex += 1 // Search field
            }
            factoryContext.value.initialize(
                isTagging: isTagging,
                startItemIndex: startItemIndex,
                item: { view, level in
                    item {
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItemPlacement() : Modifier
                        let itemContext = context.content(composer: RenderingComposer { view, context in
                            ComposeItem(view: view, level: level, context: context(false), modifier: itemModifier, styling: styling)
                        })
                        view.Compose(context: itemContext)
                    }
                },
                indexedItems: { range, identifier, offset, onDelete, onMove, level, factory in
                    let count = range.endExclusive - range.start
                    let key: ((Int) -> String)? = identifier == nil ? nil : { composeBundleString(for: identifier!(range.start + factoryContext.value.remapIndex($0, from: offset))) }
                    items(count: count, key: key) { index in
                        let keyValue = key?(index) // Key closure already remaps index
                        let index = factoryContext.value.remapIndex(index, from: offset)
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItemPlacement() : Modifier
                        let editableItemContext = context.content(composer: RenderingComposer { view, context in
                            ComposeEditableItem(view: view, level: level, context: context(false), modifier: itemModifier, styling: styling, key: keyValue, index: index, onDelete: onDelete, onMove: onMove, reorderableState: reorderableState)
                        })
                        factory(index + range.start).Compose(context: editableItemContext)
                    }
                },
                objectItems: { objects, identifier, offset, onDelete, onMove, level, factory in
                    let key: (Int) -> String = { composeBundleString(for: identifier(objects[factoryContext.value.remapIndex($0, from: offset)])) }
                    items(count: objects.count, key: key) { index in
                        let keyValue = key(index) // Key closure already remaps index
                        let index = factoryContext.value.remapIndex(index, from: offset)
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItemPlacement() : Modifier
                        let editableItemContext = context.content(composer: RenderingComposer { view, context in
                            ComposeEditableItem(view: view, level: level, context: context(false), modifier: itemModifier, styling: styling, key: keyValue, index: index, onDelete: onDelete, onMove: onMove, reorderableState: reorderableState)
                        })
                        factory(objects[index]).Compose(context: editableItemContext)
                    }
                },
                objectBindingItems: { objectsBinding, identifier, offset, editActions, onDelete, onMove, level, factory in
                    let key: (Int) -> String = { composeBundleString(for: identifier(objectsBinding.wrappedValue[factoryContext.value.remapIndex($0, from: offset)])) }
                    items(count: objectsBinding.wrappedValue.count, key: key) { index in
                        let keyValue = key(index) // Key closure already remaps index
                        let index = factoryContext.value.remapIndex(index, from: offset)
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItemPlacement() : Modifier
                        let editableItemContext = context.content(composer: RenderingComposer { view, context in
                            ComposeEditableItem(view: view, level: level, context: context(false), modifier: itemModifier, styling: styling, objectsBinding: objectsBinding, key: keyValue, index: index, editActions: editActions, onDelete: onDelete, onMove: onMove, reorderableState: reorderableState)
                        })
                        factory(objectsBinding, index).Compose(context: editableItemContext)
                    }
                },
                sectionHeader: { view in
                    let context = view === collectingComposer.views.firstOrNull() ? topSectionHeaderContext : sectionHeaderContext
                    if styling.style == .plain {
                        stickyHeader {
                            view.Compose(context: context)
                        }
                    } else {
                        item {
                            view.Compose(context: context)
                        }
                    }
                },
                sectionFooter: { view in
                    item {
                        view.Compose(context: sectionFooterContext)
                    }
                }
            )

            if isSearchable {
                item {
                    ComposeSearchField(state: searchableState!, context: context, styling: styling, safeAreaHeight: headerSafeAreaHeight)
                }
            }
            if hasHeader {
                let hasTopSection = collectingComposer.views.firstOrNull() is LazySectionHeader
                item {
                    ComposeHeader(styling: styling, safeAreaHeight: isSearchable ? 0.dp : headerSafeAreaHeight, hasTopSection: hasTopSection)
                }
            }
            for (view, level) in collectingComposer.views {
                if let factory = view as? LazyItemFactory {
                    factory.composeLazyItems(context: factoryContext.value, level: level)
                } else {
                    factoryContext.value.item(view, level)
                }
            }
            if hasFooter {
                let hasBottomSection = collectingComposer.views.lastOrNull() is LazySectionFooter
                item {
                    ComposeFooter(styling: styling, safeAreaHeight: footerSafeAreaHeight, hasBottomSection: hasBottomSection)
                }
            }
        }
    }

    private func headerSafeAreaHeight(_ safeArea: SafeArea?, density: Density) -> Dp {
        guard let safeArea, safeArea.absoluteSystemBarEdges.contains(.top) && safeArea.safeBoundsPx.top > safeArea.presentationBoundsPx.top else {
            return 0.dp
        }
        return with(density) { (safeArea.safeBoundsPx.top - safeArea.presentationBoundsPx.top).toDp() }
    }

    private func footerSafeAreaHeight(_ safeArea: SafeArea?, density: Density) -> Dp {
        guard let safeArea, safeArea.absoluteSystemBarEdges.contains(.bottom) && safeArea.presentationBoundsPx.bottom > safeArea.safeBoundsPx.bottom else {
            return 0.dp
        }
        return with(density) { (safeArea.presentationBoundsPx.bottom - safeArea.safeBoundsPx.bottom).toDp() }
    }

    private static let horizontalInset = 16.0
    private static let verticalInset = 16.0
    private static let minimumItemHeight = 32.0
    private static let horizontalItemInset = 16.0
    private static let verticalItemInset = 8.0
    private static let levelInset = 24.0

    static func contentModifier(level: Int) -> Modifier {
        return Modifier.padding(start: (horizontalItemInset + level * levelInset).dp, end: horizontalItemInset.dp, top: verticalItemInset.dp, bottom: verticalItemInset.dp).fillMaxWidth().requiredHeightIn(min: minimumItemHeight.dp)
    }

    @Composable static func ComposeSeparator(level: Int) {
        androidx.compose.material3.Divider(modifier: Modifier.padding(start: (horizontalItemInset + level * levelInset).dp).fillMaxWidth(), color: Color.separator.colorImpl())
    }

    @Composable private func ComposeItem(view: View, level: Int, context: ComposeContext, modifier: Modifier = Modifier, styling: ListStyling, isItem: Bool = true) {
        guard !view.isSwiftUIEmptyView else {
            return
        }

        let itemModifierView = view.strippingModifiers(until: { $0 == .listItem }, perform: { $0 as? ListItemModifierView })
        var itemModifier: Modifier = Modifier
        if itemModifierView?.background == nil {
            itemModifier = itemModifier.background(BackgroundColor(styling: styling.withStyle(ListStyle.plain), isItem: isItem))
        }

        // The given modifiers include elevation shadow for dragging, etc that need to go before the others
        let containerContext = context.content(modifier: modifier.then(itemModifier).then(context.modifier))
        let composeContainer: @Composable (ComposeContext) -> Void = { context in
            Column(modifier: context.modifier) {
                let placement = EnvironmentValues.shared._placement
                EnvironmentValues.shared.setValues {
                    $0.set_placement(placement.union(ViewPlacement.listItem))
                } in: {
                    // Note that we're calling the same view's Compose function again with a new context
                    view.Compose(context: context.content(composer: ListItemComposer(contentModifier: Self.contentModifier(level: level), itemTransformer: itemTransformer)))
                }
                if itemModifierView?.separator != Visibility.hidden {
                    Self.ComposeSeparator(level: level)
                }
            }
        }

        if let background = itemModifierView?.background {
            TargetViewLayout(context: containerContext, isOverlay: false, alignment: Alignment.center, target: composeContainer, dependent: {
                background.Compose(context: $0)
            })
        } else {
            composeContainer(containerContext)
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
    @Composable private func ComposeEditableItem(view: View, level: Int, context: ComposeContext, modifier: Modifier, styling: ListStyling, objectsBinding: Binding<RandomAccessCollection<Any>>? = nil, key: String?, index: Int, editActions: EditActions = [], onDelete: ((IndexSet) -> Void)?, onMove: ((IndexSet, Int) -> Void)?, reorderableState: ReorderableLazyListState) {
        guard !view.isSwiftUIEmptyView else {
            return
        }
        guard let key else {
            ComposeItem(view: view, level: level, context: context, modifier: modifier, styling: styling)
            return
        }
        let editActionsModifiers = EditActionsModifierView.unwrap(view: view)
        let isDeleteEnabled = (editActions.contains(.delete) || onDelete != nil) && editActionsModifiers?.isDeleteDisabled != true
        let isMoveEnabled = (editActions.contains(.move) || onMove != nil) && editActionsModifiers?.isMoveDisabled != true
        guard isDeleteEnabled || isMoveEnabled else {
            ComposeItem(view: view, level: level, context: context, modifier: modifier, styling: styling)
            return
        }

        if isDeleteEnabled {
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

            let content: @Composable (Modifier) -> Void = {
                SwipeToDismissBox(state: dismissState, enableDismissFromEndToStart: true, enableDismissFromStartToEnd: false, modifier: $0, backgroundContent: {
                    let trashVector = Image.composeImageVector(named: "trash")!
                    Box(modifier: Modifier.background(androidx.compose.ui.graphics.Color.Red).fillMaxSize(), contentAlignment: androidx.compose.ui.Alignment.CenterEnd) {
                        Icon(imageVector: trashVector, contentDescription: "Delete", modifier = Modifier.padding(end: 24.dp), tint: androidx.compose.ui.graphics.Color.White)
                    }
                }, content: {
                    ComposeItem(view: view, level: level, context: context, styling: styling)
                })
            }
            if isMoveEnabled {
                ComposeReorderableItem(reorderableState: reorderableState, key: key, modifier: modifier, content: content)
            } else {
                content(modifier)
            }
        } else {
            ComposeReorderableItem(reorderableState: reorderableState, key: key, modifier: modifier) {
                ComposeItem(view: view, level: level, context: context, modifier: $0, styling: styling)
            }
        }
    }

    @Composable private func ComposeReorderableItem(reorderableState: ReorderableLazyListState, key: String, modifier: Modifier, content: @Composable (Modifier) -> Void) {
        ReorderableItem(state: reorderableState, key: key, defaultDraggingModifier: modifier) { dragging in
            var itemModifier = Modifier.detectReorderAfterLongPress(reorderableState)
            if dragging {
                let elevation = animateDpAsState(8.dp)
                itemModifier = itemModifier.shadow(elevation.value)
            }
            content(itemModifier)
        }
    }

    @Composable private func ComposeSectionHeader(view: View, context: ComposeContext, styling: ListStyling, isTop: Bool) {
        if !isTop && styling.style != ListStyle.plain {
            // Vertical padding
            ComposeFooter(styling: styling, safeAreaHeight: 0.dp, hasBottomSection: true)
        }
        let backgroundColor = BackgroundColor(styling: styling, isItem: false)
        let modifier = Modifier
            .zIndex(Float(0.5))
            .background(backgroundColor)
            .then(context.modifier)
        var contentModifier = Modifier.fillMaxWidth()
        if isTop && styling.style != .plain {
            contentModifier = contentModifier.padding(start: Self.horizontalItemInset.dp, top: 0.dp, end: Self.horizontalItemInset.dp, bottom: Self.verticalItemInset.dp)
        } else {
            contentModifier = contentModifier.padding(horizontal: Self.horizontalItemInset.dp, vertical: Self.verticalItemInset.dp)
        }
        Box(modifier: modifier, contentAlignment: androidx.compose.ui.Alignment.BottomCenter) {
            Column(modifier: Modifier.fillMaxWidth()) {
                EnvironmentValues.shared.setValues {
                    $0.set_listSectionHeaderStyle(styling.style)
                } in: {
                    view.Compose(context: context.content(modifier: contentModifier))
                }
            }
            if styling.style != ListStyle.plain {
                ComposeRoundedCorners(isTop: true, fill: backgroundColor)
            }
        }
    }

    @Composable private func ComposeSectionFooter(view: View, context: ComposeContext, styling: ListStyling) {
        if styling.style == .plain {
            ComposeItem(view: view, level: 0, context: context, styling: styling, isItem: false)
        } else {
            let backgroundColor = BackgroundColor(styling: styling, isItem: false)
            let modifier = Modifier.offset(y: -1.dp) // Cover last row's divider
                .zIndex(Float(0.5))
                .background(backgroundColor)
                .then(context.modifier)
            let contentModifier = Modifier.fillMaxWidth().padding(horizontal: Self.horizontalItemInset.dp, vertical: Self.verticalItemInset.dp)
            Box(modifier: modifier, contentAlignment: androidx.compose.ui.Alignment.TopCenter) {
                Column(modifier: Modifier.fillMaxWidth().heightIn(min: 1.dp)) {
                    EnvironmentValues.shared.setValues {
                        $0.set_listSectionFooterStyle(styling.style)
                    } in: {
                        view.Compose(context: context.content(modifier: contentModifier))
                    }
                }
                ComposeRoundedCorners(isTop: false, fill: backgroundColor)
            }
        }
    }

    /// - Warning: Only call for non-.plain styles or with a positive safe area height. This is distinct from having this function detect
    /// .plain and zero-height and return without rendering. That causes .plain style lists to have a weird rubber banding effect on overscroll.
    @Composable private func ComposeHeader(styling: ListStyling, safeAreaHeight: Dp, hasTopSection: Bool) {
        var height = safeAreaHeight
        if styling.style != .plain {
            height += Self.verticalInset.dp
        }
        let backgroundColor = BackgroundColor(styling: styling, isItem: false)
        let modifier = Modifier.fillMaxWidth()
            .height(height)
            .zIndex(Float(0.5))
            .background(backgroundColor)
        Box(modifier: modifier, contentAlignment: androidx.compose.ui.Alignment.BottomCenter) {
            if !hasTopSection && styling.style != .plain {
                ComposeRoundedCorners(isTop: true, fill: backgroundColor)
            }
        }
    }

    /// - Warning: Only call for non-.plain styles or with a positive safe area height. This is distinct from having this function detect
    /// .plain and zero-height and return without rendering. That causes .plain style lists to have a weird rubber banding effect on overscroll.
    @Composable private func ComposeFooter(styling: ListStyling, safeAreaHeight: Dp, hasBottomSection: Bool) {
        var height = safeAreaHeight
        var offset = 0.dp
        if styling.style != .plain {
            height += Self.verticalInset.dp
            offset = -1.dp // Cover last row's divider
        }
        let backgroundColor = BackgroundColor(styling: styling, isItem: false)
        let modifier = Modifier.fillMaxWidth()
            .height(height)
            .offset(y: offset)
            .zIndex(Float(0.5))
            .background(backgroundColor)
        Box(modifier: modifier, contentAlignment: androidx.compose.ui.Alignment.TopCenter) {
            if !hasBottomSection && styling.style != .plain {
                ComposeRoundedCorners(isTop: false, fill: backgroundColor)
            }
        }
    }

    @Composable private func ComposeRoundedCorners(isTop: Bool, fill: androidx.compose.ui.graphics.Color) {
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
        let offset = isTop ? listSectionnCornerRadius.dp : -listSectionnCornerRadius.dp
        let modifier = Modifier
            .fillMaxWidth()
            .height(listSectionnCornerRadius.dp)
            .offset(y: offset)
            .clip(shape)
            .background(fill)
        Box(modifier: modifier)
    }

    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
    @Composable private func ComposeSearchField(state: SearchableState, context: ComposeContext, styling: ListStyling, safeAreaHeight: Dp) {
        var modifier = Modifier.background(BackgroundColor(styling: styling, isItem: false))
        if styling.style == ListStyle.plain {
            modifier = modifier.padding(top: Self.verticalInset.dp + safeAreaHeight, start: Self.horizontalInset.dp, end: Self.horizontalInset.dp, bottom: Self.verticalInset.dp)
        } else {
            modifier = modifier.padding(top: Self.verticalInset.dp + safeAreaHeight)
        }
        modifier = modifier.fillMaxWidth()
        SearchField(state: state, context: context.content(modifier: modifier))
    }

    @Composable private func BackgroundColor(styling: ListStyling, isItem: Bool) -> androidx.compose.ui.graphics.Color {
        if !isItem && styling.backgroundVisibility == Visibility.hidden {
            return Color.clear.colorImpl()
        } else if styling.style == ListStyle.plain {
            return Color.background.colorImpl()
        } else {
            return Color.systemBackground.colorImpl()
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
    let style: ListStyle
    let backgroundVisibility: Visibility

    func withStyle(_ style: ListStyle) -> ListStyling {
        return ListStyling(style: style, backgroundVisibility: backgroundVisibility)
    }
}

/// Adopted by views that adapt when used as a list item.
protocol ListItemAdapting {
    #if SKIP
    /// Whether to compose this view as a list item or to use the standard compose pipeline.
    @Composable func shouldComposeListItem() -> Bool

    /// Compose this view as a list item.
    @Composable func ComposeListItem(context: ComposeContext, contentModifier: Modifier)
    #endif
}

#if SKIP
final class ListItemComposer: RenderingComposer {
    let contentModifier: Modifier
    let itemTransformer: ((View) -> View)?

    init(contentModifier: Modifier, itemTransformer: ((View) -> View)? = nil) {
        self.contentModifier = contentModifier
        self.itemTransformer = itemTransformer
    }

    @Composable override func Compose(view: View, context: (Bool) -> ComposeContext) {
        let view = itemTransformer?(view) ?? view
        if let listItemAdapting = view as? ListItemAdapting, listItemAdapting.shouldComposeListItem() {
            listItemAdapting.ComposeListItem(context: context(false), contentModifier: contentModifier)
        } else if view is ComposeModifierView || view is ComposeBuilder || !view.isSwiftUIModuleView {
            // Allow content of modifier views and custom views to adapt to list item rendering
            var contentContext = context(true)
            // Erase item transformer, as we've already applied it
            contentContext.composer = ListItemComposer(contentModifier: contentModifier)
            view.ComposeContent(context: contentContext)
        } else {
            Box(modifier: contentModifier, contentAlignment: androidx.compose.ui.Alignment.CenterStart) {
                view.ComposeContent(context: context(false))
            }
        }
    }
}
#endif

public struct ListStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = ListStyle(rawValue: 0)

    @available(*, unavailable)
    public static let sidebar = ListStyle(rawValue: 1)

    @available(*, unavailable)
    public static let insetGrouped = ListStyle(rawValue: 2)

    @available(*, unavailable)
    public static let grouped = ListStyle(rawValue: 3)

    @available(*, unavailable)
    public static let inset = ListStyle(rawValue: 4)

    public static let plain = ListStyle(rawValue: 5)
}

public enum ListItemTint : Sendable {
    case fixed(Color)
    case preferred(Color)
    case monochrome
}

public enum ListSectionSpacing : Sendable {
    case `default`
    case compact
    case custom(CGFloat)
}

extension View {
    public func listRowBackground(_ view: Any?) -> some View {
        #if SKIP
        return ListItemModifierView(view: self, background: view as! View?)
        #else
        return self
        #endif
    }
    
    public func listRowSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> some View {
        #if SKIP
        return ListItemModifierView(view: self, separator: visibility)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func listRowSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listSectionSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listSectionSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> some View {
        return self
    }

    public func listStyle(_ style: ListStyle) -> some View {
        #if SKIP
        return environment(\._listStyle, style)
        #else
        return self
        #endif
    }

    public func listItemTint(_ tint: Color?) -> some View {
        #if SKIP
        return environment(\._listItemTint, tint)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func listItemTint(_ tint: ListItemTint?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listRowInsets(_ insets: EdgeInsets?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listRowSpacing(_ spacing: CGFloat?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listSectionSpacing(_ spacing: ListSectionSpacing) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listSectionSpacing(_ spacing: CGFloat) -> some View {
        return self
    }

    @available(*, unavailable)
    public func swipeActions(edge: HorizontalEdge = .trailing, allowsFullSwipe: Bool = true, @ViewBuilder content: () -> any View) -> some View {
        return self
    }
}

#if SKIP
final class ListItemModifierView: ComposeModifierView, ListItemAdapting {
    var background: View?
    var separator: Visibility?

    init(view: View, background: View? = nil, separator: Visibility? = nil) {
        let modifierView = view.strippingModifiers(until: { $0 == .listItem }, perform: { $0 as? ListItemModifierView })
        self.background = background ?? modifierView?.background
        self.separator = separator ?? modifierView?.separator
        super.init(view: view, role: ComposeModifierRole.listItem)
    }

    @Composable func shouldComposeListItem() -> Bool {
        return (view as? ListItemAdapting)?.shouldComposeListItem() == true
    }

    @Composable func ComposeListItem(context: ComposeContext, contentModifier: Modifier) {
        (view as? ListItemAdapting)?.ComposeListItem(context: context, contentModifier: contentModifier)
    }
}
#endif

#if false

// TODO: Process for use in SkipUI

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

#endif
