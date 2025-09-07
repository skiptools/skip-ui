// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.gestures.awaitEachGesture
import androidx.compose.foundation.gestures.awaitFirstDown
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.gestures.detectTransformGestures
import androidx.compose.foundation.gestures.drag
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.input.pointer.PointerEventPass
import androidx.compose.ui.input.pointer.PointerInputChange
import androidx.compose.ui.input.pointer.PointerInputScope
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.input.pointer.positionChange
import androidx.compose.ui.layout.LayoutCoordinates
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalDensity
import org.burnoutcrew.reorderable.awaitPointerSlopOrCancellation
import kotlin.math.abs
#endif

public protocol Gesture<V> : BridgedGesture {
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

// SKIP @bridge
public protocol BridgedGesture {
}

extension BridgedGesture {
    // SKIP @bridge
    public func onChangedBool(bridgedAction: @escaping (Bool) -> Void) -> any BridgedGesture {
        return (self as! any Gesture<Bool>).onChanged(bridgedAction)
    }

    // SKIP @bridge
    public func onEndedBool(bridgedAction: @escaping (Bool) -> Void) -> any BridgedGesture {
        return (self as! any Gesture<Bool>).onEnded(bridgedAction)
    }

    // SKIP @bridge
    public func onChangedCGFloat(bridgedAction: @escaping (CGFloat) -> Void) -> any BridgedGesture {
        return (self as! any Gesture<CGFloat>).onChanged(bridgedAction)
    }

    // SKIP @bridge
    public func onEndedCGFloat(bridgedAction: @escaping (CGFloat) -> Void) -> any BridgedGesture {
        return (self as! any Gesture<CGFloat>).onEnded(bridgedAction)
    }

    // SKIP @bridge
    public func onChangedDragGestureValue(bridgedAction: @escaping (DragGestureValue) -> Void) -> any BridgedGesture {
        let action: (DragGesture.Value) -> Void = { bridgedAction(DragGestureValue($0)) }
        return (self as! any Gesture<DragGesture.Value>).onChanged(action)
    }

    // SKIP @bridge
    public func onEndedDragGestureValue(bridgedAction: @escaping (DragGestureValue) -> Void) -> any BridgedGesture {
        let action: (DragGesture.Value) -> Void = { bridgedAction(DragGestureValue($0)) }
        return (self as! any Gesture<DragGesture.Value>).onEnded(action)
    }

    // SKIP @bridge
    public func onChangedMagnifyGestureValue(bridgedAction: @escaping (MagnifyGestureValue) -> Void) -> any BridgedGesture {
        let action: (MagnifyGesture.Value) -> Void = { bridgedAction(MagnifyGestureValue($0)) }
        return (self as! any Gesture<MagnifyGesture.Value>).onChanged(action)
    }

    // SKIP @bridge
    public func onEndedMagnifyGestureValue(bridgedAction: @escaping (MagnifyGestureValue) -> Void) -> any BridgedGesture {
        let action: (MagnifyGesture.Value) -> Void = { bridgedAction(MagnifyGestureValue($0)) }
        return (self as! any Gesture<MagnifyGesture.Value>).onEnded(action)
    }

    // SKIP @bridge
    public func onChangedRotateGestureValue(bridgedAction: @escaping (RotateGestureValue) -> Void) -> any BridgedGesture {
        let action: (RotateGesture.Value) -> Void = { bridgedAction(RotateGestureValue($0)) }
        return (self as! any Gesture<RotateGesture.Value>).onChanged(action)
    }

    // SKIP @bridge
    public func onEndedRotateGestureValue(bridgedAction: @escaping (RotateGestureValue) -> Void) -> any BridgedGesture {
        let action: (RotateGesture.Value) -> Void = { bridgedAction(RotateGestureValue($0)) }
        return (self as! any Gesture<RotateGesture.Value>).onEnded(action)
    }

    // SKIP @bridge
    public func onChangedVoid(bridgedAction: @escaping () -> Void) -> any BridgedGesture {
        #if SKIP
        let action: (Unit) -> Void = { _ in bridgedAction() }
        return (self as! any Gesture<Unit>).onChanged(action)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func onEndedVoid(bridgedAction: @escaping () -> Void) -> any BridgedGesture {
        #if SKIP
        let action: (Unit) -> Void = { _ in bridgedAction() }
        return (self as! any Gesture<Unit>).onEnded(action)
        #else
        return self
        #endif
    }
}

// SKIP @bridge
public struct DragGesture : Gesture, BridgedGesture {
    public typealias V = DragGesture.Value

    public struct Value : Equatable {
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

    // SKIP @bridge
    public init(minimumDistance: CGFloat, bridgedCoordinateSpace: Int, name: Any?) {
        self.minimumDistance = minimumDistance
        self.coordinateSpace = CoordinateSpaceProtocolFrom(bridged: bridgedCoordinateSpace, name: name as? AnyHashable)
    }
}

// SKIP @bridge
public struct DragGestureValue {
    // SKIP @bridge
    public let time: Double
    // SKIP @bridge
    public let locationX: CGFloat
    // SKIP @bridge
    public let locationY: CGFloat
    // SKIP @bridge
    public let startLocationX: CGFloat
    // SKIP @bridge
    public let startLocationY: CGFloat
    // SKIP @bridge
    public let velocityWidth: CGFloat
    // SKIP @bridge
    public let velocityHeight: CGFloat
    // SKIP @bridge
    public let predictedEndLocationX: CGFloat
    // SKIP @bridge
    public let predictedEndLocationY: CGFloat

    init(_ value: DragGesture.Value) {
        self.time = value.time.timeIntervalSinceReferenceDate
        self.locationX = value.location.x
        self.locationY = value.location.y
        self.startLocationX = value.startLocation.x
        self.startLocationY = value.startLocation.y
        self.velocityWidth = value.velocity.width
        self.velocityHeight = value.velocity.height
        self.predictedEndLocationX = value.predictedEndLocation.x
        self.predictedEndLocationY = value.predictedEndLocation.y
    }
}

// SKIP @bridge
public struct TapGesture : Gesture, BridgedGesture {
    public typealias V = Void

    public var count: Int
    public var coordinateSpace: CoordinateSpaceProtocol

    public init(count: Int = 1, coordinateSpace: some CoordinateSpaceProtocol = .local) {
        self.count = count
        self.coordinateSpace = coordinateSpace
    }

    // SKIP @bridge
    public init(count: Int, bridgedCoordinateSpace: Int, name: Any?) {
        self.count = count
        self.coordinateSpace = CoordinateSpaceProtocolFrom(bridged: bridgedCoordinateSpace, name: name as? AnyHashable)
    }
}

// SKIP @bridge
public struct LongPressGesture : Gesture, BridgedGesture {
    public typealias V = Bool

    public var minimumDuration: Double
    public var maximumDistance: CGFloat

    // SKIP @bridge
    public init(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10.0) {
        self.minimumDuration = minimumDuration
        self.maximumDistance = maximumDistance
    }
}

// SKIP @bridge
public struct MagnifyGesture : Gesture, BridgedGesture {
    public typealias V = MagnifyGesture.Value

    public struct Value : Equatable {
        public var time: Date
        public var magnification: CGFloat
        public var velocity: CGFloat
        public var startAnchor: UnitPoint
        public var startLocation: CGPoint
    }

    public var minimumScaleDelta: CGFloat

    // SKIP @bridge
    public init(minimumScaleDelta: CGFloat = 0.01) {
        self.minimumScaleDelta = minimumScaleDelta
    }
}

// SKIP @bridge
public struct MagnifyGestureValue {
    // SKIP @bridge
    public let time: Double
    // SKIP @bridge
    public let magnification: CGFloat
    // SKIP @bridge
    public let velocity: CGFloat
    // SKIP @bridge
    public let startAnchorX: Double
    // SKIP @bridge
    public let startAnchorY: Double
    // SKIP @bridge
    public let startLocationX: CGFloat
    // SKIP @bridge
    public let startLocationY: CGFloat

    init(_ value: MagnifyGesture.Value) {
        self.time = value.time.timeIntervalSinceReferenceDate
        self.magnification = value.magnification
        self.velocity = value.velocity
        self.startAnchorX = value.startAnchor.x
        self.startAnchorY = value.startAnchor.y
        self.startLocationX = value.startLocation.x
        self.startLocationY = value.startLocation.y
    }
}

// SKIP @bridge
public struct RotateGesture : Gesture, BridgedGesture {
    public typealias V = RotateGesture.Value

    public struct Value : Equatable {
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

    // SKIP @bridge
    public init(minimumAngleDegreesDelta: Double) {
        self.minimumAngleDelta = .degrees(minimumAngleDegreesDelta)
    }
}

// SKIP @bridge
public struct RotateGestureValue {
    // SKIP @bridge
    public let time: Double
    // SKIP @bridge
    public let rotationDegrees: Double
    // SKIP @bridge
    public let velocityDegrees: Double
    // SKIP @bridge
    public let startAnchorX: Double
    // SKIP @bridge
    public let startAnchorY: Double
    // SKIP @bridge
    public let startLocationX: CGFloat
    // SKIP @bridge
    public let startLocationY: CGFloat

    init(_ value: RotateGesture.Value) {
        self.time = value.time.timeIntervalSinceReferenceDate
        self.rotationDegrees = value.rotation.degrees
        self.velocityDegrees = value.velocity.degrees
        self.startAnchorX = value.startAnchor.x
        self.startAnchorY = value.startAnchor.y
        self.startLocationX = value.startLocation.x
        self.startLocationY = value.startLocation.y
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

    public struct Value : Equatable {
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

public struct GestureMask : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let none: GestureMask = []
    @available(*, unavailable)
    public static let gesture = GestureMask(rawValue: 1) // For bridging
    @available(*, unavailable)
    public static let subviews = GestureMask(rawValue: 2) // For bridging
    public static let all = GestureMask(rawValue: 3) // For bridging
}

extension View {
    public func gesture<V>(_ gesture: any Gesture<V>, including mask: GestureMask = .all) -> any View {
        // We only support a mask of `.all` or `.none`
        return self.gesture(gesture, isEnabled: !mask.isEmpty)
    }

    public func gesture<V>(_ gesture: any Gesture<V>, isEnabled: Bool) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: GestureModifier(gesture: gesture as! Gesture<Any>, isEnabled: isEnabled))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func bridgedGesture(_ gesture: Any, isEnabled: Bool) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: GestureModifier(gesture: gesture as! Gesture<Any>, isEnabled: isEnabled))
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func highPriorityGesture<V>(_ gesture: any Gesture<V>, including mask: GestureMask = .all) -> some View {
        return self
    }

    @available(*, unavailable)
    public func highPriorityGesture<V>(_ gesture: any Gesture<V>, isEnabled: Bool) -> some View {
        return self
    }

    // SKIP @bridge
    public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = CGFloat(10.0), perform action: @escaping () -> Void) -> any View {
        let longPressGesture = LongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
        return gesture(longPressGesture.onEnded({ _ in action() }))
    }

    // SKIP @bridge
    public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = CGFloat(10.0), perform action: @escaping () -> Void, onPressingChanged: @escaping (Bool) -> Void) -> any View {
        let longPressGesture = LongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
        return gesture(longPressGesture.onChanged(onPressingChanged).onEnded({ _ in action() }))
    }

    public func onTapGesture(count: Int = 1, coordinateSpace: some CoordinateSpaceProtocol = .local, perform action: @escaping (CGPoint) -> Void) -> any View {
        #if SKIP
        let tapGesture = TapGesture(count: count, coordinateSpace: coordinateSpace)
        var modified = tapGesture.modified
        modified.onEndedWithLocation = action
        return gesture(modified)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func onTapGesture(count: Int, bridgedCoordinateSpace: Int, name: Any?, perform action: @escaping (CGFloat, CGFloat) -> Void) -> any View {
        let coordinateSpace = CoordinateSpaceProtocolFrom(bridged: bridgedCoordinateSpace, name: name as? AnyHashable)
        return onTapGesture(count: count, coordinateSpace: coordinateSpace, perform: { p in action(p.x, p.y) })
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
    let coordinateSpace: CoordinateSpace
    var onChanged: [(V) -> Void] = []
    var onEnded: [(V) -> Void] = []
    var onEndedWithLocation: ((CGPoint) -> Void)?

    init(gesture: any Gesture<V>) {
        self.gesture = gesture
        self.coordinateSpace = (gesture as? TapGesture)?.coordinateSpace.coordinateSpace ?? (gesture as? DragGesture)?.coordinateSpace.coordinateSpace ?? CoordinateSpace.local
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

    var minimumDistance: CGFloat {
        return (gesture as? DragGesture)?.minimumDistance ?? 0.0
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

    var isMagnifyGesture: Bool {
        return gesture is MagnifyGesture
    }

    func onMagnifyChange(magnification: CGFloat, location: CGPoint, translation: CGSize) {
        let value = magnifyValue(magnification: magnification, location: location, translation: translation)
        onChanged.forEach { $0(value as! V) }
    }

    func onMagnifyEnd(magnification: CGFloat, location: CGPoint, translation: CGSize) {
        let value = magnifyValue(magnification: magnification, location: location, translation: translation)
        onEnded.forEach { $0(value as! V) }
    }

    private func magnifyValue(magnification: CGFloat, location: CGPoint, translation: CGSize) -> MagnifyGesture.Value {
        return MagnifyGesture.Value(time: Date(), magnification: magnification, velocity: 0.0, startAnchor: UnitPoint(x: 0.0, y: 0.0), startLocation: CGPoint(x: location.x - translation.width, y: location.y - translation.height))
    }

    var isRotateGesture: Bool {
        return gesture is RotateGesture
    }

    func onRotateChange(rotation: Double, location: CGPoint, translation: CGSize) {
        let value = rotateValue(rotation: rotation, location: location, translation: translation)
        onChanged.forEach { $0(value as! V) }
    }

    func onRotateEnd(rotation: Double, location: CGPoint, translation: CGSize) {
        let value = rotateValue(rotation: rotation, location: location, translation: translation)
        onEnded.forEach { $0(value as! V) }
    }

    private func rotateValue(rotation: Double, location: CGPoint, translation: CGSize) -> RotateGesture.Value {
        return RotateGesture.Value(time: Date(), rotation: .degrees(rotation), velocity: .degrees(0.0), startAnchor: UnitPoint(x: 0.0, y: 0.0), startLocation: CGPoint(x: location.x - translation.width, y: location.y - translation.height))
    }

    override var modified: ModifiedGesture {
        return self
    }
}

/// Modifier view that collects and executes gestures.
final class GestureModifier: RenderModifier {
    let gesture: ModifiedGesture<Any>?
    var isConsumed = false

    init(gesture: Gesture<Any>, isEnabled: Bool) {
        self.gesture = isEnabled ? gesture.modified : nil
        super.init()
        self.action = { renderable, context in
            var context = context
            context.modifier = addGestures(for: renderable, to: context.modifier)
            renderable.Render(context: context)
        }
    }

    @Composable private func addGestures(for renderable: Renderable, to modifier: Modifier) -> Modifier {
        guard !isConsumed else {
            return modifier
        }
        guard EnvironmentValues.shared.isEnabled else {
            return modifier
        }

        // Compose wants you to collect all e.g. tap gestures into a single pointerInput modifier, so we collect all our gestures
        let gestures: kotlin.collections.MutableList<ModifiedGesture<Any>> = mutableListOf()
        if let gesture {
            gestures.add(gesture)
        }
        renderable.forEachModifier {
            guard let gestureModifier = $0 as? GestureModifier else {
                return nil
            }
            if let gesture = gestureModifier.gesture {
                gestures.add(gesture)
            }
            gestureModifier.isConsumed = true
            return nil
        }

        let density = LocalDensity.current
        var ret = modifier
        
        // If the gesture is placed directly on a shape, we attempt to constrain hits to the shape
        if let shape = renderable.strip() as? ModifiedShape, renderable.forEachModifier(perform: { $0.role != .accessibility && !($0 is GestureModifier) ? true : nil }) == nil, let touchShape = shape.asComposeTouchShape(density: density) {
            ret = ret.clip(touchShape)
        }

        let layoutCoordinates = remember { mutableStateOf<LayoutCoordinates?>(nil) }
        ret = ret.onGloballyPositioned { layoutCoordinates.value = $0 }

        let tapGestures = rememberUpdatedState(gestures.filter { $0.isTapGesture })
        let doubleTapGestures = rememberUpdatedState(gestures.filter { $0.isDoubleTapGesture })
        let longPressGestures = rememberUpdatedState(gestures.filter { $0.isLongPressGesture })
        if tapGestures.value.size > 0 || doubleTapGestures.value.size > 0 || longPressGestures.value.size > 0 {
            ret = ret.pointerInput(true) {
                let onDoubleTap: ((Offset) -> Void)?
                if doubleTapGestures.value.size > 0 {
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
                if longPressGestures.value.size > 0 {
                    onLongPress = { _ in
                        longPressGestures.value.forEach { $0.onLongPressEnd() }
                    }
                } else {
                    onLongPress = nil
                }
                detectTapGestures(onDoubleTap: onDoubleTap, onLongPress: onLongPress, onPress: { _ in
                    longPressGestures.value.forEach { $0.onLongPressChange() }
                }, onTap: { localOffsetPx in
                    for tapGesture in tapGestures.value {
                        var offsetPx = localOffsetPx
                        if tapGesture.coordinateSpace.isGlobal, let layoutCoordinates = layoutCoordinates.value {
                            offsetPx = layoutCoordinates.localToRoot(offsetPx)
                        }
                        let x = with(density) { offsetPx.x.toDp() }
                        let y = with(density) { offsetPx.y.toDp() }
                        let point = CGPoint(x: CGFloat(x.value), y: CGFloat(y.value))
                        tapGesture.onTap(at: point)
                    }
                })
            }
        }

        let dragGestures = rememberUpdatedState(gestures.filter { $0.isDragGesture })
        if dragGestures.value.size > 0 {
            let dragOffsetX = remember { mutableStateOf(Float(0.0)) }
            let dragOffsetY = remember { mutableStateOf(Float(0.0)) }
            let dragPositionPx = remember { mutableStateOf(Offset(x: Float(0.0), y: Float(0.0))) }
            let noMinimumDistance = dragGestures.value.any { $0.minimumDistance <= 0.0 }
            let scrollAxes = EnvironmentValues.shared._scrollAxes
            ret = ret.pointerInput(scrollAxes) {
                let onDrag: (PointerInputChange, Offset) -> Void = { change, offsetPx in
                    let offsetX = with(density) { offsetPx.x.toDp() }
                    let offsetY = with(density) { offsetPx.y.toDp() }
                    dragOffsetX.value += offsetX.value
                    dragOffsetY.value += offsetY.value
                    let translation = CGSize(width: CGFloat(dragOffsetX.value), height: CGFloat(dragOffsetY.value))

                    dragPositionPx.value = change.position
                    for dragGesture in dragGestures.value {
                        var positionPx = change.position
                        if dragGesture.coordinateSpace.isGlobal, let layoutCoordinates = layoutCoordinates.value {
                            positionPx = layoutCoordinates.localToRoot(positionPx)
                        }
                        let positionX = (with(density) { positionPx.x.toDp() }).value
                        let positionY = (with(density) { positionPx.y.toDp() }).value
                        let location = CGPoint(x: CGFloat(positionX), y: CGFloat(positionY))
                        dragGesture.onDragChange(location: location, translation: translation)
                    }
                }
                let onDragEnd: () -> Void = {
                    let translation = CGSize(width: CGFloat(dragOffsetX.value), height: CGFloat(dragOffsetY.value))
                    dragOffsetX.value = Float(0.0)
                    dragOffsetY.value = Float(0.0)
                    for dragGesture in dragGestures.value {
                        var positionPx = dragPositionPx.value
                        if dragGesture.coordinateSpace.isGlobal, let layoutCoordinates = layoutCoordinates.value {
                            positionPx = layoutCoordinates.localToRoot(positionPx)
                        }
                        let positionX = (with(density) { positionPx.x.toDp() }).value
                        let positionY = (with(density) { positionPx.y.toDp() }).value
                        let location = CGPoint(x: CGFloat(positionX), y: CGFloat(positionY))
                        dragGesture.onDragEnd(location: location, translation: translation)
                    }
                }
                detectDragGesturesWithScrollAxes(onDrag: onDrag, onDragEnd: onDragEnd, onDragCancel: onDragEnd, shouldAwaitTouchSlop: { !noMinimumDistance }, scrollAxes: scrollAxes)
            }
        }

        let magnifyGestures = rememberUpdatedState(gestures.filter { $0.isMagnifyGesture })
        let rotateGestures = rememberUpdatedState(gestures.filter { $0.isRotateGesture })
        if magnifyGestures.value.size > 0 || rotateGestures.value.size > 0 {
            let magnification = remember { mutableStateOf(Float(1.0)) }
            let rotation = remember { mutableStateOf(Float(0.0)) }
            let panOffsetX = remember { mutableStateOf(Float(0.0)) }
            let panOffsetY = remember { mutableStateOf(Float(0.0)) }
            let locationX = remember { mutableStateOf(Float(0.0)) }
            let locationY = remember { mutableStateOf(Float(0.0)) }
            let hasMagnified = remember { mutableStateOf(false) }
            let hasRotated = remember { mutableStateOf(false) }
            ret = ret.pointerInput(true) {
                detectTransformGesturesWithGestureEnd(panZoomLock: false, onGesture: { centroidPx, panPx, zoom, rotate in
                    if zoom != Float(1.0) {
                        hasMagnified.value = true
                    }
                    if rotate != Float(0.0) {
                        hasRotated.value = true
                    }
                    if !hasMagnified.value && !hasRotated.value {
                        return
                    }

                    panOffsetX.value = (with(density) { panPx.x.toDp() }).value
                    panOffsetY.value = (with(density) { panPx.y.toDp() }).value
                    let translation = CGSize(width: CGFloat(panOffsetX.value), height: CGFloat(panOffsetY.value))

                    locationX.value = (with(density) { centroidPx.x.toDp() }).value
                    locationY.value = (with(density) { centroidPx.y.toDp() }).value
                    let location = CGPoint(x: CGFloat(locationX.value), y: CGFloat(locationY.value))

                    if hasMagnified.value {
                        magnification.value *= zoom
                        for magnifyGesture in magnifyGestures.value {
                            magnifyGesture.onMagnifyChange(magnification: CGFloat(magnification.value), location: location, translation: translation)
                        }
                    }
                    if hasRotated.value {
                        rotation.value += rotate
                        for rotateGesture in rotateGestures.value {
                            rotateGesture.onRotateChange(rotation: Double(rotation.value), location: location, translation: translation)
                        }
                    }
                }, onGestureEnd: {
                    if !hasMagnified.value && !hasRotated.value {
                        return
                    }
                    let translation = CGSize(width: CGFloat(panOffsetX.value), height: CGFloat(panOffsetY.value))
                    let location = CGPoint(x: CGFloat(locationX.value), y: CGFloat(locationY.value))
                    if hasMagnified.value {
                        for magnifyGesture in magnifyGestures.value {
                            magnifyGesture.onMagnifyEnd(magnification: CGFloat(magnification.value), location: location, translation: translation)
                        }
                    }
                    if hasRotated.value {
                        for rotateGesture in rotateGestures.value {
                            rotateGesture.onRotateEnd(rotation: Double(rotation.value), location: location, translation: translation)
                        }
                    }

                    magnification.value = Float(1.0)
                    rotation.value = Float(0.0)
                    panOffsetX.value = Float(0.0)
                    panOffsetY.value = Float(0.0)
                    locationX.value = Float(0.0)
                    locationY.value = Float(0.0)
                    hasMagnified.value = false
                    hasRotated.value = false
                })
            }
        }
        return ret
    }
}

// This is an adaptation of the internal Compose function here: https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/gestures/DragGestureDetector.kt
// SKIP DECLARE: suspend fun PointerInputScope.detectDragGesturesWithScrollAxes(onDrag: (PointerInputChange, Offset) -> Unit, onDragEnd: () -> Unit, onDragCancel: () -> Unit, shouldAwaitTouchSlop: () -> Boolean, scrollAxes: Axis.Set)
func detectDragGesturesWithScrollAxes(onDragEnd: () -> Void, onDragCancel: () -> Void, onDrag: (PointerInputChange, Offset) -> Void, shouldAwaitTouchSlop: () -> Bool, scrollAxes: Axis.Set) {
    var overSlop: Offset
    awaitEachGesture {
        let initialDown = awaitFirstDown(requireUnconsumed: false, pass: PointerEventPass.Initial)
        let awaitTouchSlop = shouldAwaitTouchSlop()
        if (!awaitTouchSlop) {
            initialDown.consume()
        }
        let down = awaitFirstDown(requireUnconsumed: false)
        var drag: PointerInputChange?
        overSlop = Offset.Zero
        if (awaitTouchSlop) {
            repeat {
                drag = awaitPointerSlopOrCancellation(down.id, down.type) { change, over in
                    if scrollAxes == Axis.Set.vertical {
                        if abs(over.x) > abs(over.y) {
                            change.consume()
                        }
                    } else if scrollAxes == Axis.Set.horizontal {
                        if abs(over.y) > abs(over.x) {
                            change.consume()
                        }
                    } else {
                        change.consume()
                    }
                    overSlop = over
                }
            } while drag != nil && drag?.isConsumed != true
        } else {
            drag = initialDown
        }

        if let drag {
            onDrag(drag, overSlop)
            let didCompleteDrag = drag(pointerId: drag.id, onDrag: {
                onDrag($0, $0.positionChange())
                $0.consume()
            })
            if didCompleteDrag {
                onDragEnd()
            } else {
                onDragCancel()
            }
        }
    }
}
#endif

/*
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
*/
#endif
