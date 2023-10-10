// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import class Foundation.UserDefaults

/// No-op
func stubScene() -> some Scene {
    //return never() // raises warning: “A call to a never-returning function”
    struct NeverScene : Scene {
        typealias Body = Never
        var body: Body { fatalError() }
    }
    return NeverScene()
}

/// A part of an app's user interface with a life cycle managed by the
/// system.
///
/// You create an ``SkipUI/App`` by combining one or more instances
/// that conform to the `Scene` protocol in the app's
/// ``SkipUI/App/body-swift.property``. You can use the built-in scenes that
/// SkipUI provides, like ``SkipUI/WindowGroup``, along with custom scenes
/// that you compose from other scenes. To create a custom scene, declare a
/// type that conforms to the `Scene` protocol. Implement the required
/// ``SkipUI/Scene/body-swift.property`` computed property and provide the
/// content for your custom scene:
///
///     struct MyScene: Scene {
///         var body: some Scene {
///             WindowGroup {
///                 MyRootView()
///             }
///         }
///     }
///
/// A scene acts as a container for a view hierarchy that you want to display
/// to the user. The system decides when and how to present the view hierarchy
/// in the user interface in a way that's platform-appropriate and dependent
/// on the current state of the app. For example, for the window group shown
/// above, the system lets the user create or remove windows that contain
/// `MyRootView` on platforms like macOS and iPadOS. On other platforms, the
/// same view hierarchy might consume the entire display when active.
///
/// Read the ``SkipUI/EnvironmentValues/scenePhase`` environment
/// value from within a scene or one of its views to check whether a scene is
/// active or in some other state. You can create a property that contains the
/// scene phase, which is one of the values in the ``SkipUI/ScenePhase``
/// enumeration, using the ``SkipUI/Environment`` attribute:
///
///     struct MyScene: Scene {
///         @Environment(\.scenePhase) private var scenePhase
///
///         // ...
///     }
///
/// The `Scene` protocol provides scene modifiers, defined as protocol methods
/// with default implementations, that you use to configure a scene. For
/// example, you can use the ``SkipUI/Scene/onChange(of:perform:)`` modifier to
/// trigger an action when a value changes. The following code empties a cache
/// when all of the scenes in the window group have moved to the background:
///
///     struct MyScene: Scene {
///         @Environment(\.scenePhase) private var scenePhase
///         @StateObject private var cache = DataCache()
///
///         var body: some Scene {
///             WindowGroup {
///                 MyRootView()
///             }
///             .onChange(of: scenePhase) { newScenePhase in
///                 if newScenePhase == .background {
///                     cache.empty()
///                 }
///             }
///         }
///     }
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol Scene {

    /// The type of scene that represents the body of this scene.
    ///
    /// When you create a custom scene, Swift infers this type from your
    /// implementation of the required ``SkipUI/Scene/body-swift.property``
    /// property.
    associatedtype Body : Scene

    /// The content and behavior of the scene.
    ///
    /// For any scene that you create, provide a computed `body` property that
    /// defines the scene as a composition of other scenes. You can assemble a
    /// scene from built-in scenes that SkipUI provides, as well as other
    /// scenes that you've defined.
    ///
    /// Swift infers the scene's ``SkipUI/Scene/Body-swift.associatedtype``
    /// associated type based on the contents of the `body` property.
    @SceneBuilder @MainActor var body: Self.Body { get }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Scene {

    /// Runs the specified action when the system provides a background task.
    ///
    /// When the system wakes your app or extension for one or more background
    /// tasks, it will call any actions associated with matching tasks. When
    /// your async actions return, the system put your app back into a suspended
    /// state. The system considers the task completed when the action closure
    /// that you provide returns. If the action closure has not returned when
    /// the task runs out of time to complete, the system cancels the task. Use
    /// to observe whether the task is low on runtime.
    ///
    ///     /// An example of a Weather Application.
    ///     struct WeatherApp: App {
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 Text("Responds to App Refresh")
    ///             }
    ///             .backgroundTask(.appRefresh("WEATHER_DATA")) {
    ///                 await updateWeatherData()
    ///             }
    ///         }
    ///         func updateWeatherData() async {
    ///             // fetches new weather data and updates app state
    ///         }
    ///     }
    ///
    ///
    /// - Parameters:
    ///   - task: The type of task with which to associate the provided action.
    ///   - action: An async closure that the system runs for the specified task
    ///     type.
    public func backgroundTask<D, R>(_ task: BackgroundTask<D, R>, action: @escaping @Sendable (D) async -> R) -> some Scene where D : Sendable, R : Sendable { stubScene() }

}

@available(iOS 17.0, macOS 13.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Scene {

    /// Sets a default size for a window.
    ///
    /// Use this scene modifier to indicate a default initial size for a new
    /// window that the system creates from a ``Scene`` declaration. For
    /// example, you can request that new windows that a ``WindowGroup``
    /// generates occupy 600 points in the x-dimension and 400 points in
    /// the y-dimension:
    ///
    ///     @main
    ///     struct MyApp: App {
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 ContentView()
    ///             }
    ///             .defaultSize(CGSize(width: 600, height: 400))
    ///         }
    ///     }
    ///
    /// The size that you specify acts only as a default for when the window
    /// first appears. People can later resize the window using interface
    /// controls that the system provides. Also, during state restoration,
    /// the system restores windows to their most recent size rather than
    /// the default size.
    ///
    /// If you specify a default size that's outside the range of the window's
    /// inherent resizability in one or both dimensions, the system clamps the
    /// affected dimension to keep it in range. You can configure the
    /// resizability of a scene using the ``Scene/windowResizability(_:)``
    /// modifier.
    ///
    /// The default size modifier affects any scene type that creates windows
    /// in macOS, namely:
    ///
    ///  * ``WindowGroup``
    ///  * ``Window``
    ///  * ``DocumentGroup``
    ///  * ``Settings``
    ///
    /// If you want to specify the input directly in terms of width and height,
    /// use ``Scene/defaultSize(width:height:)`` instead.
    ///
    /// - Parameter size: The default size for new windows created from a scene.
    ///
    /// - Returns: A scene that uses a default size for new windows.
    public func defaultSize(_ size: CGSize) -> some Scene { stubScene() }


    /// Sets a default width and height for a window.
    ///
    /// Use this scene modifier to indicate a default initial size for a new
    /// window that the system creates from a ``Scene`` declaration. For
    /// example, you can request that new windows that a ``WindowGroup``
    /// generates occupy 600 points in the x-dimension and 400 points in
    /// the y-dimension:
    ///
    ///     @main
    ///     struct MyApp: App {
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 ContentView()
    ///             }
    ///             .defaultSize(width: 600, height: 400)
    ///         }
    ///     }
    ///
    /// The size that you specify acts only as a default for when the window
    /// first appears. People can later resize the window using interface
    /// controls that the system provides. Also, during state restoration,
    /// the system restores windows to their most recent size rather than
    /// the default size.
    ///
    /// If you specify a default size that's outside the range of the window's
    /// inherent resizability in one or both dimensions, the system clamps the
    /// affected dimension to keep it in range. You can configure the
    /// resizability of a scene using the ``Scene/windowResizability(_:)``
    /// modifier.
    ///
    /// The default size modifier affects any scene type that creates windows
    /// in macOS, namely:
    ///
    ///  * ``WindowGroup``
    ///  * ``Window``
    ///  * ``DocumentGroup``
    ///  * ``Settings``
    ///
    /// If you want to specify the size input in terms of size instance,
    /// use ``Scene/defaultSize(_:)`` instead.
    ///
    /// - Parameter width: The default width for windows created from a scene.
    /// - Parameter height: The default height for windows created from a scene.
    ///
    /// - Returns: A scene that uses a default size for new windows.
    public func defaultSize(width: CGFloat, height: CGFloat) -> some Scene { stubScene() }

}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Scene {

    /// Removes all commands defined by the modified scene.
    ///
    /// `WindowGroup`, `Window`, and other scene types all have an associated
    /// set of commands that they include by default. Apply this modifier to a
    /// scene to exclude those commands.
    ///
    /// For example, the following code adds a scene for presenting the details
    /// of an individual data model in a separate window. To ensure that the
    /// window can only appear programmatically, we remove the scene's commands,
    /// including File > New Note Window.
    ///
    ///     @main
    ///     struct Example: App {
    ///         var body: some Scene {
    ///             ...
    ///
    ///             WindowGroup("Note", id: "note", for: Note.ID.self) {
    ///                 NoteDetailView(id: $0)
    ///             }
    ///             .commandsRemoved()
    ///         }
    ///     }
    ///
    /// - Returns: A scene that excludes any commands defined by its children.
    public func commandsRemoved() -> some Scene { stubScene() }


    /// Replaces all commands defined by the modified scene with the commands
    /// from the builder.
    ///
    /// `WindowGroup`, `Window`, and other scene types all have an associated
    /// set of commands that they include by default. Apply this modifier to a
    /// scene to replace those commands with the output from the given builder.
    ///
    /// For example, the following code adds a scene for showing the contents of
    /// the pasteboard in a dedicated window. We replace the scene's default
    /// Window > Clipboard menu command with a custom Edit > Show Clipboard
    /// command that we place next to the other pasteboard commands.
    ///
    ///     @main
    ///     struct Example: App {
    ///         @Environment(\.openWindow) var openWindow
    ///
    ///         var body: some Scene {
    ///             ...
    ///
    ///             Window("Clipboard", id: "clipboard") {
    ///                 ClipboardContentView()
    ///             }
    ///             .commandsReplaced {
    ///                 CommandGroup(after: .pasteboard) {
    ///                     Section {
    ///                         Button("Show Clipboard") {
    ///                             openWindow(id: "clipboard")
    ///                         }
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - content: A `Commands` builder whose output will be used to replace
    ///     the commands normally provided by the modified scene.
    ///
    /// - Returns: A scene that replaces any commands defined by its children
    ///   with alternative content.
    public func commandsReplaced<Content>(@CommandsBuilder content: () -> Content) -> some Scene where Content : Commands { stubScene() }

}

@available(iOS 17.0, macOS 13.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Scene {

    /// Sets the kind of resizability to use for a window.
    ///
    /// Use this scene modifier to apply a value of type ``WindowResizability``
    /// to a ``Scene`` that you define in your ``App`` declaration.
    /// The value that you specify indicates the strategy the system uses to
    /// place minimum and maximum size restrictions on windows that it creates
    /// from that scene.
    ///
    /// For example, you can create a window group that people can resize to
    /// between 100 and 400 points in both dimensions by applying both a frame
    /// with those constraints to the scene's content, and the
    /// ``WindowResizability/contentSize`` resizability to the scene:
    ///
    ///     @main
    ///     struct MyApp: App {
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 ContentView()
    ///                     .frame(
    ///                         minWidth: 100, maxWidth: 400,
    ///                         minHeight: 100, maxHeight: 400)
    ///             }
    ///             .windowResizability(.contentSize)
    ///         }
    ///     }
    ///
    /// The default value for all scenes if you don't apply the modifier is
    /// ``WindowResizability/automatic``. With that strategy, ``Settings``
    /// windows use the ``WindowResizability/contentSize`` strategy, while
    /// all others use ``WindowResizability/contentMinSize``.
    ///
    /// - Parameter resizability: The resizability to use for windows created by
    ///   this scene.
    ///
    /// - Returns: A scene that uses the specified resizability strategy.
    public func windowResizability(_ resizability: WindowResizability) -> some Scene { stubScene() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Scene {

    /// Adds an action to perform when the given value changes.
    ///
    /// Use this modifier to trigger a side effect when a value changes, like
    /// the value associated with an ``SkipUI/Environment`` value or a
    /// ``SkipUI/Binding``. For example, you can clear a cache when you notice
    /// that a scene moves to the background:
    ///
    ///     struct MyScene: Scene {
    ///         @Environment(\.scenePhase) private var scenePhase
    ///         @StateObject private var cache = DataCache()
    ///
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 MyRootView()
    ///             }
    ///             .onChange(of: scenePhase) { newScenePhase in
    ///                 if newScenePhase == .background {
    ///                     cache.empty()
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task:
    ///
    ///     .onChange(of: scenePhase) { newScenePhase in
    ///         if newScenePhase == .background {
    ///             Task.detached(priority: .background) {
    ///                 // ...
    ///             }
    ///         }
    ///     }
    ///
    /// The system passes the new value into the closure. If you need the old
    /// value, capture it in the closure.
    ///
    /// Important: This modifier is deprecated and has been replaced with new
    /// versions that include either zero or two parameters within the closure,
    /// unlike this version that includes one parameter. This deprecated version
    /// and the new versions behave differently with respect to how they execute
    /// the action closure, specifically when the closure captures other values.
    /// Using the deprecated API, the closure is run with captured values that
    /// represent the "old" state. With the replacement API, the closure is run
    /// with captured values that represent the "new" state, which makes it
    /// easier to correctly perform updates that rely on supplementary values
    /// (that may or may not have changed) in addition to the changed value that
    /// triggered the action.
    ///
    /// - Important: This modifier is deprecated and has been replaced with new
    ///   versions that include either zero or two parameters within the
    ///   closure, unlike this version that includes one parameter. This
    ///   deprecated version and the new versions behave differently with
    ///   respect to how they execute the action closure, specifically when the
    ///   closure captures other values. Using the deprecated API, the closure
    ///   is run with captured values that represent the "old" state. With the
    ///   replacement API, the closure is run with captured values that
    ///   represent the "new" state, which makes it easier to correctly perform
    ///   updates that rely on supplementary values (that may or may not have
    ///   changed) in addition to the changed value that triggered the action.
    ///
    /// - Parameters:
    ///   - value: The value to check when determining whether to run the
    ///     closure. The value must conform to the
    ///     
    ///     protocol.
    ///   - action: A closure to run when the value changes. The closure
    ///     provides a single `newValue` parameter that indicates the changed
    ///     value.
    ///
    /// - Returns: A scene that triggers an action in response to a change.
    @available(iOS, deprecated: 17.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(macOS, deprecated: 14.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(tvOS, deprecated: 17.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(watchOS, deprecated: 10.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(xrOS, deprecated: 1.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    public func onChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some Scene where V : Equatable { stubScene() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Scene {

    /// Adds an action to perform when the given value changes.
    ///
    /// Use this modifier to trigger a side effect when a value changes, like
    /// the value associated with an ``SkipUI/Environment`` key or a
    /// ``SkipUI/Binding``. For example, you can clear a cache when you notice
    /// that a scene moves to the background:
    ///
    ///     struct MyScene: Scene {
    ///         @Environment(\.scenePhase) private var scenePhase
    ///         @StateObject private var cache = DataCache()
    ///
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 MyRootView(cache: cache)
    ///             }
    ///             .onChange(of: scenePhase) { oldScenePhase, newScenePhase in
    ///                 if newScenePhase == .background {
    ///                     cache.empty()
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task:
    ///
    ///     .onChange(of: scenePhase) { oldScenePhase, newScenePhase in
    ///         if newScenePhase == .background {
    ///             Task.detached(priority: .background) {
    ///                 // ...
    ///             }
    ///         }
    ///     }
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value. The system passes the old and new
    /// observed values into the closure.
    ///
    /// - Parameters:
    ///   - value: The value to check when determining whether to run the
    ///     closure. The value must conform to the
    ///     
    ///     protocol.
    ///   - initial: Whether the action should be run when this scene initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///   - oldValue: The old value that failed the comparison check (or the
    ///     initial value when requested).
    ///   - newValue: The new value that failed the comparison check.
    ///
    /// - Returns: A scene that triggers an action in response to a change.
    public func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> some Scene where V : Equatable { stubScene() }


    /// Adds an action to perform when the given value changes.
    ///
    /// Use this modifier to trigger a side effect when a value changes, like
    /// the value associated with an ``SkipUI/Environment`` key or a
    /// ``SkipUI/Binding``. For example, you can clear a cache when you notice
    /// that a scene moves to the background:
    ///
    ///     struct MyScene: Scene {
    ///         @Environment(\.locale) private var locale
    ///         @StateObject private var cache = LocalizationDataCache()
    ///
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 MyRootView(cache: cache)
    ///             }
    ///             .onChange(of: locale) {
    ///                 cache.empty()
    ///             }
    ///         }
    ///     }
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task:
    ///
    ///     .onChange(of: locale) {
    ///         Task.detached(priority: .background) {
    ///             // ...
    ///         }
    ///     }
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value.
    ///
    /// - Parameters:
    ///   - value: The value to check when determining whether to run the
    ///     closure. The value must conform to the
    ///     
    ///     protocol.
    ///   - initial: Whether the action should be run when this scene initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///
    /// - Returns: A scene that triggers an action in response to a change.
    public func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping () -> Void) -> some Scene where V : Equatable { stubScene() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Scene {

    /// Adds commands to the scene.
    ///
    /// Commands are realized in different ways on different platforms. On
    /// macOS, the main menu uses the available command menus and groups to
    /// organize its main menu items. Each menu is represented as a top-level
    /// menu bar menu, and each command group has a corresponding set of menu
    /// items in one of the top-level menus, delimited by separator menu items.
    ///
    /// On iPadOS, commands with keyboard shortcuts are exposed in the shortcut
    /// discoverability HUD that users see when they hold down the Command (⌘)
    /// key.
    public func commands<Content>(@CommandsBuilder content: () -> Content) -> some Scene where Content : Commands { stubScene() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Scene {

    /// The default store used by `AppStorage` contained within the scene and
    /// its view content.
    ///
    /// If unspecified, the default store for a view hierarchy is
    /// `UserDefaults.standard`, but can be set a to a custom one. For example,
    /// sharing defaults between an app and an extension can override the
    /// default store to one created with `UserDefaults.init(suiteName:_)`.
    ///
    /// - Parameter store: The user defaults to use as the default
    ///   store for `AppStorage`.
    public func defaultAppStorage(_ store: UserDefaults) -> some Scene { stubScene() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Scene {

    /// Specifies a modifier to indicate if this Scene can be used
    /// when creating a new Scene for the received External Event.
    ///
    /// This modifier is only supported for WindowGroup Scene types.
    ///
    /// For DocumentGroups, the received External Event must have a URL
    /// for the DocumentGroup to be considered. (Either via openURL, or
    /// the webPageURL property of an NSUserActivity). The UTI for the URL
    /// is implicitly matched against the DocumentGroup's supported types.
    ///
    /// If the modifier evaluates to true, an instance of the
    /// Scene will be used.
    ///
    /// If the modifier evaluates to false, on macOS the Scene
    /// will not be used even if no other Scenes are available.
    /// This case is considered an error. On iOS, the first Scene
    /// specified in the body property for the App will be used.
    ///
    /// If no modifier is set, the Scene will be used if all
    /// other WindowGroups with a modifier evaluate to false.
    ///
    /// On platforms that only allow a single Window/Scene, this method is
    /// ignored.
    ///
    /// - Parameter matching: A Set of Strings that are checked to see
    /// if they are contained in the targetContentIdenfifier. The empty Set
    /// and empty Strings never match. The String value "*" always matches.
    public func handlesExternalEvents(matching conditions: Set<String>) -> some Scene { stubScene() }

}

/// A result builder for composing a collection of scenes into a single
/// composite scene.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@resultBuilder public struct SceneBuilder {

    /// Builds an expression within the builder.
    public static func buildExpression<Content>(_ content: Content) -> Content where Content : Scene { fatalError() }

    /// Passes a single scene written as a child scene through unmodified.
    public static func buildBlock<Content>(_ content: Content) -> Content where Content : Scene { fatalError() }
}

//@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//extension SceneBuilder {
//
//    /// Provides support for "if" statements in multi-statement closures,
//    /// producing an optional scene that is visible only when the condition
//    /// evaluates to `true`.
//    ///
//    /// "if" statements in a ``SceneBuilder`` are limited to only
//    /// `#available()` clauses.
//    public static func buildOptional(_ scene: (Scene & _LimitedAvailabilitySceneMarker)?) -> some Scene { stubScene() }
//
//
//    /// Provides support for "if" statements with `#available()` clauses in
//    /// multi-statement closures, producing conditional content for the "then"
//    /// branch, i.e. the conditionally-available branch.
//    public static func buildLimitedAvailability(_ scene: some Scene) -> Scene & _LimitedAvailabilitySceneMarker { stubScene() }
//}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension SceneBuilder {

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> some Scene where C0 : Scene, C1 : Scene { stubScene() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension SceneBuilder {

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> some Scene where C0 : Scene, C1 : Scene, C2 : Scene { stubScene() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension SceneBuilder {

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> some Scene where C0 : Scene, C1 : Scene, C2 : Scene, C3 : Scene { stubScene() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension SceneBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> some Scene where C0 : Scene, C1 : Scene, C2 : Scene, C3 : Scene, C4 : Scene { stubScene() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension SceneBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> some Scene where C0 : Scene, C1 : Scene, C2 : Scene, C3 : Scene, C4 : Scene, C5 : Scene { stubScene() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension SceneBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> some Scene where C0 : Scene, C1 : Scene, C2 : Scene, C3 : Scene, C4 : Scene, C5 : Scene, C6 : Scene { stubScene() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension SceneBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> some Scene where C0 : Scene, C1 : Scene, C2 : Scene, C3 : Scene, C4 : Scene, C5 : Scene, C6 : Scene, C7 : Scene { stubScene() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension SceneBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> some Scene where C0 : Scene, C1 : Scene, C2 : Scene, C3 : Scene, C4 : Scene, C5 : Scene, C6 : Scene, C7 : Scene, C8 : Scene { stubScene() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension SceneBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> some Scene where C0 : Scene, C1 : Scene, C2 : Scene, C3 : Scene, C4 : Scene, C5 : Scene, C6 : Scene, C7 : Scene, C8 : Scene, C9 : Scene { stubScene() }

}

/// The padding used to space a view from its containing scene.
///
/// Add scene padding to a view using the ``View/scenePadding(_:edges:)``
/// modifier.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ScenePadding : Equatable, Sendable {

    /// The minimum scene padding value.
    ///
    /// In macOS, this value represents the recommended spacing for the root
    /// view of a window. In watchOS, this represents the horizontal spacing
    /// that you use to align your view with the title of a navigation view.
    public static let minimum: ScenePadding = { fatalError() }()

    
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Adds padding to the specified edges of this view using an amount that's
    /// appropriate for the current scene.
    ///
    /// Use this modifier to add a scene-appropriate amount of padding to a
    /// view. Specify either a single edge value from ``Edge/Set``, or an
    ///  that
    /// describes the edges to pad.
    ///
    /// In macOS, use scene padding to produce the recommended spacing around
    /// the root view of a window. In watchOS, use scene padding to align
    /// elements of your user interface with top level elements, like the title
    /// of a navigation view. For example, compare the effects of different
    /// kinds of padding on text views presented inside a ``NavigationView``
    /// in watchOS:
    ///
    ///     VStack(alignment: .leading, spacing: 10) {
    ///         Text("Scene padding")
    ///             .scenePadding(.horizontal)
    ///             .border(.red) // Border added for reference.
    ///         Text("Regular padding")
    ///             .padding(.horizontal)
    ///             .border(.green)
    ///         Text("Text with no padding")
    ///             .border(.blue)
    ///         Button("Button") { }
    ///     }
    ///     .navigationTitle("Hello World")
    ///
    /// The text with scene padding automatically aligns with the title,
    /// unlike the text that uses the default padding or the text without
    /// padding:
    ///
    /// ![A watchOS screenshot with the title Hello World and a back button
    /// in the upper left. The title is indented by a small amount from
    /// the leading edge of the screen. Three bordered strings and a button
    /// appear arranged vertically below the title.
    /// The first string says Scene padding and has a red border that's aligned
    /// with the leading edge of the screen. The leading
    /// edge of the string inside the border aligns with the leading edge of
    /// the screen's title.
    /// The second string says Regular padding and has a green border that's
    /// aligned with the leading edge of the screen. The leading edge of the
    /// string appears offset from the title's leading edge by a small amount.
    /// The third string says Text with no padding and has a blue border that's
    /// aligned with the leading edge of the screen. The string is also aligned
    /// with the leading edge of the screen.](View-scenePadding-1-watchOS)
    ///
    /// Scene padding in watchOS also ensures that your content avoids the
    /// curved edges of a device like Apple Watch Series 7.
    /// In other platforms, scene padding produces the same default padding that
    /// you get from the ``View/padding(_:_:)`` modifier.
    ///
    /// > Important: Scene padding doesn't pad the top and bottom edges of a
    /// view in watchOS, even if you specify those edges as part of the input.
    /// For example, if you specify ``Edge/Set/vertical`` instead of
    /// ``Edge/Set/horizontal`` in the example above, the modifier would have
    /// no effect in watchOS. It does, however, apply to all the edges that you
    /// specify in other platforms.
    ///
    /// - Parameter edges: The set of edges along which to pad this view.
    ///
    /// - Returns: A view that's padded on specified edges by a
    ///   scene-appropriate amount.
    public func scenePadding(_ edges: Edge.Set = .all) -> some View { return stubView() }


    /// Adds a specified kind of padding to the specified edges of this view
    /// using an amount that's appropriate for the current scene.
    ///
    /// Use this modifier to add a scene-appropriate amount of padding to a
    /// view. Specify either a single edge value from ``Edge/Set``, or an
    ///  that
    /// describes the edges to pad.
    ///
    /// In macOS, use scene padding to produce the recommended spacing around
    /// the root view of a window. In watchOS, use scene padding to align
    /// elements of your user interface with top level elements, like the title
    /// of a navigation view. For example, compare the effects of different
    /// kinds of padding on text views presented inside a ``NavigationView``
    /// in watchOS:
    ///
    ///     VStack(alignment: .leading, spacing: 10) {
    ///         Text("Minimum Scene padding")
    ///             .scenePadding(.minimum, edges: .horizontal)
    ///             .border(.red) // Border added for reference.
    ///         Text("Navigation Bar Scene padding")
    ///             .scenePadding(.navigationBar, edges: .horizontal)
    ///             .border(.yellow)
    ///         Text("Regular padding")
    ///             .padding(.horizontal)
    ///             .border(.green)
    ///         Text("Text with no padding")
    ///             .border(.blue)
    ///         Button("Button") { }
    ///     }
    ///     .navigationTitle("Hello World")
    ///
    /// The text with minimum scene padding uses the system minimum padding
    /// and the text with navigation bar scene padding automatically aligns
    /// with the navigation bar content. In contrast, the text that uses the
    /// default padding and the text without padding do not align with scene
    /// elements.
    ///
    /// Scene padding in watchOS also ensures that your content avoids the
    /// curved edges of a device like Apple Watch Series 7.
    /// In other platforms, scene padding produces the same default padding that
    /// you get from the ``View/padding(_:_:)`` modifier.
    ///
    /// > Important: Scene padding doesn't pad the top and bottom edges of a
    /// view in watchOS, even if you specify those edges as part of the input.
    /// For example, if you specify ``Edge/Set/vertical`` instead of
    /// ``Edge/Set/horizontal`` in the example above, the modifier would have
    /// no effect in watchOS. It does, however, apply to all the edges that you
    /// specify in other platforms.
    ///
    /// - Parameter padding: The kind of padding to add.
    /// - Parameter edges: The set of edges along which to pad this view.
    ///
    /// - Returns: A view that's padded on specified edges by a
    ///   scene-appropriate amount.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func scenePadding(_ padding: ScenePadding, edges: Edge.Set = .all) -> some View { return stubView() }

}

/// An indication of a scene's operational state.
///
/// The system moves your app's ``Scene`` instances through phases that reflect
/// a scene's operational state. You can trigger actions when the phase changes.
/// Read the current phase by observing the ``EnvironmentValues/scenePhase``
/// value in the ``Environment``:
///
///     @Environment(\.scenePhase) private var scenePhase
///
/// How you interpret the value depends on where it's read from.
/// If you read the phase from inside a ``View`` instance, you obtain a value
/// that reflects the phase of the scene that contains the view. The following
/// example uses the ``SkipUI/View/onChange(of:perform:)`` method to enable
/// a timer whenever the enclosing scene enters the ``ScenePhase/active`` phase
/// and disable the timer when entering any other phase:
///
///     struct MyView: View {
///         @ObservedObject var model: DataModel
///         @Environment(\.scenePhase) private var scenePhase
///
///         var body: some View {
///             TimerView()
///                 .onChange(of: scenePhase) { phase in
///                     model.isTimerRunning = (phase == .active)
///                 }
///         }
///     }
///
/// If you read the phase from within an ``App`` instance, you obtain an
/// aggregate value that reflects the phases of all the scenes in your app. The
/// app reports a value of ``ScenePhase/active`` if any scene is active, or a
/// value of ``ScenePhase/inactive`` when no scenes are active. This includes
/// multiple scene instances created from a single scene declaration; for
/// example, from a ``WindowGroup``. When an app enters the
/// ``ScenePhase/background`` phase, expect the app to terminate soon after.
/// You can use that opportunity to free any resources:
///
///     @main
///     struct MyApp: App {
///         @Environment(\.scenePhase) private var scenePhase
///
///         var body: some Scene {
///             WindowGroup {
///                 MyRootView()
///             }
///             .onChange(of: scenePhase) { phase in
///                 if phase == .background {
///                     // Perform cleanup when all scenes within
///                     // MyApp go to the background.
///                 }
///             }
///         }
///     }
///
/// If you read the phase from within a custom ``Scene`` instance, the value
/// similarly reflects an aggregation of all the scenes that make up the custom
/// scene:
///
///     struct MyScene: Scene {
///         @Environment(\.scenePhase) private var scenePhase
///
///         var body: some Scene {
///             WindowGroup {
///                 MyRootView()
///             }
///             .onChange(of: scenePhase) { phase in
///                 if phase == .background {
///                     // Perform cleanup when all scenes within
///                     // MyScene go to the background.
///                 }
///             }
///         }
///     }
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public enum ScenePhase : Comparable {

    /// The scene isn't currently visible in the UI.
    ///
    /// Do as little as possible in a scene that's in the `background` phase.
    /// The `background` phase can precede termination, so do any cleanup work
    /// immediately upon entering this state. For example, close any open files
    /// and network connections. However, a scene can also return to the
    /// ``ScenePhase/active`` phase from the background.
    ///
    /// Expect an app that enters the `background` phase to terminate.
    case background

    /// The scene is in the foreground but should pause its work.
    ///
    /// A scene in this phase doesn't receive events and should pause
    /// timers and free any unnecessary resources. The scene might be completely
    /// hidden in the user interface or otherwise unavailable to the user.
    /// In macOS, scenes only pass through this phase temporarily on their way
    /// to the ``ScenePhase/background`` phase.
    ///
    /// An app or custom scene in this phase contains no scene instances in the
    /// ``ScenePhase/active`` phase.
    case inactive

    /// The scene is in the foreground and interactive.
    ///
    /// An active scene isn't necessarily front-most. For example, a macOS
    /// window might be active even if it doesn't currently have focus.
    /// Nevertheless, all scenes should operate normally in this phase.
    ///
    /// An app or custom scene in this phase contains at least one active scene
    /// instance.
    case active

    


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
    public static func < (a: ScenePhase, b: ScenePhase) -> Bool { fatalError() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ScenePhase : Sendable {
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ScenePhase : Hashable {
}

//@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//extension Group : Scene where Content : Scene {
//    public var body: Never { fatalError() }
//
//
//    /// Creates a group of scenes.
//    ///
//    /// - Parameter content: A ``SkipUI/SceneBuilder`` that produces the scenes
//    /// to group.
//    @inlinable public init(@SceneBuilder content: () -> Content) { fatalError() }
//}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Never : Scene {
}

#endif
