// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material.ContentAlpha
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.SegmentedButton
import androidx.compose.material3.SegmentedButtonColors
import androidx.compose.material3.SegmentedButtonDefaults
import androidx.compose.material3.SingleChoiceSegmentedButtonRow
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import skip.model.StateTracking
#endif

// SKIP @bridge
public final class Picker<SelectionValue> : View, Renderable {
    let selection: Binding<SelectionValue>
    let label: ComposeBuilder
    let content: ComposeBuilder
    #if SKIP
    private var isMenuExpanded: MutableState<Bool>? = nil
    #endif

    public init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> any View, @ViewBuilder label: () -> any View) {
        self.selection = selection
        self.content = ComposeBuilder.from(content)
        self.label = ComposeBuilder.from(label)
    }

    public convenience init(_ titleKey: LocalizedStringKey, selection: Binding<SelectionValue>, @ViewBuilder content: () -> any View) {
        self.init(selection: selection, content: content, label: { Text(titleKey) })
    }

    public convenience init(_ titleResource: LocalizedStringResource, selection: Binding<SelectionValue>, @ViewBuilder content: () -> any View) {
        self.init(selection: selection, content: content, label: { Text(titleResource) })
    }

    public convenience init(_ title: String, selection: Binding<SelectionValue>, @ViewBuilder content: () -> any View) {
        self.init(selection: selection, content: content, label: { Text(verbatim: title) })
    }

    // SKIP @bridge
    public init(getSelection: @escaping () -> SelectionValue, setSelection: @escaping (SelectionValue) -> Void, bridgedContent: any View, bridgedLabel: any View) {
        self.selection = Binding(get: getSelection, set: setSelection)
        self.content = ComposeBuilder.from { bridgedContent }
        self.label = ComposeBuilder.from { bridgedLabel }
    }

    #if SKIP
    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        isMenuExpanded = remember { mutableStateOf(false) }
        return listOf(self)
    }

    @Composable override func Render(context: ComposeContext) {
        let style = EnvironmentValues.shared._pickerStyle ?? PickerStyle.automatic
        if style == PickerStyle.segmented {
            RenderSegmentedValue(context: context)
        } else if EnvironmentValues.shared._labelsHidden || style != .navigationLink {
            // Most picker styles do not display their label outside of a Form (see RenderListItem)
            let (selected, tagged) = processPickerContent(content: content, selection: selection, context: context)
            RenderSelectedValue(selectedRenderable: selected, taggedRenderables: tagged, context: context, style: style)
        } else {
            // Navigation link style outside of a List. This style does display its label
            RenderLabeledValue(context: context, style: style)
        }
    }

    @Composable private func RenderLabeledValue(context: ComposeContext, style: PickerStyle) {
        let (selected, tagged) = processPickerContent(content: content, selection: selection, context: context)
        let contentContext = context.content()
        let navigator = LocalNavigator.current
        let label = (self.label.Evaluate(context: context, options: 0).firstOrNull() ?? EmptyView()) as Renderable // Let transpiler understand type
        let title = titleFromLabel(label, context: context)
        let modifier = context.modifier.clickable(onClick: {
            navigator?.navigateToView(PickerSelectionView(title: title, content: content, selection: selection))
        }, enabled: EnvironmentValues.shared.isEnabled)
        ComposeContainer(modifier: modifier, fillWidth: true) { modifier in
            Row(modifier: modifier, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                Box(modifier: Modifier.padding(end: 8.dp).weight(Float(1.0))) {
                    Button.RenderTextButton(label: label.asView(), context: contentContext)
                }
                RenderSelectedValue(selectedRenderable: selected, taggedRenderables: tagged, context: contentContext, style: style, performsAction: false)
            }
        }
    }

    @Composable private func RenderSelectedValue(selectedRenderable: Renderable, taggedRenderables: kotlin.collections.List<Renderable>?, context: ComposeContext, style: PickerStyle, performsAction: Bool = true) {
        let selectedValueRenderable = selectedRenderable ?? processPickerContent(content: content, selection: selection, context: context).0
        let selectedValueLabel: Renderable
        let isMenu: Bool
        if style == .automatic || style == .menu {
            selectedValueLabel = HStack(spacing: 2.0) {
                selectedValueRenderable.asView()
                Image(systemName: "chevron.down").accessibilityHidden(true)
            }
            isMenu = true
        } else {
            selectedValueLabel = selectedValueRenderable
            isMenu = false
        }
        if performsAction {
            Box {
                Button.RenderTextButton(label: selectedValueLabel.asView(), context: context) { toggleIsMenuExpanded() }
                if isMenu {
                    RenderPickerSelectionMenu(taggedRenderables: taggedRenderables, context: context.content())
                }
            }
        } else {
            var foregroundStyle = EnvironmentValues.shared._tint ?? Color(colorImpl: { MaterialTheme.colorScheme.outline })
            if !EnvironmentValues.shared.isEnabled {
                foregroundStyle = foregroundStyle.opacity(Double(ContentAlpha.disabled))
            }
            EnvironmentValues.shared.setValues {
                $0.set_foregroundStyle(foregroundStyle)
                return ComposeResult.ok
            } in: {
                selectedValueLabel.Render(context: context)
            }
        }
    }

    @Composable private func RenderSegmentedValue(context: ComposeContext) {
        let (_, tagged) = processPickerContent(content: content, selection: selection, context: context, requireTaggedRenderables: true)
        let selectedIndex = tagged?.indexOfFirst { TagModifier.on(content: $0, role: .tag)?.value == selection.wrappedValue } ?? -1
        let isEnabled = EnvironmentValues.shared.isEnabled
        let colors: SegmentedButtonColors
        let disabledBorderColor = Color.primary.colorImpl().copy(alpha: ContentAlpha.disabled)
        if let tint = EnvironmentValues.shared._tint {
            colors = SegmentedButtonDefaults.colors(activeContainerColor: tint.colorImpl().copy(alpha: Float(0.15)), disabledActiveBorderColor: disabledBorderColor, disabledInactiveBorderColor: disabledBorderColor)
        } else {
            colors = SegmentedButtonDefaults.colors(disabledActiveBorderColor: disabledBorderColor, disabledInactiveBorderColor: disabledBorderColor)
        }

        let contentContext = context.content()
        let updateOptions = EnvironmentValues.shared._material3SegmentedButton
        SingleChoiceSegmentedButtonRow(modifier: Modifier.fillWidth().then(context.modifier)) {
            if let tagged {
                for (index, taggedRenderable) in tagged.withIndex() {
                    let isSelected = index == selectedIndex
                    let onClick: () -> Void = {
                        selection.wrappedValue = TagModifier.on(content: taggedRenderable, role: .tag)?.value as! SelectionValue
                    }
                    let shape = SegmentedButtonDefaults.itemShape(index: index, count: tagged.size)
                    let borderColor = isSelected ? (isEnabled ? colors.activeBorderColor : colors.disabledActiveBorderColor) : (isEnabled ? colors.inactiveBorderColor : colors.disabledInactiveBorderColor)
                    let border = SegmentedButtonDefaults.borderStroke(borderColor)
                    let icon: @Composable () -> Void = { SegmentedButtonDefaults.Icon(isSelected) }
                    var options = Material3SegmentedButtonOptions(index: index, count: tagged.size, selected: isSelected, onClick: onClick, modifier: Modifier, enabled: isEnabled, shape: shape, colors: colors, border: border, icon: icon)
                    if let updateOptions {
                        options = updateOptions(options)
                    }
                    SegmentedButton(selected: options.selected, onClick: options.onClick, modifier: options.modifier, enabled: options.enabled, shape: options.shape, colors: options.colors, border: options.border, icon: options.icon) {
                        if let label = taggedRenderable.strip() as? Label {
                            label.RenderTitle(context: contentContext)
                        } else {
                            taggedRenderable.Render(context: contentContext)
                        }
                    }
                }
            }
        }
    }

    @Composable func shouldRenderListItem(context: ComposeContext) -> (Bool, (() -> Void)?) {
        let style = EnvironmentValues.shared._pickerStyle
        guard style != PickerStyle.segmented else {
            return (false, nil)
        }
        let action: () -> Void
        if style == .navigationLink {
            let navigator = LocalNavigator.current
            let label = self.label.Evaluate(context: context, options: 0).firstOrNull() ?? EmptyView()
            let title = titleFromLabel(label, context: context)
            action = { navigator?.navigateToView(PickerSelectionView(title: title, content: content, selection: selection)) }
        } else {
            action = { toggleIsMenuExpanded() }
        }
        return (true, action)
    }

    @Composable override func RenderListItem(context: ComposeContext, modifiers: kotlin.collections.List<ModifierProtocol>) {
        ModifiedContent.RenderWithModifiers(modifiers, context: context) { context in
            let (selected, tagged) = processPickerContent(content: content, selection: selection, context: context)
            let style = EnvironmentValues.shared._pickerStyle ?? PickerStyle.automatic
            Row(modifier: context.modifier, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                if !EnvironmentValues.shared._labelsHidden {
                    Box(modifier: Modifier.padding(end: 8.dp).weight(Float(1.0))) {
                        label.Compose(context: context)
                    }
                }
                Box {
                    RenderSelectedValue(selectedRenderable: selected, taggedRenderables: tagged, context: context, style: style, performsAction: false)
                    if style != .segmented && style != .navigationLink {
                        RenderPickerSelectionMenu(taggedRenderables: tagged, context: context)
                    }
                }
                if style == .navigationLink {
                    NavigationLink.RenderChevron()
                }
            }
        }
    }

    @Composable private func RenderPickerSelectionMenu(taggedRenderables: kotlin.collections.List<Renderable>?, context: ComposeContext) {
        // Create selectable views from the *content* of each tag view, preserving the enclosing tag
        let renderables = taggedRenderables ?? processPickerContent(content: content, selection: selection, context: context, requireTaggedRenderables: true).1 ?? listOf()
        let menuItems = renderables.map {
            let renderable = $0 as Renderable // Let transpiler understand type
            let tagValue = TagModifier.on(content: renderable, role: .tag)?.value
            let button = Button(action: {
                selection.wrappedValue = tagValue as! SelectionValue
            }, label: { renderable.asView() })
            return ModifiedContent(content: button as Renderable, modifier: TagModifier(value: tagValue, role: .tag))
        }
        DropdownMenu(expanded: isMenuExpanded?.value == true, onDismissRequest: { isMenuExpanded?.value = false }) {
            let coroutineScope = rememberCoroutineScope()
            Menu.RenderDropdownMenuItems(for: menuItems, selection: selection.wrappedValue, context: context, replaceMenu: { _ in
                coroutineScope.launch {
                    delay(200) // Allow menu item selection animation to be visible
                    isMenuExpanded?.value = false
                }
            })
        }
    }

    @Composable private func titleFromLabel(_ label: Renderable, context: ComposeContext) -> Text {
        let stripped = label.strip()
        if let text = stripped as? Text {
            return text
        } else if let label = stripped as? Label, let text = label.title.Evaluate(context: context, options: 0).firstOrNull()?.strip() as? Text {
            return text
        } else {
            return Text(verbatim: String(describing: selection.wrappedValue))
        }
    }

    private func toggleIsMenuExpanded() {
        if let isMenuExpanded {
            isMenuExpanded.value = !isMenuExpanded.value
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct PickerStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = PickerStyle(rawValue: 1) // For bridging
    public static let navigationLink = PickerStyle(rawValue: 2) // For bridging
    public static let segmented = PickerStyle(rawValue: 3) // For bridging

    @available(*, unavailable)
    public static let inline = PickerStyle(rawValue: 4) // For bridging

    @available(*, unavailable)
    public static let wheel = PickerStyle(rawValue: 5) // For bridging

    public static let menu = PickerStyle(rawValue: 6) // For bridging

    @available(*, unavailable)
    public static let palette = PickerStyle(rawValue: 7) // For bridging
}

extension View {
    public func pickerStyle(_ style: PickerStyle) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: PickerStyleModifier(style: style))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func pickerStyle(bridgedStyle: Int) -> any View {
        return pickerStyle(PickerStyle(rawValue: bridgedStyle))
    }

    #if SKIP
    /// Compose segmented button customization for `Picker`.
    public func material3SegmentedButton(_ options: @Composable (Material3SegmentedButtonOptions) -> Material3SegmentedButtonOptions) -> View {
        return environment(\._material3SegmentedButton, options, affectsEvaluate: false)
    }
    #endif
}

#if SKIP
@Composable func processPickerContent<SelectionValue>(content: ComposeBuilder, selection: Binding<SelectionValue>, context: ComposeContext, requireTaggedRenderables: Bool = false) -> (Renderable, kotlin.collections.List<Renderable>?) {
    let selectedTag = selection.wrappedValue
    let renderables = content.Evaluate(context: context, options: EvaluateOptions(isKeepForEach: true).value)
    if !requireTaggedRenderables {
        // Attempt to shortcut finding the selected view without expanding everything
        for forEach in renderables.mapNotNull({ $0 as? ForEach }) {
            if let selected =
                forEach.untaggedRenderable(forTag: selectedTag, context: context) {
                return (selected, nil)
            }
        }
    }

    var selected: Renderable? = nil
    var tagged: kotlin.collections.MutableList<Renderable> = mutableListOf()
    for renderable in renderables {
        let current: kotlin.collections.List<Renderable>
        if let view = renderable as? View, renderable.strip() is ForEach {
            current = view.Evaluate(context: context, options: 0)
        } else {
            current = listOf(renderable)
        }
        for renderable in current {
            if let tagModifier = TagModifier.on(content: renderable, role: .tag) {
                tagged.add(renderable)
                if selected == nil, tagModifier.value == selectedTag {
                    selected = renderable
                }
            }
        }
    }
    return (selected ?? EmptyView(), tagged)
}

struct PickerSelectionView<SelectionValue> : View {
    let title: Text
    let content: View
    let selection: Binding<SelectionValue>

    @State private var selectionValue: SelectionValue
    @Environment(\.dismiss) private var dismiss

    init(title: Text, content: View, selection: Binding<SelectionValue>) {
        self.title = title
        self.content = content
        self.selection = selection
        self._selectionValue = State(initialValue: selection.wrappedValue)
    }

    var body: some View {
        List(fixedContent: content, itemTransformer: { pickerRow(label: $0) })
            .navigationTitle(title)
    }

    private func pickerRow(label: Renderable) -> Renderable {
        let labelValue = TagModifier.on(content: label, role: .tag)?.value as? SelectionValue
        return Button {
            if let labelValue {
                selection.wrappedValue = labelValue
                self.selectionValue = labelValue // Update the checkmark in the UI while we dismiss
            }
            dismiss()
        } label: {
            HStack {
                // The embedded ZStack allows us to fill the width without a Spacer, which in Compose will share equal space with
                // the label if it also wants to expand to fill space
                ZStack { label.asView() }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "checkmark")
                    .foregroundStyle(EnvironmentValues.shared._tint ?? Color.accentColor)
                    .opacity(labelValue == selectionValue ? 1.0 : 0.0)
            }
        }
        .buttonStyle(ButtonStyle.plain)
        .asRenderable()
    }
}

final class PickerStyleModifier: EnvironmentModifier {
    let style: PickerStyle

    init(style: PickerStyle) {
        self.style = style
        super.init()
        self.action = { environment in
            environment.set_pickerStyle(style)
            return ComposeResult.ok
        }
    }

    @Composable override func shouldRenderListItem(content: Renderable, context: ComposeContext) -> (Bool, (() -> Void)?) {
        // The picker style matters when deciding whether to render pickers as list items
        return EnvironmentValues.shared.setValuesWithReturn(action!, in: {
            return content.shouldRenderListItem(context: context)
        })
    }
}

public struct Material3SegmentedButtonOptions {
    public let index: Int
    public let count: Int
    public var selected: Boolean
    public var onClick: () -> Void
    public var modifier: Modifier
    public var enabled: Boolean
    public var shape: androidx.compose.ui.graphics.Shape
    public var colors: SegmentedButtonColors
    public var border: BorderStroke
    public var contentPadding: PaddingValues = SegmentedButtonDefaults.ContentPadding
    public var interactionSource: MutableInteractionSource? = nil
    public var icon: @Composable () -> Void

    public func copy(
        selected: Bool = self.selected,
        onClick: () -> Void = self.onClick,
        modifier: Modifier = self.modifier,
        enabled: Bool = self.enabled,
        shape: androidx.compose.ui.graphics.Shape = self.shape,
        colors: SegmentedButtonColors = self.colors,
        border: BorderStroke = self.border,
        contentPadding: PaddingValues = self.contentPadding,
        interactionSource: MutableInteractionSource? = self.interactionSource,
        icon: @Composable () -> Void = self.icon
    ) -> Material3SegmentedButtonOptions {
        return Material3SegmentedButtonOptions(index: index, count: count, selected: selected, onClick: onClick, modifier: modifier, enabled: enabled, shape: shape, colors: colors, border: border, contentPadding: contentPadding, interactionSource: interactionSource, icon: icon)
    }
}
#endif

/*
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Picker {
    /// Creates a picker that displays a custom label.
    ///
    /// If the wrapped values of the collection passed to `sources` are not all
    /// the same, some styles render the selection in a mixed state. The
    /// specific presentation depends on the style.  For example, a Picker
    /// with a menu style uses dashes instead of checkmarks to indicate the
    /// selected values.
    ///
    /// In the following example, a picker in a document inspector controls the
    /// thickness of borders for the currently-selected shapes, which can be of
    /// any number.
    ///
    ///     enum Thickness: String, CaseIterable, Identifiable {
    ///         case thin
    ///         case regular
    ///         case thick
    ///
    ///         var id: String { rawValue }
    ///     }
    ///
    ///     struct Border {
    ///         var color: Color
    ///         var thickness: Thickness
    ///     }
    ///
    ///     @State private var selectedObjectBorders = [
    ///         Border(color: .black, thickness: .thin),
    ///         Border(color: .red, thickness: .thick)
    ///     ]
    ///
    ///     Picker(
    ///         sources: $selectedObjectBorders,
    ///         selection: \.thickness
    ///     ) {
    ///         ForEach(Thickness.allCases) { thickness in
    ///             Text(thickness.rawValue)
    ///         }
    ///     } label: {
    ///         Text("Border Thickness")
    ///     }
    ///
    /// - Parameters:
    ///     - sources: A collection of values used as the source for displaying
    ///       the Picker's selection.
    ///     - selection: The key path of the values that determines the
    ///       currently-selected options. When a user selects an option from the
    ///       picker, the values at the key path of all items in the `sources`
    ///       collection are updated with the selected option.
    ///     - content: A view that contains the set of options.
    ///     - label: A view that describes the purpose of selecting an option.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<C>(sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) where C : RandomAccessCollection { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Picker /* where Label == Text */ {

    /// Creates a picker that generates its label from a localized string key.
    ///
    /// - Parameters:
    ///     - titleKey: A localized string key that describes the purpose of
    ///       selecting an option.
    ///     - selection: A binding to a property that determines the
    ///       currently-selected option.
    ///     - content: A view that contains the set of options.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// To initialize a picker with a string variable, use
    /// ``init(_:selection:content:)-5njtq`` instead.


    /// Creates a picker that generates its label from a localized string key.
    ///
    /// If the wrapped values of the collection passed to `sources` are not all
    /// the same, some styles render the selection in a mixed state. The
    /// specific presentation depends on the style.  For example, a Picker
    /// with a menu style uses dashes instead of checkmarks to indicate the
    /// selected values.
    ///
    /// In the following example, a picker in a document inspector controls the
    /// thickness of borders for the currently-selected shapes, which can be of
    /// any number.
    ///
    ///     enum Thickness: String, CaseIterable, Identifiable {
    ///         case thin
    ///         case regular
    ///         case thick
    ///
    ///         var id: String { rawValue }
    ///     }
    ///
    ///     struct Border {
    ///         var color: Color
    ///         var thickness: Thickness
    ///     }
    ///
    ///     @State private var selectedObjectBorders = [
    ///         Border(color: .black, thickness: .thin),
    ///         Border(color: .red, thickness: .thick)
    ///     ]
    ///
    ///     Picker(
    ///         "Border Thickness",
    ///         sources: $selectedObjectBorders,
    ///         selection: \.thickness
    ///     ) {
    ///         ForEach(Thickness.allCases) { thickness in
    ///             Text(thickness.rawValue)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - titleKey: A localized string key that describes the purpose of
    ///       selecting an option.
    ///     - sources: A collection of values used as the source for displaying
    ///       the Picker's selection.
    ///     - selection: The key path of the values that determines the
    ///       currently-selected options. When a user selects an option from the
    ///       picker, the values at the key path of all items in the `sources`
    ///       collection are updated with the selected option.
    ///     - content: A view that contains the set of options.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<C>(_ titleKey: LocalizedStringKey, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection { fatalError() }

    /// Creates a picker bound to a collection of bindings that generates its
    /// label from a string.
    ///
    /// If the wrapped values of the collection passed to `sources` are not all
    /// the same, some styles render the selection in a mixed state. The
    /// specific presentation depends on the style.  For example, a Picker
    /// with a menu style uses dashes instead of checkmarks to indicate the
    /// selected values.
    ///
    /// In the following example, a picker in a document inspector controls the
    /// thickness of borders for the currently-selected shapes, which can be of
    /// any number.
    ///
    ///     enum Thickness: String, CaseIterable, Identifiable {
    ///         case thin
    ///         case regular
    ///         case thick
    ///
    ///         var id: String { rawValue }
    ///     }
    ///
    ///     struct Border {
    ///         var color: Color
    ///         var thickness: Thickness
    ///     }
    ///
    ///     @State private var selectedObjectBorders = [
    ///         Border(color: .black, thickness: .thin),
    ///         Border(color: .red, thickness: .thick)
    ///     ]
    ///
    ///     Picker(
    ///         "Border Thickness",
    ///         sources: $selectedObjectBorders,
    ///         selection: \.thickness
    ///     ) {
    ///         ForEach(Thickness.allCases) { thickness in
    ///             Text(thickness.rawValue)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - title: A string that describes the purpose of selecting an option.
    ///     - sources: A collection of values used as the source for displaying
    ///       the Picker's selection.
    ///     - selection: The key path of the values that determines the
    ///       currently-selected options. When a user selects an option from the
    ///       picker, the values at the key path of all items in the `sources`
    ///       collection are updated with the selected option.
    ///     - content: A view that contains the set of options.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// To initialize a picker with a localized string key, use
    /// ``init(_:sources:selection:content:)-6e1x`` instead.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<C, S>(_ title: S, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection, S : StringProtocol { fatalError() }
}
*/
#endif
