// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if !SKIP

/// The context of the current state-processing update.
///
/// Use a transaction to pass an animation between views in a view hierarchy.
///
/// The root transaction for a state change comes from the binding that changed,
/// plus any global values set by calling ``withTransaction(_:_:)`` or
/// ``withAnimation(_:_:)``.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Transaction {

    /// Creates a transaction.
    @inlinable public init() { fatalError() }

    /// Accesses the transaction value associated with a custom key.
    ///
    /// Create custom transaction values by defining a key that conforms to the
    /// ``TransactionKey`` protocol, and then using that key with the subscript
    /// operator of the ``Transaction`` structure to get and set a value for
    /// that key:
    ///
    ///     private struct MyTransactionKey: TransactionKey {
    ///         static let defaultValue = false = { fatalError() }()
    ///     }
    ///
    ///     extension Transaction {
    ///         var myCustomValue: Bool {
    ///             get { self[MyTransactionKey.self] }
    ///             set { self[MyTransactionKey.self] = newValue }
    ///         }
    ///     }
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public subscript<K>(key: K.Type) -> K.Value where K : TransactionKey { get { fatalError() } }
}


/// A key for accessing values in a transaction.
///
/// You can create custom transaction values by extending the ``Transaction``
/// structure with new properties.
/// First declare a new transaction key type and specify a value for the
/// required ``defaultValue`` property:
///
///     private struct MyTransactionKey: TransactionKey {
///         static let defaultValue = false = { fatalError() }()
///     }
///
/// The Swift compiler automatically infers the associated ``Value`` type as the
/// type you specify for the default value. Then use the key to define a new
/// transaction value property:
///
///     extension Transaction {
///         var myCustomValue: Bool {
///             get { self[MyTransactionKey.self] }
///             set { self[MyTransactionKey.self] = newValue }
///         }
///     }
///
/// Clients of your transaction value never use the key directly.
/// Instead, they use the key path of your custom transaction value property.
/// To set the transaction value for a change, wrap that change in a call to
/// `withTransaction`:
///
///     withTransaction(\.myCustomValue, true) {
///         isActive.toggle()
///     }
///
/// To set it for a view and all its subviews, add the
/// ``View/transaction(_:_:)`` view modifier to that view:
///
///     MyView()
///         .transaction(\.myCustomValue, true)
///
/// To use the value from inside `MyView` or one of its descendants, use the
/// ``View/transaction(_:)`` view modifier:
///
///     MyView()
///         .transaction { transaction in
///             if transaction.myCustomValue {
///                 transaction.animation = .default.repeatCount(3)
///             }
///         }
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol TransactionKey {

    /// The associated type representing the type of the transaction key's
    /// value.
    associatedtype Value

    /// The default value for the transaction key.
    static var defaultValue: Self.Value { get }
}

#endif

#if false
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Transaction {

    /// The behavior for how windows will dismiss programmatically when used in
    /// conjunction with ``DismissWindowAction``.
    ///
    /// The default value is `.interactive`.
    ///
    /// You can use this property to dismiss windows which may be showing a
    /// modal presentation by using the `.destructive` value:
    ///
    ///     struct DismissWindowButton: View {
    ///         @Environment(\.dismissWindow) private var dismissWindow
    ///
    ///         var body: some View {
    ///             Button("Close Auxiliary Window") {
    ///                 withTransaction(\.dismissBehavior, .destructive) {
    ///                     dismissWindow(id: "auxiliary")
    ///                 }
    ///             }
    ///         }
    ///     }
    public var dismissBehavior: DismissBehavior { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Transaction {

    /// Creates a transaction and assigns its animation property.
    ///
    /// - Parameter animation: The animation to perform when the current state
    ///   changes.
    public init(animation: Animation?) { fatalError() }

    /// The animation, if any, associated with the current state change.
    public var animation: Animation? { get { fatalError() } }

    /// A Boolean value that indicates whether views should disable animations.
    ///
    /// This value is `true` during the initial phase of a two-part transition
    /// update, to prevent ``View/animation(_:)`` from inserting new animations
    /// into the transaction.
    public var disablesAnimations: Bool { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transaction {

    /// Adds a completion to run when the animations created with this
    /// transaction are all complete.
    ///
    /// The completion callback will always be fired exactly one time. If no
    /// animations are created by the changes in `body`, then the callback will
    /// be called immediately after `body`.
    public mutating func addAnimationCompletion(criteria: AnimationCompletionCriteria = .logicallyComplete, _ completion: @escaping () -> Void) { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Transaction {

    /// Whether this transaction will track the velocity of any animatable
    /// properties that change.
    ///
    /// This property can be enabled in an interactive context to track velocity
    /// during a user interaction so that when the interaction ends, an
    /// animation can use the accumulated velocities to create animations that
    /// preserve them. This tracking is mutually exclusive with an animation
    /// being used during a view change, since if there is an animation, it is
    /// responsible for managing its own velocity.
    ///
    /// Gesture onChanged and updating callbacks automatically set this property
    /// to true.
    ///
    /// This example shows an interaction which applies changes, tracking
    /// velocity until the final change, which applies an animation (which will
    /// start with the velocity that was tracked during the previous changes).
    /// These changes could come from a server or from an interactive control
    /// like a slider.
    ///
    ///     func receiveChange(change: ChangeInfo) {
    ///         var transaction = Transaction()
    ///         if change.isFinal {
    ///             transaction.animation = .spring
    ///         } else {
    ///             transaction.tracksVelocity = true
    ///         }
    ///         withTransaction(transaction) {
    ///             state.applyChange(change)
    ///         }
    ///     }
    public var tracksVelocity: Bool { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Transaction {

    /// A Boolean value that indicates whether the transaction originated from
    /// an action that produces a sequence of values.
    ///
    /// This value is `true` if a continuous action created the transaction, and
    /// is `false` otherwise. Continuous actions include things like dragging a
    /// slider or pressing and holding a stepper, as opposed to tapping a
    /// button.
    public var isContinuous: Bool { get { fatalError() } }
}

/// Executes a closure with the specified transaction and returns the result.
///
/// - Parameters:
///   - transaction : An instance of a transaction, set as the thread's current
///     transaction.
///   - body: A closure to execute.
///
/// - Returns: The result of executing the closure with the specified
///   transaction.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func withTransaction<Result>(_ transaction: Transaction, _ body: () throws -> Result) rethrows -> Result { fatalError() }

/// Executes a closure with the specified transaction key path and value and
/// returns the result.
///
/// - Parameters:
///   - keyPath: A key path that indicates the property of the ``Transaction``
///     structure to update.
///   - value: The new value to set for the item specified by `keyPath`.
///   - body: A closure to execute.
///
/// - Returns: The result of executing the closure with the specified
///   transaction value.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func withTransaction<R, V>(_ keyPath: WritableKeyPath<Transaction, V>, _ value: V, _ body: () throws -> R) rethrows -> R { fatalError() }


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Applies the given transaction mutation function to all animations used
    /// within the view.
    ///
    /// Use this modifier to change or replace the animation used in a view.
    /// Consider three identical animations controlled by a
    /// button that executes all three animations simultaneously:
    ///
    ///  * The first animation rotates the "Rotation" ``Text`` view by 360
    ///    degrees.
    ///  * The second uses the `transaction(_:)` modifier to change the
    ///    animation by adding a delay to the start of the animation
    ///    by two seconds and then increases the rotational speed of the
    ///    "Rotation\nModified" ``Text`` view animation by a factor of 2.
    ///  * The third animation uses the `transaction(_:)` modifier to
    ///    replace the rotation animation affecting the "Animation\nReplaced"
    ///    ``Text`` view with a spring animation.
    ///
    /// The following code implements these animations:
    ///
    ///     struct TransactionExample: View {
    ///         @State private var flag = false
    ///
    ///         var body: some View {
    ///             VStack(spacing: 50) {
    ///                 HStack(spacing: 30) {
    ///                     Text("Rotation")
    ///                         .rotationEffect(Angle(degrees:
    ///                                                 self.flag ? 360 : 0))
    ///
    ///                     Text("Rotation\nModified")
    ///                         .rotationEffect(Angle(degrees:
    ///                                                 self.flag ? 360 : 0))
    ///                         .transaction { view in
    ///                             view.animation =
    ///                                 view.animation?.delay(2.0).speed(2)
    ///                         }
    ///
    ///                     Text("Animation\nReplaced")
    ///                         .rotationEffect(Angle(degrees:
    ///                                                 self.flag ? 360 : 0))
    ///                         .transaction { view in
    ///                             view.animation = .interactiveSpring(
    ///                                 response: 0.60,
    ///                                 dampingFraction: 0.20,
    ///                                 blendDuration: 0.25)
    ///                         }
    ///                 }
    ///
    ///                 Button("Animate") {
    ///                     withAnimation(.easeIn(duration: 2.0)) {
    ///                         self.flag.toggle()
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// Use this modifier on leaf views such as ``Image`` or ``Button`` rather
    /// than container views such as ``VStack`` or ``HStack``. The
    /// transformation applies to all child views within this view; calling
    /// `transaction(_:)` on a container view can lead to unbounded scope of
    /// execution depending on the depth of the view hierarchy.
    ///
    /// - Parameter transform: The transformation to apply to transactions
    ///   within this view.
    ///
    /// - Returns: A view that wraps this view and applies a transformation to
    ///   all transactions used within the view.
    public func transaction(_ transform: @escaping (inout Transaction) -> Void) -> some View { return stubView() }


    /// Applies the given transaction mutation function to all animations used
    /// within the view.
    ///
    /// Use this modifier to change or replace the animation used in a view.
    /// Consider three identical views controlled by a
    /// button that changes all three simultaneously:
    ///
    ///  * The first view animates rotating the "Rotation" ``Text`` view by 360
    ///    degrees.
    ///  * The second uses the `transaction(_:)` modifier to change the
    ///    animation by adding a delay to the start of the animation
    ///    by two seconds and then increases the rotational speed of the
    ///    "Rotation\nModified" ``Text`` view animation by a factor of 2.
    ///  * The third uses the `transaction(_:)` modifier to disable animations
    ///    affecting the "Animation\nReplaced" ``Text`` view.
    ///
    /// The following code implements these animations:
    ///
    ///     struct TransactionExample: View {
    ///         @State var flag = false
    ///
    ///         var body: some View {
    ///             VStack(spacing: 50) {
    ///                 HStack(spacing: 30) {
    ///                     Text("Rotation")
    ///                         .rotationEffect(Angle(degrees: flag ? 360 : 0))
    ///
    ///                     Text("Rotation\nModified")
    ///                         .rotationEffect(Angle(degrees: flag ? 360 : 0))
    ///                         .transaction(value: flag) { t in
    ///                             t.animation =
    ///                                 t.animation?.delay(2.0).speed(2)
    ///                         }
    ///
    ///                     Text("Animation\nReplaced")
    ///                         .rotationEffect(Angle(degrees: flag ? 360 : 0))
    ///                         .transaction(value: flag) { t in
    ///                             t.disableAnimations = true
    ///                         }
    ///                 }
    ///
    ///                 Button("Animate") {
    ///                     withAnimation(.easeIn(duration: 2.0)) {
    ///                         flag.toggle()
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: A value to monitor for changes.
    ///   - transform: The transformation to apply to transactions
    ///     within this view.
    ///
    /// - Returns: A view that wraps this view and applies a transformation to
    ///   all transactions used within the view whenever `value` changes.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func transaction(value: some Equatable, _ transform: @escaping (inout Transaction) -> Void) -> some View { return stubView() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Applies the given transaction mutation function to all animations used
    /// within the `body` closure.
    ///
    /// Any modifiers applied to the content of `body` will be applied to this
    /// view, and the changes to the transaction performed in the `transform`
    /// will only affect the modifiers defined in the `body`.
    ///
    /// The following code animates the opacity changing with a faster
    /// animation, while the contents of MyView are animated with the implicit
    /// transaction:
    ///
    ///     MyView(isActive: isActive)
    ///         .transaction { transaction in
    ///             transaction.animation = transaction.animation?.speed(2)
    ///         } body: { content in
    ///             content.opacity(isActive ? 1.0 : 0.0)
    ///         }
    ///
    /// - See Also: `Transaction.disablesAnimations`
    public func transaction<V>(_ transform: @escaping (inout Transaction) -> Void, @ViewBuilder body: (PlaceholderContentView<Self>) -> V) -> some View where V : View { return stubView() }


    /// Applies the given animation to all animatable values within the `body`
    /// closure.
    ///
    /// Any modifiers applied to the content of `body` will be applied to this
    /// view, and the `animation` will only be used on the modifiers defined in
    /// the `body`.
    ///
    /// The following code animates the opacity changing with an easeInOut
    /// animation, while the contents of MyView are animated with the implicit
    /// transaction's animation:
    ///
    ///     MyView(isActive: isActive)
    ///         .animation(.easeInOut) { content in
    ///             content.opacity(isActive ? 1.0 : 0.0)
    ///         }
    public func animation<V>(_ animation: Animation?, @ViewBuilder body: (PlaceholderContentView<Self>) -> V) -> some View where V : View { return stubView() }

}
#endif
#endif
