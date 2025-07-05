// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.ContentAlpha
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.KeyboardArrowLeft
import androidx.compose.material.icons.outlined.KeyboardArrowRight
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.unit.dp
#endif

// SKIP @bridge
public struct DisclosureGroup : View, ListItemAdapting, LazyItemFactory {
    let label: ComposeBuilder
    let content: ComposeBuilder
    let expandedBinding: Binding<Bool>

    // We cannot support this constructor because we have not been able to get expansion working reliably
    // in Lists without an external Binding
    @available(*, unavailable)
    public init(@ViewBuilder content: @escaping () -> any View, @ViewBuilder label: () -> any View) {
        self.label = ComposeBuilder.from(label)
        self.content = ComposeBuilder.from(content)
        self.expandedBinding = Binding(get: { false }, set: { _ in })
    }

    public init(isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> any View, @ViewBuilder label: () -> any View) {
        self.label = ComposeBuilder.from(label)
        self.content = ComposeBuilder.from(content)
        self.expandedBinding = isExpanded
    }

    // SKIP @bridge
    public init(getExpanded: @escaping () -> Bool, setExpanded: @escaping (Bool) -> Void, bridgedContent: any View, bridgedLabel: any View) {
        self.label = ComposeBuilder.from { bridgedLabel }
        self.content = ComposeBuilder.from { bridgedContent }
        self.expandedBinding = Binding(get: getExpanded, set: setExpanded)
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: @escaping () -> any View) {
        self.label = ComposeBuilder.from({ Text(titleKey) })
        self.content = ComposeBuilder.from(content)
        self.expandedBinding = Binding(get: { false }, set: { _ in })
    }

    public init(_ titleResource: LocalizedStringResource, @ViewBuilder content: @escaping () -> any View) {
        self.label = ComposeBuilder.from({ Text(titleResource) })
        self.content = ComposeBuilder.from(content)
        self.expandedBinding = Binding(get: { false }, set: { _ in })
    }

    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> any View) {
        self.init(isExpanded: isExpanded, content: content, label: { Text(titleKey) })
    }

    public init(_ titleResource: LocalizedStringResource, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> any View) {
        self.init(isExpanded: isExpanded, content: content, label: { Text(titleResource) })
    }

    @available(*, unavailable)
    public init(_ label: String, @ViewBuilder content: @escaping () -> any View) {
        self.label = ComposeBuilder.from({ Text(verbatim: label) })
        self.content = ComposeBuilder.from(content)
        self.expandedBinding = Binding(get: { false }, set: { _ in })
    }

    public init(_ label: String, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> any View) {
        self.init(isExpanded: isExpanded, content: content, label: { Text(verbatim: label) })
    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalAnimationApi::class)
    @Composable override func ComposeContent(context: ComposeContext) {
        let columnArrangement = Arrangement.spacedBy(8.dp, alignment: androidx.compose.ui.Alignment.CenterVertically)
        let contentContext = context.content()
        ComposeContainer(axis: .vertical, modifier: context.modifier, fillWidth: true) { modifier in
            Column(modifier: modifier, verticalArrangement: columnArrangement, horizontalAlignment: androidx.compose.ui.Alignment.Start) {
                ComposeLabel(context: contentContext)
                // Note: we can't seem to turn *off* animation when in AnimatedContent, so we've removed the code that
                // tries. We could take a separate code path to avoid AnimatedContent, but then a change in animation
                // status could cause us to lose state
                AnimatedContent(targetState: expandedBinding.wrappedValue) { isExpanded in
                    if isExpanded {
                        Column(modifier: Modifier.fillMaxWidth(), verticalArrangement: columnArrangement, horizontalAlignment: androidx.compose.ui.Alignment.CenterHorizontally) {
                            content.Compose(context: contentContext)
                        }
                    }
                }
            }
        }
    }

    @Composable override func shouldComposeListItem() -> Bool {
        return true
    }

    @Composable override func ComposeListItem(context: ComposeContext, contentModifier: Modifier) {
        ComposeLabel(context: context, listItemModifier: contentModifier)
    }

    @Composable private func ComposeLabel(context: ComposeContext, listItemModifier: Modifier? = nil) {
        let contentContext = context.content()
        let isListItem = rememberUpdatedState(listItemModifier != nil)
        let isEnabled = EnvironmentValues.shared.isEnabled
        let (foregroundStyle, accessoryColor) = ComposeStyles(isEnabled: isEnabled, isListItem: isListItem.value)
        let rotationAngle = Float(expandedBinding.wrappedValue ? 90 : 0).asAnimatable(context: contentContext)
        let isRTL = EnvironmentValues.shared.layoutDirection == .rightToLeft
        var modifier: Modifier = isEnabled ? Modifier.clickable(onClick: {
            if isListItem.value {
                // Attempting to animate the list expansion and contraction doesn't work well and causes artifacts
                // in other list items
                expandedBinding.wrappedValue = !expandedBinding.wrappedValue
            } else {
                withAnimation { expandedBinding.wrappedValue = !expandedBinding.wrappedValue }
            }
        }) : Modifier
        if let listItemModifier {
            modifier = modifier.then(listItemModifier)
        }
        Row(modifier: modifier, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
            Box(modifier: Modifier.padding(end: 8.dp).weight(Float(1.0))) {
                EnvironmentValues.shared.setValues {
                    if let foregroundStyle {
                        $0.set_foregroundStyle(foregroundStyle)
                    }
                    return ComposeResult.ok
                } in: {
                    label.Compose(context: contentContext)
                }
            }
            Icon(modifier = Modifier.rotate(rotationAngle.value), imageVector: isRTL ? Icons.Outlined.KeyboardArrowLeft : Icons.Outlined.KeyboardArrowRight, contentDescription: nil, tint: accessoryColor)
        }
    }

    @Composable private func ComposeStyles(isEnabled: Bool, isListItem: Bool) -> (ShapeStyle?, androidx.compose.ui.graphics.Color) {
        var foregroundStyle: ShapeStyle? = nil
        if !isListItem {
            foregroundStyle = EnvironmentValues.shared._foregroundStyle ?? EnvironmentValues.shared._tint ?? Color.accentColor
        }
        var accessoryColor = foregroundStyle?.asColor(opacity: 1.0, animationContext: nil) ?? EnvironmentValues.shared._tint?.colorImpl() ?? Color.accentColor.colorImpl()
        if !isEnabled {
            if isListItem {
                accessoryColor = MaterialTheme.colorScheme.outlineVariant
            } else {
                let disabledAlpha = ContentAlpha.disabled
                if foregroundStyle != nil {
                    foregroundStyle = AnyShapeStyle(foregroundStyle!, opacity: Double(disabledAlpha))
                }
                accessoryColor = accessoryColor.copy(alpha: disabledAlpha)
            }
        }
        return (foregroundStyle, accessoryColor)
    }

    @Composable override func appendLazyItemViews(to composer: LazyItemCollectingComposer, appendingContext: ComposeContext) -> ComposeResult {
        composer.append(self)
        if expandedBinding.wrappedValue {
            composer.pushLevel()
            content.Compose(context: appendingContext)
            composer.popLevel()
        }
        return ComposeResult.ok
    }

    func composeLazyItems(context: LazyItemFactoryContext, level: Int) {
        context.item(self, level)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct DisclosureGroupStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = DisclosureGroupStyle(rawValue: 0)
}

extension View {
    public func disclosureGroupStyle(_ style: DisclosureGroupStyle) -> some View {
        // We only support the single .automatic style
        return self
    }
}

#if false
/// The properties of a disclosure group instance.
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DisclosureGroupStyleConfiguration {

    /// A type-erased label of a disclosure group.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// The label for the disclosure group.
    public let label: DisclosureGroupStyleConfiguration.Label = { fatalError() }()

    /// A type-erased content of a disclosure group.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// The content of the disclosure group.
    public let content: DisclosureGroupStyleConfiguration.Content = { fatalError() }()

    /// A binding to a Boolean that indicates whether the disclosure
    /// group is expanded.
//    @Binding public var isExpanded: Bool { get { fatalError() } nonmutating set { } }

//    public var $isExpanded: Binding<Bool> { get { fatalError() } }
}

#endif
#endif
