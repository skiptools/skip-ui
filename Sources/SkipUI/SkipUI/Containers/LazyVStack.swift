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
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

// SKIP @bridge
public struct LazyVStack : View, Renderable {
    let alignment: HorizontalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = [], @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    // SKIP @bridge
    public init(alignmentKey: String, spacing: CGFloat?, bridgedPinnedViews: Int, bridgedContent: any View) {
        self.alignment = HorizontalAlignment(key: alignmentKey)
        self.spacing = spacing
        self.content = ComposeBuilder.from { bridgedContent }
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        // Let any parent scroll view know about our builtin scrolling. If there is a parent scroll
        // view that didn't already know, abort and wait for recompose to avoid fatal nested scroll error
        PreferenceValues.shared.contribute(context: context, key: BuiltinScrollAxisSetPreferenceKey.self, value: Axis.Set.vertical)
        guard !EnvironmentValues.shared._scrollAxes.contains(Axis.Set.vertical) else {
            return
        }

        let columnAlignment = alignment.asComposeAlignment()
        let columnArrangement = Arrangement.spacedBy((spacing ?? 8.0).dp, alignment: androidx.compose.ui.Alignment.CenterVertically)
        let isScrollEnabled = EnvironmentValues.shared._scrollViewAxes.contains(.vertical)
        let scrollAxes: Axis.Set = isScrollEnabled ? Axis.Set.vertical : []
        let scrollTargetBehavior = EnvironmentValues.shared._scrollTargetBehavior

        let searchableState = EnvironmentValues.shared._searchableState
        let isSearchable = searchableState?.isOnNavigationStack == false

        let renderables = content.EvaluateLazyItems(context: context)
        let itemContext = context.content()
        let itemCollector = remember { mutableStateOf(LazyItemCollector()) }
        ComposeContainer(axis: .vertical, scrollAxes: scrollAxes, modifier: context.modifier, fillWidth: true, fillHeight: false) { modifier in
            IgnoresSafeAreaLayout(expandInto: [], checkEdges: [.bottom], modifier: modifier) { _, safeAreaEdges in
                // Integrate with our scroll-to-top and ScrollViewReader
                let listState = rememberLazyListState(initialFirstVisibleItemIndex = isSearchable ? 1 : 0)
                let flingBehavior = scrollTargetBehavior is ViewAlignedScrollTargetBehavior ? rememberSnapFlingBehavior(listState, SnapPosition.Start) : ScrollableDefaults.flingBehavior()
                let coroutineScope = rememberCoroutineScope()
                PreferenceValues.shared.contribute(context: context, key: ScrollToTopPreferenceKey.self, value: ScrollToTopAction(key: listState) {
                    coroutineScope.launch {
                        listState.animateScrollToItem(0)
                    }
                })
                let scrollToID = ScrollToIDAction(key: listState) { id in
                    if let itemIndex = itemCollector.value.index(for: id) {
                        coroutineScope.launch {
                            if Animation.isInWithAnimation {
                                listState.animateScrollToItem(itemIndex)
                            } else {
                                listState.scrollToItem(itemIndex)
                            }
                        }
                    }
                }
                PreferenceValues.shared.contribute(context: context, key: ScrollToIDPreferenceKey.self, value: scrollToID)
                if safeAreaEdges.contains(Edge.Set.bottom) {
                    PreferenceValues.shared.contribute(context: context, key: ToolbarPreferenceKey.self, value: ToolbarPreferences(scrollableState: listState, for: [ToolbarPlacement.bottomBar]))
                    PreferenceValues.shared.contribute(context: context, key: TabBarPreferenceKey.self, value: ToolbarBarPreferences(scrollableState: listState))
                }

                EnvironmentValues.shared.setValues {
                    $0.set_scrollTargetBehavior(nil)
                    return ComposeResult.ok
                } in: {
                    LazyColumn(state: listState, modifier: Modifier.fillMaxWidth(), verticalArrangement: columnArrangement, horizontalAlignment: columnAlignment, contentPadding: EnvironmentValues.shared._contentPadding.asPaddingValues(), userScrollEnabled: isScrollEnabled, flingBehavior: flingBehavior) {
                        itemCollector.value.initialize(
                            startItemIndex: isSearchable ? 1 : 0,
                            item: { renderable, _ in
                                item {
                                    renderable.Render(context: itemContext)
                                }
                            },
                            indexedItems: { range, identifier, _, _, _, _, factory in
                                let count = range.endExclusive - range.start
                                let key: ((Int) -> String)? = identifier == nil ? nil : { composeBundleString(for: identifier!($0 + range.start)) }
                                items(count: count, key: key) { index in
                                    factory(index + range.start, itemContext).Render(context: itemContext)
                                }
                            },
                            objectItems: { objects, identifier, _, _, _, _, factory in
                                let key: (Int) -> String = { composeBundleString(for: identifier(objects[$0])) }
                                items(count: objects.count, key: key) { index in
                                    factory(objects[index], itemContext).Render(context: itemContext)
                                }
                            },
                            objectBindingItems: { objectsBinding, identifier, _, _, _, _, _, factory in
                                let key: (Int) -> String = { composeBundleString(for: identifier(objectsBinding.wrappedValue[$0])) }
                                items(count: objectsBinding.wrappedValue.count, key: key) { index in
                                    factory(objectsBinding, index, itemContext).Render(context: itemContext)
                                }
                            },
                            sectionHeader: { renderable in
                                item {
                                    renderable.Render(context: itemContext)
                                }
                            },
                            sectionFooter: { renderable in
                                item {
                                    renderable.Render(context: itemContext)
                                }
                            }
                        )
                        if isSearchable {
                            item {
                                let modifier = Modifier.padding(16.dp).fillMaxWidth()
                                SearchField(state: searchableState!, context: context.content(modifier: modifier))
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

#endif
