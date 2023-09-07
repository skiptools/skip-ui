// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import class Foundation.Formatter
import class Foundation.NSObject
import protocol Foundation.ReferenceConvertible
import protocol Foundation.FormatStyle
import protocol Foundation.ParseableFormatStyle
import protocol Foundation._FormatSpecifiable
import struct Foundation.Date
import struct Foundation.DateComponents
import struct Foundation.DateInterval
import struct Foundation.AttributedString
import struct Foundation.LocalizedStringResource
#else
#endif

/// The key used to look up an entry in a strings file or strings dictionary
/// file.
///
/// Initializers for several SkipUI types -- such as ``Text``, ``Toggle``,
/// ``Picker`` and others --  implicitly look up a localized string when you
/// provide a string literal. When you use the initializer `Text("Hello")`,
/// SkipUI creates a `LocalizedStringKey` for you and uses that to look up a
/// localization of the `Hello` string. This works because `LocalizedStringKey`
/// conforms to
/// .
///
/// Types whose initializers take a `LocalizedStringKey` usually have
/// a corresponding initializer that accepts a parameter that conforms to
/// . Passing
/// a `String` variable to these initializers avoids localization, which is
/// usually appropriate when the variable contains a user-provided value.
///
/// As a general rule, use a string literal argument when you want
/// localization, and a string variable argument when you don't. In the case
/// where you want to localize the value of a string variable, use the string to
/// create a new `LocalizedStringKey` instance.
///
/// The following example shows how to create ``Text`` instances both
/// with and without localization. The title parameter provided to the
/// ``Section`` is a literal string, so SkipUI creates a
/// `LocalizedStringKey` for it. However, the string entries in the
/// `messageStore.today` array are `String` variables, so the ``Text`` views
/// in the list use the string values verbatim.
///
///     List {
///         Section(header: Text("Today")) {
///             ForEach(messageStore.today) { message in
///                 Text(message.title)
///             }
///         }
///     }
///
/// If the app is localized into Japanese with the following
/// translation of its `Localizable.strings` file:
///
/// ```other
/// "Today" = "今日";
/// ```
///
/// When run in Japanese, the example produces a
/// list like the following, localizing "Today" for the section header, but not
/// the list items.
///
/// ![A list with a single section header displayed in Japanese.
/// The items in the list are all in English: New for Monday, Account update,
/// and Server
/// maintenance.](SkipUI-LocalizedStringKey-Today-List-Japanese.png)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct LocalizedStringKey : Equatable {
    public var value: String

    /// Creates a localized string key from the given string value.
    ///
    /// - Parameter value: The string to use as a localization key.
    public init(_ value: String) {
        self.value = value
    }

    /// Creates a localized string key from the given string literal.
    ///
    /// - Parameter value: The string literal to use as a localization key.
    public init(stringLiteral value: String) {
        self.value = value
    }
}

#if !SKIP
extension LocalizedStringKey : ExpressibleByStringInterpolation {

    /// Creates a localized string key from the given string interpolation.
    ///
    /// To create a localized string key from a string interpolation, use
    /// the `\()` string interpolation syntax. Swift matches the parameter
    /// types in the expression to one of the `appendInterpolation` methods
    /// in ``LocalizedStringKey/StringInterpolation``. The interpolated
    /// types can include numeric values, Foundation types, and SkipUI
    /// ``Text`` and ``Image`` instances.
    ///
    /// The following example uses a string interpolation with two arguments:
    /// an unlabeled
    /// and a ``Text/DateStyle`` labeled `style`. The compiler maps these to the
    /// method
    /// ``LocalizedStringKey/StringInterpolation/appendInterpolation(_:style:)``
    /// as it builds the string that it creates the
    /// ``LocalizedStringKey`` with.
    ///
    ///     let key = LocalizedStringKey("Date is \(company.foundedDate, style: .offset)")
    ///     let text = Text(key) // Text contains "Date is +45 years"
    ///
    /// You can write this example more concisely, implicitly creating a
    /// ``LocalizedStringKey`` as the parameter to the ``Text``
    /// initializer:
    ///
    ///     let text = Text("Date is \(company.foundedDate, style: .offset)")
    ///
    /// - Parameter stringInterpolation: The string interpolation to use as the
    ///   localization key.
    public init(stringInterpolation: LocalizedStringKey.StringInterpolation) { fatalError() }

    /// Represents the contents of a string literal with interpolations
    /// while it’s being built, for use in creating a localized string key.
    public struct StringInterpolation : StringInterpolationProtocol {

        /// Creates an empty instance ready to be filled with string literal content.
        ///
        /// Don't call this initializer directly. Instead, initialize a variable or
        /// constant using a string literal with interpolated expressions.
        ///
        /// Swift passes this initializer a pair of arguments specifying the size of
        /// the literal segments and the number of interpolated segments. Use this
        /// information to estimate the amount of storage you will need.
        ///
        /// - Parameter literalCapacity: The approximate size of all literal segments
        ///   combined. This is meant to be passed to `String.reserveCapacity(_:)`;
        ///   it may be slightly larger or smaller than the sum of the counts of each
        ///   literal segment.
        /// - Parameter interpolationCount: The number of interpolations which will be
        ///   appended. Use this value to estimate how much additional capacity will
        ///   be needed for the interpolated segments.
        public init(literalCapacity: Int, interpolationCount: Int) { fatalError() }

        /// Appends a literal string.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameter literal: The literal string to append.
        public mutating func appendLiteral(_ literal: String) { fatalError() }

        /// Appends a literal string segment to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameter string: The literal string to append.
        public mutating func appendInterpolation(_ string: String) { fatalError() }

        /// Appends an optionally-formatted instance of a Foundation type
        /// to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameters:
        ///   - subject: The Foundation object to append.
        ///   - formatter: A formatter to convert `subject` to a string
        ///     representation.
        public mutating func appendInterpolation<Subject>(_ subject: Subject, formatter: Formatter? = nil) where Subject : ReferenceConvertible { fatalError() }

        /// Appends an optionally-formatted instance of an Objective-C subclass
        /// to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// The following example shows how to use a
            /// value and a
            /// to create a ``LocalizedStringKey`` that uses the formatter
        /// style
            /// when generating the measurement's string representation. Rather than
        /// calling `appendInterpolation(_:formatter)` directly, the code
        /// gets the formatting behavior implicitly by using the `\()`
        /// string interpolation syntax.
        ///
        ///     let siResistance = Measurement(value: 640, unit: UnitElectricResistance.ohms)
        ///     let formatter = MeasurementFormatter()
        ///     formatter.unitStyle = .long
        ///     let key = LocalizedStringKey ("Resistance: \(siResistance, formatter: formatter)")
        ///     let text1 = Text(key) // Text contains "Resistance: 640 ohms"
        ///
        /// - Parameters:
        ///   - subject: An
        ///     to append.
        ///   - formatter: A formatter to convert `subject` to a string
        ///     representation.
        public mutating func appendInterpolation<Subject>(_ subject: Subject, formatter: Formatter? = nil) where Subject : NSObject { fatalError() }

        /// Appends the formatted representation  of a nonstring type
        /// supported by a corresponding format style.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// The following example shows how to use a string interpolation to
        /// format a
            /// with a
        ///  and
        /// append it to static text. The resulting interpolation implicitly
        /// creates a ``LocalizedStringKey``, which a ``Text`` uses to provide
        /// its content.
        ///
        ///     Text("The time is \(myDate, format: Date.FormatStyle(date: .omitted, time:.complete))")
        ///
        /// - Parameters:
        ///   - input: The instance to format and append.
        ///   - format: A format style to use when converting `input` into a string
        ///   representation.
        @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
        public mutating func appendInterpolation<F>(_ input: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String { fatalError() }

        /// Appends a type, convertible to a string by using a default format
        /// specifier, to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameters:
        ///   - value: A primitive type to append, such as
        ///     ,
        ///     , or
        ///     .
        public mutating func appendInterpolation<T>(_ value: T) where T : _FormatSpecifiable { fatalError() }

        /// Appends a type, convertible to a string with a format specifier,
        /// to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameters:
        ///   - value: The value to append.
        ///   - specifier: A format specifier to convert `subject` to a string
        ///     representation, like `%f`
        public mutating func appendInterpolation<T>(_ value: T, specifier: String) where T : _FormatSpecifiable { fatalError() }

        /// Appends the string displayed by a text view to a string
        /// interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// - Parameters:
        ///   - value: A ``Text`` instance to append.
        @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
        public mutating func appendInterpolation(_ text: Text) { fatalError() }

        /// Appends an attributed string to a string interpolation.
        ///
        /// Don't call this method directly; it's used by the compiler when
        /// interpreting string interpolations.
        ///
        /// The following example shows how to use a string interpolation to
        /// format an
            /// and append it to static text. The resulting interpolation implicitly
        /// creates a ``LocalizedStringKey``, which a ``Text`` view uses to provide
        /// its content.
        ///
        ///     struct ContentView: View {
        ///
        ///         var nextDate: AttributedString {
        ///             var result = Calendar.current
        ///                 .nextWeekend(startingAfter: Date.now)!
        ///                 .start
        ///                 .formatted(
        ///                     .dateTime
        ///                     .month(.wide)
        ///                     .day()
        ///                     .attributed
        ///                 )
        ///             result.backgroundColor = .green
        ///             result.foregroundColor = .white
        ///             return result
        ///         }
        ///
        ///         var body: some View {
        ///             Text("Our next catch-up is on \(nextDate)!")
        ///         }
        ///     }
        ///
        /// For this example, assume that the app runs on a device set to a
        /// Russian locale, and has the following entry in a Russian-localized
        /// `Localizable.strings` file:
        ///
        ///     "Our next catch-up is on %@!" = "Наша следующая встреча состоится %@!";
        ///
        /// The attributed string `nextDate` replaces the format specifier
        /// `%@`,  maintaining its color and date-formatting attributes, when
        /// the ``Text`` view renders its contents:
        ///
        /// ![A text view with Russian text, ending with a date that uses white
        /// text on a green
        /// background.](LocalizedStringKey-AttributedString-Russian)
        ///
        /// - Parameter attributedString: The attributed string to append.
        @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
        public mutating func appendInterpolation(_ attributedString: AttributedString) { fatalError() }

        /// The type that should be used for literal segments.
        public typealias StringLiteralType = String
    }

    

    /// A type that represents an extended grapheme cluster literal.
    ///
    /// Valid types for `ExtendedGraphemeClusterLiteralType` are `Character`,
    /// `String`, and `StaticString`.
    public typealias ExtendedGraphemeClusterLiteralType = String

    /// A type that represents a string literal.
    ///
    /// Valid types for `StringLiteralType` are `String` and `StaticString`.
    public typealias StringLiteralType = String

    /// A type that represents a Unicode scalar literal.
    ///
    /// Valid types for `UnicodeScalarLiteralType` are `Unicode.Scalar`,
    /// `Character`, `String`, and `StaticString`.
    public typealias UnicodeScalarLiteralType = String
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LocalizedStringKey.StringInterpolation {

    /// Appends an image to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameter image: The image to append.
    public mutating func appendInterpolation(_ image: Image) { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LocalizedStringKey.StringInterpolation {

    /// Appends a formatted date to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameters:
    ///   - date: The date to append.
    ///   - style: A predefined style to format the date with.
    public mutating func appendInterpolation(_ date: Date, style: Text.DateStyle) { fatalError() }

    /// Appends a date range to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameter dates: The closed range of dates to append.
    public mutating func appendInterpolation(_ dates: ClosedRange<Date>) { fatalError() }

    /// Appends a date interval to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameter interval: The date interval to append.
    public mutating func appendInterpolation(_ interval: DateInterval) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension LocalizedStringKey.StringInterpolation {

    /// Appends a timer interval to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameters:
    ///     - timerInterval: The interval between where to run the timer.
    ///     - pauseTime: If present, the date at which to pause the timer.
    ///         The default is `nil` which indicates to never pause.
    ///     - countsDown: Whether to count up or down. The default is `true`.
    ///     - showsHours: Whether to include an hours component if there are
    ///         more than 60 minutes left on the timer. The default is `true`.
    public mutating func appendInterpolation(timerInterval: ClosedRange<Date>, pauseTime: Date? = nil, countsDown: Bool = true, showsHours: Bool = true) { fatalError() }
}

extension LocalizedStringKey.StringInterpolation {

    /// Appends the localized string resource to a string interpolation.
    ///
    /// Don't call this method directly; it's used by the compiler when
    /// interpreting string interpolations.
    ///
    /// - Parameters:
    ///   - value: The localized string resource to append.
    @available(iOS 16.0, macOS 13, tvOS 16.0, watchOS 9.0, *)
    public mutating func appendInterpolation(_ resource: LocalizedStringResource) { fatalError() }
}

#endif
