// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.aspectRatio
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
import androidx.compose.ui.graphics.CompositingStrategy
import androidx.compose.ui.graphics.TransformOrigin
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.layout.Measurable
import androidx.compose.ui.layout.Placeable
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.layout
import androidx.compose.ui.layout.onGloballyPositioned
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

extension View {
    // SKIP @bridge
    public func allowsHitTesting(_ enabled: Bool) -> any View {
        #if SKIP
        if enabled {
            return self
        } else {
            return ModifiedContent(content: self, modifier: RenderModifier {
                return $0.modifier.clickable(enabled: false, onClick: {})
            })
        }
        #else
        return self
        #endif
    }

    public func aspectRatio(_ ratio: CGFloat? = nil, contentMode: ContentMode) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: AspectRatioModifier(ratio: ratio, contentMode: contentMode))
        #else
        return self
        #endif
    }

    public func aspectRatio(_ size: CGSize, contentMode: ContentMode) -> any View {
        return aspectRatio(size.width / size.height, contentMode: contentMode)
    }

    // SKIP @bridge
    public func aspectRatio(_ ratio: CGFloat? = nil, bridgedContentMode: Int) -> any View {
        return aspectRatio(ratio, contentMode: ContentMode(rawValue: bridgedContentMode) ?? .fit)
    }

    public func background(_ background: any View, alignment: Alignment = .center) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { renderable, context in
            BackgroundLayout(content: renderable, context: context, background: background, alignment: alignment)
        })
        #else
        return self
        #endif
    }

    public func background(alignment: Alignment = .center, @ViewBuilder content: () -> any View) -> any View {
        return background(content(), alignment: alignment)
    }

    // SKIP @bridge
    public func background(horizontalAlignmentKey: String, verticalAlignmentKey: String, bridgedContent: any View) -> any View {
        return background(alignment: Alignment(horizontal: HorizontalAlignment(key: horizontalAlignmentKey), vertical: VerticalAlignment(key: verticalAlignmentKey)), content: { bridgedContent })
    }

    /// - Warning: The second argument here should default to `.all`. Our implementation is not yet sophisticated enough to auto-detect when it is
    ///     against a safe area boundary, so this would cause problems. Therefore we default to `[]` and rely on ther user to specify the edges.
    public func background(ignoresSafeAreaEdges edges: Edge.Set = []) -> any View {
        return self.background(BackgroundStyle.shared, ignoresSafeAreaEdges: edges)
    }

    /// - Warning: The second argument here should default to `.all`. Our implementation is not yet sophisticated enough to auto-detect when it is
    ///     against a safe area boundary, so this would cause problems. Therefore we default to `[]` and rely on ther user to specify the edges.
    public func background(_ style: any ShapeStyle, ignoresSafeAreaEdges edges: Edge.Set = []) -> any View {
        #if SKIP
        if edges.isEmpty {
            return ModifiedContent(content: self, modifier: RenderModifier { context in
                if let color = style.asColor(opacity: 1.0, animationContext: context) {
                    return context.modifier.background(color)
                } else if let brush = style.asBrush(opacity: 1.0, animationContext: context) {
                    return context.modifier.background(brush)
                } else {
                    return context.modifier
                }
            })
        } else {
            return background {
                style.ignoresSafeArea(edges: edges)
            }
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func background(_ style: any ShapeStyle, bridgedIgnoresSafeAreaEdges: Int) -> any View {
        return background(style, ignoresSafeAreaEdges: Edge.Set(rawValue: bridgedIgnoresSafeAreaEdges))
    }

    public func background(in shape: any Shape, fillStyle: FillStyle = FillStyle()) -> any View {
        return background(BackgroundStyle.shared, in: shape, fillStyle: fillStyle)
    }

    public func background(_ style: any ShapeStyle, in shape: any Shape, fillStyle: FillStyle = FillStyle()) -> any View {
        return background(content: { shape.fill(style) })
    }

    // SKIP @bridge
    public func background(_ style: any ShapeStyle, in shape: any Shape, eoFill: Bool, antialiased: Bool) -> any View {
        return background(style, in: shape, fillStyle: FillStyle(eoFill: eoFill, antialiased: antialiased))
    }

    // SKIP @bridge
    public func backgroundStyle(_ style: any ShapeStyle) -> any View {
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
    public func badge(_ resource: LocalizedStringResource) -> some View {
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

    public func blendMode(_ blendMode: BlendMode) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.graphicsLayer(
                compositingStrategy: CompositingStrategy.Offscreen,
                blendMode: blendMode.asComposeBlendMode()
            )
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func blendMode(bridgedRawValue: Int) -> any View {
        return blendMode(BlendMode(rawValue: bridgedRawValue) ?? .normal)
    }

    // SKIP @bridge
    public func blur(radius: CGFloat, opaque: Bool = false) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.blur(radiusX: radius.dp, radiusY: radius.dp, edgeTreatment: BlurredEdgeTreatment.Unbounded)
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func border(_ style: any ShapeStyle, width: CGFloat = 1.0) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { context in
            if let color = style.asColor(opacity: 1.0, animationContext: context) {
                return context.modifier.border(width: width.dp, color: color)
            } else if let brush = style.asBrush(opacity: 1.0, animationContext: context) {
                return context.modifier.border(BorderStroke(width: width.dp, brush: brush))
            } else {
                return context.modifier
            }
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func brightness(_ amount: Double) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.then(BrightnessModifier(amount: amount))
        })
        #else
        return self
        #endif
    }

    public func clipShape(_ shape: any Shape, style: FillStyle = FillStyle()) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.clip(shape.asComposeShape(density: LocalDensity.current))
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func clipShape(_ shape: any Shape, eoFill: Bool, antialiased: Bool) -> any View {
        return clipShape(shape, style: FillStyle(eoFill: eoFill, antialiased: antialiased))
    }

    // SKIP @bridge
    public func clipped(antialiased: Bool = false) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.clipToBounds()
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func colorInvert() -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.then(ColorInvertModifier())
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func colorMultiply(_ color: Color) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { context in
            return context.modifier.then(ColorMultiplyModifier(color: color.colorImpl()))
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func compositingGroup() -> any View {
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

    // SKIP @bridge
    public func contrast(_ amount: Double) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.then(ContrastModifier(amount: amount))
        })
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func controlSize(_ controlSize: ControlSize) -> some View {
        return self
    }

    @available(*, unavailable)
    public func coordinateSpace(_ name: NamedCoordinateSpace) -> some View {
        return self
    }

    // No need to @bridge because we define it in terms of `clipShape`
    public func cornerRadius(_ radius: CGFloat, antialiased: Bool = true) -> any View {
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
    public func dialogSuppressionToggle(_ titleResource: LocalizedStringResource, isSuppressed: Binding<Bool>) -> some View {
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

    // SKIP @bridge
    public func disabled(_ disabled: Bool) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: DisabledModifier(disabled))
        #else
        return self
        #endif
    }

    public func drawingGroup(opaque: Bool = false, colorMode: ColorRenderingMode = .nonLinear) -> any View {
        #if SKIP
        // Android ignores opaque and colorMode
        // drawingGroup forces offscreen rendering - Compose equivalent is CompositingStrategy.Offscreen
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.graphicsLayer(compositingStrategy: CompositingStrategy.Offscreen)
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func drawingGroup() -> any View {
        return drawingGroup(opaque: false, colorMode: .nonLinear)
    }

    // No need to @bridge
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
        return environment(\._foregroundStyle, color, affectsEvaluate: false)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func foregroundStyle(_ style: any ShapeStyle) -> any View {
        #if SKIP
        return environment(\._foregroundStyle, style, affectsEvaluate: false)
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
        return ModifiedContent(content: self, modifier: RenderModifier { renderable, context in
            let animatable = (Float(width ?? 0.0), Float(height ?? 0.0)).asAnimatable(context: context)
            FrameLayout(content: renderable, context: context, width: width == nil ? nil : Double(animatable.value.0), height: height == nil ? nil : Double(animatable.value.1), alignment: alignment)
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func frame(width: CGFloat?, height: CGFloat?, horizontalAlignmentKey: String, verticalAlignmentKey: String) -> any View {
        return frame(width: width, height: height, alignment: Alignment(horizontal: HorizontalAlignment(key: horizontalAlignmentKey), vertical: VerticalAlignment(key: verticalAlignmentKey)))
    }

    public func frame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { renderable, context in
            FrameLayout(content: renderable, context: context, minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment)
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func frame(minWidth: CGFloat?, idealWidth: CGFloat?, maxWidth: CGFloat?, minHeight: CGFloat?, idealHeight: CGFloat?, maxHeight: CGFloat?, horizontalAlignmentKey: String, verticalAlignmentKey: String) -> any View {
        return frame(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: Alignment(horizontal: HorizontalAlignment(key: horizontalAlignmentKey), vertical: VerticalAlignment(key: verticalAlignmentKey)))
    }

    // SKIP @bridge
    public func grayscale(_ amount: Double) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.then(GrayscaleModifier(amount: amount))
        })
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
    public func help(_ textResource: LocalizedStringResource) -> some View {
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

    // SKIP @bridge
    public func hidden() -> any View {
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

    public func hueRotation(_ angle: Angle) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.then(HueRotationModifier(degrees: angle.degrees))
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func hueRotation(bridgedAngle: Double) -> any View {
        return hueRotation(.radians(bridgedAngle))
    }

    // SKIP @bridge
    public func id(_ id: Any) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: TagModifier(value: id, role: .id))
        #else
        return self
        #endif
    }

    public func ignoresSafeArea(_ regions: SafeAreaRegions = .all, edges: Edge.Set = .all) -> any View {
        #if SKIP
        guard regions.contains(.container) else {
            return self
        }
        return ModifiedContent(content: self, modifier: RenderModifier { renderable, context in
            IgnoresSafeAreaLayout(content: renderable, context: context, expandInto: edges)
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func ignoresSafeArea(bridgedRegions: Int, bridgedEdges: Int) -> any View {
        return ignoresSafeArea(SafeAreaRegions(rawValue: bridgedRegions), edges: Edge.Set(rawValue: bridgedEdges))
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

    // SKIP @bridge
    public func labelsHidden() -> any View {
        #if SKIP
        return environment(\._labelsHidden, true, affectsEvaluate: false)
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

    /// Allow users to revert to previous layout versions.
    // SKIP @bridge
    public func layoutImplementationVersion(_ version: Int) -> any View {
        #if SKIP
        return environment(\._layoutImplementationVersion, version)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func luminanceToAlpha() -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.then(LuminanceToAlphaModifier())
        })
        #else
        return self
        #endif
    }

    public func mask(_ mask: any View, alignment: Alignment = .center) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { renderable, context in
            MaskLayout(content: renderable, context: context, mask: mask, alignment: alignment)
        })
        #else
        return self
        #endif
    }

    public func mask(alignment: Alignment = .center, @ViewBuilder _ mask: () -> any View) -> any View {
        return self.mask(mask(), alignment: alignment)
    }

    // SKIP @bridge
    public func mask(horizontalAlignmentKey: String, verticalAlignmentKey: String, bridgedMask: any View) -> any View {
        return mask(bridgedMask, alignment: Alignment(horizontal: HorizontalAlignment(key: horizontalAlignmentKey), vertical: VerticalAlignment(key: verticalAlignmentKey)))
    }

    @available(*, unavailable)
    public func matchedGeometryEffect<ID>(id: any Hashable, in namespace: Any /* Namespace.ID */, properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: Bool = true) -> some View {
        return self
    }

    public func offset(_ offset: CGSize) -> any View {
        return self.offset(x: offset.width, y: offset.height)
    }

    // SKIP @bridge
    public func offset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            let density = LocalDensity.current
            let animatable = (Float(x), Float(y)).asAnimatable(context: $0)
            let offsetPx = with(density) {
                IntOffset(animatable.value.0.dp.roundToPx(), animatable.value.1.dp.roundToPx())
            }
            return $0.modifier.offset { offsetPx }
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func onAppear(perform action: (() -> Void)? = nil) -> any View {
        #if SKIP
        // TODO: would it be better to use the (new) onFirstVisible and onVisibilityChanged APIs here?
        return ModifiedContent(content: self, modifier: SideEffectModifier { _ in
            let hasAppeared = remember { mutableStateOf(false) }
            if !hasAppeared.value {
                hasAppeared.value = true
                SideEffect { action?() }
            }
            return ComposeResult.ok
        })
        #else
        return self
        #endif
    }

    public func onChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: SideEffectModifier { context in
            let rememberedValue = rememberSaveable(stateSaver: context.stateSaver as! Saver<V, Any>) { mutableStateOf(value) }
            if rememberedValue.value != value {
                rememberedValue.value = value
                SideEffect { action(value) }
            }
            return ComposeResult.ok
        })
        #else
        return self
        #endif
    }

    // Note: Kotlin's type inference has issues when a no-label closure follows a defaulted argument and the closure is
    // inline rather than trailing at the call site. So for these onChange variants we've separated the 'initial' argument
    // out rather than default it

    public func onChange<V>(of value: V, _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> any View {
        return onChange(of: value, initial: false, action)
    }

    // SKIP @bridge
    public func onChange<V>(of value: V, initial: Bool, _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: SideEffectModifier { context in
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
        })
        #else
        return self
        #endif
    }

    public func onChange<V>(of value: V?, _ action: @escaping () -> Void) -> any View {
        return onChange(of: value, initial: false, action)
    }

    public func onChange<V>(of value: V?, initial: Bool, _ action: @escaping () -> Void) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: SideEffectModifier { context in
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
        })
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func onContinuousHover(coordinateSpace: some CoordinateSpaceProtocol = .local, perform action: @escaping (HoverPhase) -> Void) -> some View {
        return self
    }

    // SKIP @bridge
    public func onDisappear(perform action: (() -> Void)? = nil) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: SideEffectModifier { _ in
            let disposeAction = rememberUpdatedState(action)
            DisposableEffect(true) {
                onDispose {
                    disposeAction.value?()
                }
            }
            return ComposeResult.ok
        })
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func onHover(perform action: @escaping (Bool) -> Void) -> some View {
        return self
    }

    // SKIP @bridge
    public func opacity(_ opacity: Double) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { context in
            let animatable = Float(opacity).asAnimatable(context: context)
            return context.modifier.graphicsLayer { alpha = animatable.value }
        })
        #else
        return self
        #endif
    }

    public func overlay(alignment: Alignment = .center, @ViewBuilder content: () -> any View) -> any View {
        #if SKIP
        let overlay = content()
        return ModifiedContent(content: self, modifier: RenderModifier { renderable, context in
            OverlayLayout(content: renderable, context: context, overlay: overlay, alignment: alignment)
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func overlay(horizontalAlignmentKey: String, verticalAlignmentKey: String, bridgedContent: any View) -> any View {
        return overlay(alignment: Alignment(horizontal: HorizontalAlignment(key: horizontalAlignmentKey), vertical: VerticalAlignment(key: verticalAlignmentKey)), content: { bridgedContent })
    }

    public func overlay(_ style: any ShapeStyle, ignoresSafeAreaEdges edges: Edge.Set = .all) -> any View {
        return overlay(style, in: Rectangle())
    }

    // SKIP @bridge
    public func overlay(_ style: any ShapeStyle, bridgedIgnoresSafeAreaEdges: Int) -> any View {
        return overlay(style, ignoresSafeAreaEdges: Edge.Set(rawValue: bridgedIgnoresSafeAreaEdges))
    }

    public func overlay(_ style: any ShapeStyle, in shape: any Shape, fillStyle: FillStyle = FillStyle()) -> any View {
        return overlay(content: { shape.fill(style) })
    }

    // SKIP @bridge
    public func overlay(_ style: any ShapeStyle, in shape: any Shape, eoFill: Bool, antialiased: Bool) -> any View {
        return overlay(style, in: shape, fillStyle: FillStyle(eoFill: eoFill, antialiased: antialiased))
    }

    public func padding(_ insets: EdgeInsets) -> some View {
        #if SKIP
        return ModifiedContent(content: self, modifier: PaddingModifier(insets: insets))
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

    // SKIP @bridge
    public func padding(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> any View {
        return padding(EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }

    @available(*, unavailable)
    public func persistentSystemOverlays(_ visibility: Visibility) -> some View {
        return self
    }

    public func position(_ position: CGPoint) -> any View {
        return self.position(x: position.x, y: position.y)
    }

    // SKIP @bridge
    public func position(x: CGFloat = 0.0, y: CGFloat = 0.0) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { renderable, context in
            let density = LocalDensity.current
            let animatable = (Float(x), Float(y)).asAnimatable(context: context)
            let positionPx = with(density) {
                IntOffset(animatable.value.0.dp.roundToPx(), animatable.value.1.dp.roundToPx())
            }
            PositionLayout(content: renderable, x: Double(animatable.value.0), y: Double(animatable.value.1), context: context)
        })
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

    // No need to @bridge because we define in terms of `EnvironmentValues.refresh`
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

    public func rotationEffect(_ angle: Angle) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { context in
            let animatable = Float(angle.degrees).asAnimatable(context: context)
            return context.modifier.rotate(animatable.value)
        })
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func rotationEffect(_ angle: Angle, anchor: UnitPoint) -> any View {
        #if SKIP
        fatalError()
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func rotationEffect(bridgedAngle: Double, anchorX: CGFloat, anchorY: CGFloat) -> any View {
        // Note: anchor is currently ignored
        return rotationEffect(.radians(bridgedAngle))
    }

    public func rotation3DEffect(_ angle: Angle, axis: (x: CGFloat, y: CGFloat, z: CGFloat), anchor: UnitPoint = .center, anchorZ: CGFloat = 0.0, perspective: CGFloat = 1.0) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { context in
            let animatable = Float(angle.degrees).asAnimatable(context: context)
            // Try to approximate SwiftUI's perspective adaptation to view size
            let size = remember { mutableStateOf(IntSize.Zero) }
            let dimension = max(size.value.width * axis.y, size.value.height * axis.x)
            let distance = max(Float(0.1), Float(dimension / 65)) / Float(perspective)
            return context.modifier
                .onGloballyPositioned { size.value = $0.size }
                .graphicsLayer(
                    transformOrigin: TransformOrigin(pivotFractionX: Float(anchor.x), pivotFractionY: Float(anchor.y)),
                    rotationX: Float(axis.x) * animatable.value,
                    rotationY: Float(axis.y) * animatable.value,
                    rotationZ: Float(axis.z) * animatable.value,
                    cameraDistance: distance
                )
        })
        #else
        return self
        #endif
    }

    public func rotation3DEffect(_ angle: Angle, axis: (x: Int, y: Int, z: Int), perspective: CGFloat = 1.0) -> any View {
        return rotation3DEffect(angle, axis: (CGFloat(axis.x), CGFloat(axis.y), CGFloat(axis.z)), perspective: perspective)
    }

    // SKIP @bridge
    public func rotation3DEffect(bridgedAngle: Double, axis: (x: CGFloat, y: CGFloat, z: CGFloat), anchorX: CGFloat, anchorY: CGFloat, anchorZ: CGFloat, perspective: CGFloat) -> any View {
        return rotation3DEffect(.radians(bridgedAngle), axis: axis, anchor: UnitPoint(x: anchorX, y: anchorY), anchorZ: anchorZ, perspective: perspective)
    }

    // SKIP @bridge
    public func saturation(_ amount: Double) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier {
            return $0.modifier.then(SaturationModifier(amount: amount))
        })
        #else
        return self
        #endif
    }

    // No need to @bridge because we define in terms of `.aspectRatio`
    public func scaledToFit() -> any View {
        return aspectRatio(nil, contentMode: .fit)
    }

    // No need to @bridge because we define in terms of `.aspectRatio`
    public func scaledToFill() -> any View {
        return aspectRatio(nil, contentMode: .fill)
    }

    public func scaleEffect(_ scale: CGSize) -> any View {
        return scaleEffect(x: scale.width, y: scale.height)
    }

    @available(*, unavailable)
    public func scaleEffect(_ scale: CGSize, anchor: UnitPoint) -> any View {
        return scaleEffect(x: scale.width, y: scale.height)
    }

    public func scaleEffect(_ s: CGFloat) -> any View {
        return scaleEffect(x: s, y: s)
    }

    @available(*, unavailable)
    public func scaleEffect(_ s: CGFloat, anchor: UnitPoint) -> any View {
        return scaleEffect(x: s, y: s)
    }

    public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { context in
            let animatable = (Float(x), Float(y)).asAnimatable(context: context)
            return context.modifier.scale(scaleX: animatable.value.0, scaleY: animatable.value.1)
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0, anchorX: CGFloat, anchorY: CGFloat) -> any View {
        // Note: anchor is currently ignored
        return scaleEffect(x: x, y: y)
    }

    @available(*, unavailable)
    public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0, anchor: UnitPoint) -> any View {
        return scaleEffect(x: x, y: y)
    }

    @available(*, unavailable)
    public func sectionActions(@ViewBuilder content: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func selectionDisabled(_ isDisabled: Bool = true) -> some View {
        return self
    }

    // SKIP @bridge
    public func shadow(color: Color = Color(/* .sRGBLinear, */ white: 0.0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0.0, y: CGFloat = 0.0) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { renderable, context in
            // See Shadowed.kt
            Shadowed(context: context, color: color.colorImpl(), offsetX: x.dp, offsetY: y.dp, blurRadius: radius.dp) { context in
                renderable.Render(context: context)
            }
        })
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
    public func tag(_ tag: Any?) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: TagModifier(value: tag, role: .tag))
        #else
        return self
        #endif
    }

    public func task(priority: TaskPriority = .userInitiated, _ action: @escaping () async -> Void) -> any View {
        return task(id: 0, priority: priority, action)
    }

    public func task(id value: Any, priority: TaskPriority = .userInitiated, _ action: @escaping () async -> Void) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: SideEffectModifier { _ in
            let handler = rememberUpdatedState(action)
            LaunchedEffect(value) {
                handler.value()
            }
            return ComposeResult.ok
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func task(id value: Any, bridgedAction: @escaping (CompletionHandler) -> Void) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: SideEffectModifier { _ in
            let actionState = rememberUpdatedState(bridgedAction)
            LaunchedEffect(value) {
                kotlinx.coroutines.suspendCancellableCoroutine { continuation in
                    let completionHandler = CompletionHandler({
                        do { continuation.resume(Unit, nil) } catch {}
                    })
                    continuation.invokeOnCancellation { _ in
                        completionHandler.onCancel?()
                    }
                    actionState.value(completionHandler)
                }
            }
            return ComposeResult.ok
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func tint(_ color: Color?) -> any View {
        #if SKIP
        return environment(\._tint, color, affectsEvaluate: false)
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
    public func typeSelectEquivalent(_ stringResource: LocalizedStringResource) -> some View {
        return self
    }

    @available(*, unavailable)
    public func typeSelectEquivalent(_ string: String) -> some View {
        return self
    }

    // SKIP @bridge
    public func zIndex(_ value: Double) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: ZIndexModifier(zIndex: value))
        #else
        return self
        #endif
    }
}

#if SKIP
extension Modifier {
    /// Log layout constraints for debugging purposes.
    ///
    /// - Parameter tag: The log tag to use (default: "LogLayout").
    /// - Returns: A modifier that logs layout constraints.
    func logLayout(tag: String = "LogLayout") -> Modifier {
        return self.layout { measurable, constraints in
            android.util.Log.d(
                tag,
                "Constraints: minWidth=\(constraints.minWidth), maxWidth=\(constraints.maxWidth), " +
                    "minHeight=\(constraints.minHeight), maxHeight=\(constraints.maxHeight)"
            )
            let placeable = measurable.measure(constraints)
            return layout(width: placeable.width, height: placeable.height) {
                placeable.place(0, 0)
            }
        }.onGloballyPositioned {
            let bounds = $0.boundsInWindow()
            android.util.Log.d(
                tag,
                "Bounds: (top=\(bounds.top), left=\(bounds.left), bottom=\(bounds.bottom), right=\(bounds.right), width=\(bounds.width), height=\(bounds.height))"
            )
        }
    }
}

final class AspectRatioModifier: RenderModifier {
    let ratio: Double?
    let contentMode: ContentMode

    init(ratio: Double?, contentMode: ContentMode) {
        self.ratio = ratio
        self.contentMode = contentMode
        super.init()
        self.action = { renderable, context in
            let stripped = renderable.strip()
            if stripped is Image || stripped is AsyncImage || ratio == nil {
                // Image has its own support for aspect ratios, and we allow the loaded Image in AsyncImage
                // to consume the modifier too
                EnvironmentValues.shared.setValues {
                    $0.set_aspectRatio((ratio, contentMode))
                    return ComposeResult.ok
                } in: {
                    renderable.Render(context: context)
                }
            } else {
                var context = context
                context.modifier = context.modifier.aspectRatio(Float(ratio))
                renderable.Render(context: context)
            }
        }
    }
}

final class DisabledModifier: EnvironmentModifier {
    let disabled: Bool

    init(_ disabled: Bool) {
        self.disabled = disabled
        super.init()
        self.action = {
            $0.setisEnabled(!disabled)
            return ComposeResult.ok
        }
    }
}

final class PaddingModifier: RenderModifier {
    let insets: EdgeInsets

    init(insets: EdgeInsets) {
        self.insets = insets
        super.init(role: .spacing)
        self.action = { renderable, context in
            let stripped = renderable.strip()
            if (stripped is LazyVGrid || stripped is LazyHGrid || stripped is LazyVStack || stripped is LazyHStack)
                && renderable.forEachModifier(perform: { $0.role == .spacing ? true : nil }) == nil {
                // Certain views apply their padding themselves
                EnvironmentValues.shared.setValues {
                    $0.set_contentPadding(insets)
                    return ComposeResult.ok
                } in: {
                    renderable.Render(context: context)
                }
            } else {
                PaddingLayout(content: renderable, padding: insets, context: context)
            }
        }
    }
}

/// Used to mark views with a tag or ID.
final class TagModifier: RenderModifier {
    let value: Any?

    init(value: Any?, role: ModifierRole) {
        self.value = value
        super.init(role: role)
    }

    /// Extract the existing tag modifier view from the given view's modifiers.
    static func on(content: Renderable, role: ModifierRole) -> TagModifier? {
        return content.forEachModifier {
            if $0.role == role {
                return $0 as? TagModifier
            } else {
                return nil
            }
        }
    }
}

/// Use a special modifier for `zIndex` so that the artificial parent container created by `.frame` can
/// pull the `zIndex` value into its own modifiers.
///
/// Otherwise the extra frame container hides the `zIndex` value from this view's logical parent container.
///
/// - Seealso: `FrameLayout`
final class ZIndexModifier: RenderModifier {
    private let zIndex: Double
    private var isConsumed = false

    init(zIndex: Double) {
        super.init()
        self.zIndex = zIndex
        self.action = { renderable, context in
            var context = context
            if !isConsumed {
                context.modifier = context.modifier.zIndex(Float(zIndex))
            }
            renderable.Render(context: context)
        }
    }

    /// Move the application of the `zIndex` to the given modifier, erasing it from this view.
    static func consume(for renderable: Renderable, with modifier: Modifier) -> Modifier {
        if let zIndex = renderable.forEachModifier(perform: {
            if let zIndexModifier = $0 as? ZIndexModifier {
                zIndexModifier.isConsumed = true
                return zIndexModifier.zIndex
            } else {
                return nil
            }
        }) {
            return modifier.zIndex(Float(zIndex))
        } else {
            return modifier
        }
    }
}
#endif
#endif
