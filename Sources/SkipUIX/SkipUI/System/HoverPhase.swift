// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// The current hovering state and value of the pointer.
///
/// When you use the ``View/onContinuousHover(coordinateSpace:perform:)``
/// modifier, you can handle the hovering state using the `action` closure.
/// SkipUI calls the closure with a phase value to indicate the current
/// hovering state. The following example updates `hoverLocation` and
/// `isHovering` based on the phase provided to the closure:
///
///     @State private var hoverLocation: CGPoint = .zero
///     @State private var isHovering = false
///
///     var body: some View {
///         VStack {
///             Color.red
///                 .frame(width: 400, height: 400)
///                 .onContinuousHover { phase in
///                     switch phase {
///                     case .active(let location):
///                         hoverLocation = location
///                         isHovering = true
///                     case .ended:
///                         isHovering = false
///                     }
///                 }
///                 .overlay {
///                     Rectangle()
///                         .frame(width: 50, height: 50)
///                         .foregroundColor(isHovering ? .green : .blue)
///                         .offset(x: hoverLocation.x, y: hoverLocation.y)
///                 }
///         }
///     }
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
@available(watchOS, unavailable)
@frozen public enum HoverPhase : Equatable {

    /// The pointer's location moved to the specified point within the view.
    case active(CGPoint)

    /// The pointer exited the view.
    case ended

    
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
@available(watchOS, unavailable)
extension HoverPhase : Sendable {
}

#endif
