// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation

public struct LocalizedStringKey : ExpressibleByStringInterpolation, Equatable {
    /// A type that represents a string literal.
    ///
    /// Valid types for `StringLiteralType` are `String` and `StaticString`.
    public typealias StringLiteralType = String

    var stringInterpolation: LocalizedStringKey.StringInterpolation

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

    public init(resource: LocalizedStringResource) {
        var interp = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 0)
        #if SKIP
        // For (presumably) historical reasons, SwiftUI.LocalizedStringKey and Foundation.LocalizedStringResource are both StringInterpolationProtocol, but have different implementation, so copy the underlying fields over manually
        interp.pattern = resource.keyAndValue.stringInterpolation.pattern
        interp.values.addAll(resource.keyAndValue.stringInterpolation.values)
        #endif
        self.stringInterpolation = interp
    }

    /// Returns the pattern string to use for looking up localized values in the `.xcstrings` file.
    ///
    /// Literal percent signs are stored doubled so a later `String.format` treats them as text.
    /// Catalog keys and Markdown use `localizedPattern`, where those doubled percents are one character again.
    public var patternFormat: String {
        stringInterpolation.pattern
    }

    /// The key and display string, with a literal percent restored from the `%%` format escape.
    ///
    /// `Text("Perfect! 100% **bold**")` looks up and renders `100%`, not `100%%`.
    /// Format specifiers such as `%@` are left intact. An authored `100%%` is stored
    /// as `100%%%%` and comes back as `100%%` — one unescape, not two.
    public var localizedPattern: String {
        return stringInterpolation.pattern.replacingOccurrences(of: "%%", with: "%")
    }

    /// The string drawn when this key has no interpolations.
    ///
    /// `resolvedFormat` is the catalog value, or `localizedPattern` when the key is
    /// missing. That string is already the literal to draw. `kotlinFormatString`
    /// does not turn a lone `%` back into `%%`, so collapsing `%` here would draw
    /// an authored `100%%` as `100%`.
    public func noInterpolationDisplay(resolvedFormat: String) -> String {
        return resolvedFormat
    }

    #if SKIP
    // FIXME: We should be able to just declare the `StringInterpolation` struct to conform to the protocol (since we don't need a separately named "LocalizedStringInterpolation"), but if we don't do this typealias, Kotlin complains: "Unresolved reference: StringInterpolation"
    public typealias StringInterpolation = LocalizedStringKey.StringInterpolation
    #endif

    public struct StringInterpolation : StringInterpolationProtocol, Equatable {
        /// The type that should be used for literal segments.
        public typealias StringLiteralType = String

        #if SKIP
        let values: MutableList<Any> = mutableListOf()
        #endif
        var pattern = ""

        public init(literalCapacity: Int, interpolationCount: Int) {
        }

        init(pattern: String, values: [Any]?) {
            self.pattern = pattern
            #if SKIP
            if let values {
                self.values.addAll(values)
            }
            #endif
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

        public mutating func appendInterpolation<T>(_ value: T) {
            #if SKIP
            values.add(value as! Any)
            #endif
            pattern += "%@"
        }
    }
}

#endif
