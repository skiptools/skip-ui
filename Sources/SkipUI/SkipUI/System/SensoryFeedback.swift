// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// Represents a type of haptic and/or audio feedback that can be played.
///
/// This feedback can be passed to `View.sensoryFeedback` to play it.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(xrOS, unavailable)
public struct SensoryFeedback : Equatable, Sendable {

    /// Indicates that a task or action has completed.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let success: SensoryFeedback = { fatalError() }()

    /// Indicates that a task or action has produced a warning of some kind.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let warning: SensoryFeedback = { fatalError() }()

    /// Indicates that an error has occurred.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let error: SensoryFeedback = { fatalError() }()

    /// Indicates that a UI element’s values are changing.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let selection: SensoryFeedback = { fatalError() }()

    /// Indicates that an important value increased above a significant
    /// threshold.
    ///
    /// Only plays feedback on watchOS.
    public static let increase: SensoryFeedback = { fatalError() }()

    /// Indicates that an important value decreased below a significant
    /// threshold.
    ///
    /// Only plays feedback on watchOS.
    public static let decrease: SensoryFeedback = { fatalError() }()

    /// Indicates that an activity started.
    ///
    /// Use this haptic when starting a timer or any other activity that can be
    /// explicitly started and stopped.
    ///
    /// Only plays feedback on watchOS.
    public static let start: SensoryFeedback = { fatalError() }()

    /// Indicates that an activity stopped.
    ///
    /// Use this haptic when stopping a timer or other activity that was
    /// previously started.
    ///
    /// Only plays feedback on watchOS.
    public static let stop: SensoryFeedback = { fatalError() }()

    /// Indicates the alignment of a dragged item.
    ///
    /// For example, use this pattern in a drawing app when the user drags a
    /// shape into alignment with another shape.
    ///
    /// Only plays feedback on macOS.
    public static let alignment: SensoryFeedback = { fatalError() }()

    /// Indicates movement between discrete levels of pressure.
    ///
    /// For example, as the user presses a fast-forward button on a video
    /// player, playback could increase or decrease and haptic feedback could be
    /// provided as different levels of pressure are reached.
    ///
    /// Only plays feedback on macOS.
    public static let levelChange: SensoryFeedback = { fatalError() }()

    /// Provides a physical metaphor you can use to complement a visual
    /// experience.
    ///
    /// Only plays feedback on iOS, watchOS, and macOS.
    public static let impact: SensoryFeedback = { fatalError() }()

    /// Provides a physical metaphor you can use to complement a visual
    /// experience.
    ///
    /// Not all platforms will play different feedback for different weights and
    /// intensities of impact.
    ///
    /// Only plays feedback on iOS, watchOS, and macOS.
    public static func impact(weight: SensoryFeedback.Weight = .medium, intensity: Double = 1.0) -> SensoryFeedback { fatalError() }

    /// Provides a physical metaphor you can use to complement a visual
    /// experience.
    ///
    /// Not all platforms will play different feedback for different
    /// flexibilities and intensities of impact.
    ///
    /// Only plays feedback on iOS, watchOS, and macOS.
    public static func impact(flexibility: SensoryFeedback.Flexibility, intensity: Double = 1.0) -> SensoryFeedback { fatalError() }

    /// The weight to be represented by a type of feedback.
    ///
    /// `Weight` values can be passed to
    /// `SensoryFeedback.impact(weight:intensity:)`.
    public struct Weight : Equatable, Sendable {

        /// Indicates a collision between small or lightweight UI objects.
        public static let light: SensoryFeedback.Weight = { fatalError() }()

        /// Indicates a collision between medium-sized or medium-weight UI
        /// objects.
        public static let medium: SensoryFeedback.Weight = { fatalError() }()

        /// Indicates a collision between large or heavyweight UI objects.
        public static let heavy: SensoryFeedback.Weight = { fatalError() }()

        
    }

    /// The flexibility to be represented by a type of feedback.
    ///
    /// `Flexibility` values can be passed to
    /// `SensoryFeedback.impact(flexibility:intensity:)`.
    public struct Flexibility : Equatable, Sendable {

        /// Indicates a collision between hard or inflexible UI objects.
        public static let rigid: SensoryFeedback.Flexibility = { fatalError() }()

        /// Indicates a collision between solid UI objects of medium
        /// flexibility.
        public static let solid: SensoryFeedback.Flexibility = { fatalError() }()

        /// Indicates a collision between soft or flexible UI objects.
        public static let soft: SensoryFeedback.Flexibility = { fatalError() }()

        
    }

    
}

#endif
