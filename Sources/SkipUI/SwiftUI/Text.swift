// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

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

/// A view that displays one or more lines of read-only text.
///
/// A text view draws a string in your app's user interface using a
/// ``Font/body`` font that's appropriate for the current platform. You can
/// choose a different standard font, like ``Font/title`` or ``Font/caption``,
/// using the ``View/font(_:)`` view modifier.
///
///     Text("Hamlet")
///         .font(.title)
///
/// ![A text view showing the name "Hamlet" in a title
/// font.](SkipUI-Text-title.png)
///
/// If you need finer control over the styling of the text, you can use the same
/// modifier to configure a system font or choose a custom font. You can also
/// apply view modifiers like ``Text/bold()`` or ``Text/italic()`` to further
/// adjust the formatting.
///
///     Text("by William Shakespeare")
///         .font(.system(size: 12, weight: .light, design: .serif))
///         .italic()
///
/// ![A text view showing by William Shakespeare in a 12 point, light, italic,
/// serif font.](SkipUI-Text-font.png)
///
/// To apply styling within specific portions of the text, you can create
/// the text view from an
/// ,
/// which in turn allows you to use Markdown to style runs of text. You can
/// mix string attributes and SkipUI modifiers, with the string attributes
/// taking priority.
///
///     let attributedString = try! AttributedString(
///         markdown: "_Hamlet_ by William Shakespeare")
///
///     var body: some View {
///         Text(attributedString)
///             .font(.system(size: 12, weight: .light, design: .serif))
///     }
///
/// ![A text view showing Hamlet by William Shakespeare in a 12 point, light,
/// serif font, with the title Hamlet in italics.](SkipUI-Text-attributed.png)
///
/// A text view always uses exactly the amount of space it needs to display its
/// rendered contents, but you can affect the view's layout. For example, you
/// can use the ``View/frame(width:height:alignment:)`` modifier to propose
/// specific dimensions to the view. If the view accepts the proposal but the
/// text doesn't fit into the available space, the view uses a combination of
/// wrapping, tightening, scaling, and truncation to make it fit. With a width
/// of `100` points but no constraint on the height, a text view might wrap a
/// long string:
///
///     Text("To be, or not to be, that is the question:")
///         .frame(width: 100)
///
/// ![A text view showing a quote from Hamlet split over three
/// lines.](SkipUI-Text-split.png)
///
/// Use modifiers like ``View/lineLimit(_:)-513mb``, ``View/allowsTightening(_:)``,
/// ``View/minimumScaleFactor(_:)``, and ``View/truncationMode(_:)`` to
/// configure how the view handles space constraints. For example, combining a
/// fixed width and a line limit of `1` results in truncation for text that
/// doesn't fit in that space:
///
///     Text("Brevity is the soul of wit.")
///         .frame(width: 100)
///         .lineLimit(1)
///
/// ![A text view showing a truncated quote from Hamlet starting Brevity is t
/// and ending with three dots.](SkipUI-Text-truncated.png)
///
/// ### Localizing strings
///
/// If you initialize a text view with a string literal, the view uses the
/// ``Text/init(_:tableName:bundle:comment:)`` initializer, which interprets the
/// string as a localization key and searches for the key in the table you
/// specify, or in the default table if you don't specify one.
///
///     Text("pencil") // Searches the default table in the main bundle.
///
/// For an app localized in both English and Spanish, the above view displays
/// "pencil" and "lápiz" for English and Spanish users, respectively. If the
/// view can't perform localization, it displays the key instead. For example,
/// if the same app lacks Danish localization, the view displays "pencil" for
/// users in that locale. Similarly, an app that lacks any localization
/// information displays "pencil" in any locale.
///
/// To explicitly bypass localization for a string literal, use the
/// ``Text/init(verbatim:)`` initializer.
///
///     Text(verbatim: "pencil") // Displays the string "pencil" in any locale.
///
/// If you intialize a text view with a variable value, the view uses the
/// ``Text/init(_:)-9d1g4`` initializer, which doesn't localize the string. However,
/// you can request localization by creating a ``LocalizedStringKey`` instance
/// first, which triggers the ``Text/init(_:tableName:bundle:comment:)``
/// initializer instead:
///
///     // Don't localize a string variable...
///     Text(writingImplement)
///
///     // ...unless you explicitly convert it to a localized string key.
///     Text(LocalizedStringKey(writingImplement))
///
/// When localizing a string variable, you can use the default table by omitting
/// the optional initialization parameters — as in the above example — just like
/// you might for a string literal.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Text : Equatable, Sendable {

    /// Creates a text view that displays a string literal without localization.
    ///
    /// Use this initializer to create a text view with a string literal without
    /// performing localization:
    ///
    ///     Text(verbatim: "pencil") // Displays the string "pencil" in any locale.
    ///
    /// If you want to localize a string literal before displaying it, use the
    /// ``Text/init(_:tableName:bundle:comment:)`` initializer instead. If you
    /// want to display a string variable, use the ``Text/init(_:)-9d1g4``
    /// initializer, which also bypasses localization.
    ///
    /// - Parameter content: A string to display without localization.
    @inlinable public init(verbatim content: String) { fatalError() }

    /// Creates a text view that displays a stored string without localization.
    ///
    /// Use this initializer to create a text view that displays — without
    /// localization — the text in a string variable.
    ///
    ///     Text(someString) // Displays the contents of `someString` without localization.
    ///
    /// SkipUI doesn't call the `init(_:)` method when you initialize a text
    /// view with a string literal as the input. Instead, a string literal
    /// triggers the ``Text/init(_:tableName:bundle:comment:)`` method — which
    /// treats the input as a ``LocalizedStringKey`` instance — and attempts to
    /// perform localization.
    ///
    /// By default, SkipUI assumes that you don't want to localize stored
    /// strings, but if you do, you can first create a localized string key from
    /// the value, and initialize the text view with that. Using a key as input
    /// triggers the ``Text/init(_:tableName:bundle:comment:)`` method instead.
    ///
    /// - Parameter content: The string value to display without localization.
    public init<S>(_ content: S) where S : StringProtocol { fatalError() }

    
}

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

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text {

    /// Creates a text view that displays localized content identified by a key.
    ///
    /// Use this initializer to look for the `key` parameter in a localization
    /// table and display the associated string value in the initialized text
    /// view. If the initializer can't find the key in the table, or if no table
    /// exists, the text view displays the string representation of the key
    /// instead.
    ///
    ///     Text("pencil") // Localizes the key if possible, or displays "pencil" if not.
    ///
    /// When you initialize a text view with a string literal, the view triggers
    /// this initializer because it assumes you want the string localized, even
    /// when you don't explicitly specify a table, as in the above example. If
    /// you haven't provided localization for a particular string, you still get
    /// reasonable behavior, because the initializer displays the key, which
    /// typically contains the unlocalized string.
    ///
    /// If you initialize a text view with a string variable rather than a
    /// string literal, the view triggers the ``Text/init(_:)-9d1g4``
    /// initializer instead, because it assumes that you don't want localization
    /// in that case. If you do want to localize the value stored in a string
    /// variable, you can choose to call the `init(_:tableName:bundle:comment:)`
    /// initializer by first creating a ``LocalizedStringKey`` instance from the
    /// string variable:
    ///
    ///     Text(LocalizedStringKey(someString)) // Localizes the contents of `someString`.
    ///
    /// If you have a string literal that you don't want to localize, use the
    /// ``Text/init(verbatim:)`` initializer instead.
    ///
    /// ### Styling localized strings with markdown
    ///
    /// If the localized string or the fallback key contains Markdown, the
    /// view displays the text with appropriate styling. For example, consider
    /// an app with the following entry in its Spanish localization file:
    ///
    ///     "_Please visit our [website](https://www.example.com)._" = "_Visita nuestro [sitio web](https://www.example.com)._";
    ///
    /// You can create a `Text` view with the Markdown-formatted base language
    /// version of the string as the localization key, like this:
    ///
    ///     Text("_Please visit our [website](https://www.example.com)._")
    ///
    /// When viewed in a Spanish locale, the view uses the Spanish text from the
    /// strings file, applying the Markdown styling.
    ///
    /// ![A text view that says Visita nuestro sitio web, with all text
    /// displayed in italics. The words sitio web are colored blue to indicate
    /// they are a link.](SkipUI-Text-init-localized.png)
    ///
    /// > Important: `Text` doesn't render all styling possible in Markdown. It
    /// doesn't support line breaks, soft breaks, or any style of paragraph- or
    /// block-based formatting like lists, block quotes, code blocks, or tables.
    /// It also doesn't support the
    /// attribute. Parsing with SkipUI treats any whitespace in the Markdown
    /// string as described by the
    /// parsing option.
    ///
    /// - Parameters:
    ///   - key: The key for a string in the table identified by `tableName`.
    ///   - tableName: The name of the string table to search. If `nil`, use the
    ///     table in the `Localizable.strings` file.
    ///   - bundle: The bundle containing the strings file. If `nil`, use the
    ///     main bundle.
    ///   - comment: Contextual information about this key-value pair.
    public init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = nil, comment: StaticString? = nil) { fatalError() }
}

extension Text {

    /// Defines text scales
    ///
    /// Text scale provides a way to pick a logical text scale
    /// relative to the base font which is used.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public struct Scale : Sendable, Hashable {

        /// Defines default text scale
        ///
        /// When specified uses the default text scale.
        public static let `default`: Text.Scale = { fatalError() }()

        /// Defines secondary text scale
        ///
        /// When specified a uses a secondary text scale.
        public static let secondary: Text.Scale = { fatalError() }()

    
        

        }
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
    @available(iOS 16.0, macOS 13, tvOS 16.0, watchOS 9.0, *)
    public init(_ resource: LocalizedStringResource) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text {

    /// The type of truncation to apply to a line of text when it's too long to
    /// fit in the available space.
    ///
    /// When a text view contains more text than it's able to display, the view
    /// might truncate the text and place an ellipsis (...) at the truncation
    /// point. Use the ``View/truncationMode(_:)`` modifier with one of the
    /// `TruncationMode` values to indicate which part of the text to
    /// truncate, either at the beginning, in the middle, or at the end.
    public enum TruncationMode : Sendable {

        /// Truncate at the beginning of the line.
        ///
        /// Use this kind of truncation to omit characters from the beginning of
        /// the string. For example, you could truncate the English alphabet as
        /// "...wxyz".
        case head

        /// Truncate at the end of the line.
        ///
        /// Use this kind of truncation to omit characters from the end of the
        /// string. For example, you could truncate the English alphabet as
        /// "abcd...".
        case tail

        /// Truncate in the middle of the line.
        ///
        /// Use this kind of truncation to omit characters from the middle of
        /// the string. For example, you could truncate the English alphabet as
        /// "ab...yz".
        case middle

        

    
        }

    /// A scheme for transforming the capitalization of characters within text.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public enum Case : Sendable {

        /// Displays text in all uppercase characters.
        ///
        /// For example, "Hello" would be displayed as "HELLO".
        ///
        /// - SeeAlso: `StringProtocol.uppercased(with:)`
        case uppercase

        /// Displays text in all lowercase characters.
        ///
        /// For example, "Hello" would be displayed as "hello".
        ///
        /// - SeeAlso: `StringProtocol.lowercased(with:)`
        case lowercase

        

    
        }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Text {

    /// Description of the style used to draw the line for `StrikethroughStyleAttribute`
    /// and `UnderlineStyleAttribute`.
    ///
    /// Use this type to specify `underlineStyle` and `strikethroughStyle`
    /// SkipUI attributes of an `AttributedString`.
    public struct LineStyle : Hashable, Sendable {

        /// Creates a line style.
        ///
        /// - Parameters:
        ///   - pattern: The pattern of the line.
        ///   - color: The color of the line. If not provided, the foreground
        ///     color of text is used.
        public init(pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) { fatalError() }

        /// The pattern, that the line has.
        public struct Pattern : Sendable {

            /// Draw a solid line.
            public static let solid: Text.LineStyle.Pattern = { fatalError() }()

            /// Draw a line of dots.
            public static let dot: Text.LineStyle.Pattern = { fatalError() }()

            /// Draw a line of dashes.
            public static let dash: Text.LineStyle.Pattern = { fatalError() }()

            public static let dashDot: Text.LineStyle.Pattern = { fatalError() }()

            /// Draw a line of alternating dashes and two dots.
            public static let dashDotDot: Text.LineStyle.Pattern = { fatalError() }()
        }

        /// Draw a single solid line.
        public static let single: Text.LineStyle = { fatalError() }()

//        /// Creates a ``Text.LineStyle`` from ``NSUnderlineStyle``.
//        ///
//        /// > Note: Use this initializer only if you need to convert an existing
//        /// ``NSUnderlineStyle`` to a SkipUI ``Text.LineStyle``.
//        /// Otherwise, create a ``Text.LineStyle`` using an
//        /// initializer like ``init(pattern:color:)``.
//        ///
//        /// - Parameter nsUnderlineStyle: A value of ``NSUnderlineStyle``
//        /// to wrap with ``Text.LineStyle``.
//        ///
//        /// - Returns: A new ``Text.LineStyle`` or `nil` when
//        /// `nsUnderlineStyle` contains styles not supported by ``Text.LineStyle``.
//        public init?(nsUnderlineStyle: NSUnderlineStyle) { fatalError() }

    
        

        }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text : View {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text {

    /// Sets the color of the text displayed by this view.
    ///
    /// Use this method to change the color of the text rendered by a text view.
    ///
    /// For example, you can display the names of the colors red, green, and
    /// blue in their respective colors:
    ///
    ///     HStack {
    ///         Text("Red").foregroundColor(.red)
    ///         Text("Green").foregroundColor(.green)
    ///         Text("Blue").foregroundColor(.blue)
    ///     }
    ///
    /// ![Three text views arranged horizontally, each containing
    ///     the name of a color displayed in that
    ///     color.](SkipUI-Text-foregroundColor.png)
    ///
    /// - Parameter color: The color to use when displaying this text.
    /// - Returns: A text view that uses the color value you supply.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    public func foregroundColor(_ color: Color?) -> Text { fatalError() }

    /// Sets the style of the text displayed by this view.
    ///
    /// Use this method to change the rendering style of the text
    /// rendered by a text view.
    ///
    /// For example, you can display the names of the colors red,
    /// green, and blue in their respective colors:
    ///
    ///     HStack {
    ///         Text("Red").foregroundStyle(.red)
    ///         Text("Green").foregroundStyle(.green)
    ///         Text("Blue").foregroundStyle(.blue)
    ///     }
    ///
    /// ![Three text views arranged horizontally, each containing
    ///     the name of a color displayed in that
    ///     color.](SkipUI-Text-foregroundColor.png)
    ///
    /// - Parameter style: The style to use when displaying this text.
    /// - Returns: A text view that uses the color value you supply.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func foregroundStyle<S>(_ style: S) -> Text where S : ShapeStyle { fatalError() }

    /// Sets the default font for text in the view.
    ///
    /// Use `font(_:)` to apply a specific font to an individual
    /// Text View, or all of the text views in a container.
    ///
    /// In the example below, the first text field has a font set directly,
    /// while the font applied to the following container applies to all of the
    /// text views inside that container:
    ///
    ///     VStack {
    ///         Text("Font applied to a text view.")
    ///             .font(.largeTitle)
    ///
    ///         VStack {
    ///             Text("These two text views have the same font")
    ///             Text("applied to their parent view.")
    ///         }
    ///         .font(.system(size: 16, weight: .light, design: .default))
    ///     }
    ///
    ///
    /// ![Applying a font to a single text view or a view container](SkipUI-view-font.png)
    ///
    /// - Parameter font: The font to use when displaying this text.
    /// - Returns: Text that uses the font you specify.
    public func font(_ font: Font?) -> Text { fatalError() }

    /// Sets the font weight of the text.
    ///
    /// - Parameter weight: One of the available font weights.
    ///
    /// - Returns: Text that uses the font weight you specify.
    public func fontWeight(_ weight: Font.Weight?) -> Text { fatalError() }

    /// Sets the font width of the text.
    ///
    /// - Parameter width: One of the available font widths.
    ///
    /// - Returns: Text that uses the font width you specify, if available.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func fontWidth(_ width: Font.Width?) -> Text { fatalError() }

    /// Applies a bold font weight to the text.
    ///
    /// - Returns: Bold text.
    public func bold() -> Text { fatalError() }

    /// Applies a bold font weight to the text.
    ///
    /// - Parameter isActive: A Boolean value that indicates
    ///   whether text has bold styling.
    ///
    /// - Returns: Bold text.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func bold(_ isActive: Bool) -> Text { fatalError() }

    /// Applies italics to the text.
    ///
    /// - Returns: Italic text.
    public func italic() -> Text { fatalError() }

    /// Applies italics to the text.
    ///
    /// - Parameter isActive: A Boolean value that indicates
    ///   whether italic styling is added.
    ///
    /// - Returns: Italic text.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func italic(_ isActive: Bool) -> Text { fatalError() }

    /// Modifies the font of the text to use the fixed-width variant
    /// of the current font, if possible.
    ///
    /// - Parameter isActive: A Boolean value that indicates
    ///   whether monospaced styling is added. Default value is `true`.
    ///
    /// - Returns: Monospaced text.
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
    public func monospaced(_ isActive: Bool = true) -> Text { fatalError() }

    /// Sets the font design of the text.
    ///
    /// - Parameter design: One of the available font designs.
    ///
    /// - Returns: Text that uses the font design you specify.
    @available(iOS 16.1, macOS 13.0, tvOS 16.1, watchOS 9.1, *)
    public func fontDesign(_ design: Font.Design?) -> Text { fatalError() }

    /// Modifies the text view's font to use fixed-width digits, while leaving
    /// other characters proportionally spaced.
    ///
    /// This modifier only affects numeric characters, and leaves all other
    /// characters unchanged.
    ///
    /// The following example shows the effect of `monospacedDigit()` on a
    /// text view. It arranges two text views in a ``VStack``, each displaying
    /// a formatted date that contains many instances of the character 1.
    /// The second text view uses the `monospacedDigit()`. Because 1 is
    /// usually a narrow character in proportional fonts, applying the
    /// modifier widens all of the 1s, and the text view as a whole.
    /// The non-digit characters in the text view remain unaffected.
    ///
    ///     let myDate = DateComponents(
    ///         calendar: Calendar(identifier: .gregorian),
    ///         timeZone: TimeZone(identifier: "EST"),
    ///         year: 2011,
    ///         month: 1,
    ///         day: 11,
    ///         hour: 11,
    ///         minute: 11
    ///     ).date!
    ///
    ///     var body: some View {
    ///         VStack(alignment: .leading) {
    ///             Text(myDate.formatted(date: .long, time: .complete))
    ///                 .font(.system(size: 20))
    ///             Text(myDate.formatted(date: .long, time: .complete))
    ///                 .font(.system(size: 20))
    ///                 .monospacedDigit()
    ///         }
    ///         .padding()
    ///         .navigationTitle("monospacedDigit() Modifier")
    ///     }
    ///
    /// ![Two vertically stacked text views, displaying the date January 11,
    /// 2011, 11:11:00 AM. The second text view uses fixed-width digits, causing
    /// all of the 1s to be wider than in the first text
    /// view.](Text-monospacedDigit-1)
    ///
    /// If the base font of the text view doesn't support fixed-width digits,
    /// the font remains unchanged.
    ///
    /// - Returns: A text view with a modified font that uses fixed-width
    /// numeric characters, while leaving other characters proportionally
    /// spaced.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func monospacedDigit() -> Text { fatalError() }

    /// Applies a strikethrough to the text.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether the text has a
    ///     strikethrough applied.
    ///   - color: The color of the strikethrough. If `color` is `nil`, the
    ///     strikethrough uses the default foreground color.
    ///
    /// - Returns: Text with a line through its center.
    public func strikethrough(_ isActive: Bool = true, color: Color? = nil) -> Text { fatalError() }

    /// Applies a strikethrough to the text.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether strikethrough
    ///     is added. The default value is `true`.
    ///   - pattern: The pattern of the line.
    ///   - color: The color of the strikethrough. If `color` is `nil`, the
    ///     strikethrough uses the default foreground color.
    ///
    /// - Returns: Text with a line through its center.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func strikethrough(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern, color: Color? = nil) -> Text { fatalError() }

    /// Applies an underline to the text.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether the text has an
    ///     underline.
    ///   - color: The color of the underline. If `color` is `nil`, the
    ///     underline uses the default foreground color.
    ///
    /// - Returns: Text with a line running along its baseline.
    public func underline(_ isActive: Bool = true, color: Color? = nil) -> Text { fatalError() }

    /// Applies an underline to the text.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether underline
    ///     styling is added. The default value is `true`.
    ///   - pattern: The pattern of the line.
    ///   - color: The color of the underline. If `color` is `nil`, the
    ///     underline uses the default foreground color.
    ///
    /// - Returns: Text with a line running along its baseline.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func underline(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern, color: Color? = nil) -> Text { fatalError() }

    /// Sets the spacing, or kerning, between characters.
    ///
    /// Kerning defines the offset, in points, that a text view should shift
    /// characters from the default spacing. Use positive kerning to widen the
    /// spacing between characters. Use negative kerning to tighten the spacing
    /// between characters.
    ///
    ///     VStack(alignment: .leading) {
    ///         Text("ABCDEF").kerning(-3)
    ///         Text("ABCDEF")
    ///         Text("ABCDEF").kerning(3)
    ///     }
    ///
    /// The last character in the first case, which uses negative kerning,
    /// experiences cropping because the kerning affects the trailing edge of
    /// the text view as well.
    ///
    /// ![Three text views showing character groups, with progressively
    /// increasing spacing between the characters in each
    /// group.](SkipUI-Text-kerning-1.png)
    ///
    /// Kerning attempts to maintain ligatures. For example, the Hoefler Text
    /// font uses a ligature for the letter combination _ffl_, as in the word
    /// _raffle_, shown here with a small negative and a small positive kerning:
    ///
    /// ![Two text views showing the word raffle in the Hoefler Text font, the
    /// first with small negative and the second with small positive kerning.
    /// The letter combination ffl has the same shape in both variants because
    /// it acts as a ligature.](SkipUI-Text-kerning-2.png)
    ///
    /// The *ffl* letter combination keeps a constant shape as the other letters
    /// move together or apart. Beyond a certain point in either direction,
    /// however, kerning does disable nonessential ligatures.
    ///
    /// ![Two text views showing the word raffle in the Hoefler Text font, the
    /// first with large negative and the second with large positive kerning.
    /// The letter combination ffl does not act as a ligature in either
    /// case.](SkipUI-Text-kerning-3.png)
    ///
    /// - Important: If you add both the ``Text/tracking(_:)`` and
    ///   ``Text/kerning(_:)`` modifiers to a view, the view applies the
    ///   tracking and ignores the kerning.
    ///
    /// - Parameter kerning: The spacing to use between individual characters in
    ///   this text. Value of `0` sets the kerning to the system default value.
    ///
    /// - Returns: Text with the specified amount of kerning.
    public func kerning(_ kerning: CGFloat) -> Text { fatalError() }

    /// Sets the tracking for the text.
    ///
    /// Tracking adds space, measured in points, between the characters in the
    /// text view. A positive value increases the spacing between characters,
    /// while a negative value brings the characters closer together.
    ///
    ///     VStack(alignment: .leading) {
    ///         Text("ABCDEF").tracking(-3)
    ///         Text("ABCDEF")
    ///         Text("ABCDEF").tracking(3)
    ///     }
    ///
    /// The code above uses an unusually large amount of tracking to make it
    /// easy to see the effect.
    ///
    /// ![Three text views showing character groups with progressively
    /// increasing spacing between the characters in each
    /// group.](SkipUI-Text-tracking.png)
    ///
    /// The effect of tracking resembles that of the ``Text/kerning(_:)``
    /// modifier, but adds or removes trailing whitespace, rather than changing
    /// character offsets. Also, using any nonzero amount of tracking disables
    /// nonessential ligatures, whereas kerning attempts to maintain ligatures.
    ///
    /// - Important: If you add both the ``Text/tracking(_:)`` and
    ///   ``Text/kerning(_:)`` modifiers to a view, the view applies the
    ///   tracking and ignores the kerning.
    ///
    /// - Parameter tracking: The amount of additional space, in points, that
    ///   the view should add to each character cluster after layout. Value of `0`
    ///   sets the tracking to the system default value.
    ///
    /// - Returns: Text with the specified amount of tracking.
    public func tracking(_ tracking: CGFloat) -> Text { fatalError() }

    /// Sets the vertical offset for the text relative to its baseline.
    ///
    /// Change the baseline offset to move the text in the view (in points) up
    /// or down relative to its baseline. The bounds of the view expand to
    /// contain the moved text.
    ///
    ///     HStack(alignment: .top) {
    ///         Text("Hello")
    ///             .baselineOffset(-10)
    ///             .border(Color.red)
    ///         Text("Hello")
    ///             .border(Color.green)
    ///         Text("Hello")
    ///             .baselineOffset(10)
    ///             .border(Color.blue)
    ///     }
    ///     .background(Color(white: 0.9))
    ///
    /// By drawing a border around each text view, you can see how the text
    /// moves, and how that affects the view.
    ///
    /// ![Three text views, each with the word "Hello" outlined by a border and
    /// aligned along the top edges. The first and last are larger than the
    /// second, with padding inside the border above the word "Hello" in the
    /// first case, and padding inside the border below the word in the last
    /// case.](SkipUI-Text-baselineOffset.png)
    ///
    /// The first view, with a negative offset, grows downward to handle the
    /// lowered text. The last view, with a positive offset, grows upward. The
    /// enclosing ``HStack`` instance, shown in gray, ensures all the text views
    /// remain aligned at their top edge, regardless of the offset.
    ///
    /// - Parameter baselineOffset: The amount to shift the text vertically (up
    ///   or down) relative to its baseline.
    ///
    /// - Returns: Text that's above or below its baseline.
    public func baselineOffset(_ baselineOffset: CGFloat) -> Text { fatalError() }
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

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an alternative accessibility label
    /// to the text that is displayed. For example, you can give an alternate label to a navigation title:
    ///
    ///     var body: some View {
    ///         NavigationView {
    ///             ContentView()
    ///                 .navigationTitle(Text("􀈤").accessibilityLabel("Inbox"))
    ///         }
    ///     }
    ///
    /// You can't style the label that you add
    ///
    /// - Parameter label: The text view to add the label to.
    public func accessibilityLabel(_ label: Text) -> Text { fatalError() }

    /// Adds a label to the view that describes its contents.
    ///
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

    /// Adds a label to the view that describes its contents.
    ///
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
    /// - Parameter label: The string for the alternative accessibility label.
    public func accessibilityLabel<S>(_ label: S) -> Text where S : StringProtocol { fatalError() }
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

/// An alignment position for text along the horizontal axis.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public enum TextAlignment : Hashable, CaseIterable {

    case leading

    case center

    case trailing

    


    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [TextAlignment]

    /// A collection of all values of this type.
    public static var allCases: [TextAlignment] { get { fatalError() } }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension TextAlignment : Sendable {
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
    public var body: Body { get { return never() } }

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    public typealias Body = Never
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
