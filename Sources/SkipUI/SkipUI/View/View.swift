// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import androidx.compose.ui.zIndex
import androidx.compose.ui.draw.BlurredEdgeTreatment
import androidx.compose.ui.draw.blur
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.clipToBounds
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.TransformOrigin
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGAffineTransform
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
import struct Foundation.URL
#endif

// SKIP @bridge
public protocol View {
    #if SKIP
    // SKIP DECLARE: fun body(): View = EmptyView()
    @ViewBuilder @MainActor var body: any View { get }
    #else
    associatedtype Body : View
    @ViewBuilder @MainActor var body: Body { get }
    #endif
}

#if SKIP
extension View {
    /// Compose this view without an existing context - typically called when integrating a SwiftUI view tree into pure Compose.
    @Composable public func Compose() -> ComposeResult {
        return Compose(context: ComposeContext())
    }

    /// Calls to `Compose` are added by the transpiler.
    @Composable public func Compose(context: ComposeContext) -> ComposeResult {
        if let composer = context.composer {
            let composerContext: (Bool) -> ComposeContext = { retain in
                guard !retain else {
                    return context
                }
                var context = context
                context.composer = nil
                return context
            }
            if let renderingComposer = composer as? RenderingComposer {
                renderingComposer.Compose(self, composerContext)
                return ComposeResult.ok
            } else if let sideEffectComposer = composer as? SideEffectComposer {
                return sideEffectComposer.Compose(self, composerContext)
            } else {
                return ComposeResult.ok
            }
        } else {
            ComposeContent(context: context)
            return ComposeResult.ok
        }
    }

    /// Compose this view's content.
    @Composable public func ComposeContent(context: ComposeContext) -> Void {
        StateTracking.pushBody()
        body.ComposeContent(context)
        StateTracking.popBody()
    }

    /// Whether this is an empty view.
    public var isSwiftUIEmptyView: Bool {
        return self is EmptyView
    }

    /// Whether this is a builtin SwiftUI view.
    public var isSwiftUIModuleView: Bool {
        return javaClass.name.startsWith("skip.ui.")
    }

    /// Strip modifier views.
    ///
    /// - Parameter until: Return `true` to stop stripping at a modifier with a given modifier.
    public func strippingModifiers<R>(until: (ComposeModifierView) -> Bool = { _ in false }, perform: (any View?) -> R) -> R {
        return perform(self)
    }
}
#endif

extension View {
    @available(*, unavailable)
    public func allowsHitTesting(_ enabled: Bool) -> some View {
        return self
    }

    public func aspectRatio(_ ratio: CGFloat? = nil, contentMode: ContentMode) -> some View {
        #if SKIP
        // Image has its own support for aspect ratios, and we allow the loaded Image in AsyncImage to consume the modifier too
        if let ratio, !strippingModifiers(perform: { $0 is Image || $0 is AsyncImage }) {
            // contentMode is not supported for non-Image views
            return ComposeModifierView(targetView: self) {
                $0.modifier = $0.modifier.aspectRatio(Float(ratio))
                return ComposeResult.ok
            }
        } else {
            return environment(\._aspectRatio, (ratio, contentMode))
        }
        #else
        return self
        #endif
    }

    public func aspectRatio(_ size: CGSize, contentMode: ContentMode) -> some View {
        return aspectRatio(size.width / size.height, contentMode: contentMode)
    }

    public func background(_ background: any View, alignment: Alignment = .center) -> some View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            BackgroundLayout(view: view, context: context, background: background, alignment: alignment)
        }
        #else
        return self
        #endif
    }

    public func background(alignment: Alignment = .center, @ViewBuilder content: () -> any View) -> some View {
        return background(content(), alignment: alignment)
    }

    /// - Warning: The second argument here should default to `.all`. Our implementation is not yet sophisticated enough to auto-detect when it is
    ///     against a safe area boundary, so this would cause problems. Therefore we default to `[]` and rely on ther user to specify the edges.
    public func background(ignoresSafeAreaEdges edges: Edge.Set = []) -> some View {
        return self.background(BackgroundStyle.shared, ignoresSafeAreaEdges: edges)
    }

    /// - Warning: The second argument here should default to `.all`. Our implementation is not yet sophisticated enough to auto-detect when it is
    ///     against a safe area boundary, so this would cause problems. Therefore we default to `[]` and rely on ther user to specify the edges.
    public func background(_ style: any ShapeStyle, ignoresSafeAreaEdges edges: Edge.Set = []) -> some View {
        #if SKIP
        if edges.isEmpty {
            return ComposeModifierView(targetView: self) {
                if let color = style.asColor(opacity: 1.0, animationContext: $0) {
                    $0.modifier = $0.modifier.background(color)
                } else if let brush = style.asBrush(opacity: 1.0, animationContext: $0) {
                    $0.modifier = $0.modifier.background(brush)
                }
                return ComposeResult.ok
            }
        } else {
            return background {
                style.ignoresSafeArea(edges: edges)
            }
        }
        #else
        return self
        #endif
    }

    public func background(in shape: any Shape, fillStyle: FillStyle = FillStyle()) -> some View {
        return background(BackgroundStyle.shared, in: shape, fillStyle: fillStyle)
    }

    public func background(_ style: any ShapeStyle, in shape: any Shape, fillStyle: FillStyle = FillStyle()) -> some View {
        return background(content: { shape.fill(style) })
    }

    public func backgroundStyle(_ style: any ShapeStyle) -> some View {
        #if SKIP
        return environment(\.backgroundStyle, style)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func badge(_ count: Int) -> some View {
        return self
    }

    @available(*, unavailable)
    public func badge(_ label: Text?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func badge(_ key: LocalizedStringKey) -> some View {
        return self
    }

    @available(*, unavailable)
    public func badge(_ label: String) -> some View {
        return self
    }

    @available(*, unavailable)
    public func badgeProminence(_ prominence: BadgeProminence) -> some View {
        return self
    }

    @available(*, unavailable)
    public func blendMode(_ blendMode: BlendMode) -> some View {
        return self
    }

    public func blur(radius: CGFloat, opaque: Bool = false) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) {
            $0.modifier = $0.modifier.blur(radiusX: radius.dp, radiusY: radius.dp, edgeTreatment: BlurredEdgeTreatment.Unbounded)
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func border(_ style: any ShapeStyle, width: CGFloat = 1.0) -> any View {
        #if SKIP
        return ComposeModifierView(targetView: self) {
            if let color = style.asColor(opacity: 1.0, animationContext: $0) {
                $0.modifier = $0.modifier.border(width: width.dp, color: color)
            } else if let brush = style.asBrush(opacity: 1.0, animationContext: $0) {
                $0.modifier = $0.modifier.border(BorderStroke(width: width.dp, brush: brush))
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func brightness(_ amount: Double) -> some View {
        return self
    }

    public func clipShape(_ shape: any Shape, style: FillStyle = FillStyle()) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) {
            $0.modifier = $0.modifier.clip(shape.asComposeShape(density: LocalDensity.current))
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    public func clipped(antialiased: Bool = false) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) {
            $0.modifier = $0.modifier.clipToBounds()
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func colorInvert() -> any View {
        #if SKIP
        return ComposeModifierView(targetView: self) {
            $0.modifier = $0.modifier.then(ColorInvertModifier())
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func colorMultiply(_ color: Color) -> some View {
        return self
    }

    public func compositingGroup() -> some View {
        return self
    }

    @available(*, unavailable)
    public func containerBackground(_ style: any ShapeStyle, for container: ContainerBackgroundPlacement) -> some View {
        return self
    }

    @available(*, unavailable)
    public func containerBackground(for container: ContainerBackgroundPlacement, alignment: Alignment = .center, @ViewBuilder content: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func containerRelativeFrame(_ axes: Axis.Set, alignment: Alignment = .center) -> some View {
        return self
    }

    @available(*, unavailable)
    public func containerRelativeFrame(_ axes: Axis.Set, count: Int, span: Int = 1, spacing: CGFloat, alignment: Alignment = .center) -> some View {
        return self
    }

    @available(*, unavailable)
    public func containerRelativeFrame(_ axes: Axis.Set, alignment: Alignment = .center, _ length: @escaping (CGFloat, Axis) -> CGFloat) -> some View {
        return self
    }

    @available(*, unavailable)
    public func containerShape<T>(_ shape: any Shape) -> some View {
        return self
    }

    @available(*, unavailable)
    public func contentShape(_ shape: any Shape, eoFill: Bool = false) -> some View {
        return self
    }

    @available(*, unavailable)
    public func contentShape(_ kind: ContentShapeKinds, _ shape: any Shape, eoFill: Bool = false) -> some View {
        return self
    }

    @available(*, unavailable)
    public func contextMenu(@ViewBuilder menuItems: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func contextMenu(@ViewBuilder menuItems: () -> any View, @ViewBuilder preview: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func contextMenu<I>(forSelectionType itemType: Any.Type? = nil, @ViewBuilder menu: @escaping (Set<I>) -> any View, primaryAction: ((Set<I>) -> Void)? = nil) -> some View where I: Hashable {
        return self
    }

    @available(*, unavailable)
    public func contrast(_ amount: Double) -> some View {
        return self
    }

    @available(*, unavailable)
    public func controlSize(_ controlSize: ControlSize) -> some View {
        return self
    }

    @available(*, unavailable)
    public func coordinateSpace(_ name: NamedCoordinateSpace) -> some View {
        return self
    }

    public func cornerRadius(_ radius: CGFloat, antialiased: Bool = true) -> some View {
        return clipShape(RoundedRectangle(cornerRadius: radius))
    }

    @available(*, unavailable)
    public func defaultHoverEffect(_ effect: HoverEffect?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func defersSystemGestures(on edges: Edge.Set) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dialogSuppressionToggle(_ titleKey: LocalizedStringKey, isSuppressed: Binding<Bool>) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dialogSuppression(_ title: String, isSuppressed: Binding<Bool>) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dialogSuppressionToggle(_ label: Text, isSuppressed: Binding<Bool>) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dialogSuppressionToggle(isSuppressed: Binding<Bool>) -> some View {
        return self
    }

    public func disabled(_ disabled: Bool) -> some View {
        #if SKIP
        return environment(\.isEnabled, !disabled)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func drawingGroup(opaque: Bool = false, colorMode: ColorRenderingMode = .nonLinear) -> some View {
        return self
    }

    public func equatable() -> some View {
        return EquatableView(content: self)
    }

    @available(*, unavailable)
    public func fileMover(isPresented: Binding<Bool>, file: URL?, onCompletion: @escaping (_ result: Result<URL, Error>) -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func fileMover(isPresented: Binding<Bool>, files: any Collection<URL>, onCompletion: @escaping (_ result: Result<[URL], Error>) -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func fileMover(isPresented: Binding<Bool>, file: URL?, onCompletion: @escaping (Result<URL, Error>) -> Void, onCancellation: @escaping () -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func fileMover(isPresented: Binding<Bool>, files: any Collection<URL>, onCompletion: @escaping (Result<[URL], Error>) -> Void, onCancellation: @escaping () -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func fixedSize(horizontal: Bool, vertical: Bool) -> some View {
        return self
    }

    @available(*, unavailable)
    public func fixedSize() -> some View {
        return self
    }

    @available(*, unavailable)
    public func flipsForRightToLeftLayoutDirection(_ enabled: Bool) -> some View {
        return self
    }

    // SKIP @bridge
    public func foregroundColor(_ color: Color?) -> any View {
        #if SKIP
        return environment(\._foregroundStyle, color)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func foregroundStyle(_ style: any ShapeStyle) -> any View {
        #if SKIP
        return environment(\._foregroundStyle, style)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func foregroundStyle(_ primary:  any ShapeStyle, _ secondary:  any ShapeStyle) -> some View {
        return self
    }

    @available(*, unavailable)
    public func foregroundStyle(_ primary:  any ShapeStyle, _ secondary:  any ShapeStyle, _ tertiary:  any ShapeStyle) -> some View {
        return self
    }

    public func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            let animatable = (Float(width ?? 0.0), Float(height ?? 0.0)).asAnimatable(context: context)
            FrameLayout(view: view, context: context, width: width == nil ? nil : Double(animatable.value.0), height: height == nil ? nil : Double(animatable.value.1), alignment: alignment)
        }
        #else
        return self
        #endif
    }

    public func frame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            FrameLayout(view: view, context: context, minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment)
        }
        #else
        return self
        #endif
    }

    public func grayscale(_ amount: Double) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) {
            $0.modifier = $0.modifier.then(GrayscaleModifier(amount: amount))
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func handlesExternalEvents(preferring: Set<String>, allowing: Set<String>) -> some View {
        return self
    }

    @available(*, unavailable)
    public func headerProminence(_ prominence: Prominence) -> some View {
        return self
    }

    @available(*, unavailable)
    public func help(_ textKey: LocalizedStringKey) -> some View {
        return self
    }

    @available(*, unavailable)
    public func help(_ text: Text) -> some View {
        return self
    }

    @available(*, unavailable)
    public func help(_ text: String) -> some View {
        return self
    }

    public func hidden() -> some View {
        #if SKIP
        return opacity(0.0)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func hoverEffect(_ effect: HoverEffect = .automatic, isEnabled: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func hoverEffectDisabled(_ disabled: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func hueRotation(_ angle: Angle) -> some View {
        // NOTE: animatable property
        return self
    }

    public func id(_ id: Any) -> some View {
        #if SKIP
        return TagModifierView(view: self, value: id, role: ComposeModifierRole.id)
        #else
        return self
        #endif
    }

    public func ignoresSafeArea(_ regions: SafeAreaRegions = .all, edges: Edge.Set = .all) -> some View {
        #if SKIP
        guard regions.contains(.container) else {
            return self
        }
        return ComposeModifierView(contentView: self) { view, context in
            IgnoresSafeAreaLayout(view: view, context: context, expandInto: edges)
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func inspector(isPresented: Binding<Bool>, @ViewBuilder content: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func inspectorColumnWidth(min: CGFloat? = nil, ideal: CGFloat, max: CGFloat? = nil) -> some View {
        return self
    }

    @available(*, unavailable)
    public func inspectorColumnWidth(_ width: CGFloat) -> some View {
        return self
    }

    @available(*, unavailable)
    public func interactionActivityTrackingTag(_ tag: String) -> some View {
        return self
    }

    @available(*, unavailable)
    public func keyboardShortcut(_ key: KeyEquivalent, modifiers: EventModifiers = .command) -> some View {
        return self
    }

    @available(*, unavailable)
    public func keyboardShortcut(_ shortcut: KeyboardShortcut?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func keyboardShortcut(_ key: KeyEquivalent, modifiers: EventModifiers = .command, localization: KeyboardShortcut.Localization) -> some View {
        return self
    }

    public func labelsHidden() -> some View {
        #if SKIP
        return environment(\._labelsHidden, true)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func layoutDirectionBehavior(_ behavior: LayoutDirectionBehavior) -> some View {
        return self
    }

    @available(*, unavailable)
    public func layoutPriority(_ value: Double) -> some View {
        return self
    }

    @available(*, unavailable)
    public func luminanceToAlpha() -> some View {
        return self
    }

    @available(*, unavailable)
    public func mask(alignment: Alignment = .center, @ViewBuilder _ mask: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func matchedGeometryEffect<ID>(id: any Hashable, in namespace: Any /* Namespace.ID */, properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: Bool = true) -> some View {
        return self
    }

    public func offset(_ offset: CGSize) -> some View {
        return self.offset(x: offset.width, y: offset.height)
    }

    public func offset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) {
            let density = LocalDensity.current
            let animatable = (Float(x), Float(y)).asAnimatable(context: $0)
            let offsetPx = with(density) {
                IntOffset(animatable.value.0.dp.roundToPx(), animatable.value.1.dp.roundToPx())
            }
            $0.modifier = $0.modifier.offset { offsetPx }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    public func onAppear(perform action: (() -> Void)? = nil) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) { _ in
            let hasAppeared = remember { mutableStateOf(false) }
            if !hasAppeared.value {
                hasAppeared.value = true
                SideEffect { action?() }
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    public func onChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) { context in
            let rememberedValue = rememberSaveable(stateSaver: context.stateSaver as! Saver<V, Any>) { mutableStateOf(value) }
            if rememberedValue.value != value {
                rememberedValue.value = value
                SideEffect { action(value) }
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    // Note: Kotlin's type inference has issues when a no-label closure follows a defaulted argument and the closure is
    // inline rather than trailing at the call site. So for these onChange variants we've separated the 'initial' argument
    // out rather than default it

    public func onChange<V>(of value: V, _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> some View {
        return onChange(of: value, initial: false, action)
    }

    public func onChange<V>(of value: V, initial: Bool, _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) { context in
            let rememberedValue = rememberSaveable(stateSaver: context.stateSaver as! Saver<V, Any>) { mutableStateOf(value) }
            let rememberedInitial = rememberSaveable(stateSaver: context.stateSaver as! Saver<Bool, Any>) { mutableStateOf(true) }
            
            let isInitial = rememberedInitial.value
            rememberedInitial.value = false
            
            let oldValue = rememberedValue.value
            let isUpdate = oldValue != value
            if isUpdate {
                rememberedValue.value = value
            }

            if (initial && isInitial) || isUpdate {
                SideEffect { action(oldValue, value) }
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    public func onChange<V>(of value: V?, _ action: @escaping () -> Void) -> some View {
        return onChange(of: value, initial: false, action)
    }

    public func onChange<V>(of value: V?, initial: Bool, _ action: @escaping () -> Void) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) { context in
            let rememberedValue = rememberSaveable(stateSaver: context.stateSaver as! Saver<V?, Any>) { mutableStateOf(value) }
            let rememberedInitial = rememberSaveable(stateSaver: context.stateSaver as! Saver<Bool, Any>) { mutableStateOf(true) }

            let isInitial = rememberedInitial.value
            rememberedInitial.value = false

            let oldValue = rememberedValue.value
            let isUpdate = oldValue != value
            if isUpdate {
                rememberedValue.value = value
            }

            if (initial && isInitial) || isUpdate {
                SideEffect { action() }
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func onContinuousHover(coordinateSpace: some CoordinateSpaceProtocol = .local, perform action: @escaping (HoverPhase) -> Void) -> some View {
        return self
    }

    public func onDisappear(perform action: (() -> Void)? = nil) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) { _ in
            let disposeAction = rememberUpdatedState(action)
            DisposableEffect(true) {
                onDispose {
                    disposeAction.value?()
                }
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func onHover(perform action: @escaping (Bool) -> Void) -> some View {
        return self
    }

    public func opacity(_ opacity: Double) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) {
            let animatable = Float(opacity).asAnimatable(context: $0)
            $0.modifier = $0.modifier.graphicsLayer { alpha = animatable.value }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    public func overlay(alignment: Alignment = .center, @ViewBuilder content: () -> any View) -> some View {
        #if SKIP
        let overlay = content()
        return ComposeModifierView(contentView: self) { view, context in
            OverlayLayout(view: view, context: context, overlay: overlay, alignment: alignment)
        }
        #else
        return self
        #endif
    }

    public func overlay(_ style: any ShapeStyle, ignoresSafeAreaEdges edges: Edge.Set = .all) -> some View {
        return overlay(style, in: Rectangle())
    }

    public func overlay(_ style: any ShapeStyle, in shape: any Shape, fillStyle: FillStyle = FillStyle()) -> some View {
        return overlay(content: { shape.fill(style) })
    }

    public func padding(_ insets: EdgeInsets) -> some View {
        #if SKIP
        // Certain views apply their padding themselves
        guard !strippingModifiers(until: { $0.role == .spacing }, perform: {
            $0 is LazyVGrid || $0 is LazyHGrid || $0 is LazyVStack || $0 is LazyHStack
        }) else {
            return environment(\._contentPadding, insets)
        }
        return ComposeModifierView(contentView: self, role: .spacing) { view, context in
            PaddingLayout(view: view, padding: insets, context: context)
        }
        #else
        return self
        #endif
    }

    public func padding(_ edges: Edge.Set, _ length: CGFloat? = nil) -> some View {
        #if SKIP
        var padding = EdgeInsets()
        if edges.contains(.top) {
            padding.top = length ?? 16.0
        }
        if edges.contains(.bottom) {
            padding.bottom = length ?? 16.0
        }
        if edges.contains(.leading) {
            padding.leading = length ?? 16.0
        }
        if edges.contains(.trailing) {
            padding.trailing = length ?? 16.0
        }
        return padding(padding)
        #else
        return self
        #endif
    }

    public func padding(_ length: CGFloat? = nil) -> some View {
        return padding(.all, length)
    }

    @available(*, unavailable)
    public func persistentSystemOverlays(_ visibility: Visibility) -> some View {
        return self
    }

    public func position(_ position: CGPoint) -> some View {
        return self.position(x: position.x, y: position.y)
    }

    public func position(x: CGFloat = 0.0, y: CGFloat = 0.0) -> some View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            let density = LocalDensity.current
            let animatable = (Float(x), Float(y)).asAnimatable(context: context)
            let positionPx = with(density) {
                IntOffset(animatable.value.0.dp.roundToPx(), animatable.value.1.dp.roundToPx())
            }
            PositionLayout(view: view, x: Double(animatable.value.0), y: Double(animatable.value.1), context: context)
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func projectionEffect(_ transform: Any /* ProjectionTransform */) -> some View {
        return self
    }

    @available(*, unavailable)
    public func popover<Item>(item: Binding<Item?>, attachmentAnchor: Any? = nil /* PopoverAttachmentAnchor = .rect(.bounds) */, arrowEdge: Edge = .top, @ViewBuilder content: @escaping (Item) -> any View) -> some View /* where Item : Identifiable, */ {
        return self
    }

    @available(*, unavailable)
    public func popover(isPresented: Binding<Bool>, attachmentAnchor: Any? = nil /* PopoverAttachmentAnchor = .rect(.bounds) */, arrowEdge: Edge = .top, @ViewBuilder content: @escaping () -> any View) -> some View {
        return self
    }

    public func refreshable(action: @escaping () async -> Void) -> some View {
        #if SKIP
        return environment(\.refresh, RefreshAction(action: action))
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func renameAction(_ isFocused: Any /* FocusState<Bool>.Binding */) -> some View {
        return self
    }

    @available(*, unavailable)
    public func renameAction(_ action: @escaping () -> Void) -> some View {
        return self
    }

    public func rotationEffect(_ angle: Angle) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) {
            let animatable = Float(angle.degrees).asAnimatable(context: $0)
            $0.modifier = $0.modifier.rotate(animatable.value)
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func rotationEffect(_ angle: Angle, anchor: UnitPoint) -> some View {
        #if SKIP
        fatalError()
        #else
        return self
        #endif
    }

    public func rotation3DEffect(_ angle: Angle, axis: (x: CGFloat, y: CGFloat, z: CGFloat), anchor: UnitPoint = .center, anchorZ: CGFloat = 0.0, perspective: CGFloat = 1.0) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) { context in
            let animatable = Float(angle.degrees).asAnimatable(context: context)
            // Try to approximate SwiftUI's perspective adaptation to view size
            let size = remember { mutableStateOf(IntSize.Zero) }
            let dimension = max(size.value.width * axis.y, size.value.height * axis.x)
            let distance = max(Float(0.1), Float(dimension / 65)) / Float(perspective)
            context.modifier = context.modifier
                .onGloballyPositioned { size.value = $0.size }
                .graphicsLayer(
                    transformOrigin: TransformOrigin(pivotFractionX: Float(anchor.x), pivotFractionY: Float(anchor.y)),
                    rotationX: Float(axis.x) * animatable.value,
                    rotationY: Float(axis.y) * animatable.value,
                    rotationZ: Float(axis.z) * animatable.value,
                    cameraDistance: distance
                )
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    public func rotation3DEffect(_ angle: Angle, axis: (x: Int, y: Int, z: Int), perspective: CGFloat = 1.0) -> some View {
        return rotation3DEffect(angle, axis: (CGFloat(axis.x), CGFloat(axis.y), CGFloat(axis.z)), perspective: perspective)
    }

    @available(*, unavailable)
    public func safeAreaInset(edge: VerticalEdge, alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func safeAreaInset(edge: HorizontalEdge, alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func safeAreaPadding(_ insets: EdgeInsets) -> some View {
        return self
    }

    @available(*, unavailable)
    public func safeAreaPadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        return self
    }

    @available(*, unavailable)
    public func safeAreaPadding(_ length: CGFloat) -> some View {
        return self
    }

    @available(*, unavailable)
    public func saturation(_ amount: Double) -> some View {
        return self
    }

    public func scaledToFit() -> some View {
        return aspectRatio(nil, contentMode: .fit)
    }

    public func scaledToFill() -> some View {
        return aspectRatio(nil, contentMode: .fill)
    }

    public func scaleEffect(_ scale: CGSize) -> some View {
        return scaleEffect(x: scale.width, y: scale.height)
    }

    @available(*, unavailable)
    public func scaleEffect(_ scale: CGSize, anchor: UnitPoint) -> some View {
        return scaleEffect(x: scale.width, y: scale.height)
    }

    public func scaleEffect(_ s: CGFloat) -> some View {
        return scaleEffect(x: s, y: s)
    }

    @available(*, unavailable)
    public func scaleEffect(_ s: CGFloat, anchor: UnitPoint) -> some View {
        return scaleEffect(x: s, y: s)
    }

    public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) {
            let animatable = (Float(x), Float(y)).asAnimatable(context: $0)
            $0.modifier = $0.modifier.scale(scaleX: animatable.value.0, scaleY: animatable.value.1)
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0, anchor: UnitPoint) -> some View {
        return scaleEffect(x: x, y: y)
    }

    @available(*, unavailable)
    public func selectionDisabled(_ isDisabled: Bool = true) -> some View {
        return self
    }

    public func shadow(color: Color = Color(/* .sRGBLinear, */ white: 0.0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0.0, y: CGFloat = 0.0) -> some View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            // See Shadowed.kt
            Shadowed(context: context, color: color.colorImpl(), offsetX: x.dp, offsetY: y.dp, blurRadius: radius.dp) { context in
                view.Compose(context: context)
            }
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func statusBarHidden(_ hidden: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func symbolEffectsRemoved(_ isEnabled: Bool = true) -> some View {
        return self
    }

    // SKIP @bridge
    public func tag(_ tag: Any) -> any View {
        #if SKIP
        return TagModifierView(view: self, value: tag, role: ComposeModifierRole.tag)
        #else
        return self
        #endif
    }

    public func task(priority: TaskPriority = .userInitiated, _ action: @escaping () async -> Void) -> some View {
        return task(id: 0, priority: priority, action)
    }

    public func task(id value: Any, priority: TaskPriority = .userInitiated, _ action: @escaping () async -> Void) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) { _ in
            let handler = rememberUpdatedState(action)
            LaunchedEffect(value) {
                handler.value()
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    public func tint(_ color: Color?) -> some View {
        #if SKIP
        return environment(\._tint, color)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func tint(_ tint: (any ShapeStyle)?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func transformEffect(_ transform: Any /* CGAffineTransform */) -> some View {
        return self
    }

    @available(*, unavailable)
    public func transformEnvironment<V>(_ keyPath: Any /* WritableKeyPath<EnvironmentValues, V> */, transform: @escaping (inout V) -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func typeSelectEquivalent(_ text: Text?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func typeSelectEquivalent(_ stringKey: LocalizedStringKey) -> some View {
        return self
    }

    @available(*, unavailable)
    public func typeSelectEquivalent(_ string: String) -> some View {
        return self
    }

    public func zIndex(_ value: Double) -> some View {
        #if SKIP
        return ZIndexModifierView(targetView: self, zIndex: value)
        #else
        return self
        #endif
    }
}

#if SKIP
/// Used to mark views with a tag or ID.
struct TagModifierView: ComposeModifierView {
    let value: Any

    init(view: View, value: Any, role: ComposeModifierRole) {
        self.value = value
        super.init(view: view, role: role)
    }

    /// Extract the existing tag modifier view from the given view's modifiers.
    static func strip(from view: View, role: ComposeModifierRole) -> TagModifierView? {
        return view.strippingModifiers(until: { $0.role == role }, perform: { $0 as? TagModifierView })
    }
}

/// Use a special modifier for `zIndex` so that the artificial parent container created by `.frame` can
/// pull the `zIndex` value into its own modifiers.
///
/// Otherwise the extra frame container hides the `zIndex` value from this view's logical parent container.
///
/// - Seealso: `FrameLayout`
final class ZIndexModifierView : ComposeModifierView {
    private var zIndex: Double

    init(targetView: View, zIndex: Double) {
        self.zIndex = zIndex
        super.init(targetView: targetView) {
            if zIndex != 0.0 {
                $0.modifier = $0.modifier.zIndex(Float(zIndex))
            }
            return ComposeResult.ok
        }
    }

    /// Move the application of the `zIndex` to the given modifier, erasing it from this view.
    func consume(with modifier: Modifier) -> Modifier {
        guard zIndex != 0.0 else {
            return modifier
        }
        let zIndexModifier = modifier.zIndex(Float(zIndex))
        zIndex = 0.0
        return zIndexModifier
    }
}
#endif

#if !SKIP

// Stubs needed to compile this package:

extension Optional : View where Wrapped : View {
    public var body: some View {
        stubView()
    }
}

extension Never : View {
}


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Never {

    /// The type for the internal content of this `AccessibilityRotorContent`.
    public typealias Body = NeverView

    /// The internal content of this `AccessibilityRotorContent`.
    public var body: Never { get { fatalError() } }
}

#endif
#endif
