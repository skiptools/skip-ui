// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.systemBars
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.SheetValue
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.unit.dp
#else
import struct CoreGraphics.CGFloat
#endif

#if SKIP
// SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
@Composable func SheetPresentation(isPresented: Binding<Bool>, content: () -> View, context: ComposeContext, onDismiss: (() -> Void)?) {
    let sheetState = rememberModalBottomSheetState(skipPartiallyExpanded: true)
    if isPresented.get() || sheetState.isVisible {
        let sheetDepth = EnvironmentValues.shared._sheetDepth
        ModalBottomSheet(
            onDismissRequest: { isPresented.set(false) },
            sheetState: sheetState,
            containerColor: androidx.compose.ui.graphics.Color.Unspecified,
            dragHandle: nil,
            windowInsets: WindowInsets(0, 0, 0, 0)
        ) {
            let stateSaver = remember { mutableStateOf(ComposeStateSaver()) }
            let sheetDepth = EnvironmentValues.shared._sheetDepth
            // We have to delay access to WindowInsets.systemBars until inside the ModalBottomSheet composable to get accurate values
            let bottomSystemBarPadding = WindowInsets.systemBars.asPaddingValues().calculateBottomPadding()
            let modifier = Modifier
                .fillMaxWidth()
                .height((LocalConfiguration.current.screenHeightDp - 20 * sheetDepth).dp)
                .padding(bottom: bottomSystemBarPadding)
            EnvironmentValues.shared.setValues {
                $0.set_sheetDepth(sheetDepth + 1)
                $0.setdismiss({ isPresented.set(false) })
                $0.set_bottomSystemBarPadding(bottomSystemBarPadding)
            } in: {
                Box(modifier: modifier, contentAlignment: androidx.compose.ui.Alignment.Center) {
                    content().Compose(context: context.content(stateSaver: stateSaver.value))
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
    @available(*, unavailable)
    public func fullScreenCover<Item, Content>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View where /* Item : Identifiable, */ Content : View {
        return self
    }

    @available(*, unavailable)
    public func fullScreenCover<Content>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        return self
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
    public func sheet<Item, Content>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View where /* Item : Identifiable, */ Content : View {
        return self
    }

    public func sheet<Content>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            SheetPresentation(isPresented: isPresented, content: content, context: context, onDismiss: onDismiss)
            view.Compose(context: context)
        }
        #else
        return self
        #endif
    }
}
