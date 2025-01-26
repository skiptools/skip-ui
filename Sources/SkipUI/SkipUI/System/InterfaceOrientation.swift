// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if false
/// The orientation of the interface from the user's perspective.
///
/// By default, device previews appear right side up, using orientation
/// ``InterfaceOrientation/portrait``. You can change the orientation
/// with a call to the ``View/previewInterfaceOrientation(_:)`` modifier:
///
///     struct CircleImage_Previews: PreviewProvider {
///         static var previews: some View {
///             CircleImage()
///                 .previewInterfaceOrientation(.landscapeRight)
///         }
///     }
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct InterfaceOrientation : CaseIterable, Identifiable, Equatable, Sendable {

    /// A collection of all values of this type.
    public static var allCases: [InterfaceOrientation] { get { fatalError() } }

    /// The stable identity of the entity associated with this instance.
    public var id: String { get { fatalError() } }

    /// The device is in portrait mode, with the top of the device on top.
    public static let portrait: InterfaceOrientation = { fatalError() }()

    /// The device is in portrait mode, but is upside down.
    public static let portraitUpsideDown: InterfaceOrientation = { fatalError() }()

    /// The device is in landscape mode, with the top of the device on the left.
    public static let landscapeLeft: InterfaceOrientation = { fatalError() }()

    /// The device is in landscape mode, with the top of the device on the right.
    public static let landscapeRight: InterfaceOrientation = { fatalError() }()

    

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [InterfaceOrientation]

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    public typealias ID = String
}
#endif
