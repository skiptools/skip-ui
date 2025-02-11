// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
import Foundation
#if canImport(Observation)
import Observation
#endif

#if SKIP
import android.content.res.Configuration
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.adaptive.ExperimentalMaterial3AdaptiveApi
import androidx.compose.material3.adaptive.currentWindowAdaptiveInfo
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.ProvidableCompositionLocal
import androidx.compose.runtime.compositionLocalOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.platform.LocalUriHandler
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import kotlin.reflect.full.companionObjectInstance
#endif

public protocol EnvironmentKey {
    associatedtype Value
}

#if SKIP
/// Added to `EnvironmentKey` companion objects.
public protocol EnvironmentKeyCompanion {
    associatedtype Value
    var defaultValue: Value { get }
}
#endif

// Model as a class because our implementation only holds the global environment keys, and so does not need to copy.
// Each key handles its own scoping of values using Android's `CompositionLocal` system
public final class EnvironmentValues {
    public static let shared = EnvironmentValues()

    #if SKIP
    // We type erase all keys and values. The alternative would be to reify these functions.
    let compositionLocals: MutableMap<Any, ProvidableCompositionLocal<Any>> = mutableMapOf()
    let lastSetValues: MutableMap<ProvidableCompositionLocal<Any>, Any> = mutableMapOf()
    let lastSetActions: MutableList<@Composable () -> Void> = mutableListOf()

    // SKIP DECLARE: @Composable operator fun <Key, Value> get(key: KClass<Key>): Value where Key: EnvironmentKey<Value>
    /// Retrieve an environment value by its `EnvironmentKey`.
    public func get(key: AnyHashable) -> Any {
        let compositionLocal = valueCompositionLocal(key: key)
        return compositionLocal.current as! Value
     }

    // SKIP DECLARE: @Composable fun <ObjectType> environmentObject(type: KClass<ObjectType>): ObjectType? where ObjectType: Any
    /// Retrieve an environment object by type.
    public func environmentObject<ObjectType>(type: ObjectType.Type) -> ObjectType? {
        let compositionLocal = objectCompositionLocal(type: type)
        let value = compositionLocal.current
        return value == Unit ? nil : value as! ObjectType
    }

    /// Set environment values.
    ///
    /// - Seealso: ``View/environment(_:)``
    /// - Warning: Setting environment values should only be done within the `execute` block of this function.
    @Composable func setValues(_ execute: @Composable (EnvironmentValues) -> Void, in content: @Composable () -> Void) {
        // Set the values in EnvironmentValues to keep any user-defined setter logic in place, then retrieve and clear the last set values
        execute(self)
        for action in lastSetActions {
            action()
        }
        lastSetActions.clear()
        let provided = lastSetValues.map { entry in
            // SKIP INSERT: val element = entry.key provides entry.value
            element
        }.toTypedArray()
        lastSetValues.clear()
        CompositionLocalProvider(*provided) {
            content()
        }
    }

    // On set we populate our `lastSetValues` map, which our `setValues` function reads from and then clears after
    // packaging the values for sending to downstream Composables. This should be safe to do even on this effectively
    // global object because it should only be occurring sequentially on the main thread.

    // SKIP DECLARE: operator fun <Key, Value> set(key: KClass<Key>, value: Value) where Key: EnvironmentKey<Value>, Value: Any
    public func set(key: AnyHashable, value: Any) {
        let compositionLocal = valueCompositionLocal(key: key)
        lastSetValues[compositionLocal] = value
    }

    @Composable public func bridged(key: String) -> EnvironmentSupport? {
        if let builtinValue = builtinBridged(key: key) {
            return builtinValue
        }
        let compositionLocal = bridgedCompositionLocal(key: key)
        let value = compositionLocal.current
        return value == Unit ? nil : value as! EnvironmentSupport
    }

    public func setBridged(key: String, value: EnvironmentSupport?) {
        let compositionLocal = bridgedCompositionLocal(key: key)
        lastSetValues[compositionLocal] = value ?? Unit
    }

    /// The Compose `CompositionLocal` for the given environment value key type.
    public func valueCompositionLocal(key: Any.Type) -> ProvidableCompositionLocal<Any> {
        // SKIP INSERT: val defaultValue = { (key.companionObjectInstance as EnvironmentKeyCompanion<*>).defaultValue }
        return compositionLocal(key: key, defaultValue: defaultValue)
    }

    /// The Compose `CompositionLocal` for the given environment object type.
    public func objectCompositionLocal(type: Any.Type) -> ProvidableCompositionLocal<Any> {
        return compositionLocal(key: type, defaultValue: { nil })
    }

    /// The Compose `CompositionLocal` for the given bridged key.
    public func bridgedCompositionLocal(key: String) -> ProvidableCompositionLocal<Any> {
        return compositionLocal(key: key, defaultValue: { nil })
    }

    func compositionLocal(key: AnyHashable, defaultValue: () -> Any?) -> ProvidableCompositionLocal<Any> {
        if let value = compositionLocals[key] {
            return value
        }
        let value = compositionLocalOf { defaultValue() ?? Unit }
        compositionLocals[key] = value
        return value
    }
    #endif
}

extension View {
    #if SKIP
    // Use inline final func to get reified generic type
    @inline(__always) public final func environment<T>(_ object: T?) -> any View {
        return environmentObject(type: T.self, object: object)
    }
    #else
    public func environment<T>(_ object: T?) -> any View {
        return self
    }
    #endif

    public func environmentObject(_ object: Any) -> any View {
        return environmentObject(type: type(of: object), object: object)
    }

    // Must be public to allow access from our inline `environment` function.
    public func environmentObject(type: Any.Type, object: Any?) -> any View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            let compositionLocal = EnvironmentValues.shared.objectCompositionLocal(type: type)
            let value = object ?? Unit
            // SKIP INSERT: val provided = compositionLocal provides value
            CompositionLocalProvider(provided) { view.Compose(context: context) }
        }
        #else
        return self
        #endif
    }

    // We rely on the transpiler to turn the `WriteableKeyPath` provided in code into a `setValue` closure
    public func environment<V>(_ setValue: (V) -> Void, _ value: V) -> any View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            EnvironmentValues.shared.setValues {
                _ in setValue(value)
            } in: {
                view.Compose(context: context)
            }
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func environment(bridgedKey: String, value: EnvironmentSupport?) -> any View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            EnvironmentValues.shared.setValues {
                $0.setBridged(key: bridgedKey, value: value)
            } in: {
                view.Compose(context: context)
            }
        }
        #else
        return self
        #endif
    }
}

#if SKIP

// The transpiler translates the `EnvironmentValues` extension vars we add (or when apps add their own) from a
// get/set var into a get-only @Composable var and a setter function. @Composable vars cannot have setters

extension EnvironmentValues {
    @Composable private func builtinValue(key: AnyHashable, defaultValue: () -> Any?) -> Any? {
        let compositionLocal = compositionLocal(key: key, defaultValue: defaultValue)
        let current = compositionLocal.current
        return current == Unit ? nil : current
    }

    private func setBuiltinValue(key: AnyHashable, value: Any?, defaultValue: () -> Any?) {
        let compositionLocal = compositionLocal(key: key, defaultValue: defaultValue)
        lastSetValues[compositionLocal] = value ?? Unit
    }

    @Composable private func builtinBridged(key: String) -> EnvironmentSupport? {
        // NOTE: We also maintain equivalent code in SkipFuseUI.EnvironmentValues.
        // It would be nice to come up with a better way to do this...
        switch key {
        case "colorScheme":
            return EnvironmentSupport(builtinValue: colorScheme.rawValue)
        default:
            return nil
        }
    }

    // MARK: - Public values

    public var autocorrectionDisabled: Bool {
        return _keyboardOptions?.autoCorrect == false
    }

    public var backgroundStyle: ShapeStyle? {
        get { builtinValue(key: "backgroundStyle", defaultValue: { nil }) as! ShapeStyle? }
        // Avoid recursive background style lookup
        set { setBuiltinValue(key: "backgroundStyle", value: newValue is BackgroundStyle ? nil : newValue, defaultValue: { nil }) }
    }

    public var colorScheme: ColorScheme {
        get { ColorScheme.fromMaterialTheme() }
        set {
            // Implemented as a special case in .colorScheme and .preferredColorScheme, because Compose forces us to go through MaterialTheme
            // rather than exposing its LocalColorScheme.current provider
        }
    }

    public var dismiss: DismissAction {
        get { builtinValue(key: "dismiss", defaultValue: { DismissAction.default }) as! DismissAction }
        set { setBuiltinValue(key: "dismiss", value: newValue, defaultValue: { DismissAction.default }) }
    }

    public var font: Font? {
        get { builtinValue(key: "font", defaultValue: { nil }) as! Font? }
        set { setBuiltinValue(key: "font", value: newValue, defaultValue: { nil }) }
    }

    // SKIP INSERT: @OptIn(ExperimentalMaterial3AdaptiveApi::class)
    public var horizontalSizeClass: UserInterfaceSizeClass? {
        UserInterfaceSizeClass.fromWindowWidthSizeClass(currentWindowAdaptiveInfo().windowSizeClass.windowWidthSizeClass)
    }

    public var isEnabled: Bool {
        get { builtinValue(key: "isEnabled", defaultValue: { true }) as! Bool }
        set { setBuiltinValue(key: "isEnabled", value: newValue, defaultValue: { true }) }
    }

    public var isSearching: Bool {
        return _searchableState?.isSearching.value == true
    }

    public var layoutDirection: LayoutDirection {
        get { LocalLayoutDirection.current == androidx.compose.ui.unit.LayoutDirection.Rtl ? LayoutDirection.rightToLeft : LayoutDirection.leftToRight }
        set { lastSetValues[LocalLayoutDirection as! ProvidableCompositionLocal<Any>] = newValue == LayoutDirection.rightToLeft ? androidx.compose.ui.unit.LayoutDirection.Rtl : androidx.compose.ui.unit.LayoutDirection.Ltr }
    }

    public var lineLimit: Int? {
        get { builtinValue(key: "lineLimit", defaultValue: { nil }) as! Int? }
        set { setBuiltinValue(key: "lineLimit", value: newValue, defaultValue: { nil }) }
    }

    public var locale: Locale {
        get { Locale(LocalConfiguration.current.locales[0]) }
        set {
            let action: @Composable () -> Void = {
                // Requires a @Composable context to copy LocalConfiguration.current
                let configuration = Configuration(LocalConfiguration.current)
                configuration.setLocale(newValue.kotlin())
                lastSetValues[LocalConfiguration as! ProvidableCompositionLocal<Any>] = configuration
            }
            lastSetActions.add(action)
        }
    }

    public var multilineTextAlignment: TextAlignment {
        get { builtinValue(key: "multilineTextAlignment", defaultValue: { TextAlignment.leading }) as! TextAlignment }
        set { setBuiltinValue(key: "multilineTextAlignment", value: newValue, defaultValue: { TextAlignment.leading }) }
    }

    public var openURL: OpenURLAction {
        get {
            let uriHandler = LocalUriHandler.current
            let openURLAction = builtinValue(key: "openURL", defaultValue: { OpenURLAction.default }) as! OpenURLAction
            return OpenURLAction(handler: openURLAction.handler, systemHandler: { uriHandler.openUri($0.absoluteString) })
        }
        set { setBuiltinValue(key: "openURL", value: newValue, defaultValue: { OpenURLAction.default }) }
    }

    public var redactionReasons: RedactionReasons {
        get { builtinValue(key: "redactionReasons", defaultValue: { RedactionReasons(rawValue: 0) }) as! RedactionReasons }
        set { setBuiltinValue(key: "redactionReasons", value: newValue, defaultValue: { RedactionReasons(rawValue: 0) }) }
    }

    public var refresh: RefreshAction? {
        get { builtinValue(key: "refresh", defaultValue: { nil }) as! RefreshAction? }
        set { setBuiltinValue(key: "refresh", value: newValue, defaultValue: { nil }) }
    }

    public var scenePhase: ScenePhase {
        switch UIApplication.shared.applicationState {
        case .active:
            return ScenePhase.active
        case .inactive:
            return ScenePhase.inactive
        case .background:
            return ScenePhase.background
        }
    }

    public var timeZone: TimeZone {
        get { builtinValue(key: "timeZone", defaultValue: { TimeZone.current }) as! TimeZone }
        set { setBuiltinValue(key: "timeZone", value: newValue, defaultValue: { TimeZone.current }) }
    }

    // SKIP INSERT: @OptIn(ExperimentalMaterial3AdaptiveApi::class)
    public var verticalSizeClass: UserInterfaceSizeClass? {
        UserInterfaceSizeClass.fromWindowHeightSizeClass(currentWindowAdaptiveInfo().windowSizeClass.windowHeightSizeClass)
    }

    /* Not yet supported
    var accessibilityDimFlashingLights: Bool
    var accessibilityDifferentiateWithoutColor: Bool
    var accessibilityEnabled: Bool
    var accessibilityInvertColors: Bool
    var accessibilityLargeContentViewerEnabled: Bool
    var accessibilityPlayAnimatedImages: Bool
    var accessibilityPrefersHeadAnchorAlternative: Bool
    var accessibilityQuickActionsEnabled: Bool
    var accessibilityReduceMotion: Bool
    var accessibilityReduceTransparency: Bool
    var accessibilityShowButtonShapes: Bool
    var accessibilitySwitchControlEnabled: Bool
    var accessibilityVoiceOverEnabled: Bool
    var legibilityWeight: LegibilityWeight?

    var dismissSearch: DismissSearchAction
    var dismissWindow: DismissWindowAction
    var openImmersiveSpace: OpenImmersiveSpaceAction
    var dismissImmersiveSpace: DismissImmersiveSpaceAction
    var newDocument: NewDocumentAction
    var openDocument: OpenDocumentAction
    var openWindow: OpenWindowAction
    var purchase: PurchaseAction
    var rename: RenameAction?
    var resetFocus: ResetFocusAction
    var authorizationController: AuthorizationController
    var webAuthenticationSession: WebAuthenticationSession

    var buttonRepeatBehavior: ButtonRepeatBehavior
    var controlSize: ControlSize
    var controlActiveState: ControlActiveState
    var defaultWheelPickerItemHeight: CGFloat
    var keyboardShortcut: KeyboardShortcut?
    var menuIndicatorVisibility: Visibility
    var menuOrder: MenuOrder
    var searchSuggestionsPlacement: SearchSuggestionsPlacement
    var colorSchemeContrast: ColorSchemeContrast
    var displayScale: CGFloat
    var imageScale: Image.Scale
    var pixelLength: CGFloat
    var sidebarRowSize: SidebarRowSize
    var calendar: Calendar
    var documentConfiguration: DocumentConfiguration?
    var managedObjectContext: NSManagedObjectContext
    var modelContext: ModelContext
    var undoManager: UndoManager?

    var isScrollEnabled: Bool
    var horizontalScrollIndicatorVisibility: ScrollIndicatorVisibility
    var verticalScrollIndicatorVisibility: ScrollIndicatorVisibility
    var scrollDismissesKeyboardMode: ScrollDismissesKeyboardMode
    var horizontalScrollBounceBehavior: ScrollBounceBehavior
    var verticalScrollBounceBehavior: ScrollBounceBehavior

    var editMode: Binding<EditMode>?
    var isActivityFullscreen: Bool
    var isFocused: Bool
    var isHoverEffectEnabled: Bool
    var isLuminanceReduced: Bool
    var isPresented: Bool
    var isSceneCaptured: Bool
    var supportsMultipleWindows: Bool

    var displayStoreKitMessage: DisplayMessageAction
    var requestReview: RequestReviewAction

    var allowsTightening: Bool
    var dynamicTypeSize: DynamicTypeSize
    var lineSpacing: CGFloat
    var minimumScaleFactor: CGFloat
    var textCase: Text.Case?
    var truncationMode: Text.TruncationMode

    var allowedDynamicRange: Image.DynamicRange?
    var backgroundMaterial: Material?
    var backgroundProminence: BackgroundProminence
    var badgeProminence: BadgeProminence
    var contentTransition: ContentTransition
    var contentTransitionAddsDrawingGroup: Bool
    var defaultMinListHeaderHeight: CGFloat?
    var defaultMinListRowHeight: CGFloat
    var isFocusEffectEnabled: Bool
    var headerProminence: Prominence
    var physicalMetrics: PhysicalMetricsConverter
    var springLoadingBehavior: SpringLoadingBehavior
    var symbolRenderingMode: SymbolRenderingMode?
    var symbolVariants: SymbolVariants

    var showsWidgetContainerBackground: Bool
    var showsWidgetLabel: Bool
    var widgetFamily: WidgetFamily
    var widgetRenderingMode: WidgetRenderingMode
    var widgetContentMargins: EdgeInsets
    */

    // MARK: - Internal values

    var _animation: Animation? {
        get { builtinValue(key: "_animation", defaultValue: { nil }) as! Animation? }
        set { setBuiltinValue(key: "_animation", value: newValue, defaultValue: { nil }) }
    }

    var _aspectRatio: (CGFloat?, ContentMode)? {
        get { builtinValue(key: "_aspectRatio", defaultValue: { nil }) as! (CGFloat?, ContentMode)? }
        set { setBuiltinValue(key: "_aspectRatio", value: newValue, defaultValue: { nil }) }
    }

    var _buttonStyle: ButtonStyle? {
        get { builtinValue(key: "_buttonStyle", defaultValue: { nil }) as! ButtonStyle? }
        set { setBuiltinValue(key: "_buttonStyle", value: newValue, defaultValue: { nil }) }
    }

    var _contentPadding: EdgeInsets {
        get { builtinValue(key: "_contentPadding", defaultValue: { EdgeInsets() }) as! EdgeInsets }
        set { setBuiltinValue(key: "_contentPadding", value: newValue, defaultValue: { EdgeInsets() }) }
    }

    var _fillHeight: (@Composable () -> Modifier)? {
        get { builtinValue(key: "_fillHeight", defaultValue: { nil }) as! (@Composable () -> Modifier)? }
        set { setBuiltinValue(key: "_fillHeight", value: newValue, defaultValue: { nil }) }
    }

    var _fillWidth: (@Composable () -> Modifier)? {
        get { builtinValue(key: "_fillWidth", defaultValue: { nil }) as! (@Composable () -> Modifier)? }
        set { setBuiltinValue(key: "_fillWidth", value: newValue, defaultValue: { nil }) }
    }

    var _fillHeightModifier: Modifier? {
        get { builtinValue(key: "_fillHeightModifier", defaultValue: { nil }) as! Modifier? }
        set { setBuiltinValue(key: "_fillHeightModifier", value: newValue, defaultValue: { nil }) }
    }

    var _fillWidthModifier: Modifier? {
        get { builtinValue(key: "_fillWidthModifier", defaultValue: { nil }) as! Modifier? }
        set { setBuiltinValue(key: "_fillWidthModifier", value: newValue, defaultValue: { nil }) }
    }

    var _foregroundStyle: ShapeStyle? {
        get { builtinValue(key: "_foregroundStyle", defaultValue: { nil }) as! ShapeStyle? }
        // Avoid recursive foreground style lookup
        set { setBuiltinValue(key: "_foregroundStyle", value: newValue is ForegroundStyle ? nil : newValue, defaultValue: { nil }) }
    }

    var _isEdgeToEdge: Bool? {
        get { builtinValue(key: "_isEdgeToEdge", defaultValue: { nil }) as! Bool? }
        set { setBuiltinValue(key: "_isEdgeToEdge", value: newValue, defaultValue: { nil }) }
    }

    var _keyboardOptions: KeyboardOptions? {
        get { builtinValue(key: "_keyboardOptions", defaultValue: { nil }) as! KeyboardOptions? }
        set { setBuiltinValue(key: "_keyboardOptions", value: newValue, defaultValue: { nil }) }
    }

    var _labelsHidden: Bool {
        get { builtinValue(key: "_labelsHidden", defaultValue: { false }) as! Bool }
        set { setBuiltinValue(key: "_labelsHidden", value: newValue, defaultValue: { false }) }
    }

    var _labelStyle: LabelStyle? {
        get { builtinValue(key: "_labelStyle", defaultValue: { nil }) as! LabelStyle? }
        set { setBuiltinValue(key: "_labelStyle", value: newValue, defaultValue: { nil }) }
    }

    var _layoutAxis: Axis? {
        get { builtinValue(key: "_layoutAxis", defaultValue: { nil }) as! Axis? }
        set { setBuiltinValue(key: "_layoutAxis", value: newValue, defaultValue: { nil }) }
    }

    /// The axes that are unbound due to scrolling.
    ///
    /// This is different than `_scrollAxes`, because using a fixed size container or applying a different layout axis
    /// can bound a scrollable layout axis and remove it from this set.
    var _layoutScrollAxes: Axis.Set {
        get { builtinValue(key: "_layoutScrollAxes", defaultValue: { Axis.Set(rawValue: 0) }) as! Axis.Set }
        set { setBuiltinValue(key: "_layoutScrollAxes", value: newValue, defaultValue: { Axis.Set(rawValue: 0) }) }
    }

    var _listItemTint: Color? {
        get { builtinValue(key: "_listItemTint", defaultValue: { nil }) as! Color? }
        set { setBuiltinValue(key: "_listItemTint", value: newValue, defaultValue: { nil }) }
    }

    var _listSectionHeaderStyle: ListStyle? {
        get { builtinValue(key: "_listSectionHeaderStyle", defaultValue: { nil }) as! ListStyle? }
        set { setBuiltinValue(key: "_listSectionHeaderStyle", value: newValue, defaultValue: { nil }) }
    }

    var _listSectionFooterStyle: ListStyle? {
        get { builtinValue(key: "_listSectionFooterStyle", defaultValue: { nil }) as! ListStyle? }
        set { setBuiltinValue(key: "_listSectionFooterStyle", value: newValue, defaultValue: { nil }) }
    }

    var _listStyle: ListStyle? {
        get { builtinValue(key: "_listStyle", defaultValue: { nil }) as! ListStyle? }
        set { setBuiltinValue(key: "_listStyle", value: newValue, defaultValue: { nil }) }
    }

    var _material3BottomAppBar: (@Composable (Material3BottomAppBarOptions) -> Material3BottomAppBarOptions)? {
        get { builtinValue(key: "_material3BottomAppBar", defaultValue: { nil }) as! (@Composable (Material3BottomAppBarOptions) -> Material3BottomAppBarOptions)? }
        set { setBuiltinValue(key: "_material3BottomAppBar", value: newValue, defaultValue: { nil }) }
    }

    var _material3Button: (@Composable (Material3ButtonOptions) -> Material3ButtonOptions)? {
        get { builtinValue(key: "_material3Button", defaultValue: { nil }) as! (@Composable (Material3ButtonOptions) -> Material3ButtonOptions)? }
        set { setBuiltinValue(key: "_material3Button", value: newValue, defaultValue: { nil }) }
    }

    var _material3ColorScheme: (@Composable (androidx.compose.material3.ColorScheme, Bool) -> androidx.compose.material3.ColorScheme)? {
        get { builtinValue(key: "_material3ColorScheme", defaultValue: { nil }) as! (@Composable (androidx.compose.material3.ColorScheme, Bool) -> androidx.compose.material3.ColorScheme)? }
        set { setBuiltinValue(key: "_material3ColorScheme", value: newValue, defaultValue: { nil }) }
    }

    var _material3NavigationBar: (@Composable (Material3NavigationBarOptions) -> Material3NavigationBarOptions)? {
        get { builtinValue(key: "_material3NavigationBar", defaultValue: { nil }) as! (@Composable (Material3NavigationBarOptions) -> Material3NavigationBarOptions)? }
        set { setBuiltinValue(key: "_material3NavigationBar", value: newValue, defaultValue: { nil }) }
    }

    var _material3SegmentedButton: (@Composable (Material3SegmentedButtonOptions) -> Material3SegmentedButtonOptions)? {
        get { builtinValue(key: "_material3SegmentedButton", defaultValue: { nil }) as! (@Composable (Material3SegmentedButtonOptions) -> Material3SegmentedButtonOptions)? }
        set { setBuiltinValue(key: "_material3SegmentedButton", value: newValue, defaultValue: { nil }) }
    }

    var _material3Text: (@Composable (Material3TextOptions) -> Material3TextOptions)? {
        get { builtinValue(key: "_material3Text", defaultValue: { nil }) as! (@Composable (Material3TextOptions) -> Material3TextOptions)? }
        set { setBuiltinValue(key: "_material3Text", value: newValue, defaultValue: { nil }) }
    }

    var _material3TextField: (@Composable (Material3TextFieldOptions) -> Material3TextFieldOptions)? {
        get { builtinValue(key: "_material3TextField", defaultValue: { nil }) as! (@Composable (Material3TextFieldOptions) -> Material3TextFieldOptions)? }
        set { setBuiltinValue(key: "_material3TextField", value: newValue, defaultValue: { nil }) }
    }

    var _material3TopAppBar: (@Composable (Material3TopAppBarOptions) -> Material3TopAppBarOptions)? {
        get { builtinValue(key: "_material3TopAppBar", defaultValue: { nil }) as! (@Composable (Material3TopAppBarOptions) -> Material3TopAppBarOptions)? }
        set { setBuiltinValue(key: "_material3TopAppBar", value: newValue, defaultValue: { nil }) }
    }

    var _onSubmitState: OnSubmitState? {
        get { builtinValue(key: "_onSubmitState", defaultValue: { nil }) as! OnSubmitState? }
        set { setBuiltinValue(key: "_onSubmitState", value: newValue, defaultValue: { nil }) }
    }

    var _pickerStyle: PickerStyle? {
        get { builtinValue(key: "_pickerStyle", defaultValue: { nil }) as! PickerStyle? }
        set { setBuiltinValue(key: "_pickerStyle", value: newValue, defaultValue: { nil }) }
    }

    var _placement: ViewPlacement {
        get { builtinValue(key: "_placement", defaultValue: { ViewPlacement(rawValue: 0) }) as! ViewPlacement }
        set { setBuiltinValue(key: "_placement", value: newValue, defaultValue: { ViewPlacement(rawValue: 0) }) }
    }

    var _progressViewStyle: ProgressViewStyle? {
        get { builtinValue(key: "_progressViewStyle", defaultValue: { nil }) as! ProgressViewStyle? }
        set { setBuiltinValue(key: "_progressViewStyle", value: newValue, defaultValue: { nil }) }
    }

    var _tabViewStyle: TabViewStyle? {
        get { builtinValue(key: "_tabViewStyle", defaultValue: { nil }) as! TabViewStyle? }
        set { setBuiltinValue(key: "_tabViewStyle", value: newValue, defaultValue: { nil }) }
    }

    var _safeArea: SafeArea? {
        get { builtinValue(key: "_safeArea", defaultValue: { nil }) as! SafeArea? }
        set { setBuiltinValue(key: "_safeArea", value: newValue, defaultValue: { nil }) }
    }

    var _scrollAxes: Axis.Set {
        get { builtinValue(key: "_scrollAxes", defaultValue: { Axis.Set(rawValue: 0) }) as! Axis.Set }
        set { setBuiltinValue(key: "_scrollAxes", value: newValue, defaultValue: { Axis.Set(rawValue: 0) }) }
    }

    var _scrollContentBackground: Visibility? {
        get { builtinValue(key: "_scrollContentBackground", defaultValue: { nil }) as! Visibility? }
        set { setBuiltinValue(key: "_scrollContentBackground", value: newValue, defaultValue: { nil }) }
    }

    /// While `_scrollAxes` contains the effective scroll directions, this property contains the nominal directions
    /// of any ancestor scroll view.
    var _scrollViewAxes: Axis.Set {
        get { builtinValue(key: "_scrollViewAxes", defaultValue: { Axis.Set(rawValue: 0) }) as! Axis.Set }
        set { setBuiltinValue(key: "_scrollViewAxes", value: newValue, defaultValue: { Axis.Set(rawValue: 0) }) }
    }

    var _searchableState: SearchableState? {
        get { builtinValue(key: "_searchableState", defaultValue: { nil }) as! SearchableState? }
        set { setBuiltinValue(key: "_searchableState", value: newValue, defaultValue: { nil }) }
    }

    var _sheetDepth: Int {
        get { builtinValue(key: "_sheetDepth", defaultValue: { 0 }) as! Int }
        set { setBuiltinValue(key: "_sheetDepth", value: newValue, defaultValue: { 0 }) }
    }

    var _textEnvironment: TextEnvironment {
        get { builtinValue(key: "_textEnvironment", defaultValue: { TextEnvironment() }) as! TextEnvironment }
        set { setBuiltinValue(key: "_textEnvironment", value: newValue, defaultValue: { TextEnvironment() }) }
    }

    var _textFieldStyle: TextFieldStyle? {
        get { builtinValue(key: "_textFieldStyle", defaultValue: { nil }) as! TextFieldStyle? }
        set { setBuiltinValue(key: "_textFieldStyle", value: newValue, defaultValue: { nil }) }
    }

    var _tint: Color? {
        get { builtinValue(key: "_tint", defaultValue: { nil }) as! Color? }
        set { setBuiltinValue(key: "_tint", value: newValue, defaultValue: { nil }) }
    }
}
#endif

#if false
import protocol Combine.ObservableObject
import struct CoreGraphics.CGFloat
import struct Foundation.Calendar
import struct Foundation.TimeZone
import struct Foundation.Locale

/// A property wrapper that reads a value from a view's environment.
///
/// Use the `Environment` property wrapper to read a value
/// stored in a view's environment. Indicate the value to read using an
/// ``EnvironmentValues`` key path in the property declaration. For example, you
/// can create a property that reads the color scheme of the current
/// view using the key path of the ``EnvironmentValues/colorScheme``
/// property:
///
///     @Environment(\.colorScheme) var colorScheme: ColorScheme
///
/// You can condition a view's content on the associated value, which
/// you read from the declared property's ``wrappedValue``. As with any property
/// wrapper, you access the wrapped value by directly referring to the property:
///
///     if colorScheme == .dark { // Checks the wrapped value.
///         DarkContent()
///     } else {
///         LightContent()
///     }
///
/// If the value changes, SkipUI updates any parts of your view that depend on
/// the value. For example, that might happen in the above example if the user
/// changes the Appearance settings.
///
/// You can use this property wrapper to read --- but not set --- an environment
/// value. SkipUI updates some environment values automatically based on system
/// settings and provides reasonable defaults for others. You can override some
/// of these, as well as set custom environment values that you define,
/// using the ``View/environment(_:_:)`` view modifier.
///
/// For the complete list of environment values provided by SkipUI, see the
/// properties of the ``EnvironmentValues`` structure. For information about
/// creating custom environment values, see the ``EnvironmentKey`` protocol.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen @propertyWrapper public struct Environment<Value> : DynamicProperty {

    /// Creates an environment property to read the specified key path.
    ///
    /// Don’t call this initializer directly. Instead, declare a property
    /// with the ``Environment`` property wrapper, and provide the key path of
    /// the environment value that the property should reflect:
    ///
    ///     struct MyView: View {
    ///         @Environment(\.colorScheme) var colorScheme: ColorScheme
    ///
    ///         // ...
    ///     }
    ///
    /// SkipUI automatically updates any parts of `MyView` that depend on
    /// the property when the associated environment value changes.
    /// You can't modify the environment value using a property like this.
    /// Instead, use the ``View/environment(_:_:)`` view modifier on a view to
    /// set a value for a view hierarchy.
    ///
    /// - Parameter keyPath: A key path to a specific resulting value.
    @inlinable public init(_ keyPath: KeyPath<EnvironmentValues, Value>) { fatalError() }

    /// The current value of the environment property.
    ///
    /// The wrapped value property provides primary access to the value's data.
    /// However, you don't access `wrappedValue` directly. Instead, you read the
    /// property variable created with the ``Environment`` property wrapper:
    ///
    ///     @Environment(\.colorScheme) var colorScheme: ColorScheme
    ///
    ///     var body: some View {
    ///         if colorScheme == .dark {
    ///             DarkContent()
    ///         } else {
    ///             LightContent()
    ///         }
    ///     }
    ///
    @inlinable public var wrappedValue: Value { get { fatalError() } }
}

extension Environment {

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init(_ objectType: Value.Type) where Value : AnyObject, Value : Observable { fatalError() }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init<T>(_ objectType: T.Type) where Value == T?, T : AnyObject, T : Observable { fatalError() }
}

/// A property wrapper type for an observable object supplied by a parent or
/// ancestor view.
///
/// An environment object invalidates the current view whenever the observable
/// object changes. If you declare a property as an environment object, be sure
/// to set a corresponding model object on an ancestor view by calling its
/// ``View/environmentObject(_:)`` modifier.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen @propertyWrapper public struct EnvironmentObject<ObjectType> : DynamicProperty where ObjectType : ObservableObject {

    /// A wrapper of the underlying environment object that can create bindings
    /// to its properties using dynamic member lookup.
    @dynamicMemberLookup @frozen public struct Wrapper {

        /// Returns a binding to the resulting value of a given key path.
        ///
        /// - Parameter keyPath: A key path to a specific resulting value.
        ///
        /// - Returns: A new binding.
        public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>) -> Binding<Subject> { get { fatalError() } }
    }

    /// The underlying value referenced by the environment object.
    ///
    /// This property provides primary access to the value's data. However, you
    /// don't access `wrappedValue` directly. Instead, you use the property
    /// variable created with the ``EnvironmentObject`` attribute.
    ///
    /// When a mutable value changes, the new value is immediately available.
    /// However, a view displaying the value is updated asynchronously and may
    /// not show the new value immediately.
    @MainActor @inlinable public var wrappedValue: ObjectType { get { fatalError() } }

    /// A projection of the environment object that creates bindings to its
    /// properties using dynamic member lookup.
    ///
    /// Use the projected value to pass an environment object down a view
    /// hierarchy.
    @MainActor public var projectedValue: EnvironmentObject<ObjectType>.Wrapper { get { fatalError() } }

    /// Creates an environment object.
    public init() { fatalError() }
}

extension EnvironmentValues {
#if canImport(UIKit)
    /// Accesses the environment value associated with a custom key.
    ///
    /// Create custom environment values by defining a key
    /// that conforms to the ``EnvironmentKey`` protocol, and then using that
    /// key with the subscript operator of the ``EnvironmentValues`` structure
    /// to get and set a value for that key:
    ///
    ///     private struct MyEnvironmentKey: EnvironmentKey {
    ///         static let defaultValue: String = "Default value"
    ///     }
    ///
    ///     extension EnvironmentValues {
    ///         var myCustomValue: String {
    ///             get { self[MyEnvironmentKey.self] }
    ///             set { self[MyEnvironmentKey.self] = newValue }
    ///         }
    ///     }
    ///
    /// You use custom environment values the same way you use system-provided
    /// values, setting a value with the ``View/environment(_:_:)`` view
    /// modifier, and reading values with the ``Environment`` property wrapper.
    /// You can also provide a dedicated view modifier as a convenience for
    /// setting the value:
    ///
    ///     extension View {
    ///         func myCustomValue(_ myCustomValue: String) -> some View {
    ///             environment(\.myCustomValue, myCustomValue)
    ///         }
    ///     }
    ///
    @available(iOS 17.0, tvOS 17.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public subscript<K>(key: K.Type) -> K.Value where K : UITraitBridgedEnvironmentKey { get { fatalError() } }
    #endif
}

extension EnvironmentValues {

    /// A Boolean value that determines whether the view hierarchy has
    /// auto-correction enabled.
    ///
    /// When the value is `nil`, SkipUI uses the system default. The default
    /// value is `nil`.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "autocorrectionDisabled")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "autocorrectionDisabled")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "autocorrectionDisabled")
    @available(watchOS, introduced: 8.0, deprecated: 100000.0, renamed: "autocorrectionDisabled")
    public var disableAutocorrection: Bool? { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {

    /// The prominence of the background underneath views associated with this
    /// environment.
    ///
    /// Foreground elements above an increased prominence background are
    /// typically adjusted to have higher contrast against a potentially vivid
    /// color, such as taking on a higher opacity monochrome appearance
    /// according to the `colorScheme`. System styles like `primary`,
    /// `secondary`, etc will automatically resolve to an appropriate style in
    /// this context. The property can be read and used for custom styled
    /// elements.
    ///
    /// In the example below, a custom star rating element is in a list row
    /// alongside some text. When the row is selected and has an increased
    /// prominence appearance, the text and star rating will update their
    /// appearance, the star rating replacing its use of yellow with the
    /// standard `secondary` style.
    ///
    ///     struct RecipeList: View {
    ///         var recipes: [Recipe]
    ///         @Binding var selectedRecipe: Recipe.ID?
    ///
    ///         var body: some View {
    ///             List(recipes, selection: $selectedRecipe) {
    ///                 RecipeListRow(recipe: $0)
    ///             }
    ///         }
    ///     }
    ///
    ///     struct RecipeListRow: View {
    ///         var recipe: Recipe
    ///         var body: some View {
    ///             VStack(alignment: .leading) {
    ///                 HStack(alignment: .firstTextBaseline) {
    ///                     Text(recipe.name)
    ///                     Spacer()
    ///                     StarRating(rating: recipe.rating)
    ///                 }
    ///                 Text(recipe.description)
    ///                     .foregroundStyle(.secondary)
    ///                     .lineLimit(2, reservesSpace: true)
    ///             }
    ///         }
    ///     }
    ///
    ///     private struct StarRating: View {
    ///         var rating: Int
    ///
    ///         @Environment(\.backgroundProminence)
    ///         private var backgroundProminence
    ///
    ///         var body: some View {
    ///             HStack(spacing: 1) {
    ///                 ForEach(0..<rating, id: \.self) { _ in
    ///                     Image(systemName: "star.fill")
    ///                 }
    ///             }
    ///             .foregroundStyle(backgroundProminence == .increased ?
    ///                 AnyShapeStyle(.secondary) : AnyShapeStyle(.yellow))
    ///             .imageScale(.small)
    ///         }
    ///     }
    ///
    /// Note that the use of `backgroundProminence` was used by a view that
    /// was nested in additional stack containers within the row. This ensured
    /// that the value correctly reflected the environment within the list row
    /// itself, as opposed to the environment of the list as a whole. One way
    /// to ensure correct resolution would be to prefer using this in a custom
    /// ShapeStyle instead, for example:
    ///
    ///     private struct StarRating: View {
    ///         var rating: Int
    ///
    ///         var body: some View {
    ///             HStack(spacing: 1) {
    ///                 ForEach(0..<rating, id: \.self) { _ in
    ///                     Image(systemName: "star.fill")
    ///                 }
    ///             }
    ///             .foregroundStyle(FillStyle())
    ///             .imageScale(.small)
    ///         }
    ///     }
    ///
    ///     extension StarRating {
    ///         struct FillStyle: ShapeStyle {
    ///             func resolve(in env: EnvironmentValues) -> some ShapeStyle {
    ///                 switch env.backgroundProminence {
    ///                 case .increased: return AnyShapeStyle(.secondary)
    ///                 default: return AnyShapeStyle(.yellow)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// Views like `List` and `Table` as well as standard shape styles like
    /// `ShapeStyle.selection` will automatically update the background
    /// prominence of foreground views. For custom backgrounds, this environment
    /// property can be explicitly set on views above custom backgrounds.
    public var backgroundProminence: BackgroundProminence { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {

    /// The behavior of spring loaded interactions for the views associated
    /// with this environment.
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
    /// A value of `enabled` means that a view should support spring loaded
    /// interactions if it is able, and `disabled` means it should not.
    /// A value of `automatic` means that a view should follow its default
    /// behavior, such as a `TabView` automatically allowing spring loading,
    /// but a `Picker` with `segmented` style would not.
    public var springLoadingBehavior: SpringLoadingBehavior { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {

    /// The default minimum height of a row in a list.
    public var defaultMinListRowHeight: CGFloat { get { fatalError() } }

    /// The default minimum height of a header in a list.
    ///
    /// When this value is `nil`, the system chooses the appropriate height. The
    /// default is `nil`.
    public var defaultMinListHeaderHeight: CGFloat? { fatalError() }
}

extension EnvironmentValues {

    /// The maximum number of lines that text can occupy in a view.
    ///
    /// The maximum number of lines is `1` if the value is less than `1`. If the
    /// value is `nil`, the text uses as many lines as required. The default is
    /// `nil`.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public var lineLimit: Int? { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension EnvironmentValues {

    /// The prominence to apply to section headers within a view.
    ///
    /// The default is ``Prominence/standard``.
    public var headerProminence: Prominence { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension EnvironmentValues {

    /// The menu indicator visibility to apply to controls within a view.
    ///
    /// - Note: On tvOS, the standard button styles do not include a menu
    ///         indicator, so this modifier will have no effect when using a
    ///         built-in button style. You can implement an indicator in your
    ///         own ``ButtonStyle`` implementation by checking the value of this
    ///         environment value.
    public var menuIndicatorVisibility: Visibility { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension EnvironmentValues {

    /// The allowed dynamic range for the view, or nil.
    public var allowedDynamicRange: Image.DynamicRange? { get { fatalError() } }
}

extension EnvironmentValues {

    /// A Boolean that indicates whether the quick actions feature is enabled.
    ///
    /// The system uses quick actions to provide users with a
    /// fast alternative interaction method. Quick actions can be
    /// presented to users with a textual banner at the top of their
    /// screen and/or an outline around a view that is already on screen.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public var accessibilityQuickActionsEnabled: Bool { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {

    /// A Boolean value that indicates whether the view associated with this
    /// environment allows user interaction.
    ///
    /// The default value is `true`.
    public var isEnabled: Bool { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {

    /// A Boolean value that indicates whether the view associated with this
    /// environment allows focus effects to be displayed.
    ///
    /// The default value is `true`.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var isFocusEffectEnabled: Bool { get { fatalError() } }
}

extension EnvironmentValues {

    /// Returns whether the nearest focusable ancestor has focus.
    ///
    /// If there is no focusable ancestor, the value is `false`.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public var isFocused: Bool { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 8.0, *)
extension EnvironmentValues {

    /// A Boolean value that indicates whether the display or environment currently requires
    /// reduced luminance.
    ///
    /// When you detect this condition, lower the overall brightness of your view.
    /// For example, you can change large, filled shapes to be stroked, and choose
    /// less bright colors:
    ///
    ///     @Environment(\.isLuminanceReduced) var isLuminanceReduced
    ///
    ///     var body: some View {
    ///         if isLuminanceReduced {
    ///             Circle()
    ///                 .stroke(Color.gray, lineWidth: 10)
    ///         } else {
    ///             Circle()
    ///                 .fill(Color.white)
    ///         }
    ///     }
    ///
    /// In addition to the changes that you make, the system could also
    /// dim the display to achieve a suitable brightness. By reacting to
    /// `isLuminanceReduced`, you can preserve contrast and readability
    /// while helping to satisfy the reduced brightness requirement.
    ///
    /// > Note: On watchOS, the system typically sets this value to `true` when the user
    /// lowers their wrist, but the display remains on. Starting in watchOS 8, the system keeps your
    /// view visible on wrist down by default. If you want the system to blur the screen
    /// instead, as it did in earlier versions of watchOS, set the value for the
    /// key in your app's
    /// file to `false`.
    public var isLuminanceReduced: Bool { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EnvironmentValues {

    /// An window presentation action stored in a view's environment.
    ///
    /// Use the `openWindow` environment value to get an ``OpenWindowAction``
    /// instance for a given ``Environment``. Then call the instance to open
    /// a window. You call the instance directly because it defines a
    /// ``OpenWindowAction/callAsFunction(id:)`` method that Swift calls
    /// when you call the instance.
    ///
    /// For example, you can define a button that opens a new mail viewer
    /// window:
    ///
    ///     @main
    ///     struct Mail: App {
    ///         var body: some Scene {
    ///             WindowGroup(id: "mail-viewer") {
    ///                 MailViewer()
    ///             }
    ///         }
    ///     }
    ///
    ///     struct NewViewerButton: View {
    ///         @Environment(\.openWindow) private var openWindow
    ///
    ///         var body: some View {
    ///             Button("Open new mail viewer") {
    ///                 openWindow(id: "mail-viewer")
    ///             }
    ///         }
    ///     }
    ///
    /// You indicate which scene to open by providing one of the following:
    ///  * A string identifier that you pass through the `id` parameter,
    ///    as in the above example.
    ///  * A `value` parameter that has a type that matches the type that
    ///    you specify in the scene's initializer.
    ///  * Both an identifier and a value. This enables you to define
    ///    multiple window groups that take input values of the same type like a
    ///    .
    ///
    /// Use the first option to target either a ``WindowGroup`` or a
    /// ``Window`` scene in your app that has a matching identifier. For a
    /// `WindowGroup`, the system creates a new window for the group. If
    /// the window group presents data, the system provides the default value
    /// or `nil` to the window's root view. If the targeted scene is a
    /// `Window`, the system orders it to the front.
    ///
    /// Use the other two options to target a `WindowGroup` and provide
    /// a value to present. If the interface already has a window from
    /// the group that's presenting the specified value, the system brings the
    /// window to the front. Otherwise, the system creates a new window and
    /// passes a binding to the specified value.
    public var openWindow: OpenWindowAction { get { fatalError() } }
}

extension EnvironmentValues {

    /// An action that activates the standard rename interaction.
    ///
    /// Use the ``View/renameAction(_:)-6lghl`` modifier to configure the rename
    /// action in the environment.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public var rename: RenameAction? { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EnvironmentValues {

    /// A Boolean value that indicates whether the current platform supports
    /// opening multiple windows.
    ///
    /// Read this property from the environment to determine if your app can
    /// use the ``EnvironmentValues/openWindow`` action to open new windows:
    ///
    ///     struct NewMailViewerButton: View {
    ///         @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
    ///         @Environment(\.openWindow) private var openWindow
    ///
    ///         var body: some View {
    ///             Button("Open New Window") {
    ///                 openWindow(id: "mail-viewer")
    ///             }
    ///             .disabled(!supportsMultipleWindows)
    ///         }
    ///     }
    ///
    /// The reported value depends on both the platform and how you configure
    /// your app:
    ///
    /// * In macOS, this property returns `true` for any app that uses the
    ///   SkipUI app lifecycle.
    /// * In iPadOS, this property returns `true` for any app that uses the
    ///   SkipUI app lifecycle and has the Information Property List key
    ///  set to `true`.
    /// * For all other platforms and configurations, the value returns `false`.
    ///
    /// If the value is false and you try to open a window, SkipUI
    /// ignores the action and logs a runtime error.
    public var supportsMultipleWindows: Bool { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {

    /// The display scale of this environment.
    public var displayScale: CGFloat { get { fatalError() } }

    /// The image scale for this environment.
    @available(macOS 11.0, *)
    public var imageScale: Image.Scale { get { fatalError() } }

    /// The size of a pixel on the screen.
    ///
    /// This value is usually equal to `1` divided by
    /// ``EnvironmentValues/displayScale``.
    public var pixelLength: CGFloat { get { fatalError() } }

    /// The font weight to apply to text.
    ///
    /// This value reflects the value of the Bold Text display setting found in
    /// the Accessibility settings.
    public var legibilityWeight: LegibilityWeight? { get { fatalError() } }

    /// The current locale that views should use.
    public var locale: Locale { get { fatalError() } }

    /// The current calendar that views should use when handling dates.
    public var calendar: Calendar { get { fatalError() } }

    /// The current time zone that views should use when handling dates.
    public var timeZone: TimeZone { get { fatalError() } }
}

extension EnvironmentValues {

    /// The visiblity to apply to scroll indicators of any
    /// vertically scrollable content.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public var verticalScrollIndicatorVisibility: ScrollIndicatorVisibility { get { fatalError() } }

    /// The visibility to apply to scroll indicators of any
    /// horizontally scrollable content.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public var horizontalScrollIndicatorVisibility: ScrollIndicatorVisibility { get { fatalError() } }
}

extension EnvironmentValues {

    /// A Boolean value that indicates whether any scroll views associated
    /// with this environment allow scrolling to occur.
    ///
    /// The default value is `true`. Use the ``View/scrollDisabled(_:)``
    /// modifier to configure this property.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public var isScrollEnabled: Bool { get { fatalError() } }
}

extension EnvironmentValues {

    /// The way that scrollable content interacts with the software keyboard.
    ///
    /// The default value is ``ScrollDismissesKeyboardMode/automatic``. Use the
    /// ``View/scrollDismissesKeyboard(_:)`` modifier to configure this
    /// property.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public var scrollDismissesKeyboardMode: ScrollDismissesKeyboardMode { get { fatalError() } }
}

extension EnvironmentValues {

    /// The scroll bounce mode for the vertical axis of scrollable views.
    ///
    /// Use the ``View/scrollBounceBehavior(_:axes:)`` view modifier to set this
    /// value in the ``Environment``.
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
    public var verticalScrollBounceBehavior: ScrollBounceBehavior { get { fatalError() } }

    /// The scroll bounce mode for the horizontal axis of scrollable views.
    ///
    /// Use the ``View/scrollBounceBehavior(_:axes:)`` view modifier to set this
    /// value in the ``Environment``.
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
    public var horizontalScrollBounceBehavior: ScrollBounceBehavior { get { fatalError() } }
}

extension EnvironmentValues {

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public subscript<T>(objectType: T.Type) -> T? where T : AnyObject, T : Observable { get { fatalError() } }
}

@available(iOS 17.0, tvOS 17.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension EnvironmentValues {

    /// A Boolean value that indicates whether the view associated with this
    /// environment allows hover effects to be displayed.
    ///
    /// The default value is `true`.
    public var isHoverEffectEnabled: Bool { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {

    /// A Boolean value that indicates whether the user has enabled an assistive
    /// technology.
    public var accessibilityEnabled: Bool { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {

    /// Whether the system preference for Differentiate without Color is enabled.
    ///
    /// If this is true, UI should not convey information using color alone
    /// and instead should use shapes or glyphs to convey information.
    public var accessibilityDifferentiateWithoutColor: Bool { get { fatalError() } }

    /// Whether the system preference for Reduce Transparency is enabled.
    ///
    /// If this property's value is true, UI (mainly window) backgrounds should
    /// not be semi-transparent; they should be opaque.
    public var accessibilityReduceTransparency: Bool { get { fatalError() } }

    /// Whether the system preference for Reduce Motion is enabled.
    ///
    /// If this property's value is true, UI should avoid large animations,
    /// especially those that simulate the third dimension.
    public var accessibilityReduceMotion: Bool { get { fatalError() } }

    /// Whether the system preference for Invert Colors is enabled.
    ///
    /// If this property's value is true then the display will be inverted.
    /// In these cases it may be needed for UI drawing to be adjusted to in
    /// order to display optimally when inverted.
    public var accessibilityInvertColors: Bool { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension EnvironmentValues {

    /// Whether the system preference for Show Button Shapes is enabled.
    ///
    /// If this property's value is true, interactive custom controls
    /// such as buttons should be drawn in such a way that their edges
    /// and borders are clearly visible.
    public var accessibilityShowButtonShapes: Bool { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {

    /// Whether the setting to reduce flashing or strobing lights in video
    /// content is on. This setting can also be used to determine if UI in
    /// playback controls should be shown to indicate upcoming content that
    /// includes flashing or strobing lights.
    public var accessibilityDimFlashingLights: Bool { get { fatalError() } }

    /// Whether the setting for playing animations in an animated image is
    /// on. When this value is false, any presented image that contains
    /// animation should not play automatically.
    public var accessibilityPlayAnimatedImages: Bool { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension EnvironmentValues {

    /// A Boolean value that indicates whether the VoiceOver screen reader is in use.
    ///
    /// The state changes as the user turns on or off the VoiceOver screen reader.
    public var accessibilityVoiceOverEnabled: Bool { get { fatalError() } }

    /// A Boolean value that indicates whether the Switch Control motor accessibility feature is in use.
    ///
    /// The state changes as the user turns on or off the Switch Control feature.
    public var accessibilitySwitchControlEnabled: Bool { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension EnvironmentValues {

    /// The current Dynamic Type size.
    ///
    /// This value changes as the user's chosen Dynamic Type size changes. The
    /// default value is device-dependent.
    ///
    /// When limiting the Dynamic Type size, consider if adding a
    /// large content view with ``View/accessibilityShowsLargeContentViewer()``
    /// would be appropriate.
    ///
    /// On macOS, this value cannot be changed by users and does not affect the
    /// text size.
    public var dynamicTypeSize: DynamicTypeSize { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension EnvironmentValues {

    /// A Boolean value that indicates when the user is searching.
    ///
    /// You can read this value like any of the other ``EnvironmentValues``,
    /// by creating a property with the ``Environment`` property wrapper:
    ///
    ///     @Environment(\.isSearching) private var isSearching
    ///
    /// Get the value to find out when the user interacts with a search
    /// field that's produced by one of the searchable modifiers, like
    /// ``View/searchable(text:placement:prompt:)-18a8f``:
    ///
    ///     struct SearchingExample: View {
    ///         @State private var searchText = ""
    ///
    ///         var body: some View {
    ///             NavigationStack {
    ///                 SearchedView()
    ///                     .searchable(text: $searchText)
    ///             }
    ///         }
    ///     }
    ///
    ///     struct SearchedView: View {
    ///         @Environment(\.isSearching) private var isSearching
    ///
    ///         var body: some View {
    ///             Text(isSearching ? "Searching!" : "Not searching.")
    ///         }
    ///     }
    ///
    /// When the user first taps or clicks in a search field, the
    /// `isSearching` property becomes `true`. When the user cancels the
    /// search operation, the property becomes `false`. To programmatically
    /// set the value to `false` and dismiss the search operation, use
    /// ``EnvironmentValues/dismissSearch``.
    ///
    /// > Important: Access the value from inside the searched view, as the
    ///   example above demonstrates, rather than from the searched view’s
    ///   parent. SkipUI sets the value in the environment of the view that
    ///   you apply the searchable modifier to, and doesn’t propagate the
    ///   value up the view hierarchy.
    public var isSearching: Bool { get { fatalError() } }

    /// An action that ends the current search interaction.
    ///
    /// Use this environment value to get the ``DismissSearchAction`` instance
    /// for the current ``Environment``. Then call the instance to dismiss
    /// the current search interaction. You call the instance directly because
    /// it defines a ``DismissSearchAction/callAsFunction()`` method that Swift
    /// calls when you call the instance.
    ///
    /// When you dismiss search, SkipUI:
    ///
    /// * Sets ``EnvironmentValues/isSearching`` to `false`.
    /// * Clears any text from the search field.
    /// * Removes focus from the search field.
    ///
    /// > Note: Calling this instance has no effect if the user isn't
    /// interacting with a search field.
    ///
    /// Use this action to dismiss a search operation based on
    /// another user interaction. For example, consider a searchable
    /// view with a ``Button`` that presents more information about the first
    /// matching item from a collection:
    ///
    ///     struct ContentView: View {
    ///         @State private var searchText = ""
    ///
    ///         var body: some View {
    ///             NavigationStack {
    ///                 SearchedView(searchText: searchText)
    ///                     .searchable(text: $searchText)
    ///             }
    ///         }
    ///     }
    ///
    ///     private struct SearchedView: View {
    ///         let searchText: String
    ///
    ///         let items = ["a", "b", "c"]
    ///         var filteredItems: [String] { items.filter { $0 == searchText.lowercased() } }
    ///
    ///         @State private var isPresented = false
    ///         @Environment(\.dismissSearch) private var dismissSearch
    ///
    ///         var body: some View {
    ///             if let item = filteredItems.first {
    ///                 Button("Details about \(item)") {
    ///                     isPresented = true
    ///                 }
    ///                 .sheet(isPresented: $isPresented) {
    ///                     NavigationStack {
    ///                         DetailView(item: item, dismissSearch: dismissSearch)
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// The button becomes visible only after the user enters search text
    /// that produces a match. When the user taps the button, SkipUI shows
    /// a sheet that provides more information about the item, including
    /// an Add button for adding the item to a stored list of items:
    ///
    ///     private struct DetailView: View {
    ///         var item: String
    ///         var dismissSearch: DismissSearchAction
    ///
    ///         @Environment(\.dismiss) private var dismiss
    ///
    ///         var body: some View {
    ///             Text("Information about \(item).")
    ///                 .toolbar {
    ///                     Button("Add") {
    ///                         // Store the item here...
    ///
    ///                         dismiss()
    ///                         dismissSearch()
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// People can dismiss the sheet by dragging it down, effectively
    /// canceling the operation, leaving the in-progress search interaction
    /// intact. Alternatively, people can tap the Add button to store the item.
    /// Because the person using your app is likely to be done with both the
    /// detail view and the search interaction at this point, the button's
    /// closure also uses the ``EnvironmentValues/dismiss`` property to dismiss
    /// the sheet, and the ``EnvironmentValues/dismissSearch`` property to
    /// reset the search field.
    ///
    /// > Important: Access the action from inside the searched view, as the
    ///   example above demonstrates, rather than from the searched view’s
    ///   parent, or another hierarchy, like that of a sheet. SkipUI sets the
    ///   value in the environment of the view that you apply the searchable
    ///   modifier to, and doesn’t propagate the value up the view hierarchy.
    public var dismissSearch: DismissSearchAction { get { fatalError() } }

    /// The current placement of search suggestions.
    ///
    /// Search suggestions render based on the platform and surrounding context
    /// in which you place the searchable modifier containing suggestions.
    /// You can render search suggestions in two ways:
    ///
    /// * In a menu attached to the search field.
    /// * Inline with the main content of the app.
    ///
    /// You find the current search suggestion placement by querying the
    /// ``EnvironmentValues/searchSuggestionsPlacement`` in your
    /// search suggestions.
    ///
    ///     enum FruitSuggestion: String, Identifiable {
    ///         case apple, banana, orange
    ///         var id: Self { self }
    ///     }
    ///
    ///     @State private var text: String = ""
    ///     @State private var suggestions: [FruitSuggestion] = []
    ///
    ///     var body: some View {
    ///         MainContent()
    ///             .searchable(text: $text) {
    ///                 FruitSuggestions(suggestions: suggestions)
    ///             }
    ///     }
    ///
    ///     struct FruitSuggestions: View {
    ///         var suggestions: [FruitSuggestion]
    ///
    ///         @Environment(\.searchSuggestionsPlacement)
    ///         private var placement
    ///
    ///         var body: some View {
    ///             if shouldRender {
    ///                 ForEach(suggestions) { suggestion in
    ///                     Text(suggestion.rawValue.capitalized)
    ///                         .searchCompletion(suggestion.rawValue)
    ///                 }
    ///             }
    ///         }
    ///
    ///         var shouldRender: Bool {
    ///             #if os(iOS)
    ///             placement == .menu
    ///             #else
    ///             true
    ///             #endif
    ///         }
    ///     }
    ///
    /// In the above example, search suggestions only render in iOS
    /// if the searchable modifier displays them in a menu. You might want
    /// to do this to render suggestions in your own list alongside
    /// your own search results when they would render in a list.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public var searchSuggestionsPlacement: SearchSuggestionsPlacement { get { fatalError() } }
}

extension EnvironmentValues {

    /// The configuration of a document in a ``DocumentGroup``.
    ///
    /// The value is `nil` for views that are not enclosed in a ``DocumentGroup``.
    ///
    /// For example, if the app shows the document path in the footer
    /// of each document, it can get the URL from the environment:
    ///
    ///     struct ContentView: View {
    ///         @Binding var document: TextDocument
    ///         @Environment(\.documentConfiguration) private var configuration: DocumentConfiguration?
    ///
    ///         var body: some View {
    ///             …
    ///             Label(
    ///                 configuration?.fileURL?.path ??
    ///                     "", systemImage: "folder.circle"
    ///             )
    ///         }
    ///     }
    ///
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var documentConfiguration: DocumentConfiguration? { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EnvironmentValues {

    /// The keyboard shortcut that buttons in this environment will be triggered
    /// with.
    ///
    /// This is particularly useful in button styles when a button's appearance
    /// depends on the shortcut associated with it. On macOS, for example, when
    /// a button is bound to the Return key, it is typically drawn with a
    /// special emphasis. This happens automatically when using the built-in
    /// button styles, and can be implemented manually in custom styles using
    /// this environment key:
    ///
    ///     private struct MyButtonStyle: ButtonStyle {
    ///         @Environment(\.keyboardShortcut)
    ///         private var shortcut: KeyboardShortcut?
    ///
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             let labelFont = Font.body
    ///                 .weight(shortcut == .defaultAction ? .bold : .regular)
    ///             configuration.label
    ///                 .font(labelFont)
    ///         }
    ///     }
    ///
    /// If no keyboard shortcut has been applied to the view or its ancestor,
    /// then the environment value will be `nil`.
    public var keyboardShortcut: KeyboardShortcut? { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension EnvironmentValues {

    /// A Boolean value that indicates whether the view associated with this
    /// environment is currently presented.
    ///
    /// You can read this value like any of the other ``EnvironmentValues``
    /// by creating a property with the ``Environment`` property wrapper:
    ///
    ///     @Environment(\.isPresented) private var isPresented
    ///
    /// Read the value inside a view if you need to know when SkipUI
    /// presents that view. For example, you can take an action when SkipUI
    /// presents a view by using the ``View/onChange(of:perform:)``
    /// modifier:
    ///
    ///     .onChange(of: isPresented) { isPresented in
    ///         if isPresented {
    ///             // Do something when first presented.
    ///         }
    ///     }
    ///
    /// This behaves differently than ``View/onAppear(perform:)``, which
    /// SkipUI can call more than once for a given presentation, like
    /// when you navigate back to a view that's already in the
    /// navigation hierarchy.
    ///
    /// To dismiss the currently presented view, use
    /// ``EnvironmentValues/dismiss``.
    public var isPresented: Bool { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {

    /// A value that indicates how the layout truncates the last line of text to
    /// fit into the available space.
    ///
    /// The default value is ``Text/TruncationMode/tail``. Some controls,
    /// however, might have a different default if appropriate.
    public var truncationMode: Text.TruncationMode { get { fatalError() } }

    /// The distance in points between the bottom of one line fragment and the
    /// top of the next.
    ///
    /// This value is always nonnegative.
    public var lineSpacing: CGFloat { get { fatalError() } }

    /// A Boolean value that indicates whether inter-character spacing should
    /// tighten to fit the text into the available space.
    ///
    /// The default value is `false`.
    public var allowsTightening: Bool { get { fatalError() } }

    /// The minimum permissible proportion to shrink the font size to fit
    /// the text into the available space.
    ///
    /// In the example below, a label with a `minimumScaleFactor` of `0.5`
    /// draws its text in a font size as small as half of the actual font if
    /// needed to fit into the space next to the text input field:
    ///
    ///     HStack {
    ///         Text("This is a very long label:")
    ///             .lineLimit(1)
    ///             .minimumScaleFactor(0.5)
    ///         TextField("My Long Text Field", text: $myTextField)
    ///             .frame(width: 250, height: 50, alignment: .center)
    ///     }
    ///
    /// ![A screenshot showing the effects of setting the minimumScaleFactor on
    ///   the text in a view](SkipUI-View-minimumScaleFactor.png)
    ///
    /// You can set the minimum scale factor to any value greater than `0` and
    /// less than or equal to `1`. The default value is `1`.
    ///
    /// SkipUI uses this value to shrink text that doesn't fit in a view when
    /// it's okay to shrink the text. For example, a label with a
    /// `minimumScaleFactor` of `0.5` draws its text in a font size as small as
    /// half the actual font if needed.
    public var minimumScaleFactor: CGFloat { get { fatalError() } }

    /// A stylistic override to transform the case of `Text` when displayed,
    /// using the environment's locale.
    ///
    /// The default value is `nil`, displaying the `Text` without any case
    /// changes.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public var textCase: Text.Case? { get { fatalError() } }
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension EnvironmentValues {

    /// An indication of whether the user can edit the contents of a view
    /// associated with this environment.
    ///
    /// Read this environment value to receive a optional binding to the
    /// edit mode state. The binding contains an ``EditMode`` value
    /// that indicates whether edit mode is active, and that you can use to
    /// change the mode. To learn how to read an environment
    /// value, see ``EnvironmentValues``.
    ///
    /// Certain built-in views automatically alter their appearance and behavior
    /// in edit mode. For example, a ``List`` with a ``ForEach`` that's
    /// configured with the ``DynamicViewContent/onDelete(perform:)`` or
    /// ``DynamicViewContent/onMove(perform:)`` modifier provides controls to
    /// delete or move list items while in edit mode. On devices without an
    /// attached keyboard and mouse or trackpad, people can make multiple
    /// selections in lists only when edit mode is active.
    ///
    /// You can also customize your own views to react to edit mode.
    /// The following example replaces a read-only ``Text`` view with
    /// an editable ``TextField``, checking for edit mode by
    /// testing the wrapped value's ``EditMode/isEditing`` property:
    ///
    ///     @Environment(\.editMode) private var editMode
    ///     @State private var name = "Maria Ruiz"
    ///
    ///     var body: some View {
    ///         Form {
    ///             if editMode?.wrappedValue.isEditing == true {
    ///                 TextField("Name", text: $name)
    ///             } else {
    ///                 Text(name)
    ///             }
    ///         }
    ///         .animation(nil, value: editMode?.wrappedValue)
    ///         .toolbar { // Assumes embedding this view in a NavigationView.
    ///             EditButton()
    ///         }
    ///     }
    ///
    /// You can set the edit mode through the binding, or you can
    /// rely on an ``EditButton`` to do that for you, as the example above
    /// demonstrates. The button activates edit mode when the user
    /// taps the Edit button, and disables editing mode when the user taps Done.
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public var editMode: Binding<EditMode>? { get { fatalError() } }
}

@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
extension EnvironmentValues {

    /// The size to apply to controls within a view.
    ///
    /// The default is ``ControlSize/regular``.
    @available(tvOS, unavailable)
    public var controlSize: ControlSize { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EnvironmentValues {

    /// The current method of animating the contents of views.
    public var contentTransition: ContentTransition { get { fatalError() } }

    /// A Boolean value that controls whether views that render content
    /// transitions use GPU-accelerated rendering.
    ///
    /// Setting this value to `true` causes SkipUI to wrap content transitions
    /// with a ``View/drawingGroup(opaque:colorMode:)`` modifier.
    public var contentTransitionAddsDrawingGroup: Bool { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EnvironmentValues {

    /// An optional style that overrides the default system background
    /// style when set.
    public var backgroundStyle: AnyShapeStyle? { get { fatalError() } }
}

extension EnvironmentValues {

    /// Whether the Large Content Viewer is enabled.
    ///
    /// The system can automatically provide a large content view
    /// with ``View/accessibilityShowsLargeContentViewer()``
    /// or you can provide your own with ``View/accessibilityShowsLargeContentViewer(_:)``.
    ///
    /// While it is not necessary to check this value before adding
    /// a large content view, it may be helpful if you need to
    /// adjust the behavior of a gesture. For example, a button with
    /// a long press handler might increase its long press duration
    /// so the user can read the text in the large content viewer first.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public var accessibilityLargeContentViewerEnabled: Bool { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {

    /// The color scheme of this environment.
    ///
    /// Read this environment value from within a view to find out if SkipUI
    /// is currently displaying the view using the ``ColorScheme/light`` or
    /// ``ColorScheme/dark`` appearance. The value that you receive depends on
    /// whether the user has enabled Dark Mode, possibly superseded by
    /// the configuration of the current presentation's view hierarchy.
    ///
    ///     @Environment(\.colorScheme) private var colorScheme
    ///
    ///     var body: some View {
    ///         Text(colorScheme == .dark ? "Dark" : "Light")
    ///     }
    ///
    /// You can set the `colorScheme` environment value directly,
    /// but that usually isn't what you want. Doing so changes the color
    /// scheme of the given view and its child views but *not* the views
    /// above it in the view hierarchy. Instead, set a color scheme using the
    /// ``View/preferredColorScheme(_:)`` modifier, which also propagates the
    /// value up through the view hierarchy to the enclosing presentation, like
    /// a sheet or a window.
    ///
    /// When adjusting your app's user interface to match the color scheme,
    /// consider also checking the ``EnvironmentValues/colorSchemeContrast``
    /// property, which reflects a system-wide contrast setting that the user
    /// controls.
    ///
    /// > Note: If you only need to provide different colors or
    /// images for different color scheme and contrast settings, do that in
    /// your app's Asset Catalog. See
    /// .
    public var colorScheme: ColorScheme { get { fatalError() } }

    /// The contrast associated with the color scheme of this environment.
    ///
    /// Read this environment value from within a view to find out if SkipUI
    /// is currently displaying the view using ``ColorSchemeContrast/standard``
    /// or ``ColorSchemeContrast/increased`` contrast. The value that you read
    /// depends entirely on user settings, and you can't change it.
    ///
    ///     @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    ///
    ///     var body: some View {
    ///         Text(colorSchemeContrast == .standard ? "Standard" : "Increased")
    ///     }
    ///
    /// When adjusting your app's user interface to match the contrast,
    /// consider also checking the ``EnvironmentValues/colorScheme`` property
    /// to find out if SkipUI is displaying the view with a light or dark
    /// appearance.
    /// 
    /// > Note: If you only need to provide different colors or
    /// images for different color scheme and contrast settings, do that in
    /// your app's Asset Catalog. See
    /// .
    public var colorSchemeContrast: ColorSchemeContrast { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {

    /// Whether buttons with this associated environment should repeatedly
    /// trigger their actions on prolonged interactions.
    ///
    /// A value of `enabled` means that buttons will be able to repeatedly
    /// trigger their action, and `disabled` means they should not. A value of
    /// `automatic` means that buttons will defer to default behavior.
    public var buttonRepeatBehavior: ButtonRepeatBehavior { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension EnvironmentValues {

    /// The material underneath the current view.
    ///
    /// This value is `nil` if the current background isn't one of the standard
    /// materials. If you set a material, the standard content styles enable
    /// their vibrant rendering modes.
    ///
    /// You set this value by calling one of the background modifiers that takes
    /// a ``ShapeStyle``, like ``View/background(_:ignoresSafeAreaEdges:)``
    /// or ``View/background(_:in:fillStyle:)-89n7j``, and passing in a
    /// ``Material``. You can also set the value manually, using
    /// `nil` to disable vibrant rendering, or a ``Material`` instance to
    /// enable the vibrancy style associated with the specified material.
    public var backgroundMaterial: Material? { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EnvironmentValues {

    /// The preferred order of items for menus presented from this view.
    ///
    /// Set this value for a view hierarchy by calling the
    /// ``View/menuOrder(_:)`` view modifier.
    public var menuOrder: MenuOrder { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EnvironmentValues {

    /// The current size of sidebar rows.
    ///
    /// On macOS, reflects the value of the "Sidebar icon size" in
    /// System Settings' Appearance settings.
    ///
    /// This can be used to update the content shown in the sidebar in
    /// response to this size. And it can be overridden to force a sidebar to a
    /// particularly size, regardless of the user preference.
    ///
    /// On other platforms, the value is always `.medium` and setting a
    /// different value has no effect.
    ///
    /// SkipUI views like `Label` automatically adapt to the sidebar row size.
    public var sidebarRowSize: SidebarRowSize { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EnvironmentValues {

    /// A window dismissal action stored in a view's environment.
    ///
    /// Use the `dismissWindow` environment value to get an
    /// ``DismissWindowAction`` instance for a given ``Environment``. Then call
    /// the instance to dismiss a window. You call the instance directly because
    /// it defines a ``DismissWindowAction/callAsFunction(id:)`` method that
    /// Swift calls when you call the instance.
    ///
    /// For example, you can define a button that dismisses an auxiliary window:
    ///
    ///     @main
    ///     struct MyApp: App {
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 ContentView()
    ///             }
    ///             #if os(macOS)
    ///             Window("Auxiliary", id: "auxiliary") {
    ///                 AuxiliaryContentView()
    ///             }
    ///             #endif
    ///         }
    ///     }
    ///
    ///     struct DismissWindowButton: View {
    ///         @Environment(\.dismissWindow) private var dismissWindow
    ///
    ///         var body: some View {
    ///             Button("Close Auxiliary Window") {
    ///                 dismissWindow(id: "auxiliary")
    ///             }
    ///         }
    ///     }
    public var dismissWindow: DismissWindowAction { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension EnvironmentValues {

    /// The prominence to apply to badges associated with this environment.
    ///
    /// The default is ``BadgeProminence/standard``.
    public var badgeProminence: BadgeProminence { get { fatalError() } }
}

/// A modifier that must resolve to a concrete modifier in an environment before
/// use.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol EnvironmentalModifier : ViewModifier where Self.Body == Never {

    /// The type of modifier to use after being resolved.
    associatedtype ResolvedModifier : ViewModifier

    /// Resolve to a concrete modifier in the given `environment`.
    func resolve(in environment: EnvironmentValues) -> Self.ResolvedModifier
}

#endif
#endif
