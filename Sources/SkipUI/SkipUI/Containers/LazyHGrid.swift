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
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyHorizontalGrid
import androidx.compose.foundation.lazy.grid.rememberLazyGridState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

// SKIP @bridge
public struct LazyHGrid: View, Renderable {
    let rows: [GridItem]
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(rows: [GridItem], alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = [], @ViewBuilder content: () -> any View) {
        self.rows = rows
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    // SKIP @bridge
    public init(rows: [GridItem], alignmentKey: String, spacing: CGFloat?, bridgedPinnedViews: Int, bridgedContent: any View) {
        self.rows = rows
        self.alignment = VerticalAlignment(key: alignmentKey)
        self.spacing = spacing
        self.content = ComposeBuilder.from { bridgedContent }
        // Note: `bridgedPinnedViews` is ignored
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        // Let any parent scroll view know about our builtin scrolling. If there is a parent scroll
        // view that didn't already know, abort and wait for recompose to avoid fatal nested scroll error
        PreferenceValues.shared.contribute(context: context, key: BuiltinScrollAxisSetPreferenceKey.self, value: Axis.Set.horizontal)
        guard !EnvironmentValues.shared._scrollAxes.contains(Axis.Set.horizontal) else {
            return
        }

        let (gridCells, cellAlignment, verticalSpacing) = GridItem.asGridCells(items: rows)
        let boxAlignment = cellAlignment?.asComposeAlignment() ?? androidx.compose.ui.Alignment.Center
        let verticalArrangement = Arrangement.spacedBy((verticalSpacing ?? 8.0).dp, alignment: alignment.asComposeAlignment())
        let horizontalArrangement = Arrangement.spacedBy((spacing ?? 8.0).dp)
        let isScrollEnabled = EnvironmentValues.shared._scrollViewAxes.contains(.horizontal)
        let scrollAxes: Axis.Set = isScrollEnabled ? Axis.Set.horizontal : []
        let scrollTargetBehavior = EnvironmentValues.shared._scrollTargetBehavior

        let renderables = content.EvaluateLazyItems(level: 0, context: context)
        let itemCollector = remember { mutableStateOf(LazyItemCollector()) }
        ComposeContainer(axis: .horizontal, scrollAxes: scrollAxes, modifier: context.modifier, fillWidth: true) { modifier in
            // Integrate with our scroll-to-top and ScrollViewReader
            let gridState = rememberLazyGridState()
            let flingBehavior = scrollTargetBehavior is ViewAlignedScrollTargetBehavior ? rememberSnapFlingBehavior(gridState, SnapPosition.Start) : ScrollableDefaults.flingBehavior()
            let coroutineScope = rememberCoroutineScope()
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

            EnvironmentValues.shared.setValues {
                $0.set_scrollTargetBehavior(nil)
                return ComposeResult.ok
            } in: {
                let contentPadding = EnvironmentValues.shared._contentPadding
                EnvironmentValues.shared.setValues {
                    $0.set_contentPadding(EdgeInsets())
                    return ComposeResult.ok
                } in: {
                LazyHorizontalGrid(state: gridState, modifier: modifier, rows: gridCells, horizontalArrangement: horizontalArrangement, verticalArrangement: verticalArrangement, contentPadding: contentPadding.asPaddingValues(), userScrollEnabled: isScrollEnabled, flingBehavior: flingBehavior) {
                    itemCollector.value.initialize(
                        startItemIndex: 0,
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
                                let scopedContext = context.content(scope: self)
                                Box(contentAlignment: boxAlignment) {
                                    factory(objects[index], scopedContext).Render(context: scopedContext)
                                }
                            }
                        },
                        objectBindingItems: { objectsBinding, identifier, _, _, _, _, _, factory in
                            let key: (Int) -> String = { composeBundleString(for: identifier(objectsBinding.wrappedValue[$0])) }
                            items(count: objectsBinding.wrappedValue.count, key: key) { index in
                                let scopedContext = context.content(scope: self)
                                Box(contentAlignment: boxAlignment) {
                                    factory(objectsBinding, index, scopedContext).Render(context: scopedContext)
                                }
                            }
                        },
                        sectionHeader: { content in
                            for renderable in content {
                                item(span: { GridItemSpan(maxLineSpan) }) {
                                    Box(contentAlignment: androidx.compose.ui.Alignment.Center) {
                                        renderable.Render(context: context.content(scope: self))
                                    }
                                }
                            }
                        },
                        sectionFooter: { content in
                            for renderable in content {
                                item(span: { GridItemSpan(maxLineSpan) }) {
                                    Box(contentAlignment: androidx.compose.ui.Alignment.Center) {
                                        renderable.Render(context: context.content(scope: self))
                                    }
                                }
                            }
                        }
                    )
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
