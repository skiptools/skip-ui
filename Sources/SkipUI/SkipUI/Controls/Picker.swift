// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
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
import androidx.compose.material3.ExperimentalMaterial3Api
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
#endif

// SKIP @bridge
public struct Picker<SelectionValue> : View, ListItemAdapting {
    let selection: Binding<SelectionValue>
    let label: ComposeBuilder
    let content: ComposeBuilder

    public init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> any View, @ViewBuilder label: () -> any View) {
        self.selection = selection
        self.content = ComposeBuilder.from(content)
        self.label = ComposeBuilder.from(label)
    }

    public init(_ titleKey: LocalizedStringKey, selection: Binding<SelectionValue>, @ViewBuilder content: () -> any View) {
        self.init(selection: selection, content: content, label: { Text(titleKey) })
    }

    public init(_ title: String, selection: Binding<SelectionValue>, @ViewBuilder content: () -> any View) {
        self.init(selection: selection, content: content, label: { Text(verbatim: title) })
    }

    // SKIP @bridge
    public init(getSelection: @escaping () -> SelectionValue, setSelection: @escaping (SelectionValue) -> Void, bridgedContent: any View, bridgedLabel: any View) {
        self.selection = Binding(get: getSelection, set: setSelection)
        self.content = ComposeBuilder.from { bridgedContent }
        self.label = ComposeBuilder.from { bridgedLabel }
    }

    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
        let style = EnvironmentValues.shared._pickerStyle ?? PickerStyle.automatic
        if style == PickerStyle.segmented {
            ComposeSegmentedValue(context: context)
        } else if EnvironmentValues.shared._labelsHidden || style != .navigationLink {
            // Most picker styles do not display their label outside of a Form (see ComposeListItem)
            let (selectedView, tagViews) = processPickerContent(content: content, selection: selection, context: context)
            ComposeSelectedValue(selectedView: selectedView, tagViews: tagViews, context: context, style: style)
        } else {
            // Navigation link style outside of a List. This style does display its label
            ComposeLabeledValue(context: context, style: style)
        }
    }

    @Composable private func ComposeLabeledValue(context: ComposeContext, style: PickerStyle) {
        let (selectedView, tagViews) = processPickerContent(content: content, selection: selection, context: context)
        let contentContext = context.content()
        let navigator = LocalNavigator.current
        let title = titleFromLabel(context: contentContext)
        let modifier = context.modifier.clickable(onClick: {
            navigator?.navigateToView(PickerSelectionView(title: title, content: content, selection: selection))
        }, enabled: EnvironmentValues.shared.isEnabled)
        ComposeContainer(modifier: modifier, fillWidth: true) { modifier in
            Row(modifier: modifier, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                Box(modifier: Modifier.padding(end: 8.dp).weight(Float(1.0))) {
                    Button.ComposeTextButton(label: label, context: contentContext)
                }
                ComposeSelectedValue(selectedView: selectedView, tagViews: tagViews, context: contentContext, style: style, performsAction: false)
            }
        }
    }

    @Composable private func ComposeSelectedValue(selectedView: View, tagViews: [TagModifierView]?, context: ComposeContext, style: PickerStyle, performsAction: Bool = true) {
        let selectedValueView = selectedView ?? processPickerContent(content: content, selection: selection, context: context).0
        let selectedValueLabel: View
        let isMenu: Bool
        if style == .automatic || style == .menu {
            selectedValueLabel = HStack(spacing: 2.0) {
                selectedValueView
                Image(systemName: "chevron.down").accessibilityHidden(true)
            }
            isMenu = true
        } else {
            selectedValueLabel = selectedValueView
            isMenu = false
        }
        if performsAction {
            let isMenuExpanded = remember { mutableStateOf(false) }
            Box {
                Button.ComposeTextButton(label: selectedValueLabel, context: context) { isMenuExpanded.value = !isMenuExpanded.value }
                if isMenu {
                    ComposePickerSelectionMenu(tagViews: tagViews, isExpanded: isMenuExpanded, context: context.content())
                }
            }
        } else {
            var foregroundStyle = EnvironmentValues.shared._tint ?? Color(colorImpl: { MaterialTheme.colorScheme.outline })
            if !EnvironmentValues.shared.isEnabled {
                foregroundStyle = foregroundStyle.opacity(Double(ContentAlpha.disabled))
            }
            selectedValueLabel.foregroundStyle(foregroundStyle).Compose(context: context)
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
    @Composable private func ComposeSegmentedValue(context: ComposeContext) {
        let (_, tagViews) = processPickerContent(content: content, selection: selection, context: context, requireTagViews: true)
        let selectedIndex = tagViews?.firstIndex { $0.value == selection.wrappedValue }
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
            if let tagViews {
                for (index, tagView) in tagViews.enumerated() {
                    let isSelected = index == selectedIndex
                    let onClick: () -> Void = {
                        selection.wrappedValue = tagView.value as! SelectionValue
                    }
                    let shape = SegmentedButtonDefaults.itemShape(index: index, count: tagViews.count)
                    let borderColor = isSelected ? (isEnabled ? colors.activeBorderColor : colors.disabledActiveBorderColor) : (isEnabled ? colors.inactiveBorderColor : colors.disabledInactiveBorderColor)
                    let border = SegmentedButtonDefaults.borderStroke(borderColor)
                    let icon: @Composable () -> Void = { SegmentedButtonDefaults.Icon(isSelected) }
                    var options = Material3SegmentedButtonOptions(index: index, count: tagViews.count, selected: isSelected, onClick: onClick, modifier: Modifier, enabled: isEnabled, shape: shape, colors: colors, border: border, icon: icon)
                    if let updateOptions {
                        options = updateOptions(options)
                    }
                    SegmentedButton(selected: options.selected, onClick: options.onClick, modifier: options.modifier, enabled: options.enabled, shape: options.shape, colors: options.colors, border: options.border, icon: options.icon) {
                        if let label = tagView.view as? Label {
                            let _ = label.ComposeTitle(context: contentContext)
                        } else {
                            let _ = tagView.view.Compose(context: contentContext)
                        }
                    }
                }
            }
        }
    }

    @Composable func shouldComposeListItem() -> Bool {
        return EnvironmentValues.shared._pickerStyle != PickerStyle.segmented
    }

    @Composable func ComposeListItem(context: ComposeContext, contentModifier: Modifier) {
        let (selectedView, tagViews) = processPickerContent(content: content, selection: selection, context: context)
        let style = EnvironmentValues.shared._pickerStyle ?? PickerStyle.automatic
        var isMenu = false
        let isMenuExpanded = remember { mutableStateOf(false) }
        let onClick: () -> Void
        if style == .navigationLink {
            let navigator = LocalNavigator.current
            let title = titleFromLabel(context: context)
            onClick = { navigator?.navigateToView(PickerSelectionView(title: title, content: content, selection: selection)) }
        } else {
            isMenu = true
            onClick = { isMenuExpanded.value = !isMenuExpanded.value }
        }
        let modifier = Modifier.clickable(onClick: onClick, enabled: EnvironmentValues.shared.isEnabled).then(contentModifier)
        Row(modifier: modifier, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
            if !EnvironmentValues.shared._labelsHidden {
                Box(modifier: Modifier.padding(end: 8.dp).weight(Float(1.0))) {
                    label.Compose(context: context)
                }
            }
            Box {
                ComposeSelectedValue(selectedView: selectedView, tagViews: tagViews, context: context, style: style, performsAction: false)
                if isMenu {
                    ComposePickerSelectionMenu(tagViews: tagViews, isExpanded: isMenuExpanded, context: context)
                }
            }
            if style == .navigationLink {
                NavigationLink.ComposeChevron()
            }
        }
    }

    @Composable private func ComposePickerSelectionMenu(tagViews: [TagModifierView]?, isExpanded: MutableState<Bool>, context: ComposeContext) {
        // Create selectable views from the *content* of each tag view, preserving the enclosing tag
        let views = tagViews ?? processPickerContent(content: content, selection: selection, context: context, requireTagViews: true).1 ?? []
        let menuItems = views.map { tagView in
            let button = Button(action: {
                selection.wrappedValue = tagView.value as! SelectionValue
            }, label: { tagView.view })
            return TagModifierView(view: button, value: tagView.value, role: ComposeModifierRole.tag) as View
        }
        DropdownMenu(expanded: isExpanded.value, onDismissRequest: { isExpanded.value = false }) {
            let coroutineScope = rememberCoroutineScope()
            Menu.ComposeDropdownMenuItems(for: menuItems, selection: selection.wrappedValue, context: context, replaceMenu: { _ in
                coroutineScope.launch {
                    delay(200) // Allow menu item selection animation to be visible
                    isExpanded.value = false
                }
            })
        }
    }

    @Composable private func titleFromLabel(context: ComposeContext) -> Text {
        return label.collectViews(context: context).compactMap { $0.strippingModifiers(perform: { $0 as? Text }) }.first ?? Text(verbatim: String(describing: selection.wrappedValue))
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
        return environment(\._pickerStyle, style)
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
        return environment(\._material3SegmentedButton, options)
    }
    #endif
}

#if SKIP
@Composable func processPickerContent<SelectionValue>(content: ComposeBuilder, selection: Binding<SelectionValue>, context: ComposeContext, requireTagViews: Bool = false) -> (View, [TagModifierView]?) {
    let selectedTag = selection.wrappedValue
    let viewCollectingComposer = PickerViewCollectingComposer(selectedTag: selectedTag, requireTagViews: requireTagViews)
    let viewCollector = context.content(composer: viewCollectingComposer)

    EnvironmentValues.shared.setValues {
        $0.set_placement(ViewPlacement.tagged)
        return ComposeResult.ok
    } in: {
        content.Compose(viewCollector)
    }
    var selectedView = viewCollectingComposer.selectedView

    let tagViews: [TagModifierView]?
    if let views = viewCollectingComposer.tagViews {
        tagViews = Array(views, nocopy: true)
    } else {
        tagViews = nil
    }
    if selectedView == nil, let tagViews {
        selectedView = tagViews.first { $0.value == selectedTag }
    }
    return (selectedView ?? EmptyView(), tagViews)
}

final class PickerViewCollectingComposer<SelectionValue> : SideEffectComposer, ForEachComposer {
    let selectedTag: SelectionValue
    let requireTagViews: Bool
    var selectedView: View?
    var tagViews: MutableList<TagModifierView>?
    private var isFirstView = true

    init(selectedTag: SelectionValue, requireTagViews: Bool) {
        self.selectedTag = selectedTag
        self.requireTagViews = requireTagViews
    }

    @Composable override func Compose(view: View, context: (Bool) -> ComposeContext) -> ComposeResult {
        let isFirstView = self.isFirstView
        self.isFirstView = false
        if let forEach = view as? ForEach {
            if isFirstView, !requireTagViews, let selectedView =
                forEach.untaggedView(forTag: selectedTag, context: context(false)) {
                self.selectedView = selectedView
            } else if selectedView == nil {
                forEach.ComposeContent(context: context(true))
            }
        } else if selectedView == nil, let taggedView = TagModifierView.strip(from: view, role: ComposeModifierRole.tag) {
            if tagViews == nil {
                tagViews = mutableListOf()
            }
            tagViews!.add(taggedView)
        }
        return ComposeResult.ok
    }
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
        List(fixedContent: content, itemTransformer: { rowView(label: $0) })
            .environment(\._placement, ViewPlacement.tagged) // Make sure ForEach tags
            .navigationTitle(title)
    }

    @ViewBuilder private func rowView(label: View) -> some View {
        let labelValue = TagModifierView.strip(from: label, role: .tag)?.value as? SelectionValue
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
                ZStack {
                    label
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "checkmark")
                    .foregroundStyle(EnvironmentValues.shared._tint ?? Color.accentColor)
                    .opacity(labelValue == selectionValue ? 1.0 : 0.0)
            }
        }
        .buttonStyle(ButtonStyle.plain)
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

#if false
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Picker {
//    /// Creates a picker that displays a custom label.
//    ///
//    /// If the wrapped values of the collection passed to `sources` are not all
//    /// the same, some styles render the selection in a mixed state. The
//    /// specific presentation depends on the style.  For example, a Picker
//    /// with a menu style uses dashes instead of checkmarks to indicate the
//    /// selected values.
//    ///
//    /// In the following example, a picker in a document inspector controls the
//    /// thickness of borders for the currently-selected shapes, which can be of
//    /// any number.
//    ///
//    ///     enum Thickness: String, CaseIterable, Identifiable {
//    ///         case thin
//    ///         case regular
//    ///         case thick
//    ///
//    ///         var id: String { rawValue }
//    ///     }
//    ///
//    ///     struct Border {
//    ///         var color: Color
//    ///         var thickness: Thickness
//    ///     }
//    ///
//    ///     @State private var selectedObjectBorders = [
//    ///         Border(color: .black, thickness: .thin),
//    ///         Border(color: .red, thickness: .thick)
//    ///     ]
//    ///
//    ///     Picker(
//    ///         sources: $selectedObjectBorders,
//    ///         selection: \.thickness
//    ///     ) {
//    ///         ForEach(Thickness.allCases) { thickness in
//    ///             Text(thickness.rawValue)
//    ///         }
//    ///     } label: {
//    ///         Text("Border Thickness")
//    ///     }
//    ///
//    /// - Parameters:
//    ///     - sources: A collection of values used as the source for displaying
//    ///       the Picker's selection.
//    ///     - selection: The key path of the values that determines the
//    ///       currently-selected options. When a user selects an option from the
//    ///       picker, the values at the key path of all items in the `sources`
//    ///       collection are updated with the selected option.
//    ///     - content: A view that contains the set of options.
//    ///     - label: A view that describes the purpose of selecting an option.
//    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//    public init<C>(sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) where C : RandomAccessCollection { fatalError() }
//}
//
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Picker /* where Label == Text */ {
//
//    /// Creates a picker that generates its label from a localized string key.
//    ///
//    /// - Parameters:
//    ///     - titleKey: A localized string key that describes the purpose of
//    ///       selecting an option.
//    ///     - selection: A binding to a property that determines the
//    ///       currently-selected option.
//    ///     - content: A view that contains the set of options.
//    ///
//    /// This initializer creates a ``Text`` view on your behalf, and treats the
//    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
//    /// ``Text`` for more information about localizing strings.
//    ///
//    /// To initialize a picker with a string variable, use
//    /// ``init(_:selection:content:)-5njtq`` instead.
//
//
//    /// Creates a picker that generates its label from a localized string key.
//    ///
//    /// If the wrapped values of the collection passed to `sources` are not all
//    /// the same, some styles render the selection in a mixed state. The
//    /// specific presentation depends on the style.  For example, a Picker
//    /// with a menu style uses dashes instead of checkmarks to indicate the
//    /// selected values.
//    ///
//    /// In the following example, a picker in a document inspector controls the
//    /// thickness of borders for the currently-selected shapes, which can be of
//    /// any number.
//    ///
//    ///     enum Thickness: String, CaseIterable, Identifiable {
//    ///         case thin
//    ///         case regular
//    ///         case thick
//    ///
//    ///         var id: String { rawValue }
//    ///     }
//    ///
//    ///     struct Border {
//    ///         var color: Color
//    ///         var thickness: Thickness
//    ///     }
//    ///
//    ///     @State private var selectedObjectBorders = [
//    ///         Border(color: .black, thickness: .thin),
//    ///         Border(color: .red, thickness: .thick)
//    ///     ]
//    ///
//    ///     Picker(
//    ///         "Border Thickness",
//    ///         sources: $selectedObjectBorders,
//    ///         selection: \.thickness
//    ///     ) {
//    ///         ForEach(Thickness.allCases) { thickness in
//    ///             Text(thickness.rawValue)
//    ///         }
//    ///     }
//    ///
//    /// - Parameters:
//    ///     - titleKey: A localized string key that describes the purpose of
//    ///       selecting an option.
//    ///     - sources: A collection of values used as the source for displaying
//    ///       the Picker's selection.
//    ///     - selection: The key path of the values that determines the
//    ///       currently-selected options. When a user selects an option from the
//    ///       picker, the values at the key path of all items in the `sources`
//    ///       collection are updated with the selected option.
//    ///     - content: A view that contains the set of options.
//    ///
//    /// This initializer creates a ``Text`` view on your behalf, and treats the
//    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
//    /// ``Text`` for more information about localizing strings.
//    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//    public init<C>(_ titleKey: LocalizedStringKey, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection { fatalError() }
//
//    /// Creates a picker bound to a collection of bindings that generates its
//    /// label from a string.
//    ///
//    /// If the wrapped values of the collection passed to `sources` are not all
//    /// the same, some styles render the selection in a mixed state. The
//    /// specific presentation depends on the style.  For example, a Picker
//    /// with a menu style uses dashes instead of checkmarks to indicate the
//    /// selected values.
//    ///
//    /// In the following example, a picker in a document inspector controls the
//    /// thickness of borders for the currently-selected shapes, which can be of
//    /// any number.
//    ///
//    ///     enum Thickness: String, CaseIterable, Identifiable {
//    ///         case thin
//    ///         case regular
//    ///         case thick
//    ///
//    ///         var id: String { rawValue }
//    ///     }
//    ///
//    ///     struct Border {
//    ///         var color: Color
//    ///         var thickness: Thickness
//    ///     }
//    ///
//    ///     @State private var selectedObjectBorders = [
//    ///         Border(color: .black, thickness: .thin),
//    ///         Border(color: .red, thickness: .thick)
//    ///     ]
//    ///
//    ///     Picker(
//    ///         "Border Thickness",
//    ///         sources: $selectedObjectBorders,
//    ///         selection: \.thickness
//    ///     ) {
//    ///         ForEach(Thickness.allCases) { thickness in
//    ///             Text(thickness.rawValue)
//    ///         }
//    ///     }
//    ///
//    /// - Parameters:
//    ///     - title: A string that describes the purpose of selecting an option.
//    ///     - sources: A collection of values used as the source for displaying
//    ///       the Picker's selection.
//    ///     - selection: The key path of the values that determines the
//    ///       currently-selected options. When a user selects an option from the
//    ///       picker, the values at the key path of all items in the `sources`
//    ///       collection are updated with the selected option.
//    ///     - content: A view that contains the set of options.
//    ///
//    /// This initializer creates a ``Text`` view on your behalf, and treats the
//    /// title similar to ``Text/init(_:)-9d1g4``. See ``Text`` for more
//    /// information about localizing strings.
//    ///
//    /// To initialize a picker with a localized string key, use
//    /// ``init(_:sources:selection:content:)-6e1x`` instead.
//    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//    public init<C, S>(_ title: S, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection, S : StringProtocol { fatalError() }
//}

#endif
#endif
