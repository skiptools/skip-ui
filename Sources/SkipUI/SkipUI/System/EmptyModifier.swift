// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// An empty, or identity, modifier, used during development to switch
/// modifiers at compile time.
///
/// Use the empty modifier to switch modifiers at compile time during
/// development. In the example below, in a debug build the ``Text``
/// view inside `ContentView` has a yellow background and a red border.
/// A non-debug build reflects the default system, or container supplied
/// appearance.
///
///     struct EmphasizedLayout: ViewModifier {
///         func body(content: Content) -> some View {
///             content
///                 .background(Color.yellow)
///                 .border(Color.red)
///         }
///     }
///
///     struct ContentView: View {
///         var body: some View {
///             Text("Hello, World!")
///                 .modifier(modifier)
///         }
///
///         var modifier: some ViewModifier {
///             #if DEBUG
///                 return EmphasizedLayout()
///             #else
///                 return EmptyModifier()
///             #endif
///         }
///     }
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct EmptyModifier : ViewModifier {
    public static let identity: EmptyModifier = { fatalError() }()

    /// The type of view representing the body.
    public typealias Body = Content

    @inlinable public init() { fatalError() }

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    @MainActor public func body() -> EmptyModifier.Body { fatalError() }
    public typealias Content = Never
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EmptyModifier : Sendable {
}


#endif
