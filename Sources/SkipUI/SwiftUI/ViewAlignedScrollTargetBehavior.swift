// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

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
///               ItemView(item)
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
///     ScrollView {
///         HeaderView()
///             .scrollTarget()
///
///         LazyVStack {
///             // other content...
///         }
///         .scrollTargetLayout()
///     }
///     .scrollTargetBehavior(.viewAligned)
///
/// You can customize whether the view aligned behavior limits the
/// number of views that can be scrolled at a time by using the
/// ``ViewAlignedScrollTargetBehavior.LimitBehavior`` type. Provide a value of
/// ``ViewAlignedScrollTargetBehavior.LimitBehavior/always`` to always have
/// the behavior only allow a few views to be scrolled at a time.
///
/// By default, the view aligned behavior will limit the number of views
/// it scrolls when in a compact horizontal size class when scrollable
/// in the horizontal axis, when in a compact vertical size class when
/// scrollable in the vertical axis, and otherwise does not impose any
/// limit on the number of views that can be scrolled.
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ViewAlignedScrollTargetBehavior : ScrollTargetBehavior {

    /// A type that defines the amount of views that can be scrolled at a time.
    public struct LimitBehavior {

        /// The automatic limit behavior.
        ///
        /// By default, the behavior will be limited in compact horizontal
        /// size classes and will not be limited otherwise.
        public static var automatic: ViewAlignedScrollTargetBehavior.LimitBehavior { get { fatalError() } }

        /// The always limit behavior.
        ///
        /// Always limit the amount of views that can be scrolled.
        public static var always: ViewAlignedScrollTargetBehavior.LimitBehavior { get { fatalError() } }

        /// The never limit behavior.
        ///
        /// Never limit the amount of views that can be scrolled.
        public static var never: ViewAlignedScrollTargetBehavior.LimitBehavior { get { fatalError() } }
    }

    /// Creates a view aligned scroll behavior.
    public init(limitBehavior: ViewAlignedScrollTargetBehavior.LimitBehavior = .automatic) { fatalError() }

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
    public func updateTarget(_ target: inout ScrollTarget, context: ViewAlignedScrollTargetBehavior.TargetContext) { fatalError() }
}

#endif
