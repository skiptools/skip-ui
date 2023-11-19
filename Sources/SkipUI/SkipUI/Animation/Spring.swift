// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import typealias Foundation.TimeInterval

/// A representation of a spring's motion.
///
/// Use this type to convert between different representations of spring
/// parameters:
///
///     let spring = Spring(duration: 0.5, bounce: 0.3)
///     let (mass, stiffness, damping) = (spring.mass, spring.stiffness, spring.damping)
///     // (1.0, 157.9, 17.6)
///
///     let spring2 = Spring(mass: 1, stiffness: 100, damping: 10)
///     let (duration, bounce) = (spring2.duration, spring2.bounce)
///     // (0.63, 0.5)
///
/// You can also use it to query for a spring's position and its other properties for
/// a given set of inputs:
///
///     func unitPosition(time: TimeInterval) -> Double {
///         let spring = Spring(duration: 0.5, bounce: 0.3)
///         return spring.position(target: 1.0, time: time)
///     }
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct Spring : Hashable, Sendable {


    


    public init() { fatalError() }
}

/// Duration/Bounce Parameters
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Spring {

    /// Creates a spring with the specified duration and bounce.
    ///
    /// - Parameters:
    ///   - duration: Defines the pace of the spring. This is approximately
    ///   equal to the settling duration, but for springs with very large
    ///   bounce values, will be the duration of the period of oscillation
    ///   for the spring.
    ///   - bounce: How bouncy the spring should be. A value of 0 indicates
    ///   no bounces (a critically damped spring), positive values indicate
    ///   increasing amounts of bounciness up to a maximum of 1.0
    ///   (corresponding to undamped oscillation), and negative values
    ///   indicate overdamped springs with a minimum value of -1.0.
    public init(duration: TimeInterval = 0.5, bounce: Double = 0.0) { fatalError() }

    /// The perceptual duration, which defines the pace of the spring.
    public var duration: TimeInterval { get { fatalError() } }

    /// How bouncy the spring is.
    ///
    /// A value of 0 indicates no bounces (a critically damped spring), positive
    /// values indicate increasing amounts of bounciness up to a maximum of 1.0
    /// (corresponding to undamped oscillation), and negative values indicate
    /// overdamped springs with a minimum value of -1.0.
    public var bounce: Double { get { fatalError() } }
}

/// Response/DampingRatio Parameters
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Spring {

    /// Creates a spring with the specified response and damping ratio.
    ///
    /// - Parameters:
    ///   - response: Defines the stiffness of the spring as an approximate
    ///   duration in seconds.
    ///   - dampingRatio: Defines the amount of drag applied as a fraction the
    ///   amount needed to produce critical damping.
    public init(response: Double, dampingRatio: Double) { fatalError() }

    /// The stiffness of the spring, defined as an approximate duration in
    /// seconds.
    public var response: Double { get { fatalError() } }

    /// The amount of drag applied, as a fraction of the amount needed to
    /// produce critical damping.
    ///
    /// When `dampingRatio` is 1, the spring will smoothly decelerate to its
    /// final position without oscillating. Damping ratios less than 1 will
    /// oscillate more and more before coming to a complete stop.
    public var dampingRatio: Double { get { fatalError() } }
}

/// Mass/Stiffness/Damping Parameters
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Spring {

    /// Creates a spring with the specified mass, stiffness, and damping.
    ///
    /// - Parameters:
    ///   - mass: Specifies that property of the object attached to the end of
    ///   the spring.
    ///   - stiffness: The corresponding spring coefficient.
    ///   - damping: Defines how the spring's motion should be damped due to the
    ///   forces of friction.
    ///   - allowOverdamping: A value of true specifies that over-damping
    ///   should be allowed when appropriate based on the other inputs, and a
    ///   value of false specifies that such cases should instead be treated as
    ///   critically damped.
    public init(mass: Double = 1.0, stiffness: Double, damping: Double, allowOverDamping: Bool = false) { fatalError() }

    /// The mass of the object attached to the end of the spring.
    ///
    /// The default mass is 1. Increasing this value will increase the spring's
    /// effect: the attached object will be subject to more oscillations and
    /// greater overshoot, resulting in an increased settling duration.
    /// Decreasing the mass will reduce the spring effect: there will be fewer
    /// oscillations and a reduced overshoot, resulting in a decreased
    /// settling duration.
    public var mass: Double { get { fatalError() } }

    /// The spring stiffness coefficient.
    ///
    /// Increasing the stiffness reduces the number of oscillations and will
    /// reduce the settling duration. Decreasing the stiffness increases the the
    /// number of oscillations and will increase the settling duration.
    public var stiffness: Double { get { fatalError() } }

    /// Defines how the spring’s motion should be damped due to the forces of
    /// friction.
    ///
    /// Reducing this value reduces the energy loss with each oscillation: the
    /// spring will overshoot its destination. Increasing the value increases
    /// the energy loss with each duration: there will be fewer and smaller
    /// oscillations.
    public var damping: Double { get { fatalError() } }
}

/// SettlingDuration/DampingRatio Parameters
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Spring {

    /// Creates a spring with the specified duration and damping ratio.
    ///
    /// - Parameters:
    ///   - settlingDuration: The approximate time it will take for the spring
    ///   to come to rest.
    ///   - dampingRatio: The amount of drag applied as a fraction of the amount
    ///   needed to produce critical damping.
    ///   - epsilon: The threshhold for how small all subsequent values need to
    ///   be before the spring is considered to have settled.
    public init(settlingDuration: TimeInterval, dampingRatio: Double, epsilon: Double = 0.001) { fatalError() }
}

/// VectorArithmetic Evaluation
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Spring {

    /// The estimated duration required for the spring system to be considered
    /// at rest.
    ///
    /// This uses a `target` of 1.0, an `initialVelocity` of 0, and an `epsilon`
    /// of 0.001.
    public var settlingDuration: TimeInterval { get { fatalError() } }

    /// The estimated duration required for the spring system to be considered
    /// at rest.
    ///
    /// The epsilon value specifies the threshhold for how small all subsequent
    /// values need to be before the spring is considered to have settled.
    public func settlingDuration<V>(target: V, initialVelocity: V = .zero, epsilon: Double) -> TimeInterval where V : VectorArithmetic { fatalError() }

    /// Calculates the value of the spring at a given time given a target
    /// amount of change.
    public func value<V>(target: V, initialVelocity: V = .zero, time: TimeInterval) -> V where V : VectorArithmetic { fatalError() }

    /// Calculates the velocity of the spring at a given time given a target
    /// amount of change.
    public func velocity<V>(target: V, initialVelocity: V = .zero, time: TimeInterval) -> V where V : VectorArithmetic { fatalError() }

    /// Updates the current  value and velocity of a spring.
    ///
    /// - Parameters:
    ///   - value: The current value of the spring.
    ///   - velocity: The current velocity of the spring.
    ///   - target: The target that `value` is moving towards.
    ///   - deltaTime: The amount of time that has passed since the spring was
    ///     at the position specified by `value`.
    public func update<V>(value: inout V, velocity: inout V, target: V, deltaTime: TimeInterval) where V : VectorArithmetic { fatalError() }

    /// Calculates the force upon the spring given a current position, target,
    /// and velocity amount of change.
    ///
    /// This value is in units of the vector type per second squared.
    public func force<V>(target: V, position: V, velocity: V) -> V where V : VectorArithmetic { fatalError() }
}

/// Animatable Evaluation
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Spring {

    /// The estimated duration required for the spring system to be considered
    /// at rest.
    ///
    /// The epsilon value specifies the threshhold for how small all subsequent
    /// values need to be before the spring is considered to have settled.
    public func settlingDuration<V>(fromValue: V, toValue: V, initialVelocity: V, epsilon: Double) -> TimeInterval where V : Animatable { fatalError() }

    /// Calculates the value of the spring at a given time for a starting
    /// and ending value for the spring to travel.
    public func value<V>(fromValue: V, toValue: V, initialVelocity: V, time: TimeInterval) -> V where V : Animatable { fatalError() }

    /// Calculates the velocity of the spring at a given time given a starting
    /// and ending value for the spring to travel.
    public func velocity<V>(fromValue: V, toValue: V, initialVelocity: V, time: TimeInterval) -> V where V : Animatable { fatalError() }

    /// Calculates the force upon the spring given a current position,
    /// velocity, and divisor from the starting and end values for the spring to travel.
    ///
    /// This value is in units of the vector type per second squared.
    public func force<V>(fromValue: V, toValue: V, position: V, velocity: V) -> V where V : Animatable { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Spring {

    /// A smooth spring with a predefined duration and no bounce.
    public static var smooth: Spring { get { fatalError() } }

    /// A smooth spring with a predefined duration and no bounce that can be
    /// tuned.
    ///
    /// - Parameters:
    ///   - duration: The perceptual duration, which defines the pace of the
    ///     spring. This is approximately equal to the settling duration, but
    ///     for very bouncy springs, will be the duration of the period of
    ///     oscillation for the spring.
    ///   - extraBounce: How much additional bounce should be added to the base
    ///     bounce of 0.
    public static func smooth(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Spring { fatalError() }

    /// A spring with a predefined duration and small amount of bounce that
    /// feels more snappy.
    public static var snappy: Spring { get { fatalError() } }

    /// A spring with a predefined duration and small amount of bounce that
    /// feels more snappy and can be tuned.
    ///
    /// - Parameters:
    ///   - duration: The perceptual duration, which defines the pace of the
    ///     spring. This is approximately equal to the settling duration, but
    ///     for very bouncy springs, will be the duration of the period of
    ///     oscillation for the spring.
    ///   - extraBounce: How much additional bounciness should be added to the
    ///     base bounce of 0.15.
    public static func snappy(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Spring { fatalError() }

    /// A spring with a predefined duration and higher amount of bounce.
    public static var bouncy: Spring { get { fatalError() } }

    /// A spring with a predefined duration and higher amount of bounce that
    /// can be tuned.
    ///
    /// - Parameters:
    ///   - duration: The perceptual duration, which defines the pace of the
    ///     spring. This is approximately equal to the settling duration, but
    ///     for very bouncy springs, will be the duration of the period of
    ///     oscillation for the spring.
    ///   - extraBounce: How much additional bounce should be added to the base
    ///     bounce of 0.3.
    ///   - blendDuration: The duration in seconds over which to interpolate
    ///     changes to the duration.
    public static func bouncy(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Spring { fatalError() }
}

/// A keyframe that uses a spring function to interpolate to the given value.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct SpringKeyframe<Value> : KeyframeTrackContent where Value : Animatable {

    /// Creates a new keyframe using the given value and timestamp.
    ///
    /// - Parameters:
    ///   - to: The value of the keyframe.
    ///   - duration: The duration of the segment defined by this keyframe,
    ///     or nil to use the settling duration of the spring.
    ///   - spring: The spring that defines the shape of the segment befire
    ///     this keyframe
    ///   - startVelocity: The velocity of the value at the start of the
    ///     segment, or `nil` to automatically compute the velocity to maintain
    ///     smooth motion.
    public init(_ to: Value, duration: TimeInterval? = nil, spring: Spring = Spring(), startVelocity: Value? = nil) { fatalError() }

    public typealias Value = Value
    public typealias Body = SpringKeyframe<Value>
//    @KeyframeTrackContentBuilder<Self.Value> public var body: Body { fatalError() }
}

/// The options for controlling the spring loading behavior of views.
///
/// Use values of this type with the ``View/springLoadingBehavior(_:)``
/// modifier.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct SpringLoadingBehavior : Hashable, Sendable {

    /// The automatic spring loading behavior.
    ///
    /// This defers to default component behavior for spring loading.
    /// Some components, such as `TabView`, will default to allowing spring
    /// loading; while others do not.
    public static let automatic: SpringLoadingBehavior = { fatalError() }()

    /// Spring loaded interactions will be enabled for applicable views.
    public static let enabled: SpringLoadingBehavior = { fatalError() }()

    /// Spring loaded interactions will be disabled for applicable views.
    public static let disabled: SpringLoadingBehavior = { fatalError() }()
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Sets the spring loading behavior this view.
    ///
    /// Spring loading refers to a view being activated during a drag and drop
    /// interaction. On iOS this can occur when pausing briefly on top of a
    /// view with dragged content. On macOS this can occur with similar brief
    /// pauses or on pressure-sensitive systems by "force clicking" during the
    /// drag. This has no effect on tvOS or watchOS.
    ///
    /// This is commonly used with views that have a navigation or presentation
    /// effect, allowing the destination to be revealed without pausing the
    /// drag interaction. For example, a button that reveals a list of folders
    /// that a dragged item can be dropped onto.
    ///
    ///     Button {
    ///         showFolders = true
    ///     } label: {
    ///         Label("Show Folders", systemImage: "folder")
    ///     }
    ///     .springLoadingBehavior(.enabled)
    ///
    /// Unlike `disabled(_:)`, this modifier overrides the value set by an
    /// ancestor view rather than being unioned with it. For example, the below
    /// button would allow spring loading:
    ///
    ///     HStack {
    ///         Button {
    ///             showFolders = true
    ///         } label: {
    ///             Label("Show Folders", systemImage: "folder")
    ///         }
    ///         .springLoadingBehavior(.enabled)
    ///
    ///         ...
    ///     }
    ///     .springLoadingBehavior(.disabled)
    ///
    /// - Parameter behavior: Whether spring loading is enabled or not. If
    ///   unspecified, the default behavior is `.automatic.`
    public func springLoadingBehavior(_ behavior: SpringLoadingBehavior) -> some View { return stubView() }

}

#endif
