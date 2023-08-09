// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
    public var body: Body { get { return never() } }

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    public typealias Body = Never
}
