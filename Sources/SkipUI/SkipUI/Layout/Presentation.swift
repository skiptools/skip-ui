// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.requiredHeightIn
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.systemBars
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.layout.wrapContentWidth
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.GenericShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialogDefaults
import androidx.compose.material3.BasicAlertDialog
import androidx.compose.material3.BottomSheetDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.ModalBottomSheetProperties
import androidx.compose.material3.SheetValue
import androidx.compose.material3.Surface
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.input.nestedscroll.NestedScrollConnection
import androidx.compose.ui.input.nestedscroll.NestedScrollSource
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Velocity
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

#if SKIP

/// Common corner radius for our overlay presentations.
let overlayPresentationCornerRadius = 16.0

// SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
@Composable func SheetPresentation(isPresented: Binding<Bool>, isFullScreen: Bool, context: ComposeContext, content: () -> any View, onDismiss: (() -> Void)?) {
    let interactiveDismissDisabledPreference = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<Bool>, Any>) { mutableStateOf(Preference<Bool>(key: InteractiveDismissDisabledPreferenceKey.self)) }
    let interactiveDismissDisabledCollector = PreferenceCollector<Bool>(key: InteractiveDismissDisabledPreferenceKey.self, state: interactiveDismissDisabledPreference)

    let sheetState = rememberModalBottomSheetState(skipPartiallyExpanded: true)
    let isPresentedValue = isPresented.get()
    if isPresentedValue || sheetState.isVisible {
        let contentViews = ComposeBuilder.from(content).collectViews(context: context)
        let topInset = remember { mutableStateOf(0.dp) }
        let topInsetPx = with(LocalDensity.current) { topInset.value.toPx() }
        let handleHeight = isFullScreen ? 0.dp : 8.dp
        let handleHeightPx = with(LocalDensity.current) { handleHeight.toPx() }
        let handlePadding = isFullScreen ? 0.dp : 10.dp
        let handlePaddingPx = with(LocalDensity.current) { handlePadding.toPx() }
        let sheetMaxWidth = isFullScreen ? Dp.Unspecified : BottomSheetDefaults.SheetMaxWidth
        let shape = GenericShape { size, _ in
            let y = topInsetPx - handleHeightPx - handlePaddingPx
            addRect(Rect(offset = Offset(x: Float(0.0), y: y), size: Size(width: size.width, height: size.height - y)))
        }
        let interactiveDismissDisabled = isFullScreen || interactiveDismissDisabledPreference.value.reduced
        let backDismissDisabled = contentViews.first?.strippingModifiers(until: { $0 is BackDismissDisabledModifierView }) { ($0 as? BackDismissDisabledModifierView)?.isDisabled == true } ?? false
        let onDismissRequest = {
            isPresented.set(false)
        }
        let properties = ModalBottomSheetProperties(shouldDismissOnBackPress: !backDismissDisabled)
        ModalBottomSheet(onDismissRequest: onDismissRequest, sheetState: sheetState, sheetMaxWidth: sheetMaxWidth, sheetGesturesEnabled: !interactiveDismissDisabled, containerColor: androidx.compose.ui.graphics.Color.Unspecified, shape: shape, dragHandle: nil, contentWindowInsets: { WindowInsets(0.dp, 0.dp, 0.dp, 0.dp) }, properties: properties) {
            let verticalSizeClass = EnvironmentValues.shared.verticalSizeClass
            let isEdgeToEdge = EnvironmentValues.shared._isEdgeToEdge == true
            let sheetDepth = EnvironmentValues.shared._sheetDepth
            var systemBarEdges: Edge.Set = isFullScreen ? .all : [.top, .bottom]

            let detentPreferences = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<PresentationDetentPreferences>, Any>) { mutableStateOf(Preference<PresentationDetentPreferences>(key: PresentationDetentPreferenceKey.self)) }
            let detentPreferencesCollector = PreferenceCollector<PresentationDetentPreferences>(key: PresentationDetentPreferences.self, state: detentPreferences)
            let reducedDetentPreferences = detentPreferences.value.reduced

            if !isFullScreen && verticalSizeClass != .compact {
                systemBarEdges.remove(.top)
                if !isEdgeToEdge {
                    systemBarEdges.remove(.bottom)
                }

                // TODO: add custom cases
                // Add inset depending on the presentation detent
                let inset: Dp
                let screenHeight = LocalConfiguration.current.screenHeightDp.dp
                let detent: PresentationDetent = reducedDetentPreferences.detent
                switch detent {
                case .medium:
                    inset = screenHeight / 2
                case let .height(h):
                    inset = screenHeight - h.dp
                case let .fraction(f):
                    inset = screenHeight * Float(1 - f)
                default:
                    // We have to delay access to WindowInsets until inside the ModalBottomSheet composable to get accurate values
                    let topBarHeight = WindowInsets.safeDrawing.asPaddingValues().calculateTopPadding()
                    // Add 44 for draggable area in case content is not draggable
                    inset = topBarHeight + (24 * sheetDepth).dp + 44.dp
                }

                topInset.value = inset
                // Draw the drag handle and the presentation root content area below it
                androidx.compose.foundation.layout.Spacer(modifier: Modifier.height(inset - handleHeight - handlePadding))
                Row(modifier: Modifier.fillMaxWidth(), horizontalArrangement: Arrangement.Center) {
                    Capsule().fill(Color.primary.opacity(0.4)).frame(width: 60.0, height: Double(handleHeight.value)).Compose(context: context)
                }
                androidx.compose.foundation.layout.Spacer(modifier: Modifier.height(handlePadding))
            } else if !isEdgeToEdge {
                systemBarEdges.remove(.top)
                systemBarEdges.remove(.bottom)
                let inset = WindowInsets.safeDrawing.asPaddingValues().calculateTopPadding()
                topInset.value = inset
                // Push the presentation root content area below the top bar
                androidx.compose.foundation.layout.Spacer(modifier: Modifier.height(inset))
            } else {
                topInset.value = 0.dp
            }

            let clipShape = RoundedCornerShape(topStart: isFullScreen ? 0.dp : overlayPresentationCornerRadius.dp, topEnd: isFullScreen ? 0.dp : overlayPresentationCornerRadius.dp)
            Box(modifier: Modifier.weight(Float(1.0)).clip(clipShape).nestedScroll(DisableScrollToDismissConnection())) {
                // Place outside of PresentationRoot recomposes
                let stateSaver = remember { ComposeStateSaver() }
                let presentationContext = context.content(stateSaver: stateSaver)
                // Place inside of ModalBottomSheet, which renders content async
                PresentationRoot(context: presentationContext, absoluteSystemBarEdges: systemBarEdges) { context in
                    EnvironmentValues.shared.setValues {
                        if !isFullScreen {
                            $0.set_sheetDepth(sheetDepth + 1)
                        }
                        $0.setdismiss(DismissAction(action: { isPresented.set(false) }))
                        return ComposeResult.ok
                    } in: {
                        PreferenceValues.shared.collectPreferences([interactiveDismissDisabledCollector, detentPreferencesCollector]) {
                            contentViews.forEach { $0.Compose(context: context) }
                        }
                    }
                }
            }
            if !isEdgeToEdge {
                // Move the presentation root content area above the bottom bar
                let inset = max(0.dp, WindowInsets.systemBars.asPaddingValues().calculateBottomPadding() - WindowInsets.ime.asPaddingValues().calculateBottomPadding())
                androidx.compose.foundation.layout.Spacer(modifier: Modifier.height(inset))
            }
        }
    }

    // When our isPresented binding flips from true to false, hide the sheet if needed and invoke onDismiss
    let wasPresented = remember { mutableStateOf(isPresentedValue) }
    let onDismissState = rememberUpdatedState(onDismiss)
    if isPresentedValue {
        wasPresented.value = true
    } else {
        LaunchedEffect(true) {
            if sheetState.targetValue != SheetValue.Hidden {
                sheetState.hide()
            }
            if wasPresented.value {
                wasPresented.value = false
                onDismissState.value?()
            }
        }
    }
}

final class DisableScrollToDismissConnection : NestedScrollConnection {
    override func onPostScroll(consumed: Offset, available: Offset, source: NestedScrollSource) -> Offset {
        return available.copy(x: Float(0.0))
    }

    override func onPostFling(consumed: Velocity, available: Velocity) async -> Velocity {
        return available.copy(x: Float(0.0))
    }
}

// SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
@Composable func ConfirmationDialogPresentation(title: Text?, isPresented: Binding<Bool>, context: ComposeContext, actions: any View, message: (any View)? = nil) {
    let sheetState = rememberModalBottomSheetState(skipPartiallyExpanded: true)
    if isPresented.get() || sheetState.isVisible {
        // Collect buttons and message text
        let actionViews: [View]
        if let composeBuilder = actions as? ComposeBuilder {
            actionViews = composeBuilder.collectViews(context: context)
        } else {
            actionViews = [actions]
        }
        let composableActions: [View] = actionViews.compactMap {
            $0.strippingModifiers { $0 as? Button ?? $0 as? Link ?? $0 as? NavigationLink }
        }
        let messageViews: [View]
        if let composeBuilder = message as? ComposeBuilder {
            messageViews = composeBuilder.collectViews(context: context)
        } else if let message {
            messageViews = [message]
        } else {
            messageViews = []
        }
        let messageText = messageViews.compactMap {
            $0.strippingModifiers { $0 as? Text }
        }.first

        ModalBottomSheet(onDismissRequest: { isPresented.set(false) }, sheetState: sheetState, containerColor: androidx.compose.ui.graphics.Color.Transparent, dragHandle: nil, contentWindowInsets: { WindowInsets(0.dp, 0.dp, 0.dp, 0.dp) }) {
            // Add padding to always keep the sheet away from the top of the screen. It should tap to dismiss like the background
            let interactionSource = remember { MutableInteractionSource() }
            Box(modifier: Modifier.fillMaxWidth().height(128.dp).clickable(interactionSource: interactionSource, indication: nil, onClick: { isPresented.set(false) }))

            let stateSaver = remember { ComposeStateSaver() }
            let scrollState = rememberScrollState()
            let isEdgeToEdge = EnvironmentValues.shared._isEdgeToEdge == true
            let bottomSystemBarPadding = WindowInsets.systemBars.asPaddingValues().calculateBottomPadding()
            let modifier = Modifier
                .fillMaxWidth()
                .padding(start: 8.dp, end: 8.dp, bottom: isEdgeToEdge ? 0.dp : bottomSystemBarPadding)
                .clip(shape: RoundedCornerShape(topStart: overlayPresentationCornerRadius.dp, topEnd: overlayPresentationCornerRadius.dp))
                .background(Color.overlayBackground.colorImpl())
                .padding(bottom: isEdgeToEdge ? bottomSystemBarPadding : 0.dp)
                .verticalScroll(scrollState)
            let contentContext = context.content(stateSaver: stateSaver)
            Column(modifier: modifier, horizontalAlignment: androidx.compose.ui.Alignment.CenterHorizontally) {
                ComposeConfirmationDialog(title: title, context: contentContext, isPresented: isPresented, actionViews: composableActions, message: messageText)
            }
        }
    }
    if !isPresented.get() {
        LaunchedEffect(true) {
            if sheetState.targetValue != SheetValue.Hidden {
                sheetState.hide()
            }
        }
    }
}

@Composable func ComposeConfirmationDialog(title: Text?, context: ComposeContext, isPresented: Binding<Bool>, actionViews: [View], message: Text?) {
    let padding = 16.dp
    if let title {
        androidx.compose.material3.Text(modifier: Modifier.padding(horizontal: padding, vertical: 8.dp), color: Color.secondary.colorImpl(), text: title.localizedTextString(), style: Font.callout.bold().fontImpl())
    }
    if let message {
        androidx.compose.material3.Text(modifier: Modifier.padding(start: padding, top: 8.dp, end: padding, bottom: padding), color: Color.secondary.colorImpl(), text: message.localizedTextString(), style: Font.callout.fontImpl())
    }
    if title != nil || message != nil {
        androidx.compose.material3.Divider()
    }

    let buttonModifier = Modifier.padding(horizontal: padding, vertical: padding)
    let buttonFont = Font.title3
    let tint = (EnvironmentValues.shared._tint ?? Color.accentColor).colorImpl()
    guard !actionViews.isEmpty else {
        ConfirmationDialogButton(action: { isPresented.set(false) }) {
            androidx.compose.material3.Text(modifier: buttonModifier, color: tint, text: stringResource(android.R.string.ok), style: buttonFont.fontImpl())
        }
        return
    }

    var cancelButton: Button? = nil
    for actionView in actionViews {
        var button = actionView as? Button
        if let link = actionView as? Link {
            link.ComposeAction()
            button = link.content
        }
        if let button {
            guard button.role != .cancel else {
                cancelButton = button
                continue
            }
            ConfirmationDialogButton(action: { isPresented.set(false); button.action() }) {
                let text = button.label.collectViews(context: context).compactMap {
                    $0.strippingModifiers { $0 as? Text }
                }.first
                let color = button.role == .destructive ? Color.red.colorImpl() : tint
                androidx.compose.material3.Text(modifier: buttonModifier, color: color, text: text?.localizedTextString() ?? "", maxLines: 1, style: buttonFont.fontImpl())
            }
        } else if let navigationLink = actionView as? NavigationLink {
            let navigationAction = navigationLink.navigationAction()
            ConfirmationDialogButton(action: { isPresented.set(false); navigationAction() }) {
                let text = navigationLink.label.collectViews(context: context).compactMap {
                    $0.strippingModifiers { $0 as? Text }
                }.first
                androidx.compose.material3.Text(modifier: buttonModifier, color: tint, text: text?.localizedTextString() ?? "", maxLines: 1, style: buttonFont.fontImpl())
            }
        }
        androidx.compose.material3.Divider()
    }
    if let cancelButton {
        ConfirmationDialogButton(action: { isPresented.set(false); cancelButton.action() }) {
            let text = cancelButton.label.collectViews(context: context).compactMap {
                $0.strippingModifiers { $0 as? Text }
            }.first
            androidx.compose.material3.Text(modifier: buttonModifier, color: tint, text: text?.localizedTextString() ?? "", maxLines: 1, style: buttonFont.bold().fontImpl())
        }
    } else {
        ConfirmationDialogButton(action: { isPresented.set(false) }) {
            androidx.compose.material3.Text(modifier: buttonModifier, color: tint, text: stringResource(android.R.string.cancel), style: buttonFont.bold().fontImpl())
        }
    }
}

@Composable func ConfirmationDialogButton(action: () -> Void, content: @Composable () -> Void) {
    Box(modifier: Modifier.fillMaxWidth().requiredHeightIn(min: 60.dp).clickable(onClick: action), contentAlignment: androidx.compose.ui.Alignment.Center) {
        content()
    }
}

// SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
@Composable func AlertPresentation(title: Text? = nil, titleResource: Int? = nil, isPresented: Binding<Bool>, context: ComposeContext, actions: any View, message: (any View)? = nil) {
    guard isPresented.get() else {
        return
    }
    // Collect buttons and message text
    let actionViews: [View]
    if let composeBuilder = actions as? ComposeBuilder {
        actionViews = composeBuilder.collectViews(context: context)
    } else {
        actionViews = [actions]
    }
    let textFields: [TextField] = actionViews.compactMap {
        $0.strippingModifiers { ($0 as? TextField) ?? ($0 as? SecureField)?.textField }
    }
    let optionViews: [View] = actionViews.compactMap {
        $0.strippingModifiers { $0 as? Button ?? $0 as? NavigationLink ?? $0 as? Link }
    }
    let messageViews: [View]
    if let composeBuilder = message as? ComposeBuilder {
        messageViews = composeBuilder.collectViews(context: context)
    } else if let message {
        messageViews = [message]
    } else {
        messageViews = []
    }
    let messageText = messageViews.compactMap {
        $0.strippingModifiers { $0 as? Text }
    }.first

    BasicAlertDialog(onDismissRequest: { isPresented.set(false) }) {
        let modifier = Modifier.wrapContentWidth().wrapContentHeight().then(context.modifier)
        Surface(modifier: modifier, shape: MaterialTheme.shapes.large, tonalElevation: AlertDialogDefaults.TonalElevation) {
            let contentContext = context.content()
            Column(modifier: Modifier.padding(top: 16.dp, bottom: 4.dp), horizontalAlignment: androidx.compose.ui.Alignment.CenterHorizontally) {
                ComposeAlert(title: title, titleResource: titleResource, context: contentContext, isPresented: isPresented, textFields: textFields, actionViews: optionViews, message: messageText)
            }
        }
    }
}

@Composable func ComposeAlert(title: Text?, titleResource: Int? = nil, context: ComposeContext, isPresented: Binding<Bool>, textFields: [TextField], actionViews: [View], message: Text?) {
    let padding = 16.dp
    if let title {
        androidx.compose.material3.Text(modifier: Modifier.padding(horizontal: padding, vertical: 8.dp), color: Color.primary.colorImpl(), text: title.localizedTextString(), style: Font.title3.bold().fontImpl(), textAlign: TextAlign.Center)
    } else if let titleResource {
        androidx.compose.material3.Text(modifier: Modifier.padding(horizontal: padding, vertical: 8.dp), color: Color.primary.colorImpl(), text: stringResource(titleResource), style: Font.title3.bold().fontImpl(), textAlign: TextAlign.Center)
    }
    if let message {
        androidx.compose.material3.Text(modifier: Modifier.padding(start: padding, end: padding), color: Color.primary.colorImpl(), text: message.localizedTextString(), style: Font.callout.fontImpl(), textAlign: TextAlign.Center)
    }

    for textField in textFields {
        let topPadding = textField == textFields.first ? 16.dp : 8.dp
        let textFieldContext = context.content(modifier: Modifier.padding(top: topPadding, start: padding, end: padding))
        textField.Compose(context: textFieldContext)
    }

    androidx.compose.material3.Divider(modifier: Modifier.padding(top: 16.dp))

    let buttonModifier = Modifier.padding(horizontal: padding, vertical: 12.dp)
    let buttonFont = Font.title3
    let tint = (EnvironmentValues.shared._tint ?? Color.accentColor).colorImpl()
    guard !actionViews.isEmpty else {
        AlertButton(modifier: Modifier.fillMaxWidth(), view: nil, isPresented: isPresented) {
            androidx.compose.material3.Text(modifier: buttonModifier, color: tint, text: stringResource(android.R.string.ok), style: buttonFont.fontImpl())
        }
        return
    }

    let buttonContent: @Composable (View, Bool) -> Void = { view, isCancel in
        let button = view as? Button ?? (view as? Link)?.content
        let label = button?.label ?? (view as? NavigationLink)?.label
        let text = label?.collectViews(context: context).compactMap {
            $0.strippingModifiers { $0 as? Text }
        }.first
        let color = button?.role == .destructive ? Color.red.colorImpl() : tint
        let style = isCancel ? buttonFont.bold().fontImpl() : buttonFont.fontImpl()
        androidx.compose.material3.Text(modifier: buttonModifier, color: color, text: text?.localizedTextString() ?? "", maxLines: 1, style: style)
    }

    let optionViews = actionViews.filter {
        if let button = $0 as? Button {
            return button.role != .cancel
        }
        return $0 is Link || $0 is NavigationLink
    }
    let cancelButton = actionViews.first {
        guard let button = $0 as? Button else { return false }
        return button.role == .cancel
    }
    let cancelCount = cancelButton == nil ? 0 : 1
    if optionViews.count + cancelCount == 2 {
        // Horizontal layout for two buttons //TODO: Should revert to vertical when text is too long
        Row(modifier: Modifier.fillMaxWidth().height(IntrinsicSize.Min)) {
            let modifier = Modifier.weight(Float(1.0))
            if let view = cancelButton ?? optionViews.first {
                AlertButton(modifier: modifier, view: view, isPresented: isPresented) {
                    buttonContent(view, view === cancelButton)
                }
                androidx.compose.material3.VerticalDivider()
            }
            if let button = optionViews.last {
                AlertButton(modifier: modifier, view: button, isPresented: isPresented) {
                    buttonContent(button, false)
                }
            }
        }
    } else {
        // Vertical layout
        let modifier = Modifier.fillMaxWidth()
        for actionView in optionViews {
            AlertButton(modifier: modifier, view: actionView, isPresented: isPresented) {
                buttonContent(actionView, false)
            }
            if actionView !== optionViews.last || cancelButton != nil {
                androidx.compose.material3.Divider()
            }
        }
        if let cancelButton {
            AlertButton(modifier: modifier, view: cancelButton, isPresented: isPresented) {
                buttonContent(cancelButton, true)
            }
        }
    }
}

@Composable func AlertButton(modifier: Modifier, view: View?, isPresented: Binding<Bool>, content: @Composable () -> Void) {
    var action: (() -> Void)?
    if let button = view as? Button {
        action = button.action
    } else if let link = view as? Link {
        link.ComposeAction()
        action = link.content.action
    } else if let navigationLink = view as? NavigationLink {
        action = navigationLink.navigationAction()
    }
    Box(modifier: modifier.clickable(onClick: { isPresented.set(false); action?() }), contentAlignment: androidx.compose.ui.Alignment.Center) {
        content()
    }
}
#endif

public enum PresentationAdaptation {
    case automatic
    case none
    case popover
    case sheet
    case fullScreenCover
}

public struct PresentationBackgroundInteraction {
    let enabled: Bool?
    let upThrough: PresentationDetent?

    public static let automatic = PresentationBackgroundInteraction(enabled: nil, upThrough: nil)

    public static let enabled = PresentationBackgroundInteraction(enabled: true, upThrough: nil)

    public static func enabled(upThrough: PresentationDetent) -> PresentationBackgroundInteraction {
        return PresentationBackgroundInteraction(enabled: true, upThrough: upThrough)
    }

    public static let disabled = PresentationBackgroundInteraction(enabled: false, upThrough: nil)
}

public enum PresentationContentInteraction : Equatable {
    case automatic
    case resizes
    case scrolls
}

public enum PresentationDetent : Hashable {
    case medium
    case large
    case fraction(CGFloat)
    case height(CGFloat)
    case custom(Any.Type)

    public struct Context {
        public let maxDetentValue: CGFloat

        public init(maxDetentValue: CGFloat) {
            self.maxDetentValue = maxDetentValue
        }

//        public subscript<T>(dynamicMember keyPath: KeyPath<EnvironmentValues, T>) -> T { get { fatalError() } }
    }

    static func forBridged(identifier: Int, value: CGFloat) -> PresentationDetent? {
        switch identifier {
        case 0: // For bridging
            return .medium
        case 1: // For bridging
            return .large
        case 2: // For bridging
            return .fraction(value)
        case 3: // For bridging
            return .height(value)
        default:
            return nil
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .medium:
            hasher.combine(1)
        case .large:
            hasher.combine(2)
        case .fraction(let fraction):
            hasher.combine(3)
            hasher.combine(fraction)
        case .height(let height):
            hasher.combine(4)
            hasher.combine(height)
        case .custom(let type):
            hasher.combine(String(describing: type))
        }
    }

    public static func == (lhs: PresentationDetent, rhs: PresentationDetent) -> Bool {
        switch lhs {
        case .medium:
            if case .medium = rhs {
                return true
            } else {
                return false
            }
        case .large:
            if case .large = rhs {
                return true
            } else {
                return false
            }
        case .fraction(let fraction1):
            if case .fraction(let fraction2) = rhs {
                return fraction1 == fraction2
            } else {
                return false
            }
        case .height(let height1):
            if case .height(let height2) = rhs {
                return height1 == height2
            } else {
                return false
            }
        case .custom(let type1):
            if case .custom(let type2) = rhs {
                return type1 == type2
            } else {
                return false
            }
        }
    }
}

public protocol CustomPresentationDetent {
//    static func height(in context: PresentationDetent.Context) -> CGFloat?
}

//public struct PresentedWindowContent<Data, Content> : View where Data : Decodable, Data : Encodable, Data : Hashable, Content : View {
//
//    public typealias Body = NeverView
//    public var body: Body { fatalError() }
//}

#if SKIP
struct PresentationDetentPreferenceKey: PreferenceKey {
    typealias Value = PresentationDetentPreferences

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<PresentationDetentPreferences>
    class Companion: PreferenceKeyCompanion {
        let defaultValue = PresentationDetentPreferences()
        func reduce(value: inout PresentationDetentPreferences, nextValue: () -> PresentationDetentPreferences) {
            value = value.reduce(nextValue())
        }
    }
}

struct PresentationDetentPreferences: Equatable {
    let detent: PresentationDetent

    init(detent: PresentationDetent? = nil) {
        self.detent = detent ?? PresentationDetent.large
    }

    func reduce(_ next: PresentationDetentPreferences) -> PresentationDetentPreferences {
        return next
    }

    public static func ==(lhs: PresentationDetentPreferences, rhs: PresentationDetentPreferences) -> Bool {
        return lhs.detent == rhs.detent
    }
}
#endif

extension View {
    public func alert(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View) -> any View {
        return alert(Text(titleKey), isPresented: isPresented, actions: actions)
    }

    public func alert(_ title: String, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View) -> any View {
        return alert(Text(verbatim: title), isPresented: isPresented, actions: actions)
    }

    public func alert(_ title: Text, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View) -> any View {
        #if SKIP
        return PresentationModifierView(view: self, providesNavigation: true) { context in
            AlertPresentation(title: title, isPresented: isPresented, context: context, actions: actions())
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func alert(_ title: Text, getIsPresented: @escaping () -> Bool, setIsPresented: @escaping (Bool) -> Void, bridgedActions: any View) -> any View {
        let isPresented = Binding(get: getIsPresented, set: setIsPresented)
        return alert(title, isPresented: isPresented, actions: { bridgedActions })
    }

    public func alert(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> any View {
        return alert(Text(titleKey), isPresented: isPresented, actions: actions, message: message)
    }

    public func alert(_ title: String, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> any View {
        return alert(Text(verbatim: title), isPresented: isPresented, actions: actions, message: message)
    }

    public func alert(_ title: Text, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> any View {
        #if SKIP
        return PresentationModifierView(view: self, providesNavigation: true) { context in
            AlertPresentation(title: title, isPresented: isPresented, context: context, actions: actions(), message: message())
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func alert(_ title: Text, getIsPresented: @escaping () -> Bool, setIsPresented: @escaping (Bool) -> Void, bridgedActions: any View, bridgedMessage: any View) -> any View {
        let isPresented = Binding(get: getIsPresented, set: setIsPresented)
        return alert(title, isPresented: isPresented, actions: { bridgedActions }, message: { bridgedMessage })
    }

    public func alert<T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View) -> any View {
        return alert(Text(titleKey), isPresented: isPresented, presenting: data, actions: actions)
    }

    public func alert<T>(_ title: String, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View) -> any View {
        return alert(Text(verbatim: title), isPresented: isPresented, presenting: data, actions: actions)
    }

    public func alert<T>(_ title: Text, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View) -> any View {
        #if SKIP
        let actionsWithData: () -> any View
        if let data {
            actionsWithData = { actions(data) }
        } else {
            actionsWithData = { EmptyView() }
        }
        return alert(title, isPresented: isPresented, actions: actionsWithData)
        #else
        return self
        #endif
    }

    public func alert<T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View, @ViewBuilder message: (T) -> any View) -> any View {
        return alert(Text(titleKey), isPresented: isPresented, presenting: data, actions: actions, message: message)
    }

    public func alert<T>(_ title: String, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View, @ViewBuilder message: (T) -> any View) -> any View {
        return alert(Text(verbatim: title), isPresented: isPresented, presenting: data, actions: actions, message: message)
    }

    public func alert<T>(_ title: Text, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View, @ViewBuilder message: (T) -> any View) -> any View {
        #if SKIP
        let actionsWithData: () -> any View
        let messageWithData: () -> any View
        if let data {
            actionsWithData = { actions(data) }
            messageWithData = { message(data) }
        } else {
            actionsWithData = { EmptyView() }
            messageWithData = { EmptyView() }
        }
        return alert(title, isPresented: isPresented, actions: actionsWithData, message: messageWithData)
        #else
        return self
        #endif
    }

//    public func alert<E>(isPresented: Binding<Bool>, error: E?, @ViewBuilder actions: () -> any View) -> some View where E : LocalizedError {
//        #if SKIP
//        let titleText: Text?
//        let titleResource: Int?
//        let actions: any View
//        if let error {
//            titleText = Text(verbatim: error.errorDescription ?? error.localizedDescription)
//            titleResource = nil
//            actions = actions()
//        } else {
//            titleText = nil
//            titleResource = android.R.string.dialog_alert_title
//            actions = EmptyView()
//        }
//        return PresentationModifierView(view: self, providesNavigation: true) { context in
//            AlertPresentation(title: titleText, titleResource: titleResource, isPresented: isPresented, context: context, actions: actions)
//        }
//        #else
//        return self
//        #endif
//    }
//
//    public func alert<E>(isPresented: Binding<Bool>, error: E?, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> some View where E : LocalizedError {
//        #if SKIP
//        let titleText: Text?
//        let titleResource: Int?
//        let actions: any View
//        let message: any View
//        if let error {
//            titleText = Text(verbatim: error.localizedDescription)
//            titleResource = nil
//            actions = actions()
//            message = message()
//        } else {
//            titleText = nil
//            titleResource = android.R.string.dialog_alert_title
//            actions = EmptyView()
//            message = EmptyView()
//        }
//        return PresentationModifierView(view: self, providesNavigation: true) { context in
//            AlertPresentation(title: titleText, titleResource: titleResource, isPresented: isPresented, context: context, actions: actions, message: message)
//        }
//        #else
//        return self
//        #endif
//    }

    public func confirmationDialog(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View) -> any View {
        return confirmationDialog(Text(titleKey), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions)
    }

    public func confirmationDialog(_ title: String, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View) -> any View {
        return confirmationDialog(Text(verbatim: title), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions)
    }

    public func confirmationDialog(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View) -> any View {
        #if SKIP
        return PresentationModifierView(view: self, providesNavigation: true) { context in
            ConfirmationDialogPresentation(title: titleVisibility != .visible ? nil : title, isPresented: isPresented, context: context, actions: actions())
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func confirmationDialog(_ title: Text, getIsPresented: @escaping () -> Bool, setIsPresented: @escaping (Bool) -> Void, bridgedTitleVisibility: Int, bridgedActions: any View) -> any View {
        let isPresented = Binding(get: getIsPresented, set: setIsPresented)
        return confirmationDialog(title, isPresented: isPresented, titleVisibility: Visibility(rawValue: bridgedTitleVisibility) ?? .automatic, actions: { bridgedActions })
    }

    public func confirmationDialog(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> some View {
        return confirmationDialog(Text(titleKey), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions, message: message)
    }

    public func confirmationDialog(_ title: String, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> some View {
        return confirmationDialog(Text(verbatim: title), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions, message: message)
    }

    public func confirmationDialog(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> some View {
        #if SKIP
        return PresentationModifierView(view: self, providesNavigation: true) { context in
            ConfirmationDialogPresentation(title: titleVisibility != .visible ? nil : title, isPresented: isPresented, context: context, actions: actions(), message: message())
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func confirmationDialog(_ title: Text, getIsPresented: @escaping () -> Bool, setIsPresented: @escaping (Bool) -> Void, bridgedTitleVisibility: Int, bridgedActions: any View, bridgedMessage: any View) -> any View {
        let isPresented = Binding(get: getIsPresented, set: setIsPresented)
        return confirmationDialog(title, isPresented: isPresented, titleVisibility: Visibility(rawValue: bridgedTitleVisibility) ?? .automatic, actions: { bridgedActions }, message: { bridgedMessage })
    }

    public func confirmationDialog<T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: @escaping (T) -> any View) -> any View {
        return confirmationDialog(Text(titleKey), isPresented: isPresented, titleVisibility: titleVisibility, presenting: data, actions: actions)
    }

    public func confirmationDialog<T>(_ title: String, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: @escaping (T) -> any View) -> any View {
        return confirmationDialog(Text(verbatim: title), isPresented: isPresented, titleVisibility: titleVisibility, presenting: data, actions: actions)
    }

    public func confirmationDialog<T>(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: @escaping (T) -> any View) -> any View {
        #if SKIP
        let actionsWithData: () -> any View
        if let data {
            actionsWithData = { actions(data) }
        } else {
            actionsWithData = { EmptyView() }
        }
        return confirmationDialog(title, isPresented: isPresented, titleVisibility: titleVisibility, actions: actionsWithData)
        #else
        return self
        #endif
    }

    public func confirmationDialog<T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: @escaping (T) -> any View, @ViewBuilder message: @escaping (T) -> any View) -> any View {
        return confirmationDialog(Text(titleKey), isPresented: isPresented, titleVisibility: titleVisibility, presenting: data, actions: actions, message: message)
    }

    public func confirmationDialog<T>(_ title: String, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: @escaping (T) -> any View, @ViewBuilder message: @escaping (T) -> any View) -> any View {
        return confirmationDialog(Text(verbatim: title), isPresented: isPresented, titleVisibility: titleVisibility, presenting: data, actions: actions, message: message)
    }

    public func confirmationDialog<T>(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: @escaping (T) -> any View, @ViewBuilder message: @escaping (T) -> any View) -> any View {
        #if SKIP
        let actionsWithData: () -> any View
        let messageWithData: () -> any View
        if let data {
            actionsWithData = { actions(data) }
            messageWithData = { message(data) }
        } else {
            actionsWithData = { EmptyView() }
            messageWithData = { EmptyView() }
        }
        return confirmationDialog(title, isPresented: isPresented, titleVisibility: titleVisibility, actions: actionsWithData, message: messageWithData)
        #else
        return self
        #endif
    }

    public func fullScreenCover<Item>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> any View) -> any View /* where Item : Identifiable, */ {
        #if SKIP
        let isPresented = Binding<Bool>(
            get: {
                return item.wrappedValue != nil
            },
            set: { newValue in
                if !newValue {
                    item.wrappedValue = nil
                }
            }
        )

        return fullScreenCover(isPresented: isPresented, onDismiss: onDismiss) {
            if let unwrappedItem = item.wrappedValue {
                content(unwrappedItem)
            }
        }
        #else
        return self
        #endif
    }

    public func fullScreenCover(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> any View) -> any View {
        #if SKIP
        return PresentationModifierView(view: self, providesNavigation: false) { context in
            SheetPresentation(isPresented: isPresented, isFullScreen: true, context: context, content: content, onDismiss: onDismiss)
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func fullScreenCover(getIsPresented: @escaping () -> Bool, setIsPresented: @escaping (Bool) -> Void, onDismiss: (() -> Void)?, bridgedContent: any View) -> any View {
        let isPresented = Binding(get: getIsPresented, set: setIsPresented)
        return fullScreenCover(isPresented: isPresented, onDismiss: onDismiss, content: { bridgedContent })
    }

    // SKIP @bridge
    public func interactiveDismissDisabled(_ isDisabled: Bool = true) -> any View {
        #if SKIP
        return preference(key: InteractiveDismissDisabledPreferenceKey.self, value: isDisabled)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func backDismissDisabled(_ isDisabled: Bool = true) -> any View {
        #if SKIP
        return BackDismissDisabledModifierView(view: self, isDisabled: isDisabled)
        #else
        return self
        #endif
    }

    public func presentationDetents(_ detents: Set<PresentationDetent>) -> any View {
        #if SKIP
        // TODO: Add support for multiple detents
        if detents.count == 0 {
            return self
        }
        let selectedDetent = detents.first
        return preference(key: PresentationDetentPreferences.self, value: PresentationDetentPreferences(detent: selectedDetent))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func presentationDetents(bridgedDetents: [Int], values: [CGFloat]) -> any View {
        var set: Set<PresentationDetent> = []
        for i in 0..<bridgedDetents.count {
            if let detent = PresentationDetent.forBridged(identifier: bridgedDetents[i], value: values[i]) {
                set.insert(detent)
            }
        }
        return presentationDetents(set)
    }

    @available(*, unavailable)
    public func presentationDetents(_ detents: Set<PresentationDetent>, selection: Binding<PresentationDetent>) -> some View {
        return self
    }

    @available(*, unavailable)
    public func presentationDragIndicator(_ visibility: Visibility) -> some View {
        return self
    }

    @available(*, unavailable)
    public func presentationBackgroundInteraction(_ interaction: PresentationBackgroundInteraction) -> some View {
        return self
    }

    @available(*, unavailable)
    public func presentationCompactAdaptation(_ adaptation: PresentationAdaptation) -> some View {
        return self
    }

    @available(*, unavailable)
    public func presentationCompactAdaptation(horizontal horizontalAdaptation: PresentationAdaptation, vertical verticalAdaptation: PresentationAdaptation) -> some View {
        return self
    }

    @available(*, unavailable)
    public func presentationCornerRadius(_ cornerRadius: CGFloat?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func presentationContentInteraction(_ behavior: PresentationContentInteraction) -> some View {
        return self
    }

    @available(*, unavailable)
    public func presentationBackground(_ style: any ShapeStyle) -> some View {
        return self
    }

    @available(*, unavailable)
    public func presentationBackground(alignment: Alignment = .center, @ViewBuilder content: () -> any View) -> some View {
        return self
    }

    public func sheet<Item>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> any View) -> some View /* where Item : Identifiable, */ {
        #if SKIP
        let isPresented = Binding<Bool>(
            get: {
                return item.wrappedValue != nil
            },
            set: { newValue in
                if !newValue {
                    item.wrappedValue = nil
                }
            }
        )

        return sheet(isPresented: isPresented, onDismiss: onDismiss) {
            if let unwrappedItem = item.wrappedValue {
                content(unwrappedItem)
            }
        }
        #else
        return self
        #endif
    }

    public func sheet(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> any View) -> some View {
        #if SKIP
        return PresentationModifierView(view: self, providesNavigation: false) { context in
            SheetPresentation(isPresented: isPresented, isFullScreen: false, context: context, content: content, onDismiss: onDismiss)
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func sheet(getIsPresented: @escaping () -> Bool, setIsPresented: @escaping (Bool) -> Void, onDismiss: (() -> Void)?, bridgedContent: any View) -> any View {
        let isPresented = Binding(get: getIsPresented, set: setIsPresented)
        return sheet(isPresented: isPresented, onDismiss: onDismiss, content: { bridgedContent })
    }
}

#if SKIP
final class PresentationModifierView: ComposeModifierView {
    private let presentation: @Composable (ComposeContext) -> Void
    private let providesNavigation: Bool

    init(view: View, providesNavigation: Bool, presentation: @Composable (ComposeContext) -> Void) {
        super.init(view: view)
        self.providesNavigation = providesNavigation
        self.presentation = presentation
    }

    @Composable override func ComposeContent(context: ComposeContext) {
        // Clear environment state that should not transfer to presentations
        // SKIP INSERT: val providedNavigator = LocalNavigator provides if (providesNavigation) LocalNavigator.current else null
        CompositionLocalProvider(providedNavigator) {
            EnvironmentValues.shared.setValues {
                $0.set_animation(nil)
                $0.set_searchableState(nil)
                return ComposeResult.ok
            } in: {
                presentation(context.content())
            }
        }
        view.Compose(context: context)
    }
}

/// Used disable the back button from dismissing a presentation.
struct BackDismissDisabledModifierView: ComposeModifierView {
    let isDisabled: Bool

    init(view: View, isDisabled: Bool) {
        self.isDisabled = isDisabled
        super.init(view: view)
    }
}

struct InteractiveDismissDisabledPreferenceKey: PreferenceKey {
    typealias Value = Bool

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<Boolean>
    final class Companion: PreferenceKeyCompanion {
        let defaultValue = false
        func reduce(value: inout Bool, nextValue: () -> Bool) {
            value = nextValue()
        }
    }
}
#endif
#endif
