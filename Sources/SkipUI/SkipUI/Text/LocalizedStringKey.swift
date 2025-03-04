// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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
