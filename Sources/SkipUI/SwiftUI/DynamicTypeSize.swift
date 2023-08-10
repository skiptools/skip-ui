// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A Dynamic Type size, which specifies how large scalable content should be.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum DynamicTypeSize : Hashable, Comparable, CaseIterable, Sendable {

    /// An extra small size.
    case xSmall

    /// A small size.
    case small

    /// A medium size.
    case medium

    /// A large size.
    case large

    /// An extra large size.
    case xLarge

    /// An extra extra large size.
    case xxLarge

    /// An extra extra extra large size.
    case xxxLarge

    /// The first accessibility size.
    case accessibility1

    /// The second accessibility size.
    case accessibility2

    /// The third accessibility size.
    case accessibility3

    /// The fourth accessibility size.
    case accessibility4

    /// The fifth accessibility size.
    case accessibility5

    /// A Boolean value indicating whether the size is one that is associated
    /// with accessibility.
    public var isAccessibilitySize: Bool { get { fatalError() } }

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (a: DynamicTypeSize, b: DynamicTypeSize) -> Bool { fatalError() }

    


    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [DynamicTypeSize]

    /// A collection of all values of this type.
    public static var allCases: [DynamicTypeSize] { get { fatalError() } }

}

#endif
