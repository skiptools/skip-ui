// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if SKIP
public func withAnimation(_ body: () -> Void) {
    body()
}
#else

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import struct Foundation.Date
import typealias Foundation.TimeInterval

/// Returns the result of recomputing the view's body with the provided
/// animation, and runs the completion when all animations are complete.
///
/// This function sets the given ``Animation`` as the ``Transaction/animation``
/// property of the thread's current ``Transaction`` as well as calling
/// ``Transaction/addAnimationCompletion`` with the specified completion.
///
/// The completion callback will always be fired exactly one time. If no
/// animations are created by the changes in `body`, then the callback will be
/// called immediately after `body`.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public func withAnimation<Result>(_ animation: Animation? = .default, completionCriteria: AnimationCompletionCriteria = .logicallyComplete, _ body: () throws -> Result, completion: @escaping () -> Void) rethrows -> Result { fatalError() }

/// Returns the result of recomputing the view's body with the provided
/// animation.
///
/// This function sets the given ``Animation`` as the ``Transaction/animation``
/// property of the thread's current ``Transaction``.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func withAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result { fatalError() }

/// A type that describes how to animate a property of a view.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol Animatable {

    /// The type defining the data to animate.
    associatedtype AnimatableData : VectorArithmetic

    /// The data to animate.
//    var animatableData: Self.AnimatableData { get set }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Animatable where Self : VectorArithmetic {

    /// The data to animate.
    public var animatableData: Self { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Animatable where Self.AnimatableData == EmptyAnimatableData {

    /// The data to animate.
    public var animatableData: EmptyAnimatableData { get { fatalError() } }
}

/// A modifier that can create another modifier with animation.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use Animatable directly")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "use Animatable directly")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use Animatable directly")
@available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use Animatable directly")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "use Animatable directly")
public protocol AnimatableModifier : Animatable, ViewModifier {
}

/// A pair of animatable values, which is itself animatable.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct AnimatablePair<First, Second> : VectorArithmetic where First : VectorArithmetic, Second : VectorArithmetic {

    /// The first value.
    public var first: First { get { fatalError() } }

    /// The second value.
    public var second: Second { get { fatalError() } }

    /// Creates an animated pair with the provided values.
    @inlinable public init(_ first: First, _ second: Second) { fatalError() }

    /// The zero value.
    ///
    /// Zero is the identity element for addition. For any value,
    /// `x + .zero == x` and `.zero + x == x`.
    public static var zero: AnimatablePair<First, Second> { get { fatalError() } }

    /// Adds two values and stores the result in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    public static func += (lhs: inout AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>) { fatalError() }

    /// Subtracts the second value from the first and stores the difference in the
    /// left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from `lhs`.
    public static func -= (lhs: inout AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>) { fatalError() }

    /// Adds two values and produces their sum.
    ///
    /// The addition operator (`+`) calculates the sum of its two arguments. For
    /// example:
    ///
    ///     1 + 2                   // 3
    ///     -10 + 15                // 5
    ///     -15 + -5                // -20
    ///     21.5 + 3.25             // 24.75
    ///
    /// You cannot use `+` with arguments of different types. To add values of
    /// different types, convert one of the values to the other value's type.
    ///
    ///     let x: Int8 = 21
    ///     let y: Int = 1000000
    ///     Int(x) + y              // 1000021
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    public static func + (lhs: AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>) -> AnimatablePair<First, Second> { fatalError() }

    /// Subtracts one value from another and produces their difference.
    ///
    /// The subtraction operator (`-`) calculates the difference of its two
    /// arguments. For example:
    ///
    ///     8 - 3                   // 5
    ///     -10 - 5                 // -15
    ///     100 - -5                // 105
    ///     10.5 - 100.0            // -89.5
    ///
    /// You cannot use `-` with arguments of different types. To subtract values
    /// of different types, convert one of the values to the other value's type.
    ///
    ///     let x: UInt8 = 21
    ///     let y: UInt = 1000000
    ///     y - UInt(x)             // 999979
    ///
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from `lhs`.
    public static func - (lhs: AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>) -> AnimatablePair<First, Second> { fatalError() }

    /// Multiplies each component of this value by the given value.
    public mutating func scale(by rhs: Double) { fatalError() }

    /// The dot-product of this animated pair with itself.
    public var magnitudeSquared: Double { get { fatalError() } }

    
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnimatablePair : Sendable where First : Sendable, Second : Sendable {
}

/// The way a view changes over time to create a smooth visual transition from
/// one state to another.
///
/// An `Animation` provides a visual transition of a view when a state value
/// changes from one value to another. The characteristics of this transition
/// vary according to the animation type. For instance, a ``linear`` animation
/// provides a mechanical feel to the animation because its speed is consistent
/// from start to finish. In contrast, an animation that uses easing, like
/// ``easeOut``, offers a more natural feel by varying the acceleration
/// of the animation.
///
/// To apply an animation to a view, add the ``View/animation(_:value:)``
/// modifier, and specify both an animation type and the value to animate. For
/// instance, the ``Circle`` view in the following code performs an
/// ``easeIn`` animation each time the state variable `scale` changes:
///
///     struct ContentView: View {
///         @State private var scale = 0.5
///
///         var body: some View {
///             VStack {
///                 Circle()
///                     .scaleEffect(scale)
///                     .animation(.easeIn, value: scale)
///                 HStack {
///                     Button("+") { scale += 0.1 }
///                     Button("-") { scale -= 0.1 }
///                 }
///             }
///             .padding()
///         }
///
/// @Video(source: "animation-01-overview-easein.mp4", poster: "animation-01-overview-easein.png", alt: "A video that shows a circle enlarging then shrinking to its original size using an ease-in animation.")
///
/// When the value of `scale` changes, the modifier
/// ``View/scaleEffect(_:anchor:)-pmi7`` resizes ``Circle`` according to the
/// new value. SkipUI can animate the transition between sizes because
/// ``Circle`` conforms to the ``Shape`` protocol. Shapes in SkipUI conform to
/// the ``Animatable`` protocol, which describes how to animate a property of a
/// view.
///
/// In addition to adding an animation to a view, you can also configure the
/// animation by applying animation modifiers to the animation type. For
/// example, you can:
///
/// - Delay the start of the animation by using the ``delay(_:)`` modifier.
/// - Repeat the animation by using the ``repeatCount(_:autoreverses:)`` or
/// ``repeatForever(autoreverses:)`` modifiers.
/// - Change the speed of the animation by using the ``speed(_:)`` modifier.
///
/// For example, the ``Circle`` view in the following code repeats
/// the ``easeIn`` animation three times by using the
/// ``repeatCount(_:autoreverses:)`` modifier:
///
///     struct ContentView: View {
///         @State private var scale = 0.5
///
///         var body: some View {
///             VStack {
///                 Circle()
///                     .scaleEffect(scale)
///                     .animation(.easeIn.repeatCount(3), value: scale)
///                 HStack {
///                     Button("+") { scale += 0.1 }
///                     Button("-") { scale -= 0.1 }
///                 }
///             }
///             .padding()
///         }
///     }
///
/// @Video(source: "animation-02-overview-easein-repeat.mp4", poster: "animation-02-overview-easein-repeat.png", alt: "A video that shows a circle that repeats the ease-in animation three times: enlarging, then shrinking, then enlarging again. The animation reverses causing the circle to shrink, then enlarge, then shrink to its original size.")
///
/// A view can also perform an animation when a binding value changes. To
/// specify the animation type on a binding, call its ``Binding/animation(_:)``
/// method. For example, the view in the following code performs a
/// ``linear`` animation, moving the box truck between the leading and trailing
/// edges of the view. The truck moves each time a person clicks the ``Toggle``
/// control, which changes the value of the `$isTrailing` binding.
///
///     struct ContentView: View {
///         @State private var isTrailing = false
///
///         var body: some View {
///            VStack(alignment: isTrailing ? .trailing : .leading) {
///                 Image(systemName: "box.truck")
///                     .font(.system(size: 64))
///
///                 Toggle("Move to trailing edge",
///                        isOn: $isTrailing.animation(.linear))
///             }
///         }
///     }
///
/// @Video(source: "animation-03-overview-binding.mp4", poster: "animation-03-overview-binding.png", alt: "A video that shows a box truck that moves from the leading edge of a view to the trailing edge. The box truck then returns to the view's leading edge.")
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Animation : Equatable, Sendable {

    /// Create an `Animation` that contains the specified custom animation.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init<A>(_ base: A) where A : CustomAnimation { fatalError() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Animation {

    /// A persistent spring animation. When mixed with other `spring()`
    /// or `interactiveSpring()` animations on the same property, each
    /// animation will be replaced by their successor, preserving
    /// velocity from one animation to the next. Optionally blends the
    /// duration values between springs over a time period.
    ///
    /// - Parameters:
    ///   - duration: The perceptual duration, which defines the pace of the
    ///     spring. This is approximately equal to the settling duration, but
    ///     for very bouncy springs, will be the duration of the period of
    ///     oscillation for the spring.
    ///   - bounce: How bouncy the spring should be. A value of 0 indicates
    ///     no bounces (a critically damped spring), positive values indicate
    ///     increasing amounts of bounciness up to a maximum of 1.0
    ///     (corresponding to undamped oscillation), and negative values
    ///     indicate overdamped springs with a minimum value of -1.0.
    ///   - blendDuration: The duration in seconds over which to
    ///     interpolate changes to the duration.
    /// - Returns: a spring animation.
    public static func spring(duration: TimeInterval = 0.5, bounce: Double = 0.0, blendDuration: Double = 0) -> Animation { fatalError() }

    /// A persistent spring animation. When mixed with other `spring()`
    /// or `interactiveSpring()` animations on the same property, each
    /// animation will be replaced by their successor, preserving
    /// velocity from one animation to the next. Optionally blends the
    /// response values between springs over a time period.
    ///
    /// - Parameters:
    ///   - response: The stiffness of the spring, defined as an
    ///     approximate duration in seconds. A value of zero requests
    ///     an infinitely-stiff spring, suitable for driving
    ///     interactive animations.
    ///   - dampingFraction: The amount of drag applied to the value
    ///     being animated, as a fraction of an estimate of amount
    ///     needed to produce critical damping.
    ///   - blendDuration: The duration in seconds over which to
    ///     interpolate changes to the response value of the spring.
    /// - Returns: a spring animation.
    public static func spring(response: Double = 0.5, dampingFraction: Double = 0.825, blendDuration: TimeInterval = 0) -> Animation { fatalError() }

    /// A persistent spring animation. When mixed with other `spring()`
    /// or `interactiveSpring()` animations on the same property, each
    /// animation will be replaced by their successor, preserving
    /// velocity from one animation to the next. Optionally blends the
    /// response values between springs over a time period.
    ///
    /// This uses the default parameter values.
    public static var spring: Animation { get { fatalError() } }

    /// A convenience for a `spring` animation with a lower
    /// `response` value, intended for driving interactive animations.
    public static func interactiveSpring(response: Double = 0.15, dampingFraction: Double = 0.86, blendDuration: TimeInterval = 0.25) -> Animation { fatalError() }

    /// A convenience for a `spring` animation with a lower
    /// `duration` value, intended for driving interactive animations.
    ///
    /// This uses the default parameter values.
    public static var interactiveSpring: Animation { get { fatalError() } }

    /// A convenience for a `spring` animation with a lower
    /// `response` value, intended for driving interactive animations.
    public static func interactiveSpring(duration: TimeInterval = 0.15, extraBounce: Double = 0.0, blendDuration: TimeInterval = 0.25) -> Animation { fatalError() }

    /// A smooth spring animation with a predefined duration and no bounce.
    public static var smooth: Animation { get { fatalError() } }

    /// A smooth spring animation with a predefined duration and no bounce
    /// that can be tuned.
    ///
    /// - Parameters:
    ///   - duration: The perceptual duration, which defines the pace of the
    ///     spring. This is approximately equal to the settling duration, but
    ///     for very bouncy springs, will be the duration of the period of
    ///     oscillation for the spring.
    ///   - extraBounce: How much additional bounce should be added to the base
    ///     bounce of 0.
    ///   - blendDuration: The duration in seconds over which to interpolate
    ///     changes to the duration.
    public static func smooth(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Animation { fatalError() }

    /// A spring animation with a predefined duration and small amount of
    /// bounce that feels more snappy.
    public static var snappy: Animation { get { fatalError() } }

    /// A spring animation with a predefined duration and small amount of
    /// bounce that feels more snappy and can be tuned.
    ///
    /// - Parameters:
    ///   - duration: The perceptual duration, which defines the pace of the
    ///     spring. This is approximately equal to the settling duration, but
    ///     for very bouncy springs, will be the duration of the period of
    ///     oscillation for the spring.
    ///   - extraBounce: How much additional bounce should be added to the base
    ///     bounce of 0.15.
    ///   - blendDuration: The duration in seconds over which to interpolate
    ///     changes to the duration.
    public static func snappy(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Animation { fatalError() }

    /// A spring animation with a predefined duration and higher amount of
    /// bounce.
    public static var bouncy: Animation { get { fatalError() } }

    /// A spring animation with a predefined duration and higher amount of
    /// bounce that can be tuned.
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
    public static func bouncy(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Animation { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Animation {

    /// A persistent spring animation.
    ///
    /// When mixed with other `spring()`
    /// or `interactiveSpring()` animations on the same property, each
    /// animation will be replaced by their successor, preserving
    /// velocity from one animation to the next. Optionally blends the
    /// duration values between springs over a time period.
    public static func spring(_ spring: Spring, blendDuration: TimeInterval = 0.0) -> Animation { fatalError() }

    /// An interpolating spring animation that uses a damped spring
    /// model to produce values in the range of one to zero.
    ///
    /// These vales are used to interpolate within the `[from, to]` range
    /// of the animated
    /// property. Preserves velocity across overlapping animations by
    /// adding the effects of each animation.
    public static func interpolatingSpring(_ spring: Spring, initialVelocity: Double = 0.0) -> Animation { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Animation {

    /// Creates a new animation with speed controlled by the given curve.
    ///
    /// - Parameters:
    ///   - timingCurve: A curve that describes the speed of the
    ///     animation over its duration.
    ///   - duration: The duration of the animation, in seconds.
    public static func timingCurve(_ curve: UnitCurve, duration: TimeInterval) -> Animation { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Animation {

    /// A default animation instance.
    ///
    /// The `default` animation is ``spring(response:dampingFraction:blendDuration:)``
    /// with:
    ///
    /// - `response` equal to `0.55`
    /// - `dampingFraction` equal to `1.0`
    /// - `blendDuration` equal to `0.0`
    ///
    /// Prior to iOS 17, macOS 14, tvOS 17, and watchOS 10, the `default`
    /// animation is ``easeInOut``.
    ///
    /// The global function
    /// ``withAnimation(_:_:)`` uses the default animation if you don't
    /// provide one. For instance, the following code listing shows
    /// an example of using the `default` animation to flip the text "Hello"
    /// each time someone clicks the Animate button.
    ///
    ///     struct ContentView: View {
    ///         @State private var degrees = Double.zero
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Spacer()
    ///                 Text("Hello")
    ///                     .font(.largeTitle)
    ///                     .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
    ///
    ///                 Spacer()
    ///                 Button("Animate") {
    ///                     withAnimation {
    ///                         degrees = (degrees == .zero) ? 180 : .zero
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-04-default-flip.mp4", poster: "animation-04-default-flip.png", alt: "A video that shows the word Hello flip horizontally so that its letters appear backwards. Then it flips in reverse so that the word Hello appears correctly.")
    ///
    /// To use the `default` animation when adding the ``View/animation(_:value:)``
    /// view modifier, specify it explicitly as the animation type. For
    /// instance, the following code shows an example of the `default`
    /// animation to spin the text "Hello" each time someone clicks the Animate
    /// button.
    ///
    ///     struct ContentView: View {
    ///         @State private var degrees = Double.zero
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Spacer()
    ///                 Text("Hello")
    ///                     .font(.largeTitle)
    ///                     .rotationEffect(.degrees(degrees))
    ///                     .animation(.default, value: degrees)
    ///
    ///                 Spacer()
    ///                 Button("Animate") {
    ///                     degrees = (degrees == .zero) ? 360 : .zero
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-05-default-spin.mp4", poster: "animation-05-default-spin.png", alt: "A video that shows the word Hello spinning clockwise for one full rotation, that is, 360 degrees. Then Hello spins counterclockwise for one full rotation.")
    ///
    /// A `default` animation instance is only equal to other `default`
    /// animation instances (using `==`), and not equal to other animation
    /// instances even when the animations are identical. For example, if you
    /// create an animation using the ``spring(response:dampingFraction:blendDuration:)``
    /// modifier with the same parameter values that `default` uses, the
    /// animation isn't equal to `default`. This behavior lets you
    /// differentiate between animations that you intentionally choose and
    /// those that use the `default` animation.
    public static let `default`: Animation = { fatalError() }()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Animation {

    /// An animation with a specified duration that combines the behaviors of
    /// in and out easing animations.
    ///
    /// An easing animation provides motion with a natural feel by varying
    /// the acceleration and deceleration of the animation, which matches
    /// how things tend to move in reality. An ease in and out animation
    /// starts slowly, increasing its speed towards the halfway point, and
    /// finally decreasing the speed towards the end of the animation.
    ///
    /// Use `easeInOut(duration:)` when you want to specify the time it takes
    /// for the animation to complete. Otherwise, use ``easeInOut`` to perform
    /// the animation for a default length of time.
    ///
    /// The following code shows an example of animating the size changes of
    /// a ``Circle`` using an ease in and out animation with a duration of
    /// one second.
    ///
    ///     struct ContentView: View {
    ///         @State private var scale = 0.5
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Circle()
    ///                     .scale(scale)
    ///                     .animation(.easeInOut(duration: 1.0), value: scale)
    ///                 HStack {
    ///                     Button("+") { scale += 0.1 }
    ///                     Button("-") { scale -= 0.1 }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-13-easeineaseout-duration.mp4", poster: "animation-13-easeineaseout-duration.png", alt: "A video that shows a circle enlarging for one second, then shrinking for another second to its original size using an ease-in ease-out animation.")
    ///
    /// - Parameter duration: The length of time, expressed in seconds, that
    /// the animation takes to complete.
    ///
    /// - Returns: An ease-in ease-out animation with a specified duration.
    public static func easeInOut(duration: TimeInterval) -> Animation { fatalError() }

    /// An animation that combines the behaviors of in and out easing
    /// animations.
    ///
    /// An easing animation provides motion with a natural feel by varying
    /// the acceleration and deceleration of the animation, which matches
    /// how things tend to move in reality. An ease in and out animation
    /// starts slowly, increasing its speed towards the halfway point, and
    /// finally decreasing the speed towards the end of the animation.
    ///
    /// The `easeInOut` animation has a default duration of 0.35 seconds. To
    /// specify the duration, use the ``easeInOut(duration:)`` method.
    ///
    /// The following code shows an example of animating the size changes of a
    /// ``Circle`` using an ease in and out animation.
    ///
    ///     struct ContentView: View {
    ///         @State private var scale = 0.5
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Circle()
    ///                     .scale(scale)
    ///                     .animation(.easeInOut, value: scale)
    ///                 HStack {
    ///                     Button("+") { scale += 0.1 }
    ///                     Button("-") { scale -= 0.1 }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-12-easeineaseout.mp4", poster: "animation-12-easeineaseout.png", alt: "A video that shows a circle enlarging, then shrinking to its original size using an ease-in ease-out animation.")
    ///
    /// - Returns: An ease-in ease-out animation with the default duration.
    public static var easeInOut: Animation { get { fatalError() } }

    /// An animation with a specified duration that starts slowly and then
    /// increases speed towards the end of the movement.
    ///
    /// An easing animation provides motion with a natural feel by varying
    /// the acceleration and deceleration of the animation, which matches
    /// how things tend to move in reality. With an ease in animation, the
    /// motion starts slowly and increases its speed towards the end.
    ///
    /// Use `easeIn(duration:)` when you want to specify the time it takes
    /// for the animation to complete. Otherwise, use ``easeIn`` to perform the
    /// animation for a default length of time.
    ///
    /// The following code shows an example of animating the size changes of
    /// a ``Circle`` using an ease in animation with a duration of one
    /// second.
    ///
    ///     struct ContentView: View {
    ///         @State private var scale = 0.5
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Circle()
    ///                     .scale(scale)
    ///                     .animation(.easeIn(duration: 1.0), value: scale)
    ///                 HStack {
    ///                     Button("+") { scale += 0.1 }
    ///                     Button("-") { scale -= 0.1 }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-09-easein-duration.mp4", poster: "animation-09-easein-duration.png", alt: "A video that shows a circle enlarging for one second, then shrinking for another second to its original size using an ease-in animation.")
    ///
    /// - Parameter duration: The length of time, expressed in seconds, that
    /// the animation takes to complete.
    ///
    /// - Returns: An ease-in animation with a specified duration.
    public static func easeIn(duration: TimeInterval) -> Animation { fatalError() }

    /// An animation that starts slowly and then increases speed towards the
    /// end of the movement.
    ///
    /// An easing animation provides motion with a natural feel by varying
    /// the acceleration and deceleration of the animation, which matches
    /// how things tend to move in reality. With an ease in animation, the
    /// motion starts slowly and increases its speed towards the end.
    ///
    /// The `easeIn` animation has a default duration of 0.35 seconds. To
    /// specify a different duration, use ``easeIn(duration:)``.
    ///
    /// The following code shows an example of animating the size changes of
    /// a ``Circle`` using the ease in animation.
    ///
    ///     struct ContentView: View {
    ///         @State private var scale = 0.5
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Circle()
    ///                     .scale(scale)
    ///                     .animation(.easeIn, value: scale)
    ///                 HStack {
    ///                     Button("+") { scale += 0.1 }
    ///                     Button("-") { scale -= 0.1 }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-08-easein.mp4", poster: "animation-08-easein.png", alt: "A video that shows a circle enlarging, then shrinking to its original size using an ease-in animation.")
    ///
    /// - Returns: An ease-in animation with the default duration.
    public static var easeIn: Animation { get { fatalError() } }

    /// An animation with a specified duration that starts quickly and then
    /// slows towards the end of the movement.
    ///
    /// An easing animation provides motion with a natural feel by varying
    /// the acceleration and deceleration of the animation, which matches
    /// how things tend to move in reality. With an ease out animation, the
    /// motion starts quickly and decreases its speed towards the end.
    ///
    /// Use `easeOut(duration:)` when you want to specify the time it takes
    /// for the animation to complete. Otherwise, use ``easeOut`` to perform
    /// the animation for a default length of time.
    ///
    /// The following code shows an example of animating the size changes of
    /// a ``Circle`` using an ease out animation with a duration of one
    /// second.
    ///
    ///     struct ContentView: View {
    ///         @State private var scale = 0.5
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Circle()
    ///                     .scale(scale)
    ///                     .animation(.easeOut(duration: 1.0), value: scale)
    ///                 HStack {
    ///                     Button("+") { scale += 0.1 }
    ///                     Button("-") { scale -= 0.1 }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-09-easein-duration.mp4", poster: "animation-09-easein-duration.png", alt: "A video that shows a circle enlarging for one second, then shrinking for another second to its original size using an ease-in animation.")
    ///
    /// - Parameter duration: The length of time, expressed in seconds, that
    /// the animation takes to complete.
    ///
    /// - Returns: An ease-out animation with a specified duration.
    public static func easeOut(duration: TimeInterval) -> Animation { fatalError() }

    /// An animation that starts quickly and then slows towards the end of the
    /// movement.
    ///
    /// An easing animation provides motion with a natural feel by varying
    /// the acceleration and deceleration of the animation, which matches
    /// how things tend to move in reality. With an ease out animation, the
    /// motion starts quickly and decreases its speed towards the end.
    ///
    /// The `easeOut` animation has a default duration of 0.35 seconds. To
    /// specify a different duration, use ``easeOut(duration:)``.
    ///
    /// The following code shows an example of animating the size changes of
    /// a ``Circle`` using an ease out animation.
    ///
    ///     struct ContentView: View {
    ///         @State private var scale = 0.5
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Circle()
    ///                     .scale(scale)
    ///                     .animation(.easeOut, value: scale)
    ///                 HStack {
    ///                     Button("+") { scale += 0.1 }
    ///                     Button("-") { scale -= 0.1 }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-10-easeout.mp4", poster: "animation-10-easeout.png", alt: "A video that shows a circle enlarging, then shrinking to its original size using an ease-out animation.")
    ///
    /// - Returns: An ease-out animation with the default duration.
    public static var easeOut: Animation { get { fatalError() } }

    /// An animation that moves at a constant speed during a specified
    /// duration.
    ///
    /// A linear animation provides a mechanical feel to the motion because its
    /// speed is consistent from start to finish of the animation. This
    /// constant speed makes a linear animation ideal for animating the
    /// movement of objects where changes in the speed might feel awkward, such
    /// as with an activity indicator.
    ///
    /// Use `linear(duration:)` when you want to specify the time it takes
    /// for the animation to complete. Otherwise, use ``linear`` to perform the
    /// animation for a default length of time.
    ///
    /// The following code shows an example of using linear animation with a
    /// duration of two seconds to animate the movement of a circle as it moves
    /// between the leading and trailing edges of the view. The color of the
    /// circle also animates from red to blue as it moves across the view.
    ///
    ///     struct ContentView: View {
    ///         @State private var isActive = false
    ///
    ///         var body: some View {
    ///             VStack(alignment: isActive ? .trailing : .leading) {
    ///                 Circle()
    ///                     .fill(isActive ? Color.red : Color.blue)
    ///                     .frame(width: 50, height: 50)
    ///
    ///                 Button("Animate") {
    ///                     withAnimation(.linear(duration: 2.0)) {
    ///                         isActive.toggle()
    ///                     }
    ///                 }
    ///                 .frame(maxWidth: .infinity)
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-07-linear-duration.mp4", poster: "animation-07-linear-duration.png", alt: "A video that shows a circle moving from the leading edge of the view to the trailing edge. The color of the circle also changes from red to blue as it moves across the view. Then the circle moves from the trailing edge back to the leading edge while also changing colors from blue to red.")
    ///
    /// - Parameter duration: The length of time, expressed in seconds, that
    /// the animation takes to complete.
    ///
    /// - Returns: A linear animation with a specified duration.
    public static func linear(duration: TimeInterval) -> Animation { fatalError() }

    /// An animation that moves at a constant speed.
    ///
    /// A linear animation provides a mechanical feel to the motion because its
    /// speed is consistent from start to finish of the animation. This
    /// constant speed makes a linear animation ideal for animating the
    /// movement of objects where changes in the speed might feel awkward, such
    /// as with an activity indicator.
    ///
    /// The following code shows an example of using linear animation to
    /// animate the movement of a circle as it moves between the leading and
    /// trailing edges of the view. The circle also animates its color change
    /// as it moves across the view.
    ///
    ///     struct ContentView: View {
    ///         @State private var isActive = false
    ///
    ///         var body: some View {
    ///             VStack(alignment: isActive ? .trailing : .leading) {
    ///                 Circle()
    ///                     .fill(isActive ? Color.red : Color.blue)
    ///                     .frame(width: 50, height: 50)
    ///
    ///                 Button("Animate") {
    ///                     withAnimation(.linear) {
    ///                         isActive.toggle()
    ///                     }
    ///                 }
    ///                 .frame(maxWidth: .infinity)
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-06-linear.mp4", poster: "animation-06-linear.png", alt: "A video that shows a circle moving from the leading edge of the view to the trailing edge. The color of the circle also changes from red to blue as it moves across the view. Then the circle moves from the trailing edge back to the leading edge while also changing colors from blue to red.")
    ///
    /// The `linear` animation has a default duration of 0.35 seconds. To
    /// specify a different duration, use ``linear(duration:)``.
    ///
    /// - Returns: A linear animation with the default duration.
    public static var linear: Animation { get { fatalError() } }

    /// An animation created from a cubic Bézier timing curve.
    ///
    /// Use this method to create a timing curve based on the control points of
    /// a cubic Bézier curve. A cubic Bézier timing curve consists of a line
    /// whose starting point is `(0, 0)` and whose end point is `(1, 1)`. Two
    /// additional control points, `(p1x, p1y)` and `(p2x, p2y)`, define the
    /// shape of the curve.
    ///
    /// The slope of the line defines the speed of the animation at that point
    /// in time. A steep slopes causes the animation to appear to run faster,
    /// while a shallower slope appears to run slower. The following
    /// illustration shows a timing curve where the animation starts and
    /// finishes fast, but appears slower through the middle section of the
    /// animation.
    ///
    /// ![An illustration of an XY graph that shows the path of a Bézier timing curve that an animation frame follows over time. The horizontal x-axis has a label with the text Time, and a label with the text Frame appears along the vertical y-axis. The path begins at the graph's origin, labeled as (0.0, 0.0). The path moves upwards, forming a concave down shape. At the point of inflection, the path continues upwards, forming a concave up shape. A label with the text First control point (p1x, p1y) appears above the path. Extending from the label is a dotted line pointing to the position (0.1, 0.75) on the graph. Another label with the text Second control point (p2x, p2y) appears below the path. A dotted line extends from the label to the (0.85, 0.35) position on the graph.](Animation-timingCurve-1)
    ///
    /// The following code uses the timing curve from the previous
    /// illustration to animate a ``Circle`` as its size changes.
    ///
    ///     struct ContentView: View {
    ///         @State private var scale = 1.0
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Circle()
    ///                     .scaleEffect(scale)
    ///                     .animation(
    ///                         .timingCurve(0.1, 0.75, 0.85, 0.35, duration: 2.0),
    ///                         value: scale)
    ///
    ///                 Button("Animate") {
    ///                     if scale == 1.0 {
    ///                         scale = 0.25
    ///                     } else {
    ///                         scale = 1.0
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-14-timing-curve.mp4", poster: "animation-14-timing-curve.png", alt: "A video that shows a circle shrinking then growing to its original size using a timing curve animation. The first control point of the time curve is (0.1, 0.75) and the second is (0.85, 0.35).")
    ///
    /// - Parameters:
    ///   - p1x: The x-coordinate of the first control point of the cubic
    ///     Bézier curve.
    ///   - p1y: The y-coordinate of the first control point of the cubic
    ///     Bézier curve.
    ///   - p2x: The x-coordinate of the second control point of the cubic
    ///     Bézier curve.
    ///   - p2y: The y-coordinate of the second control point of the cubic
    ///     Bézier curve.
    ///   - duration: The length of time, expressed in seconds, the animation
    ///     takes to complete.
    /// - Returns: A cubic Bézier timing curve animation.
    public static func timingCurve(_ p1x: Double, _ p1y: Double, _ p2x: Double, _ p2y: Double, duration: TimeInterval = 0.35) -> Animation { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Animation {

    /// An interpolating spring animation that uses a damped spring
    /// model to produce values in the range [0, 1] that are then used
    /// to interpolate within the [from, to] range of the animated
    /// property. Preserves velocity across overlapping animations by
    /// adding the effects of each animation.
    ///
    /// - Parameters:
    ///   - mass: The mass of the object attached to the spring.
    ///   - stiffness: The stiffness of the spring.
    ///   - damping: The spring damping value.
    ///   - initialVelocity: the initial velocity of the spring, as
    ///     a value in the range [0, 1] representing the magnitude of
    ///     the value being animated.
    /// - Returns: a spring animation.
    public static func interpolatingSpring(mass: Double = 1.0, stiffness: Double, damping: Double, initialVelocity: Double = 0.0) -> Animation { fatalError() }

    /// An interpolating spring animation that uses a damped spring
    /// model to produce values in the range [0, 1] that are then used
    /// to interpolate within the [from, to] range of the animated
    /// property. Preserves velocity across overlapping animations by
    /// adding the effects of each animation.
    ///
    /// - Parameters:
    ///   - duration: The perceptual duration, which defines the pace of the
    ///     spring. This is approximately equal to the settling duration, but
    ///     for very bouncy springs, will be the duration of the period of
    ///     oscillation for the spring.
    ///   - bounce: How bouncy the spring should be. A value of 0 indicates
    ///     no bounces (a critically damped spring), positive values indicate
    ///     increasing amounts of bounciness up to a maximum of 1.0
    ///     (corresponding to undamped oscillation), and negative values
    ///     indicate overdamped springs with a minimum value of -1.0.
    ///   - initialVelocity: the initial velocity of the spring, as
    ///     a value in the range [0, 1] representing the magnitude of
    ///     the value being animated.
    /// - Returns: a spring animation.
    public static func interpolatingSpring(duration: TimeInterval = 0.5, bounce: Double = 0.0, initialVelocity: Double = 0.0) -> Animation { fatalError() }

    /// An interpolating spring animation that uses a damped spring
    /// model to produce values in the range [0, 1] that are then used
    /// to interpolate within the [from, to] range of the animated
    /// property. Preserves velocity across overlapping animations by
    /// adding the effects of each animation.
    ///
    /// This uses the default parameter values.
    public static var interpolatingSpring: Animation { get { fatalError() } }
}

extension Animation {

    /// Causes the animation to report logical completion after the specified
    /// duration, if it has not already logically completed.
    ///
    /// Note that the indicated duration will not cause the animation to
    /// continue running after the base animation has fully completed.
    ///
    /// If the animation is removed before the given duration is reached,
    /// logical completion will be reported immediately.
    ///
    /// - Parameters:
    ///   - duration: The duration after which the animation should  report
    ///     that it is logically complete.
    /// - Returns: An animation that reports logical completion after the
    ///   given duration.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func logicallyComplete(after duration: TimeInterval) -> Animation { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Animation {

    /// Delays the start of the animation by the specified number of seconds.
    ///
    /// Use this method to delay the start of an animation. For example, the
    /// following code animates the height change of two capsules.
    /// Animation of the first ``Capsule`` begins immediately. However,
    /// animation of the second one doesn't begin until a half second later.
    ///
    ///     struct ContentView: View {
    ///         @State private var adjustBy = 100.0
    ///
    ///         var body: some View {
    ///             VStack(spacing: 40) {
    ///                 HStack(alignment: .bottom) {
    ///                     Capsule()
    ///                         .frame(width: 50, height: 175 - adjustBy)
    ///                         .animation(.easeInOut, value: adjustBy)
    ///                     Capsule()
    ///                         .frame(width: 50, height: 175 + adjustBy)
    ///                         .animation(.easeInOut.delay(0.5), value: adjustBy)
    ///                 }
    ///
    ///                 Button("Animate") {
    ///                     adjustBy *= -1
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-15-delay.mp4", poster: "animation-15-delay.png", alt: "A video that shows two capsules side by side that animate using the ease-in ease-out animation. The capsule on the left is short, while the capsule on the right is tall. As they animate, the short capsule grows upwards to match the height of the tall capsule. Then the tall capsule shrinks to match the original height of the short capsule. Then the capsule on the left shrinks to its original height, followed by the capsule on the right growing to its original height.")
    ///
    /// - Parameter delay: The number of seconds to delay the start of the
    /// animation.
    /// - Returns: An animation with a delayed start.
    public func delay(_ delay: TimeInterval) -> Animation { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Animation {

    /// Changes the duration of an animation by adjusting its speed.
    ///
    /// Setting the speed of an animation changes the duration of the animation
    /// by a factor of `speed`. A higher speed value causes a faster animation
    /// sequence due to a shorter duration. For example, a one-second animation
    /// with a speed of `2.0` completes in half the time (half a second).
    ///
    ///     struct ContentView: View {
    ///         @State private var adjustBy = 100.0
    ///
    ///         private var oneSecondAnimation: Animation {
    ///            .easeInOut(duration: 1.0)
    ///         }
    ///
    ///         var body: some View {
    ///             VStack(spacing: 40) {
    ///                 HStack(alignment: .bottom) {
    ///                     Capsule()
    ///                         .frame(width: 50, height: 175 - adjustBy)
    ///                     Capsule()
    ///                         .frame(width: 50, height: 175 + adjustBy)
    ///                 }
    ///                 .animation(oneSecondAnimation.speed(2.0), value: adjustBy)
    ///
    ///                 Button("Animate") {
    ///                     adjustBy *= -1
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-18-speed.mp4", poster: "animation-18-speed.png", alt: "A video that shows two capsules side by side that animate using the ease-in ease-out animation. The capsule on the left is short, while the capsule on the right is tall. They animate for half a second with the short capsule growing upwards to match the height of the tall capsule. Then the tall capsule shrinks to match the original height of the short capsule. For another half second, the capsule on the left shrinks to its original height, followed by the capsule on the right growing to its original height.")
    ///
    /// Setting `speed` to a lower number slows the animation, extending its
    /// duration. For example, a one-second animation with a speed of `0.25`
    /// takes four seconds to complete.
    ///
    ///     struct ContentView: View {
    ///         @State private var adjustBy = 100.0
    ///
    ///         private var oneSecondAnimation: Animation {
    ///            .easeInOut(duration: 1.0)
    ///         }
    ///
    ///         var body: some View {
    ///             VStack(spacing: 40) {
    ///                 HStack(alignment: .bottom) {
    ///                     Capsule()
    ///                         .frame(width: 50, height: 175 - adjustBy)
    ///                     Capsule()
    ///                         .frame(width: 50, height: 175 + adjustBy)
    ///                 }
    ///                 .animation(oneSecondAnimation.speed(0.25), value: adjustBy)
    ///
    ///                 Button("Animate") {
    ///                     adjustBy *= -1
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-19-speed-slow.mp4", poster: "animation-19-speed-slow.png", alt: "A video that shows two capsules side by side that animate using the ease-in ease-out animation. The capsule on the left is short, while the right-side capsule is tall. They animate for four seconds with the short capsule growing upwards to match the height of the tall capsule. Then the tall capsule shrinks to match the original height of the short capsule. For another four seconds, the capsule on the left shrinks to its original height, followed by the capsule on the right growing to its original height.")
    ///
    /// - Parameter speed: The speed at which SkipUI performs the animation.
    /// - Returns: An animation with the adjusted speed.
    public func speed(_ speed: Double) -> Animation { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Animation {

    /// Repeats the animation for a specific number of times.
    ///
    /// Use this method to repeat the animation a specific number of times. For
    /// example, in the following code, the animation moves a truck from one
    /// edge of the view to the other edge. It repeats this animation three
    /// times.
    ///
    ///     struct ContentView: View {
    ///         @State private var driveForward = true
    ///
    ///         private var driveAnimation: Animation {
    ///             .easeInOut
    ///             .repeatCount(3, autoreverses: true)
    ///             .speed(0.5)
    ///         }
    ///
    ///         var body: some View {
    ///             VStack(alignment: driveForward ? .leading : .trailing, spacing: 40) {
    ///                 Image(systemName: "box.truck")
    ///                     .font(.system(size: 48))
    ///                     .animation(driveAnimation, value: driveForward)
    ///
    ///                 HStack {
    ///                     Spacer()
    ///                     Button("Animate") {
    ///                         driveForward.toggle()
    ///                     }
    ///                     Spacer()
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-16-repeat-count.mp4", poster: "animation-16-repeat-count.png", alt: "A video that shows a box truck moving from the leading edge of a view to the trailing edge, and back again before looping in the opposite direction.")
    ///
    /// The first time the animation runs, the truck moves from the leading
    /// edge to the trailing edge of the view. The second time the animation
    /// runs, the truck moves from the trailing edge to the leading edge
    /// because `autoreverse` is `true`. If `autoreverse` were `false`, the
    /// truck would jump back to leading edge before moving to the trailing
    /// edge. The third time the animation runs, the truck moves from the
    /// leading to the trailing edge of the view.
    ///
    /// - Parameters:
    ///   - repeatCount: The number of times that the animation repeats. Each
    ///   repeated sequence starts at the beginning when `autoreverse` is
    ///  `false`.
    ///   - autoreverses: A Boolean value that indicates whether the animation
    ///   sequence plays in reverse after playing forward. Autoreverse counts
    ///   towards the `repeatCount`. For instance, a `repeatCount` of one plays
    ///   the animation forward once, but it doesn’t play in reverse even if
    ///   `autoreverse` is `true`. When `autoreverse` is `true` and
    ///   `repeatCount` is `2`, the animation moves forward, then reverses, then
    ///   stops.
    /// - Returns: An animation that repeats for specific number of times.
    public func repeatCount(_ repeatCount: Int, autoreverses: Bool = true) -> Animation { fatalError() }

    /// Repeats the animation for the lifespan of the view containing the
    /// animation.
    ///
    /// Use this method to repeat the animation until the instance of the view
    /// no longer exists, or the view’s explicit or structural identity
    /// changes. For example, the following code continuously rotates a
    /// gear symbol for the lifespan of the view.
    ///
    ///     struct ContentView: View {
    ///         @State private var rotationDegrees = 0.0
    ///
    ///         private var animation: Animation {
    ///             .linear
    ///             .speed(0.1)
    ///             .repeatForever(autoreverses: false)
    ///         }
    ///
    ///         var body: some View {
    ///             Image(systemName: "gear")
    ///                 .font(.system(size: 86))
    ///                 .rotationEffect(.degrees(rotationDegrees))
    ///                 .onAppear {
    ///                     withAnimation(animation) {
    ///                         rotationDegrees = 360.0
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// @Video(source: "animation-17-repeat-forever.mp4", poster: "animation-17-repeat-forever.png", alt: "A video that shows a gear that continuously rotates clockwise.")
    ///
    /// - Parameter autoreverses: A Boolean value that indicates whether the
    /// animation sequence plays in reverse after playing forward.
    /// - Returns: An animation that continuously repeats.
    public func repeatForever(autoreverses: Bool = true) -> Animation { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Animation : Hashable {

    /// Calculates the current value of the animation.
    ///
    /// - Returns: The current value of the animation, or `nil` if the animation has finished.
    public func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic { fatalError() }

    /// Calculates the current velocity of the animation.
    ///
    /// - Returns: The current velocity of the animation, or `nil` if the the velocity isn't available.
    public func velocity<V>(value: V, time: TimeInterval, context: AnimationContext<V>) -> V? where V : VectorArithmetic { fatalError() }

    /// Returns a Boolean value that indicates whether the current animation
    /// should merge with a previous animation.
    public func shouldMerge<V>(previous: Animation, value: V, time: TimeInterval, context: inout AnimationContext<V>) -> Bool where V : VectorArithmetic { fatalError() }

//    public var base: CustomAnimation { get { fatalError() } }


}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Animation : CustomStringConvertible, CustomDebugStringConvertible, CustomReflectable {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get { fatalError() } }

    /// A textual representation of this instance, suitable for debugging.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(reflecting:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `debugDescription` property for types that conform to
    /// `CustomDebugStringConvertible`:
    ///
    ///     struct Point: CustomDebugStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var debugDescription: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(reflecting: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `debugDescription` property.
    public var debugDescription: String { get { fatalError() } }

    /// The custom mirror for this instance.
    ///
    /// If this type has value semantics, the mirror should be unaffected by
    /// subsequent mutations of the instance.
    public var customMirror: Mirror { get { fatalError() } }
}

/// The criteria that determines when an animation is considered finished.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct AnimationCompletionCriteria : Hashable, Sendable {

    /// The animation has logically completed, but may still be in its long
    /// tail.
    ///
    /// If a subsequent change occurs that creates additional animations on
    /// properties with `logicallyComplete` completion callbacks registered,
    /// then those callbacks will fire when the animations from the change that
    /// they were registered with logically complete, ignoring the new
    /// animations.
    public static let logicallyComplete: AnimationCompletionCriteria = { fatalError() }()

    /// The entire animation is finished and will now be removed.
    ///
    /// If a subsequent change occurs that creates additional animations on
    /// properties with `removed` completion callbacks registered, then those
    /// callbacks will only fire when *all* of the created animations are
    /// complete.
    public static let removed: AnimationCompletionCriteria = { fatalError() }()


    

}

/// Contextual values that a custom animation can use to manage state and
/// access a view's environment.
///
/// The system provides an `AnimationContext` to a ``CustomAnimation`` instance
/// so that the animation can store and retrieve values in an instance of
/// ``AnimationState``. To access these values, use the context's
/// ``AnimationContext/state`` property.
///
/// For more convenient access to state, create an ``AnimationStateKey`` and
/// extend `AnimationContext` to include a computed property that gets and
/// sets the ``AnimationState`` value. Then use this property instead of
/// ``AnimationContext/state`` to retrieve the state of a custom animation. For
/// example, the following code creates an animation state key named
/// `PausableState`. Then the code extends `AnimationContext` to include the
/// `pausableState` property:
///
///     private struct PausableState<Value: VectorArithmetic>: AnimationStateKey {
///         var paused = false
///         var pauseTime: TimeInterval = 0.0
///
///         static var defaultValue: Self { .init() }
///     }
///
///     extension AnimationContext {
///         fileprivate var pausableState: PausableState<Value> {
///             get { state[PausableState<Value>.self] }
///             set { state[PausableState<Value>.self] = newValue }
///         }
///     }
///
/// To access the pausable state, the custom animation `PausableAnimation` uses
/// the `pausableState` property instead of the ``AnimationContext/state``
/// property:
///
///     struct PausableAnimation: CustomAnimation {
///         let base: Animation
///
///         func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
///             let paused = context.environment.animationPaused
///
///             let pausableState = context.pausableState
///             var pauseTime = pausableState.pauseTime
///             if pausableState.paused != paused {
///                 pauseTime = time - pauseTime
///                 context.pausableState = PausableState(paused: paused, pauseTime: pauseTime)
///             }
///
///             let effectiveTime = paused ? pauseTime : time - pauseTime
///             let result = base.animate(value: value, time: effectiveTime, context: &context)
///             return result
///         }
///     }
///
/// The animation can also retrieve environment values of the view that created
/// the animation. To retrieve a view's environment value, use the context's
/// ``AnimationContext/environment`` property. For instance, the following code
/// creates a custom ``EnvironmentKey`` named `AnimationPausedKey`, and the
/// view `PausableAnimationView` uses the key to store the paused state:
///
///     struct AnimationPausedKey: EnvironmentKey {
///         static let defaultValue = false = { fatalError() }()
///     }
///
///     extension EnvironmentValues {
///         var animationPaused: Bool {
///             get { self[AnimationPausedKey.self] }
///             set { self[AnimationPausedKey.self] = newValue }
///         }
///     }
///
///     struct PausableAnimationView: View {
///         @State private var paused = false
///
///         var body: some View {
///             VStack {
///                 ...
///             }
///             .environment(\.animationPaused, paused)
///         }
///     }
///
/// Then the custom animation `PausableAnimation` retrieves the paused state
/// from the view's environment using the ``AnimationContext/environment``
/// property:
///
///     struct PausableAnimation: CustomAnimation {
///         func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
///             let paused = context.environment.animationPaused
///             ...
///         }
///     }
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct AnimationContext<Value> where Value : VectorArithmetic {

    /// The current state of a custom animation.
    ///
    /// An instance of ``CustomAnimation`` uses this property to read and
    /// write state values as the animation runs.
    ///
    /// An alternative to using the `state` property in a custom animation is
    /// to create an ``AnimationStateKey`` type and extend ``AnimationContext``
    /// with a custom property that returns the state as a custom type. For
    /// example, the following code creates a state key named `PausableState`.
    /// It's convenient to store state values in the key type, so the
    /// `PausableState` structure includes properties for the stored state
    /// values `paused` and `pauseTime`.
    ///
    ///     private struct PausableState<Value: VectorArithmetic>: AnimationStateKey {
    ///         var paused = false
    ///         var pauseTime: TimeInterval = 0.0
    ///
    ///         static var defaultValue: Self { .init() }
    ///     }
    ///
    /// To provide access the pausable state, the following code extends
    /// `AnimationContext` to include the `pausableState` property. This
    /// property returns an instance of the custom `PausableState` structure
    /// stored in ``AnimationContext/state``, and it can also store a new
    /// `PausableState` instance in `state`.
    ///
    ///     extension AnimationContext {
    ///         fileprivate var pausableState: PausableState<Value> {
    ///             get { state[PausableState<Value>.self] }
    ///             set { state[PausableState<Value>.self] = newValue }
    ///         }
    ///     }
    ///
    /// Now a custom animation can use the `pausableState` property instead of
    /// the ``AnimationContext/state`` property as a convenient way to read and
    /// write state values as the animation runs.
    ///
    ///     struct PausableAnimation: CustomAnimation {
    ///         func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
    ///             let pausableState = context.pausableState
    ///             var pauseTime = pausableState.pauseTime
    ///             ...
    ///         }
    ///     }
    ///
    public var state: AnimationState<Value>

    /// Set this to `true` to indicate that an animation is logically complete.
    ///
    /// This controls when AnimationCompletionCriteria.logicallyComplete
    /// completion callbacks are fired. This should be set to `true` at most
    /// once in the life of an animation, changing back to `false` later will be
    /// ignored. If this is never set to `true`, the behavior is equivalent to
    /// if this had been set to `true` just as the animation finished (by
    /// returning `nil`).
    public var isLogicallyComplete: Bool { get { fatalError() } }

    /// The current environment of the view that created the custom animation.
    ///
    /// An instance of ``CustomAnimation`` uses this property to read
    /// environment values from the view that created the animation. To learn
    /// more about environment values including how to define custom
    /// environment values, see ``EnvironmentValues``.
    public var environment: EnvironmentValues { get { fatalError() } }

    /// Creates a new context from another one with a state that you provide.
    ///
    /// Use this method to create a new context that contains the state that
    /// you provide and view environment values from the original context.
    ///
    /// - Parameter state: The initial state for the new context.
    /// - Returns: A new context that contains the specified state.
    public func withState<T>(_ state: AnimationState<T>) -> AnimationContext<T> where T : VectorArithmetic { fatalError() }
}

/// A container that stores the state for a custom animation.
///
/// An ``AnimationContext`` uses this type to store state for a
/// ``CustomAnimation``. To retrieve the stored state of a context, you can
/// use the ``AnimationContext/state`` property. However, a more convenient
/// way to access the animation state is to define an ``AnimationStateKey``
/// and extend ``AnimationContext`` with a computed property that gets
/// and sets the animation state, as shown in the following code:
///
///     private struct PausableState<Value: VectorArithmetic>: AnimationStateKey {
///         static var defaultValue: Self { .init() }
///     }
///
///     extension AnimationContext {
///         fileprivate var pausableState: PausableState<Value> {
///             get { state[PausableState<Value>.self] }
///             set { state[PausableState<Value>.self] = newValue }
///         }
///     }
///
/// When creating an ``AnimationStateKey``, it's convenient to define the
/// state values that your custom animation needs. For example, the following
/// code adds the properties `paused` and `pauseTime` to the `PausableState`
/// animation state key:
///
///     private struct PausableState<Value: VectorArithmetic>: AnimationStateKey {
///         var paused = false
///         var pauseTime: TimeInterval = 0.0
///
///         static var defaultValue: Self { .init() }
///     }
///
/// To access the pausable state in a `PausableAnimation`, the follow code
/// calls `pausableState` instead of using the context's
/// ``AnimationContext/state`` property. And because the animation state key
/// `PausableState` defines properties for state values, the custom animation
/// can read and write those values.
///
///     struct PausableAnimation: CustomAnimation {
///         let base: Animation
///
///         func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
///             let paused = context.environment.animationPaused
///
///             let pausableState = context.pausableState
///             var pauseTime = pausableState.pauseTime
///             if pausableState.paused != paused {
///                 pauseTime = time - pauseTime
///                 context.pausableState = PausableState(paused: paused, pauseTime: pauseTime)
///             }
///
///             let effectiveTime = paused ? pauseTime : time - pauseTime
///             let result = base.animate(value: value, time: effectiveTime, context: &context)
///             return result
///         }
///     }
///
/// ### Storing state for secondary animations
///
/// A custom animation can also use `AnimationState` to store the state of a
/// secondary animation. For example, the following code creates an
/// ``AnimationStateKey`` that includes the property `secondaryState`, which a
/// custom animation can use to store other state:
///
///     private struct TargetState<Value: VectorArithmetic>: AnimationStateKey {
///         var timeDelta = 0.0
///         var valueDelta = Value.zero
///         var secondaryState: AnimationState<Value>? = .init()
///
///         static var defaultValue: Self { .init() }
///     }
///
///     extension AnimationContext {
///         fileprivate var targetState: TargetState<Value> {
///             get { state[TargetState<Value>.self] }
///             set { state[TargetState<Value>.self] = newValue }
///         }
///     }
///
/// The custom animation `TargetAnimation` uses `TargetState` to store state
/// data in `secondaryState` for another animation that runs as part of the
/// target animation.
///
///     struct TargetAnimation: CustomAnimation {
///         var base: Animation
///         var secondary: Animation
///
///         func animate<V: VectorArithmetic>(value: V, time: Double, context: inout AnimationContext<V>) -> V? {
///             var targetValue = value
///             if let secondaryState = context.targetState.secondaryState {
///                 var secondaryContext = context
///                 secondaryContext.state = secondaryState
///                 let secondaryValue = value - context.targetState.valueDelta
///                 let result = secondary.animate(
///                     value: secondaryValue, time: time - context.targetState.timeDelta,
///                     context: &secondaryContext)
///                 if let result = result {
///                     context.targetState.secondaryState = secondaryContext.state
///                     targetValue = result + context.targetState.valueDelta
///                 } else {
///                     context.targetState.secondaryState = nil
///                 }
///             }
///             let result = base.animate(value: targetValue, time: time, context: &context)
///             if let result = result {
///                 targetValue = result
///             } else if context.targetState.secondaryState == nil {
///                 return nil
///             }
///             return targetValue
///     }
///
///         func shouldMerge<V: VectorArithmetic>(previous: Animation, value: V, time: Double, context: inout AnimationContext<V>) -> Bool {
///             guard let previous = previous.base as? Self else { return false }
///             var secondaryContext = context
///             if let secondaryState = context.targetState.secondaryState {
///                 secondaryContext.state = secondaryState
///                 context.targetState.valueDelta = secondary.animate(
///                     value: value, time: time - context.targetState.timeDelta,
///                     context: &secondaryContext) ?? value
///             } else {
///                 context.targetState.valueDelta = value
///             }
///             // Reset the target each time a merge occurs.
///             context.targetState.secondaryState = .init()
///             context.targetState.timeDelta = time
///             return base.shouldMerge(
///                 previous: previous.base, value: value, time: time,
///                 context: &context)
///         }
///     }
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct AnimationState<Value> where Value : VectorArithmetic {

    /// Create an empty state container.
    ///
    /// You don't typically create an instance of ``AnimationState`` directly.
    /// Instead, the ``AnimationContext`` provides the animation state to an
    /// instance of ``CustomAnimation``.
    public init() { fatalError() }

    /// Accesses the state for a custom key.
    ///
    /// Create a custom animation state value by defining a key that conforms
    /// to the ``AnimationStateKey`` protocol and provide the
    /// ``AnimationStateKey/defaultValue`` for the key. Also include properties
    /// to read and write state values that your ``CustomAnimation`` uses. For
    /// example, the following code defines a key named `PausableState` that
    /// has two state values, `paused` and `pauseTime`:
    ///
    ///     private struct PausableState<Value: VectorArithmetic>: AnimationStateKey {
    ///         var paused = false
    ///         var pauseTime: TimeInterval = 0.0
    ///
    ///         static var defaultValue: Self { .init() }
    ///     }
    ///
    /// Use that key with the subscript operator of the ``AnimationState``
    /// structure to get and set a value for the key. For more convenient
    /// access to the key value, extend ``AnimationContext`` with a computed
    /// property that gets and sets the key's value.
    ///
    ///     extension AnimationContext {
    ///         fileprivate var pausableState: PausableState<Value> {
    ///             get { state[PausableState<Value>.self] }
    ///             set { state[PausableState<Value>.self] = newValue }
    ///         }
    ///     }
    ///
    /// To access the state values in a ``CustomAnimation``, call the custom
    /// computed property, then read and write the state values that the
    /// custom ``AnimationStateKey`` provides.
    ///
    ///     struct PausableAnimation: CustomAnimation {
    ///         let base: Animation
    ///
    ///         func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
    ///             let paused = context.environment.animationPaused
    ///
    ///             let pausableState = context.pausableState
    ///             var pauseTime = pausableState.pauseTime
    ///             if pausableState.paused != paused {
    ///                 pauseTime = time - pauseTime
    ///                 context.pausableState = PausableState(paused: paused, pauseTime: pauseTime)
    ///             }
    ///
    ///             let effectiveTime = paused ? pauseTime : time - pauseTime
    ///             let result = base.animate(value: value, time: effectiveTime, context: &context)
    ///             return result
    ///         }
    ///     }
    public subscript<K>(key: K.Type) -> K.Value where K : AnimationStateKey { get { fatalError() } }
}

/// A key for accessing animation state values.
///
/// To access animation state from an ``AnimationContext`` in a custom
/// animation, create an `AnimationStateKey`. For example, the following
/// code creates an animation state key named `PausableState` and sets the
/// value for the required ``defaultValue`` property. The code also defines
/// properties for state values that the custom animation needs when
/// calculating animation values. Keeping the state values in the animation
/// state key makes it more convenient to read and write those values in the
/// implementation of a ``CustomAnimation``.
///
///     private struct PausableState<Value: VectorArithmetic>: AnimationStateKey {
///         var paused = false
///         var pauseTime: TimeInterval = 0.0
///
///         static var defaultValue: Self { .init() }
///     }
///
/// To make accessing the value of the animation state key more convenient,
/// define a property for it by extending ``AnimationContext``:
///
///     extension AnimationContext {
///         fileprivate var pausableState: PausableState<Value> {
///             get { state[PausableState<Value>.self] }
///             set { state[PausableState<Value>.self] = newValue }
///         }
///     }
///
/// Then, you can read and write your state in an instance of `CustomAnimation`
/// using the ``AnimationContext``:
///
///     struct PausableAnimation: CustomAnimation {
///         let base: Animation
///
///         func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
///             let paused = context.environment.animationPaused
///
///             let pausableState = context.pausableState
///             var pauseTime = pausableState.pauseTime
///             if pausableState.paused != paused {
///                 pauseTime = time - pauseTime
///                 context.pausableState = PausableState(paused: paused, pauseTime: pauseTime)
///             }
///
///             let effectiveTime = paused ? pauseTime : time - pauseTime
///             let result = base.animate(value: value, time: effectiveTime, context: &context)
///             return result
///         }
///     }
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol AnimationStateKey {

    /// The associated type representing the type of the animation state key's
    /// value.
    associatedtype Value

    /// The default value for the animation state key.
    static var defaultValue: Self.Value { get }
}

/// A pausable schedule of dates updating at a frequency no more quickly than
/// the provided interval.
///
/// You can also use ``TimelineSchedule/animation(minimumInterval:paused:)`` to
/// construct this schedule.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AnimationTimelineSchedule : TimelineSchedule, Sendable {

    /// Create a pausable schedule of dates updating at a frequency no more
    /// quickly than the provided interval.
    ///
    /// - Parameters:
    ///     - minimumInterval: The minimum interval to update the schedule at.
    ///     Pass nil to let the system pick an appropriate update interval.
    ///     - paused: If the schedule should stop generating updates.
    public init(minimumInterval: Double? = nil, paused: Bool = false) { fatalError() }

    /// Returns entries at the frequency of the animation schedule.
    ///
    /// When in `.lowFrequency` mode, return no entries, effectively pausing the animation.
    public func entries(from start: Date, mode: TimelineScheduleMode) -> AnimationTimelineSchedule.Entries { fatalError() }

    /// The sequence of dates within a schedule.
    ///
    /// The ``TimelineSchedule/entries(from:mode:)`` method returns a value
    /// of this type, which is a
    /// of dates in ascending order. A ``TimelineView`` that you create with a
    /// schedule updates its content at the moments in time corresponding to
    /// the dates included in the sequence.
    public struct Entries : Sequence, IteratorProtocol, Sendable {

        /// Advances to the next element and returns it, or `nil` if no next element
        /// exists.
        ///
        /// Repeatedly calling this method returns, in order, all the elements of the
        /// underlying sequence. As soon as the sequence has run out of elements, all
        /// subsequent calls return `nil`.
        ///
        /// You must not call this method if any other copy of this iterator has been
        /// advanced with a call to its `next()` method.
        ///
        /// The following example shows how an iterator can be used explicitly to
        /// emulate a `for`-`in` loop. First, retrieve a sequence's iterator, and
        /// then call the iterator's `next()` method until it returns `nil`.
        ///
        ///     let numbers = [2, 3, 5, 7]
        ///     var numbersIterator = numbers.makeIterator()
        ///
        ///     while let num = numbersIterator.next() {
        ///         print(num)
        ///     }
        ///     // Prints "2"
        ///     // Prints "3"
        ///     // Prints "5"
        ///     // Prints "7"
        ///
        /// - Returns: The next element in the underlying sequence, if a next element
        ///   exists; otherwise, `nil`.
        public mutating func next() -> Date? { fatalError() }

        /// A type representing the sequence's elements.
        public typealias Element = Date

        /// A type that provides the sequence's iteration interface and
        /// encapsulates its iteration state.
        public typealias Iterator = AnimationTimelineSchedule.Entries
    }
}

/// A type that defines how an animatable value changes over time.
///
/// Use this protocol to create a type that changes an animatable value over
/// time, which produces a custom visual transition of a view. For example, the
/// follow code changes an animatable value using an elastic ease-in ease-out
/// function:
///
///     struct ElasticEaseInEaseOutAnimation: CustomAnimation {
///         let duration: TimeInterval
///
///         func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
///             if time > duration { return nil } // The animation has finished.
///
///             let p = time / duration
///             let s = sin((20 * p - 11.125) * ((2 * Double.pi) / 4.5))
///             if p < 0.5 {
///                 return value.scaled(by: -(pow(2, 20 * p - 10) * s) / 2)
///             } else {
///                 return value.scaled(by: (pow(2, -20 * p + 10) * s) / 2 + 1)
///             }
///         }
///     }
///
/// > Note: To maintain state during the life span of a custom animation, use
/// the ``AnimationContext/state`` property available on the `context`
/// parameter value. You can also use context's
/// ``AnimationContext/environment`` property to retrieve environment values
/// from the view that created the custom animation. For more information, see
/// ``AnimationContext``.
///
/// To create an ``Animation`` instance of a custom animation, use the
/// ``Animation/init(_:)`` initializer, passing in an instance of a custom
/// animation; for example:
///
///     Animation(ElasticEaseInEaseOutAnimation(duration: 5.0))
///
/// To help make view code more readable, extend ``Animation`` and add a static
/// property and function that returns an `Animation` instance of a custom
/// animation. For example, the following code adds the static property
/// `elasticEaseInEaseOut` that returns the elastic ease-in ease-out animation
/// with a default duration of `0.35` seconds. Next, the code adds a method
/// that returns the animation with a specified duration.
///
///     extension Animation {
///         static var elasticEaseInEaseOut: Animation { elasticEaseInEaseOut(duration: 0.35) }
///         static func elasticEaseInEaseOut(duration: TimeInterval) -> Animation {
///             Animation(ElasticEaseInEaseOutAnimation(duration: duration))
///         }
///     }
///
/// To animate a view with the elastic ease-in ease-out animation, a view calls
/// either `.elasticEaseInEaseOut` or `.elasticEaseInEaseOut(duration:)`. For
/// example, the follow code includes an Animate button that, when clicked,
/// animates a circle as it moves from one edge of the view to the other,
/// using the elastic ease-in ease-out animation with a duration of `5`
/// seconds:
///
///     struct ElasticEaseInEaseOutView: View {
///         @State private var isActive = false
///
///         var body: some View {
///             VStack(alignment: isActive ? .trailing : .leading) {
///                 Circle()
///                     .frame(width: 100.0)
///                     .foregroundColor(.accentColor)
///
///                 Button("Animate") {
///                     withAnimation(.elasticEaseInEaseOut(duration: 5.0)) {
///                         isActive.toggle()
///                     }
///                 }
///                 .frame(maxWidth: .infinity)
///             }
///             .padding()
///         }
///     }
///
/// @Video(source: "animation-20-elastic.mp4", poster: "animation-20-elastic.png", alt: "A video that shows a circle that moves from one edge of the view to the other using an elastic ease-in ease-out animation. The circle's initial position is near the leading edge of the view. The circle begins moving slightly towards the leading, then towards trail edges of the view before it moves off the leading edge showing only two-thirds of the circle. The circle then moves quickly to the trailing edge of the view, going slightly beyond the edge so that only two-thirds of the circle is visible. The circle bounces back into full view before settling into position near the trailing edge of the view. The circle repeats this animation in reverse, going from the trailing edge of the view to the leading edge.")
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol CustomAnimation : Hashable {

    /// Calculates the value of the animation at the specified time.
    ///
    /// Implement this method to calculate and return the value of the
    /// animation at a given point in time. If the animation has finished,
    /// return `nil` as the value. This signals to the system that it can
    /// remove the animation.
    ///
    /// If your custom animation needs to maintain state between calls to the
    /// `animate(value:time:context:)` method, store the state data in
    /// `context`. This makes the data available to the method next time
    /// the system calls it. To learn more about managing state data in a
    /// custom animation, see ``AnimationContext``.
    ///
    /// - Parameters:
    ///   - value: The vector to animate towards.
    ///   - time: The elapsed time since the start of the animation.
    ///   - context: An instance of ``AnimationContext`` that provides access
    ///   to state and the animation environment.
    /// - Returns: The current value of the animation, or `nil` if the
    ///   animation has finished.
    func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic

    /// Calculates the velocity of the animation at a specified time.
    ///
    /// Implement this method to provide the velocity of the animation at a
    /// given time. Should subsequent animations merge with the animation,
    /// the system preserves continuity of the velocity between animations.
    ///
    /// The default implementation of this method returns `nil`.
    ///
    /// > Note: State and environment data is available to this method via the
    /// `context` parameter, but `context` is read-only. This behavior is
    /// different than with ``animate(value:time:context:)`` and
    /// ``shouldMerge(previous:value:time:context:)-7f4ts`` where `context` is
    /// an `inout` parameter, letting you change the context including state
    /// data of the animation. For more information about managing state data
    /// in a custom animation, see ``AnimationContext``.
    ///
    /// - Parameters:
    ///   - value: The vector to animate towards.
    ///   - time: The amount of time since the start of the animation.
    ///   - context: An instance of ``AnimationContext`` that provides access
    ///   to state and the animation environment.
    /// - Returns: The current velocity of the animation, or `nil` if the
    ///   animation has finished.
    func velocity<V>(value: V, time: TimeInterval, context: AnimationContext<V>) -> V? where V : VectorArithmetic

    /// Determines whether an instance of the animation can merge with other
    /// instance of the same type.
    ///
    /// When a view creates a new animation on an animatable value that already
    /// has a running animation of the same animation type, the system calls
    /// the `shouldMerge(previous:value:time:context:)` method on the new
    /// instance to determine whether it can merge the two instance. Implement
    /// this method if the animation can merge with another instance. The
    /// default implementation returns `false`.
    ///
    /// If `shouldMerge(previous:value:time:context:)` returns `true`, the
    /// system merges the new animation instance with the previous animation.
    /// The system provides to the new instance the state and elapsed time from
    /// the previous one. Then it removes the previous animation.
    ///
    /// If this method returns `false`, the system doesn't merge the animation
    /// with the previous one. Instead, both animations run together and the
    /// system combines their results.
    ///
    /// If your custom animation needs to maintain state between calls to the
    /// `shouldMerge(previous:value:time:context:)` method, store the state
    /// data in `context`. This makes the data available to the method next
    /// time the system calls it. To learn more, see ``AnimationContext``.
    ///
    /// - Parameters:
    ///   - previous: The previous running animation.
    ///   - value: The vector to animate towards.
    ///   - time: The amount of time since the start of the previous animation.
    ///   - context: An instance of ``AnimationContext`` that provides access
    ///   to state and the animation environment.
    /// - Returns: A Boolean value of `true` if the animation should merge with
    ///   the previous animation; otherwise, `false`.
    func shouldMerge<V>(previous: Animation, value: V, time: TimeInterval, context: inout AnimationContext<V>) -> Bool where V : VectorArithmetic
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CustomAnimation {

    /// Calculates the velocity of the animation at a specified time.
    ///
    /// Implement this method to provide the velocity of the animation at a
    /// given time. Should subsequent animations merge with the animation,
    /// the system preserves continuity of the velocity between animations.
    ///
    /// The default implementation of this method returns `nil`.
    ///
    /// > Note: State and environment data is available to this method via the
    /// `context` parameter, but `context` is read-only. This behavior is
    /// different than with ``animate(value:time:context:)`` and
    /// ``shouldMerge(previous:value:time:context:)-7f4ts`` where `context` is
    /// an `inout` parameter, letting you change the context including state
    /// data of the animation. For more information about managing state data
    /// in a custom animation, see ``AnimationContext``.
    ///
    /// - Parameters:
    ///   - value: The vector to animate towards.
    ///   - time: The amount of time since the start of the animation.
    ///   - context: An instance of ``AnimationContext`` that provides access
    ///   to state and the animation environment.
    /// - Returns: The current velocity of the animation, or `nil` if the
    ///   animation has finished.
    public func velocity<V>(value: V, time: TimeInterval, context: AnimationContext<V>) -> V? where V : VectorArithmetic { fatalError() }

    /// Determines whether an instance of the animation can merge with other
    /// instance of the same type.
    ///
    /// When a view creates a new animation on an animatable value that already
    /// has a running animation of the same animation type, the system calls
    /// the `shouldMerge(previous:value:time:context:)` method on the new
    /// instance to determine whether it can merge the two instance. Implement
    /// this method if the animation can merge with another instance. The
    /// default implementation returns `false`.
    ///
    /// If `shouldMerge(previous:value:time:context:)` returns `true`, the
    /// system merges the new animation instance with the previous animation.
    /// The system provides to the new instance the state and elapsed time from
    /// the previous one. Then it removes the previous animation.
    ///
    /// If this method returns `false`, the system doesn't merge the animation
    /// with the previous one. Instead, both animations run together and the
    /// system combines their results.
    ///
    /// If your custom animation needs to maintain state between calls to the
    /// `shouldMerge(previous:value:time:context:)` method, store the state
    /// data in `context`. This makes the data available to the method next
    /// time the system calls it. To learn more, see ``AnimationContext``.
    ///
    /// - Parameters:
    ///   - previous: The previous running animation.
    ///   - value: The vector to animate towards.
    ///   - time: The amount of time since the start of the previous animation.
    ///   - context: An instance of ``AnimationContext`` that provides access
    ///   to state and the animation environment.
    /// - Returns: A Boolean value of `true` if the animation should merge with
    ///   the previous animation; otherwise, `false`.
    public func shouldMerge<V>(previous: Animation, value: V, time: TimeInterval, context: inout AnimationContext<V>) -> Bool where V : VectorArithmetic { fatalError() }
}

/// A keyframe that uses a cubic curve to smoothly interpolate between values.
///
/// If you don't specify a start or end velocity, SkipUI automatically
/// computes a curve that maintains smooth motion between keyframes.
///
/// Adjacent cubic keyframes result in a Catmull-Rom spline.
///
/// If a cubic keyframe follows a different type of keyframe, such as a linear
/// keyframe, the end velocity of the segment defined by the previous keyframe
/// will be used as the starting velocity.
///
/// Likewise, if a cubic keyframe is followed by a different type of keyframe,
/// the initial velocity of the next segment is used as the end velocity of the
/// segment defined by this keyframe.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct CubicKeyframe<Value> : KeyframeTrackContent where Value : Animatable {

    /// Creates a new keyframe using the given value and timestamp.
    ///
    /// - Parameters:
    ///   - to: The value of the keyframe.
    ///   - startVelocity: The velocity of the value at the beginning of the
    ///     segment, or `nil` to automatically compute the velocity to maintain
    ///     smooth motion.
    ///   - endVelocity: The velocity of the value at the end of the segment,
    ///     or `nil` to automatically compute the velocity to maintain smooth
    ///     motion.
    ///   - duration: The duration of the segment defined by this keyframe.
    public init(_ to: Value, duration: TimeInterval, startVelocity: Value? = nil, endVelocity: Value? = nil) { fatalError() }

    public typealias Value = Value
    public typealias Body = CubicKeyframe<Value>
    public var body: Body { fatalError() }
}

/// A container that animates its content with keyframes.
///
/// The `content` closure updates every frame while
/// animating, so avoid performing any expensive operations directly within
/// `content`.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct KeyframeAnimator<Value, KeyframePath, Content> : View where Value == KeyframePath.Value, KeyframePath : Keyframes, Content : View {

    /// Plays the given keyframes when the given trigger value changes, updating
    /// the view using the modifiers you apply in `body`.
    ///
    /// Note that the `content` closure will be updated on every frame while
    /// animating, so avoid performing any expensive operations directly within
    /// `content`.
    ///
    /// If the trigger value changes while animating, the `keyframes` closure
    /// will be called with the current interpolated value, and the keyframes
    /// that you return define a new animation that replaces the old one. The
    /// previous velocity will be preserved, so cubic or spring keyframes will
    /// maintain continuity from the previous animation if they do not specify
    /// a custom initial velocity.
    ///
    /// When a keyframe animation finishes, the animator will remain at the
    /// end value, which becomes the initial value for the next animation.
    ///
    /// - Parameters:
    ///   - initialValue: The initial value that the keyframes will animate
    ///     from.
    ///   - trigger: A value to observe for changes.
    ///   - content: A view builder closure that takes the interpolated value
    ///     generated by the keyframes as its single argument.
    ///   - keyframes: Keyframes defining how the value changes over time. The
    ///     current value of the animator is the single argument, which is
    ///     equal to `initialValue` when the view first appears, then is equal
    ///     to the end value of the previous keyframe animation on subsequent
    ///     calls.
    public init(initialValue: Value, trigger: some Equatable, @ViewBuilder content: @escaping (Value) -> Content, @KeyframesBuilder<Value> keyframes: @escaping (Value) -> KeyframePath) { fatalError() }

    /// Loops the given keyframes continuously, updating
    /// the view using the modifiers you apply in `body`.
    ///
    /// Note that the `content` closure will be updated on every frame while
    /// animating, so avoid performing any expensive operations directly within
    /// `content`.
    ///
    /// - Parameters:
    ///   - initialValue: The initial value that the keyframes will animate
    ///     from.
    ///   - repeating: Whether the keyframes are currently repeating. If false,
    ///     the value at the beginning of the keyframe timeline will be
    ///     provided to the content closure.
    ///   - content: A view builder closure that takes the interpolated value
    ///     generated by the keyframes as its single argument.
    ///   - keyframes: Keyframes defining how the value changes over time. The
    ///     current value of the animator is the single argument, which is
    ///     equal to `initialValue` when the view first appears, then is equal
    ///     to the end value of the previous keyframe animation on subsequent
    ///     calls.
    public init(initialValue: Value, repeating: Bool = true, @ViewBuilder content: @escaping (Value) -> Content, @KeyframesBuilder<Value> keyframes: @escaping (Value) -> KeyframePath) { fatalError() }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A description of how a value changes over time, modeled using keyframes.
///
/// Unlike other animations in SkipUI (using ``Animation``), keyframes
/// don't interpolate between from and to values that SkipUI provides as
/// state changes. Instead, keyframes fully define the path that a value
/// takes over time using the tracks that make up their body.
///
/// `Keyframes` values are roughly analogous to video clips;
/// they have a set duration, and you can scrub and evaluate them for any
/// time within the duration.
///
/// The `Keyframes` structure also allows you to compute an interpolated
/// value at a specific time, which you can use when integrating keyframes
/// into custom use cases.
///
/// For example, you can use a `Keyframes` instance to define animations for a
/// type conforming to `Animatable:`
///
///     let keyframes = KeyframeTimeline(initialValue: CGPoint.zero) {
///         CubcKeyframe(.init(x: 0, y: 100), duration: 0.3)
///         CubicKeyframe(.init(x: 0, y: 0), duration: 0.7)
///     }
///
///     let value = keyframes.value(time: 0.45
///
/// For animations that involve multiple coordinated changes, you can include
/// multiple nested tracks:
///
///     struct Values {
///         var rotation = Angle.zero
///         var scale = 1.0
///     }
///
///     let keyframes = KeyframeTimeline(initialValue: Values()) {
///         KeyframeTrack(\.rotation) {
///             CubicKeyframe(.zero, duration: 0.2)
///             CubicKeyframe(.degrees(45), duration: 0.3)
///         }
///         KeyframeTrack(\.scale) {
///             CubicKeyframe(value: 1.2, duration: 0.5)
///             CubicKeyframe(value: 0.9, duration: 0.2)
///             CubicKeyframe(value: 1.0, duration: 0.3)
///         }
///     }
///
/// Multiple nested tracks update the initial value in the order that they are
/// declared. This means that if multiple nested plans change the same property
/// of the root value, the value from the last competing track will be used.
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct KeyframeTimeline<Value> {

    /// Creates a new instance using the initial value and content that you
    /// provide.
    public init(initialValue: Value, @KeyframesBuilder<Value> content: () -> some Keyframes<Value>) { fatalError() }

    /// The duration of the content in seconds.
    public var duration: TimeInterval { get { fatalError() } }

    /// Returns the interpolated value at the given time.
    public func value(time: Double) -> Value { fatalError() }

    /// Returns the interpolated value at the given progress in the range zero to one.
    public func value(progress: Double) -> Value { fatalError() }
}

/// A sequence of keyframes animating a single property of a root type.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct KeyframeTrack<Root, Value, Content> : Keyframes where Value == Content.Value, Content : KeyframeTrackContent {

    /// Creates an instance that animates the entire value from the root of the key path.
    ///
    /// - Parameter keyframes: A keyframe collection builder closure containing
    ///   the keyframes that control the interpolation curve.
    public init(@KeyframeTrackContentBuilder<Root> content: () -> Content) where Root == Value { fatalError() }

    /// Creates an instance that animates the property of the root value
    /// at the given key path.
    ///
    /// - Parameter keyPath: The property to animate.
    /// - Parameter keyframes: A keyframe collection builder closure containing
    ///   the keyframes that control the interpolation curve.
    public init(_ keyPath: WritableKeyPath<Root, Value>, @KeyframeTrackContentBuilder<Value> content: () -> Content) { fatalError() }

    /// The type of keyframes representing the body of this type.
    ///
    /// When you create a custom keyframes type, Swift infers this type from your
    /// implementation of the required
    /// ``Keyframes/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { return never() }
}

/// A group of keyframes that define an interpolation curve of an animatable
/// value.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol KeyframeTrackContent<Value> {

    associatedtype Value : Animatable = Self.Body.Value

    associatedtype Body : KeyframeTrackContent

    /// The composition of content that comprise the keyframe track.
//    @KeyframeTrackContentBuilder<Self.Value> var body: Self.Body { get }
}

/// The builder that creates keyframe track content from the keyframes
/// that you define within a closure.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@resultBuilder public struct KeyframeTrackContentBuilder<Value> where Value : Animatable {

    public static func buildExpression<K>(_ expression: K) -> K where Value == K.Value, K : KeyframeTrackContent { fatalError() }

//    public static func buildArray(_ components: [some KeyframeTrackContent<Value>]) -> some KeyframeTrackContent<Value> { return never() }


    public static func buildEither<First, Second>(first component: First) -> KeyframeTrackContentBuilder<Value>.Conditional<Value, First, Second> where Value == First.Value, First : KeyframeTrackContent, Second : KeyframeTrackContent, First.Value == Second.Value { fatalError() }

    public static func buildEither<First, Second>(second component: Second) -> KeyframeTrackContentBuilder<Value>.Conditional<Value, First, Second> where Value == First.Value, First : KeyframeTrackContent, Second : KeyframeTrackContent, First.Value == Second.Value { fatalError() }

    public static func buildPartialBlock<K>(first: K) -> K where Value == K.Value, K : KeyframeTrackContent { fatalError() }

//    public static func buildPartialBlock(accumulated: some KeyframeTrackContent<Value>, next: some KeyframeTrackContent<Value>) -> some KeyframeTrackContent<Value> { return never() }


    public static func buildBlock() -> Never { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension KeyframeTrackContentBuilder {

    /// A conditional result from the result builder.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public struct Conditional<ConditionalValue, First, Second> : KeyframeTrackContent where ConditionalValue == First.Value, First : KeyframeTrackContent, Second : KeyframeTrackContent, First.Value == Second.Value {
        public typealias Value = ConditionalValue
        public typealias Body = KeyframeTrackContentBuilder<Value>.Conditional<Value, First, Second>
        public var body: Body { fatalError() }
    }
}

/// A type that defines changes to a value over time.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol Keyframes<Value> {

    /// The type of value animated by this keyframes type
    associatedtype Value = Self.Body.Value

    /// The type of keyframes representing the body of this type.
    ///
    /// When you create a custom keyframes type, Swift infers this type from your
    /// implementation of the required
    /// ``Keyframes/body-swift.property`` property.
    associatedtype Body : Keyframes

    /// The composition of content that comprise the keyframes.
    @KeyframesBuilder<Self.Value> var body: Self.Body { get }
}

/// A builder that combines keyframe content values into a single value.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@resultBuilder public struct KeyframesBuilder<Value> {

    public static func buildExpression<K>(_ expression: K) -> K where Value == K.Value, K : KeyframeTrackContent { fatalError() }

//    public static func buildArray(_ components: [some KeyframeTrackContent<Value>]) -> some KeyframeTrackContent<Value> { fatalError() }


    public static func buildEither<First, Second>(first component: First) -> KeyframeTrackContentBuilder<Value>.Conditional<Value, First, Second> where Value == First.Value, First : KeyframeTrackContent, Second : KeyframeTrackContent, First.Value == Second.Value { fatalError() }

    public static func buildEither<First, Second>(second component: Second) -> KeyframeTrackContentBuilder<Value>.Conditional<Value, First, Second> where Value == First.Value, First : KeyframeTrackContent, Second : KeyframeTrackContent, First.Value == Second.Value { fatalError() }

    public static func buildPartialBlock<K>(first: K) -> K where Value == K.Value, K : KeyframeTrackContent { fatalError() }

//    public static func buildPartialBlock(accumulated: some KeyframeTrackContent<Value>, next: some KeyframeTrackContent<Value>) -> some KeyframeTrackContent<Value> { return never() }


    public static func buildBlock() -> Never where Value : Animatable { return never() }


    public static func buildFinalResult<Content>(_ component: Content) -> KeyframeTrack<Value, Value, Content> where Value == Content.Value, Content : KeyframeTrackContent { fatalError() }

    /// Keyframes
    public static func buildExpression<Content>(_ expression: Content) -> Content where Value == Content.Value, Content : Keyframes { fatalError() }

    public static func buildPartialBlock<Content>(first: Content) -> Content where Value == Content.Value, Content : Keyframes { fatalError() }

//    public static func buildPartialBlock(accumulated: some Keyframes<Value>, next: some Keyframes<Value>) -> some Keyframes<Value> { return never() }


//    public static func buildBlock() -> some Keyframes<Value> { return never() }


    public static func buildFinalResult<Content>(_ component: Content) -> Content where Value == Content.Value, Content : Keyframes { fatalError() }
}

/// A keyframe that uses simple linear interpolation.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct LinearKeyframe<Value> : KeyframeTrackContent where Value : Animatable {

    /// Creates a new keyframe using the given value and timestamp.
    ///
    /// - Parameters:
    ///   - to: The value of the keyframe.
    ///   - duration: The duration of the segment defined by this keyframe.
    ///   - timingCurve: A unit curve that controls the speed of interpolation.
    public init(_ to: Value, duration: TimeInterval, timingCurve: UnitCurve = .linear) { fatalError() }

    public typealias Value = Value
    public typealias Body = LinearKeyframe<Value>
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGPoint : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGPoint {

    public func applying(_ m: ProjectionTransform) -> CGPoint { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGSize : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGRect : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = Never // AnimatablePair<CGPoint.AnimatableData, CGSize.AnimatableData>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension UnitPoint : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Double : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = Double
    public var animatableData: AnimatableData { get { fatalError() } set { } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CGFloat : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = CGFloat
    public var animatableData: AnimatableData { get { fatalError() } set { } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EdgeInsets : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension StrokeStyle : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { } }
}

/// An empty type for animatable data.
///
/// This type is suitable for use as the `animatableData` property of
/// types that do not have any animatable properties.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct EmptyAnimatableData : VectorArithmetic {

    @inlinable public init() { fatalError() }

    /// The zero value.
    ///
    /// Zero is the identity element for addition. For any value,
    /// `x + .zero == x` and `.zero + x == x`.
    @inlinable public static var zero: EmptyAnimatableData { get { fatalError() } }

    /// Adds two values and stores the result in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    @inlinable public static func += (lhs: inout EmptyAnimatableData, rhs: EmptyAnimatableData) { fatalError() }

    /// Subtracts the second value from the first and stores the difference in the
    /// left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from `lhs`.
    @inlinable public static func -= (lhs: inout EmptyAnimatableData, rhs: EmptyAnimatableData) { fatalError() }

    /// Adds two values and produces their sum.
    ///
    /// The addition operator (`+`) calculates the sum of its two arguments. For
    /// example:
    ///
    ///     1 + 2                   // 3
    ///     -10 + 15                // 5
    ///     -15 + -5                // -20
    ///     21.5 + 3.25             // 24.75
    ///
    /// You cannot use `+` with arguments of different types. To add values of
    /// different types, convert one of the values to the other value's type.
    ///
    ///     let x: Int8 = 21
    ///     let y: Int = 1000000
    ///     Int(x) + y              // 1000021
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    @inlinable public static func + (lhs: EmptyAnimatableData, rhs: EmptyAnimatableData) -> EmptyAnimatableData { fatalError() }

    /// Subtracts one value from another and produces their difference.
    ///
    /// The subtraction operator (`-`) calculates the difference of its two
    /// arguments. For example:
    ///
    ///     8 - 3                   // 5
    ///     -10 - 5                 // -15
    ///     100 - -5                // 105
    ///     10.5 - 100.0            // -89.5
    ///
    /// You cannot use `-` with arguments of different types. To subtract values
    /// of different types, convert one of the values to the other value's type.
    ///
    ///     let x: UInt8 = 21
    ///     let y: UInt = 1000000
    ///     y - UInt(x)             // 999979
    ///
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from `lhs`.
    @inlinable public static func - (lhs: EmptyAnimatableData, rhs: EmptyAnimatableData) -> EmptyAnimatableData { fatalError() }

    /// Multiplies each component of this value by the given value.
    @inlinable public mutating func scale(by rhs: Double) { fatalError() }

    /// The dot-product of this animatable data instance with itself.
    @inlinable public var magnitudeSquared: Double { get { fatalError() } }

    
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EmptyAnimatableData : Sendable {
}

/// A container that animates its content by automatically cycling through
/// a collection of phases that you provide, each defining a discrete step
/// within an animation.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct PhaseAnimator<Phase, Content> : View where Phase : Equatable, Content : View {

    /// Cycles through the given phases when the trigger value changes,
    /// updating the view builder closure that you supply.
    ///
    /// The phases that you provide specify the individual values that will
    /// be animated to when the trigger value changes.
    ///
    /// When the view first appears, the value from the first phase is provided
    /// to the `content` closure. When the trigger value changes, the content
    /// closure is called with the value from the second phase and its
    /// corresponding animation. This continues until the last phase is
    /// reached, after which the first phase is animated to.
    ///
    /// - Parameters:
    ///   - phases: Phases defining the states that will be cycled through.
    ///     This sequence must not be empty. If an empty sequence is provided,
    ///     a visual warning will be displayed in place of this view, and a
    ///     warning will be logged.
    ///   - trigger: A value to observe for changes.
    ///   - content: A view builder closure.
    ///   - animation: A closure that returns the animation to use when
    ///     transitioning to the next phase. If `nil` is returned, the
    ///     transition will not be animated.
    public init(_ phases: some Sequence<Phase>, trigger: some Equatable, @ViewBuilder content: @escaping (Phase) -> Content, animation: @escaping (Phase) -> Animation? = { _ in .default }) { fatalError() }

    /// Cycles through the given phases continuously, updating the content
    /// using the view builder closure that you supply.
    ///
    /// The phases that you provide define the individual values that will
    /// be animated between.
    ///
    /// When the view first appears, the the first phase is provided
    /// to the `content` closure. The animator then immediately animates
    /// to the second phase, using an animation returned from the `animation`
    /// closure. This continues until the last phase is reached, after which
    /// the animator loops back to the beginning.
    ///
    /// - Parameters:
    ///   - phases: Phases defining the states that will be cycled through.
    ///     This sequence must not be empty. If an empty sequence is provided,
    ///     a visual warning will be displayed in place of this view, and a
    ///     warning will be logged.
    ///   - content: A view builder closure.
    ///   - animation: A closure that returns the animation to use when
    ///     transitioning to the next phase. If `nil` is returned, the
    ///     transition will not be animated.
    public init(_ phases: some Sequence<Phase>, @ViewBuilder content: @escaping (Phase) -> Content, animation: @escaping (Phase) -> Animation? = { _ in .default }) { fatalError() }

    @MainActor public var body: some View { get { stubView() } }

//    public typealias Body = some View
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Never : Keyframes {
}

extension Never : KeyframeTrackContent {
}

#endif
