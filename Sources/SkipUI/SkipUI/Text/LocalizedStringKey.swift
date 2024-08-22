// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

public struct LocalizedStringKey : ExpressibleByStringInterpolation, Equatable {
    /// A type that represents a string literal.
    ///
    /// Valid types for `StringLiteralType` are `String` and `StaticString`.
    public typealias StringLiteralType = String

    internal var stringInterpolation: LocalizedStringKey.StringInterpolation

    #if SKIP
    public init(_ string: String) {
        self.init(stringLiteral: string)
    }
    #else
    public init(_ interpolation: LocalizedStringKey.StringInterpolation) {
        self.stringInterpolation = interpolation
    }
    #endif

    public init(stringLiteral value: String) {
        var interp = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 0)
        interp.appendLiteral(value)
        self.stringInterpolation = interp
    }

    public init(stringInterpolation: LocalizedStringKey.StringInterpolation) {
        self.stringInterpolation = stringInterpolation
    }

    /// Returns the pattern string to use for looking up localized values in the `.xcstrings` file
    public var patternFormat: String {
        stringInterpolation.pattern
    }

    #if SKIP
    // FIXME: We should be able to just declare the `StringInterpolation` struct to conform to the protocol (since we don't need a separately named "LocalizedStringInterpolation"), but if we don't do this typealias, Kotlin complains: "Unresolved reference: StringInterpolation"
    public typealias StringInterpolation = LocalizedStringKey.StringInterpolation
    #endif

    public struct StringInterpolation : StringInterpolationProtocol, Equatable {
        /// The type that should be used for literal segments.
        public typealias StringLiteralType = String

        #if SKIP
        let values: MutableList<AnyHashable> = mutableListOf()
        #endif
        var pattern = ""

        public init(literalCapacity: Int, interpolationCount: Int) {
        }

        public mutating func appendLiteral(_ literal: String) {
            // need to escape out Java-specific format marker
            pattern += literal.replacingOccurrences(of: "%", with: "%%")
        }

        public mutating func appendInterpolation(_ string: String) {
            #if SKIP
            values.add(string)
            #endif
            pattern += "%@"
        }

        public mutating func appendInterpolation(_ int: Int) {
            #if SKIP
            values.add(int)
            #endif
            pattern += "%lld"
        }

        public mutating func appendInterpolation(_ int: Int16) {
            #if SKIP
            values.add(int)
            #endif
            pattern += "%d"
        }

        public mutating func appendInterpolation(_ int: Int64) {
            #if SKIP
            values.add(int)
            #endif
            pattern += "%lld"
        }

        public mutating func appendInterpolation(_ int: UInt) {
            #if SKIP
            values.add(int)
            #endif
            pattern += "%llu"
        }

        public mutating func appendInterpolation(_ int: UInt16) {
            #if SKIP
            values.add(int)
            #endif
            pattern += "%u"
        }

        public mutating func appendInterpolation(_ int: UInt64) {
            #if SKIP
            values.add(int)
            #endif
            pattern += "%llu"
        }

        public mutating func appendInterpolation(_ double: Double) {
            #if SKIP
            values.add(double)
            #endif
            pattern += "%lf"
        }

        public mutating func appendInterpolation(_ float: Float) {
            #if SKIP
            values.add(float)
            #endif
            pattern += "%f"
        }

        public mutating func appendInterpolation<T: Hashable>(_ value: T) {
            #if SKIP
            values.add(value as AnyHashable)
            #endif
            pattern += "%@"
        }

        //public mutating func appendInterpolation(_ string: String) { fatalError() }
        //public mutating func appendInterpolation<Subject>(_ subject: Subject, formatter: Formatter? = nil) where Subject : ReferenceConvertible { fatalError() }
        //public mutating func appendInterpolation<Subject>(_ subject: Subject, formatter: Formatter? = nil) where Subject : NSObject { fatalError() }
        //public mutating func appendInterpolation<F>(_ input: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String { fatalError() }
        //public mutating func appendInterpolation<T>(_ value: T) where T : _FormatSpecifiable { fatalError() }
        //public mutating func appendInterpolation<T>(_ value: T, specifier: String) where T : _FormatSpecifiable { fatalError() }
        //public mutating func appendInterpolation(_ text: Text) { fatalError() }
        //public mutating func appendInterpolation(_ attributedString: AttributedString) { fatalError() }
        //public mutating func appendInterpolation(_ image: Image) { fatalError() }
        //public mutating func appendInterpolation(_ date: Date, style: Text.DateStyle) { fatalError() }
        //public mutating func appendInterpolation(_ dates: ClosedRange<Date>) { fatalError() }
        //public mutating func appendInterpolation(_ interval: DateInterval) { fatalError() }
        //public mutating func appendInterpolation(timerInterval: ClosedRange<Date>, pauseTime: Date? = nil, countsDown: Bool = true, showsHours: Bool = true) { fatalError() }
        //public mutating func appendInterpolation(_ resource: LocalizedStringResource) { fatalError() }
    }
}
