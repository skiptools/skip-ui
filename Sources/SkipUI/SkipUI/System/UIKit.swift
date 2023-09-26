// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP
#if canImport(UIKit)
import protocol Combine.ObservableObject
import protocol UIKit.UIApplicationDelegate
import protocol UIKit.UIMutableTraits
import protocol UIKit.UIContentConfiguration
import protocol UIKit.UIViewControllerTransitionCoordinator
import protocol UIKit.UIContentView
import protocol UIKit.UIContentContainer
import protocol UIKit.UIConfigurationState

import class Foundation.NSObject
import class Foundation.UndoManager
import class Foundation.NSCoder
import class UIKit.UIView
import class UIKit.UIColor
import class UIKit.UITraitCollection
import class UIKit.UIKeyCommand
import class UIKit.UIViewController

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import struct ObjectiveC.Selector
import struct UIKit.UITextContentType
import struct UIKit.UIRectEdge
import struct UIKit.UIContentSizeCategory
import struct UIKit.UIContentSizeCategory
import struct UIKit.UITextContentType
import struct UIKit.NSUnderlineStyle
import struct UIKit.ImageResource
import struct UIKit.NSDirectionalEdgeInsets

import enum UIKit.UIKeyboardType
import enum UIKit.UITextAutocapitalizationType
import enum UIKit.UIUserInterfaceStyle
import enum UIKit.UILegibilityWeight
import enum UIKit.UIUserInterfaceSizeClass
import enum UIKit.UIAccessibilityContrast

import enum UIKit.UIKeyboardType
import enum UIKit.UITextAutocapitalizationType
import enum UIKit.UIStatusBarAnimation
import enum UIKit.UIStatusBarStyle
import enum UIKit.UITraitEnvironmentLayoutDirection


/// A property wrapper type that you use to create a UIKit app delegate.
///
/// To handle app delegate callbacks in an app that uses the
/// SkipUI life cycle, define a type that conforms to the
///
/// protocol, and implement the delegate methods that you need. For example,
/// you can implement the
///
/// method to handle remote notification registration:
///
///     class MyAppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
///         func application(
///             _ application: UIApplication,
///             didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
///         ) {
///             // Record the device token.
///         }
///     }
///
/// Then use the `UIApplicationDelegateAdaptor` property wrapper inside your
/// ``App`` declaration to tell SkipUI about the delegate type:
///
///     @main
///     struct MyApp: App {
///         @UIApplicationDelegateAdaptor private var appDelegate: MyAppDelegate
///
///         var body: some Scene { ... }
///     }
///
/// SkipUI instantiates the delegate and calls the delegate's
/// methods in response to life cycle events. Define the delegate adaptor
/// only in your ``App`` declaration, and only once for a given app. If
/// you declare it more than once, SkipUI generates a runtime error.
///
/// If your app delegate conforms to the
///
/// protocol, as in the example above, then SkipUI puts the delegate it
/// creates into the ``Environment``. You can access the delegate from
/// any scene or view in your app using the ``EnvironmentObject`` property
/// wrapper:
///
///     @EnvironmentObject private var appDelegate: MyAppDelegate
///
/// This enables you to use the dollar sign (`$`) prefix to get a binding to
/// published properties that you declare in the delegate. For more information,
/// see ``projectedValue``.
///
/// > Important: Manage an app's life cycle events without using an app
/// delegate whenever possible. For example, prefer to handle changes
/// in ``ScenePhase`` instead of relying on delegate callbacks, like
/// .
///
/// ### Scene delegates
///
/// Some iOS apps define a
///
/// to handle scene-based events, like app shortcuts:
///
///     class MySceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
///         func windowScene(
///             _ windowScene: UIWindowScene,
///             performActionFor shortcutItem: UIApplicationShortcutItem
///         ) async -> Bool {
///             // Do something with the shortcut...
///
///             return true
///         }
///     }
///
/// You can provide this kind of delegate to a SkipUI app by returning the
/// scene delegate's type from the
///
/// method inside your app delegate:
///
///     extension MyAppDelegate {
///         func application(
///             _ application: UIApplication,
///             configurationForConnecting connectingSceneSession: UISceneSession,
///             options: UIScene.ConnectionOptions
///         ) -> UISceneConfiguration {
///
///             let configuration = UISceneConfiguration(
///                                     name: nil,
///                                     sessionRole: connectingSceneSession.role)
///             if connectingSceneSession.role == .windowApplication {
///                 configuration.delegateClass = MySceneDelegate.self
///             }
///             return configuration
///         }
///     }
///
/// When you configure the
///
/// instance, you only need to indicate the delegate class, and not a scene
/// class or storyboard. SkipUI creates and manages the delegate instance,
/// and sends it any relevant delegate callbacks.
///
/// As with the app delegate, if you make your scene delegate an observable
/// object, SkipUI automatically puts it in the ``Environment``, from where
/// you can access it with the ``EnvironmentObject`` property wrapper, and
/// create bindings to its published properties.
@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
@MainActor @propertyWrapper public struct UIApplicationDelegateAdaptor<DelegateType> : DynamicProperty where DelegateType : NSObject, DelegateType : UIApplicationDelegate {

    /// The underlying app delegate.
    @MainActor public var wrappedValue: DelegateType { get { fatalError() } }

    /// Creates a UIKit app delegate adaptor.
    ///
    /// Call this initializer indirectly by creating a property with the
    /// ``UIApplicationDelegateAdaptor`` property wrapper from inside your
    /// ``App`` declaration:
    ///
    ///     @main
    ///     struct MyApp: App {
    ///         @UIApplicationDelegateAdaptor private var appDelegate: MyAppDelegate
    ///
    ///         var body: some Scene { ... }
    ///     }
    ///
    /// SkipUI initializes the delegate and manages its lifetime, calling upon
    /// it to handle application delegate callbacks.
    ///
    /// If you want SkipUI to put the instantiated delegate in the
    /// ``Environment``, make sure the delegate class also conforms to the
    /// protocol. That causes SkipUI to invoke the ``init(_:)-8vsx1``
    /// initializer rather than this one.
    ///
    /// - Parameter delegateType: The type of application delegate that you
    ///   define in your app, which conforms to the
    ///
    ///   protocol.
    @MainActor public init(_ delegateType: DelegateType.Type = DelegateType.self) { fatalError() }
}

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension UIApplicationDelegateAdaptor where DelegateType : ObservableObject {

    /// Creates a UIKit app delegate adaptor using a delegate that's
    /// an observable object.
    ///
    /// Call this initializer indirectly by creating a property with the
    /// ``UIApplicationDelegateAdaptor`` property wrapper from inside your
    /// ``App`` declaration:
    ///
    ///     @main
    ///     struct MyApp: App {
    ///         @UIApplicationDelegateAdaptor private var appDelegate: MyAppDelegate
    ///
    ///         var body: some Scene { ... }
    ///     }
    ///
    /// SkipUI initializes the delegate and manages its lifetime, calling it
    /// as needed to handle application delegate callbacks.
    ///
    /// SkipUI invokes this method when your app delegate conforms to the
    /// protocol. In this case, SkipUI automatically places the delegate in the
    /// ``Environment``. You can access such a delegate from any scene or
    /// view in your app using the ``EnvironmentObject`` property wrapper:
    ///
    ///     @EnvironmentObject private var appDelegate: MyAppDelegate
    ///
    /// If your delegate isn't an observable object, SkipUI invokes the
    /// ``init(_:)-59sfu`` initializer rather than this one, and doesn't
    /// put the delegate instance in the environment.
    ///
    /// - Parameter delegateType: The type of application delegate that you
    ///   define in your app, which conforms to the
    ///
    ///   and
    ///
    ///   protocols.
    @MainActor public init(_ delegateType: DelegateType.Type = DelegateType.self) { fatalError() }

    /// A projection of the observed object that provides bindings to its
    /// properties.
    ///
    /// Use the projected value to get a binding to a value that the delegate
    /// publishes. Access the projected value by prefixing the name of the
    /// delegate instance with a dollar sign (`$`). For example, you might
    /// publish a Boolean value in your application delegate:
    ///
    ///     class MyAppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    ///         @Published var isEnabled = false
    ///
    ///         // ...
    ///     }
    ///
    /// If you declare the delegate in your ``App`` using the
    /// ``UIApplicationDelegateAdaptor`` property wrapper, you can get
    /// the delegate that SkipUI instantiates from the environment and
    /// access a binding to its published values from any view in your app:
    ///
    ///     struct MyView: View {
    ///         @EnvironmentObject private var appDelegate: MyAppDelegate
    ///
    ///         var body: some View {
    ///             Toggle("Enabled", isOn: $appDelegate.isEnabled)
    ///         }
    ///     }
    ///
    @MainActor public var projectedValue: ObservedObject<DelegateType>.Wrapper { get { fatalError() } }
}

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension UIApplicationDelegateAdaptor : Sendable {
}

/// A content configuration suitable for hosting a hierarchy of SkipUI views.
///
/// Use a value of this type, which conforms to the
///
/// protocol, with a
///  or
///  to host
/// a hierarchy of SkipUI views in a collection or table view, respectively.
/// For example, the following shows a stack with an image and text inside the
/// cell:
///
///     myCell.contentConfiguration = UIHostingConfiguration {
///         HStack {
///             Image(systemName: "star").foregroundStyle(.purple)
///             Text("Favorites")
///             Spacer()
///         }
///     }
///
/// You can also customize the background of the containing cell. The following
/// example draws a blue background:
///
///     myCell.contentConfiguration = UIHostingConfiguration {
///         HStack {
///             Image(systemName: "star").foregroundStyle(.purple)
///             Text("Favorites")
///             Spacer()
///         }
///     }
///     .background {
///         Color.blue
///     }
///
/// When used in a list layout, certain APIs are bridged automatically, like
/// swipe actions and separator alignment. The following example shows a
/// trailing yellow star swipe action:
///
///     cell.contentConfiguration = UIHostingConfiguration {
///         HStack {
///             Image(systemName: "airplane")
///             Text("Flight 123")
///             Spacer()
///         }
///         .swipeActions {
///             Button { ... } label: {
///                 Label("Favorite", systemImage: "star")
///             }
///             .tint(.yellow)
///         }
///     }
///
@available(iOS 16.0, tvOS 16.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct UIHostingConfiguration<Content, Background> : UIContentConfiguration where Content : View, Background : View {

    /// Sets the background contents for the hosting configuration's enclosing
    /// cell.
    ///
    /// The following example sets a custom view to the background of the cell:
    ///
    ///     UIHostingConfiguration {
    ///         Text("My Contents")
    ///     }
    ///     .background {
    ///         MyBackgroundView()
    ///     }
    ///
    /// - Parameter background: The contents of the SkipUI hierarchy to be
    ///   shown inside the background of the cell.
    public func background<B>(@ViewBuilder content: () -> B) -> UIHostingConfiguration<Content, B> where B : View { fatalError() }

    /// Sets the background contents for the hosting configuration's enclosing
    /// cell.
    ///
    /// The following example sets a custom view to the background of the cell:
    ///
    ///     UIHostingConfiguration {
    ///         Text("My Contents")
    ///     }
    ///     .background(Color.blue)
    ///
    /// - Parameter style: The shape style to be used as the background of the
    ///   cell.
//    public func background<S>(_ style: S) -> UIHostingConfiguration<Content, _UIHostingConfigurationBackgroundView<S>> where S : ShapeStyle { fatalError() }

    /// Sets the margins around the content of the configuration.
    ///
    /// Use this modifier to replace the default margins applied to the root of
    /// the configuration. The following example creates 20 points of space
    /// between the content and the background on the horizontal edges.
    ///
    ///     UIHostingConfiguration {
    ///         Text("My Contents")
    ///     }
    ///     .margins(.horizontal, 20.0)
    ///
    /// - Parameters:
    ///    - edges: The edges to apply the insets. Any edges not specified will
    ///      use the system default values. The default value is
    ///      ``Edge/Set/all``.
    ///    - length: The amount to apply.
    public func margins(_ edges: Edge.Set = .all, _ length: CGFloat) -> UIHostingConfiguration<Content, Background> { fatalError() }

    /// Sets the margins around the content of the configuration.
    ///
    /// Use this modifier to replace the default margins applied to the root of
    /// the configuration. The following example creates 10 points of space
    /// between the content and the background on the leading edge and 20 points
    /// of space on the trailing edge:
    ///
    ///     UIHostingConfiguration {
    ///         Text("My Contents")
    ///     }
    ///     .margins(.horizontal, 20.0)
    ///
    /// - Parameters:
    ///    - edges: The edges to apply the insets. Any edges not specified will
    ///      use the system default values. The default value is
    ///      ``Edge/Set/all``.
    ///    - insets: The insets to apply.
    public func margins(_ edges: Edge.Set = .all, _ insets: EdgeInsets) -> UIHostingConfiguration<Content, Background> { fatalError() }

    /// Sets the minimum size for the configuration.
    ///
    /// Use this modifier to indicate that a configuration's associated cell can
    /// be resized to a specific minimum. The following example allows the cell
    /// to be compressed to zero size:
    ///
    ///     UIHostingConfiguration {
    ///         Text("My Contents")
    ///     }
    ///     .minSize(width: 0, height: 0)
    ///
    /// - Parameter width: The value to use for the width dimension. A value of
    ///   `nil` indicates that the system default should be used.
    /// - Parameter height: The value to use for the height dimension. A value
    ///   of `nil` indicates that the system default should be used.
    public func minSize(width: CGFloat? = nil, height: CGFloat? = nil) -> UIHostingConfiguration<Content, Background> { fatalError() }

    /// Sets the minimum size for the configuration.
    ///
    /// Use the version with parameters instead.
    @available(*, deprecated, message: "Please pass one or more parameters.")
    public func minSize() -> UIHostingConfiguration<Content, Background> { fatalError() }

    @MainActor public func makeContentView() -> UIView & UIContentView { fatalError() }

    public func updated(for state: UIConfigurationState) -> UIHostingConfiguration<Content, Background> { fatalError() }
}

@available(iOS 16.0, tvOS 16.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension UIHostingConfiguration where Background == EmptyView {

    /// Creates a hosting configuration with the given contents.
    ///
    /// - Parameter content: The contents of the SkipUI hierarchy to be shown
    ///   inside the cell.
    public init(@ViewBuilder content: () -> Content) { fatalError() }
}

/// A UIKit view controller that manages a SkipUI view hierarchy.
///
/// Create a `UIHostingController` object when you want to integrate SkipUI
/// views into a UIKit view hierarchy. At creation time, specify the SkipUI
/// view you want to use as the root view for this view controller; you can
/// change that view later using the ``SkipUI/UIHostingController/rootView``
/// property. Use the hosting controller like you would any other view
/// controller, by presenting it or embedding it as a child view controller
/// in your interface.
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
@MainActor open class UIHostingController<Content> : UIViewController where Content : View {

    @MainActor override dynamic open var undoManager: UndoManager? { get { fatalError() } }

    @MainActor override dynamic open var keyCommands: [UIKeyCommand]? { get { fatalError() } }

    /// Creates a hosting controller object that wraps the specified SkipUI
    /// view.
    ///
    /// - Parameter rootView: The root view of the SkipUI view hierarchy that
    ///   you want to manage using the hosting view controller.
    ///
    /// - Returns: A `UIHostingController` object initialized with the
    ///   specified SkipUI view.
    @MainActor public init(rootView: Content) { fatalError() }

    /// Creates a hosting controller object from an archive and the specified
    /// SkipUI view.
    /// - Parameters:
    ///   - coder: The decoder to use during initialization.
    ///   - rootView: The root view of the SkipUI view hierarchy that you want
    ///     to manage using this view controller.
    ///
    /// - Returns: A `UIViewController` object that you can present from your
    ///   interface.
    @MainActor public init?(coder aDecoder: NSCoder, rootView: Content) { fatalError() }

    /// Creates a hosting controller object from the contents of the specified
    /// archive.
    ///
    /// The default implementation of this method throws an exception. To create
    /// your view controller from an archive, override this method and
    /// initialize the superclass using the ``init(coder:rootView:)`` method
    /// instead.
    ///
    /// -Parameter coder: The decoder to use during initialization.
    @MainActor required dynamic public init?(coder aDecoder: NSCoder) { fatalError() }

    @MainActor override dynamic open func loadView() { fatalError() }

    /// Notifies the view controller that its view is about to be added to a
    /// view hierarchy.
    ///
    /// SkipUI calls this method before adding the hosting controller's root
    /// view to the view hierarchy. You can override this method to perform
    /// custom tasks associated with the appearance of the view. If you
    /// override this method, you must call `super` at some point in your
    /// implementation.
    ///
    /// - Parameter animated: If `true`, the view is being added
    ///   using an animation.
    @MainActor override dynamic open func viewWillAppear(_ animated: Bool) { fatalError() }

    /// Notifies the view controller that its view has been added to a
    /// view hierarchy.
    ///
    /// SkipUI calls this method after adding the hosting controller's root
    /// view to the view hierarchy. You can override this method to perform
    /// custom tasks associated with the appearance of the view. If you
    /// override this method, you must call `super` at some point in your
    /// implementation.
    ///
    /// - Parameter animated: If `true`, the view is being added
    ///   using an animation.
    @MainActor override dynamic open func viewDidAppear(_ animated: Bool) { fatalError() }

    /// Notifies the view controller that its view will be removed from a
    /// view hierarchy.
    ///
    /// SkipUI calls this method before removing the hosting controller's root
    /// view from the view hierarchy. You can override this method to perform
    /// custom tasks associated with the disappearance of the view. If you
    /// override this method, you must call `super` at some point in your
    /// implementation.
    ///
    /// - Parameter animated: If `true`, the view is being removed
    ///   using an animation.
    @MainActor override dynamic open func viewWillDisappear(_ animated: Bool) { fatalError() }

    @MainActor override dynamic open func viewDidDisappear(_ animated: Bool) { fatalError() }

    @MainActor override dynamic open func viewWillLayoutSubviews() { fatalError() }

    @MainActor override dynamic open var isModalInPresentation: Bool { get { fatalError() } set { } }

    /// The root view of the SkipUI view hierarchy managed by this view
    /// controller.
    @MainActor public var rootView: Content { get { fatalError() } }

    /// The options for how the hosting controller tracks changes to the size
    /// of its SkipUI content.
    ///
    /// The default value is the empty set.
    @available(iOS 16.0, tvOS 16.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public var sizingOptions: UIHostingControllerSizingOptions { get { fatalError() } }

    /// Calculates and returns the most appropriate size for the current view.
    ///
    /// - Parameter size: The proposed new size for the view.
    ///
    /// - Returns: The size that offers the best fit for the root view and its
    ///   contents.
    @MainActor public func sizeThatFits(in size: CGSize) -> CGSize { fatalError() }

    @MainActor override dynamic open func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) { fatalError() }

    /// The preferred status bar style for the view controller.
    @MainActor override dynamic open var preferredStatusBarStyle: UIStatusBarStyle { get { fatalError() } }

    /// A Boolean value that indicates whether the view controller prefers the
    /// status bar to be hidden or shown.
    @MainActor override dynamic open var prefersStatusBarHidden: Bool { get { fatalError() } }

    /// The animation style to use when hiding or showing the status bar for
    /// this view controller.
    @MainActor override dynamic open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { get { fatalError() } }

    @MainActor override dynamic open var childForStatusBarStyle: UIViewController? { get { fatalError() } }

    @MainActor override dynamic open var childForStatusBarHidden: UIViewController? { get { fatalError() } }

    @MainActor override dynamic open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) { fatalError() }

    @MainActor override dynamic open func willMove(toParent parent: UIViewController?) { fatalError() }

    @MainActor override dynamic open func didMove(toParent parent: UIViewController?) { fatalError() }

    /// Sets the screen edge from which you want your gesture to take
    /// precedence over the system gesture.
    @MainActor override dynamic open var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { get { fatalError() } }

    @MainActor override dynamic open var childForScreenEdgesDeferringSystemGestures: UIViewController? { get { fatalError() } }

    /// A Boolean value that indicates whether the view controller prefers the
    /// home indicator to be hidden or shown.
    @MainActor override dynamic open var prefersHomeIndicatorAutoHidden: Bool { get { fatalError() } }

    @MainActor override dynamic open var childForHomeIndicatorAutoHidden: UIViewController? { get { fatalError() } }

    @MainActor override dynamic open func target(forAction action: Selector, withSender sender: Any?) -> Any? { fatalError() }
}

extension UIHostingController {

    /// The safe area regions that this view controller adds to its view.
    ///
    /// An example of when this is appropriate to use is when hosting content
    /// that you know should never be affected by the safe area, such as a
    /// custom scrollable container. Disabling a safe area region omits it from
    /// the SkipUI layout system altogether.
    ///
    /// The default value is ``SafeAreaRegions.all``.
    @available(iOS 16.4, tvOS 16.4, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public var safeAreaRegions: SafeAreaRegions { get { fatalError() } }
}

/// Options for how a hosting controller tracks its content's size.
@available(iOS 16.0, tvOS 16.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct UIHostingControllerSizingOptions : OptionSet, Sendable {

    /// The raw value.
    public let rawValue: Int = { fatalError() }()

    /// Creates a new option set from a raw value.
    public init(rawValue: Int) { fatalError() }

    /// The hosting controller tracks its content's ideal size in its
    /// preferred content size.
    ///
    /// Use this option when using a hosting controller with a container view
    /// controller that requires up-to-date knowledge of the hosting
    /// controller's ideal size.
    ///
    /// - Note: This option comes with a performance cost because it
    ///   asks for the ideal size of the content using the
    ///   ``ProposedViewSize/unspecified`` size proposal.
    public static let preferredContentSize: UIHostingControllerSizingOptions = { fatalError() }()

    /// The hosting controller's view automatically invalidate its intrinsic
    /// content size when its ideal size changes.
    ///
    /// Use this option when the hosting controller's view is being laid out
    /// with Auto Layout.
    ///
    /// - Note: This option comes with a performance cost because it
    ///   asks for the ideal size of the content using the
    ///   ``ProposedViewSize/unspecified`` size proposal.
    public static let intrinsicContentSize: UIHostingControllerSizingOptions = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = UIHostingControllerSizingOptions

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = UIHostingControllerSizingOptions

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int
}

/// An environment key that is bridged to a UIKit trait.
///
/// Use this protocol to allow the same underlying data to be accessed using an
/// environment key in SkipUI and trait in UIKit. As the bridging is
/// bidirectional, values written to the trait in UIKit can be read using the
/// environment key in SkipUI, and values written to the environment key in
/// SkipUI can be read from the trait in UIKit.
///
/// Given a custom UIKit trait named `MyTrait` with `myTrait` properties on
/// both `UITraitCollection` and `UIMutableTraits`:
///
///     struct MyTrait: UITraitDefinition {
///         static let defaultValue = "Default value"
///     }
///
///     extension UITraitCollection {
///         var myTrait: String {
///             self[MyTrait.self]
///         }
///     }
///
///     extension UIMutableTraits {
///         var myTrait: String {
///             get { self[MyTrait.self] }
///             set { self[MyTrait.self] = newValue }
///         }
///     }
///
/// You can declare an environment key to represent the same data:
///
///     struct MyEnvironmentKey: EnvironmentKey {
///         static let defaultValue = "Default value"
///     }
///
/// Bridge the environment key and the trait by conforming to the
/// `UITraitBridgedEnvironmentKey` protocol, providing implementations
/// of ``read(from:)`` and ``write(to:value:)`` to losslessly convert
/// the environment value from and to the corresponding trait value:
///
///     extension MyEnvironmentKey: UITraitBridgedEnvironmentKey {
///         static func read(
///             from traitCollection: UITraitCollection
///         ) -> String {
///             traitCollection.myTrait
///         }
///
///         static func write(
///             to mutableTraits: inout UIMutableTraits, value: String
///         ) {
///             mutableTraits.myTrait = value
///         }
///     }
///
@available(iOS 17.0, tvOS 17.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public protocol UITraitBridgedEnvironmentKey : EnvironmentKey {

    /// Reads the trait value from the trait collection, and returns
    /// the equivalent environment value.
    ///
    /// - Parameter traitCollection: The trait collection to read from.
    static func read(from traitCollection: UITraitCollection) -> Self.Value

    static func write(to mutableTraits: inout UIMutableTraits, value: Self.Value)
}

/// A view that represents a UIKit view controller.
///
/// Use a ``UIViewControllerRepresentable`` instance to create and manage a
///  object in your
/// SkipUI interface. Adopt this protocol in one of your app's custom
/// instances, and use its methods to create, update, and tear down your view
/// controller. The creation and update processes parallel the behavior of
/// SkipUI views, and you use them to configure your view controller with your
/// app's current state information. Use the teardown process to remove your
/// view controller cleanly from your SkipUI. For example, you might use the
/// teardown process to notify other objects that the view controller is
/// disappearing.
///
/// To add your view controller into your SkipUI interface, create your
/// ``UIViewControllerRepresentable`` instance and add it to your SkipUI
/// interface. The system calls the methods of your custom instance at
/// appropriate times.
///
/// The system doesn't automatically communicate changes occurring within your
/// view controller to other parts of your SkipUI interface. When you want your
/// view controller to coordinate with other SkipUI views, you must provide a
/// ``NSViewControllerRepresentable/Coordinator`` instance to facilitate those
/// interactions. For example, you use a coordinator to forward target-action
/// and delegate messages from your view controller to any SkipUI views.
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public protocol UIViewControllerRepresentable : View where Self.Body == Never {

    /// The type of view controller to present.
    associatedtype UIViewControllerType : UIViewController

    /// Creates the view controller object and configures its initial state.
    ///
    /// You must implement this method and use it to create your view controller
    /// object. Create the view controller using your app's current data and
    /// contents of the `context` parameter. The system calls this method only
    /// once, when it creates your view controller for the first time. For all
    /// subsequent updates, the system calls the
    /// ``UIViewControllerRepresentable/updateUIViewController(_:context:)``
    /// method.
    ///
    /// - Parameter context: A context structure containing information about
    ///   the current state of the system.
    ///
    /// - Returns: Your UIKit view controller configured with the provided
    ///   information.
    @MainActor func makeUIViewController(context: Self.Context) -> Self.UIViewControllerType

    /// Updates the state of the specified view controller with new information
    /// from SkipUI.
    ///
    /// When the state of your app changes, SkipUI updates the portions of your
    /// interface affected by those changes. SkipUI calls this method for any
    /// changes affecting the corresponding UIKit view controller. Use this
    /// method to update the configuration of your view controller to match the
    /// new state information provided in the `context` parameter.
    ///
    /// - Parameters:
    ///   - uiViewController: Your custom view controller object.
    ///   - context: A context structure containing information about the current
    ///     state of the system.
    @MainActor func updateUIViewController(_ uiViewController: Self.UIViewControllerType, context: Self.Context)

    /// Cleans up the presented view controller (and coordinator) in
    /// anticipation of their removal.
    ///
    /// Use this method to perform additional clean-up work related to your
    /// custom view controller. For example, you might use this method to remove
    /// observers or update other parts of your SkipUI interface.
    ///
    /// - Parameters:
    ///   - uiViewController: Your custom view controller object.
    ///   - coordinator: The custom coordinator instance you use to communicate
    ///     changes back to SkipUI. If you do not use a custom coordinator, the
    ///     system provides a default instance.
    @MainActor static func dismantleUIViewController(_ uiViewController: Self.UIViewControllerType, coordinator: Self.Coordinator)

    /// A type to coordinate with the view controller.
    associatedtype Coordinator = Void

    /// Creates the custom instance that you use to communicate changes from
    /// your view controller to other parts of your SkipUI interface.
    ///
    /// Implement this method if changes to your view controller might affect
    /// other parts of your app. In your implementation, create a custom Swift
    /// instance that can communicate with other parts of your interface. For
    /// example, you might provide an instance that binds its variables to
    /// SkipUI properties, causing the two to remain synchronized. If your view
    /// controller doesn't interact with other parts of your app, providing a
    /// coordinator is unnecessary.
    ///
    /// SkipUI calls this method before calling the
    /// ``UIViewControllerRepresentable/makeUIViewController(context:)`` method.
    /// The system provides your coordinator either directly or as part of a
    /// context structure when calling the other methods of your representable
    /// instance.
    @MainActor func makeCoordinator() -> Self.Coordinator

    /// Given a proposed size, returns the preferred size of the composite view.
    ///
    /// This method may be called more than once with different proposed sizes
    /// during the same layout pass. SkipUI views choose their own size, so one
    /// of the values returned from this function will always be used as the
    /// actual size of the composite view.
    ///
    /// - Parameters:
    ///   - proposal: The proposed size for the view controller.
    ///   - uiViewController: Your custom view controller object.
    ///   - context: A context structure containing information about the
    ///     current state of the system.
    ///
    /// - Returns: The composite size of the represented view controller.
    ///   Returning a value of `nil` indicates that the system should use the
    ///   default sizing algorithm.
    @available(iOS 16.0, tvOS 16.0, *)
    @MainActor func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: Self.UIViewControllerType, context: Self.Context) -> CGSize?

    typealias Context = UIViewControllerRepresentableContext<Self>

    //@available(iOS 17.0, tvOS 17.0, *)
    //typealias LayoutOptions
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
extension UIViewControllerRepresentable where Self.Coordinator == () {

    /// Creates the custom instance that you use to communicate changes from
    /// your view controller to other parts of your SkipUI interface.
    ///
    /// Implement this method if changes to your view controller might affect
    /// other parts of your app. In your implementation, create a custom Swift
    /// instance that can communicate with other parts of your interface. For
    /// example, you might provide an instance that binds its variables to
    /// SkipUI properties, causing the two to remain synchronized. If your view
    /// controller doesn't interact with other parts of your app, providing a
    /// coordinator is unnecessary.
    ///
    /// SkipUI calls this method before calling the
    /// ``UIViewControllerRepresentable/makeUIViewController(context:)`` method.
    /// The system provides your coordinator either directly or as part of a
    /// context structure when calling the other methods of your representable
    /// instance.
    public func makeCoordinator() -> Self.Coordinator { fatalError() }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
extension UIViewControllerRepresentable {

    /// Given a proposed size, returns the preferred size of the composite view.
    ///
    /// This method may be called more than once with different proposed sizes
    /// during the same layout pass. SkipUI views choose their own size, so one
    /// of the values returned from this function will always be used as the
    /// actual size of the composite view.
    ///
    /// - Parameters:
    ///   - proposal: The proposed size for the view controller.
    ///   - uiViewController: Your custom view controller object.
    ///   - context: A context structure containing information about the
    ///     current state of the system.
    ///
    /// - Returns: The composite size of the represented view controller.
    ///   Returning a value of `nil` indicates that the system should use the
    ///   default sizing algorithm.
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: Self.UIViewControllerType, context: Self.Context) -> CGSize? { fatalError() }

    /// Cleans up the presented view controller (and coordinator) in
    /// anticipation of their removal.
    ///
    /// Use this method to perform additional clean-up work related to your
    /// custom view controller. For example, you might use this method to remove
    /// observers or update other parts of your SkipUI interface.
    ///
    /// - Parameters:
    ///   - uiViewController: Your custom view controller object.
    ///   - coordinator: The custom coordinator instance you use to communicate
    ///     changes back to SkipUI. If you do not use a custom coordinator, the
    ///     system provides a default instance.
    public static func dismantleUIViewController(_ uiViewController: Self.UIViewControllerType, coordinator: Self.Coordinator) { fatalError() }

    /// Declares the content and behavior of this view.
    public var body: Never { get { fatalError() } }
}

/// Contextual information about the state of the system that you use to create
/// and update your UIKit view controller.
///
/// A ``UIViewControllerRepresentableContext`` structure contains details about
/// the current state of the system. When creating and updating your view
/// controller, the system creates one of these structures and passes it to the
/// appropriate method of your custom ``UIViewControllerRepresentable``
/// instance. Use the information in this structure to configure your view
/// controller. For example, use the provided environment values to configure
/// the appearance of your view controller and views. Don't create this
/// structure yourself.
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
@MainActor public struct UIViewControllerRepresentableContext<Representable> where Representable : UIViewControllerRepresentable {

    /// The view's associated coordinator.
    @MainActor public let coordinator: Representable.Coordinator = { fatalError() }()

    /// The current transaction.
    @MainActor public var transaction: Transaction { get { fatalError() } }

    /// Environment values that describe the current state of the system.
    ///
    /// Use the environment values to configure the state of your UIKit view
    /// controller when creating or updating it.
    @MainActor public var environment: EnvironmentValues { get { fatalError() } }
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension UIViewControllerRepresentableContext : Sendable {
}

/// A wrapper for a UIKit view that you use to integrate that view into your
/// SkipUI view hierarchy.
///
/// Use a ``UIViewRepresentable`` instance to create and manage a
///  object in your SkipUI
/// interface. Adopt this protocol in one of your app's custom instances, and
/// use its methods to create, update, and tear down your view. The creation and
/// update processes parallel the behavior of SkipUI views, and you use them to
/// configure your view with your app's current state information. Use the
/// teardown process to remove your view cleanly from your SkipUI. For example,
/// you might use the teardown process to notify other objects that the view is
/// disappearing.
///
/// To add your view into your SkipUI interface, create your
/// ``UIViewRepresentable`` instance and add it to your SkipUI interface. The
/// system calls the methods of your representable instance at appropriate times
/// to create and update the view. The following example shows the inclusion of
/// a custom `MyRepresentedCustomView` structure in the view hierarchy.
///
///     struct ContentView: View {
///        var body: some View {
///           VStack {
///              Text("Global Sales")
///              MyRepresentedCustomView()
///           }
///        }
///     }
///
/// The system doesn't automatically communicate changes occurring within your
/// view to other parts of your SkipUI interface. When you want your view to
/// coordinate with other SkipUI views, you must provide a
/// ``NSViewControllerRepresentable/Coordinator`` instance to facilitate those
/// interactions. For example, you use a coordinator to forward target-action
/// and delegate messages from your view to any SkipUI views.
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public protocol UIViewRepresentable : View where Self.Body == Never {

    /// The type of view to present.
    associatedtype UIViewType : UIView

    /// Creates the view object and configures its initial state.
    ///
    /// You must implement this method and use it to create your view object.
    /// Configure the view using your app's current data and contents of the
    /// `context` parameter. The system calls this method only once, when it
    /// creates your view for the first time. For all subsequent updates, the
    /// system calls the ``UIViewRepresentable/updateUIView(_:context:)``
    /// method.
    ///
    /// - Parameter context: A context structure containing information about
    ///   the current state of the system.
    ///
    /// - Returns: Your UIKit view configured with the provided information.
    @MainActor func makeUIView(context: Self.Context) -> Self.UIViewType

    /// Updates the state of the specified view with new information from
    /// SkipUI.
    ///
    /// When the state of your app changes, SkipUI updates the portions of your
    /// interface affected by those changes. SkipUI calls this method for any
    /// changes affecting the corresponding UIKit view. Use this method to
    /// update the configuration of your view to match the new state information
    /// provided in the `context` parameter.
    ///
    /// - Parameters:
    ///   - uiView: Your custom view object.
    ///   - context: A context structure containing information about the current
    ///     state of the system.
    @MainActor func updateUIView(_ uiView: Self.UIViewType, context: Self.Context)

    /// Cleans up the presented UIKit view (and coordinator) in anticipation of
    /// their removal.
    ///
    /// Use this method to perform additional clean-up work related to your
    /// custom view. For example, you might use this method to remove observers
    /// or update other parts of your SkipUI interface.
    ///
    /// - Parameters:
    ///   - uiView: Your custom view object.
    ///   - coordinator: The custom coordinator instance you use to communicate
    ///     changes back to SkipUI. If you do not use a custom coordinator, the
    ///     system provides a default instance.
    @MainActor static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator)

    /// A type to coordinate with the view.
    associatedtype Coordinator = Void

    /// Creates the custom instance that you use to communicate changes from
    /// your view to other parts of your SkipUI interface.
    ///
    /// Implement this method if changes to your view might affect other parts
    /// of your app. In your implementation, create a custom Swift instance that
    /// can communicate with other parts of your interface. For example, you
    /// might provide an instance that binds its variables to SkipUI
    /// properties, causing the two to remain synchronized. If your view doesn't
    /// interact with other parts of your app, providing a coordinator is
    /// unnecessary.
    ///
    /// SkipUI calls this method before calling the
    /// ``UIViewRepresentable/makeUIView(context:)`` method. The system provides
    /// your coordinator either directly or as part of a context structure when
    /// calling the other methods of your representable instance.
    @MainActor func makeCoordinator() -> Self.Coordinator

    /// Given a proposed size, returns the preferred size of the composite view.
    ///
    /// This method may be called more than once with different proposed sizes
    /// during the same layout pass. SkipUI views choose their own size, so one
    /// of the values returned from this function will always be used as the
    /// actual size of the composite view.
    ///
    /// - Parameters:
    ///   - proposal: The proposed size for the view.
    ///   - uiView: Your custom view object.
    ///   - context: A context structure containing information about the
    ///     current state of the system.
    ///
    /// - Returns: The composite size of the represented view controller.
    ///   Returning a value of `nil` indicates that the system should use the
    ///   default sizing algorithm.
    @available(iOS 16.0, tvOS 16.0, *)
    @MainActor func sizeThatFits(_ proposal: ProposedViewSize, uiView: Self.UIViewType, context: Self.Context) -> CGSize?

    typealias Context = UIViewRepresentableContext<Self>

    //@available(iOS 17.0, tvOS 17.0, *)
    //typealias LayoutOptions
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
extension UIViewRepresentable where Self.Coordinator == () {

    /// Creates the custom instance that you use to communicate changes from
    /// your view to other parts of your SkipUI interface.
    ///
    /// Implement this method if changes to your view might affect other parts
    /// of your app. In your implementation, create a custom Swift instance that
    /// can communicate with other parts of your interface. For example, you
    /// might provide an instance that binds its variables to SkipUI
    /// properties, causing the two to remain synchronized. If your view doesn't
    /// interact with other parts of your app, providing a coordinator is
    /// unnecessary.
    ///
    /// SkipUI calls this method before calling the
    /// ``UIViewRepresentable/makeUIView(context:)`` method. The system provides
    /// your coordinator either directly or as part of a context structure when
    /// calling the other methods of your representable instance.
    public func makeCoordinator() -> Self.Coordinator { fatalError() }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
extension UIViewRepresentable {

    /// Cleans up the presented UIKit view (and coordinator) in anticipation of
    /// their removal.
    ///
    /// Use this method to perform additional clean-up work related to your
    /// custom view. For example, you might use this method to remove observers
    /// or update other parts of your SkipUI interface.
    ///
    /// - Parameters:
    ///   - uiView: Your custom view object.
    ///   - coordinator: The custom coordinator instance you use to communicate
    ///     changes back to SkipUI. If you do not use a custom coordinator, the
    ///     system provides a default instance.
    public static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator) { fatalError() }

    /// Given a proposed size, returns the preferred size of the composite view.
    ///
    /// This method may be called more than once with different proposed sizes
    /// during the same layout pass. SkipUI views choose their own size, so one
    /// of the values returned from this function will always be used as the
    /// actual size of the composite view.
    ///
    /// - Parameters:
    ///   - proposal: The proposed size for the view.
    ///   - uiView: Your custom view object.
    ///   - context: A context structure containing information about the
    ///     current state of the system.
    ///
    /// - Returns: The composite size of the represented view controller.
    ///   Returning a value of `nil` indicates that the system should use the
    ///   default sizing algorithm.
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @available(macOS, unavailable)
    public func sizeThatFits(_ proposal: ProposedViewSize, uiView: Self.UIViewType, context: Self.Context) -> CGSize? { fatalError() }

    /// Declares the content and behavior of this view.
    public var body: Never { get { fatalError() } }
}

/// Contextual information about the state of the system that you use to create
/// and update your UIKit view.
///
/// A ``UIViewRepresentableContext`` structure contains details about the
/// current state of the system. When creating and updating your view, the
/// system creates one of these structures and passes it to the appropriate
/// method of your custom ``UIViewRepresentable`` instance. Use the information
/// in this structure to configure your view. For example, use the provided
/// environment values to configure the appearance of your view. Don't create
/// this structure yourself.
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
@MainActor public struct UIViewRepresentableContext<Representable> where Representable : UIViewRepresentable {

    /// The view's associated coordinator.
    @MainActor public let coordinator: Representable.Coordinator = { fatalError() }()

    /// The current transaction.
    @MainActor public var transaction: Transaction { get { fatalError() } }

    /// The current environment.
    ///
    /// Use the environment values to configure the state of your view when
    /// creating or updating it.
    @MainActor public var environment: EnvironmentValues { get { fatalError() } }
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension UIViewRepresentableContext : Sendable {
}

extension ColorScheme {

    /// Creates a color scheme from its user interface style equivalent.
    @available(iOS 14.0, tvOS 14.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public init?(_ uiUserInterfaceStyle: UIUserInterfaceStyle) { fatalError() }
}

extension ColorSchemeContrast {

    /// Creates a contrast from its accessibility contrast equivalent.
    @available(iOS 14.0, tvOS 14.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public init?(_ uiAccessibilityContrast: UIAccessibilityContrast) { fatalError() }
}

extension UIColor {

    @available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    @available(macOS, unavailable)
    public convenience init(_ color: Color) { fatalError() }
}

extension UIUserInterfaceStyle {

    /// Creates a user interface style from its ColorScheme equivalent.
    @available(iOS 14.0, tvOS 14.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public init(_ colorScheme: ColorScheme?) { fatalError() }
}

extension UIAccessibilityContrast {

    /// Create a contrast from its ColorSchemeContrast equivalent.
    @available(iOS 14.0, tvOS 14.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public init(_ colorSchemeContrast: ColorSchemeContrast?) { fatalError() }
}

extension UIContentSizeCategory {

    /// Create a size category from its `ContentSizeCategory` equivalent.
    @available(iOS 14.0, tvOS 14.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public init(_ sizeCategory: ContentSizeCategory?) { fatalError() }

    @available(iOS 15.0, tvOS 15.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public init(_ dynamicTypeSize: DynamicTypeSize?) { fatalError() }
}

@available(iOS 15.0, tvOS 15.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension DynamicTypeSize {

    /// Create a Dynamic Type size from its `UIContentSizeCategory` equivalent.
    public init?(_ uiSizeCategory: UIContentSizeCategory) { fatalError() }
}

extension UITraitEnvironmentLayoutDirection {

    /// Create a direction from its LayoutDirection equivalent.
    @available(iOS 14.0, tvOS 14.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public init(_ layoutDirection: LayoutDirection) { fatalError() }
}

extension UILegibilityWeight {

    /// Creates a legibility weight from its LegibilityWeight equivalent.
    @available(iOS 14.0, tvOS 14.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public init(_ legibilityWeight: LegibilityWeight?) { fatalError() }
}

extension LegibilityWeight {

    /// Creates a legibility weight from its UILegibilityWeight equivalent.
    @available(iOS 14.0, tvOS 14.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public init?(_ uiLegibilityWeight: UILegibilityWeight) { fatalError() }
}

extension UIUserInterfaceSizeClass {

    /// Creates a UIKit size class from the specified SkipUI size class.
    @available(iOS 14.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public init(_ sizeClass: UserInterfaceSizeClass?) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension NSUnderlineStyle {

    /// Creates a ``NSUnderlineStyle`` from ``Text.LineStyle``.
    ///
    /// - Parameter lineStyle: A value of ``Text.LineStyle``
    /// to wrap with ``NSUnderlineStyle``.
    ///
    /// - Returns: A new ``NSUnderlineStyle``.
    public init(_ lineStyle: Text.LineStyle) { fatalError() }
}

extension NSDirectionalEdgeInsets {

    /// Create edge insets from the equivalent EdgeInsets.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
    @available(watchOS, unavailable)
    public init(_ edgeInsets: EdgeInsets) { fatalError() }
}

extension EdgeInsets {

    /// Create edge insets from the equivalent NSDirectionalEdgeInsets.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
    @available(watchOS, unavailable)
    public init(_ nsEdgeInsets: NSDirectionalEdgeInsets) { fatalError() }
}

extension UserInterfaceSizeClass {

    /// Creates a SkipUI size class from the specified UIKit size class.
    @available(iOS 14.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public init?(_ uiUserInterfaceSizeClass: UIUserInterfaceSizeClass) { fatalError() }
}

extension ContentSizeCategory {

    /// Create a size category from its UIContentSizeCategory equivalent.
    @available(iOS 14.0, tvOS 14.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public init?(_ uiSizeCategory: UIContentSizeCategory) { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Label /* where Title == Text, Icon == Image */ {

    /// Creates a label with an icon image and a title generated from a
    /// localized string.
    ///
    /// - Parameters:
    ///    - titleKey: A title generated from a localized string.
    ///    - image: The image resource to lookup.
    public init(_ titleKey: LocalizedStringKey, image resource: ImageResource) { fatalError() }

    /// Creates a label with an icon image and a title generated from a string.
    ///
    /// - Parameters:
    ///    - title: A string used as the label's title.
    ///    - image: The image resource to lookup.
    public init<S>(_ title: S, image resource: ImageResource) where S : StringProtocol { fatalError() }
}

extension View {

    /// Sets the keyboard type for this view.
    ///
    /// Use `keyboardType(_:)` to specify the keyboard type to use for text
    /// entry. A number of different keyboard types are available to meet
    /// specialized input needs, such as entering email addresses or phone
    /// numbers.
    ///
    /// The example below presents a ``TextField`` to input an email address.
    /// Setting the text field's keyboard type to `.emailAddress` ensures the
    /// user can only enter correctly formatted email addresses.
    ///
    ///     TextField("someone@example.com", text: $emailAddress)
    ///         .keyboardType(.emailAddress)
    ///
    /// There are several different kinds of specialized keyboard types
    /// available though the
    ///  enumeration. To
    /// specify the default system keyboard type, use `.default`.
    ///
    /// ![A screenshot showing the use of a specialized keyboard type with a
    /// text field.](SkipUI-View-keyboardType.png)
    ///
    /// - Parameter type: One of the keyboard types defined in the
    ///  enumeration.
    @available(iOS 13.0, tvOS 13.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public func keyboardType(_ type: UIKeyboardType) -> some View { return stubView() }

}

extension View {

    /// Sets whether to apply auto-capitalization to this view.
    ///
    /// Use `autocapitalization(_:)` when you need to automatically capitalize
    /// words, sentences, or other text like proper nouns.
    ///
    /// In example below, as the user enters text each word is automatically
    /// capitalized:
    ///
    ///     TextField("Last, First", text: $fullName)
    ///         .autocapitalization(UITextAutocapitalizationType.words)
    ///
    /// The
    /// enumeration defines the available capitalization modes. The default is
    /// .
    ///
    /// - Parameter style: One of the autocapitalization modes defined in the
    /// enumeration.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use textInputAutocapitalization(_:)")
    @available(macOS, unavailable)
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use textInputAutocapitalization(_:)")
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "use textInputAutocapitalization(_:)")
    public func autocapitalization(_ style: UITextAutocapitalizationType) -> some View { return stubView() }

}

extension View {

    /// Sets the text content type for this view, which the system uses to
    /// offer suggestions while the user enters text on an iOS or tvOS device.
    ///
    /// Use this method to set the content type for input text.
    /// For example, you can configure a ``TextField`` for the entry of email
    /// addresses:
    ///
    ///     TextField("Enter your email", text: $emailAddress)
    ///         .textContentType(.emailAddress)
    ///
    /// - Parameter textContentType: One of the content types available in the
    ///
    ///   structure that identify the semantic meaning expected for a text-entry
    ///   area. These include support for email addresses, location names, URLs,
    ///   and telephone numbers, to name just a few.
    @available(iOS 13.0, tvOS 13.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public func textContentType(_ textContentType: UITextContentType?) -> some View { return stubView() }

}

#endif

#endif
