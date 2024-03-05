// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.animation.core.AnimationSpec
import androidx.compose.animation.core.EaseInOutBack
import androidx.compose.animation.core.SpringSpec
import androidx.compose.animation.core.TweenSpec
#endif

public struct Spring : Hashable, Sendable {
    #if SKIP
    private let animationSpec: AnimationSpec<Any>

    /// Convert this spring to a Compose animation spec.
    public func asAnimationSpec() -> AnimationSpec<Any> {
        return animationSpec
    }
    #endif

    public init(duration: TimeInterval = 0.5, bounce: Double = 0.0) {
        #if SKIP
        animationSpec = TweenSpec(durationMillis: Int(duration * 1000.0), easing: EaseInOutBack)
        #endif
    }

    @available(*, unavailable)
    public var duration: TimeInterval {
        return 0.0
    }

    @available(*, unavailable)
    public var bounce: Double {
        return 0.0
    }

    public init(response: Double, dampingRatio: Double) {
        #if SKIP
        animationSpec = TweenSpec(durationMillis: Int(response * 1000.0), easing: EaseInOutBack)
        #endif
    }

    @available(*, unavailable)
    public var response: Double {
        return 0.0
    }

    @available(*, unavailable)
    public var dampingRatio: Double {
        return 0.0
    }

    public init(mass: Double = 1.0, stiffness: Double, damping: Double, allowOverDamping: Bool = false) {
        #if SKIP
        let dampingRatio = damping / (2.0 * sqrt(mass * stiffness))
        animationSpec = SpringSpec(dampingRatio: Float(dampingRatio), stiffness: Float(stiffness))
        #endif
    }

    @available(*, unavailable)
    public var mass: Double {
        return 0.0
    }

    @available(*, unavailable)
    public var stiffness: Double {
        return 0.0
    }

    @available(*, unavailable)
    public var damping: Double {
        return 0.0
    }

    public init(settlingDuration: TimeInterval, dampingRatio: Double, epsilon: Double = 0.001) {
        #if SKIP
        animationSpec = TweenSpec(durationMillis: Int(settlingDuration * 1000.0), easing: EaseInOutBack)
        #endif
    }

    @available(*, unavailable)
    public var settlingDuration: TimeInterval {
        return 0.0
    }

    public static var smooth: Spring {
        return smooth(duration: 0.5, extraBounce: 0.0)
    }

    public static func smooth(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Spring {
        return Spring(duration: duration, bounce: extraBounce)
    }

    public static var snappy: Spring {
        return snappy(duration: 0.5, extraBounce: 0.0)
    }

    public static func snappy(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Spring {
        return Spring(duration: duration, bounce: extraBounce)
    }

    public static var bouncy: Spring {
        return bouncy(duration: 0.5, extraBounce: 0.0)
    }

    public static func bouncy(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Spring {
        return Spring(duration: duration, bounce: extraBounce)
    }
}

public enum SpringLoadingBehavior : Hashable, Sendable {
    case automatic
    case enabled
    case disabled
}

#if false

// TODO: Process for use in SkipUI

extension Spring {
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

#endif
