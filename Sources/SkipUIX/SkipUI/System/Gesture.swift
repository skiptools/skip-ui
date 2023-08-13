// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

import struct Foundation.Date

/// An instance that matches a sequence of events to a gesture, and returns a
/// stream of values for each of its states.
///
/// Create custom gestures by declaring types that conform to the `Gesture`
/// protocol.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol Gesture<Value> {

    /// The type representing the gesture's value.
    associatedtype Value

    /// The type of gesture representing the body of `Self`.
    associatedtype Body : Gesture

    /// The content and behavior of the gesture.
    var body: Self.Body { get }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Gesture {

    /// Sequences a gesture with another one to create a new gesture, which
    /// results in the second gesture only receiving events after the first
    /// gesture succeeds.
    ///
    /// - Parameter other: A gesture you want to combine with another gesture to
    ///   create a new, sequenced gesture.
    ///
    /// - Returns: A gesture that's a sequence of two gestures.
    @inlinable public func sequenced<Other>(before other: Other) -> SequenceGesture<Self, Other> where Other : Gesture { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Gesture {

    /// Combines a gesture with another gesture to create a new gesture that
    /// recognizes both gestures at the same time.
    ///
    /// - Parameter other: A gesture that you want to combine with your gesture
    ///   to create a new, combined gesture.
    ///
    /// - Returns: A gesture with two simultaneous gestures.
    @inlinable public func simultaneously<Other>(with other: Other) -> SimultaneousGesture<Self, Other> where Other : Gesture { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Gesture {

    /// Adds an action to perform when the gesture ends.
    ///
    /// - Parameter action: The action to perform when this gesture ends. The
    ///   `action` closure's parameter contains the final value of the gesture.
    ///
    /// - Returns: A gesture that triggers `action` when the gesture ends.
//    public func onEnded(_ action: @escaping (Self.Value) -> Void) -> _EndedGesture<Self> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Gesture where Self.Value : Equatable {

    /// Adds an action to perform when the gesture's value changes.
    ///
    /// - Parameter action: The action to perform when this gesture's value
    ///   changes. The `action` closure's parameter contains the gesture's new
    ///   value.
    ///
    /// - Returns: A gesture that triggers `action` when this gesture's value
    ///   changes.
//    public func onChanged(_ action: @escaping (Self.Value) -> Void) -> _ChangedGesture<Self> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Gesture {

    /// Returns a gesture that's the result of mapping the given closure over
    /// the gesture.
//    public func map<T>(_ body: @escaping (Self.Value) -> T) -> _MapGesture<Self, T> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Gesture {

    /// Combines two gestures exclusively to create a new gesture where only one
    /// gesture succeeds, giving precedence to the first gesture.
    ///
    /// - Parameter other: A gesture you combine with your gesture, to create a
    ///   new, combined gesture.
    ///
    /// - Returns: A gesture that's the result of combining two gestures where
    ///   only one of them can succeed. SkipUI gives precedence to the first
    ///   gesture.
    @inlinable public func exclusively<Other>(before other: Other) -> ExclusiveGesture<Self, Other> where Other : Gesture { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Gesture {

    /// Updates the provided gesture state property as the gesture's value
    /// changes.
    ///
    /// Use this callback to update transient UI state as described in
    /// <doc:Adding-Interactivity-with-Gestures>.
    ///
    /// - Parameters:
    ///   - state: A binding to a view's ``GestureState`` property.
    ///   - body: The callback that SkipUI invokes as the gesture's value
    ///     changes. Its `currentState` parameter is the updated state of the
    ///     gesture. The `gestureState` parameter is the previous state of the
    ///     gesture, and the `transaction` is the context of the gesture.
    ///
    /// - Returns: A version of the gesture that updates the provided `state` as
    ///   the originating gesture's value changes and that resets the `state`
    ///   to its initial value when the user or the system ends or cancels the
    ///   gesture.
    @inlinable public func updating<State>(_ state: GestureState<State>, body: @escaping (Self.Value, inout State, inout Transaction) -> Void) -> GestureStateGesture<Self, State> { fatalError() }
}

/// Options that control how adding a gesture to a view affects other gestures
/// recognized by the view and its subviews.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct GestureMask : OptionSet {

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public let rawValue: UInt32

    /// Creates a new option set from the given raw value.
    ///
    /// This initializer always succeeds, even if the value passed as `rawValue`
    /// exceeds the static properties declared as part of the option set. This
    /// example creates an instance of `ShippingOptions` with a raw value beyond
    /// the highest element, with a bit mask that effectively contains all the
    /// declared static members.
    ///
    ///     let extraOptions = ShippingOptions(rawValue: 255)
    ///     print(extraOptions.isStrictSuperset(of: .all))
    ///     // Prints "true"
    ///
    /// - Parameter rawValue: The raw value of the option set to create. Each bit
    ///   of `rawValue` potentially represents an element of the option set,
    ///   though raw values may include bits that are not defined as distinct
    ///   values of the `OptionSet` type.
    public init(rawValue: UInt32) { fatalError() }

    /// Disable all gestures in the subview hierarchy, including the added
    /// gesture.
    public static let none: GestureMask = { fatalError() }()

    /// Enable the added gesture but disable all gestures in the subview
    /// hierarchy.
    public static let gesture: GestureMask = { fatalError() }()

    /// Enable all gestures in the subview hierarchy but disable the added
    /// gesture.
    public static let subviews: GestureMask = { fatalError() }()

    /// Enable both the added gesture as well as all other gestures on the view
    /// and its subviews.
    public static let all: GestureMask = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = GestureMask

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = GestureMask

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = UInt32
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension GestureMask : Sendable {
}

/// A property wrapper type that updates a property while the user performs a
/// gesture and resets the property back to its initial state when the gesture
/// ends.
///
/// Declare a property as `@GestureState`, pass as a binding to it as a
/// parameter to a gesture's ``Gesture/updating(_:body:)`` callback, and receive
/// updates to it. A property that's declared as `@GestureState` implicitly
/// resets when the gesture becomes inactive, making it suitable for tracking
/// transient state.
///
/// Add a long-press gesture to a ``Circle``, and update the interface during
/// the gesture by declaring a property as `@GestureState`:
///
///     struct SimpleLongPressGestureView: View {
///         @GestureState private var isDetectingLongPress = false
///
///         var longPress: some Gesture {
///             LongPressGesture(minimumDuration: 3)
///                 .updating($isDetectingLongPress) { currentState, gestureState, transaction in
///                     gestureState = currentState
///                 }
///         }
///
///         var body: some View {
///             Circle()
///                 .fill(self.isDetectingLongPress ? Color.red : Color.green)
///                 .frame(width: 100, height: 100, alignment: .center)
///                 .gesture(longPress)
///         }
///     }
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper @frozen public struct GestureState<Value> : DynamicProperty {

    /// Creates a view state that's derived from a gesture.
    ///
    /// - Parameter wrappedValue: A wrapped value for the gesture state
    ///   property.
    public init(wrappedValue: Value) { fatalError() }

    /// Creates a view state that's derived from a gesture with an initial
    /// value.
    ///
    /// - Parameter initialValue: An initial value for the gesture state
    ///   property.
    public init(initialValue: Value) { fatalError() }

    /// Creates a view state that's derived from a gesture with a wrapped state
    /// value and a transaction to reset it.
    ///
    /// - Parameters:
    ///   - wrappedValue: A wrapped value for the gesture state property.
    ///   - resetTransaction: A transaction that provides metadata for view
    ///     updates.
    public init(wrappedValue: Value, resetTransaction: Transaction) { fatalError() }

    /// Creates a view state that's derived from a gesture with an initial state
    /// value and a transaction to reset it.
    ///
    /// - Parameters:
    ///   - initialValue: An initial state value.
    ///   - resetTransaction: A transaction that provides metadata for view
    ///     updates.
    public init(initialValue: Value, resetTransaction: Transaction) { fatalError() }

    /// Creates a view state that's derived from a gesture with a wrapped state
    /// value and a closure that provides a transaction to reset it.
    ///
    /// - Parameters:
    ///   - wrappedValue: A wrapped value for the gesture state property.
    ///   - reset: A closure that provides a ``Transaction``.
    public init(wrappedValue: Value, reset: @escaping (Value, inout Transaction) -> Void) { fatalError() }

    /// Creates a view state that's derived from a gesture with an initial state
    /// value and a closure that provides a transaction to reset it.
    ///
    /// - Parameters:
    ///   - initialValue: An initial state value.
    ///   - reset: A closure that provides a ``Transaction``.
    public init(initialValue: Value, reset: @escaping (Value, inout Transaction) -> Void) { fatalError() }

    /// The wrapped value referenced by the gesture state property.
    public var wrappedValue: Value { get { fatalError() } }

    /// A binding to the gesture state property.
    public var projectedValue: GestureState<Value> { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension GestureState where Value : ExpressibleByNilLiteral {

    /// Creates a view state that's derived from a gesture with a transaction to
    /// reset it.
    ///
    /// - Parameter resetTransaction: A transaction that provides metadata for
    ///   view updates.
    public init(resetTransaction: Transaction = Transaction()) { fatalError() }

    /// Creates a view state that's derived from a gesture with a closure that
    /// provides a transaction to reset it.
    ///
    /// - Parameter reset: A closure that provides a ``Transaction``.
    public init(reset: @escaping (Value, inout Transaction) -> Void) { fatalError() }
}

/// A gesture that updates the state provided by a gesture's updating callback.
///
/// A gesture's ``Gesture/updating(_:body:)`` callback returns a
/// `GestureStateGesture` instance for updating a transient state property
/// that's annotated with the ``GestureState`` property wrapper.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct GestureStateGesture<Base, State> : Gesture where Base : Gesture {

    /// The type representing the gesture's value.
    public typealias Value = Base.Value

    /// The originating gesture.
    public var base: Base { get { fatalError() } }

    /// A value that changes as the user performs the gesture.
    public var state: GestureState<State>

    /// The updating gesture containing the originating gesture's value, the
    /// updated state of the gesture, and a transaction.
//    public var body: (GestureStateGesture<Base, State>.Value, inout State, inout Transaction) -> Void { get { fatalError() } }

    /// Creates a new gesture that's the result of an ongoing gesture.
    ///
    /// - Parameters:
    ///   - base: The originating gesture.
    ///   - state: The wrapped value of a ``GestureState`` property.
    ///   - body: The callback that SkipUI invokes as the gesture's value
    ///     changes.
    @inlinable public init(base: Base, state: GestureState<State>, body: @escaping (GestureStateGesture<Base, State>.Value, inout State, inout Transaction) -> Void) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A gesture that succeeds when the user performs a long press.
///
/// To recognize a long-press gesture on a view, create and configure the
/// gesture, then add it to the view using the ``View/gesture(_:including:)``
/// modifier.
///
/// Add a long-press gesture to a ``Circle`` to animate its color from blue to
/// red, and then change it to green when the gesture ends:
///
///     struct LongPressGestureView: View {
///         @GestureState private var isDetectingLongPress = false
///         @State private var completedLongPress = false
///
///         var longPress: some Gesture {
///             LongPressGesture(minimumDuration: 3)
///                 .updating($isDetectingLongPress) { currentState, gestureState,
///                         transaction in
///                     gestureState = currentState
///                     transaction.animation = Animation.easeIn(duration: 2.0)
///                 }
///                 .onEnded { finished in
///                     self.completedLongPress = finished
///                 }
///         }
///
///         var body: some View {
///             Circle()
///                 .fill(self.isDetectingLongPress ?
///                     Color.red :
///                     (self.completedLongPress ? Color.green : Color.blue))
///                 .frame(width: 100, height: 100, alignment: .center)
///                 .gesture(longPress)
///         }
///     }
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 14.0, *)
public struct LongPressGesture : Gesture {

    /// The minimum duration of the long press that must elapse before the
    /// gesture succeeds.
    public var minimumDuration: Double { get { fatalError() } }

    /// The maximum distance that the long press can move before the gesture
    /// fails.
    @available(tvOS, unavailable)
    public var maximumDistance: CGFloat { get { fatalError() } }

    /// Creates a long-press gesture with a minimum duration and a maximum
    /// distance that the interaction can move before the gesture fails.
    ///
    /// - Parameters:
    ///   - minimumDuration: The minimum duration of the long press that must
    ///     elapse before the gesture succeeds.
    ///   - maximumDistance: The maximum distance that the fingers or cursor
    ///     performing the long press can move before the gesture fails.
    @available(tvOS, unavailable)
    public init(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10) { fatalError() }

    /// The type representing the gesture's value.
    public typealias Value = Bool

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "MagnifyGesture")
@available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "MagnifyGesture")
@available(watchOS, unavailable)
@available(tvOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "MagnifyGesture")
public struct MagnificationGesture : Gesture {

    /// The minimum required delta before the gesture starts.
    public var minimumScaleDelta: CGFloat { get { fatalError() } }

    /// Creates a magnification gesture with a given minimum delta for the
    /// gesture to start.
    ///
    /// - Parameter minimumScaleDelta: The minimum scale delta required before
    ///   the gesture starts.
    public init(minimumScaleDelta: CGFloat = 0.01) { fatalError() }

    /// The type representing the gesture's value.
    public typealias Value = CGFloat

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A gesture that recognizes a magnification motion and tracks the amount of
/// magnification.
///
/// A magnify gesture tracks how a magnification event sequence changes.
/// To recognize a magnify gesture on a view, create and configure the
/// gesture, and then add it to the view using the
/// ``View/gesture(_:including:)`` modifier.
///
/// Add a magnify gesture to a ``Circle`` that changes its size while the
/// user performs the gesture:
///
///     struct MagnifyGestureView: View {
///         @GestureState private var magnifyBy = 1.0
///
///         var magnification: some Gesture {
///             MagnifyGesture()
///                 .updating($magnifyBy) { value, gestureState, transaction in
///                     gestureState = value.magnification
///                 }
///         }
///
///         var body: some View {
///             Circle()
///                 .frame(width: 100, height: 100)
///                 .scaleEffect(magnifyBy)
///                 .gesture(magnification)
///         }
///     }
///
@available(iOS 17.0, macOS 14.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct MagnifyGesture : Gesture {

    /// The type representing the gesture's value.
    public struct Value : Equatable, Sendable {

        /// The time associated with the gesture's current event.
        public var time: Date { get { fatalError() } }

        /// The relative amount that the gesture has magnified by.
        ///
        /// A value of 2.0 means that the user has interacted with the gesture
        /// to increase the magnification by a factor of 2 more than before the
        /// gesture.
        public var magnification: CGFloat { get { fatalError() } }

        /// The current magnification velocity.
        public var velocity: CGFloat { get { fatalError() } }

        /// The initial anchor point of the gesture in the modified view's
        /// coordinate space.
        public var startAnchor: UnitPoint { get { fatalError() } }

        /// The initial center of the gesture in the modified view's coordinate
        /// space.
        public var startLocation: CGPoint { get { fatalError() } }

        
    }

    /// The minimum required delta before the gesture starts.
    public var minimumScaleDelta: CGFloat { get { fatalError() } }

    /// Creates a magnify gesture with a given minimum delta for the
    /// gesture to start.
    ///
    /// - Parameter minimumScaleDelta: The minimum scale delta required before
    ///   the gesture starts.
    public init(minimumScaleDelta: CGFloat = 0.01) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A gesture that recognizes a rotation motion and tracks the angle of the
/// rotation.
///
/// A rotate gesture tracks how a rotation event sequence changes. To
/// recognize a rotate gesture on a view, create and configure the gesture,
/// and then add it to the view using the ``View/gesture(_:including:)``
/// modifier.
///
/// Add a rotate gesture to a ``Rectangle`` and apply a rotation effect:
///
///     struct RotateGestureView: View {
///         @State private var angle = Angle(degrees: 0.0)
///
///         var rotation: some Gesture {
///             RotateGesture()
///                 .onChanged { value in
///                     angle = value.rotation
///                 }
///         }
///
///         var body: some View {
///             Rectangle()
///                 .frame(width: 200, height: 200, alignment: .center)
///                 .rotationEffect(angle)
///                 .gesture(rotation)
///         }
///     }
@available(iOS 17.0, macOS 14.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct RotateGesture : Gesture {

    /// The type representing the gesture's value.
    public struct Value : Equatable, Sendable {

        /// The time associated with the gesture's current event.
        public var time: Date { get { fatalError() } }

        /// The relative amount that the gesture has rotated by.
        ///
        /// A value of 30 degrees means that the user has interacted with the
        /// gesture to rotate by 30 degrees relative to the amount before the
        /// gesture.
        public var rotation: Angle { get { fatalError() } }

        /// The current rotation velocity.
        public var velocity: Angle { get { fatalError() } }

        /// The initial anchor point of the gesture in the modified view's
        /// coordinate space.
        public var startAnchor: UnitPoint { get { fatalError() } }

        /// The initial center of the gesture in the modified view's coordinate
        /// space.
        public var startLocation: CGPoint { get { fatalError() } }

        
    }

    /// The minimum delta required before the gesture succeeds.
    public var minimumAngleDelta: Angle { get { fatalError() } }

    /// Creates a rotation gesture with a minimum delta for the gesture to
    /// start.
    ///
    /// - Parameter minimumAngleDelta: The minimum delta required before the
    ///   gesture starts. The default value is a one-degree angle.
    public init(minimumAngleDelta: Angle = .degrees(1)) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "RotateGesture")
@available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "RotateGesture")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "RotateGesture")
public struct RotationGesture : Gesture {

    /// The minimum delta required before the gesture succeeds.
    public var minimumAngleDelta: Angle { get { fatalError() } }

    /// Creates a rotation gesture with a minimum delta for the gesture to
    /// start.
    ///
    /// - Parameter minimumAngleDelta: The minimum delta required before the
    ///   gesture starts. The default value is a one-degree angle.
    public init(minimumAngleDelta: Angle = .degrees(1)) { fatalError() }

    /// The type representing the gesture's value.
    public typealias Value = Angle

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A gesture that activates immediately upon receiving any spatial event that describes
/// clicks, touches, or pinches.
///
/// Use the `action` closure to handle the collection
/// of events that target this gesture's view. The `phase` of
/// the events in the collection may move to `ended` or `cancelled` while
/// the gesture itself remains active. Individually track state for each `Event`
/// inside the `action` closure. The following shows a `SpatialEventGesture` that emits
/// particles in a simulation:
///
/// ```
/// struct ParticlePlayground: View {
///     @StateObject
///     var model = ParticlesModel()
///     var body: some View {
///         Canvas { context, size in
///             for p in model.particles {
///                 drawParticle(p, in: context)
///             }
///         }.gesture(SpatialEventGesture { events in
///             for event in events {
///                 if event.phase == .active {
///                     // Update a particle emitter at each active event's location.
///                     model.emitters[event.id] = ParticlesModel.Emitter(
///                         location: event.location
///                     )
///                 } else {
///                     // Clear out emitter state when the event is no longer active.
///                     model.emitters[event.id] = nil
///                 }
///             }
///         })
///     }
/// }
/// ```
@available(xrOS 1.0, iOS 17.0, macOS 14.0, watchOS 10.0, *)
@available(tvOS, unavailable)
public struct SpatialEventGesture : Gesture {

    /// Creates the gesture with a desired coordinate space and a handler
    /// that triggers when any event state changes.
    public init(coordinateSpace: CoordinateSpaceProtocol = .local, action: @escaping (SpatialEventCollection) -> Void) { fatalError() }

    /// The type representing the gesture's value.
    public typealias Value = Void

    /// The coordinate space of the gesture.
    public let coordinateSpace: CoordinateSpace = { fatalError() }()

    /// The action to call when the state of any event changes.
    public let action: (SpatialEventCollection) -> Void = { fatalError() }()

//    public var internalBody: some Gesture<()> { get { fatalError() } }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A gesture that recognizes one or more taps and reports their location.
///
/// To recognize a tap gesture on a view, create and configure the gesture, and
/// then add it to the view using the ``View/gesture(_:including:)`` modifier.
/// The following code adds a tap gesture to a ``Circle`` that toggles the color
/// of the circle based on the tap location:
///
///     struct TapGestureView: View {
///         @State private var location: CGPoint = .zero
///
///         var tap: some Gesture {
///             SpatialTapGesture()
///                 .onEnded { event in
///                     self.location = event.location
///                  }
///         }
///
///         var body: some View {
///             Circle()
///                 .fill(self.location.y > 50 ? Color.blue : Color.red)
///                 .frame(width: 100, height: 100, alignment: .center)
///                 .gesture(tap)
///         }
///     }
@available(iOS 16.0, macOS 13.0, watchOS 9.0, xrOS 1.0, *)
@available(tvOS, unavailable)
public struct SpatialTapGesture : Gesture {

    /// The attributes of a tap gesture.
    public struct Value : Equatable, @unchecked Sendable {

        /// The location of the tap gesture's current event.
        public var location: CGPoint { get { fatalError() } }

        
    }

    /// The required number of tap events.
    public var count: Int { get { fatalError() } }

    /// The coordinate space in which to receive location values.
    public var coordinateSpace: CoordinateSpace { get { fatalError() } }

    /// Creates a tap gesture with the number of required taps and the
    /// coordinate space of the gesture's location.
    ///
    /// - Parameters:
    ///   - count: The required number of taps to complete the tap
    ///     gesture.
    ///   - coordinateSpace: The coordinate space of the tap gesture's location.
    @available(iOS, introduced: 16.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(macOS, introduced: 13.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(watchOS, introduced: 9.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(tvOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    public init(count: Int = 1, coordinateSpace: CoordinateSpace = .local) { fatalError() }

    /// Creates a tap gesture with the number of required taps and the
    /// coordinate space of the gesture's location.
    ///
    /// - Parameters:
    ///   - count: The required number of taps to complete the tap
    ///     gesture.
    ///   - coordinateSpace: The coordinate space of the tap gesture's location.
    @available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init(count: Int = 1, coordinateSpace: some CoordinateSpaceProtocol = .local) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A gesture that recognizes one or more taps.
///
/// To recognize a tap gesture on a view, create and configure the gesture, and
/// then add it to the view using the ``View/gesture(_:including:)`` modifier.
/// The following code adds a tap gesture to a ``Circle`` that toggles the color
/// of the circle:
///
///     struct TapGestureView: View {
///         @State private var tapped = false
///
///         var tap: some Gesture {
///             TapGesture(count: 1)
///                 .onEnded { _ in self.tapped = !self.tapped }
///         }
///
///         var body: some View {
///             Circle()
///                 .fill(self.tapped ? Color.blue : Color.red)
///                 .frame(width: 100, height: 100, alignment: .center)
///                 .gesture(tap)
///         }
///     }
@available(iOS 13.0, macOS 10.15, tvOS 16.0, watchOS 6.0, *)
public struct TapGesture : Gesture {
    public var body: Never


    /// The required number of tap events.
    public var count: Int { get { fatalError() } }

    /// Creates a tap gesture with the number of required taps.
    ///
    /// - Parameter count: The required number of taps to complete the tap
    ///   gesture.
    public init(count: Int = 1) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView

    /// The type representing the gesture's value.
    public typealias Value = Void
}

/// A dragging motion that invokes an action as the drag-event sequence changes.
///
/// To recognize a drag gesture on a view, create and configure the gesture, and
/// then add it to the view using the ``View/gesture(_:including:)`` modifier.
///
/// Add a drag gesture to a ``Circle`` and change its color while the user
/// performs the drag gesture:
///
///     struct DragGestureView: View {
///         @State private var isDragging = false
///
///         var drag: some Gesture {
///             DragGesture()
///                 .onChanged { _ in self.isDragging = true }
///                 .onEnded { _ in self.isDragging = false }
///         }
///
///         var body: some View {
///             Circle()
///                 .fill(self.isDragging ? Color.red : Color.blue)
///                 .frame(width: 100, height: 100, alignment: .center)
///                 .gesture(drag)
///         }
///     }
@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
public struct DragGesture : Gesture {

    /// The attributes of a drag gesture.
    public struct Value : Equatable, Sendable {

        /// The time associated with the drag gesture's current event.
        public var time: Date { get { fatalError() } }

        /// The location of the drag gesture's current event.
        public var location: CGPoint { get { fatalError() } }

        /// The location of the drag gesture's first event.
        public var startLocation: CGPoint { get { fatalError() } }

        /// The total translation from the start of the drag gesture to the
        /// current event of the drag gesture.
        ///
        /// This is equivalent to `location.{x,y} - startLocation.{x,y}`.
        public var translation: CGSize { get { fatalError() } }

        /// The current drag velocity.
        public var velocity: CGSize { get { fatalError() } }

        /// A prediction, based on the current drag velocity, of where the final
        /// location will be if dragging stopped now.
        public var predictedEndLocation: CGPoint { get { fatalError() } }

        /// A prediction, based on the current drag velocity, of what the final
        /// translation will be if dragging stopped now.
        public var predictedEndTranslation: CGSize { get { fatalError() } }

        
    }

    /// The minimum dragging distance before the gesture succeeds.
    public var minimumDistance: CGFloat { get { fatalError() } }

    /// The coordinate space in which to receive location values.
    public var coordinateSpace: CoordinateSpace { get { fatalError() } }

    /// Creates a dragging gesture with the minimum dragging distance before the
    /// gesture succeeds and the coordinate space of the gesture's location.
    ///
    /// - Parameters:
    ///   - minimumDistance: The minimum dragging distance for the gesture to
    ///     succeed.
    ///   - coordinateSpace: The coordinate space of the dragging gesture's
    ///     location.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(tvOS, unavailable)
    public init(minimumDistance: CGFloat = 10, coordinateSpace: CoordinateSpace = .local) { fatalError() }

    /// Creates a dragging gesture with the minimum dragging distance before the
    /// gesture succeeds and the coordinate space of the gesture's location.
    ///
    /// - Parameters:
    ///   - minimumDistance: The minimum dragging distance for the gesture to
    ///     succeed.
    ///   - coordinateSpace: The coordinate space of the dragging gesture's
    ///     location.
    @available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
    @available(tvOS, unavailable)
    public init(minimumDistance: CGFloat = 10, coordinateSpace: some CoordinateSpaceProtocol = .local) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A gesture containing two gestures that can happen at the same time with
/// neither of them preceding the other.
///
/// A simultaneous gesture is a container-event handler that evaluates its two
/// child gestures at the same time. Its value is a struct with two optional
/// values, each representing the phases of one of the two gestures.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct SimultaneousGesture<First, Second> : Gesture where First : Gesture, Second : Gesture {

    /// The value of a simultaneous gesture that indicates which of its two
    /// gestures receives events.
    @frozen public struct Value {

        /// The value of the first gesture.
        public var first: First.Value?

        /// The value of the second gesture.
        public var second: Second.Value?
    }

    /// The first of two gestures that can happen simultaneously.
    public var first: First { get { fatalError() } }

    /// The second of two gestures that can happen simultaneously.
    public var second: Second { get { fatalError() } }

    /// Creates a gesture with two gestures that can receive updates or succeed
    /// independently of each other.
    ///
    /// - Parameters:
    ///   - first: The first of two gestures that can happen simultaneously.
    ///   - second: The second of two gestures that can happen simultaneously.
    @inlinable public init(_ first: First, _ second: Second) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SimultaneousGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SimultaneousGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {

    
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SimultaneousGesture.Value : Hashable where First.Value : Hashable, Second.Value : Hashable {


}

/// A gesture that's a sequence of two gestures.
///
/// Read <doc:Composing-SkipUI-Gestures> to learn how you can create a sequence
/// of two gestures.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct SequenceGesture<First, Second> : Gesture where First : Gesture, Second : Gesture {

    /// The value of a sequence gesture that helps to detect whether the first
    /// gesture succeeded, so the second gesture can start.
    @frozen public enum Value {

        /// The first gesture hasn't ended.
        case first(First.Value)

        /// The first gesture has ended.
        case second(First.Value, Second.Value?)
    }

    /// The first gesture in a sequence of two gestures.
    public var first: First { get { fatalError() } }

    /// The second gesture in a sequence of two gestures.
    public var second: Second { get { fatalError() } }

    /// Creates a sequence gesture with two gestures.
    ///
    /// - Parameters:
    ///   - first: The first gesture of the sequence.
    ///   - second: The second gesture of the sequence.
    @inlinable public init(_ first: First, _ second: Second) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SequenceGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SequenceGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {

    
}

/// A gesture that consists of two gestures where only one of them can succeed.
///
/// The `ExclusiveGesture` gives precedence to its first gesture.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct ExclusiveGesture<First, Second> : Gesture where First : Gesture, Second : Gesture {

    /// The value of an exclusive gesture that indicates which of two gestures
    /// succeeded.
    @frozen public enum Value {

        /// The first of two gestures succeeded.
        case first(First.Value)

        /// The second of two gestures succeeded.
        case second(Second.Value)
    }

    /// The first of two gestures.
    public var first: First { get { fatalError() } }

    /// The second of two gestures.
    public var second: Second { get { fatalError() } }

    /// Creates a gesture from two gestures where only one of them succeeds.
    ///
    /// - Parameters:
    ///   - first: The first of two gestures. This gesture has precedence over
    ///     the other gesture.
    ///   - second: The second of two gestures.
    @inlinable public init(_ first: First, _ second: Second) { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ExclusiveGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ExclusiveGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {

    
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Never : Gesture {

    /// The type representing the gesture's value.
    public typealias Value = Never
}

/// Extends `T?` to conform to `Gesture` type if `T` also conforms to
/// `Gesture`. A nil value is mapped to an empty (i.e. failing)
/// gesture.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Optional : Gesture where Wrapped : Gesture {

    /// The type representing the gesture's value.
    public typealias Value = Wrapped.Value

    public typealias Body = NeverView
    public var body: Never { return never() }
}


#endif
