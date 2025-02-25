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

public struct LazyHStack : View {
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = [], @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
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

        // Collect all top-level views to compose. The LazyRow itself is not a composable context, so we have to execute
        // our content's Compose function to collect its views before entering the LazyRow body, then use LazyRow's
        // LazyListScope functions to compose individual items
        let collectingComposer = LazyItemCollectingComposer()
        let viewsCollector = context.content(composer: collectingComposer)
        content.Compose(context: viewsCollector)

        let itemContext = context.content()
        let factoryContext = remember { mutableStateOf(LazyItemFactoryContext()) }
        ComposeContainer(axis: .horizontal, scrollAxes: scrollAxes, modifier: context.modifier, fillWidth: true, fillHeight: false) { modifier in
            // Integrate with ScrollViewReader
            let listState = rememberLazyListState()
            let flingBehavior = scrollTargetBehavior is ViewAlignedScrollTargetBehavior ? rememberSnapFlingBehavior(listState, SnapPosition.Start) : ScrollableDefaults.flingBehavior()
            let coroutineScope = rememberCoroutineScope()
            let scrollToID: (Any) -> Void = { id in
                if let itemIndex = factoryContext.value.index(for: id) {
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
            } in: {
                LazyRow(state: listState, modifier: modifier, horizontalArrangement: rowArrangement, verticalAlignment: rowAlignment, contentPadding: EnvironmentValues.shared._contentPadding.asPaddingValues(), userScrollEnabled: isScrollEnabled, flingBehavior: flingBehavior) {
                    factoryContext.value.initialize(
                        startItemIndex: 0,
                        item: { view, _ in
                            item {
                                view.Compose(context: itemContext)
                            }
                        },
                        indexedItems: { range, identifier, _, _, _, _, factory in
                            let count = range.endExclusive - range.start
                            let key: ((Int) -> String)? = identifier == nil ? nil : { composeBundleString(for: identifier!($0)) }
                            items(count: count, key: key) { index in
                                factory(index + range.start).Compose(context: itemContext)
                            }
                        },
                        objectItems: { objects, identifier, _, _, _, _, factory in
                            let key: (Int) -> String = { composeBundleString(for: identifier(objects[$0])) }
                            items(count: objects.count, key: key) { index in
                                factory(objects[index]).Compose(context: itemContext)
                            }
                        },
                        objectBindingItems: { objectsBinding, identifier, _, _, _, _, _, factory in
                            let key: (Int) -> String = { composeBundleString(for: identifier(objectsBinding.wrappedValue[$0])) }
                            items(count: objectsBinding.wrappedValue.count, key: key) { index in
                                factory(objectsBinding, index).Compose(context: itemContext)
                            }
                        },
                        sectionHeader: { view in
                            item {
                                view.Compose(context: itemContext)
                            }
                        },
                        sectionFooter: { view in
                            item {
                                view.Compose(context: itemContext)
                            }
                        }
                    )
                    for (view, level) in collectingComposer.views {
                        if let factory = view as? LazyItemFactory {
                            factory.composeLazyItems(context: factoryContext.value, level: level)
                        } else {
                            factoryContext.value.item(view, level)
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
