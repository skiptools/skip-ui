// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Box
import androidx.compose.material.ContentAlpha
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.surfaceColorAtElevation
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
#endif

public struct Color: ShapeStyle, Hashable, Sendable {
    #if SKIP
    public let colorImpl: @Composable () -> androidx.compose.ui.graphics.Color

    public init(colorImpl: @Composable () -> androidx.compose.ui.graphics.Color) {
        self.colorImpl = colorImpl
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        let animatable = colorImpl().asAnimatable(context: context)
        let modifier = context.modifier.background(animatable.value).fillSize()
        Box(modifier: modifier)
    }

    /// Return the equivalent Compose color.
    @Composable public func asComposeColor() -> androidx.compose.ui.graphics.Color {
        return colorImpl()
    }

    // MARK: - ShapeStyle

    @Composable override func asColor(opacity: Double, animationContext: ComposeContext?) -> androidx.compose.ui.graphics.Color? {
        let color = self.opacity(opacity).colorImpl()
        if let animationContext {
            return color.asAnimatable(context: animationContext).value
        } else {
            return color
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif

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

    // MARK: -

    public enum RGBColorSpace : Hashable, Sendable {
        case sRGB
        case sRGBLinear
        case displayP3
    }

    public init(red: Double, green: Double, blue: Double, opacity: Double = 1.0) {
        #if SKIP
        colorImpl = { androidx.compose.ui.graphics.Color(red: Self.clamp(red), green: Self.clamp(green), blue: Self.clamp(blue), alpha = Self.clamp(opacity)) }
        #endif
    }

    public init(_ colorSpace: Color.RGBColorSpace, red: Double, green: Double, blue: Double, opacity: Double = 1.0) {
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }

    public init(white: Double, opacity: Double = 1.0) {
        self.init(red: white, green: white, blue: white, opacity: opacity)
    }

    public init(_ colorSpace: Color.RGBColorSpace, white: Double, opacity: Double = 1.0) {
        self.init(white: white, opacity: opacity)
    }

    public init(hue: Double, saturation: Double, brightness: Double, opacity: Double = 1.0) {
        #if SKIP
        colorImpl = { androidx.compose.ui.graphics.Color.hsv(hue: Self.clamp(hue) * 360, saturation: Self.clamp(saturation), value: Self.clamp(brightness), alpha: Self.clamp(opacity)) }
        #endif
    }

    public init(_ color: UIColor) {
        self.init(red: color.red, green: color.green, blue: color.blue, opacity: color.alpha)
    }

    public init(uiColor color: UIColor) {
        self.init(red: color.red, green: color.green, blue: color.blue, opacity: color.alpha)
    }

    public init(_ name: String, bundle: Bundle? = nil) {
        #if SKIP
        let assetColorInfo: AssetColorInfo? = rememberCachedAsset(namedColorCache, AssetKey(name: name, bundle: bundle)) { _ in
            assetColorInfo(name: name, bundle: bundle ?? Bundle.main)
        }
        colorImpl = { assetColorInfo?.colorImpl() ?? Color.gray.colorImpl() }
        #endif
    }

    private static func clamp(_ value: Double) -> Float {
        return max(Float(0.0), min(Float(1.0), Float(value)))
    }

    // MARK: -

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

    // MARK: -

    public static var accentColor: Color {
        #if SKIP
        return Color(colorImpl: { MaterialTheme.colorScheme.primary })
        #else
        fatalError()
        #endif
    }

    #if SKIP
    @Composable static func assetAccentColor(colorScheme: ColorScheme) -> androidx.compose.ui.graphics.Color? {
        let name = "AccentColor"
        let colorInfo = rememberCachedAsset(namedColorCache, AssetKey(name: name, bundle: Bundle.main)) { _ in
            assetColorInfo(name: name, bundle: Bundle.main)
        }
        return colorInfo?.colorImpl(colorScheme: colorScheme)
    }

    static let background = Color(colorImpl: {
        MaterialTheme.colorScheme.surface
    })

    /// Matches Android's default bottom bar color.
    static let systemBarBackground: Color = Color(colorImpl: {
        MaterialTheme.colorScheme.surfaceColorAtElevation(3.dp)
    })

    /// Use for e.g. grouped table backgrounds, etc.
    static let systemBackground: Color = systemBarBackground

    /// Use for overlays like alerts and action sheets.
    static let overlayBackground: Color = Color(colorImpl: {
        MaterialTheme.colorScheme.surface.copy(alpha: Float(0.9))
    })

    /// Use for separators, etc.
    static var separator: Color = Color(colorImpl: {
        MaterialTheme.colorScheme.surfaceColorAtElevation(3.dp)
    })

    /// Use for placeholder content.
    static let placeholderOpacity = 0.2

    /// Use for placeholder content.
    static var placeholder: Color {
        _primary.opacity(placeholderOpacity)
    }

    fileprivate static let _primary = Color(colorImpl: {
        MaterialTheme.colorScheme.onBackground
    })
    fileprivate static let _secondary = Color(colorImpl: {
        MaterialTheme.colorScheme.onBackground.copy(alpha: ContentAlpha.medium)
    })
    fileprivate static let _clear = Color(colorImpl: {
        androidx.compose.ui.graphics.Color.Transparent
    })
    fileprivate static let _white = Color(colorImpl: {
        androidx.compose.ui.graphics.Color.White
    })
    fileprivate static let _black = Color(colorImpl: {
        androidx.compose.ui.graphics.Color.Black
    })
    fileprivate static let _gray = Color(colorImpl: {
        ComposeColor(light: 0xFF8E8E93, dark: 0xFF8E8E93)
    })
    fileprivate static let _red = Color(colorImpl: {
        ComposeColor(light: 0xFFFF3B30, dark: 0xFFFF453A)
    })
    fileprivate static let _orange = Color(colorImpl: {
        ComposeColor(light: 0xFFFF9500, dark: 0xFFFF9F0A)
    })
    fileprivate static let _yellow = Color(colorImpl: {
        ComposeColor(light: 0xFFFFCC00, dark: 0xFFFFD60A)
    })
    fileprivate static let _green = Color(colorImpl: {
        ComposeColor(light: 0xFF34C759, dark: 0xFF30D158)
    })
    fileprivate static let _mint = Color(colorImpl: {
        ComposeColor(light: 0xFF00C7BE, dark: 0xFF63E6E2)
    })
    fileprivate static let _teal = Color(colorImpl: {
        ComposeColor(light: 0xFF30B0C7, dark: 0xFF40C8E0)
    })
    fileprivate static let _cyan = Color(colorImpl: {
        ComposeColor(light: 0xFF32ADE6, dark: 0xFF64D2FF)
    })
    fileprivate static let _blue = Color(colorImpl: {
        ComposeColor(light: 0xFF007AFF, dark: 0xFF0A84FF)
    })
    fileprivate static let _indigo = Color(colorImpl: {
        ComposeColor(light: 0xFF5856D6, dark: 0xFF5E5CE6)
    })
    fileprivate static let _purple = Color(colorImpl: {
        ComposeColor(light: 0xFFAF52DE, dark: 0xFFBF5AF2)
    })
    fileprivate static let _pink = Color(colorImpl: {
        ComposeColor(light: 0xFFFF2D55, dark: 0xFFFF375F)
    })
    fileprivate static let _brown = Color(colorImpl: {
        ComposeColor(light: 0xFFA2845E, dark: 0xFFAC8E68)
    })
    #endif

    // MARK: -

    public func opacity(_ opacity: Double) -> Color {
        #if SKIP
        guard opacity != 1.0 else {
            return self
        }
        return Color(colorImpl: {
            let color = colorImpl()
            return color.copy(alpha: color.alpha * Float(opacity))
        })
        #else
        return self
        #endif
    }

    public var gradient: AnyGradient {
        #if SKIP
        // Create a SwiftUI-like gradient by varying the saturation of this color
        let startColorImpl: @Composable () -> androidx.compose.ui.graphics.Color = {
            let color = colorImpl()
            let hsv = FloatArray(3)
            android.graphics.Color.RGBToHSV(Int(color.red * 255), Int(color.green * 255), Int(color.blue * 255), hsv)
            androidx.compose.ui.graphics.Color.hsv(hsv[0], hsv[1] * Float(0.75), hsv[2], alpha: color.alpha)
        }
        let endColorImpl: @Composable () -> androidx.compose.ui.graphics.Color = {
            let color = colorImpl()
            let hsv = FloatArray(3)
            android.graphics.Color.RGBToHSV(Int(color.red * 255), Int(color.green * 255), Int(color.blue * 255), hsv)
            androidx.compose.ui.graphics.Color.hsv(hsv[0], min(Float(1.0), hsv[1] * (Float(1.0) / Float(0.75))), hsv[2], alpha: color.alpha)
        }
        return AnyGradient(gradient = Gradient(colors: [Color(colorImpl: startColorImpl), Color(colorImpl: endColorImpl)]))
        #else
        fatalError()
        #endif
    }
}

#if SKIP
/// Returns the given color value based on whether the view is in dark mode or light mode.
@Composable private func ComposeColor(light: Int64, dark: Int64) -> androidx.compose.ui.graphics.Color {
    // TODO: EnvironmentValues.shared.colorMode == .dark ? dark : light
    androidx.compose.ui.graphics.Color(isSystemInDarkTheme() ? dark : light)
}
#endif

extension ShapeStyle where Self == Color {
    public static var primary: Color {
        #if SKIP
        Color._primary
        #else
        Color(white: 1.0)
        #endif
    }
    public static var secondary: Color {
        #if SKIP
        Color._secondary
        #else
        Color(white: 1.0)
        #endif
    }
    public static var clear: Color {
        #if SKIP
        Color._clear
        #else
        Color(white: 1.0)
        #endif
    }
    public static var white: Color {
        #if SKIP
        Color._white
        #else
        Color(white: 1.0)
        #endif
    }
    public static var black: Color {
        #if SKIP
        Color._black
        #else
        Color(white: 1.0)
        #endif
    }
    public static var gray: Color {
        #if SKIP
        Color._gray
        #else
        Color(white: 1.0)
        #endif
    }
    public static var red: Color {
        #if SKIP
        Color._red
        #else
        Color(white: 1.0)
        #endif
    }
    public static var orange: Color {
        #if SKIP
        Color._orange
        #else
        Color(white: 1.0)
        #endif
    }
    public static var yellow: Color {
        #if SKIP
        Color._yellow
        #else
        Color(white: 1.0)
        #endif
    }
    public static var green: Color {
        #if SKIP
        Color._green
        #else
        Color(white: 1.0)
        #endif
    }
    public static var mint: Color {
        #if SKIP
        Color._mint
        #else
        Color(white: 1.0)
        #endif
    }
    public static var teal: Color {
        #if SKIP
        Color._teal
        #else
        Color(white: 1.0)
        #endif
    }
    public static var cyan: Color {
        #if SKIP
        Color._cyan
        #else
        Color(white: 1.0)
        #endif
    }
    public static var blue: Color {
        #if SKIP
        Color._blue
        #else
        Color(white: 1.0)
        #endif
    }
    public static var indigo: Color {
        #if SKIP
        Color._indigo
        #else
        Color(white: 1.0)
        #endif
    }
    public static var purple: Color {
        #if SKIP
        Color._purple
        #else
        Color(white: 1.0)
        #endif
    }
    public static var pink: Color {
        #if SKIP
        Color._pink
        #else
        Color(white: 1.0)
        #endif
    }
    public static var brown: Color {
        #if SKIP
        Color._brown
        #else
        Color(white: 1.0)
        #endif
    }
}

#if SKIP

private let namedColorCache: [AssetKey: AssetColorInfo?] = [:]

private struct AssetColorInfo {
    let light: ColorSet.ColorSpec?
    let dark: ColorSet.ColorSpec?

    /// The `ColorSet` that was loaded for the given info.
    let colorSet: ColorSet

    @Composable func colorImpl(colorScheme: ColorScheme? = nil) -> androidx.compose.ui.graphics.Color? {
        let colorScheme = colorScheme ?? EnvironmentValues.shared.colorScheme
        var color: androidx.compose.ui.graphics.Color? = nil
        if colorScheme == .dark, let dark {
            return dark.colorImpl()
        } else {
            return light?.colorImpl()
        }
    }
}

private func assetColorInfo(name: String, bundle: Bundle) -> AssetColorInfo? {
    for dataURL in assetContentsURLs(name: "\(name).colorset", bundle: bundle) {
        do {
            let data = try Data(contentsOf: dataURL)
            logger.debug("loading colorset asset contents from: \(dataURL)")
            let colorSet = try JSONDecoder().decode(ColorSet.self, from: data)
            let lightColor = colorSet.colors.sortedByAssetFit(colorScheme: ColorScheme.light).compactMap { $0.color }.last
            let darkColor = colorSet.colors.sortedByAssetFit(colorScheme: ColorScheme.dark).compactMap { $0.color }.last
            return AssetColorInfo(light: lightColor, dark: darkColor, colorSet: colorSet)
        } catch {
            logger.warning("error loading color data from \(name): \(error)")
        }
    }
    return nil
}

/* The `Contents.json` in a `*.colorset` folder for a symbol
 https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/Named_Color.html
 {
   "colors" : [
     {
       "color" : {
         "platform" : "universal",
         "reference" : "systemBlueColor"
       },
       "idiom" : "universal"
     }
   ],
   "info" : {
     "author" : "xcode",
     "version" : 1
   }
 }
 */
private struct ColorSet : Decodable {
    let colors: [ColorInfo]
    let info: AssetContentsInfo

    struct ColorInfo : Decodable, AssetSortable {
        let color: ColorSpec?
        let idiom: String? // e.g. "universal"
        let appearances: [AssetAppearance]?
    }

    struct ColorSpec : Decodable {
        let platform: String? // e.g. "ios"
        let reference: String? // e.g. "systemBlueColor"
        let components: ColorComponents?

        @Composable func colorImpl() -> androidx.compose.ui.graphics.Color? {
            if let components {
                return components.color.colorImpl()
            }
            switch reference {
            case "labelColor":
                return Color.primary.colorImpl()
            case "secondaryLabelColor":
                return Color.secondary.colorImpl()
            case "systemBlueColor":
                return Color.blue.colorImpl()
            case "systemBrownColor":
                return Color.brown.colorImpl()
            case "systemCyanColor":
                return Color.cyan.colorImpl()
            case "systemGrayColor":
                return Color.gray.colorImpl()
            case "systemGreenColor":
                return Color.green.colorImpl()
            case "systemIndigoColor":
                return Color.indigo.colorImpl()
            case "systemMintColor":
                return Color.mint.colorImpl()
            case "systemOrangeColor":
                return Color.orange.colorImpl()
            case "systemPinkColor":
                return Color.pink.colorImpl()
            case "systemPurpleColor":
                return Color.purple.colorImpl()
            case "systemRedColor":
                return Color.red.colorImpl()
            case "systemTealColor":
                return Color.teal.colorImpl()
            case "systemYellowColor":
                return Color.yellow.colorImpl()
            default:
                return nil
            }
        }
    }

    struct ColorComponents : Decodable {
        let red: String?
        let green: String?
        let blue: String?
        let alpha: String?

        var color: Color {
            let redValue = Double(red ?? "") ?? 0.0
            let greenValue = Double(green ?? "") ?? 0.0
            let blueValue = Double(blue ?? "") ?? 0.0
            let alphaValue = Double(alpha ?? "") ?? 1.0
            return Color(red: redValue, green: greenValue, blue: blueValue, opacity: alphaValue)
        }
    }
}

#endif

#if !SKIP

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
//    public var animatableData: AnimatableData { get { fatalError() } set { } }
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
