// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp
#endif

// Erase the generic to facilitate specialization.
// SKIP DECLARE: interface Gesture
public protocol Gesture<Value> {
    #if !SKIP
    associatedtype Value
    associatedtype Body : Gesture
    var body: Self.Body { get }
    #endif
}

extension Gesture {
    @available(*, unavailable)
    public func exclusively(before other: any Gesture) -> any Gesture {
        return self
    }

    @available(*, unavailable)
    public func onEnded(_ action: @escaping () -> Void) -> any Gesture {
        return self
    }

    @available(*, unavailable)
    public func onEnded(_ action: @escaping (Any) -> Void) -> any Gesture {
        return self
    }

    @available(*, unavailable)
    public func onChanged(_ action: @escaping () -> Void) -> any Gesture {
        return self
    }

    @available(*, unavailable)
    public func onChanged(_ action: @escaping (Any) -> Void) -> any Gesture {
        return self
    }

    @available(*, unavailable)
    public func map(_ body: @escaping () -> Any) -> any Gesture {
        return self
    }

    @available(*, unavailable)
    public func map(_ body: @escaping (Any) -> Any) -> any Gesture {
        return self
    }

    @available(*, unavailable)
    public func sequenced(before other: any Gesture) -> any Gesture {
        return self
    }

    @available(*, unavailable)
    public func simultaneously(with other: any Gesture) -> any Gesture {
        return self
    }
}

public struct DragGesture : Gesture {
    public struct Value : Equatable, Sendable {
        public var time: Date
        public var location: CGPoint
        public var startLocation: CGPoint
        public var translation: CGSize
        public var velocity: CGSize
        public var predictedEndLocation: CGPoint
        public var predictedEndTranslation: CGSize
    }

    public var minimumDistance: CGFloat
    public var coordinateSpace: CoordinateSpaceProtocol

    public init(minimumDistance: CGFloat = 10.0, coordinateSpace: some CoordinateSpaceProtocol = .local) {
        self.minimumDistance = minimumDistance
        self.coordinateSpace = coordinateSpace
    }

    #if !SKIP
    public var body: some Gesture {
        return self
    }
    #endif
}

public struct TapGesture : Gesture {
    public var count: Int

    public init(count: Int = 1) {
        self.count = count
    }

    #if !SKIP
    public typealias Value = Void

    public var body: some Gesture {
        return self
    }
    #endif
}

public struct LongPressGesture : Gesture {
    public var minimumDuration: Double
    public var maximumDistance: CGFloat

    public init(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10.0) {
        self.minimumDuration = minimumDuration
        self.maximumDistance = maximumDistance
    }

    #if !SKIP
    public typealias Value = Bool

    public var body: some Gesture {
        return self
    }
    #endif
}

public struct MagnifyGesture : Gesture {
    public struct Value : Equatable, Sendable {
        public var time: Date
        public var magnification: CGFloat
        public var velocity: CGFloat
        public var startAnchor: UnitPoint
        public var startLocation: CGPoint
    }

    public var minimumScaleDelta: CGFloat

    public init(minimumScaleDelta: CGFloat = 0.01) {
        self.minimumScaleDelta = minimumScaleDelta
    }

    #if !SKIP
    public var body: some Gesture {
        return self
    }
    #endif
}

public struct RotateGesture : Gesture {
    public struct Value : Equatable, Sendable {
        public var time: Date
        public var rotation: Angle
        public var velocity: Angle
        public var startAnchor: UnitPoint
        public var startLocation: CGPoint
    }

    public var minimumAngleDelta: Angle

    public init(minimumAngleDelta: Angle = .degrees(1.0)) {
        self.minimumAngleDelta = minimumAngleDelta
    }

    #if !SKIP
    public var body: some Gesture {
        return self
    }
    #endif
}

public struct SpatialEventGesture : Gesture {
    public let coordinateSpace: CoordinateSpaceProtocol
    public let action: (Any /* SpatialEventCollection */) -> Void

    public init(coordinateSpace: CoordinateSpaceProtocol = .local, action: @escaping (Any /* SpatialEventCollection */) -> Void) {
        self.coordinateSpace = coordinateSpace
        self.action = action
    }

    #if !SKIP
    public typealias Value = Void

    public var body: some Gesture {
        return self
    }
    #endif
}

public struct SpatialTapGesture : Gesture {
    public struct Value : Equatable, Sendable {
        public var location: CGPoint
    }

    public var count: Int
    public var coordinateSpace: CoordinateSpaceProtocol

    public init(count: Int = 1, coordinateSpace: some CoordinateSpaceProtocol = .local) {
        self.count = count
        self.coordinateSpace = coordinateSpace
    }

    #if !SKIP
    public var body: some Gesture {
        return self
    }
    #endif
}

public struct GestureMask : OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let none = GestureMask(rawValue: 1)
    public static let gesture = GestureMask(rawValue: 2)
    public static let subviews = GestureMask(rawValue: 4)
    public static let all = GestureMask(rawValue: 7)
}

extension View {
    @available(*, unavailable)
    public func gesture(_ gesture: any Gesture) -> some View {
        return self
    }

    @available(*, unavailable)
    public func gesture(_ gesture: any Gesture, including mask: GestureMask) -> some View {
        return self
    }

    @available(*, unavailable)
    public func highPriorityGesture(_ gesture: any Gesture, including mask: GestureMask = .all) -> some View {
        return self
    }

    public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = CGFloat(10.0), perform action: @escaping () -> Void) -> some View {
        #if SKIP
        return GestureModifierView(contextView: self, longPressAction: action)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = CGFloat(10.0), perform action: @escaping () -> Void, onPressingChanged: (Bool) -> Void) -> some View {
        return self
    }

    public func onTapGesture(count: Int = 1, perform action: @escaping (CGPoint) -> Void) -> some View {
        #if SKIP
        if count == 1 {
            return GestureModifierView(contextView: self, tapAction: action)
        } else if count == 2 {
            return GestureModifierView(contextView: self, doubleTapAction: action)
        } else {
            return self
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func onTapGesture(count: Int = 1, coordinateSpace: some CoordinateSpaceProtocol, perform action: @escaping (CGPoint) -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func simultaneousGesture<T>(_ gesture: any Gesture, including mask: GestureMask = .all) -> some View {
        return self
    }
}

#if SKIP
class GestureModifierView: ComposeModifierView {
    var tapAction: ((CGPoint) -> Void)?
    var doubleTapAction: ((CGPoint) -> Void)?
    var longPressAction: (() -> Void)?

    init(contextView: View, tapAction: ((CGPoint) -> Void)? = nil, doubleTapAction: ((CGPoint) -> Void)? = nil, longPressAction: (() -> Void)? = nil) {
        super.init(contextView: contextView, role: ComposeModifierRole.gesture, contextTransform: { _ in })
        // Compose doesn't support multiple pointerInput modifiers, so combine them into this view
        let wrappedGestureView = contextView.strippingModifiers(until: { $0 == .gesture }, perform: { $0 as? GestureModifierView })
        self.tapAction = tapAction ?? wrappedGestureView?.tapAction
        self.doubleTapAction = doubleTapAction ?? wrappedGestureView?.doubleTapAction
        self.longPressAction = longPressAction ?? wrappedGestureView?.longPressAction
        wrappedGestureView?.tapAction = nil
        wrappedGestureView?.doubleTapAction = nil
        wrappedGestureView?.longPressAction = nil

        self.contextTransform = { $0.modifier = addGestures(to: $0.modifier) }
    }

    @Composable private func addGestures(to modifier: Modifier) -> Modifier {
        guard tapAction != nil || doubleTapAction != nil || longPressAction != nil else {
             return modifier
        }
        guard EnvironmentValues.shared.isEnabled else {
            return modifier
        }
        let density = LocalDensity.current
        return modifier.pointerInput(true) {
             let onDoubleTap: ((Offset) -> Void)? = if let doubleTapAction {
                 { offset in
                     let x = with(density) { offset.x.toDp() }
                     let y = with(density) { offset.y.toDp() }
                     doubleTapAction(CGPoint(x: CGFloat(x.value), y: CGFloat(y.value)))
                 }
             } else {
                 nil
             }
             let onLongPress: ((Offset) -> Void)? = if let longPressAction {
                 { _ in longPressAction() }
             } else {
                 nil
             }
             detectTapGestures(onDoubleTap: onDoubleTap, onLongPress: onLongPress) { offset in
                 if let tapAction {
                     let x = with(density) { offset.x.toDp() }
                     let y = with(density) { offset.y.toDp() }
                     tapAction(CGPoint(x: CGFloat(x.value), y: CGFloat(y.value)))
                 }
             }
         }
    }
}
#endif

#if !SKIP

// TODO: Process for use in SkipUI

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
import struct Foundation.Date

/// A type-erased gesture.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct AnyGesture<Value> : Gesture {

    /// Creates an instance from another gesture.
    ///
    /// - Parameter gesture: A gesture that you use to create a new gesture.
    public init<T>(_ gesture: T) where Value == T.Value, T : Gesture { fatalError() }

    /// The type of gesture representing the body of `Self`.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
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
    public func updating<State>(_ state: GestureState<State>, body: @escaping (Self.Value, inout State, inout Transaction) -> Void) -> GestureStateGesture<Self, State> { fatalError() }
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

    //public typealias Body = Never
    public var body: some Gesture { return self }
}

#endif
