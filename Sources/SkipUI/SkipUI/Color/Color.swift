// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP INSERT: import androidx.compose.foundation.background
// SKIP INSERT: import androidx.compose.runtime.Composable

public struct Color: View, Hashable, Sendable {
    #if SKIP
    let colorImpl: @Composable () -> androidx.compose.ui.graphics.Color

    init(colorImpl: @Composable () -> androidx.compose.ui.graphics.Color) {
        self.colorImpl = colorImpl
    }

    @Composable public override func Compose(context: ComposeContext) {
        let modifier = context.modifier.background(colorImpl())
        androidx.compose.foundation.layout.Box(modifier: modifier)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif

    @available(*, unavailable)
    public init(_ color: Any) {
        #if SKIP
        colorImpl = { androidx.compose.ui.graphics.Color.White }
        #endif
    }

    @available(*, unavailable)
    public init(cgColor: Any /* CGColor */) {
        #if SKIP
        colorImpl = { androidx.compose.ui.graphics.Color.White }
        #endif
    }

    @available(*, unavailable)
    public var cgColor: Any? /* CGColor? */ {
        fatalError()
    }

    #if SKIP
    @available(*, unavailable)
    public func resolve(in environment: Any /* EnvironmentValues */) -> Color.Resolved {
        fatalError()
    }
    #else
    public func resolve(in environment: EnvironmentValues) -> Color.Resolved {
        fatalError()
    }
    #endif
}

extension Color {
    public enum RGBColorSpace : Hashable, Sendable {
        case sRGB
        case sRGBLinear
        case displayP3
    }

    public init(red: Double, green: Double, blue: Double, opacity: Double = 1.0) {
        #if SKIP
        colorImpl = { androidx.compose.ui.graphics.Color(red = Float(red), green = Float(green), blue = Float(blue), alpha = Float(opacity)) }
        #endif
    }

    @available(*, unavailable)
    public init(_ colorSpace: Color.RGBColorSpace, red: Double, green: Double, blue: Double, opacity: Double = 1.0) {
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }

    public init(white: Double, opacity: Double = 1.0) {
        self.init(red: white, green: white, blue: white, opacity: opacity)
    }

    @available(*, unavailable)
    public init(_ colorSpace: Color.RGBColorSpace, white: Double, opacity: Double = 1.0) {
        self.init(white: white, opacity: opacity)
    }

    public init(hue: Double, saturation: Double, brightness: Double, opacity: Double = 1.0) {
        #if SKIP
        colorImpl = { androidx.compose.ui.graphics.Color.hsl(hue: Float(hue), saturation: Float(saturation), lightness: Float(brightness), alpha: Float(opacity)) }
        #endif
    }
}

extension Color {
    public struct Resolved : Hashable {
        public var red: Float
        public var green: Float
        public var blue: Float
        public var opacity: Float

        public init(red: Float, green: Float, blue: Float, opacity: Float) {
            self.red = red
            self.green = green
            self.blue = blue
            self.opacity = opacity
        }

        @available(*, unavailable)
        public init(colorSpace: Color.RGBColorSpace, red: Float, green: Float, blue: Float, opacity: Float) {
            self.init(red: red, green: green, blue: blue, opacity: opacity)
        }

        @available(*, unavailable)
        public var cgColor: Any /* CGColor */ {
            fatalError()
        }
    }

    public init(_ resolved: Color.Resolved) {
        self.init(red: Double(resolved.red), green: Double(resolved.green), blue: Double(resolved.blue), opacity: Double(resolved.opacity))
    }
}

extension Color {
    public static var accentColor: Color {
        #if SKIP
        return Color(colorImpl: { androidx.compose.material3.MaterialTheme.colorScheme.primary })
        #else
        fatalError()
        #endif
    }
}

#if SKIP
extension Color {
    public static let red = Color(colorImpl: { androidx.compose.ui.graphics.Color.Red })
    public static let orange = Color(colorImpl: { androidx.compose.ui.graphics.Color(0xFFFF9F0A) })
    public static let yellow = Color(colorImpl: { androidx.compose.ui.graphics.Color.Yellow })
    public static let green = Color(colorImpl: { androidx.compose.ui.graphics.Color.Green })
    public static let mint = Color(colorImpl: { androidx.compose.ui.graphics.Color(0xFF5AC8FA) })
    public static let teal = Color(colorImpl: { androidx.compose.ui.graphics.Color(0xFF64D2FF) })
    public static let cyan = Color(colorImpl: { androidx.compose.ui.graphics.Color.Cyan })
    public static let blue = Color(colorImpl: { androidx.compose.ui.graphics.Color.Blue })
    public static let indigo = Color(colorImpl: { androidx.compose.ui.graphics.Color(0xFF5856D6) })
    public static let purple = Color(colorImpl: { androidx.compose.ui.graphics.Color(0xFFAF52DE) })
    public static let pink = Color(colorImpl: { androidx.compose.ui.graphics.Color(0xFFFF2D55) })
    public static let brown = Color(colorImpl: { androidx.compose.ui.graphics.Color(0xFFA2845E) })
    public static let white = Color(colorImpl: { androidx.compose.ui.graphics.Color.White })
    public static let gray = Color(colorImpl: { androidx.compose.ui.graphics.Color.Gray })
    public static let black = Color(colorImpl: { androidx.compose.ui.graphics.Color.Black })
    public static let clear = Color(colorImpl: { androidx.compose.ui.graphics.Color.Transparent })
    public static let primary = Color(colorImpl: { androidx.compose.material3.MaterialTheme.colorScheme.onSurface })
    public static let secondary = Color(colorImpl: { androidx.compose.material3.MaterialTheme.colorScheme.onSurfaceVariant })
}
#endif

extension Color {
    @available(*, unavailable)
    public init(_ name: String, bundle: Any? = nil /* Bundle? = nil */) {
        #if SKIP
        colorImpl = { androidx.compose.ui.graphics.Color.White }
        #endif
    }
}

extension Color {
    @available(*, unavailable)
    public init(uiColor: Any /* UIColor */) {
        #if SKIP
        colorImpl = { androidx.compose.ui.graphics.Color.White }
        #endif
    }
}

extension Color {
    public func opacity(_ opacity: Double) -> Color {
        #if SKIP
        return Color(colorImpl: {
            let color = colorImpl()
            return color.copy(alpha: Float(opacity))
        })
        #else
        return self
        #endif
    }
}

extension Color {
    @available(*, unavailable)
    public var gradient: Any /* AnyGradient */ {
        fatalError()
    }
}

#if !SKIP

// Stubs needed to compile this package:

extension Color : ShapeStyle {
}

extension Color.Resolved : ShapeStyle {
    public typealias Resolved = Never
}

// Unneeded stubs:

//#if canImport(CoreTransferable)
//import protocol CoreTransferable.Transferable
//import protocol CoreTransferable.TransferRepresentation
//
//@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//extension Color : Transferable {
//
//    /// One group of colors–constant colors–created with explicitly specified
//    /// component values are transferred as is.
//    ///
//    /// Another group of colors–standard colors, like `Color.mint`,
//    /// and semantic colors, like `Color.accentColor`–are rendered on screen
//    /// differently depending on the current ``SkipUI/Environment``. For transferring,
//    /// they are resolved against the default environment and might produce
//    /// a slightly different result at the destination if the source of drag
//    /// or copy uses a non-default environment.
//    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//    public static var transferRepresentation: some TransferRepresentation { get { return stubTransferRepresentation() } }
//
//    /// The type of the representation used to import and export the item.
//    ///
//    /// Swift infers this type from the return value of the
//    /// ``transferRepresentation`` property.
//    //public typealias Representation = Never // some TransferRepresentation
//}
//#endif

//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension Color.Resolved : Animatable {
//
//    /// The type defining the data to animate.
//    public typealias AnimatableData = AnimatablePair<Float, AnimatablePair<Float, AnimatablePair<Float, Float>>>
//
//    /// The data to animate.
//    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }
//}

//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension Color.Resolved : Codable {
//
//    /// Encodes this value into the given encoder.
//    ///
//    /// If the value fails to encode anything, `encoder` will encode an empty
//    /// keyed container in its place.
//    ///
//    /// This function throws an error if any values are invalid for the given
//    /// encoder's format.
//    ///
//    /// - Parameter encoder: The encoder to write data to.
//    public func encode(to encoder: Encoder) throws { fatalError() }
//
//    /// Creates a new instance by decoding from the given decoder.
//    ///
//    /// This initializer throws an error if reading from the decoder fails, or
//    /// if the data read is corrupted or otherwise invalid.
//    ///
//    /// - Parameter decoder: The decoder to read data from.
//    public init(from decoder: Decoder) throws { fatalError() }
//}

#endif
