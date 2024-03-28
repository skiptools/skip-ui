// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.requiredHeightIn
import androidx.compose.foundation.layout.systemBars
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CornerBasedShape
import androidx.compose.foundation.shape.CornerSize
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.SheetValue
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.RoundRect
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Outline
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
#else
import struct CoreGraphics.CGFloat
#endif

#if SKIP

/// Common corner radius for our overlay presentations.
let overlayPresentationCornerRadius = 16.0

// SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
@Composable func SheetPresentation(isPresented: Binding<Bool>, isFullScreen: Bool, context: ComposeContext, content: () -> any View, onDismiss: (() -> Void)?) {
    let sheetState = rememberModalBottomSheetState(skipPartiallyExpanded: true)
    if isPresented.get() || sheetState.isVisible {
        let contentView = ComposeBuilder.from(content)
        let topSystemBarHeight = remember { mutableStateOf(0.dp) }
        let topCornerSize = isFullScreen ? CornerSize(0.dp) : CornerSize(overlayPresentationCornerRadius.dp)
        let shape = with(LocalDensity.current) {
            RoundedCornerShapeWithTopOffset(offset: topSystemBarHeight.value.toPx(), topStart: topCornerSize, topEnd: topCornerSize)
        }
        let coroutineScope = rememberCoroutineScope()
        let onDismissRequest = {
            if isFullScreen {
                // Veto attempts to dismiss fullscreen modal via swipe or back button by re-showing
                if isPresented.get() {
                    coroutineScope.launch { sheetState.show() }
                }
            } else {
                isPresented.set(false)
            }
        }
        ModalBottomSheet(onDismissRequest: onDismissRequest, sheetState: sheetState, containerColor: androidx.compose.ui.graphics.Color.Unspecified, shape: shape, dragHandle: nil, windowInsets: WindowInsets(0, 0, 0, 0)) {
            let stateSaver = remember { ComposeStateSaver() } // Place outside of PresentationRoot recomposes
            let presentationContext = context.content(stateSaver: stateSaver)
            // Place inside of ModalBottomSheet, which renders content async
            PresentationRoot(context: presentationContext) { context in
                let sheetDepth = EnvironmentValues.shared._sheetDepth
                // We have to delay access to WindowInsets.systemBars until inside the ModalBottomSheet composable to get accurate values
                let systemBarPadding = WindowInsets.systemBars.asPaddingValues()
                topSystemBarHeight.value = systemBarPadding.calculateTopPadding()
                let bottomSystemBarPadding = systemBarPadding.calculateBottomPadding()
                var modifier = context.modifier.fillMaxWidth()
                if isFullScreen {
                    modifier = modifier.fillMaxHeight()
                } else {
                    modifier = modifier.height((LocalConfiguration.current.screenHeightDp - 24 * sheetDepth).dp + topSystemBarHeight.value)
                }
                modifier = modifier.padding(bottom: bottomSystemBarPadding)
                modifier = modifier.background(Color.background.colorImpl())
                EnvironmentValues.shared.setValues {
                    if !isFullScreen {
                        $0.set_sheetDepth(sheetDepth + 1)
                    }
                    $0.setdismiss({ isPresented.set(false) })
                    $0.set_bottomSystemBarPadding(bottomSystemBarPadding)
                } in: {
                    let contentContext = context.content()
                    Box(modifier: modifier, contentAlignment: androidx.compose.ui.Alignment.Center) {
                        contentView.Compose(context: contentContext)
                    }
                }
            }
        }
    }
    if !isPresented.get() {
        LaunchedEffect(true) {
            if sheetState.targetValue != SheetValue.Hidden {
                sheetState.hide()
                onDismiss?()
            }
        }
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
        let buttons = actionViews.compactMap {
            $0.strippingModifiers { $0 as? Button }
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

        ModalBottomSheet(
            onDismissRequest: { isPresented.set(false) },
            sheetState: sheetState,
            containerColor: androidx.compose.ui.graphics.Color.Transparent,
            dragHandle: nil,
            windowInsets: WindowInsets(0, 0, 0, 0)
        ) {
            // Add padding to always keep the sheet away from the top of the screen. It should tap to dismiss like the background
            let interactionSource = remember { MutableInteractionSource() }
            Box(modifier: Modifier.fillMaxWidth().height(128.dp).clickable(interactionSource: interactionSource, indication: nil, onClick: { isPresented.set(false) }))

            let stateSaver = remember { ComposeStateSaver() }
            let scrollState = rememberScrollState()
            let bottomSystemBarPadding = WindowInsets.systemBars.asPaddingValues().calculateBottomPadding()
            let modifier = Modifier
                .fillMaxWidth()
                .padding(start: 8.dp, end: 8.dp, bottom: bottomSystemBarPadding)
                .clip(shape = RoundedCornerShape(topStart: overlayPresentationCornerRadius.dp, topEnd: overlayPresentationCornerRadius.dp))
                .background(Color.overlayBackground.colorImpl())
                .verticalScroll(scrollState)
            let contentContext = context.content(stateSaver: stateSaver)
            Column(modifier: modifier, horizontalAlignment: androidx.compose.ui.Alignment.CenterHorizontally) {
                ComposeConfirmationDialog(title: title, context: contentContext, isPresented: isPresented, buttons: buttons, message: messageText)
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

@Composable func ComposeConfirmationDialog(title: Text?, context: ComposeContext, isPresented: Binding<Bool>, buttons: [Button], message: Text?) {
    let padding = 16.dp
    if let title {
        androidx.compose.material3.Text(modifier = Modifier.padding(horizontal: padding, vertical: 8.dp), color: Color.secondary.colorImpl(), text: title.localizedTextString(), style: Font.callout.bold().fontImpl())
    }
    if let message {
        androidx.compose.material3.Text(modifier = Modifier.padding(start: padding, top: 8.dp, end: padding, bottom: padding), color: Color.secondary.colorImpl(), text: message.localizedTextString(), style: Font.callout.fontImpl())
    }
    if title != nil || message != nil {
        androidx.compose.material3.Divider()
    }

    let buttonModifier = Modifier.padding(horizontal: padding, vertical: padding)
    let buttonFont = Font.title3
    let tint = (EnvironmentValues.shared._tint ?? Color.accentColor).colorImpl()
    guard !buttons.isEmpty else {
        ConfirmationDialogButton(action: { isPresented.set(false) }) {
            androidx.compose.material3.Text(modifier: buttonModifier, color: tint, text: stringResource(android.R.string.ok), style: buttonFont.fontImpl())
        }
        return
    }

    var cancelButton: Button? = nil
    for button in buttons {
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
#endif

public enum PresentationAdaptation : Sendable {
    case automatic
    case none
    case popover
    case sheet
    case fullScreenCover
}

public struct PresentationBackgroundInteraction : Sendable {
    let enabled: Bool?
    let upThrough: PresentationDetent?

    public static let automatic = PresentationBackgroundInteraction(enabled: nil, upThrough: nil)
    
    public static let enabled = PresentationBackgroundInteraction(enabled: true, upThrough: nil)

    public static func enabled(upThrough: PresentationDetent) -> PresentationBackgroundInteraction {
        return PresentationBackgroundInteraction(enabled: true, upThrough: upThrough)
    }

    public static let disabled = PresentationBackgroundInteraction(enabled: false, upThrough: nil)
}

public enum PresentationContentInteraction : Equatable, Sendable {
    case automatic
    case resizes
    case scrolls
}

public enum PresentationDetent : Hashable, Sendable {
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

extension View {
    public func confirmationDialog(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View) -> some View {
        return confirmationDialog(Text(titleKey), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions)
    }

    public func confirmationDialog(_ title: String, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View) -> some View {
        return confirmationDialog(Text(verbatim: title), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions)
    }

    public func confirmationDialog(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View) -> some View {
        #if SKIP
        return PresentationModifierView(view: self) { context in
            ConfirmationDialogPresentation(title: titleVisibility != .visible ? nil : title, isPresented: isPresented, context: context, actions: actions())
        }
        #else
        return self
        #endif
    }

    public func confirmationDialog(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> some View {
        return confirmationDialog(Text(titleKey), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions, message: message)
    }

    public func confirmationDialog(_ title: String, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> some View {
        return confirmationDialog(Text(verbatim: title), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions, message: message)
    }

    public func confirmationDialog(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> some View {
        #if SKIP
        return PresentationModifierView(view: self) { context in
            ConfirmationDialogPresentation(title: titleVisibility != .visible ? nil : title, isPresented: isPresented, context: context, actions: actions(), message: message())
        }
        #else
        return self
        #endif
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

    @available(*, unavailable)
    public func fullScreenCover<Item>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> any View) -> some View /* where Item : Identifiable, */ {
        return self
    }

    public func fullScreenCover(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> any View) -> some View {
        #if SKIP
        return PresentationModifierView(view: self) { context in
            SheetPresentation(isPresented: isPresented, isFullScreen: true, context: context, content: content, onDismiss: onDismiss)
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func presentationDetents(_ detents: Set<PresentationDetent>) -> some View {
        return self
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

    @available(*, unavailable)
    public func sheet<Item>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> any View) -> some View /* where Item : Identifiable, */ {
        return self
    }

    public func sheet(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> any View) -> some View {
        #if SKIP
        return PresentationModifierView(view: self) { context in
            SheetPresentation(isPresented: isPresented, isFullScreen: false, context: context, content: content, onDismiss: onDismiss)
        }
        #else
        return self
        #endif
    }
}

#if SKIP
final class PresentationModifierView: ComposeModifierView {
    private let presentation: @Composable (ComposeContext) -> Void

    init(view: View, presentation: @Composable (ComposeContext) -> Void) {
        super.init(view: view)
        self.presentation = presentation
    }

    @Composable override func ComposeContent(context: ComposeContext) {
        EnvironmentValues.shared.setValues {
            // Clear environment state that should not transfer to presentations
            $0.set_animation(nil)
            $0.set_searchableState(nil)
        } in: {
            presentation(context.content())
        }
        view.Compose(context: context)
    }
}

/// Used to chop off the empty area Compose adds above the content of a bottom sheet modal, and to round the rop corners.
final class RoundedCornerShapeWithTopOffset: CornerBasedShape {
    private let offset: Float

    init(offset: Float, topStart: CornerSize, topEnd: CornerSize, bottomEnd: CornerSize = CornerSize(0.dp), bottomStart: CornerSize = CornerSize(0.dp)) {
        self.offset = offset
        super.init(topStart: topStart, topEnd: topEnd, bottomEnd: bottomEnd, bottomStart: bottomStart)
    }

    override func copy(topStart: CornerSize, topEnd: CornerSize, bottomEnd: CornerSize, bottomStart: CornerSize) -> RoundedCornerShapeWithTopOffset {
        return RoundedCornerShapeWithTopOffset(offset: offset, topStart: topStart, topEnd: topEnd, bottomEnd: bottomEnd, bottomStart: bottomStart)
    }

    override func createOutline(size: Size, topStart: Float, topEnd: Float, bottomEnd: Float, bottomStart: Float, layoutDirection: androidx.compose.ui.unit.LayoutDirection) -> Outline {
        let rect = Rect(offset: Offset(x: Float(0.0), y: offset), size: size)
        let topLeft = CornerRadius(layoutDirection == androidx.compose.ui.unit.LayoutDirection.Ltr ? topStart : topEnd)
        let topRight = CornerRadius(layoutDirection == androidx.compose.ui.unit.LayoutDirection.Ltr ? topStart : topEnd)
        let bottomRight = CornerRadius(layoutDirection == androidx.compose.ui.unit.LayoutDirection.Ltr ? bottomEnd : bottomStart)
        let bottomLeft = CornerRadius(layoutDirection == androidx.compose.ui.unit.LayoutDirection.Ltr ? bottomStart : bottomEnd)
        return Outline.Rounded(RoundRect(rect: rect, topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft))
    }
}
#endif
