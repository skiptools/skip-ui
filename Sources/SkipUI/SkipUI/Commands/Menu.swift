// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.Box
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Check
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
#endif

// Use a class to avoid copying so that we can update our toggleMenu action on the current instance
public class Menu : View {
    let content: ComposeView
    let label: ComposeView
    let primaryAction: (() -> Void)?
    var toggleMenu: () -> Void = {}

    public init(@ViewBuilder content: () -> any View, @ViewBuilder label: () -> any View) {
        self.content = ComposeView.from(content)
        #if SKIP
        self.label = ComposeView(view: Button(action: { self.toggleMenu() }, label: label))
        #else
        self.label = ComposeView(view: EmptyView())
        #endif
        self.primaryAction = nil
    }

    public convenience init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View) {
        self.init(content: content, label: { Text(titleKey) })
    }

    public convenience init(_ title: String, @ViewBuilder content: () -> any View) {
        self.init(content: content, label: { Text(verbatim: title) })
    }

    public init(@ViewBuilder content: () -> any View, @ViewBuilder label: () -> any View, primaryAction: @escaping () -> Void) {
        self.content = ComposeView.from(content)
        // We don't use a Button because we can't attach a long press detector to it
        // So currently, any Menu with a primaryAction ignores .buttonStyle
        self.label = ComposeView.from(label)
        self.primaryAction = primaryAction
    }

    public convenience init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View, primaryAction: @escaping () -> Void) {
        self.init(content: content, label: { Text(titleKey) }, primaryAction: primaryAction)
    }

    public convenience init(_ title: String, @ViewBuilder content: () -> any View, primaryAction: @escaping () -> Void) {
        self.init(content: content, label: { Text(verbatim: title) }, primaryAction: primaryAction)

    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalFoundationApi::class)
    @Composable override func ComposeContent(context: ComposeContext) {
        let contentContext = context.content()
        let isEnabled = EnvironmentValues.shared.isEnabled
        ComposeContainer(eraseAxis: true, modifier: context.modifier) { modifier in
            Box(modifier: modifier) {
                if let primaryAction {
                    let primaryActionModifier = Modifier.combinedClickable(
                        enabled = isEnabled,
                        onLongClick = { toggleMenu() },
                        onClick = primaryAction
                    )
                    ComposeTextButton(label: label, context: context.content(modifier: primaryActionModifier))
                } else {
                    label.Compose(context: contentContext)
                }
                if isEnabled {
                    // We default to displaying our own content, but if the user selects a nested menu we can present
                    // that instead. The nested menu selection is cleared on dismiss
                    let isMenuExpanded = remember { mutableStateOf(false) }
                    let nestedMenu = remember { mutableStateOf<Menu?>(nil) }
                    let coroutineScope = rememberCoroutineScope()
                    toggleMenu = {
                        nestedMenu.value = nil
                        isMenuExpanded.value = !isMenuExpanded.value
                    }
                    let replaceMenu: (Menu?) -> Void = { menu in
                        coroutineScope.launch {
                            delay(200) // Allow menu item selection animation to be visible
                            isMenuExpanded.value = false
                            delay(100) // Otherwise we see a flash of the primary menu on nested menu dismiss
                            nestedMenu.value = nil
                            if let menu {
                                nestedMenu.value = menu
                                isMenuExpanded.value = true
                            }
                        }
                    }
                    DropdownMenu(expanded: isMenuExpanded.value, onDismissRequest: {
                        isMenuExpanded.value = false
                        coroutineScope.launch {
                            delay(100) // Otherwise we see a flash of the primary menu on nested menu dismiss
                            nestedMenu.value = nil
                        }
                    }) {
                        let itemViews = (nestedMenu.value?.content ?? content).collectViews(context: context)
                        Self.ComposeDropdownMenuItems(for: itemViews, context: contentContext, replaceMenu: replaceMenu)
                    }
                } else {
                    toggleMenu = {}
                }
            }
        }
    }

    @Composable static func ComposeDropdownMenuItems(for itemViews: [View], selection: Hashable? = nil, context: ComposeContext, replaceMenu: (Menu?) -> Void) {
        for itemView in itemViews {
            if let strippedItemView = itemView.strippingModifiers(perform: { $0 }) {
                if let button = strippedItemView as? Button {
                    let isSelected: Bool
                    if let tagView = itemView as? TagModifierView {
                        isSelected = tagView.tag == selection
                    } else {
                        isSelected = false
                    }
                    ComposeDropdownMenuItem(for: button.label, context: context, isSelected: isSelected) {
                        button.action()
                        replaceMenu(nil)
                    }
                } else if let text = strippedItemView as? Text {
                    DropdownMenuItem(text: { text.Compose(context: context) }, onClick: {}, enabled: false)
                } else if let section = strippedItemView as? Section {
                    if let header = section.header {
                        DropdownMenuItem(text: { header.Compose(context: context) }, onClick: {}, enabled: false)
                    }
                    let sectionViews = section.content.collectViews(context: context)
                    ComposeDropdownMenuItems(for: sectionViews, context: context, replaceMenu: replaceMenu)
                    Divider().Compose(context: context)
                } else if let menu = strippedItemView as? Menu {
                    if let button = menu.label.collectViews(context: context).first?.strippingModifiers(perform: { $0 as? Button }) {
                        ComposeDropdownMenuItem(for: button.label, context: context) {
                            replaceMenu(menu)
                        }
                    }
                } else {
                    // Dividers are also supported... maybe other view types?
                    itemView.Compose(context: context)
                }
            }
        }
    }

    @Composable private static func ComposeDropdownMenuItem(for view: ComposeView, context: ComposeContext, isSelected: Bool? = nil, action: () -> Void) {
        let label = view.collectViews(context: context).first?.strippingModifiers(perform: { $0 as? Label })
        if let isSelected {
            let selectedIcon: @Composable () -> Void
            if isSelected {
                selectedIcon = { Icon(imageVector: Icons.Outlined.Check, contentDescription: "selected") }
            } else {
                selectedIcon = {}
            }
            if let label {
                DropdownMenuItem(text: { label.ComposeTitle(context: context) }, leadingIcon: selectedIcon, trailingIcon: { label.ComposeImage(context: context) }, onClick: action)
            } else {
                DropdownMenuItem(text: { view.Compose(context: context) }, leadingIcon: selectedIcon, onClick: action)
            }
        } else {
            if let label {
                DropdownMenuItem(text: { label.ComposeTitle(context: context) }, trailingIcon: { label.ComposeImage(context: context) }, onClick: action)
            } else {
                DropdownMenuItem(text: { view.Compose(context: context) }, onClick: action)
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct MenuStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = MenuStyle(rawValue: 0)
    public static let button = MenuStyle(rawValue: 1)
}

public struct MenuActionDismissBehavior: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = MenuActionDismissBehavior(rawValue: 0)
    public static let enabled = MenuActionDismissBehavior(rawValue: 0)
    @available(*, unavailable)
    public static let disabled = MenuActionDismissBehavior(rawValue: 1)
}

public struct MenuOrder: RawRepresentable, Equatable, Hashable, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = MenuOrder(rawValue: 0)
    @available(*, unavailable)
    public static let priority = MenuOrder(rawValue: 1)
    public static let fixed = MenuOrder(rawValue: 2)
}

extension View {
    public func menuStyle(_ style: MenuStyle) -> some View {
        return self
    }

    public func menuActionDismissBehavior(_ behavior: MenuActionDismissBehavior) -> some View {
        return self
    }

    @available(*, unavailable)
    public func menuIndicator(_ visibility: Visibility) -> some View {
        return self
    }

    public func menuOrder(_ order: MenuOrder) -> some View {
        return self
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

//@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
//@available(watchOS, unavailable)
//extension Menu where Label == MenuStyleConfiguration.Label, Content == MenuStyleConfiguration.Content {
//
//    /// Creates a menu based on a style configuration.
//    ///
//    /// Use this initializer within the ``MenuStyle/makeBody(configuration:)``
//    /// method of a ``MenuStyle`` instance to create an instance of the menu
//    /// being styled. This is useful for custom menu styles that modify the
//    /// current menu style.
//    ///
//    /// For example, the following code creates a new, custom style that adds a
//    /// red border around the current menu style:
//    ///
//    ///     struct RedBorderMenuStyle: MenuStyle {
//    ///         func makeBody(configuration: Configuration) -> some View {
//    ///             Menu(configuration)
//    ///                 .border(Color.red)
//    ///         }
//    ///     }
//    ///
//    public init(_ configuration: MenuStyleConfiguration) { fatalError() }
//}
//
///// A type that applies standard interaction behavior and a custom appearance
///// to all menus within a view hierarchy.
/////
///// To configure the current menu style for a view hierarchy, use the
///// ``View/menuStyle(_:)`` modifier.
//@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
//@available(watchOS, unavailable)
//public protocol MenuStyle {
//
//    /// A view that represents the body of a menu.
//    associatedtype Body : View
//
//    /// Creates a view that represents the body of a menu.
//    ///
//    /// - Parameter configuration: The properties of the menu.
//    ///
//    /// The system calls this method for each ``Menu`` instance in a view
//    /// hierarchy where this style is the current menu style.
//    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body
//
//    /// The properties of a menu.
//    typealias Configuration = MenuStyleConfiguration
//}

/// A configuration of a menu.
///
/// Use the ``Menu/init(_:)`` initializer of ``Menu`` to create an
/// instance using the current menu style, which you can modify to create a
/// custom style.
///
/// For example, the following code creates a new, custom style that adds a red
/// border to the current menu style:
///
///     struct RedBorderMenuStyle: MenuStyle {
///         func makeBody(configuration: Configuration) -> some View {
///             Menu(configuration)
///                 .border(Color.red)
///         }
///     }
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct MenuStyleConfiguration {

    /// A type-erased label of a menu.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A type-erased content of a menu.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }
}

#endif
