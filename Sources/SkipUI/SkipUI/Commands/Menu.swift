// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
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
// SKIP @bridge
public final class Menu : View, Renderable {
    let content: ComposeBuilder
    let label: ComposeBuilder
    let primaryAction: (() -> Void)?
    var toggleMenu: () -> Void = {}

    public init(@ViewBuilder content: () -> any View, @ViewBuilder label: () -> any View) {
        self.content = ComposeBuilder.from(content)
        #if SKIP
        self.label = ComposeBuilder(view: Button(action: { self.toggleMenu() }, label: label))
        #else
        self.label = ComposeBuilder(view: EmptyView())
        #endif
        self.primaryAction = nil
    }

    public convenience init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View) {
        self.init(content: content, label: { Text(titleKey) })
    }

    public convenience init(_ titleResource: LocalizedStringResource, @ViewBuilder content: () -> any View) {
        self.init(content: content, label: { Text(titleResource) })
    }

    public convenience init(_ title: String, @ViewBuilder content: () -> any View) {
        self.init(content: content, label: { Text(verbatim: title) })
    }

    public init(@ViewBuilder content: () -> any View, @ViewBuilder label: () -> any View, primaryAction: @escaping () -> Void) {
        self.content = ComposeBuilder.from(content)
        // We don't use a Button because we can't attach a long press detector to it
        // So currently, any Menu with a primaryAction ignores .buttonStyle
        self.label = ComposeBuilder.from(label)
        self.primaryAction = primaryAction
    }

    public convenience init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View, primaryAction: @escaping () -> Void) {
        self.init(content: content, label: { Text(titleKey) }, primaryAction: primaryAction)
    }

    public convenience init(_ titleResource: LocalizedStringResource, @ViewBuilder content: () -> any View, primaryAction: @escaping () -> Void) {
        self.init(content: content, label: { Text(titleResource) }, primaryAction: primaryAction)
    }

    public convenience init(_ title: String, @ViewBuilder content: () -> any View, primaryAction: @escaping () -> Void) {
        self.init(content: content, label: { Text(verbatim: title) }, primaryAction: primaryAction)
    }

    // SKIP @bridge
    public init(bridgedContent: any View, bridgedLabel: any View, primaryAction: (() -> Void)?) {
        self.content = ComposeBuilder.from { bridgedContent }
        if let primaryAction {
            self.label = ComposeBuilder.from { bridgedLabel }
            self.primaryAction = primaryAction
        } else {
            #if SKIP
            self.label = ComposeBuilder(view: Button(action: { self.toggleMenu() }, label: { bridgedLabel }))
            #else
            self.label = ComposeBuilder.from { bridgedLabel }
            #endif
            self.primaryAction = nil
        }
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
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
                    Button.RenderTextButton(label: label, context: context.content(modifier: primaryActionModifier))
                } else {
                    label.Compose(context: contentContext)
                }
                if isEnabled {
                    toggleMenu = Self.RenderDropdownMenu(content: content, context: contentContext)
                } else {
                    toggleMenu = {}
                }
            }
        }
    }

    @Composable static func RenderDropdownMenu(content: ComposeBuilder, context: ComposeContext) -> () -> Void {
        // We default to displaying our own content, but if the user selects a nested menu we can present
        // that instead. The nested menu selection is cleared on dismiss
        let isMenuExpanded = remember { mutableStateOf(false) }
        let nestedMenu = remember { mutableStateOf<Menu?>(nil) }
        let coroutineScope = rememberCoroutineScope()
        let toggleMenu = {
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
            var placement = EnvironmentValues.shared._placement
            EnvironmentValues.shared.setValues {
                placement.remove(ViewPlacement.toolbar) // Menus popovers are displayed outside the toolbar context
                $0.set_placement(placement)
                return ComposeResult.ok
            } in: {
                let renderables = (nestedMenu.value?.content ?? content).Evaluate(context: context, options: 0)
                Self.RenderDropdownMenuItems(for: renderables, context: context, replaceMenu: replaceMenu)
            }
        }
        return toggleMenu
    }

    @Composable static func RenderDropdownMenuItems(for renderables: kotlin.collections.List<Renderable>, selection: Hashable? = nil, context: ComposeContext, replaceMenu: (Menu?) -> Void) {
        for renderable in renderables {
            var stripped = renderable.strip()
            if let shareLink = stripped as? ShareLink {
                shareLink.ComposeAction()
                stripped = shareLink.content
            } else if let link = stripped as? Link {
                link.ComposeAction()
                stripped = link.content
            }
            if let button = stripped as? Button {
                let isSelected: Bool?
                if let tagModifier = TagModifier.on(content: renderable, role: .tag) {
                    isSelected = tagModifier.value == selection
                } else {
                    isSelected = nil
                }
                RenderDropdownMenuItem(for: button.label, context: context, isSelected: isSelected) {
                    button.action()
                    replaceMenu(nil)
                }
            } else if let text = stripped as? Text {
                DropdownMenuItem(text: { text.Render(context: context) }, onClick: {}, enabled: false)
            } else if let section = stripped as? Section {
                if let header = section.header {
                    DropdownMenuItem(text: { header.Compose(context: context) }, onClick: {}, enabled: false)
                }
                let sectionRenderables = section.content.Evaluate(context: context, options: 0)
                RenderDropdownMenuItems(for: sectionRenderables, context: context, replaceMenu: replaceMenu)
                Divider().Compose(context: context)
            } else if let menu = stripped as? Menu {
                if let button = menu.label.Evaluate(context: context, options: 0).firstOrNull()?.strip() as? Button {
                    RenderDropdownMenuItem(for: button.label, context: context) {
                        replaceMenu(menu)
                    }
                }
            } else {
                // Dividers are also supported... maybe other view types?
                renderable.Render(context: context)
            }
        }
    }

    @Composable private static func RenderDropdownMenuItem(for view: ComposeBuilder, context: ComposeContext, isSelected: Bool? = nil, action: () -> Void) {
        let renderables = view.Evaluate(context: context, options: 0)
        let label = renderables.firstOrNull()?.strip() as? Label
        if let isSelected {
            let selectedIcon: @Composable () -> Void
            if isSelected {
                selectedIcon = { Icon(imageVector: Icons.Outlined.Check, contentDescription: "selected") }
            } else {
                selectedIcon = {}
            }
            if let label {
                DropdownMenuItem(text: { label.RenderTitle(context: context) }, leadingIcon: selectedIcon, trailingIcon: { label.RenderImage(context: context) }, onClick: action)
            } else {
                DropdownMenuItem(text: {
                    for renderable in renderables {
                        renderable.Render(context: context)
                    }
                }, leadingIcon: selectedIcon, onClick: action)
            }
        } else {
            if let label {
                DropdownMenuItem(text: { label.RenderTitle(context: context) }, trailingIcon: { label.RenderImage(context: context) }, onClick: action)
            } else {
                DropdownMenuItem(text: {
                    for renderable in renderables {
                        renderable.Render(context: context)
                    }
                }, onClick: action)
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

    public static let automatic = MenuStyle(rawValue: 0) // For bridging
    public static let button = MenuStyle(rawValue: 1) // For bridging
}

public struct MenuActionDismissBehavior: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = MenuActionDismissBehavior(rawValue: 0) // For bridging
    public static let enabled = MenuActionDismissBehavior(rawValue: 0) // For bridging
    @available(*, unavailable)
    public static let disabled = MenuActionDismissBehavior(rawValue: 1) // For bridging
}

public struct MenuOrder: RawRepresentable, Equatable, Hashable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = MenuOrder(rawValue: 0) // For bridging
    @available(*, unavailable)
    public static let priority = MenuOrder(rawValue: 1) // For bridging
    public static let fixed = MenuOrder(rawValue: 2) // For bridging
}

extension View {
    public func menuStyle(_ style: MenuStyle) -> any View {
        return self
    }

    // SKIP @bridge
    public func menuStyle(bridgedStyle: Int) -> any View {
        return menuStyle(MenuStyle(rawValue: bridgedStyle))
    }

    public func menuActionDismissBehavior(_ behavior: MenuActionDismissBehavior) -> any View {
        return self
    }

    // SKIP @bridge
    public func menuActionDismissBehavior(bridgedBehavior: Int) -> any View {
        return menuActionDismissBehavior(MenuActionDismissBehavior(rawValue: bridgedBehavior))
    }

    @available(*, unavailable)
    public func menuIndicator(_ visibility: Visibility) -> some View {
        return self
    }

    public func menuOrder(_ order: MenuOrder) -> any View {
        return self
    }

    // SKIP @bridge
    public func menuOrder(bridgedOrder: Int) -> any View {
        return menuOrder(MenuOrder(rawValue: bridgedOrder))
    }
}

/*
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
*/
#endif
