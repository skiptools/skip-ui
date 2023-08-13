// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

import class Foundation.Bundle

/// A representation of a color that adapts to a given context.
///
/// You can create a color in one of several ways:
///
/// * Load a color from an Asset Catalog:
///     ```
///     let aqua = Color("aqua") // Looks in your app's main bundle by default.
///     ```
/// * Specify component values, like red, green, and blue; hue,
///   saturation, and brightness; or white level:
///     ```
///     let skyBlue = Color(red: 0.4627, green: 0.8392, blue: 1.0)
///     let lemonYellow = Color(hue: 0.1639, saturation: 1, brightness: 1)
///     let steelGray = Color(white: 0.4745)
///     ```
/// * Create a color instance from another color, like a
///    or an
///   :
///     ```
///     #if os(iOS)
///     let linkColor = Color(uiColor: .link)
///     #elseif os(macOS)
///     let linkColor = Color(nsColor: .linkColor)
///     #endif
///     ```
/// * Use one of a palette of predefined colors, like ``ShapeStyle/black``,
///   ``ShapeStyle/green``, and ``ShapeStyle/purple``.
///
/// Some view modifiers can take a color as an argument. For example,
/// ``View/foregroundStyle(_:)`` uses the color you provide to set the
/// foreground color for view elements, like text or symbols.
///
///     Image(systemName: "leaf.fill")
///         .foregroundStyle(Color.green)
///
/// ![A screenshot of a green leaf.](Color-1)
///
/// Because SkipUI treats colors as ``View`` instances, you can also
/// directly add them to a view hierarchy. For example, you can layer
/// a rectangle beneath a sun image using colors defined above:
///
///     ZStack {
///         skyBlue
///         Image(systemName: "sun.max.fill")
///             .foregroundStyle(lemonYellow)
///     }
///     .frame(width: 200, height: 100)
///
/// A color used as a view expands to fill all the space it's given,
/// as defined by the frame of the enclosing ``ZStack`` in the above example:
///
/// ![A screenshot of a yellow sun on a blue background.](Color-2)
///
/// SkipUI only resolves a color to a concrete value
/// just before using it in a given environment.
/// This enables a context-dependent appearance for
/// system defined colors, or those that you load from an Asset Catalog.
/// For example, a color can have distinct light and dark variants
/// that the system chooses from at render time.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Color : Hashable, CustomStringConvertible, Sendable {

    /// Creates a color that represents the specified custom color.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init<T>(_ color: T) where T : Hashable, T : ShapeStyle, T.Resolved == Color.Resolved { fatalError() }

    /// Evaluates this color to a resolved color given the current
    /// `context`.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func resolve(in environment: EnvironmentValues) -> Color.Resolved { fatalError() }

    /// A Core Graphics representation of the color, if available.
    ///
    /// You can get a
    /// instance from a constant SkipUI color. This includes colors you create
    /// from a Core Graphics color, from RGB or HSB components, or from constant
    /// UIKit and AppKit colors.
    ///
    /// For a dynamic color, like one you load from an Asset Catalog using
    /// ``init(_:bundle:)``, or one you create from a dynamic UIKit or AppKit
    /// color, this property is `nil`. To evaluate all types of colors, use the
    /// `resolve(in:)` method.
    @available(iOS, introduced: 14.0, deprecated: 100000.0, renamed: "resolve(in:)")
    @available(macOS, introduced: 11.0, deprecated: 100000.0, renamed: "resolve(in:)")
    @available(tvOS, introduced: 14.0, deprecated: 100000.0, renamed: "resolve(in:)")
    @available(watchOS, introduced: 7.0, deprecated: 100000.0, renamed: "resolve(in:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "resolve(in:)")
    public var cgColor: CGColor? { get { fatalError() } }


    /// A textual representation of the color.
    ///
    /// Use this method to get a string that represents the color.
    /// The 
    /// function uses this property to get a string representing an instance:
    ///
    ///     print(Color.red)
    ///     // Prints "red"
    public var description: String { get { fatalError() } }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color : View {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Color {

    /// A concrete color value.
    ///
    /// `Color.Resolved` is a set of RGBA values that represent a color that can
    /// be shown. The values are in Linear sRGB color space, extended range. This is
    /// a low-level type, most colors are represented by the `Color` type.
    ///
    /// - SeeAlso: `Color`
    @frozen public struct Resolved : Hashable {

        /// The amount of red in the color in the sRGB linear color space.
        public var linearRed: Float { get { fatalError() } }

        /// The amount of green in the color in the sRGB linear color space.
        public var linearGreen: Float { get { fatalError() } }

        /// The amount of blue in the color in the sRGB linear color space.
        public var linearBlue: Float { get { fatalError() } }

        /// The degree of opacity in the color, given in the range `0` to `1`.
        ///
        /// A value of `0` means 100% transparency, while a value of `1` means
        /// 100% opacity.
        public var opacity: Float { get { fatalError() } }

    
        

        }

    /// Creates a constant color with the values specified by the resolved
    /// color.
    public init(_ resolved: Color.Resolved) { fatalError() }
}

@available(iOS, introduced: 14.0, deprecated: 100000.0, message: "Use Color(cgColor:) when converting a CGColor, or create a standard Color directly")
@available(macOS, introduced: 11.0, deprecated: 100000.0, message: "Use Color(cgColor:) when converting a CGColor, or create a standard Color directly")
@available(tvOS, introduced: 14.0, deprecated: 100000.0, message: "Use Color(cgColor:) when converting a CGColor, or create a standard Color directly")
@available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "Use Color(cgColor:) when converting a CGColor, or create a standard Color directly")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use Color(cgColor:) when converting a CGColor, or create a standard Color directly")
extension Color {

    /// Creates a color from a Core Graphics color.
    ///
    /// - Parameter color: A
    ///    instance
    ///   from which to create a color.
    public init(_ cgColor: CGColor) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Color {

    /// Creates a color from a Core Graphics color.
    ///
    /// - Parameter color: A
    ///    instance
    ///   from which to create a color.
    public init(cgColor: CGColor) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {

    /// A profile that specifies how to interpret a color value for display.
    public enum RGBColorSpace : Sendable {

        /// The extended red, green, blue (sRGB) color space.
        ///
        /// For information about the sRGB colorimetry and nonlinear
        /// transform function, see the IEC 61966-2-1 specification.
        ///
        /// Standard sRGB color spaces clamp the red, green, and blue
        /// components of a color to a range of `0` to `1`, but SkipUI colors
        /// use an extended sRGB color space, so you can use component values
        /// outside that range.
        case sRGB

        /// The extended sRGB color space with a linear transfer function.
        ///
        /// This color space has the same colorimetry as ``sRGB``, but uses
        /// a linear transfer function.
        ///
        /// Standard sRGB color spaces clamp the red, green, and blue
        /// components of a color to a range of `0` to `1`, but SkipUI colors
        /// use an extended sRGB color space, so you can use component values
        /// outside that range.
        case sRGBLinear

        /// The Display P3 color space.
        ///
        /// This color space uses the Digital Cinema Initiatives - Protocol 3
        /// (DCI-P3) primary colors, a D65 white point, and the ``sRGB``
        /// transfer function.
        case displayP3

        

    
        }

    /// Creates a constant color from red, green, and blue component values.
    ///
    /// This initializer creates a constant color that doesn't change based
    /// on context. For example, it doesn't have distinct light and dark
    /// appearances, unlike various system-defined colors, or a color that
    /// you load from an Asset Catalog with ``init(_:bundle:)``.
    ///
    /// A standard sRGB color space clamps each color component — `red`,
    /// `green`, and `blue` — to a range of `0` to `1`, but SkipUI colors
    /// use an extended sRGB color space, so
    /// you can use component values outside that range. This makes it
    /// possible to create colors using the ``RGBColorSpace/sRGB`` or
    /// ``RGBColorSpace/sRGBLinear`` color space that make full use of the wider
    /// gamut of a diplay that supports ``RGBColorSpace/displayP3``.
    ///
    /// - Parameters:
    ///   - colorSpace: The profile that specifies how to interpret the color
    ///     for display. The default is ``RGBColorSpace/sRGB``.
    ///   - red: The amount of red in the color.
    ///   - green: The amount of green in the color.
    ///   - blue: The amount of blue in the color.
    ///   - opacity: An optional degree of opacity, given in the range `0` to
    ///     `1`. A value of `0` means 100% transparency, while a value of `1`
    ///     means 100% opacity. The default is `1`.
    public init(_ colorSpace: Color.RGBColorSpace = .sRGB, red: Double, green: Double, blue: Double, opacity: Double = 1) { fatalError() }

    /// Creates a constant grayscale color.
    ///
    /// This initializer creates a constant color that doesn't change based
    /// on context. For example, it doesn't have distinct light and dark
    /// appearances, unlike various system-defined colors, or a color that
    /// you load from an Asset Catalog with ``init(_:bundle:)``.
    ///
    /// A standard sRGB color space clamps the `white` component
    /// to a range of `0` to `1`, but SkipUI colors
    /// use an extended sRGB color space, so
    /// you can use component values outside that range. This makes it
    /// possible to create colors using the ``RGBColorSpace/sRGB`` or
    /// ``RGBColorSpace/sRGBLinear`` color space that make full use of the wider
    /// gamut of a diplay that supports ``RGBColorSpace/displayP3``.
    ///
    /// - Parameters:
    ///   - colorSpace: The profile that specifies how to interpret the color
    ///     for display. The default is ``RGBColorSpace/sRGB``.
    ///   - white: A value that indicates how white
    ///     the color is, with higher values closer to 100% white, and lower
    ///     values closer to 100% black.
    ///   - opacity: An optional degree of opacity, given in the range `0` to
    ///     `1`. A value of `0` means 100% transparency, while a value of `1`
    ///     means 100% opacity. The default is `1`.
    public init(_ colorSpace: Color.RGBColorSpace = .sRGB, white: Double, opacity: Double = 1) { fatalError() }

    /// Creates a constant color from hue, saturation, and brightness values.
    ///
    /// This initializer creates a constant color that doesn't change based
    /// on context. For example, it doesn't have distinct light and dark
    /// appearances, unlike various system-defined colors, or a color that
    /// you load from an Asset Catalog with ``init(_:bundle:)``.
    ///
    /// - Parameters:
    ///   - hue: A value in the range `0` to `1` that maps to an angle
    ///     from 0° to 360° to represent a shade on the color wheel.
    ///   - saturation: A value in the range `0` to `1` that indicates
    ///     how strongly the hue affects the color. A value of `0` removes the
    ///     effect of the hue, resulting in gray. As the value increases,
    ///     the hue becomes more prominent.
    ///   - brightness: A value in the range `0` to `1` that indicates
    ///     how bright a color is. A value of `0` results in black, regardless
    ///     of the other components. The color lightens as you increase this
    ///     component.
    ///   - opacity: An optional degree of opacity, given in the range `0` to
    ///     `1`. A value of `0` means 100% transparency, while a value of `1`
    ///     means 100% opacity. The default is `1`.
    public init(hue: Double, saturation: Double, brightness: Double, opacity: Double = 1) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {

    /// A color that reflects the accent color of the system or app.
    ///
    /// The accent color is a broad theme color applied to
    /// views and controls. You can set it at the application level by specifying
    /// an accent color in your app's asset catalog.
    ///
    /// > Note: In macOS, SkipUI applies customization of the accent color
    /// only if the user chooses Multicolor under General > Accent color
    /// in System Preferences.
    ///
    /// The following code renders a ``Text`` view using the app's accent color:
    ///
    ///     Text("Accent Color")
    ///         .foregroundStyle(Color.accentColor)
    ///
    public static var accentColor: Color { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {

    /// A context-dependent red color suitable for use in UI elements.
    public static let red: Color = { fatalError() }()

    /// A context-dependent orange color suitable for use in UI elements.
    public static let orange: Color = { fatalError() }()

    /// A context-dependent yellow color suitable for use in UI elements.
    public static let yellow: Color = { fatalError() }()

    /// A context-dependent green color suitable for use in UI elements.
    public static let green: Color = { fatalError() }()

    /// A context-dependent mint color suitable for use in UI elements.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static let mint: Color = { fatalError() }()

    /// A context-dependent teal color suitable for use in UI elements.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static let teal: Color = { fatalError() }()

    /// A context-dependent cyan color suitable for use in UI elements.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static let cyan: Color = { fatalError() }()

    /// A context-dependent blue color suitable for use in UI elements.
    public static let blue: Color = { fatalError() }()

    /// A context-dependent indigo color suitable for use in UI elements.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static let indigo: Color = { fatalError() }()

    /// A context-dependent purple color suitable for use in UI elements.
    public static let purple: Color = { fatalError() }()

    /// A context-dependent pink color suitable for use in UI elements.
    public static let pink: Color = { fatalError() }()

    /// A context-dependent brown color suitable for use in UI elements.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static let brown: Color = { fatalError() }()

    /// A white color suitable for use in UI elements.
    public static let white: Color = { fatalError() }()

    /// A context-dependent gray color suitable for use in UI elements.
    public static let gray: Color = { fatalError() }()

    /// A black color suitable for use in UI elements.
    public static let black: Color = { fatalError() }()

    /// A clear color suitable for use in UI elements.
    public static let clear: Color = { fatalError() }()

    /// The color to use for primary content.
    public static let primary: Color = { fatalError() }()

    /// The color to use for secondary content.
    public static let secondary: Color = { fatalError() }()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color : ShapeStyle {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {

    /// Creates a color from a color set that you indicate by name.
    ///
    /// Use this initializer to load a color from a color set stored in an
    /// Asset Catalog. The system determines which color within the set to use
    /// based on the environment at render time. For example, you
    /// can provide light and dark versions for background and foreground
    /// colors:
    ///
    /// ![A screenshot of color sets for foreground and background colors,
    ///   each with light and dark variants,
    ///   in an Asset Catalog.](Color-init-1)
    ///
    /// You can then instantiate colors by referencing the names of the assets:
    ///
    ///     struct Hello: View {
    ///         var body: some View {
    ///             ZStack {
    ///                 Color("background")
    ///                 Text("Hello, world!")
    ///                     .foregroundStyle(Color("foreground"))
    ///             }
    ///             .frame(width: 200, height: 100)
    ///         }
    ///     }
    ///
    /// SkipUI renders the appropriate colors for each appearance:
    ///
    /// ![A side by side comparison of light and dark appearance screenshots
    ///   of the same content. The light variant shows dark text on a light
    ///   background, while the dark variant shows light text on a dark
    ///   background.](Color-init-2)
    ///
    /// - Parameters:
    ///   - name: The name of the color resource to look up.
    ///   - bundle: The bundle in which to search for the color resource.
    ///     If you don't indicate a bundle, the initializer looks in your app's
    ///     main bundle by default.
    public init(_ name: String, bundle: Bundle? = nil) { fatalError() }
}


#if canImport(UIKit)
import class UIKit.UIColor
import struct UIKit.ColorResource

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Color {

    /// Initialize a `Color` with a color resource.
    public init(_ resource: ColorResource) { fatalError() }
}

@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use Color(uiColor:) when converting a UIColor, or create a standard Color directly")
@available(macOS, unavailable)
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use Color(uiColor:) when converting a UIColor, or create a standard Color directly")
@available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use Color(uiColor:) when converting a UIColor, or create a standard Color directly")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use Color(uiColor:) when converting a UIColor, or create a standard Color directly")
extension Color {

    /// Creates a color from a UIKit color.
    ///
    /// Use this method to create a SkipUI color from a
    ///  instance.
    /// The new color preserves the adaptability of the original.
    /// For example, you can create a rectangle using
    /// to see how the shade adjusts to match the user's system settings:
    ///
    ///     struct Box: View {
    ///         var body: some View {
    ///             Color(UIColor.link)
    ///                 .frame(width: 200, height: 100)
    ///         }
    ///     }
    ///
    /// The `Box` view defined above automatically changes its
    /// appearance when the user turns on Dark Mode. With the light and dark
    /// appearances placed side by side, you can see the subtle difference
    /// in shades:
    ///
    /// ![A side by side comparison of light and dark appearance screenshots of
    ///   rectangles rendered with the link color. The light variant appears on
    ///   the left, and the dark variant on the right.](Color-init-3)
    ///
    /// > Note: Use this initializer only if you need to convert an existing
    ///  to a
    /// SkipUI color. Otherwise, create a SkipUI ``Color`` using an
    /// initializer like ``init(_:red:green:blue:opacity:)``, or use a system
    /// color like ``ShapeStyle/blue``.
    ///
    /// - Parameter color: A
    ///    instance
    ///   from which to create a color.
    public init(_ color: UIColor) { fatalError() }
}


@available(iOS 15.0, tvOS 15.0, watchOS 8.0, *)
@available(macOS, unavailable)
extension Color {

    /// Creates a color from a UIKit color.
    ///
    /// Use this method to create a SkipUI color from a
    ///  instance.
    /// The new color preserves the adaptability of the original.
    /// For example, you can create a rectangle using
    /// to see how the shade adjusts to match the user's system settings:
    ///
    ///     struct Box: View {
    ///         var body: some View {
    ///             Color(uiColor: .link)
    ///                 .frame(width: 200, height: 100)
    ///         }
    ///     }
    ///
    /// The `Box` view defined above automatically changes its
    /// appearance when the user turns on Dark Mode. With the light and dark
    /// appearances placed side by side, you can see the subtle difference
    /// in shades:
    ///
    /// ![A side by side comparison of light and dark appearance screenshots of
    ///   rectangles rendered with the link color. The light variant appears on
    ///   the left, and the dark variant on the right.](Color-init-3)
    ///
    /// > Note: Use this initializer only if you need to convert an existing
    ///  to a
    /// SkipUI color. Otherwise, create a SkipUI ``Color`` using an
    /// initializer like ``init(_:red:green:blue:opacity:)``, or use a system
    /// color like ``ShapeStyle/blue``.
    ///
    /// - Parameter color: A
    ///    instance
    ///   from which to create a color.
    public init(uiColor: UIColor) { fatalError() }
}
#endif

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {

    /// Multiplies the opacity of the color by the given amount.
    ///
    /// - Parameter opacity: The amount by which to multiply the opacity of the
    ///   color.
    /// - Returns: A view with modified opacity.
    public func opacity(_ opacity: Double) -> Color { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Color {

    /// Returns the standard gradient for the color `self`.
    ///
    /// For example, filling a rectangle with a gradient derived from
    /// the standard blue color:
    ///
    ///     Rectangle().fill(.blue.gradient)
    ///
    public var gradient: AnyGradient { get { fatalError() } }
}

#if canImport(CoreTransferable)
import protocol CoreTransferable.Transferable
import protocol CoreTransferable.TransferRepresentation

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Color : Transferable {

    /// One group of colors–constant colors–created with explicitly specified
    /// component values are transferred as is.
    ///
    /// Another group of colors–standard colors, like `Color.mint`,
    /// and semantic colors, like `Color.accentColor`–are rendered on screen
    /// differently depending on the current ``SkipUI/Environment``. For transferring,
    /// they are resolved against the default environment and might produce
    /// a slightly different result at the destination if the source of drag
    /// or copy uses a non-default environment.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public static var transferRepresentation: some TransferRepresentation { get { return stubTransferRepresentation() } }

    /// The type of the representation used to import and export the item.
    ///
    /// Swift infers this type from the return value of the
    /// ``transferRepresentation`` property.
    //public typealias Representation = Never // some TransferRepresentation
}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Color.Resolved : ShapeStyle {

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Color.Resolved : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Color.Resolved : Animatable {

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<Float, AnimatablePair<Float, AnimatablePair<Float, Float>>>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Color.Resolved {

    /// Creates a resolved color from red, green, and blue component values.
    ///
    /// A standard sRGB color space clamps each color component — `red`,
    /// `green`, and `blue` — to a range of `0` to `1`, but SkipUI colors
    /// use an extended sRGB color space, so
    /// you can use component values outside that range. This makes it
    /// possible to create colors using the ``RGBColorSpace/sRGB`` or
    /// ``RGBColorSpace/sRGBLinear`` color space that make full use of the
    /// wider gamut of a diplay that supports ``RGBColorSpace/displayP3``.
    ///
    /// - Parameters:
    ///   - colorSpace: The profile that specifies how to interpret the
    ///     color for display. The default is ``RGBColorSpace/sRGB``.
    ///   - red: The amount of red in the color.
    ///   - green: The amount of green in the color.
    ///   - blue: The amount of blue in the color.
    ///   - opacity: An optional degree of opacity, given in the range `0`
    ///     to `1`. A value of `0` means 100% transparency, while a value of
    ///     `1` means 100% opacity. The default is `1`.
    public init(colorSpace: Color.RGBColorSpace = .sRGB, red: Float, green: Float, blue: Float, opacity: Float = 1) { fatalError() }

    /// The amount of red in the color in the sRGB color space.
    public var red: Float { get { fatalError() } }

    /// The amount of green in the color in the sRGB color space.
    public var green: Float { get { fatalError() } }

    /// The amount of blue in the color in the sRGB color space.
    public var blue: Float { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Color.Resolved : Codable {

    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws { fatalError() }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Color.Resolved {

    /// A Core Graphics representation of the color.
    ///
    /// You can get a
    /// instance from a resolved color.
    public var cgColor: CGColor { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color.RGBColorSpace : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color.RGBColorSpace : Hashable {
}

#endif
