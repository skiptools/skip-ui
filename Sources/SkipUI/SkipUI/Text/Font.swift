// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import android.graphics.Typeface
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.sp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

// SKIP @bridge
public struct Font : Hashable {
    #if SKIP
    public let fontImpl: @Composable () -> androidx.compose.ui.text.TextStyle

    public init(fontImpl: @Composable () -> androidx.compose.ui.text.TextStyle) {
        self.fontImpl = fontImpl
    }

    // M3: Default Font Size/Line Height
    // displayLarge: Roboto 57/64
    // displayMedium: Roboto 45/52
    // displaySmall: Roboto 36/44
    // headlineLarge: Roboto 32/40
    // headlineMedium: Roboto 28/36
    // headlineSmall: Roboto 24/32
    // titleLarge: New-Roboto Medium 22/28
    // titleMedium: Roboto Medium 16/24
    // titleSmall: Roboto Medium 14/20
    // bodyLarge: Roboto 16/24
    // bodyMedium: Roboto 14/20
    // bodySmall: Roboto 12/16
    // labelLarge: Roboto Medium 14/20
    // labelMedium: Roboto Medium 12/16
    // labelSmall: New Roboto Medium 11/16

    // manual offsets are applied to the default font sizes to get them to line up with SwiftUI default sizes; see TextTests.swift

    public static let largeTitle = Font(fontImpl: {
        adjust(MaterialTheme.typography.titleLarge, by: Float(+9.0 + 1.0))
    })

    public static let title = Font(fontImpl: {
        adjust(MaterialTheme.typography.headlineMedium, by: Float(-2.0))
    })

    public static let title2 = Font(fontImpl: {
        adjust(MaterialTheme.typography.headlineSmall, by: Float(-5.0 + 1.0))
    })

    public static let title3 = Font(fontImpl: {
        adjust(MaterialTheme.typography.headlineSmall, by: Float(-6.0))
    })

    public static let headline = Font(fontImpl: {
        adjust(MaterialTheme.typography.titleMedium, by: Float(0.0))
    })

    public static let subheadline = Font(fontImpl: {
        adjust(MaterialTheme.typography.titleSmall, by: Float(0.0))
    })

    public static let body = Font(fontImpl: {
        adjust(MaterialTheme.typography.bodyLarge, by: Float(0.0))
    })

    public static let callout = Font(fontImpl:  {
        adjust(MaterialTheme.typography.bodyMedium, by: Float(+1.0))
    })

    public static let footnote = Font(fontImpl: {
        adjust(MaterialTheme.typography.bodySmall, by: Float(+0.0))
    })

    public static let caption = Font(fontImpl: {
        adjust(MaterialTheme.typography.bodySmall, by: Float(-0.75))
    })

    public static let caption2 = Font(fontImpl:  {
        adjust(MaterialTheme.typography.bodySmall, by: Float(-1.0))
    })

    private static func adjust(_ style: androidx.compose.ui.text.TextStyle, by amount: Float) -> androidx.compose.ui.text.TextStyle {
        guard amount != Float(0.0) else {
            return style
        }
        let fontSize = (style.fontSize.value + amount).sp
        let lineHeight = style.lineHeight == TextUnit.Unspecified ? style.lineHeight : (style.lineHeight.value + amount).sp
        return style.copy(fontSize: fontSize, lineHeight: lineHeight)
    }
    #endif

    public enum TextStyle : Int, CaseIterable, Codable, Hashable {
        case largeTitle = 0 // For bridging
        case title = 1 // For bridging
        case title2 = 2 // For bridging
        case title3 = 3 // For bridging
        case headline = 4 // For bridging
        case subheadline = 5 // For bridging
        case body = 6 // For bridging
        case callout = 7 // For bridging
        case footnote = 8 // For bridging
        case caption = 9 // For bridging
        case caption2 = 10 // For bridging
    }

    public static func system(_ style: Font.TextStyle, design: Font.Design? = nil, weight: Font.Weight? = nil) -> Font {
        #if SKIP
        let font: Font
        switch style {
        case .largeTitle:
            font = .largeTitle
        case .title:
            font = .title
        case .title2:
            font = .title2
        case .title3:
            font = .title3
        case .headline:
            font = .headline
        case .subheadline:
            font = .subheadline
        case .body:
            font = .body
        case .callout:
            font = .callout
        case .footnote:
            font = .footnote
        case .caption:
            font = .caption
        case .caption2:
            font = .caption2
        }
        guard weight != nil || design != nil else {
            return font
        }
        return Font(fontImpl: {
            font.fontImpl().copy(fontWeight: fontWeight(for: weight), fontFamily: fontFamily(for: design))
        })
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public static func system(bridgedStyle: Int, bridgedDesign: Int?, bridgedWeight: Int?) -> Font {
        let style = Font.TextStyle(rawValue: bridgedStyle) ?? .body
        let design = bridgedDesign == nil ? nil : Font.Design(rawValue: bridgedDesign!)
        let weight = bridgedWeight == nil ? nil : Font.Weight(value: bridgedWeight!)
        return system(style, design: design, weight: weight)
    }

    public static func system(size: CGFloat, weight: Font.Weight? = nil, design: Font.Design? = nil) -> Font {
        #if SKIP
        return Font(fontImpl: {
            androidx.compose.ui.text.TextStyle(fontSize: size.sp, fontWeight: fontWeight(for: weight), fontFamily: fontFamily(for: design))
        })
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public static func system(size: CGFloat, bridgedDesign: Int?, bridgedWeight: Int?) -> Font {
        let design = bridgedDesign == nil ? nil : Font.Design(rawValue: bridgedDesign!)
        let weight = bridgedWeight == nil ? nil : Font.Weight(value: bridgedWeight!)
        return system(size: size, weight: weight, design: design)
    }

    #if SKIP
    // Cache is used not only to avoid expense of recreating font families, but also because recreated families for
    // the same name do not compare equal, causing recompositions under some configs:
    // https://github.com/skiptools/skip/issues/399
    private static var fontFamilyCache: [String: FontFamily] = [:]

    private static func findNamedFont(_ fontName: String, ctx: android.content.Context) -> FontFamily? {
        var fontFamily: FontFamily? = nil
        synchronized(fontFamilyCache) {
            fontFamily = fontFamilyCache[fontName]
        }
        guard fontFamily == nil else {
            return fontFamily
        }

        // Android font names are lowercased and separated by "_" characters, since Android resource names can take only alphanumeric characters.
        // Font lookups on Android reference the font's filename, whereas SwiftUI references the font's Postscript name
        // So the best way to have the same font lookup code work on both platforms is to name the
        // font with PS name "Some Poscript Font-Bold" as "some_postscript_font_bold.ttf", and then both iOS and Android
        // can reference it by the postscript name
        let name = fontName.lowercased().replace(" ", "_").replace("-", "_")

        //android.util.Log.i("SkipUI", "finding font: \(name)")

        // look up the font in the resource bundle for custom embedded fonts
        let fid = ctx.resources.getIdentifier(name, "font", ctx.packageName)
        if fid == 0 {
            // try to fall back on system installed fonts like "courier"
            if let typeface = Typeface.create(name, Typeface.NORMAL) {
                //android.util.Log.i("SkipUI", "found font: \(typeface)")
                fontFamily = FontFamily(typeface)
            } else {
                android.util.Log.w("SkipUI", "unable to find font named: \(fontName) (\(name))")
            }
        } else if let customTypeface = ctx.resources.getFont(fid) {
            fontFamily = FontFamily(customTypeface)
        } else {
            android.util.Log.w("SkipUI", "unable to find font named: \(name)")
        }
        if let fontFamily {
            synchronized(fontFamilyCache) {
                fontFamilyCache[fontName] = fontFamily
            }
        }
        return fontFamily
    }
    #endif

    // SKIP @bridge
    public static func custom(_ name: String, size: CGFloat) -> Font {
        #if SKIP
        return Font(fontImpl: {
            androidx.compose.ui.text.TextStyle(fontFamily: Self.findNamedFont(name, ctx: LocalContext.current), fontSize: size.sp)
        })
        #else
        fatalError()
        #endif
    }

    public static func custom(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
        #if SKIP
        let systemFont = system(textStyle)
        return Font(fontImpl: {
            let absoluteSize = systemFont.fontImpl().fontSize.value + size
            androidx.compose.ui.text.TextStyle(fontFamily: Self.findNamedFont(name, ctx: LocalContext.current), fontSize: absoluteSize.sp)
        })
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public static func custom(_ name: String, size: CGFloat, bridgedRelativeTo textStyle: Int) -> Font {
        return custom(name, size: size, relativeTo: Font.TextStyle(rawValue: textStyle) ?? .body)
    }

    // SKIP @bridge
    public static func custom(_ name: String, fixedSize: CGFloat, unusedp: Any? = nil) -> Font {
        return Font.custom(name, size: fixedSize)
    }

    @available(*, unavailable)
    public static var `default`: Font {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ font: Any /* CTFont */) {
        #if SKIP
        fontImpl = { MaterialTheme.typography.bodyMedium }
        #endif
    }

    // SKIP @bridge
    public func italic(_ isActive: Bool = true) -> Font {
        #if SKIP
        return Font(fontImpl: {
            fontImpl().copy(fontStyle: isActive ?  androidx.compose.ui.text.font.FontStyle.Italic : androidx.compose.ui.text.font.FontStyle.Normal)
        })
        #else
        fatalError()
        #endif
    }

    @available(*, unavailable)
    public func smallCaps(_ isActive: Bool = true) -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func lowercaseSmallCaps(_ isActive: Bool = true) -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func uppercaseSmallCaps(_ isActive: Bool = true) -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func monospacedDigit(_ isActive: Bool = true) -> Font {
        fatalError()
    }

    public func weight(_ weight: Font.Weight) -> Font {
        #if SKIP
        return Font(fontImpl: {
            fontImpl().copy(fontWeight: Self.fontWeight(for: weight))
        })
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public func weight(bridgedWeight: Int) -> Font {
        return weight(Font.Weight(value: bridgedWeight))
    }

    #if SKIP
    private static func fontWeight(for weight: Font.Weight?) -> FontWeight? {
        switch weight {
        case nil:
            return nil
        case .ultraLight:
            return FontWeight.Thin
        case .thin:
            return FontWeight.ExtraLight
        case .light:
            return FontWeight.Light
        case .regular:
            return FontWeight.Normal
        case .medium:
            return FontWeight.Medium
        case .semibold:
            return FontWeight.SemiBold
        case .bold:
            return FontWeight.Bold
        case .heavy:
            return FontWeight.ExtraBold
        case .black:
            return FontWeight.Black
        default:
            return FontWeight.Normal
        }
    }
    #endif

    @available(*, unavailable)
    public func width(_ width: Font.Width) -> Font {
        fatalError()
    }

    public func bold(_ isActive: Bool = true) -> Font {
        return weight(isActive ? Weight.bold : Weight.regular)
    }

    public func monospaced(_ isActive: Bool = true) -> Font {
        return design(isActive ? Design.monospaced : Design.default)
    }

    public func design(_ design: Design?) -> Font {
        #if SKIP
        return Font(fontImpl: {
            fontImpl().copy(fontFamily: Self.fontFamily(for: design))
        })
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public func design(bridgedValue: Int) -> Font {
        return design(Design(rawValue: bridgedValue))
    }

    @available(*, unavailable)
    public func leading(_ leading: Font.Leading) -> Font {
        fatalError()
    }

    // SKIP @bridge
    public func pointSize(_ size: CGFloat) -> Font {
        #if SKIP
        return Font(fontImpl: {
            fontImpl().copy(fontSize: size.sp)
        })
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public func scaledBy(_ factor: CGFloat) -> Font {
        #if SKIP
        return Font(fontImpl: {
            let textStyle = fontImpl()
            let pointSize = textStyle.fontSize.value * factor
            return textStyle.copy(fontSize: pointSize.sp)
        })
        #else
        fatalError()
        #endif
    }

    @available(*, unavailable)
    public func resolve(in context: Font.Context) -> Font.Resolved {
        fatalError()
    }

    public struct Context : Hashable, CustomDebugStringConvertible {
        public var debugDescription: String {
            return "Font.Context"
        }
    }

    public struct Resolved : Hashable {
        public let ctFont: Int /* CTFont */
        public let isBold: Bool
        public let isItalic: Bool
        public let pointSize: CGFloat
        public let weight: Font.Weight
        public let width: Font.Width
        public let leading: Font.Leading
        public let isMonospaced: Bool
        public let isLowercaseSmallCaps: Bool
        public let isUppercaseSmallCaps: Bool
        public let isSmallCaps: Bool
    }

    public struct Weight : Hashable {
        let value: Int
        public static let ultraLight = Weight(value: -3) // For bridging (-0.8)
        public static let thin = Weight(value: -2) // For bridging (-0.6)
        public static let light = Weight(value: -1) // For bridging (-0.4)
        public static let regular = Weight(value: 0) // For bridging (0.0)
        public static let medium = Weight(value: 1) // For bridging (0.23)
        public static let semibold = Weight(value: 2) // For bridging (0.3)
        public static let bold = Weight(value: 3) // For bridging (0.4)
        public static let heavy = Weight(value: 4) // For bridging (0.56)
        public static let black = Weight(value: 5) // For bridging (0.62)
    }

    public struct Width : Hashable {
        public var value: CGFloat

        public init(_ value: CGFloat) {
            self.value = value
        }

        public static let compressed = Width(0.8)
        public static let condensed = Width(0.9)
        public static let standard = Width(1.0)
        public static let expanded = Width(1.2)
    }

    public enum Leading : Hashable {
        case standard
        case tight
        case loose
    }

    public enum Design : Int, Hashable {
        case `default` = 0 // For bridging
        case serif = 1 // For bridging
        case rounded = 2 // For bridging
        case monospaced = 3 // For bridging
    }

    #if SKIP
    private static func fontFamily(for design: Design?) -> FontFamily? {
        switch design {
        case nil:
            return nil
        case .default:
            return FontFamily.Default
        case .serif:
            return FontFamily.Serif
        case .rounded:
            return FontFamily.Cursive
        case .monospaced:
            return FontFamily.Monospace
        }
    }
    #endif
}

public enum LegibilityWeight : Hashable {
    case regular
    case bold
}

#if !SKIP

// Unneeded stubs:

//@propertyWrapper public struct ScaledMetric<Value> : DynamicProperty where Value : BinaryFloatingPoint {
//    public init(wrappedValue: Value, relativeTo textStyle: Font.TextStyle) { fatalError() }
//    public init(wrappedValue: Value) { fatalError() }
//    public var wrappedValue: Value { get { fatalError() } }
//}

#endif
#endif
