// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.gestures.FlingBehavior
import androidx.compose.foundation.gestures.ScrollableDefaults
import androidx.compose.foundation.gestures.snapping.SnapPosition
import androidx.compose.foundation.gestures.snapping.rememberSnapFlingBehavior
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.rememberLazyGridState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.layout.layout
import kotlinx.coroutines.launch
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

// SKIP @bridge
public struct LazyVGrid: View, Renderable {
    let columns: [GridItem]
    let alignment: HorizontalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(columns: [GridItem], alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = [], @ViewBuilder content: () -> any View) {
        self.columns = columns
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    // SKIP @bridge
    public init(columns: [GridItem], alignmentKey: String, spacing: CGFloat?, bridgedPinnedViews: Int, bridgedContent: any View) {
        self.columns = columns
        self.alignment = HorizontalAlignment(key: alignmentKey)
        self.spacing = spacing
        self.content = ComposeBuilder.from { bridgedContent }
        // Note: `bridgedPinnedViews` is ignored
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        // Let any parent scroll view know about our builtin scrolling. If there is a parent scroll
        // view that didn't already know, abort and wait for recompose to avoid fatal nested scroll error
        PreferenceValues.shared.contribute(context: context, key: BuiltinScrollAxisSetPreferenceKey.self, value: Axis.Set.vertical)
        guard !EnvironmentValues.shared._scrollAxes.contains(Axis.Set.vertical) else {
            return
        }

        let (gridCells, cellAlignment, horizontalSpacing) = GridItem.asGridCells(items: columns)
        let boxAlignment = cellAlignment?.asComposeAlignment() ?? androidx.compose.ui.Alignment.Center
        let horizontalArrangement = Arrangement.spacedBy((horizontalSpacing ?? 8.0).dp, alignment: alignment.asComposeAlignment())
        let verticalArrangement = Arrangement.spacedBy((spacing ?? 8.0).dp)
        let isScrollEnabled = EnvironmentValues.shared._scrollViewAxes.contains(.vertical)
        let scrollAxes: Axis.Set = isScrollEnabled ? Axis.Set.vertical : []
        let scrollTargetBehavior = EnvironmentValues.shared._scrollTargetBehavior

        let searchableState = EnvironmentValues.shared._searchableState
        let isSearchable = searchableState?.isOnNavigationStack == false

        let renderables = content.EvaluateLazyItems(level: 0, context: context)
        let itemCollector = remember { mutableStateOf(LazyItemCollector()) }
        ComposeContainer(axis: .vertical, scrollAxes: scrollAxes, modifier: context.modifier, fillWidth: true) { modifier in
            IgnoresSafeAreaLayout(expandInto: [], checkEdges: [.bottom], modifier: modifier) { _, safeAreaEdges in
                // Integrate with our scroll-to-top and ScrollViewReader
                let gridState = rememberLazyGridState(initialFirstVisibleItemIndex = isSearchable ? 1 : 0)
                let flingBehavior = scrollTargetBehavior is ViewAlignedScrollTargetBehavior ? rememberSnapFlingBehavior(gridState, SnapPosition.Start) : ScrollableDefaults.flingBehavior()
                let coroutineScope = rememberCoroutineScope()
                PreferenceValues.shared.contribute(context: context, key: ScrollToTopPreferenceKey.self, value: ScrollToTopAction(key: gridState) {
                    coroutineScope.launch {
                        gridState.animateScrollToItem(0)
                    }
                })
                let scrollToID = ScrollToIDAction(key: gridState) { id in
                    if let itemIndex = itemCollector.value.index(for: id) {
                        coroutineScope.launch {
                            if Animation.isInWithAnimation {
                                gridState.animateScrollToItem(itemIndex)
                            } else {
                                gridState.scrollToItem(itemIndex)
                            }
                        }
                    }
                }
                PreferenceValues.shared.contribute(context: context, key: ScrollToIDPreferenceKey.self, value: scrollToID)
                if safeAreaEdges.contains(Edge.Set.bottom) {
                    PreferenceValues.shared.contribute(context: context, key: ToolbarPreferenceKey.self, value: ToolbarPreferences(scrollableState: gridState, for: [ToolbarPlacement.bottomBar]))
                    PreferenceValues.shared.contribute(context: context, key: TabBarPreferenceKey.self, value: ToolbarBarPreferences(scrollableState: gridState))
                }

                EnvironmentValues.shared.setValues {
                    $0.set_scrollTargetBehavior(nil)
                    return ComposeResult.ok
                } in: {
                    let contentPadding = EnvironmentValues.shared._contentPadding.asPaddingValues()
                    LazyVerticalGrid(state: gridState, modifier: Modifier.fillMaxWidth(), columns: gridCells, horizontalArrangement: horizontalArrangement, verticalArrangement: verticalArrangement, contentPadding: contentPadding, userScrollEnabled: isScrollEnabled, flingBehavior: flingBehavior) {
                        itemCollector.value.initialize(
                            startItemIndex: isSearchable ? 1 : 0,
                            item: { renderable, _ in
                                item {
                                    Box(contentAlignment: boxAlignment) {
                                        renderable.Render(context: context.content(scope: self))
                                    }
                                }
                            },
                            indexedItems: { range, identifier, _, _, _, _, factory in
                                let count = range.endExclusive - range.start
                                let key: ((Int) -> String)? = identifier == nil ? nil : { composeBundleString(for: identifier!($0 + range.start)) }
                                items(count: count, key: key) { index in
                                    Box(contentAlignment: boxAlignment) {
                                        let scopedContext = context.content(scope: self)
                                        factory(index + range.start, scopedContext).Render(context: scopedContext)
                                    }
                                }
                            },
                            objectItems: { objects, identifier, _, _, _, _, factory in
                                let key: (Int) -> String = { composeBundleString(for: identifier(objects[$0])) }
                                items(count: objects.count, key: key) { index in
                                    Box(contentAlignment: boxAlignment) {
                                        let scopedContext = context.content(scope: self)
                                        factory(objects[index], scopedContext).Render(context: scopedContext)
                                    }
                                }
                            },
                            objectBindingItems: { objectsBinding, identifier, _, _, _, _, _, factory in
                                let key: (Int) -> String = { composeBundleString(for: identifier(objectsBinding.wrappedValue[$0])) }
                                items(count: objectsBinding.wrappedValue.count, key: key) { index in
                                    Box(contentAlignment: boxAlignment) {
                                        let scopedContext = context.content(scope: self)
                                        factory(objectsBinding, index, scopedContext).Render(context: scopedContext)
                                    }
                                }
                            },
                            sectionHeader: { renderable in
                                item(span: { GridItemSpan(maxLineSpan) }) {
                                    Box(contentAlignment: androidx.compose.ui.Alignment.Center) {
                                        renderable.Render(context: context.content(scope: self))
                                    }
                                }
                            },
                            sectionFooter: { renderable in
                                item(span: { GridItemSpan(maxLineSpan) }) {
                                    Box(contentAlignment: androidx.compose.ui.Alignment.Center) {
                                        renderable.Render(context: context.content(scope: self))
                                    }
                                }
                            }
                        )
                        if isSearchable {
                            item(span: { GridItemSpan(maxLineSpan) }) {
                                let modifier = Modifier
                                    .ignoreHorizontalContentPadding(
                                        start: contentPadding.asEdgeInsets().leading.dp,
                                        end: contentPadding.asEdgeInsets().trailing.dp
                                    )
                                    .padding(start: 16.dp, end: 16.dp, top: 16.dp, bottom: 8.dp)
                                    .fillMaxWidth()
                                SearchField(state: searchableState!, context: context.content(modifier: modifier, scope: self))
                            }
                        }
                        for renderable in renderables {
                            if let factory = renderable as? LazyItemFactory, factory.shouldProduceLazyItems() {
                                factory.produceLazyItems(collector: itemCollector.value, modifiers: listOf(), level: 0)
                            } else {
                                itemCollector.value.item(renderable, 0)
                            }
                        }
                    }
                }
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
private extension Modifier {
    func ignoreHorizontalContentPadding(start leadingPadding: Dp, end trailingPadding: Dp) -> Modifier {
        self.layout { measurable, constraints in
            let overriddenWidth = constraints.maxWidth + leadingPadding.roundToPx() + trailingPadding.roundToPx()
            let placeable = measurable.measure(constraints.copy(maxWidth: overriddenWidth))
            return layout(width: placeable.width, height: placeable.height) {
                placeable.place(x: 0, y: 0)
            }
        }
    }
}
#endif
#endif
