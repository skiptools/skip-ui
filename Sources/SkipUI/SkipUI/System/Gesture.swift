// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp
#endif

public protocol Gesture<V> {
    associatedtype V
    #if SKIP
    var modified: ModifiedGesure { get }
    #endif
}

extension Gesture {
    @available(*, unavailable)
    public func exclusively(before other: any Gesture) -> any Gesture<V> {
        return self
    }

    // Skip can't distinguish between this and the other onEnded variant
//    @available(*, unavailable)
//    public func onEnded(_ action: @escaping () -> Void) -> any Gesture<V> {
//        return self
//    }

    public func onEnded(_ action: @escaping (V) -> Void) -> any Gesture<V> {
        #if SKIP
        var gesture = self.modified
        gesture.onEnded.append(action)
        return gesture
        #else
        return self
        #endif
    }

    // Skip can't distinguish between this and the other onChanged variant
//    @available(*, unavailable)
//    public func onChanged(_ action: @escaping () -> Void) -> any Gesture<V> {
//        return self
//    }

    public func onChanged(_ action: @escaping (V) -> Void) -> any Gesture<V> {
        #if SKIP
        var gesture = self.modified
        gesture.onChanged.append(action)
        return gesture
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func map(_ body: @escaping () -> Any) -> any Gesture<V> {
        return self
    }

    @available(*, unavailable)
    public func map(_ body: @escaping (Any) -> Any) -> any Gesture<V> {
        return self
    }

    @available(*, unavailable)
    public func sequenced(before other: any Gesture) -> any Gesture<V> {
        return self
    }

    @available(*, unavailable)
    public func simultaneously(with other: any Gesture) -> any Gesture<V> {
        return self
    }

    #if SKIP
    public var modified: ModifiedGesture<V> {
        return ModifiedGesture(gesture: self)
    }
    #endif
}

public struct DragGesture : Gesture {
    public typealias V = DragGesture.Value

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
}

public struct TapGesture : Gesture {
    public typealias V = Void

    public var count: Int

    public init(count: Int = 1) {
        self.count = count
    }
}

public struct LongPressGesture : Gesture {
    public typealias V = Bool

    public var minimumDuration: Double
    public var maximumDistance: CGFloat

    public init(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10.0) {
        self.minimumDuration = minimumDuration
        self.maximumDistance = maximumDistance
    }
}

public struct MagnifyGesture : Gesture {
    public typealias V = MagnifyGesture.Value

    public struct Value : Equatable, Sendable {
        public var time: Date
        public var magnification: CGFloat
        public var velocity: CGFloat
        public var startAnchor: UnitPoint
        public var startLocation: CGPoint
    }

    public var minimumScaleDelta: CGFloat

    @available(*, unavailable)
    public init(minimumScaleDelta: CGFloat = 0.01) {
        self.minimumScaleDelta = minimumScaleDelta
    }
}

public struct RotateGesture : Gesture {
    public typealias V = RotateGesture.Value

    public struct Value : Equatable, Sendable {
        public var time: Date
        public var rotation: Angle
        public var velocity: Angle
        public var startAnchor: UnitPoint
        public var startLocation: CGPoint
    }

    public var minimumAngleDelta: Angle

    @available(*, unavailable)
    public init(minimumAngleDelta: Angle = .degrees(1.0)) {
        self.minimumAngleDelta = minimumAngleDelta
    }
}

public struct SpatialEventGesture : Gesture {
    public typealias V = Void

    public let coordinateSpace: CoordinateSpaceProtocol
    public let action: (Any /* SpatialEventCollection */) -> Void

    @available(*, unavailable)
    public init(coordinateSpace: CoordinateSpaceProtocol = .local, action: @escaping (Any /* SpatialEventCollection */) -> Void) {
        self.coordinateSpace = coordinateSpace
        self.action = action
    }
}

public struct SpatialTapGesture : Gesture {
    public typealias V = SpatialTapGesture.Value

    public struct Value : Equatable, Sendable {
        public var location: CGPoint
    }

    public var count: Int
    public var coordinateSpace: CoordinateSpaceProtocol

    @available(*, unavailable)
    public init(count: Int = 1, coordinateSpace: some CoordinateSpaceProtocol = .local) {
        self.count = count
        self.coordinateSpace = coordinateSpace
    }
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
    public func gesture<V>(_ gesture: any Gesture<V>) -> some View {
        #if SKIP
        return GestureModifierView(view: self, gesture: gesture as! Gesture<Any>)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func gesture<V>(_ gesture: any Gesture<V>, including mask: GestureMask) -> some View {
        return self
    }

    @available(*, unavailable)
    public func highPriorityGesture<V>(_ gesture: any Gesture<V>, including mask: GestureMask = .all) -> some View {
        return self
    }

    public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = CGFloat(10.0), perform action: @escaping () -> Void) -> some View {
        let longPressGesture = LongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
        return gesture(longPressGesture.onEnded({ _ in action() }))
    }

    public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = CGFloat(10.0), perform action: @escaping () -> Void, onPressingChanged: @escaping (Bool) -> Void) -> some View {
        let longPressGesture = LongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
        return gesture(longPressGesture.onChanged(onPressingChanged).onEnded({ _ in action() }))
    }

    public func onTapGesture(count: Int = 1, perform action: @escaping (CGPoint) -> Void) -> some View {
        #if SKIP
        let tapGesture = TapGesture(count: count)
        var modified = tapGesture.modified
        modified.onEndedWithLocation = action
        return gesture(modified)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func onTapGesture(count: Int = 1, coordinateSpace: some CoordinateSpaceProtocol, perform action: @escaping (CGPoint) -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func simultaneousGesture<V>(_ gesture: any Gesture<V>, including mask: GestureMask = .all) -> some View {
        return self
    }
}

#if SKIP
/// A gesture that has been modified with callbacks, etc.
public struct ModifiedGesture<V> : Gesture {
    let gesture: any Gesture<V>
    var onChanged: [(V) -> Void] = []
    var onEnded: [(V) -> Void] = []
    var onEndedWithLocation: ((CGPoint) -> Void)?

    init(gesture: any Gesture<V>) {
        self.gesture = gesture
    }

    var isTapGesture: Bool {
        return (gesture as? TapGesture)?.count == 1
    }

    func onTap(at point: CGPoint) {
        onEndedWithLocation?(point)
        onEnded.forEach { $0(Void as! V) }
    }

    var isDoubleTapGesture: Bool {
        return (gesture as? TapGesture)?.count == 2
    }

    func onDoubleTap(at point: CGPoint) {
        onEndedWithLocation?(point)
        onEnded.forEach { $0(Void as! V) }
    }

    var isLongPressGesture: Bool {
        return gesture is LongPressGesture
    }

    func onLongPressChange() {
        onChanged.forEach { $0(true as! V) }
    }

    func onLongPressEnd() {
        onEnded.forEach { $0(true as! V) }
    }

    var isDragGesture: Bool {
        return gesture is DragGesture
    }

    func onDragChange(location: CGPoint, translation: CGSize) {
        let value = dragValue(location: location, translation: translation)
        onChanged.forEach { $0(value as! V) }
    }

    func onDragEnd(location: CGPoint, translation: CGSize) {
        let value = dragValue(location: location, translation: translation)
        onEnded.forEach { $0(value as! V) }
    }

    private func dragValue(location: CGPoint, translation: CGSize) -> DragGesture.Value {
        return DragGesture.Value(time: Date(), location: location, startLocation: CGPoint(x: location.x - translation.width, y: location.y - translation.height), translation: translation, velocity: .zero, predictedEndLocation: location, predictedEndTranslation: translation)
    }

    override var modified: ModifiedGesture {
        return self
    }
}

/// Modifier view that collects and executes gestures.
final class GestureModifierView: ComposeModifierView {
    var gestures: [ModifiedGesture<Any>]

    init(view: View, gesture: Gesture<Any>) {
        super.init(view: view, role: ComposeModifierRole.gesture)
        gestures = [gesture.modified]

        // Compose wants you to collect all e.g. tap gestures into a single pointerInput modifier, so we collect all our gestures
        if let wrappedGestureView = view.strippingModifiers(until: { $0 == .gesture }, perform: { $0 as? GestureModifierView }) {
            gestures += wrappedGestureView.gestures
            wrappedGestureView.gestures = []
        }
        self.action = {
            $0.modifier = addGestures(to: $0.modifier)
            return ComposeResult.ok
        }
    }

    @Composable private func addGestures(to modifier: Modifier) -> Modifier {
        guard !gestures.isEmpty else {
            return modifier
        }
        guard EnvironmentValues.shared.isEnabled else {
            return modifier
        }

        let density = LocalDensity.current
        var ret = modifier

        let tapGestures = rememberUpdatedState(gestures.filter { $0.isTapGesture })
        let doubleTapGestures = rememberUpdatedState(gestures.filter { $0.isDoubleTapGesture })
        let longPressGestures = rememberUpdatedState(gestures.filter { $0.isLongPressGesture })
        if !tapGestures.value.isEmpty || !doubleTapGestures.value.isEmpty || !longPressGestures.value.isEmpty {
            ret = ret.pointerInput(true) {
                let onDoubleTap: ((Offset) -> Void)?
                if !doubleTapGestures.value.isEmpty {
                    onDoubleTap = { offsetPx in
                        let x = with(density) { offsetPx.x.toDp() }
                        let y = with(density) { offsetPx.y.toDp() }
                        let point = CGPoint(x: CGFloat(x.value), y: CGFloat(y.value))
                        doubleTapGestures.value.forEach { $0.onDoubleTap(at: point) }
                    }
                } else {
                    onDoubleTap = nil
                }
                let onLongPress: ((Offset) -> Void)?
                if !longPressGestures.value.isEmpty {
                    onLongPress = { _ in
                        longPressGestures.value.forEach { $0.onLongPressEnd() }
                    }
                } else {
                    onLongPress = nil
                }
                detectTapGestures(onDoubleTap: onDoubleTap, onLongPress: onLongPress, onPress: { _ in
                    longPressGestures.value.forEach { $0.onLongPressChange() }
                }, onTap: { offsetPx in
                    if !tapGestures.value.isEmpty {
                        let x = with(density) { offsetPx.x.toDp() }
                        let y = with(density) { offsetPx.y.toDp() }
                        let point = CGPoint(x: CGFloat(x.value), y: CGFloat(y.value))
                        tapGestures.value.forEach { $0.onTap(at: point) }
                    }
                })
            }
        }

        let dragGestures = rememberUpdatedState(gestures.filter { $0.isDragGesture })
        if !dragGestures.value.isEmpty {
            let dragOffsetX = remember { mutableStateOf(Float(0.0)) }
            let dragOffsetY = remember { mutableStateOf(Float(0.0)) }
            let dragPositionX = remember { mutableStateOf(Float(0.0)) }
            let dragPositionY = remember { mutableStateOf(Float(0.0)) }
            ret = ret.pointerInput(true) {
                detectDragGestures(onDrag: { change, offsetPx in
                    let offsetX = with(density) { offsetPx.x.toDp() }
                    let offsetY = with(density) { offsetPx.y.toDp() }
                    dragOffsetX.value += offsetX.value
                    dragOffsetY.value += offsetY.value
                    let translation = CGSize(width: CGFloat(dragOffsetX.value), height: CGFloat(dragOffsetY.value))

                    dragPositionX.value = (with(density) { change.position.x.toDp() }).value
                    dragPositionY.value = (with(density) { change.position.y.toDp() }).value
                    let location = CGPoint(x: CGFloat(dragPositionX.value), y: CGFloat(dragPositionY.value))

                    dragGestures.value.forEach { $0.onDragChange(location: location, translation: translation) }
                }, onDragEnd: {
                    let translation = CGSize(width: CGFloat(dragOffsetX.value), height: CGFloat(dragOffsetY.value))
                    let location = CGPoint(x: CGFloat(dragPositionX.value), y: CGFloat(dragPositionY.value))
                    dragOffsetX.value = Float(0.0)
                    dragOffsetY.value = Float(0.0)
                    dragGestures.value.forEach { $0.onDragEnd(location: location, translation: translation) }
                }, onDragCancel: {
                    let translation = CGSize(width: CGFloat(dragOffsetX.value), height: CGFloat(dragOffsetY.value))
                    let location = CGPoint(x: CGFloat(dragPositionX.value), y: CGFloat(dragPositionY.value))
                    dragOffsetX.value = Float(0.0)
                    dragOffsetY.value = Float(0.0)
                    dragGestures.value.forEach { $0.onDragEnd(location: location, translation: translation) }
                })
            }
        }
        return ret
    }
}
#endif

#if false

// TODO: Process for use in SkipUI

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
import struct Foundation.Date

/// A type-erased gesture.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct AnyGesture<V> : Gesture {

    /// Creates an instance from another gesture.
    ///
    /// - Parameter gesture: A gesture that you use to create a new gesture.
    public init<T>(_ gesture: T) where V == T.V, T : Gesture { fatalError() }
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
    public func updating<State>(_ state: GestureState<State>, body: @escaping (Self.V, inout State, inout Transaction) -> Void) -> GestureStateGesture<Self, State> { fatalError() }
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
    public typealias V = Base.V

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
    @inlinable public init(base: Base, state: GestureState<State>, body: @escaping (GestureStateGesture<Base, State>.V, inout State, inout Transaction) -> Void) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Never : Gesture {

    /// The type representing the gesture's value.
    public typealias V = Never
}

/// Extends `T?` to conform to `Gesture` type if `T` also conforms to
/// `Gesture`. A nil value is mapped to an empty (i.e. failing)
/// gesture.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Optional : Gesture where Wrapped : Gesture {

    /// The type representing the gesture's value.
    public typealias V = Wrapped.V
}

#endif
