// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import typealias Foundation.TimeInterval

/// A collection of events that target a specific view.
///
/// You can look up a specific event using its `ID`
/// or iterate over all touches in the collection to apply logic depending
/// on the touch's states.
@available(xrOS 1.0, iOS 17.0, macOS 14.0, watchOS 10.0, *)
@available(tvOS, unavailable)
public struct SpatialEventCollection : Collection {

    /// A spatial event generated from a finger, pointing device, or other input mechanism
    /// that can drive gestures in the system.
    @available(xrOS 1.0, iOS 17.0, macOS 14.0, watchOS 10.0, *)
    @available(tvOS, unavailable)
    public struct Event : Identifiable {

        /// A value that uniquely identifies an event over the course of its lifetime.
        public struct ID : Hashable {

        
            

                }

        /// A kind of spatial event used to differentiate between different
        /// input sources or modes.
        public enum Kind : Hashable {

            /// An event generated from a touch directly targeting content.
            case touch

            /// An event generated from a pencil making contact with content.
            @available(iOS 17.0, *)
            @available(macOS, unavailable)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            @available(xrOS, unavailable)
            case pencil

            /// An event representing a click-based, indirect input device
            /// describing the input sequence from click to click release.
            @available(xrOS 1.0, iOS 17.0, macOS 14.0, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            case pointer

            

        
                }

        /// The phase of a particular state of the event.
        public enum Phase {

            /// The phase is active and the state associated with it is
            /// guaranteed to produce at least one more update.
            case active

            /// The state associated with this phase ended normally
            /// and won't produce any more updates.
            case ended

            /// The state associated with this phase was canceled
            /// and won't produce any more updates.
            case cancelled

            

        
                }

        /// A pose describing the input device such as a pencil
        /// or hand controlling the event.
        public struct InputDevicePose {

            /// Altitude angle.
            ///
            /// An angle of zero indicates that the device is parallel to the content,
            /// while 90 degrees indicates that it is normal to the content surface.
            public var altitude: Angle { get { fatalError() } }

            /// Azimuth angle.
            ///
            /// An angle of zero points along the content's positive X axis.
            public var azimuth: Angle { get { fatalError() } }
        }

        /// An identifier that uniquely identifies this event over its lifetime.
        public var id: SpatialEventCollection.Event.ID { get { fatalError() } }

        /// The time this `Event` was processed.
        public var timestamp: TimeInterval { get { fatalError() } }

        /// Indicates what input source generated this event.
        public var kind: SpatialEventCollection.Event.Kind { get { fatalError() } }

        /// The 2D location of the touch.
        public var location: CGPoint { get { fatalError() } }

        /// The phase of the event.
        public var phase: SpatialEventCollection.Event.Phase { get { fatalError() } }

        /// The set of active modifier keys at the time of this event.
        public var modifierKeys: EventModifiers { get { fatalError() } }

        #if canImport(UIKit)
        /// The 3D position and orientation of the device controlling the touch, if one exists.
        @available(xrOS 1.0, iOS 17.0, *)
        @available(macOS, unavailable)
        @available(watchOS, unavailable)
        @available(tvOS, unavailable)
        public var inputDevicePose: SpatialEventCollection.Event.InputDevicePose?
        #endif
    }

    /// Retrieves an event using its unique identifier.
    ///
    /// Returns `nil` if the `Event` no longer exists in the collection.
    public subscript(index: SpatialEventCollection.Event.ID) -> SpatialEventCollection.Event? { get { fatalError() } }

    /// An iterator over all events in the collection.
    public struct Iterator : IteratorProtocol {

        /// The next `Event` in the sequence, if one exists.
        public mutating func next() -> SpatialEventCollection.Event? { fatalError() }

        /// The type of element traversed by the iterator.
        public typealias Element = SpatialEventCollection.Event
    }

    /// Makes an iterator over all events in the collection.
    public func makeIterator() -> SpatialEventCollection.Iterator { fatalError() }

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public struct Index : Comparable {

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
        public static func < (lhs: SpatialEventCollection.Index, rhs: SpatialEventCollection.Index) -> Bool { fatalError() }

        
    }

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: SpatialEventCollection.Index { get { fatalError() } }

    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    ///
    /// When you need a range that includes the last element of a collection, use
    /// the half-open range operator (`..<`) with `endIndex`. The `..<` operator
    /// creates a range that doesn't include the upper bound, so it's always
    /// safe to use with `endIndex`. For example:
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let index = numbers.firstIndex(of: 30) {
    ///         print(numbers[index ..< numbers.endIndex])
    ///     }
    ///     // Prints "[30, 40, 50]"
    ///
    /// If the collection is empty, `endIndex` is equal to `startIndex`.
    public var endIndex: SpatialEventCollection.Index { get { fatalError() } }

    /// Accesses the element at the specified position.
    ///
    /// The following example accesses an element of an array through its
    /// subscript to print its value:
    ///
    ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     print(streets[1])
    ///     // Prints "Bryant"
    ///
    /// You can subscript a collection with any valid index other than the
    /// collection's end index. The end index refers to the position one past
    /// the last element of a collection, so it doesn't correspond with an
    /// element.
    ///
    /// - Parameter position: The position of the element to access. `position`
    ///   must be a valid index of the collection that is not equal to the
    ///   `endIndex` property.
    ///
    /// - Complexity: O(1)
    public subscript(position: SpatialEventCollection.Index) -> SpatialEventCollection.Event { get { fatalError() } }

    /// Returns the position immediately after the given index.
    ///
    /// The successor of an index must be well defined. For an index `i` into a
    /// collection `c`, calling `c.index(after: i)` returns the same index every
    /// time.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: SpatialEventCollection.Index) -> SpatialEventCollection.Index { fatalError() }

    /// A type representing the sequence's elements.
    public typealias Element = SpatialEventCollection.Event

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = DefaultIndices<SpatialEventCollection>

    /// A collection representing a contiguous subrange of this collection's
    /// elements. The subsequence shares indices with the original collection.
    ///
    /// The default subsequence type for collections that don't define their own
    /// is `Slice`.
    public typealias SubSequence = Slice<SpatialEventCollection>
}

@available(macOS 14.0, *)
extension SpatialEventCollection.Event {
}

@available(xrOS 1.0, iOS 17.0, macOS 14.0, watchOS 10.0, *)
@available(tvOS, unavailable)
extension SpatialEventCollection.Event.Phase : Equatable {
}

@available(xrOS 1.0, iOS 17.0, macOS 14.0, watchOS 10.0, *)
@available(tvOS, unavailable)
extension SpatialEventCollection.Event.Phase : Hashable {
}

#endif
