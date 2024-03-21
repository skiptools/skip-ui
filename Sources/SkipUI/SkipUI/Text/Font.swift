// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import android.content.Context
import android.graphics.Typeface
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
#else
import struct CoreGraphics.CGFloat
#endif

public struct Font : Hashable, Sendable {
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
        return amount == Float(0.0) ? style : style.copy(fontSize: (style.fontSize.value + amount).sp)
    }
    #endif

    public enum TextStyle : CaseIterable, Hashable, Sendable {
        case largeTitle
        case title
        case title2
        case title3
        case headline
        case subheadline
        case body
        case callout
        case footnote
        case caption
        case caption2
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

    public static func system(size: CGFloat, weight: Font.Weight? = nil, design: Font.Design? = nil) -> Font {
        #if SKIP
        return Font(fontImpl: {
            androidx.compose.ui.text.TextStyle(fontSize: size.sp, fontWeight: fontWeight(for: weight), fontFamily: fontFamily(for: design))
        })
        #else
        fatalError()
        #endif
    }

    #if SKIP
    private static func findNamedFont(_ fontName: String, ctx: Context) -> FontFamily? {
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
                return FontFamily(typeface)
            }

            android.util.Log.w("SkipUI", "unable to find font named: \(fontName) (\(name))")
            return nil
        }

        if let customTypeface = ctx.resources.getFont(fid) {
            return FontFamily(customTypeface)
        }

        android.util.Log.w("SkipUI", "unable to find font named: \(name)")
        return nil
    }
    #endif

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

    public static func custom(_ name: String, fixedSize: CGFloat) -> Font {
        return Font.custom(name, size: fixedSize)
    }

    @available(*, unavailable)
    public init(_ font: Any /* CTFont */) {
        #if SKIP
        fontImpl = { MaterialTheme.typography.bodyMedium }
        #endif
    }

    public func italic() -> Font {
        #if SKIP
        return Font(fontImpl: {
            fontImpl().copy(fontStyle: androidx.compose.ui.text.font.FontStyle.Italic)
        })
        #else
        fatalError()
        #endif
    }

    @available(*, unavailable)
    public func smallCaps() -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func lowercaseSmallCaps() -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func uppercaseSmallCaps() -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func monospacedDigit() -> Font {
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

    public func bold() -> Font {
        return weight(Weight.bold)
    }

    public func monospaced() -> Font {
        return design(Design.monospaced)
    }

    func design(_ design: Design?) -> Font {
        #if SKIP
        return Font(fontImpl: {
            fontImpl().copy(fontFamily: Self.fontFamily(for: Design.monospaced))
        })
        #else
        fatalError()
        #endif
    }

    @available(*, unavailable)
    public func leading(_ leading: Font.Leading) -> Font {
        fatalError()
    }

    public struct Weight : Hashable, Sendable {
        let value: Double
        public static let ultraLight = Weight(value: -0.8)
        public static let thin = Weight(value: -0.6)
        public static let light = Weight(value: -0.4)
        public static let regular = Weight(value: 0.0)
        public static let medium = Weight(value: 0.23)
        public static let semibold = Weight(value: 0.3)
        public static let bold = Weight(value: 0.4)
        public static let heavy = Weight(value: 0.56)
        public static let black = Weight(value: 0.62)
    }

    public struct Width : Hashable, Sendable {
        public var value: CGFloat

        public init(_ value: CGFloat) {
            self.value = value
        }

        public static let compressed = Width(0.8)
        public static let condensed = Width(0.9)
        public static let standard = Width(1.0)
        public static let expanded = Width(1.2)
    }

    public enum Leading : Hashable, Sendable {
        case standard
        case tight
        case loose
    }

    public enum Design : Hashable, Sendable {
        case `default`
        case serif
        case rounded
        case monospaced
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

public enum LegibilityWeight : Hashable, Sendable {
    case regular
    case bold
}

public struct RedactionReasons : OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let placeholder = RedactionReasons(rawValue: 1 << 0)
    public static let privacy = RedactionReasons(rawValue: 1 << 1)
    public static let invalidated = RedactionReasons(rawValue: 1 << 2)
}

#if !SKIP

// Unneeded stubs:

//@propertyWrapper public struct ScaledMetric<Value> : DynamicProperty where Value : BinaryFloatingPoint {
//    public init(wrappedValue: Value, relativeTo textStyle: Font.TextStyle) { fatalError() }
//    public init(wrappedValue: Value) { fatalError() }
//    public var wrappedValue: Value { get { fatalError() } }
//}

#endif
