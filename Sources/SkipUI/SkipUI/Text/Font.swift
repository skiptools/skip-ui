// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import struct CoreGraphics.CGFloat
#endif

// SKIP INSERT: import androidx.compose.runtime.Composable

public struct Font : Hashable, Sendable {
    #if SKIP
    let fontImpl: @Composable () -> androidx.compose.ui.text.TextStyle

    init(fontImpl: @Composable () -> androidx.compose.ui.text.TextStyle) {
        self.fontImpl = fontImpl
    }
    #endif
}

extension Font {
    #if SKIP
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

    public static let largeTitle = Font(fontImpl: {
        androidx.compose.material3.MaterialTheme.typography.displaySmall
    })

    public static let title = Font(fontImpl: {
        androidx.compose.material3.MaterialTheme.typography.titleLarge
    })

    public static let title2 = Font(fontImpl: {
        androidx.compose.material3.MaterialTheme.typography.titleMedium
    })

    public static let title3 = Font(fontImpl: {
        androidx.compose.material3.MaterialTheme.typography.titleSmall
    })

    public static let headline = Font(fontImpl: {
        androidx.compose.material3.MaterialTheme.typography.headlineSmall
    })

    public static let subheadline = Font(fontImpl: {
        androidx.compose.material3.MaterialTheme.typography.bodyLarge
    })

    public static let body = Font(fontImpl: {
        androidx.compose.material3.MaterialTheme.typography.bodyMedium
    })

    public static let callout = Font(fontImpl:  {
        androidx.compose.material3.MaterialTheme.typography.bodySmall
    })

    public static let footnote = Font(fontImpl: {
        androidx.compose.material3.MaterialTheme.typography.labelSmall
    })

    public static let caption = Font(fontImpl: {
        androidx.compose.material3.MaterialTheme.typography.labelMedium
    })

    public static let caption2 = Font(fontImpl:  {
        androidx.compose.material3.MaterialTheme.typography.labelSmall
    })
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

    public static func system(_ style: Font.TextStyle) -> Font {
        #if SKIP
        switch style {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .subheadline:
            return .subheadline
        case .body:
            return .body
        case .callout:
            return .callout
        case .footnote:
            return .footnote
        case .caption:
            return .caption
        case .caption2:
            return .caption2
        }
        #else
        fatalError()
        #endif
    }

    @available(*, unavailable)
    public static func system(_ style: Font.TextStyle, design: Font.Design?) -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public static func system(_ style: Font.TextStyle, design: Font.Design? = nil, weight: Font.Weight?) -> Font {
        fatalError()
    }
}

extension Font {
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
            switch weight {
            case .ultraLight:
                return fontImpl().copy(fontWeight: androidx.compose.ui.text.font.FontWeight.Thin)
            case .thin:
                return fontImpl().copy(fontWeight: androidx.compose.ui.text.font.FontWeight.ExtraLight)
            case .light:
                return fontImpl().copy(fontWeight: androidx.compose.ui.text.font.FontWeight.Light)
            case .regular:
                return fontImpl().copy(fontWeight: androidx.compose.ui.text.font.FontWeight.Normal)
            case .medium:
                return fontImpl().copy(fontWeight: androidx.compose.ui.text.font.FontWeight.Medium)
            case .semibold:
                return fontImpl().copy(fontWeight: androidx.compose.ui.text.font.FontWeight.SemiBold)
            case .bold:
                return fontImpl().copy(fontWeight: androidx.compose.ui.text.font.FontWeight.Bold)
            case .heavy:
                return fontImpl().copy(fontWeight: androidx.compose.ui.text.font.FontWeight.ExtraBold)
            case .black:
                return fontImpl().copy(fontWeight: androidx.compose.ui.text.font.FontWeight.Black)
            default:
                return fontImpl().copy(fontWeight: androidx.compose.ui.text.font.FontWeight.Normal)
            }
        })
        #else
        fatalError()
        #endif
    }

    @available(*, unavailable)
    public func width(_ width: Font.Width) -> Font {
        fatalError()
    }

    public func bold() -> Font {
        return weight(.bold)
    }

    @available(*, unavailable)
    public func monospaced() -> Font {
        fatalError()
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

        // TODO: Real values
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
}

extension Font {
    @available(*, unavailable)
    public static func system(size: CGFloat, weight: Font.Weight? = nil, design: Font.Design? = nil) -> Font {
        fatalError()
    }

    public enum Design : Hashable, Sendable {
        case `default`
        case serif
        case rounded
        case monospaced
    }
}

extension Font {
    public static func custom(_ name: String, size: CGFloat) -> Font {
        #if SKIP
        return Font(fontImpl: {
            // note that Android can find "courier" but not "Courier"
            androidx.compose.ui.text.TextStyle(fontFamily: androidx.compose.ui.text.font.FontFamily(android.graphics.Typeface.create(name, android.graphics.Typeface.NORMAL)), fontSize: androidx.compose.ui.unit.TextUnit(Float(size), androidx.compose.ui.unit.TextUnitType.Sp))
        })
        #else
        fatalError()
        #endif
    }

    public static func custom(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
        // TODO: handle textStyle
        return Font.custom(name, size: size)
    }

    public static func custom(_ name: String, fixedSize: CGFloat) -> Font {
        // TODO: handle fixed size (somehow)
        return Font.custom(name, size: fixedSize)
    }

    @available(*, unavailable)
    public init(_ font: Any /* CTFont */) {
        #if SKIP
        fontImpl = { androidx.compose.material3.MaterialTheme.typography.bodyMedium }
        #endif
    }
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
