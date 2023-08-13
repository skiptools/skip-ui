// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// The size classes, like regular or small, that you can apply to controls
/// within a view.
@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
public enum ControlSize : CaseIterable, Sendable {

    /// A control version that is minimally sized.
    case mini

    /// A control version that is proportionally smaller size for space-constrained views.
    case small

    /// A control version that is the default size.
    case regular

    /// A control version that is prominently sized.
    @available(macOS 11.0, *)
    case large

    @available(iOS 17.0, macOS 14.0, watchOS 10.0, xrOS 1.0, *)
    case extraLarge

    /// A collection of all values of this type.
    public static var allCases: [ControlSize] { get { fatalError() } }

    


    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ControlSize]

}

@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ControlSize : Equatable {
}

@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ControlSize : Hashable {
}


#endif
