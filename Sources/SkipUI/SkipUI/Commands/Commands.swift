// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// No-op
func stubCommands() -> some Commands {
    //return never() // raises warning: “A call to a never-returning function”
    struct NeverCommands : Commands {
        typealias Body = Never
        var body: Body { fatalError() }
    }
    return NeverCommands()
}


/// Conforming types represent a group of related commands that can be exposed
/// to the user via the main menu on macOS and key commands on iOS.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol Commands {

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    associatedtype Body : Commands

    /// The contents of the command hierarchy.
    ///
    /// For any commands that you create, provide a computed `body` property
    /// that defines the scene as a composition of other scenes. You can
    /// assemble a command hierarchy from built-in commands that SkipUI
    /// provides, as well as other commands that you've defined.
    @CommandsBuilder var body: Self.Body { get }
}


@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Never : Commands {
}

//@available(iOS 14.0, macOS 11.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension Group : Commands where Content : Commands {
//
//    /// Creates a group of commands.
//    ///
//    /// - Parameter content: A ``SkipUI/CommandsBuilder`` that produces the
//    /// commands to group.
//    @inlinable public init(@CommandsBuilder content: () -> Content) { fatalError() }
//
//    public var body: Never { fatalError() }
//}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Optional : Commands where Wrapped : Commands {

    //public typealias Body = NeverView
    public var body: some Commands { stubCommands() }
}

/// An empty group of commands.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct EmptyCommands : Commands {

    /// Creates an empty command hierarchy.
    public init() { fatalError() }

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// Groups of controls that you can add to existing command menus.
///
/// In macOS, SkipUI realizes command groups as collections of menu items in a
/// menu bar menu. In iOS, iPadOS, and tvOS, SkipUI creates key commands for
/// each of a group's commands that has a keyboard shortcut.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct CommandGroup<Content> : Commands where Content : View {

    /// A value describing the addition of the given views to the beginning of
    /// the indicated group.
    public init(before group: CommandGroupPlacement, @ViewBuilder addition: () -> Content) { fatalError() }

    /// A value describing the addition of the given views to the end of the
    /// indicated group.
    public init(after group: CommandGroupPlacement, @ViewBuilder addition: () -> Content) { fatalError() }

    /// A value describing the complete replacement of the contents of the
    /// indicated group with the given views.
    public init(replacing group: CommandGroupPlacement, @ViewBuilder addition: () -> Content) { fatalError() }

    /// The contents of the command hierarchy.
    ///
    /// For any commands that you create, provide a computed `body` property
    /// that defines the scene as a composition of other scenes. You can
    /// assemble a command hierarchy from built-in commands that SkipUI
    /// provides, as well as other commands that you've defined.
    public var body: some Commands { get { stubCommands() } }

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    //public typealias Body = NeverView
}

/// The standard locations that you can place new command groups relative to.
///
/// The names of these placements aren't visible in the user interface, but
/// the discussion for each placement lists the items that it includes.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct CommandGroupPlacement {

    /// Placement for commands that provide information about the app,
    /// the terms of the user's license agreement, and so on.
    ///
    /// By default, this group includes the following command in macOS:
    /// * About App
    public static let appInfo: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that expose app settings and
    /// preferences.
    ///
    /// By default, this group includes the following command in macOS:
    /// * Preferences
    public static let appSettings: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that expose services other apps provide.
    ///
    /// By default, this group includes the following command in macOS:
    /// * Services submenu (managed automatically)
    public static let systemServices: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that control the visibility of running
    /// apps.
    ///
    /// By default, this group includes the following commands in macOS:
    /// * Hide App
    /// * Hide Others
    /// * Show All
    public static let appVisibility: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that result in app termination.
    ///
    /// By default, this group includes the following command in macOS:
    /// * Quit App
    public static let appTermination: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that create and open different kinds of
    /// documents.
    ///
    /// By default, this group includes the following commands in macOS:
    /// * New
    /// * Open
    /// * Open Recent submenu (managed automatically)
    public static let newItem: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that save open documents and close
    /// windows.
    ///
    /// By default, this group includes the following commands in macOS:
    /// * Close
    /// * Save
    /// * Save As/Duplicate
    /// * Revert to Saved
    public static let saveItem: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that relate to importing and exporting
    /// data using formats that the app doesn't natively support.
    ///
    /// Empty by default in macOS.
    public static let importExport: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands related to printing app content.
    ///
    /// By default, this group includes the following commands in macOS:
    /// * Page Setup
    /// * Print
    public static let printItem: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that control the Undo Manager.
    ///
    /// By default, this group includes the following commands in macOS:
    /// * Undo
    /// * Redo
    public static let undoRedo: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that interact with the Clipboard and
    /// manipulate content that is currently selected in the app's view
    /// hierarchy.
    ///
    /// By default, this group includes the following commands in macOS:
    /// * Cut
    /// * Copy
    /// * Paste
    /// * Paste and Match Style
    /// * Delete
    /// * Select All
    public static let pasteboard: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that manipulate and transform text
    /// selections.
    ///
    /// By default, this group includes the following commands in macOS:
    /// * Find submenu
    /// * Spelling and Grammar submenu
    /// * Substitutions submenu
    /// * Transformations submenu
    /// * Speech submenu
    public static let textEditing: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that manipulate and transform the styles
    /// applied to text selections.
    ///
    /// By default, this group includes the following commands in macOS:
    /// * Font submenu
    /// * Text submenu
    public static let textFormatting: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that manipulate the toolbar.
    ///
    /// By default, this group includes the following commands in macOS:
    /// * Show/Hide Toolbar
    /// * Customize Toolbar
    public static let toolbar: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that control the app's sidebar and full-screen
    /// modes.
    ///
    /// By default, this group includes the following commands in macOS:
    /// * Show/Hide Sidebar
    /// * Enter/Exit Full Screen
    public static let sidebar: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that control the size of the window.
    ///
    /// By default, this group includes the following commands in macOS:
    /// * Minimize
    /// * Zoom
    public static let windowSize: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that arrange all of an app's windows.
    ///
    /// By default, this group includes the following command in macOS:
    /// * Bring All to Front
    public static let windowArrangement: CommandGroupPlacement = { fatalError() }()

    /// Placement for commands that present documentation and helpful
    /// information to people.
    ///
    /// By default, this group includes the following command in macOS:
    /// * App Help
    public static let help: CommandGroupPlacement = { fatalError() }()
}

/// Command menus are stand-alone, top-level containers for controls that
/// perform related, app-specific commands.
///
/// Command menus are realized as menu bar menus on macOS, inserted between the
/// built-in View and Window menus in order of declaration. On iOS, iPadOS, and
/// tvOS, SkipUI creates key commands for each of a menu's commands that has a
/// keyboard shortcut.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct CommandMenu<Content> : Commands where Content : View {

    /// Creates a new menu with a localized name for a collection of app-
    /// specific commands, inserted in the standard location for app menus
    /// (after the View menu, in order with other menus declared without an
    /// explicit location).
    public init(_ nameKey: LocalizedStringKey, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a new menu for a collection of app-specific commands, inserted
    /// in the standard location for app menus (after the View menu, in order
    /// with other menus declared without an explicit location).
    public init(_ name: Text, @ViewBuilder content: () -> Content) { fatalError() }

    /// Creates a new menu for a collection of app-specific commands, inserted
    /// in the standard location for app menus (after the View menu, in order
    /// with other menus declared without an explicit location).
    public init<S>(_ name: S, @ViewBuilder content: () -> Content) where S : StringProtocol { fatalError() }

    /// The contents of the command hierarchy.
    ///
    /// For any commands that you create, provide a computed `body` property
    /// that defines the scene as a composition of other scenes. You can
    /// assemble a command hierarchy from built-in commands that SkipUI
    /// provides, as well as other commands that you've defined.
    public var body: some Commands { get { stubCommands() } }

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    //public typealias Body = NeverView
}

/// Constructs command sets from multi-expression closures. Like `ViewBuilder`,
/// it supports up to ten expressions in the closure body.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@resultBuilder public struct CommandsBuilder {

    /// Builds an expression within the builder.
    public static func buildExpression<Content>(_ content: Content) -> Content where Content : Commands { fatalError() }

    /// Builds an empty command set from a block containing no statements.
    public static func buildBlock() -> EmptyCommands { fatalError() }

    /// Passes a single command group written as a child group through
    /// modified.
    public static func buildBlock<C>(_ content: C) -> C where C : Commands { fatalError() }
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension CommandsBuilder {

    /// Provides support for "if" statements in multi-statement closures,
    /// producing an optional value that is visible only when the condition
    /// evaluates to `true`.
    public static func buildIf<C>(_ content: C?) -> C? where C : Commands { fatalError() }

    /// Provides support for "if" statements in multi-statement closures,
    /// producing conditional content for the "then" branch.
//    public static func buildEither<T, F>(first: T) -> _ConditionalContent<T, F> where T : Commands, F : Commands { fatalError() }

    /// Provides support for "if-else" statements in multi-statement closures,
    /// producing conditional content for the "else" branch.
//    public static func buildEither<T, F>(second: F) -> _ConditionalContent<T, F> where T : Commands, F : Commands { fatalError() }

    /// Provides support for "if" statements with `#available()` clauses in
    /// multi-statement closures, producing conditional content for the "then"
    /// branch, i.e. the conditionally-available branch.
    public static func buildLimitedAvailability<C>(_ content: C) -> some Commands where C : Commands { stubCommands() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension CommandsBuilder {

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> some Commands where C0 : Commands, C1 : Commands { stubCommands() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension CommandsBuilder {

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> some Commands where C0 : Commands, C1 : Commands, C2 : Commands { stubCommands() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension CommandsBuilder {

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> some Commands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands { stubCommands() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension CommandsBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> some Commands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands { stubCommands() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension CommandsBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> some Commands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands { stubCommands() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension CommandsBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> some Commands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands { stubCommands() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension CommandsBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> some Commands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands { stubCommands() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension CommandsBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> some Commands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands { stubCommands() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension CommandsBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> some Commands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands { stubCommands() }

}


/// A built-in set of commands for transforming the styles applied to selections
/// of text.
///
/// These commands are optional and can be explicitly requested by passing a
/// value of this type to the `Scene.commands(_:)` modifier.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TextFormattingCommands : Commands {

    /// A new value describing the built-in text-formatting commands.
    public init() { fatalError() }

    /// The contents of the command hierarchy.
    ///
    /// For any commands that you create, provide a computed `body` property
    /// that defines the scene as a composition of other scenes. You can
    /// assemble a command hierarchy from built-in commands that SkipUI
    /// provides, as well as other commands that you've defined.
    public var body: some Commands { get { stubCommands() } }

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    //public typealias Body = NeverView
}

/// A built-in set of commands for manipulating window sidebars.
///
/// These commands are optional and can be explicitly requested by passing a
/// value of this type to the ``Scene/commands(content:)`` modifier.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct SidebarCommands : Commands {

    /// A new value describing the built-in sidebar-related commands.
    public init() { fatalError() }

    /// The contents of the command hierarchy.
    ///
    /// For any commands that you create, provide a computed `body` property
    /// that defines the scene as a composition of other scenes. You can
    /// assemble a command hierarchy from built-in commands that SkipUI
    /// provides, as well as other commands that you've defined.
    public var body: some Commands { get { stubCommands() } }

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    //public typealias Body = NeverView
}

#endif
