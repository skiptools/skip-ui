// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// A modifier that you apply to a view or another view modifier, producing a
/// different version of the original value.
///
/// Adopt the ``ViewModifier`` protocol when you want to create a reusable
/// modifier that you can apply to any view. The example below combines several
/// modifiers to create a new modifier that you can use to create blue caption
/// text surrounded by a rounded rectangle:
///
///     struct BorderedCaption: ViewModifier {
///         func body(content: Content) -> some View {
///             content
///                 .font(.caption2)
///                 .padding(10)
///                 .overlay(
///                     RoundedRectangle(cornerRadius: 15)
///                         .stroke(lineWidth: 1)
///                 )
///                 .foregroundColor(Color.blue)
///         }
///     }
///
/// You can apply ``View/modifier(_:)`` directly to a view, but a more common
/// and idiomatic approach uses ``View/modifier(_:)`` to define an extension to
/// ``View`` itself that incorporates the view modifier:
///
///     extension View {
///         func borderedCaption() -> some View {
///             modifier(BorderedCaption())
///         }
///     }
///
/// You can then apply the bordered caption to any view, similar to this:
///
///     Image(systemName: "bus")
///         .resizable()
///         .frame(width:50, height:50)
///     Text("Downtown Bus")
///         .borderedCaption()
///
/// ![A screenshot showing the image of a bus with a caption reading
/// Downtown Bus. A view extension, using custom a modifier, renders the
///  caption in blue text surrounded by a rounded
///  rectangle.](SkipUI-View-ViewModifier.png)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol ViewModifier {

    /// The type of view representing the body.
    associatedtype Body : View

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    @ViewBuilder @MainActor func body(content: Self.Content) -> Self.Body

    /// The content view type passed to `body()`.
    associatedtype Content
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewModifier where Self.Body == Never {

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: Self.Content) -> Self.Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewModifier {

    /// Returns a new modifier that is the result of concatenating
    /// `self` with `modifier`.
    public func concat<T>(_ modifier: T) -> ModifiedContent<Self, T> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewModifier {

    /// Returns a new version of the modifier that will apply the
    /// transaction mutation function `transform` to all transactions
    /// within the modifier.
//    public func transaction(_ transform: @escaping (inout Transaction) -> Void) -> some ViewModifier { fatalError() }


    /// Returns a new version of the modifier that will apply
    /// `animation` to all animatable values within the modifier.
//    public func animation(_ animation: Animation?) -> some ViewModifier { fatalError() }

}

#endif
