// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.gestures.FlingBehavior
import androidx.compose.foundation.gestures.ScrollableDefaults
import androidx.compose.foundation.gestures.snapping.SnapPosition
import androidx.compose.foundation.gestures.snapping.rememberSnapFlingBehavior
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.rememberLazyListState
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
public struct LazyHStack : View, Renderable {
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = [], @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    // SKIP @bridge
    public init(alignmentKey: String, spacing: CGFloat?, bridgedPinnedViews: Int, bridgedContent: any View) {
        self.alignment = VerticalAlignment(key: alignmentKey)
        self.spacing = spacing
        self.content = ComposeBuilder.from { bridgedContent }
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        // Let any parent scroll view know about our builtin scrolling. If there is a parent scroll
        // view that didn't already know, abort and wait for recompose to avoid fatal nested scroll error
        PreferenceValues.shared.contribute(context: context, key: BuiltinScrollAxisSetPreferenceKey.self, value: Axis.Set.horizontal)
        guard !EnvironmentValues.shared._scrollAxes.contains(Axis.Set.horizontal) else {
            return
        }

        let rowAlignment = alignment.asComposeAlignment()
        let rowArrangement = Arrangement.spacedBy((spacing ?? 8.0).dp, alignment: androidx.compose.ui.Alignment.CenterHorizontally)
        let isScrollEnabled = EnvironmentValues.shared._scrollViewAxes.contains(.horizontal)
        let scrollAxes: Axis.Set = isScrollEnabled ? Axis.Set.horizontal : []
        let scrollTargetBehavior = EnvironmentValues.shared._scrollTargetBehavior

        let renderables = content.EvaluateLazyItems(context: context)
        let itemContext = context.content()
        let itemCollector = remember { mutableStateOf(LazyItemCollector()) }
        ComposeContainer(axis: .horizontal, scrollAxes: scrollAxes, modifier: context.modifier, fillWidth: true, fillHeight: false) { modifier in
            // Integrate with ScrollViewReader
            let listState = rememberLazyListState()
            let flingBehavior = scrollTargetBehavior is ViewAlignedScrollTargetBehavior ? rememberSnapFlingBehavior(listState, SnapPosition.Start) : ScrollableDefaults.flingBehavior()
            let coroutineScope = rememberCoroutineScope()
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

            EnvironmentValues.shared.setValues {
                $0.set_scrollTargetBehavior(nil)
                return ComposeResult.ok
            } in: {
                LazyRow(state: listState, modifier: modifier, horizontalArrangement: rowArrangement, verticalAlignment: rowAlignment, contentPadding: EnvironmentValues.shared._contentPadding.asPaddingValues(), userScrollEnabled: isScrollEnabled, flingBehavior: flingBehavior) {
                    itemCollector.value.initialize(
                        startItemIndex: 0,
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
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
