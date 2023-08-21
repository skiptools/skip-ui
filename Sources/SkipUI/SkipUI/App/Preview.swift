// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

#if canImport(UIKit)
import enum UIKit.PreviewLayout

/// Creates a preview of a SkipUI view.
///
/// - Parameters:
///   - name: Optional display name for the preview, which appears in the canvas.
///   - traits: Trait customizing the appearance of the preview.
///   - additionalTraits: Optional additional traits.
///   - body: A closure producing a SkipUI view.
//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//@freestanding(declaration) public macro Preview(_ name: String? = nil, traits: PreviewTrait<Preview.ViewTraits>, _ additionalTraits: PreviewTrait<Preview.ViewTraits>..., body: @escaping () -> View) = #externalMacro(module: "PreviewsMacros", type: "SkipUIView")

/// Creates a preview of a SkipUI view.
///
/// - Parameters:
///   - name: Optional display name for the preview, which appears in the canvas.
///   - body: A closure producing a SkipUI view.
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//@freestanding(declaration) public macro Preview(_ name: String? = nil, body: @escaping () -> View) = #externalMacro(module: "PreviewsMacros", type: "SkipUIView")

/// A context type for use with a preview.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol PreviewContext {

    /// Returns the context's value for a key, or a the key's default value
    /// if the context doesn't define a value for the key.
    subscript<Key>(key: Key.Type) -> Key.Value where Key : PreviewContextKey { get }
}

/// A key type for a preview context.
///
/// The default value is `nil`.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol PreviewContextKey {

    /// The type of the value returned by the key.
    associatedtype Value

    /// The default value of the key.
    static var defaultValue: Self.Value { get }
}

/// A simulator device that runs a preview.
///
/// Create a preview device by name, like "iPhone X", or by model number,
/// like "iPad8,1". Use the device in a call to the ``View/previewDevice(_:)``
/// modifier to set a preview device that doesn't change when you change the
/// run destination in Xcode:
///
///     struct CircleImage_Previews: PreviewProvider {
///         static var previews: some View {
///             CircleImage()
///                 .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
///         }
///     }
///
/// You can get a list of supported preview device names by using the
/// `xcrun` command in the Terminal app:
///
///     % xcrun simctl list devicetypes
///
/// Additionally, you can use the following values for macOS platform
/// development:
/// - "Mac"
/// - "Mac Catalyst"
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PreviewDevice : RawRepresentable, ExpressibleByStringLiteral, Sendable {

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public let rawValue: String = { fatalError() }()

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional("PaperSize.Legal")"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init(rawValue: String) { fatalError() }

    /// Creates an instance initialized to the given string value.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral: String) { fatalError() }

    /// A type that represents an extended grapheme cluster literal.
    ///
    /// Valid types for `ExtendedGraphemeClusterLiteralType` are `Character`,
    /// `String`, and `StaticString`.
    public typealias ExtendedGraphemeClusterLiteralType = String

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = String

    /// A type that represents a string literal.
    ///
    /// Valid types for `StringLiteralType` are `String` and `StaticString`.
    public typealias StringLiteralType = String

    /// A type that represents a Unicode scalar literal.
    ///
    /// Valid types for `UnicodeScalarLiteralType` are `Unicode.Scalar`,
    /// `Character`, `String`, and `StaticString`.
    public typealias UnicodeScalarLiteralType = String
}

/// Platforms that can run the preview.
///
/// Xcode infers the platform for a preview based on the currently
/// selected target. If you have a multiplatform target and want to
/// suggest a particular target for a preview, implement the
/// ``PreviewProvider/platform-75xu4`` computed property as a hint,
/// and specify one of the preview platforms:
///
///     struct CircleImage_Previews: PreviewProvider {
///         static var previews: some View {
///             CircleImage()
///         }
///
///         static var platform: PreviewPlatform? {
///             PreviewPlatform.tvOS
///         }
///     }
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum PreviewPlatform : Sendable {

    /// Specifies iOS as the preview platform.
    case iOS

    /// Specifies macOS as the preview platform.
    case macOS

    /// Specifies tvOS as the preview platform.
    case tvOS

    /// Specifies watchOS as the preview platform.
    case watchOS

    


}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension PreviewPlatform : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension PreviewPlatform : Hashable {
}

/// A type that produces view previews in Xcode.
///
/// Create an Xcode preview by declaring a structure that conforms to the
/// `PreviewProvider` protocol. Implement the required
/// ``PreviewProvider/previews-swift.type.property`` computed property,
/// and return the view to display:
///
///     struct CircleImage_Previews: PreviewProvider {
///         static var previews: some View {
///             CircleImage()
///         }
///     }
///
/// Xcode statically discovers preview providers in your project and generates
/// previews for any providers currently open in the source editor.
/// Xcode generates the preview using the current run destination as a hint
/// for which device to display. For example, Xcode shows the following preview
/// if you've selected an iOS target to run on the iPhone 12 Pro Max simulator:
///
/// ![A screenshot of the Xcode canvas previewing a circular image on an
/// iPhone in the portrait orientation.](PreviewProvider-1)
///
/// When you create a new file (File > New > File)
/// and choose the SkipUI view template, Xcode automatically inserts a
/// preview structure at the bottom of the file that you can configure.
/// You can also create new preview structures in an existing SkipUI
/// view file by choosing Editor > Create Preview.
///
/// Customize the preview's appearance by adding view modifiers, just like you
/// do when building a custom ``View``. This includes preview-specific
/// modifiers that let you control aspects of the preview, like the device
/// orientation:
///
///     struct CircleImage_Previews: PreviewProvider {
///         static var previews: some View {
///             CircleImage()
///                 .previewInterfaceOrientation(.landscapeLeft)
///         }
///     }
///
/// ![A screenshot of the Xcode canvas previewing a circular image on an
/// iPhone in the landscape left orientation.](PreviewProvider-2)
///
/// For the complete list of preview customizations,
/// see <doc:Previews-in-Xcode>.
///
/// Xcode creates different previews for each view in your preview,
/// so you can see variations side by side. For example, you
/// might want to see a view's light and dark appearances simultaneously:
///
///     struct CircleImage_Previews: PreviewProvider {
///         static var previews: some View {
///             CircleImage()
///             CircleImage()
///                 .preferredColorScheme(.dark)
///         }
///     }
///
/// Use a ``Group`` when you want to maintain different previews, but apply a
/// single modifier to all of them:
///
///     struct CircleImage_Previews: PreviewProvider {
///         static var previews: some View {
///             Group {
///                 CircleImage()
///                 CircleImage()
///                     .preferredColorScheme(.dark)
///             }
///             .previewLayout(.sizeThatFits)
///         }
///     }
///
/// ![A screenshot of the Xcode canvas previewing a circular image twice,
/// once with a light appearance and once with a dark appearance. Both
/// previews take up only as much room as they need to fit the circular
/// image.](PreviewProvider-3)
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//@MainActor public protocol PreviewProvider : _PreviewProvider {
//
//    /// The type to preview.
//    ///
//    /// When you create a preview, Swift infers this type from your
//    /// implementation of the required
//    /// ``PreviewProvider/previews-swift.type.property`` property.
//    associatedtype Previews : View
//
//    /// A collection of views to preview.
//    ///
//    /// Implement a computed `previews` property to indicate the content to
//    /// preview. Xcode generates a preview for each view that you list. You
//    /// can apply ``View`` modifiers to the views, like you do
//    /// when creating a custom view. For a preview, you can also use
//    /// various preview-specific modifiers that customize the preview.
//    /// For example, you can choose a specific device for the preview
//    /// by adding the ``View/previewDevice(_:)`` modifier:
//    ///
//    ///     struct CircleImage_Previews: PreviewProvider {
//    ///         static var previews: some View {
//    ///             CircleImage()
//    ///                 .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
//    ///         }
//    ///     }
//    ///
//    /// For the full list of preview-specific modifiers,
//    /// see <doc:Previews-in-Xcode>.
//    @ViewBuilder @MainActor static var previews: Self.Previews { get { fatalError() } }
//
//    /// The platform on which to run the provider.
//    ///
//    /// Xcode infers the platform for a preview based on the currently
//    /// selected target. If you have a multiplatform target and want to
//    /// suggest a particular target for a preview, implement the
//    /// `platform` computed property to provide a hint,
//    /// and specify one of the ``PreviewPlatform`` values:
//    ///
//    ///     struct CircleImage_Previews: PreviewProvider {
//    ///         static var previews: some View {
//    ///             CircleImage()
//    ///         }
//    ///
//    ///         static var platform: PreviewPlatform? {
//    ///             PreviewPlatform.tvOS
//    ///         }
//    ///     }
//    ///
//    /// Xcode ignores this value unless you have a multiplatform target.
//    @MainActor static var platform: PreviewPlatform? { get { fatalError() } }
//}
//
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension PreviewProvider {
//
//    /// The platform to run the provider on.
//    ///
//    /// This default implementation of the ``PreviewProvider/platform-75xu4``
//    /// computed property returns `nil`. Rely on this implementation unless
//    /// you have a multiplatform target and want to suggest a particular
//    /// platform for a preview.
//    @MainActor public static var platform: PreviewPlatform? { get { fatalError() } }
//}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Overrides the device for a preview.
    ///
    /// By default, Xcode automatically chooses a preview device based
    /// on your currently selected run destination. If you want to
    /// choose a device that doesn't change based on Xcode settings,
    /// provide a ``PreviewDevice`` instance that you initialize with
    /// the name or model of a specific device:
    ///
    ///     struct CircleImage_Previews: PreviewProvider {
    ///         static var previews: some View {
    ///             CircleImage()
    ///                 .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
    ///         }
    ///     }
    ///
    /// You can get a list of supported preview device names, like "iPhone 11",
    /// "iPad Pro (11-inch)", and "Apple Watch Series 5 - 44mm", by using the
    /// `xcrun` command in the Terminal app:
    ///
    ///     % xcrun simctl list devicetypes
    ///
    /// Additionally, you can use the following values for macOS platform
    /// development:
    /// - "Mac"
    /// - "Mac Catalyst"
    ///
    /// - Parameter value: A device to use for preview, or `nil` to let Xcode
    ///   automatically choose a device based on the run destination.
    /// - Returns: A preview that uses the given device.
    @inlinable public func previewDevice(_ value: PreviewDevice?) -> some View { return stubView() }


    /// Overrides the size of the container for the preview.
    ///
    /// By default, previews use the ``PreviewLayout/device`` layout,
    /// which places the view inside a visual representation of the chosen
    /// device. You can instead tell a preview to use a different layout
    /// by choosing one of the ``PreviewLayout`` values, like
    /// ``PreviewLayout/sizeThatFits``:
    ///
    ///     struct CircleImage_Previews: PreviewProvider {
    ///         static var previews: some View {
    ///             CircleImage()
    ///                 .previewLayout(.sizeThatFits)
    ///         }
    ///     }
    ///
    /// - Parameter value: A layout to use for preview.
    /// - Returns: A preview that uses the given layout.
    @inlinable public func previewLayout(_ value: PreviewLayout) -> some View { return stubView() }


    /// Sets a user visible name to show in the canvas for a preview.
    ///
    /// Apply this modifier to a view inside your ``PreviewProvider``
    /// implementation to associate a display name with that view's preview:
    ///
    ///     struct CircleImage_Previews: PreviewProvider {
    ///         static var previews: some View {
    ///             CircleImage()
    ///                 .previewDisplayName("Circle")
    ///         }
    ///     }
    ///
    /// ![A screenshot of the Xcode preview canvas cropped to just the top of a
    /// preview, highlighting the name in the preview's title bar, which is set
    /// to the word circle.](View-previewDisplayName-1)
    ///
    /// Add a name when you have multiple previews together in the canvas that
    /// you need to tell apart. The default value is `nil`, in which case
    /// Xcode displays a default string.
    ///
    /// - Parameter value: A name for the preview.
    /// - Returns: A preview that uses the given name.
    @inlinable public func previewDisplayName(_ value: String?) -> some View { return stubView() }


    /// Declares a context for the preview.
    ///
    /// - Parameter value: The context for the preview; the default is `nil`.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @inlinable public func previewContext<C>(_ value: C) -> some View where C : PreviewContext { return stubView() }


    /// Overrides the orientation of the preview.
    ///
    /// By default, device previews appear right side up, using orientation
    /// ``InterfaceOrientation/portrait``. You can
    /// change the orientation of a preview using one of the values in
    /// the ``InterfaceOrientation`` structure:
    ///
    ///     struct CircleImage_Previews: PreviewProvider {
    ///         static var previews: some View {
    ///             CircleImage()
    ///                 .previewInterfaceOrientation(.landscapeRight)
    ///         }
    ///     }
    ///
    /// - Parameter value: An orientation to use for preview.
    /// - Returns: A preview that uses the given orientation.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func previewInterfaceOrientation(_ value: InterfaceOrientation) -> some View { return stubView() }

}

//extension Preview {
//
//    /// Creates a preview of a SkipUI view.
//    ///
//    /// The `#Preview` macro expands into a declaration that calls this initializer. To create a preview
//    /// that appears in the canvas, you must use the macro, not instantiate a Preview directly.
//    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//    public init(_ name: String? = nil, traits: PreviewTrait<Preview.ViewTraits>..., body: @escaping () -> View) { fatalError() }
//}

#endif

#endif
