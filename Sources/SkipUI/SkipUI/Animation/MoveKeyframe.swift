// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// A keyframe that immediately moves to the given value without interpolating.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct MoveKeyframe<Value> : KeyframeTrackContent where Value : Animatable {

    /// Creates a new keyframe using the given value.
    ///
    /// - Parameters:
    ///   - to: The value of the keyframe.
    public init(_ to: Value) { fatalError() }

    public typealias Value = Value
    public typealias Body = MoveKeyframe<Value>
    public var body: Body { fatalError() }
}

#endif
