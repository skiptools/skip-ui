// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct SensoryFeedback : RawRepresentable, Equatable, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let success = SensoryFeedback(rawValue: 1)
    public static let warning = SensoryFeedback(rawValue: 2)
    public static let error = SensoryFeedback(rawValue: 3)
    public static let selection = SensoryFeedback(rawValue: 4)
    public static let increase = SensoryFeedback(rawValue: 5)
    public static let decrease = SensoryFeedback(rawValue: 6)
    public static let start = SensoryFeedback(rawValue: 7)
    public static let stop = SensoryFeedback(rawValue: 8)
    public static let alignment = SensoryFeedback(rawValue: 9)
    public static let levelChange = SensoryFeedback(rawValue: 10)
    public static let impact = SensoryFeedback(rawValue: 11)

    @available(*, unavailable)
    public static func impact(weight: SensoryFeedback.Weight = .medium, intensity: Double = 1.0) -> SensoryFeedback {
        fatalError()
    }

    @available(*, unavailable)
    public static func impact(flexibility: SensoryFeedback.Flexibility, intensity: Double = 1.0) -> SensoryFeedback {
        fatalError()
    }

    public enum Weight : Equatable, Sendable {
        case light
        case medium
        case heavy
    }

    public enum Flexibility : Equatable, Sendable {
        case rigid
        case solid
        case soft
    }
}
