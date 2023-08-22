// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
// SKIP INSERT: import androidx.compose.foundation.*
// SKIP INSERT: import androidx.compose.foundation.layout.*
// SKIP INSERT: import androidx.compose.material3.*
// SKIP INSERT: import androidx.compose.runtime.*
// SKIP INSERT: import androidx.compose.ui.*
// SKIP INSERT: import androidx.compose.ui.draw.*
// SKIP INSERT: import androidx.compose.ui.platform.*
// SKIP INSERT: import androidx.compose.ui.semantics.*
// SKIP INSERT: import androidx.compose.ui.text.*
// SKIP INSERT: import androidx.compose.ui.text.style.*
// SKIP INSERT: import androidx.compose.ui.unit.*

// MARK: - Font

extension View {
    /// Sets the font for this view.
    public func font(_ font: Font) -> some View {
        #if SKIP
        return ComposeContextView(self) {
            $0.font = font
        }
        #else
        return self.font(font.fontImpl)
        #endif
    }
}

#if !SKIP
typealias FontImpl = SwiftUI.Font
#endif

/// An environment-dependent font.
public struct Font : Hashable {
    var fontImpl: FontImpl

    init(font fontImpl: FontImpl) {
        self.fontImpl = fontImpl
    }
}

extension Font {
    /// A font with the large title text style.
    public static let largeTitle: Font = Font(font: FontImpl.largeTitle)

    /// A font with the title text style.
    public static let title: Font = Font(font: FontImpl.title)

    /// Create a font for second level hierarchical headings.
    public static let title2: Font = Font(font: FontImpl.title2)

    /// Create a font for third level hierarchical headings.
    public static let title3: Font = Font(font: FontImpl.title3)

    /// A font with the headline text style.
    public static let headline: Font = Font(font: FontImpl.headline)

    /// A font with the subheadline text style.
    public static let subheadline: Font = Font(font: FontImpl.subheadline)

    /// A font with the body text style.
    public static let body: Font = Font(font: FontImpl.body)

    /// A font with the callout text style.
    public static let callout: Font = Font(font: FontImpl.callout)

    /// A font with the footnote text style.
    public static let footnote: Font = Font(font: FontImpl.footnote)

    /// A font with the caption text style.
    public static let caption: Font = Font(font: FontImpl.caption)

    /// Create a font with the alternate caption text style.
    public static let caption2: Font = Font(font: FontImpl.caption2)

    /// Gets a system font that uses the specified style, design, and weight.
//    public static func system(_ style: Font.TextStyle, design: Font.Design? = nil, weight: Font.Weight? = nil) -> Font

    /// Gets a system font with the given text style and design.
//    public static func system(_ style: Font.TextStyle, design: Font.Design = .default) -> Font

    /// A dynamic text style to use for fonts.
    public enum TextStyle : CaseIterable, Sendable {
        /// The font style for large titles.
        case largeTitle

        /// The font used for first level hierarchical headings.
        case title

        /// The font used for second level hierarchical headings.
        case title2

        /// The font used for third level hierarchical headings.
        case title3

        /// The font used for headings.
        case headline

        /// The font used for subheadings.
        case subheadline

        /// The font used for body text.
        case body

        /// The font used for callouts.
        case callout

        /// The font used in footnotes.
        case footnote

        /// The font used for standard captions.
        case caption

        /// The font used for alternate captions.
        case caption2
    }
}

#if SKIP
struct FontImpl {
    /*
     Default typography scale for Material Design 3

     M3    Default Font Size/Line Height
     displayLarge    Roboto 57/64
     displayMedium    Roboto 45/52
     displaySmall    Roboto 36/44
     headlineLarge    Roboto 32/40
     headlineMedium    Roboto 28/36
     headlineSmall    Roboto 24/32
     titleLarge    New-Roboto Medium 22/28
     titleMedium    Roboto Medium 16/24
     titleSmall    Roboto Medium 14/20
     bodyLarge    Roboto 16/24
     bodyMedium    Roboto 14/20
     bodySmall    Roboto 12/16
     labelLarge    Roboto Medium 14/20
     labelMedium    Roboto Medium 12/16
     labelSmall    New Roboto Medium, 11/16
     */
    static let largeTitle = FontImpl { androidx.compose.material3.MaterialTheme.typography.displaySmall }
    static let title = FontImpl { androidx.compose.material3.MaterialTheme.typography.titleLarge }
    static let title2 = FontImpl { androidx.compose.material3.MaterialTheme.typography.titleMedium }
    static let title3 = FontImpl { androidx.compose.material3.MaterialTheme.typography.titleSmall }
    static let headline = FontImpl { androidx.compose.material3.MaterialTheme.typography.headlineSmall }
    static let subheadline = FontImpl { androidx.compose.material3.MaterialTheme.typography.bodyLarge }
    static let body = FontImpl { androidx.compose.material3.MaterialTheme.typography.bodyMedium }
    static let callout = FontImpl { androidx.compose.material3.MaterialTheme.typography.bodySmall }
    static let footnote = FontImpl { androidx.compose.material3.MaterialTheme.typography.displaySmall }
    static let caption = FontImpl { androidx.compose.material3.MaterialTheme.typography.labelMedium }
    static let caption2 = FontImpl { androidx.compose.material3.MaterialTheme.typography.labelSmall }

    let composeTextStyle: @Composable () -> androidx.compose.ui.text.TextStyle

    init(composeTextStyle: @Composable () -> androidx.compose.ui.text.TextStyle) {
        self.composeTextStyle = composeTextStyle
    }
}
#endif

extension Font {
    /// Create a custom font with the given `name` and `size` that scales with
    /// the body text style.
//    public static func custom(_ name: String, size: CGFloat) -> Font {

    /// Create a custom font with the given `name` and `size` that scales
    /// relative to the given `textStyle`.
//    public static func custom(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font

    /// Create a custom font with the given `name` and a fixed `size` that does
    /// not scale with Dynamic Type.
//    public static func custom(_ name: String, fixedSize: CGFloat) -> Font
}

extension Font {
    /// Specifies a system font to use, along with the style, weight, and any
    /// design parameters you want applied to the text.
//    public static func system(size: CGFloat, weight: Font.Weight? = nil, design: Font.Design? = nil) -> Font

    /// Specifies a system font to use, along with the style, weight, and any
    /// design parameters you want applied to the text.
//    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font

    /// A design to use for fonts.
    public enum Design : Hashable, Sendable {
        case `default`
        case serif
        case rounded
        case monospaced
    }
}

extension Font {
    /// Adds italics to the font.
//    public func italic() -> Font

    /// Adjusts the font to enable all small capitals.
//    public func smallCaps() -> Font

    /// Adjusts the font to enable lowercase small capitals.
//    public func lowercaseSmallCaps() -> Font

    /// Adjusts the font to enable uppercase small capitals.
//    public func uppercaseSmallCaps() -> Font

    /// Returns a modified font that uses fixed-width digits, while leaving
    /// other characters proportionally spaced.
//    public func monospacedDigit() -> Font

    /// Sets the weight of the font.
//    public func weight(_ weight: Font.Weight) -> Font

    /// Sets the width of the font.
//    public func width(_ width: Font.Width) -> Font

    /// Adds bold styling to the font.
//    public func bold() -> Font

    /// Returns a fixed-width font from the same family as the base font.
//    public func monospaced() -> Font

    /// Adjusts the line spacing of a font.
//    public func leading(_ leading: Font.Leading) -> Font

    /// A weight to use for fonts.
//    @frozen public struct Weight : Hashable {
//        public static let ultraLight: Font.Weight
//        public static let thin: Font.Weight
//        public static let light: Font.Weight
//        public static let regular: Font.Weight
//        public static let medium: Font.Weight
//        public static let semibold: Font.Weight
//        public static let bold: Font.Weight
//        public static let heavy: Font.Weight
//        public static let black: Font.Weight
//    }
//
//    /// A width to use for fonts that have multiple widths.
//    public struct Width : Hashable, Sendable {
//        public var value: CGFloat
//        public static let compressed: Font.Width
//        public static let condensed: Font.Width
//        public static let standard: Font.Width
//        public static let expanded: Font.Width
//        public init(_ value: CGFloat)
//    }
//
//    /// A line spacing adjustment that you can apply to a font.
//    public enum Leading : Sendable {
//        /// The font's default line spacing.
//        case standard
//
//        /// Reduced line spacing.
//        case tight
//
//        /// Increased line spacing.
//        case loose
//    }
}

// MARK: - Other modifiers
// https://developer.android.com/jetpack/compose/modifiers-list

#if SKIP
extension View {
    public func accessibilityIdentifier(_ identifier: String) -> some View {
        return ComposeContextView(self) {
            $0.modifier = $0.modifier.testTag(identifier)
        }
    }
}
#endif

#if SKIP
extension View {
    public func accessibilityLabel(_ label: Text) -> some View {
        return ComposeContextView(self) {
            $0.modifier = $0.modifier.semantics { contentDescription = label.text }
        }
    }

    public func accessibilityLabel(_ label: String) -> some View {
        return ComposeContextView(self) {
            $0.modifier = $0.modifier.semantics { contentDescription = label }
        }
    }
}
#endif

#if SKIP
extension View {
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        return ComposeContextView(self) {
            if let width {
                $0.modifier = $0.modifier.width(width.dp)
            }
            if let height {
                $0.modifier = $0.modifier.height(height.dp)
            }
        }
    }
}
#endif

#if SKIP
extension View {
    public func opacity(_ alpha: Double) -> some View {
        return ComposeContextView(self) {
            $0.modifier = $0.modifier.alpha(Float(alpha))
        }
    }
}
#endif

extension View {
    public func rotationEffect(_ angle: Angle) -> some View {
        #if SKIP
        return ComposeContextView(self) {
            $0.modifier = $0.modifier.rotate(Float(angle.degrees))
        }
        #else
        return self.rotationEffect(SwiftUI.Angle.radians(angle.radians))
        #endif
    }
}

public struct Angle {
    public var radians: Double
    public var degrees: Double {
        get {
            return Self.radiansToDegrees(radians)
        }
        set {
            radians = Self.degreesToRadians(newValue)
        }
    }

    public init() {
        self.radians = 0.0
    }

    public init(radians: Double) {
        self.radians = radians
    }

    public init(degrees: Double) {
        self.radians = Self.degreesToRadians(degrees)
    }

    public static func radians(_ radians: Double) -> Angle {
        return Angle(radians: radians)
    }

    public static func degrees(_ degrees: Double) -> Angle {
        return Angle(degrees: degrees)
    }

    private static func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180 / Double.pi
    }

    private static func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }
}

#if SKIP
extension View {
    public func scaleEffect(x: Double, y: Double) -> some View {
        return ComposeContextView(self) {
            $0.modifier = $0.modifier.scale(scaleX: Float(x), scaleY: Float(y))
        }
    }
}
#endif
#endif
