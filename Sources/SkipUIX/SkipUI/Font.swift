// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import class CoreText.CTFont

/// An environment-dependent font.
///
/// The system resolves a font's value at the time it uses the font in a given
/// environment because ``Font`` is a late-binding token.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Font : Hashable, Sendable {


}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font {

    /// A font with the large title text style.
    public static let largeTitle: Font = { fatalError() }()

    /// A font with the title text style.
    public static let title: Font = { fatalError() }()

    /// Create a font for second level hierarchical headings.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static let title2: Font = { fatalError() }()

    /// Create a font for third level hierarchical headings.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static let title3: Font = { fatalError() }()

    /// A font with the headline text style.
    public static let headline: Font = { fatalError() }()

    /// A font with the subheadline text style.
    public static let subheadline: Font = { fatalError() }()

    /// A font with the body text style.
    public static let body: Font = { fatalError() }()

    /// A font with the callout text style.
    public static let callout: Font = { fatalError() }()

    /// A font with the footnote text style.
    public static let footnote: Font = { fatalError() }()

    /// A font with the caption text style.
    public static let caption: Font = { fatalError() }()

    /// Create a font with the alternate caption text style.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static let caption2: Font = { fatalError() }()

    /// Gets a system font that uses the specified style, design, and weight.
    ///
    /// Use this method to create a system font that has the specified
    /// properties. The following example creates a system font with the
    /// ``TextStyle/body`` text style, a ``Design/serif`` design, and
    /// a ``Weight/bold`` weight, and applies the font to a ``Text`` view
    /// using the ``View/font(_:)`` view modifier:
    ///
    ///     Text("Hello").font(.system(.body, design: .serif, weight: .bold))
    ///
    /// The `design` and `weight` parameters are both optional. If you omit
    /// either, the system uses a default value for that parameter. The
    /// default values are typically ``Design/default`` and ``Weight/regular``,
    /// respectively, but might vary depending on the context.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public static func system(_ style: Font.TextStyle, design: Font.Design? = nil, weight: Font.Weight? = nil) -> Font { fatalError() }

    /// Gets a system font with the given text style and design.
    ///
    /// This function has been deprecated, use the one with nullable `design`
    /// and `weight` instead.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use `system(_:design:weight:)` instead.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use `system(_:design:weight:)` instead.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use `system(_:design:weight:)` instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use `system(_:design:weight:)` instead.")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use `system(_:design:weight:)` instead.")
    public static func system(_ style: Font.TextStyle, design: Font.Design = .default) -> Font { fatalError() }

    /// A dynamic text style to use for fonts.
    public enum TextStyle : CaseIterable, Sendable {

        /// The font style for large titles.
        case largeTitle

        /// The font used for first level hierarchical headings.
        case title

        /// The font used for second level hierarchical headings.
        @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
        case title2

        /// The font used for third level hierarchical headings.
        @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
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
        @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
        case caption2

        /// A collection of all values of this type.
        public static var allCases: [Font.TextStyle] { get { fatalError() } }

        

    
        /// A type that can represent a collection of all values of this type.
        public typealias AllCases = [Font.TextStyle]

        }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font {

    /// Adds italics to the font.
    public func italic() -> Font { fatalError() }

    /// Adjusts the font to enable all small capitals.
    ///
    /// See ``Font/lowercaseSmallCaps()`` and ``Font/uppercaseSmallCaps()`` for
    /// more details.
    public func smallCaps() -> Font { fatalError() }

    /// Adjusts the font to enable lowercase small capitals.
    ///
    /// This function turns lowercase characters into small capitals for the
    /// font. It is generally used for display lines set in large and small
    /// caps, such as titles. It may include forms related to small capitals,
    /// such as old-style figures.
    public func lowercaseSmallCaps() -> Font { fatalError() }

    /// Adjusts the font to enable uppercase small capitals.
    ///
    /// This feature turns capital characters into small capitals. It is
    /// generally used for words which would otherwise be set in all caps, such
    /// as acronyms, but which are desired in small-cap form to avoid disrupting
    /// the flow of text.
    public func uppercaseSmallCaps() -> Font { fatalError() }

    /// Returns a modified font that uses fixed-width digits, while leaving
    /// other characters proportionally spaced.
    ///
    /// This modifier only affects numeric characters, and leaves all other
    /// characters unchanged. If the base font doesn't support fixed-width,
    /// or _monospace_ digits, the font remains unchanged.
    ///
    /// The following example shows two text fields arranged in a ``VStack``.
    /// Both text fields specify the 12-point system font, with the second
    /// adding the `monospacedDigit()` modifier to the font. Because the text
    /// includes the digit 1, normally a narrow character in proportional
    /// fonts, the second text field becomes wider than the first.
    ///
    ///     @State private var userText = "Effect of monospacing digits: 111,111."
    ///
    ///     var body: some View {
    ///         VStack {
    ///             TextField("Proportional", text: $userText)
    ///                 .font(.system(size: 12))
    ///             TextField("Monospaced", text: $userText)
    ///                 .font(.system(size: 12).monospacedDigit())
    ///         }
    ///         .padding()
    ///         .navigationTitle(Text("Font + monospacedDigit()"))
    ///     }
    ///
    /// ![A macOS window showing two text fields arranged vertically. Each
    /// shows the text Effect of monospacing digits: 111,111. The even spacing
    /// of the digit 1 in the second text field causes it to be noticably wider
    /// than the first.](Environment-Font-monospacedDigit-1)
    ///
    /// - Returns: A font that uses fixed-width numeric characters.
    public func monospacedDigit() -> Font { fatalError() }

    /// Sets the weight of the font.
    public func weight(_ weight: Font.Weight) -> Font { fatalError() }

    /// Sets the width of the font.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func width(_ width: Font.Width) -> Font { fatalError() }

    /// Adds bold styling to the font.
    public func bold() -> Font { fatalError() }

    /// Returns a fixed-width font from the same family as the base font.
    ///
    /// If there's no suitable font face in the same family, SkipUI
    /// returns a default fixed-width font.
    ///
    /// The following example adds the `monospaced()` modifier to the default
    /// system font, then applies this font to a ``Text`` view:
    ///
    ///     struct ContentView: View {
    ///         let myFont = Font
    ///             .system(size: 24)
    ///             .monospaced()
    ///
    ///         var body: some View {
    ///             Text("Hello, world!")
    ///                 .font(myFont)
    ///                 .padding()
    ///                 .navigationTitle("Monospaced")
    ///         }
    ///     }
    ///
    ///
    /// ![A macOS window showing the text Hello, world in a 24-point
    /// fixed-width font.](Environment-Font-monospaced-1)
    ///
    /// SkipUI may provide different fixed-width replacements for standard
    /// user interface fonts (such as ``Font/title``, or a system font created
    /// with ``Font/system(_:design:)``) than for those same fonts when created
    /// by name with ``Font/custom(_:size:)``.
    ///
    /// The ``View/font(_:)`` modifier applies the font to all text within
    /// the view. To mix fixed-width text with other styles in the same
    /// `Text` view, use the ``Text/init(_:)-1a4oh`` initializer to use an
    /// appropropriately-styled
    /// for the text view's content. You can use the
    /// initializer to provide a Markdown-formatted string containing the
    /// backtick-syntax (\`…\`) to apply code voice to specific ranges
    /// of the attributed string.
    ///
    /// - Returns: A fixed-width font from the same family as the base font,
    /// if one is available, and a default fixed-width font otherwise.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func monospaced() -> Font { fatalError() }

    /// Adjusts the line spacing of a font.
    ///
    /// You can change a font's line spacing while maintaining other
    /// characteristics of the font by applying this modifier.
    /// For example, you can decrease spacing of the ``body`` font by
    /// applying the ``Leading/tight`` value to it:
    ///
    ///     let myFont = Font.body.leading(.tight)
    ///
    /// The availability of leading adjustments depends on the font. For some
    /// fonts, the modifier has no effect and returns the original font.
    ///
    /// - Parameter leading: The line spacing adjustment to apply.
    ///
    /// - Returns: A modified font that uses the specified line spacing, or
    ///   the original font if it doesn't support line spacing adjustments.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public func leading(_ leading: Font.Leading) -> Font { fatalError() }

    /// A weight to use for fonts.
    @frozen public struct Weight : Hashable {
        private let value: Double
        public static let ultraLight: Font.Weight = Weight(value: -0.8)
        public static let thin: Font.Weight = Weight(value: -0.6)
        public static let light: Font.Weight = Weight(value: -0.4)
        public static let regular: Font.Weight = Weight(value: 0.0)
        public static let medium: Font.Weight = Weight(value: 0.23)
        public static let semibold: Font.Weight = Weight(value: 0.3)
        public static let bold: Font.Weight = Weight(value: 0.4)
        public static let heavy: Font.Weight = Weight(value: 0.56)
        public static let black: Font.Weight = Weight(value: 0.62)
    }

    /// A width to use for fonts that have multiple widths.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public struct Width : Hashable, Sendable {

        public var value: CGFloat { get { fatalError() } }

        public static let compressed: Font.Width = { fatalError() }()

        public static let condensed: Font.Width = { fatalError() }()

        public static let standard: Font.Width = { fatalError() }()

        public static let expanded: Font.Width = { fatalError() }()

        public init(_ value: CGFloat) { fatalError() }

    
        

        }

    /// A line spacing adjustment that you can apply to a font.
    ///
    /// Apply one of the `Leading` values to a font using the
    /// ``Font/leading(_:)`` method to increase or decrease the line spacing.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public enum Leading : Sendable {

        /// The font's default line spacing.
        ///
        /// If you modify a font to use a nonstandard line spacing like
        /// ``tight`` or ``loose``, you can use this value to return to
        /// the font's default line spacing.
        case standard

        /// Reduced line spacing.
        ///
        /// This value typically reduces line spacing by 1 point for watchOS
        /// and 2 points on other platforms.
        case tight

        /// Increased line spacing.
        ///
        /// This value typically increases line spacing by 1 point for watchOS
        /// and 2 points on other platforms.
        case loose

        

    
        }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font {

    /// Specifies a system font to use, along with the style, weight, and any
    /// design parameters you want applied to the text.
    ///
    /// Use this function to create a system font by specifying the size and
    /// weight, and a type design together. The following styles the system font
    /// as 17 point, ``Font/Weight/semibold`` text:
    ///
    ///     Text("Hello").font(.system(size: 17, weight: .semibold))
    ///
    /// While the following styles the text as 17 point ``Font/Weight/bold``,
    /// and applies a `serif` ``Font/Design`` to the system font:
    ///
    ///     Text("Hello").font(.system(size: 17, weight: .bold, design: .serif))
    ///
    /// Both `weight` and `design` can be optional. When you do not provide a
    /// `weight` or `design`, the system can pick one based on the current
    /// context, which may not be ``Font/Weight/regular`` or
    /// ``Font/Design/default`` in certain context. The following example styles
    /// the text as 17 point system font using ``Font/Design/rounded`` design,
    /// while its weight can depend on the current context:
    ///
    ///     Text("Hello").font(.system(size: 17, design: .rounded))
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public static func system(size: CGFloat, weight: Font.Weight? = nil, design: Font.Design? = nil) -> Font { fatalError() }

    /// Specifies a system font to use, along with the style, weight, and any
    /// design parameters you want applied to the text.
    ///
    /// Use this function to create a system font by specifying the size and
    /// weight, and a type design together. The following styles the system font
    /// as 17 point, ``Font/Weight/semibold`` text:
    ///
    ///     Text("Hello").font(.system(size: 17, weight: .semibold))
    ///
    /// While the following styles the text as 17 point ``Font/Weight/bold``,
    /// and applies a `serif` ``Font/Design`` to the system font:
    ///
    ///     Text("Hello").font(.system(size: 17, weight: .bold, design: .serif))
    ///
    /// If you want to use the default ``Font/Weight``
    /// (``Font/Weight/regular``), you don't need to specify the `weight` in the
    /// method. The following example styles the text as 17 point
    /// ``Font/Weight/regular``, and uses a ``Font/Design/rounded`` system font:
    ///
    ///     Text("Hello").font(.system(size: 17, design: .rounded))
    ///
    /// This function has been deprecated, use the one with nullable `weight`
    /// and `design` instead.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use `system(size:weight:design:)` instead.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use `system(size:weight:design:)` instead.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use `system(size:weight:design:)` instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use `system(size:weight:design:)` instead.")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use `system(size:weight:design:)` instead.")
    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font { fatalError() }

    /// A design to use for fonts.
    public enum Design : Hashable, Sendable {

        case `default`

        @available(watchOS 7.0, *)
        case serif

        case rounded

        @available(watchOS 7.0, *)
        case monospaced

        

    
        }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font {

    /// Create a custom font with the given `name` and `size` that scales with
    /// the body text style.
    public static func custom(_ name: String, size: CGFloat) -> Font { fatalError() }

    /// Create a custom font with the given `name` and `size` that scales
    /// relative to the given `textStyle`.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func custom(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font { fatalError() }

    /// Create a custom font with the given `name` and a fixed `size` that does
    /// not scale with Dynamic Type.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func custom(_ name: String, fixedSize: CGFloat) -> Font { fatalError() }

    /// Creates a custom font from a platform font instance.
    ///
    /// Initializing ``Font`` with platform font instance
    /// () can bridge SkipUI
    /// ``Font`` with  or
    /// , both of which are
    /// toll-free bridged to
    /// . For example:
    ///
    ///     // Use native Core Text API to create desired ctFont.
    ///     let ctFont = CTFontCreateUIFontForLanguage(.system, 12, nil)!
    ///
    ///     // Create SkipUI Text with the CTFont instance.
    ///     let text = Text("Hello").font(Font(ctFont))
    public init(_ font: CTFont) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font.TextStyle : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font.TextStyle : Hashable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font.Weight : Sendable {
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Font.Leading : Equatable {
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Font.Leading : Hashable {
}

/// The Accessibility Bold Text user setting options.
///
/// The app can't override the user's choice before iOS 16, tvOS 16 or
/// watchOS 9.0.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum LegibilityWeight : Hashable, Sendable {

    /// Use regular font weight (no Accessibility Bold).
    case regular

    /// Use heavier font weight (force Accessibility Bold).
    case bold

    


}

/// A dynamic property that scales a numeric value.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@propertyWrapper public struct ScaledMetric<Value> : DynamicProperty where Value : BinaryFloatingPoint {

    /// Creates the scaled metric with an unscaled value and a text style to
    /// scale relative to.
    public init(wrappedValue: Value, relativeTo textStyle: Font.TextStyle) { fatalError() }

    /// Creates the scaled metric with an unscaled value using the default
    /// scaling.
    public init(wrappedValue: Value) { fatalError() }

    /// The value scaled based on the current environment.
    public var wrappedValue: Value { get { fatalError() } }
}

/// The reasons to apply a redaction to data displayed on screen.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct RedactionReasons : OptionSet, Sendable {

    /// The raw value.
    public let rawValue: Int = { fatalError() }()

    /// Creates a new set from a raw value.
    ///
    /// - Parameter rawValue: The raw value with which to create the
    ///   reasons for redaction.
    public init(rawValue: Int) { fatalError() }

    /// Displayed data should appear as generic placeholders.
    ///
    /// Text and images will be automatically masked to appear as
    /// generic placeholders, though maintaining their original size and shape.
    /// Use this to create a placeholder UI without directly exposing
    /// placeholder data to users.
    public static let placeholder: RedactionReasons = { fatalError() }()

    /// Displayed data should be obscured to protect private information.
    ///
    /// Views marked with `privacySensitive` will be automatically redacted
    /// using a standard styling. To apply a custom treatment the redaction
    /// reason can be read out of the environment.
    ///
    ///     struct BankingContentView: View {
    ///         @Environment(\.redactionReasons) var redactionReasons
    ///
    ///         var body: some View {
    ///             if redactionReasons.contains(.privacy) {
    ///                 FullAppCover()
    ///             } else {
    ///                 AppContent()
    ///             }
    ///         }
    ///     }
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static let privacy: RedactionReasons = { fatalError() }()

    /// Displayed data should appear as invalidated and pending a new update.
    ///
    /// Views marked with `invalidatableContent` will be automatically
    /// redacted with a standard styling indicating the content is invalidated
    /// and new content will be available soon.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public static let invalidated: RedactionReasons = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = RedactionReasons

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = RedactionReasons

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int
}

#endif
