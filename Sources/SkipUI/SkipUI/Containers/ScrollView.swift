// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.pullrefresh.PullRefreshIndicator
import androidx.compose.material.pullrefresh.PullRefreshState
import androidx.compose.material.pullrefresh.pullRefresh
import androidx.compose.material.pullrefresh.rememberPullRefreshState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
#endif

// SKIP @bridge
public struct ScrollView : View {
    let content: ComposeBuilder
    let axes: Axis.Set

    public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, @ViewBuilder content: () -> any View) {
        // Note: showsIndicator is ignored
        self.axes = axes
        self.content = ComposeBuilder.from(content)
    }

    // SKIP @bridge
    public init(bridgedAxes: Int, showsIndicators: Bool, bridgedContent: any View) {
        // Note: showsIndicator is ignored
        self.axes = Axis.Set(rawValue: bridgedAxes)
        self.content = ComposeBuilder.from { bridgedContent }
    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalMaterialApi::class)
    @Composable public override func ComposeContent(context: ComposeContext) {
        // Some components in Compose have their own scrolling built in
        let builtinScrollAxisSet = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<Axis.Set>, Any>) { mutableStateOf(Preference<Axis.Set>(key: BuiltinScrollAxisSetPreferenceKey.self)) }
        let builtinScrollAxisSetCollector = PreferenceCollector<Axis.Set>(key: BuiltinScrollAxisSetPreferenceKey.self, state: builtinScrollAxisSet)

        let scrollState = rememberScrollState()
        let coroutineScope = rememberCoroutineScope()
        let isVerticalScroll = axes.contains(.vertical) && !builtinScrollAxisSet.value.reduced.contains(Axis.Set.vertical)
        let isHorizontalScroll = axes.contains(.horizontal) && !builtinScrollAxisSet.value.reduced.contains(Axis.Set.horizontal)
        var scrollModifier: Modifier = Modifier
        var effectiveScrollAxes: Axis.Set = []
        if isVerticalScroll {
            scrollModifier = scrollModifier.verticalScroll(scrollState)
            effectiveScrollAxes.insert(Axis.Set.vertical)
            if !axes.contains(.horizontal) {
                // Integrate with our scroll-to-top navigation bar taps
                PreferenceValues.shared.contribute(context: context, key: ScrollToTopPreferenceKey.self, value: ScrollToTopAction(key: scrollState) {
                    coroutineScope.launch {
                        scrollState.animateScrollTo(0)
                    }
                })
            }
        }
        if isHorizontalScroll {
            scrollModifier = scrollModifier.horizontalScroll(scrollState)
            effectiveScrollAxes.insert(Axis.Set.horizontal)
        }
        let contentContext = context.content()
        ComposeContainer(scrollAxes: effectiveScrollAxes, modifier: context.modifier, fillWidth: axes.contains(.horizontal), fillHeight: axes.contains(.vertical)) { modifier in
            IgnoresSafeAreaLayout(expandInto: [], checkEdges: [.bottom], modifier: modifier) { _, safeAreaEdges in
                var containerModifier: Modifier = Modifier
                if isVerticalScroll {
                    containerModifier = containerModifier.fillMaxHeight()
                    if safeAreaEdges.contains(Edge.Set.bottom) {
                        PreferenceValues.shared.contribute(context: context, key: ToolbarPreferenceKey.self, value: ToolbarPreferences(scrollableState: scrollState, for: [ToolbarPlacement.bottomBar]))
                        PreferenceValues.shared.contribute(context: context, key: TabBarPreferenceKey.self, value: ToolbarBarPreferences(scrollableState: scrollState))
                    }
                }
                if isHorizontalScroll {
                    containerModifier = containerModifier.fillMaxWidth()
                }

                let refreshing = remember { mutableStateOf(false) }
                let refreshAction = EnvironmentValues.shared.refresh
                let refreshState: PullRefreshState?
                if let refreshAction {
                    let updatedAction = rememberUpdatedState(refreshAction)
                    refreshState = rememberPullRefreshState(refreshing.value, {
                        coroutineScope.launch {
                            refreshing.value = true
                            updatedAction.value()
                            refreshing.value = false
                        }
                    })
                    containerModifier = containerModifier.pullRefresh(refreshState!)
                } else {
                    refreshState = nil
                }

                Box(modifier: containerModifier) {
                    Column(modifier: scrollModifier) {
                        if isVerticalScroll {
                            let searchableState = EnvironmentValues.shared._searchableState
                            let isSearchable = searchableState?.isModifierOnNavigationStack == false
                            if isSearchable {
                                SearchField(state: searchableState, context: context.content(modifier: Modifier.padding(horizontal: 16.dp, vertical: 8.dp)))
                            }
                        }
                        EnvironmentValues.shared.setValues {
                            $0.set_scrollViewAxes(axes)
                        } in: {
                            PreferenceValues.shared.collectPreferences([builtinScrollAxisSetCollector]) {
                                content.Compose(context: contentContext)
                            }
                        }
                    }
                    if let refreshState {
                        PullRefreshIndicator(refreshing.value, refreshState, Modifier.align(androidx.compose.ui.Alignment.TopCenter))
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

// SKIP @bridge
public struct ScrollViewProxy {
    #if SKIP
    let scrollToID: (Any) -> Void
    #endif

    public func scrollTo(_ id: Any, anchor: UnitPoint? = nil) {
        #if SKIP
        // Warning: anchor is currently ignored
        scrollToID(id)
        #endif
    }

    // SKIP @bridge
    public func scrollTo(bridgedID: Any, anchorX: CGFloat?, anchorY: CGFloat?) {
        let anchor: UnitPoint?
        if let anchorX, let anchorY {
            anchor = UnitPoint(x: anchorX, y: anchorY)
        } else {
            anchor = nil
        }
        scrollTo(bridgedID, anchor: anchor)
    }
}

// SKIP @bridge
public struct ScrollViewReader : View {
    public let content: (ScrollViewProxy) -> any View

    // SKIP @bridge
    public init(@ViewBuilder content: @escaping (ScrollViewProxy) -> any View) {
        self.content = content
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let scrollToID = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<ScrollToIDAction>, Any>) { mutableStateOf(Preference<ScrollToIDAction>(key: ScrollToIDPreferenceKey.self)) }
        let scrollToIDCollector = PreferenceCollector<ScrollToIDAction>(key: ScrollToIDPreferenceKey.self, state: scrollToID)
        let scrollProxy = ScrollViewProxy(scrollToID: scrollToID.value.reduced.action)
        PreferenceValues.shared.collectPreferences([scrollToIDCollector]) {
            content(scrollProxy).Compose(context)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
struct ScrollToTopPreferenceKey: PreferenceKey {
    typealias Value = ScrollToTopAction

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<ScrollToTopAction>
    final class Companion: PreferenceKeyCompanion {
        let defaultValue = ScrollToTopAction(key: nil, action: { })
        func reduce(value: inout ScrollToTopAction, nextValue: () -> ScrollToTopAction) {
            value = nextValue()
        }
    }
}

struct ScrollToTopAction : Equatable {
    // Key the action on the listState/gridState/etc that performs the scrolling, so that on
    // recompose when the remembered state might change, the preference action is updated
    let key: Any?
    let action: () -> Void

    static func ==(lhs: ScrollToTopAction, rhs: ScrollToTopAction) -> Bool {
        return lhs.key == rhs.key
    }
}

struct ScrollToIDPreferenceKey: PreferenceKey {
    typealias Value = ScrollToIDAction

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<ScrollToIDAction>
    final class Companion: PreferenceKeyCompanion {
        let defaultValue = ScrollToIDAction(key: nil, action: { _ in })
        func reduce(value: inout ScrollToIDAction, nextValue: () -> ScrollToIDAction) {
            value = nextValue()
        }
    }
}

struct ScrollToIDAction : Equatable {
    // Key the action on the listState/gridState/etc that performs the scrolling, so that on
    // recompose when the remembered state might change, the preference action is updated
    let key: Any?
    let action: (Any) -> Void

    static func ==(lhs: ScrollToIDAction, rhs: ScrollToIDAction) -> Bool {
        return lhs.key == rhs.key
    }
}

struct BuiltinScrollAxisSetPreferenceKey: PreferenceKey {
    typealias Value = Axis.Set

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<Axis.Set>
    final class Companion: PreferenceKeyCompanion {
        let defaultValue: Axis.Set = []
        func reduce(value: inout Axis.Set, nextValue: () -> Axis.Set) {
            value.formUnion(nextValue())
        }
    }
}
#endif

public enum ScrollBounceBehavior {
    case automatic
    case always
    case basedOnSize
}

public enum ScrollDismissesKeyboardMode {
    case automatic
    case immediately
    case interactively
    case never
}

public enum ScrollIndicatorVisibility : Equatable {
    case automatic
    case visible
    case hidden
    case never
}

public struct ScrollTarget {
    public var rect: CGRect
    public var anchor: UnitPoint?

    public init(rect: CGRect, anchor: UnitPoint? = nil) {
        self.rect = rect
        self.anchor = anchor
    }
}

public struct PinnedScrollableViews : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    @available(*, unavailable)
    public static let sectionHeaders = PinnedScrollableViews(rawValue: 1 << 0) // For bridging
    @available(*, unavailable)
    public static let sectionFooters = PinnedScrollableViews(rawValue: 1 << 1) // For bridging
}

extension View {
    @available(*, unavailable)
    public func contentMargins(_ edges: Edge.Set = .all, _ insets: EdgeInsets, for placement: ContentMarginPlacement = .automatic) -> some View {
        return self
    }

    @available(*, unavailable)
    public func contentMargins(_ edges: Edge.Set = .all, _ length: CGFloat?, for placement: ContentMarginPlacement = .automatic) -> some View {
        return self
    }

    @available(*, unavailable)
    public func contentMargins(_ length: CGFloat, for placement: ContentMarginPlacement = .automatic) -> some View {
        return self
    }

    @available(*, unavailable)
    public func scrollBounceBehavior(_ behavior: ScrollBounceBehavior, axes: Axis.Set = [.vertical]) -> some View {
        return self
    }

    @available(*, unavailable)
    public func scrollClipDisabled(_ disabled: Bool = true) -> some View {
        return self
    }

    public func scrollContentBackground(_ visibility: Visibility) -> any View {
        #if SKIP
        return environment(\._scrollContentBackground, visibility)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func scrollContentBackground(bridgedVisibility: Int) -> any View {
        return scrollContentBackground(Visibility(rawValue: bridgedVisibility) ?? .automatic)
    }

    @available(*, unavailable)
    public func scrollDismissesKeyboard(_ mode: ScrollDismissesKeyboardMode) -> some View {
        return self
    }

    @available(*, unavailable)
    public func scrollDisabled(_ disabled: Bool) -> some View {
        return self
    }

    @available(*, unavailable)
    public func scrollIndicators(_ visibility: ScrollIndicatorVisibility, axes: Axis.Set = [.vertical, .horizontal]) -> some View {
        return self
    }

    @available(*, unavailable)
    public func scrollIndicatorsFlash(onAppear: Bool) -> some View {
        return self
    }

    @available(*, unavailable)
    public func scrollIndicatorsFlash(trigger value: some Equatable) -> some View {
        return self
    }

    @available(*, unavailable)
    public func scrollPosition(id: Binding<(any Hashable)?>) -> some View {
        return self
    }

    @available(*, unavailable)
    public func scrollPosition(initialAnchor: UnitPoint?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func scrollTarget(isEnabled: Bool = true) -> some View {
        return self
    }

    // SKIP @bridge
    public func scrollTargetBehavior(_ behavior: any ScrollTargetBehavior) -> any View {
        #if SKIP
        return environment(\._scrollTargetBehavior, behavior)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func scrollTargetLayout(isEnabled: Bool = true) -> any View {
        // We do not support specifying scroll targets, but we want the natural pattern of using this modifier
        // on the VStack/HStack content of a ScrollView to work without #if SKIP-ing it out
        return self
    }
}

// MARK: ScrollTargetBehavior

// SKIP @bridge
public protocol ScrollTargetBehavior {
}

public struct PagingScrollTargetBehavior: ScrollTargetBehavior {
    @available(*, unavailable)
    public init() {
    }
}

extension ScrollTargetBehavior where Self == PagingScrollTargetBehavior {
    @available(*, unavailable)
    public static var paging: PagingScrollTargetBehavior {
        fatalError()
    }
}

// SKIP @bridge
public struct ViewAlignedScrollTargetBehavior: ScrollTargetBehavior {
    public init(limitBehavior: LimitBehavior = .automatic) {
        // Note: we currently ignore the limit behavior
    }

    // SKIP @bridge
    public init(bridgedLimitBehavior: Int) {
        // Note: we currently ignore the limit behavior
    }

    public enum LimitBehavior : Int {
        case automatic = 0 // For bridging
        case always = 1 // For bridging
        case never = 2 // For bridging
        case alwaysByFew = 3 // For bridging
        case alwaysByOne = 4 // For bridging
    }
}

extension ScrollTargetBehavior where Self == ViewAlignedScrollTargetBehavior {
    public static var viewAligned: ViewAlignedScrollTargetBehavior {
        return ViewAlignedScrollTargetBehavior()
    }

    public static func viewAligned(limitBehavior: ViewAlignedScrollTargetBehavior.LimitBehavior) -> ViewAlignedScrollTargetBehavior {
        return ViewAlignedScrollTargetBehavior(limitBehavior: limitBehavior)
    }
}

#if false
import struct CoreGraphics.CGSize
import struct CoreGraphics.CGVector

// TODO: Process for use in SkipUI

/// The context in which a scroll target behavior updates its scroll target.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@dynamicMemberLookup public struct ScrollTargetBehaviorContext {

    /// The original target when the scroll gesture began.
    public var originalTarget: ScrollTarget { get { fatalError() } }

    /// The current velocity of the scrollable view's scroll gesture.
    public var velocity: CGVector { get { fatalError() } }

    /// The size of the content of the scrollable view.
    public var contentSize: CGSize { get { fatalError() } }

    /// The size of the container of the scrollable view.
    ///
    /// This is the size of the bounds of the scroll view subtracting any
    /// insets applied to the scroll view (like the safe area).
    public var containerSize: CGSize { get { fatalError() } }

    /// The axes in which the scrollable view is scrollable.
    public var axes: Axis.Set { get { fatalError() } }

    public subscript<T>(dynamicMember keyPath: KeyPath<EnvironmentValues, T>) -> T { get { fatalError() } }
}

/// The configuration of a scroll transition that controls how a transition
/// is applied as a view is scrolled through the visible region of a containing
/// scroll view or other container.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ScrollTransitionConfiguration {

    /// Creates a new configuration that discretely animates the transition
    /// when the view becomes visible.
    ///
    /// Unlike the interactive configuration, the transition isn't
    /// interpolated as the scroll view is scrolled. Instead, the transition
    /// phase only changes once the threshold has been reached, at which
    /// time the given animation is used to animate to the new phase.
    ///
    /// - Parameters:
    ///   - animation: The animation to use when transitioning between states.
    ///
    /// - Returns: A configuration that discretely animates between
    ///   transition phases.
    public static func animated(_ animation: Animation = .default) -> ScrollTransitionConfiguration { fatalError() }

    /// Creates a new configuration that discretely animates the transition
    /// when the view becomes visible.
    public static let animated: ScrollTransitionConfiguration = { fatalError() }()

    /// Creates a new configuration that interactively interpolates the
    /// transition's effect as the view is scrolled into the visible region
    /// of the container.
    ///
    /// - Parameters:
    ///   - timingCurve: The curve that adjusts the pace at which the effect
    ///     is interpolated between phases of the transition. For example, an
    ///     `.easeIn` curve causes interpolation to begin slowly as the view
    ///     reaches the edge of the scroll view, then speed up as it reaches
    ///     the visible threshold. The curve is applied 'forward' while the
    ///     view is appearing, meaning that time zero corresponds to the
    ///     view being just hidden, and time 1.0 corresponds to the pont at
    ///     which the view reaches the configuration threshold. This also means
    ///     that the timing curve is applied in reversed while the view
    ///     is moving away from the center of the scroll view.
    ///
    /// - Returns: A configuration that interactively interpolates between
    ///   transition phases based on the current scroll position.
    public static func interactive(timingCurve: UnitCurve = .easeInOut) -> ScrollTransitionConfiguration { fatalError() }

    /// Creates a new configuration that interactively interpolates the
    /// transition's effect as the view is scrolled into the visible region
    /// of the container.
    public static let interactive: ScrollTransitionConfiguration = { fatalError() }()

    /// Creates a new configuration that does not change the appearance of the view.
    public static let identity: ScrollTransitionConfiguration = { fatalError() }()

    /// Sets the animation with which the transition will be applied.
    ///
    /// If the transition is interactive, the given animation will be used
    /// to animate the effect toward the current interpolated value, causing
    /// the effect to lag behind the current scroll position.
    ///
    /// - Parameter animation: An animation that will be used to apply the
    ///   transition to the view.
    ///
    /// - Returns: A copy of this configuration with the animation set to the
    ///   given value.
    public func animation(_ animation: Animation) -> ScrollTransitionConfiguration { fatalError() }

    /// Sets the threshold at which the view will be considered fully visible.
    ///
    /// - Parameters:
    ///   - threshold: The threshold specifying how much of the view must
    ///     intersect with the container before it is treated as visible.
    ///
    /// - Returns: A copy of this configuration with the threshold set to the
    ///   given value.
    public func threshold(_ threshold: ScrollTransitionConfiguration.Threshold) -> ScrollTransitionConfiguration { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScrollTransitionConfiguration {

    /// Describes a specific point in the progression of a target view within a container
    /// from hidden (fully outside the container) to visible.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public struct Threshold {

        public static let visible: ScrollTransitionConfiguration.Threshold = { fatalError() }()

        public static let hidden: ScrollTransitionConfiguration.Threshold = { fatalError() }()

        /// The target view is centered within the container
        public static var centered: ScrollTransitionConfiguration.Threshold { get { fatalError() } }

        /// The target view is visible by the given amount, where zero is fully
        /// hidden, and one is fully visible.
        ///
        /// Values less than zero or greater than one are clamped.
        public static func visible(_ amount: Double) -> ScrollTransitionConfiguration.Threshold { fatalError() }

        /// Creates a new threshold that combines this threshold value with
        /// another threshold, interpolated by the given amount.
        ///
        /// - Parameters:
        ///   - other: The second threshold value.
        ///   - amount: The ratio with which this threshold is combined with
        ///     the given threshold, where zero is equal to this threshold,
        ///     1.0 is equal to `other`, and values in between combine the two
        ///     thresholds.
        public func interpolated(towards other: ScrollTransitionConfiguration.Threshold, amount: Double) -> ScrollTransitionConfiguration.Threshold { fatalError() }

        /// Returns a threshold that is met when the target view is closer to the
        /// center of the container by `distance`. Use negative values to move
        /// the threshold away from the center.
        public func inset(by distance: Double) -> ScrollTransitionConfiguration.Threshold { fatalError() }
    }
}

/// The phases that a view transitions between when it scrolls among other views.
///
/// When a view with a scroll transition modifier applied is approaching
/// the visible region of the containing scroll view or other container,
/// the effect  will first be applied with the `topLeading` or `bottomTrailing`
/// phase (depending on which edge the view is approaching), then will be
/// moved to the `identity` phase as the view moves into the visible area. The
/// timing and behavior that determines when a view is visible within the
/// container is controlled by the configuration that is provided to the
/// `scrollTransition` modifier.
///
/// In the `identity` phase, scroll transitions should generally not make any
/// visual change to the view they are applied to, since the transition's view
/// modifications in the `identity` phase will be applied to the view as long
/// as it is visible. In the `topLeading` and `bottomTrailing` phases,
/// transitions should apply a change that will be animated to create the
/// transition.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@frozen public enum ScrollTransitionPhase {

    /// The scroll transition is being applied to a view that is about to
    /// move into the visible area at the top edge of a vertical scroll view,
    /// or the leading edge of a horizont scroll view.
    case topLeading

    /// The scroll transition is being applied to a view that is in the
    /// visible area.
    ///
    /// In this phase, a transition should show its steady state appearance,
    /// which will generally not make any visual change to the view.
    case identity

    /// The scroll transition is being applied to a view that is about to
    /// move into the visible area at the bottom edge of a vertical scroll
    /// view, or the trailing edge of a horizontal scroll view.
    case bottomTrailing

    public var isIdentity: Bool { get { fatalError() } }

    /// A phase-derived value that can be used to scale or otherwise modify
    /// effects.
    ///
    /// Returns -1.0 when in the topLeading phase, zero when in the identity
    /// phase, and 1.0 when in the bottomTrailing phase.
    public var value: Double { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScrollTransitionPhase : Equatable {
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScrollTransitionPhase : Hashable {
}

/// The scroll behavior that aligns scroll targets to container-based geometry.
///
/// In the following example, every view in the lazy stack is flexible
/// in both directions and the scroll view settles to container-aligned
/// boundaries.
///
///     ScrollView {
///         LazyVStack(spacing: 0.0) {
///             ForEach(items) { item in
///                 FullScreenItem(item)
///             }
///         }
///     }
///     .scrollTargetBehavior(.paging)
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct PagingScrollTargetBehavior : ScrollTargetBehavior {

    /// Creates a paging scroll behavior.
    public init() { fatalError() }

    /// Updates the proposed target that a scrollable view should scroll to.
    ///
    /// The system calls this method in two main cases:
    /// - When a scroll gesture ends, it calculates where it would naturally
    ///   scroll to using its deceleration rate. The system
    ///   provides this calculated value as the target of this method.
    /// - When a scrollable view's size changes, it calculates where it should
    ///   be scrolled given the new size and provides this calculates value
    ///   as the target of this method.
    ///
    /// You can implement this method to override the calculated target
    /// which will have the scrollable view scroll to a different position
    /// than it would otherwise.
    public func updateTarget(_ target: inout ScrollTarget, context: PagingScrollTargetBehavior.TargetContext) { fatalError() }
}

#endif
#endif
