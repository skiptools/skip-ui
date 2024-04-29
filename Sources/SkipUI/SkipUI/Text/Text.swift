// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.material3.LocalTextStyle
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.text.style.LineHeightStyle
import androidx.compose.ui.text.style.TextAlign
import skip.foundation.LocalizedStringResource
import skip.foundation.Bundle
import skip.foundation.Locale
#else
import struct CoreGraphics.CGFloat
import struct Foundation.LocalizedStringResource
import class Foundation.Bundle
import struct Foundation.Locale
#endif

public struct Text: View, Equatable {
    private let textView: _Text
    private let modifiedView: any View

    public init(verbatim: String) {
        textView = _Text(verbatim: verbatim, key: nil, tableName: nil, bundle: nil)
        modifiedView = textView
    }

    public init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = Bundle.main, comment: StaticString? = nil) {
        textView = _Text(verbatim: nil, key: key, tableName: tableName, bundle: bundle)
        modifiedView = textView
    }

    public init(_ key: String, tableName: String? = nil, bundle: Bundle? = Bundle.main, comment: StaticString? = nil) {
        textView = _Text(verbatim: nil, key: LocalizedStringKey(stringLiteral: key), tableName: tableName, bundle: bundle)
        modifiedView = textView
    }

    init(textView: _Text, modifiedView: any View) {
        self.textView = textView
        // Don't copy view
        // SKIP REPLACE: this.modifiedView = modifiedView
        self.modifiedView = modifiedView
    }

    #if SKIP
    /// Interpret the key against the given bundle and the environment's current locale.
    @Composable public func localizedTextString() -> String {
        return textView.localizedTextString()
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        modifiedView.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif

    public static func ==(lhs: Text, rhs: Text) -> Bool {
        return lhs.textView == rhs.textView
    }

    // Text-specific implementations of View modifiers

    public func accessibilityLabel(_ label: Text) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.accessibilityLabel(label))
    }

    public func accessibilityLabel(_ label: String) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.accessibilityLabel(label))
    }

    public func foregroundColor(_ color: Color?) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.foregroundColor(color))
    }

    public func foregroundStyle(_ style: any ShapeStyle) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.foregroundStyle(style))
    }

    public func font(_ font: Font?) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.font(font))
    }

    public func fontWeight(_ weight: Font.Weight?) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.fontWeight(weight))
    }

    @available(*, unavailable)
    public func fontWidth(_ width: Font.Width?) -> Text {
        return self
    }

    public func bold(_ isActive: Bool = true) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.bold(isActive))
    }

    public func italic(_ isActive: Bool = true) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.italic(isActive))
    }

    public func monospaced(_ isActive: Bool = true) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.monospaced(isActive))
    }

    public func fontDesign(_ design: Font.Design?) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.fontDesign(design))
    }

    @available(*, unavailable)
    public func monospacedDigit() -> Text {
        return self
    }

    @available(*, unavailable)
    public func strikethrough(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> Text {
        return self
    }

    @available(*, unavailable)
    public func underline(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> Text {
        return self
    }

    @available(*, unavailable)
    public func kerning(_ kerning: CGFloat) -> Text {
        return self
    }

    @available(*, unavailable)
    public func tracking(_ tracking: CGFloat) -> Text {
        return self
    }

    @available(*, unavailable)
    public func baselineOffset(_ baselineOffset: CGFloat) -> Text {
        return self
    }

    public enum Case : Sendable {
        case uppercase
        case lowercase
    }

    public struct LineStyle : Hashable, Sendable {
        public let pattern: Text.LineStyle.Pattern
        public let color: Color?

        public init(pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) {
            self.pattern = pattern
            self.color = color
        }

        public enum Pattern : Sendable {
            case solid
            case dot
            case dash
            case dashot
            case dashDotDot
        }

        public static let single = Text.LineStyle()
    }

    public enum Scale : Sendable, Hashable {
        case `default`
        case secondary
    }

    public enum TruncationMode : Sendable {
        case head
        case tail
        case middle
    }
}

struct _Text: View, Equatable {
    let verbatim: String?
    let key: LocalizedStringKey?
    let tableName: String?
    let bundle: Bundle?

    #if SKIP
    @Composable func localizedTextString() -> String {
        if let verbatim = self.verbatim { return verbatim }
        guard let key = self.key else { return "" }

        let locfmt = EnvironmentValues.shared.locale.localize(key: key.patternFormat, value: nil, bundle: self.bundle, tableName: self.tableName)

        // re-interpret the placeholder strings in the resulting localized string with the string interpolation's values
        let replaced = String(format: locfmt ?? key.patternFormat, key.stringInterpolation.values)
        return replaced
    }

    @Composable override func ComposeContent(context: ComposeContext) {
        var font: Font
        var text = self.localizedTextString()
        if let environmentFont = EnvironmentValues.shared.font {
            font = environmentFont
        } else if let sectionHeaderStyle = EnvironmentValues.shared._listSectionHeaderStyle {
            font = Font.callout
            if sectionHeaderStyle == .plain {
                font = font.bold()
            } else {
                text = text.uppercased()
            }
        } else if let sectionFooterStyle = EnvironmentValues.shared._listSectionFooterStyle, sectionFooterStyle != .plain {
            font = Font.footnote
        } else {
            font = Font(fontImpl: { LocalTextStyle.current })
        }
        if let weight = EnvironmentValues.shared._fontWeight {
            font = font.weight(weight)
        }
        if let design = EnvironmentValues.shared._fontDesign {
            font = font.design(design)
        }
        if EnvironmentValues.shared._isItalic {
            font = font.italic()
        }

        var textColor: androidx.compose.ui.graphics.Color? = nil
        var textBrush: Brush? = nil
        if let foregroundStyle = EnvironmentValues.shared._foregroundStyle {
            if let color = foregroundStyle.asColor(opacity: 1.0, animationContext: context) {
                textColor = color
            } else {
                textBrush = foregroundStyle.asBrush(opacity: 1.0, animationContext: context)
            }
        } else if EnvironmentValues.shared._listSectionHeaderStyle != nil {
            textColor = Color.secondary.colorImpl()
        } else if let sectionFooterStyle = EnvironmentValues.shared._listSectionFooterStyle, sectionFooterStyle != .plain {
            textColor = Color.secondary.colorImpl()
        } else {
            textColor = EnvironmentValues.shared._placement.contains(ViewPlacement.systemTextColor) ? androidx.compose.ui.graphics.Color.Unspecified : Color.primary.colorImpl()
        }
        let textAlign = EnvironmentValues.shared.multilineTextAlignment.asTextAlign()
        let maxLines = max(1, EnvironmentValues.shared.lineLimit ?? Int.MAX_VALUE)
        var style = font.fontImpl()
        // Trim the line height padding to mirror SwiftUI.Text layout. For now we only do this here on the Text component
        // rather than in Font to de-risk this aberration from Compose default text style behavior
        style = style.copy(lineHeightStyle: LineHeightStyle(alignment: LineHeightStyle.Alignment.Center, trim: LineHeightStyle.Trim.Both))
        if let textBrush {
            style = style.copy(brush: textBrush)
        }
        let animatable = style.asAnimatable(context: context)
        if let textColor {
            androidx.compose.material3.Text(text: text, modifier: context.modifier, color: textColor, maxLines: maxLines, style: animatable.value, textAlign: textAlign)
        } else {
            androidx.compose.material3.Text(text: text, modifier: context.modifier, maxLines: maxLines, style: animatable.value, textAlign: textAlign)
        }
    }
    #else
    var body: some View {
        stubView()
    }
    #endif
}

public enum TextAlignment : Hashable, CaseIterable, Sendable {
    case leading
    case center
    case trailing

    #if SKIP
    /// Convert this enum to a Compose `TextAlign` value.
    public func asTextAlign() -> TextAlign {
        return switch self {
        case .leading: TextAlign.Start
        case .center: TextAlign.Center
        case .trailing: TextAlign.End
        }
    }
    #endif
}

extension View {
    @available(*, unavailable)
    public func allowsTightening(_ flag: Bool) -> some View {
        return self
    }

    @available(*, unavailable)
    public func baselineOffset(_ baselineOffset: CGFloat) -> some View {
        return self
    }

    public func bold(_ isActive: Bool = true) -> some View {
        return fontWeight(isActive ? Font.Weight.bold : nil)
    }

    @available(*, unavailable)
    public func dynamicTypeSize(_ size: DynamicTypeSize) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dynamicTypeSize(_ range: Range<DynamicTypeSize>) -> some View {
        return self
    }

    public func font(_ font: Font?) -> some View {
        #if SKIP
        return environment(\.font, font)
        #else
        return self
        #endif
    }

    public func fontDesign(_ design: Font.Design?) -> some View {
        #if SKIP
        return environment(\._fontDesign, design)
        #else
        return self
        #endif
    }

    public func fontWeight(_ weight: Font.Weight?) -> some View {
        #if SKIP
        return environment(\._fontWeight, weight)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func fontWidth(_ width: Font.Width?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func invalidatableContent(_ invalidatable: Bool = true) -> some View {
        return self
    }

    public func italic(_ isActive: Bool = true) -> some View {
        #if SKIP
        return environment(\._isItalic, isActive)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func kerning(_ kerning: CGFloat) -> some View {
        return self
    }

    public func lineLimit(_ number: Int?) -> some View {
        #if SKIP
        return environment(\.lineLimit, number)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func lineLimit(_ limit: Range<Int>) -> some View {
        return self
    }

    @available(*, unavailable)
    public func lineLimit(_ limit: Int, reservesSpace: Bool) -> some View {
        return self
    }

    @available(*, unavailable)
    public func lineSpacing(_ lineSpacing: CGFloat) -> some View {
        return self
    }

    @available(*, unavailable)
    public func monospacedDigit() -> some View {
        return self
    }

    public func monospaced(_ isActive: Bool = true) -> some View {
        return fontDesign(isActive ? Font.Design.monospaced : nil)
    }

    @available(*, unavailable)
    public func minimumScaleFactor(_ factor: CGFloat) -> some View {
        return self
    }

    public func multilineTextAlignment(_ alignment: TextAlignment) -> some View {
        #if SKIP
        return environment(\.multilineTextAlignment, alignment)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func privacySensitive(_ sensitive: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func redacted(reason: RedactionReasons) -> some View {
        return self
    }

    @available(*, unavailable)
    public func speechAlwaysIncludesPunctuation(_ value: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func speechSpellsOutCharacters(_ value: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func speechAdjustedPitch(_ value: Double) -> some View {
        return self
    }

    @available(*, unavailable)
    public func speechAnnouncementsQueued(_ value: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func strikethrough(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> some View {
        return self
    }

    @available(*, unavailable)
    public func textCase(_ textCase: Text.Case?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func textScale(_ scale: Text.Scale, isEnabled: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func textSelection(_ selectability: TextSelectability) -> some View {
        return self
    }

    @available(*, unavailable)
    public func tracking(_ tracking: CGFloat) -> some View {
        return self
    }

    @available(*, unavailable)
    public func truncationMode(_ mode: Text.TruncationMode) -> some View {
        return self
    }

    @available(*, unavailable)
    public func underline(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> some View {
        return self
    }

    @available(*, unavailable)
    public func unredacted() -> some View {
        return self
    }
}

#if false

// TODO: Process for use in SkipUI

import struct Foundation.AttributedString
import struct Foundation.Date
import struct Foundation.DateInterval
import struct Foundation.Locale
import struct Foundation.LocalizedStringResource

import protocol Foundation.AttributeScope
import struct Foundation.AttributeScopeCodableConfiguration
import enum Foundation.AttributeScopes
import enum Foundation.AttributeDynamicLookup
import protocol Foundation.AttributedStringKey

import class Foundation.Bundle
import class Foundation.NSObject
import class Foundation.Formatter

import protocol Foundation.ParseableFormatStyle
import protocol Foundation.FormatStyle
import protocol Foundation.ReferenceConvertible

extension Text {

    /// Creates an instance that wraps an `Image`, suitable for concatenating
    /// with other `Text`
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public init(_ image: Image) { fatalError() }
}

extension Text {

    /// Specifies the language for typesetting.
    ///
    /// In some cases `Text` may contain text of a particular language which
    /// doesn't match the device UI language. In that case it's useful to
    /// specify a language so line height, line breaking and spacing will
    /// respect the script used for that language. For example:
    ///
    ///     Text(verbatim: "แอปเปิล")
    ///         .typesettingLanguage(.init(languageCode: .thai))
    ///
    /// Note: this language does not affect text localization.
    ///
    /// - Parameters:
    ///   - language: The explicit language to use for typesetting.
    ///   - isEnabled: A Boolean value that indicates whether text langauge is
    ///     added
    /// - Returns: Text with the typesetting language set to the value you
    ///   supply.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func typesettingLanguage(_ language: Locale.Language, isEnabled: Bool = true) -> Text { fatalError() }

    /// Specifies the language for typesetting.
    ///
    /// In some cases `Text` may contain text of a particular language which
    /// doesn't match the device UI language. In that case it's useful to
    /// specify a language so line height, line breaking and spacing will
    /// respect the script used for that language. For example:
    ///
    ///     Text(verbatim: "แอปเปิล").typesettingLanguage(
    ///         .explicit(.init(languageCode: .thai)))
    ///
    /// Note: this language does not affect text localized localization.
    ///
    /// - Parameters:
    ///   - language: The language to use for typesetting.
    ///   - isEnabled: A Boolean value that indicates whether text language is
    ///     added
    /// - Returns: Text with the typesetting language set to the value you
    ///   supply.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func typesettingLanguage(_ language: TypesettingLanguage, isEnabled: Bool = true) -> Text { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text {

    /// Creates a text view that displays the formatted representation
    /// of a reference-convertible value.
    ///
    /// Use this initializer to create a text view that formats `subject`
    /// using `formatter`.
    /// - Parameters:
    ///   - subject: A
    ///   
    ///   instance compatible with `formatter`.
    ///   - formatter: A
    ///   
    ///   capable of converting `subject` into a string representation.
    public init<Subject>(_ subject: Subject, formatter: Formatter) where Subject : ReferenceConvertible { fatalError() }

    /// Creates a text view that displays the formatted representation
    /// of a Foundation object.
    ///
    /// Use this initializer to create a text view that formats `subject`
    /// using `formatter`.
    /// - Parameters:
    ///   - subject: An
    ///   
    ///   instance compatible with `formatter`.
    ///   - formatter: A
    ///   
    ///   capable of converting `subject` into a string representation.
    public init<Subject>(_ subject: Subject, formatter: Formatter) where Subject : NSObject { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Text {

    /// Creates a text view that displays the formatted representation
    /// of a nonstring type supported by a corresponding format style.
    ///
    /// Use this initializer to create a text view backed by a nonstring
    /// value, using a
    /// to convert the type to a string representation. Any changes to the value
    /// update the string displayed by the text view.
    ///
    /// In the following example, three ``Text`` views present a date with
    /// different combinations of date and time fields, by using different
    /// options.
    ///
    ///     @State private var myDate = Date()
    ///     var body: some View {
    ///         VStack {
    ///             Text(myDate, format: Date.FormatStyle(date: .numeric, time: .omitted))
    ///             Text(myDate, format: Date.FormatStyle(date: .complete, time: .complete))
    ///             Text(myDate, format: Date.FormatStyle().hour(.defaultDigitsNoAMPM).minute())
    ///         }
    ///     }
    ///
    /// ![Three vertically stacked text views showing the date with different
    /// levels of detail: 4/1/1976; April 1, 1976; Thursday, April 1,
    /// 1976.](Text-init-format-1)
    ///
    /// - Parameters:
    ///   - input: The underlying value to display.
    ///   - format: A format style of type `F` to convert the underlying value
    ///     of type `F.FormatInput` to a string representation.
    public init<F>(_ input: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text {

    /// A predefined style used to display a `Date`.
    public struct DateStyle : Sendable {

        /// A style displaying only the time component for a date.
        ///
        ///     Text(event.startDate, style: .time)
        ///
        /// Example output:
        ///     11:23PM
        public static let time: Text.DateStyle = { fatalError() }()

        /// A style displaying a date.
        ///
        ///     Text(event.startDate, style: .date)
        ///
        /// Example output:
        ///     June 3, 2019
        public static let date: Text.DateStyle = { fatalError() }()

        /// A style displaying a date as relative to now.
        ///
        ///     Text(event.startDate, style: .relative)
        ///
        /// Example output:
        ///     2 hours, 23 minutes
        ///     1 year, 1 month
        public static let relative: Text.DateStyle = { fatalError() }()

        /// A style displaying a date as offset from now.
        ///
        ///     Text(event.startDate, style: .offset)
        ///
        /// Example output:
        ///     +2 hours
        ///     -3 months
        public static let offset: Text.DateStyle = { fatalError() }()

        /// A style displaying a date as timer counting from now.
        ///
        ///     Text(event.startDate, style: .timer)
        ///
        /// Example output:
        ///    2:32
        ///    36:59:01
        public static let timer: Text.DateStyle = { fatalError() }()
    }

    /// Creates an instance that displays localized dates and times using a specific style.
    ///
    /// - Parameters:
    ///     - date: The target date to display.
    ///     - style: The style used when displaying a date.
    public init(_ date: Date, style: Text.DateStyle) { fatalError() }

    /// Creates an instance that displays a localized range between two dates.
    ///
    /// - Parameters:
    ///     - dates: The range of dates to display
    public init(_ dates: ClosedRange<Date>) { fatalError() }

    /// Creates an instance that displays a localized time interval.
    ///
    ///     Text(DateInterval(start: event.startDate, duration: event.duration))
    ///
    /// Example output:
    ///     9:30AM - 3:30PM
    ///
    /// - Parameters:
    ///     - interval: The date interval to display
    public init(_ interval: DateInterval) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Text {

    /// Creates an instance that displays a timer counting within the provided
    /// interval.
    ///
    ///     Text(
    ///         timerInterval: Date.now...Date(timeInterval: 12 * 60, since: .now))
    ///         pauseTime: Date.now + (10 * 60))
    ///
    /// The example above shows a text that displays a timer counting down
    /// from "12:00" and will pause when reaching "10:00".
    ///
    /// - Parameters:
    ///     - timerInterval: The interval between where to run the timer.
    ///     - pauseTime: If present, the date at which to pause the timer.
    ///         The default is `nil` which indicates to never pause.
    ///     - countsDown: Whether to count up or down. The default is `true`.
    ///     - showsHours: Whether to include an hours component if there are
    ///         more than 60 minutes left on the timer. The default is `true`.
    public init(timerInterval: ClosedRange<Date>, pauseTime: Date? = nil, countsDown: Bool = true, showsHours: Bool = true) { fatalError() }
}

extension Text {

    /// Applies a text scale to the text.
    ///
    /// - Parameters:
    ///   - scale: The text scale to apply.
    ///   - isEnabled: If true the text scale is applied; otherwise text scale
    ///     is unchanged.
    /// - Returns: Text with the specified scale applied.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func textScale(_ scale: Text.Scale, isEnabled: Bool = true) -> Text { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Text {

    /// Sets whether VoiceOver should always speak all punctuation in the text view.
    ///
    /// Use this modifier to control whether the system speaks punctuation characters
    /// in the text. You might use this for code or other text where the punctuation is relevant, or where
    /// you want VoiceOver to speak a verbatim transcription of the text you provide. For example,
    /// given the text:
    ///
    ///     Text("All the world's a stage, " +
    ///          "And all the men and women merely players;")
    ///          .speechAlwaysIncludesPunctuation()
    ///
    /// VoiceOver would speak "All the world apostrophe s a stage comma and all the men
    /// and women merely players semicolon".
    ///
    /// By default, VoiceOver voices punctuation based on surrounding context.
    ///
    /// - Parameter value: A Boolean value that you set to `true` if
    ///   VoiceOver should speak all punctuation in the text. Defaults to `true`.
    public func speechAlwaysIncludesPunctuation(_ value: Bool = true) -> Text { fatalError() }

    /// Sets whether VoiceOver should speak the contents of the text view character by character.
    ///
    /// Use this modifier when you want VoiceOver to speak text as individual letters,
    /// character by character. This is important for text that is not meant to be spoken together, like:
    /// - An acronym that isn't a word, like APPL, spoken as "A-P-P-L".
    /// - A number representing a series of digits, like 25, spoken as "two-five" rather than "twenty-five".
    ///
    /// - Parameter value: A Boolean value that when `true` indicates
    ///    VoiceOver should speak text as individual characters. Defaults
    ///    to `true`.
    public func speechSpellsOutCharacters(_ value: Bool = true) -> Text { fatalError() }

    /// Raises or lowers the pitch of spoken text.
    ///
    /// Use this modifier when you want to change the pitch of spoken text.
    /// The value indicates how much higher or lower to change the pitch.
    ///
    /// - Parameter value: The amount to raise or lower the pitch.
    ///   Values between `-1` and `0` result in a lower pitch while
    ///   values between `0` and `1` result in a higher pitch.
    ///   The method clamps values to the range `-1` to `1`.
    public func speechAdjustedPitch(_ value: Double) -> Text { fatalError() }

    /// Controls whether to queue pending announcements behind existing speech rather than
    /// interrupting speech in progress.
    ///
    /// Use this modifier when you want affect the order in which the
    /// accessibility system delivers spoken text. Announcements can
    /// occur automatically when the label or value of an accessibility
    /// element changes.
    ///
    /// - Parameter value: A Boolean value that determines if VoiceOver speaks
    ///   changes to text immediately or enqueues them behind existing speech.
    ///   Defaults to `true`.
    public func speechAnnouncementsQueued(_ value: Bool = true) -> Text { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text {

    /// Concatenates the text in two text views in a new text view.
    ///
    /// - Parameters:
    ///   - lhs: The first text view with text to combine.
    ///   - rhs: The second text view with text to combine.
    ///
    /// - Returns: A new text view containing the combined contents of the two
    ///   input text views.
    public static func + (lhs: Text, rhs: Text) -> Text { fatalError() }
}

extension Text {

    /// Creates a text view that displays a localized string resource.
    ///
    /// Use this initializer to display a localized string that is
    /// represented by a 
    ///
    ///     var object = LocalizedStringResource("pencil")
    ///     Text(object) // Localizes the resource if possible, or displays "pencil" if not.
    ///
    //@available(iOS 16.0, macOS 13, tvOS 16.0, watchOS 9.0, *)
    //public init(_ resource: LocalizedStringResource) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Text {

    /// Sets an accessibility text content type.
    ///
    /// Use this modifier to set the content type of this accessibility
    /// element. Assistive technologies can use this property to choose
    /// an appropriate way to output the text. For example, when
    /// encountering a source coding context, VoiceOver could
    /// choose to speak all punctuation.
    ///
    /// If you don't set a value with this method, the default content type
    /// is ``AccessibilityTextContentType/plain``.
    ///
    /// - Parameter value: The accessibility content type from the available
    /// ``AccessibilityTextContentType`` options.
    public func accessibilityTextContentType(_ value: AccessibilityTextContentType) -> Text { fatalError() }

    /// Sets the accessibility level of this heading.
    ///
    /// Use this modifier to set the level of this heading in relation to other headings. The system speaks
    /// the level number of levels ``AccessibilityHeadingLevel/h1`` through
    /// ``AccessibilityHeadingLevel/h6`` alongside the text.
    ///
    /// The default heading level if you don't use this modifier
    /// is ``AccessibilityHeadingLevel/unspecified``.
    ///
    /// - Parameter level: The heading level to associate with this element
    ///   from the available ``AccessibilityHeadingLevel`` levels.
    public func accessibilityHeading(_ level: AccessibilityHeadingLevel) -> Text { fatalError() }

    /// Use this method to provide an alternative accessibility label to the text that is displayed.
    /// For example, you can give an alternate label to a navigation title:
    ///
    ///     var body: some View {
    ///         NavigationView {
    ///             ContentView()
    ///                 .navigationTitle(Text("􀈤").accessibilityLabel("Inbox"))
    ///         }
    ///     }
    ///
    /// - Parameter labelKey: The string key for the alternative
    ///   accessibility label.
    public func accessibilityLabel(_ labelKey: LocalizedStringKey) -> Text { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Text {

    /// Creates a text view that displays styled attributed content.
    ///
    /// Use this initializer to style text according to attributes found in the specified
    /// .
    /// Attributes in the attributed string take precedence over styles added by
    /// view modifiers. For example, the attributed text in the following
    /// example appears in blue, despite the use of the ``View/foregroundColor(_:)``
    /// modifier to use red throughout the enclosing ``VStack``:
    ///
    ///     var content: AttributedString {
    ///         var attributedString = AttributedString("Blue text")
    ///         attributedString.foregroundColor = .blue
    ///         return attributedString
    ///     }
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Text(content)
    ///             Text("Red text")
    ///         }
    ///         .foregroundColor(.red)
    ///     }
    ///
    /// ![A vertical stack of two text views, the top labeled Blue Text with a
    /// blue font color, and the bottom labeled Red Text with a red font
    /// color.](SkipUI-Text-init-attributed.png)
    ///
    /// SkipUI combines text attributes with SkipUI modifiers whenever
    /// possible. For example, the following listing creates text that is
    /// both bold and red:
    ///
    ///     var content: AttributedString {
    ///         var content = AttributedString("Some text")
    ///         content.inlinePresentationIntent = .stronglyEmphasized
    ///         return content
    ///     }
    ///
    ///     var body: some View {
    ///         Text(content).foregroundColor(Color.red)
    ///     }
    ///
    /// A SkipUI ``Text`` view renders most of the styles defined by the
    /// Foundation attribute
    /// , like the
    /// value, which SkipUI presents as bold text.
    ///
    /// > Important: ``Text`` uses only a subset of the attributes defined in
    /// .
    /// `Text` renders all
    /// attributes except for
    ///  and
    /// .
    /// It also renders the
    /// attribute as a clickable link. `Text` ignores any other
    /// Foundation-defined attributes in an attributed string.
    ///
    /// SkipUI also defines additional attributes in the attribute scope
    /// which you can access from an attributed string's
    /// property. SkipUI attributes take precedence over equivalent attributes
    /// from other frameworks, such as
    ///  and
    /// .
    ///
    ///
    /// You can create an `AttributedString` with Markdown syntax, which allows
    /// you to style distinct runs within a `Text` view:
    ///
    ///     let content = try! AttributedString(
    ///         markdown: "**Thank You!** Please visit our [website](http://example.com).")
    ///
    ///     var body: some View {
    ///         Text(content)
    ///     }
    ///
    /// The `**` syntax around "Thank You!" applies an
    /// attribute with the value
    /// .
    /// SkipUI renders this as
    /// bold text, as described earlier. The link syntax around "website"
    /// creates a
    /// attribute, which `Text` styles to indicate it's a link; by default,
    /// clicking or tapping the link opens the linked URL in the user's default
    /// browser. Alternatively, you can perform custom link handling by putting
    /// an ``OpenURLAction`` in the text view's environment.
    ///
    /// ![A text view that says Thank you. Please visit our website. The text
    /// The view displays the words Thank you in a bold font, and the word
    /// website styled to indicate it is a
    /// link.](SkipUI-Text-init-markdown.png)
    ///
    /// You can also use Markdown syntax in localized string keys, which means
    /// you can write the above example without needing to explicitly create
    /// an `AttributedString`:
    ///
    ///     var body: some View {
    ///         Text("**Thank You!** Please visit our [website](https://example.com).")
    ///     }
    ///
    /// In your app's strings files, use Markdown syntax to apply styling
    /// to the app's localized strings. You also use this approach when you want
    /// to perform automatic grammar agreement on localized strings, with
    /// the `^[text](inflect:true)` syntax.
    ///
    /// For details about Markdown syntax support in SkipUI, see
    /// ``Text/init(_:tableName:bundle:comment:)``.
    ///
    /// - Parameters:
    ///   - attributedContent: An attributed string to style and display,
    ///   in accordance with its attributes.
    public init(_ attributedContent: AttributedString) { fatalError() }
}

//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Text.Storage : @unchecked Sendable {
//}
//
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Text.Modifier : @unchecked Sendable {
//}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text.DateStyle : Equatable {

    
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text.DateStyle : Codable {

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

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text.TruncationMode : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text.TruncationMode : Hashable {
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text.Case : Equatable {
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text.Case : Hashable {
}

/// A built-in group of commands for searching, editing, and transforming
/// selections of text.
///
/// These commands are optional and can be explicitly requested by passing a
/// value of this type to the `Scene.commands(_:)` modifier.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TextEditingCommands : Commands {

    /// A new value describing the built-in text-editing commands.
    public init() { fatalError() }

    /// The contents of the command hierarchy.
    ///
    /// For any commands that you create, provide a computed `body` property
    /// that defines the scene as a composition of other scenes. You can
    /// assemble a command hierarchy from built-in commands that SkipUI
    /// provides, as well as other commands that you've defined.
    public var body: Body { fatalError() }

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    public typealias Body = NeverView
}

extension AttributeScopes {

    /// A property for accessing the attribute scopes defined by SkipUI.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var skipUI: AttributeScopes.SkipUIAttributes.Type { get { fatalError() } }

    /// Attribute scopes defined by SkipUI.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public struct SkipUIAttributes : AttributeScope {

//        /// A property for accessing a font attribute.
//        public let font: AttributeScopes.SwiftUI.FontAttribute = { fatalError() }()
//
//        /// A property for accessing a foreground color attribute.
//        public let foregroundColor: AttributeScopes.SkipUIAttributes.ForegroundColorAttribute = { fatalError() }()
//
//        /// A property for accessing a background color attribute.
//        public let backgroundColor: AttributeScopes.SkipUIAttributes.BackgroundColorAttribute = { fatalError() }()
//
//        /// A property for accessing a strikethrough style attribute.
//        public let strikethroughStyle: AttributeScopes.SkipUIAttributes.StrikethroughStyleAttribute = { fatalError() }()
//
//        /// A property for accessing an underline style attribute.
//        public let underlineStyle: AttributeScopes.SkipUIAttributes.UnderlineStyleAttribute = { fatalError() }()
//
//        /// A property for accessing a kerning attribute.
//        public let kern: AttributeScopes.SkipUIAttributes.KerningAttribute = { fatalError() }()
//
//        /// A property for accessing a tracking attribute.
//        public let tracking: AttributeScopes.SkipUIAttributes.TrackingAttribute = { fatalError() }()
//
//        /// A property for accessing a baseline offset attribute.
//        public let baselineOffset: AttributeScopes.SkipUIAttributes.BaselineOffsetAttribute = { fatalError() }()
//
//        /// A property for accessing attributes defined by the Accessibility framework.
//        public let accessibility: AttributeScopes.AccessibilityAttributes = { fatalError() }()

        /// A property for accessing attributes defined by the Foundation framework.
        public let foundation: AttributeScopes.FoundationAttributes = { fatalError() }()

        public typealias DecodingConfiguration = AttributeScopeCodableConfiguration

        public typealias EncodingConfiguration = AttributeScopeCodableConfiguration
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension AttributeDynamicLookup {

    public subscript<T>(dynamicMember keyPath: KeyPath<AttributeScopes.SkipUIAttributes, T>) -> T where T : AttributedStringKey { get { fatalError() } }
}

#endif
