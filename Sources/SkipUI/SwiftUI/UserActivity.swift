// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if canImport(Foundation)
import class Foundation.NSUserActivity

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension NSUserActivity {

//    /// Error types when getting/setting typed payload
//    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//    public enum TypedPayloadError : Error {
//
//        /// UserInfo is empty or invalid
//        case invalidContent
//
//        /// Content failed to encode into a valid Dictionary
//        case encodingError
//
//        /// Returns a Boolean value indicating whether two values are equal.
//        ///
//        /// Equality is the inverse of inequality. For any values `a` and `b`,
//        /// `a == b` implies that `a != b` is `false`.
//        ///
//        /// - Parameters:
//        ///   - lhs: A value to compare.
//        ///   - rhs: Another value to compare.
//        public static func == (a: NSUserActivity.TypedPayloadError, b: NSUserActivity.TypedPayloadError) -> Bool { fatalError() }
//
//        /// Hashes the essential components of this value by feeding them into the
//        /// given hasher.
//        ///
//        /// Implement this method to conform to the `Hashable` protocol. The
//        /// components used for hashing must be the same as the components compared
//        /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
//        /// with each of these components.
//        ///
//        /// - Important: In your implementation of `hash(into:)`,
//        ///   don't call `finalize()` on the `hasher` instance provided,
//        ///   or replace it with a different instance.
//        ///   Doing so may become a compile-time error in the future.
//        ///
//        /// - Parameter hasher: The hasher to use when combining the components
//        ///   of this instance.
//        public func hash(into hasher: inout Hasher) { fatalError() }
//
//        /// The hash value.
//        ///
//        /// Hash values are not guaranteed to be equal across different executions of
//        /// your program. Do not save hash values to use during a future execution.
//        ///
//        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
//        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
//        ///   The compiler provides an implementation for `hashValue` for you.
//        public var hashValue: Int { get { fatalError() } }
//    }

    /// Given a Codable Swift type, return an instance decoded from the
    /// NSUserActivity's userInfo dictionary
    ///
    /// - Parameter type: the instance type to be decoded from userInfo
    /// - Returns: the type safe instance or raises if it can't be decoded
    public func typedPayload<T>(_ type: T.Type) throws -> T where T : Decodable, T : Encodable { fatalError() }

    /// Given an instance of a Codable Swift type, encode it into the
    /// NSUserActivity's userInfo dictionary
    ///
    /// - Parameter payload: the instance to be converted to userInfo
    public func setTypedPayload<T>(_ payload: T) throws where T : Decodable, T : Encodable { fatalError() }
}
#endif
