// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.layout.Box
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import kotlinx.coroutines.launch
#else
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
#endif

public struct ScrollView : View {
    let content: ComposeBuilder
    let axes: Axis.Set

    public init(_ axes: Axis.Set = .vertical, @ViewBuilder content: () -> any View) {
        self.axes = axes
        self.content = ComposeBuilder.from(content)
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        // Some components in Compose have their own scrolling built in, so we'll look for them
        // below before adding our scrolling modifiers
        let firstView = content.collectViews(context: context).first?.strippingModifiers { $0 }

        let scrollState = rememberScrollState()
        let coroutineScope = rememberCoroutineScope()
        var scrollModifier: Modifier = Modifier
        if axes.contains(.vertical) && !(firstView is LazyVStack) && !(firstView is LazyVGrid) {
            scrollModifier = scrollModifier.verticalScroll(scrollState)
            if !axes.contains(.horizontal) {
                // Integrate with our scroll-to-top navigation bar taps
                PreferenceValues.shared.reducePreference(key: ScrollToTopPreferenceKey.self, value: {
                    coroutineScope.launch {
                        scrollState.animateScrollTo(0)
                    }
                })
            }
        }
        if axes.contains(.horizontal) && !(firstView is LazyHStack) && !(firstView is LazyHGrid) {
            scrollModifier = scrollModifier.horizontalScroll(scrollState)
        }
        let contentContext = context.content()
        ComposeContainer(scrollAxes: axes, modifier: context.modifier, fillWidth: axes.contains(.horizontal), fillHeight: axes.contains(.vertical), then: scrollModifier) { modifier in
            Box(modifier: modifier) {
                content.Compose(context: contentContext)
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
struct ScrollToTopPreferenceKey: PreferenceKey {
    typealias Value = () -> Void

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<() -> Unit>
    final class Companion: PreferenceKeyCompanion {
        let defaultValue: () -> Void = {}
        func reduce(value: inout () -> Void, nextValue: () -> () -> Void) {
            value = nextValue()
        }
    }
}
#endif

public enum ScrollBounceBehavior : Sendable {
    case automatic
    case always
    case basedOnSize
}

public enum ScrollDismissesKeyboardMode : Sendable {
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

public struct PinnedScrollableViews : OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    @available(*, unavailable)
    public static let sectionHeaders = PinnedScrollableViews(rawValue: 1 << 0)
    @available(*, unavailable)
    public static let sectionFooters = PinnedScrollableViews(rawValue: 1 << 1)
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

    public func scrollContentBackground(_ visibility: Visibility) -> some View {
        #if SKIP
        return environment(\._scrollContentBackground, visibility)
        #else
        return self
        #endif
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

    @available(*, unavailable)
    public func scrollTargetBehavior(_ behavior: Any /* some ScrollTargetBehavior */) -> some View {
        return self
    }

    @available(*, unavailable)
    public func scrollTargetLayout(isEnabled: Bool = true) -> some View {
        return self
    }
}

#if false

import struct CoreGraphics.CGSize
import struct CoreGraphics.CGVector

// TODO: Process for use in SkipUI

/// A type that defines the scroll behavior of a scrollable view.
///
/// A scrollable view calculates where scroll gestures should end using its
/// deceleration rate and the state of its scroll gesture by default. A scroll
/// behavior allows for customizing this logic.
///
/// You define a scroll behavior using the
/// ``ScrollTargetBehavior/updateTarget(_:context:)`` method.
///
/// Using this method, you can control where someone can scroll in a scrollable
/// view. For example, you can create a custom scroll behavior
/// that aligns to every 10 points by doing the following:
///
///     struct BasicScrollTargetBehavior: ScrollTargetBehavior {
///         func updateTarget(_ target: inout Target, context: TargetContext) {
///             // Align to every 1/10 the size of the scroll view.
///             target.rect.x.round(
///                 toMultipleOf: round(context.containerSize.width / 10.0))
///         }
///     }
///
/// ### Paging Behavior
///
/// SkipUI offers built in scroll behaviors. One such behavior
/// is the ``PagingScrollTargetBehavior`` which uses the geometry of the scroll
/// view to decide where to allow scrolls to end.
///
/// In the following example, every view in the lazy stack is flexible
/// in both directions and the scroll view will settle to container aligned
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
/// ### View Aligned Behavior
///
/// SkipUI also offers a ``ViewAlignedScrollTargetBehavior`` scroll behavior
/// that will always settle on the geometry of individual views.
///
///     ScrollView(.horizontal) {
///         LazyHStack(spacing: 10.0) {
///             ForEach(items) { item in
///                 ItemView(item)
///             }
///         }
///         .scrollTargetLayout()
///     }
///     .scrollTargetBehavior(.viewAligned)
///     .safeAreaPadding(.horizontal, 20.0)
///
/// You configure which views should be used for settling using the
/// ``View/scrollTargetLayout()`` modifier. Apply this modifier to a
/// layout container like ``LazyVStack`` or ``HStack`` and each individual
/// view in that layout will be considered for alignment.
///
/// You can also associate invidiual views for alignment using the
/// ``View/scrollTarget()`` modifier.
///
///     ScrollView(.horizontal) {
///         HeaderView()
///             .scrollTarget()
///         LazyVStack {
///             // other content...
///         }
///         .scrollTargetLayout()
///     }
///     .scrollTargetBehavior(.viewAligned)
///
/// Use types conforming to this protocol with the
/// ``View/scrollTargetBehavior(_:)`` modifier.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol ScrollTargetBehavior {

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
    func updateTarget(_ target: inout ScrollTarget, context: Self.TargetContext)

    /// The context in which a scroll behavior updates the scroll target.
    typealias TargetContext = ScrollTargetBehaviorContext
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScrollTargetBehavior where Self == PagingScrollTargetBehavior {

    /// The scroll behavior that aligns scroll targets to container-based
    /// geometry.
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
    public static var paging: PagingScrollTargetBehavior { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScrollTargetBehavior where Self == ViewAlignedScrollTargetBehavior {

    /// The scroll behavior that aligns scroll targets to view-based geometry.
    ///
    /// You use this behavior when a scroll view should always align its
    /// scroll targets to a rectangle that's aligned to the geometry of a view. In
    /// the following example, the scroll view always picks an item view
    /// to settle on.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///     .padding(.horizontal, 20.0)
    ///
    /// You configure which views should be used for settling using the
    /// ``View/scrollTargetLayout()`` modifier. Apply this modifier to a
    /// layout container like ``LazyVStack`` or ``HStack`` and each individual
    /// view in that layout will be considered for alignment.
    ///
    /// You can also associate invidiual views for alignment using the
    /// ``View/scrollTarget()`` modifier.
    ///
    ///     ScrollView(.horizontal) {
    ///         LeadingView()
    ///             .scrollTarget()
    ///         LazyHStack {
    ///             // other content...
    ///         }
    ///         .scrollTarget()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///
    /// You can customize whether the view aligned behavior limits the
    /// number of views that can be scrolled at a time by using the
    /// ``ViewAlignedScrollTargetBehavior.LimitBehavior`` type. Provide a value
    /// of ``ViewAlignedScrollTargetBehavior.LimitBehavior/always`` to always
    /// have the behavior only allow a few views to be scrolled at a time.
    ///
    /// By default, the view aligned behavior limits the number of views
    /// it scrolls when in a compact horizontal size class when scrollable
    /// in the horizontal axis, when in a compact vertical size class when
    /// scrollable in the vertical axis, and otherwise doesn't impose any
    /// limit on the number of views that can be scrolled.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public static var viewAligned: ViewAlignedScrollTargetBehavior { get { fatalError() } }

    /// The scroll behavior that aligns scroll targets to view-based geometry.
    ///
    /// You use this behavior when a scroll view should always align its
    /// scroll targets to a rectangle that's aligned to the geometry of a view. In
    /// the following example, the scroll view always picks an item view
    /// to settle on.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///     .padding(.horizontal, 20.0)
    ///
    /// You configure which views should be used for settling using the
    /// ``View/scrollTargetLayout()`` modifier. Apply this modifier to a
    /// layout container like ``LazyVStack`` or ``HStack`` and each individual
    /// view in that layout will be considered for alignment.
    ///
    /// You can also associate invidiual views for alignment using the
    /// ``View/scrollTarget()`` modifier.
    ///
    ///     ScrollView(.horizontal) {
    ///         LeadingView()
    ///             .scrollTarget()
    ///         LazyHStack {
    ///             // other content...
    ///         }
    ///         .scrollTarget()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///
    /// You can customize whether the view aligned behavior limits the
    /// number of views that can be scrolled at a time by using the
    /// ``ViewAlignedScrollTargetBehavior.LimitBehavior`` type. Provide a value
    /// of ``ViewAlignedScrollTargetBehavior.LimitBehavior/always`` to always
    /// have the behavior only allow a few views to be scrolled at a time.
    ///
    /// By default, the view aligned behavior limits the number of views
    /// it scrolls when in a compact horizontal size class when scrollable
    /// in the horizontal axis, when in a compact vertical size class when
    /// scrollable in the vertical axis, and otherwise doesn't impose any
    /// limit on the number of views that can be scrolled.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public static func viewAligned(limitBehavior: ViewAlignedScrollTargetBehavior.LimitBehavior) -> Self { fatalError() }
}

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

/// A proxy value that supports programmatic scrolling of the scrollable
/// views within a view hierarchy.
///
/// You don't create instances of `ScrollViewProxy` directly. Instead, your
/// ``ScrollViewReader`` receives an instance of `ScrollViewProxy` in its
/// `content` view builder. You use actions within this view builder, such
/// as button and gesture handlers or the ``View/onChange(of:perform:)``
/// method, to call the proxy's ``ScrollViewProxy/scrollTo(_:anchor:)`` method.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ScrollViewProxy {

    /// Scans all scroll views contained by the proxy for the first
    /// with a child view with identifier `id`, and then scrolls to
    /// that view.
    ///
    /// If `anchor` is `nil`, this method finds the container of the identified
    /// view, and scrolls the minimum amount to make the identified view
    /// wholly visible.
    ///
    /// If `anchor` is non-`nil`, it defines the points in the identified
    /// view and the scroll view to align. For example, setting `anchor` to
    /// ``UnitPoint/top`` aligns the top of the identified view to the top of
    /// the scroll view. Similarly, setting `anchor` to ``UnitPoint/bottom``
    /// aligns the bottom of the identified view to the bottom of the scroll
    /// view, and so on.
    ///
    /// - Parameters:
    ///   - id: The identifier of a child view to scroll to.
    ///   - anchor: The alignment behavior of the scroll action.
    public func scrollTo<ID>(_ id: ID, anchor: UnitPoint? = nil) where ID : Hashable { fatalError() }
}

/// A view that provides programmatic scrolling, by working with a proxy
/// to scroll to known child views.
///
/// The scroll view reader's content view builder receives a ``ScrollViewProxy``
/// instance; you use the proxy's ``ScrollViewProxy/scrollTo(_:anchor:)`` to
/// perform scrolling.
///
/// The following example creates a ``ScrollView`` containing 100 views that
/// together display a color gradient. It also contains two buttons, one each
/// at the top and bottom. The top button tells the ``ScrollViewProxy`` to
/// scroll to the bottom button, and vice versa.
///
///     @Namespace var topID
///     @Namespace var bottomID
///
///     var body: some View {
///         ScrollViewReader { proxy in
///             ScrollView {
///                 Button("Scroll to Bottom") {
///                     withAnimation {
///                         proxy.scrollTo(bottomID)
///                     }
///                 }
///                 .id(topID)
///
///                 VStack(spacing: 0) {
///                     ForEach(0..<100) { i in
///                         color(fraction: Double(i) / 100)
///                             .frame(height: 32)
///                     }
///                 }
///
///                 Button("Top") {
///                     withAnimation {
///                         proxy.scrollTo(topID)
///                     }
///                 }
///                 .id(bottomID)
///             }
///         }
///     }
///
///     func color(fraction: Double) -> Color {
///         Color(red: fraction, green: 1 - fraction, blue: 0.5)
///     }
///
/// ![A scroll view, with a button labeled "Scroll to Bottom" at top.
/// Below this, a series of vertically aligned rows, each filled with a
/// color, that are progressing from green to
/// red.](SkipUI-ScrollViewReader-scroll-to-bottom-button.png)
///
/// > Important: You may not use the ``ScrollViewProxy``
/// during execution of the `content` view builder; doing so results in a
/// runtime error. Instead, only actions created within `content` can call
/// the proxy, such as gesture handlers or a view's `onChange(of:perform:)`
/// method.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen public struct ScrollViewReader<Content> : View where Content : View {

    /// The view builder that creates the reader's content.
    public var content: (ScrollViewProxy) -> Content { get { fatalError() } }

    /// Creates an instance that can perform programmatic scrolling of its
    /// child scroll views.
    ///
    /// - Parameter content: The reader's content, containing one or more
    /// scroll views. This view builder receives a ``ScrollViewProxy``
    /// instance that you use to perform scrolling.
    @inlinable public init(@ViewBuilder content: @escaping (ScrollViewProxy) -> Content) { fatalError() }

    @MainActor public var body: some View { get { return stubView() } }

//    public typealias Body = some View
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
