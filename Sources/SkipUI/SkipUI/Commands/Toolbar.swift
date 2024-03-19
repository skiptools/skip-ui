// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

public protocol ToolbarContent {
//    associatedtype Body : ToolbarContent
//    @ToolbarContentBuilder var body: Self.Body { get }
}

public protocol CustomizableToolbarContent : ToolbarContent /* where Self.Body : CustomizableToolbarContent */ {
}

extension CustomizableToolbarContent {
    @available(*, unavailable)
    public func defaultCustomization(_ defaultVisibility: Visibility = .automatic, options: ToolbarCustomizationOptions = []) -> some CustomizableToolbarContent {
        return self
    }

    @available(*, unavailable)
    public func customizationBehavior(_ behavior: ToolbarCustomizationBehavior) -> some CustomizableToolbarContent {
        return self
    }
}

// We base our toolbar content on `View` rather than a custom protocol so that we can reuse the
// `@ViewBuilder` logic built into the transpiler. The Swift compiler will guarantee that the
// only allowed toolbar content are types that conform to `ToolbarContent`

public struct ToolbarItem : CustomizableToolbarContent, View {
    let placement: ToolbarItemPlacement
    let content: ComposeBuilder

    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> any View) {
        self.placement = placement
        self.content = ComposeBuilder.from(content)
    }

    @available(*, unavailable)
    public init(id: String, placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> any View) {
        self.placement = placement
        self.content = ComposeBuilder.from(content)
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        content.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct ToolbarItemGroup : CustomizableToolbarContent, View  {
    let placement: ToolbarItemPlacement
    let content: ComposeBuilder

    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> any View) {
        self.placement = placement
        self.content = ComposeBuilder.from(content)
    }

    @available(*, unavailable)
    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> any View, @ViewBuilder label: () -> any View) {
        self.placement = placement
        self.content = ComposeBuilder.from(content)
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        content.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct ToolbarTitleMenu : CustomizableToolbarContent, View {
    @available(*, unavailable)
    public init() {
    }

    @available(*, unavailable)
    public init(@ViewBuilder content: () -> any View) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}

public enum ToolbarCustomizationBehavior : Sendable {
    case `default`
    case reorderable
    case disabled
}

public enum ToolbarItemPlacement {
    case automatic
    case principal
    case navigation
    case primaryAction
    case secondaryAction
    case status
    case confirmationAction
    case cancellationAction
    case destructiveAction
    case keyboard
    case topBarLeading
    case topBarTrailing
    case bottomBar
}

public enum ToolbarPlacement {
    case automatic
    case bottomBar
    case navigationBar
    case tabBar
}

public enum ToolbarRole : Sendable {
    case automatic
    case navigationStack
    case browser
    case editor
}

public enum ToolbarTitleDisplayMode {
    case automatic
    case large
    case inlineLarge
    case inline
}

public struct ToolbarCustomizationOptions : OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static var alwaysAvailable = ToolbarCustomizationOptions(rawValue: 1 << 0)
}

extension View {
    public func toolbar(@ViewBuilder content: () -> any View) -> some View {
        #if SKIP
        return preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(content: [content()]))
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func toolbar(id: String, @ViewBuilder content: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func toolbar(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        #if SKIP
        return preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(visibility: visibility, for: bars))
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func toolbarBackground(_ style: any ShapeStyle, for bars: ToolbarPlacement...) -> some View {
        #if SKIP
        return preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(background: style, for: bars))
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func toolbarBackground(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        #if SKIP
        return preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(backgroundVisibility: visibility, for: bars))
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func toolbarColorScheme(_ colorScheme: ColorScheme?, for bars: ToolbarPlacement...) -> some View {
        return self
    }

    public func toolbarTitleDisplayMode(_ mode: ToolbarTitleDisplayMode) -> some View {
        #if SKIP
        return preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(titleDisplayMode: mode))
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func toolbarTitleMenu(@ViewBuilder content: () -> any View) -> some View {
        #if SKIP
        return preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(titleMenu: content()))
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func toolbarRole(_ role: ToolbarRole) -> some View {
        return self
    }
}

#if SKIP
struct ToolbarPreferenceKey: PreferenceKey {
    typealias Value = ToolbarPreferences?

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<ToolbarPreferences?>
    class Companion: PreferenceKeyCompanion {
        let defaultValue: ToolbarPreferences? = nil
        func reduce(value: inout ToolbarPreferences?, nextValue: () -> ToolbarPreferences?) {
            guard let next = nextValue() else {
                return
            }
            if value == nil {
                value = next
            } else {
                value = value!.reduce(next)
            }
        }
    }
}

struct ToolbarPreferences: Equatable {
    let content: [View]?
    let titleDisplayMode: ToolbarTitleDisplayMode?
    let titleMenu: View?
    let backButtonHidden: Bool?
    let navigationBar: ToolbarBarPreferences?
    let bottomBar: ToolbarBarPreferences?
    let tabBar: ToolbarBarPreferences?

    init(content: [View]? = nil, titleDisplayMode: ToolbarTitleDisplayMode? = nil, titleMenu: View? = nil, backButtonHidden: Bool? = nil, navigationBar: ToolbarBarPreferences? = nil, bottomBar: ToolbarBarPreferences? = nil, tabBar: ToolbarBarPreferences? = nil) {
        self.content = content
        self.titleDisplayMode = titleDisplayMode
        self.titleMenu = titleMenu
        self.backButtonHidden = backButtonHidden
        self.navigationBar = navigationBar
        self.bottomBar = bottomBar
        self.tabBar = tabBar
    }

    init(visibility: Visibility? = nil, background: ShapeStyle? = nil, backgroundVisibility: Visibility? = nil, for bars: [ToolbarPlacement]) {
        let barPreferences = ToolbarBarPreferences(visibility: visibility, background: background, backgroundVisibility: backgroundVisibility)
        var navigationBar: ToolbarBarPreferences? = nil
        var bottomBar: ToolbarBarPreferences? = nil
        var tabBar: ToolbarBarPreferences? = nil
        for bar in bars {
            switch bar {
            case .automatic, .navigationBar:
                navigationBar = barPreferences
            case .bottomBar:
                bottomBar = barPreferences
            case .tabBar:
                tabBar = barPreferences
            }
        }
        self.navigationBar = navigationBar
        self.bottomBar = bottomBar
        self.tabBar = tabBar
        self.content = nil
        self.titleDisplayMode = nil
        self.titleMenu = nil
        self.backButtonHidden = nil
    }

    func reduce(_ next: ToolbarPreferences) -> ToolbarPreferences {
        let rcontent: [View]?
        if let ncontent = next.content, let content {
            rcontent = content + ncontent
        } else {
            rcontent = next.content ?? content
        }
        return ToolbarPreferences(content: rcontent, titleDisplayMode: next.titleDisplayMode ?? titleDisplayMode, titleMenu: next.titleMenu ?? titleMenu, backButtonHidden: next.backButtonHidden ?? backButtonHidden, navigationBar: reduceBar(navigationBar, next.navigationBar), bottomBar: reduceBar(bottomBar, next.bottomBar), tabBar: reduceBar(tabBar, next.tabBar))
    }

    private func reduceBar(_ bar: ToolbarBarPreferences?, _ next: ToolbarBarPreferences?) -> ToolbarBarPreferences? {
        if let bar, let next {
            return bar.reduce(next)
        } else {
            return next ?? bar
        }
    }

    public static func ==(lhs: ToolbarPreferences, rhs: ToolbarPreferences) -> Bool {
        guard lhs.titleDisplayMode == rhs.titleDisplayMode, lhs.backButtonHidden == rhs.backButtonHidden else {
            return false
        }
        guard isBarEqual(lhs.navigationBar, rhs.navigationBar), isBarEqual(lhs.bottomBar, rhs.bottomBar), isBarEqual(lhs.tabBar, rhs.tabBar) else {
            return false
        }
        guard (lhs.content?.count ?? 0) == (rhs.content?.count ?? 0), (lhs.titleMenu != nil) == (rhs.titleMenu != nil) else {
            return false
        }
        // Don't compare on views because they will never compare equal. Toolbar block will get re-evaluated on
        // change to any state it accesses
        return true
    }

    private static func isBarEqual(_ lhs: ToolbarBarPreferences?, _ rhs: ToolbarBarPreferences?) -> Bool {
        // Don't compare on background because it will never compare equal
        return lhs?.visibility == rhs?.visibility && lhs?.backgroundVisibility == rhs?.backgroundVisibility && (lhs?.background != nil) == (rhs?.background != nil)
    }
}

struct ToolbarBarPreferences {
    let visibility: Visibility?
    let background: ShapeStyle?
    let backgroundVisibility: Visibility?

    func reduce(_ next: ToolbarBarPreferences) -> ToolbarBarPreferences {
        return ToolbarBarPreferences(visibility: next.visibility ?? visibility, background: next.background ?? background, backgroundVisibility: next.backgroundVisibility ?? backgroundVisibility)
    }
}

struct ToolbarItems {
    let content: [View]

    @Composable func filterTopBarLeading() -> [View] {
        return filter(expandGroups: false) { $0 == .topBarLeading }
    }

    @Composable func filterTopBarTrailing() -> [View] {
        return filter(expandGroups: false) {
            switch $0 {
            case .automatic, .principal, .primaryAction, .secondaryAction, .topBarTrailing:
                return true
            default:
                return false
            }
        }
    }

    @Composable func filterBottomBar() -> [View] {
        var views = filter(expandGroups: true) { $0 == .bottomBar }
        // SwiftUI inserts a spacer between the first and remaining items
        if views.count > 1 && !views.contains(where: { $0.strippingModifiers { $0 is Spacer } }) {
            views.insert(Spacer(), at: 1)
        }
        return views
    }

    @Composable private func filter(expandGroups: Bool, placement: (ToolbarItemPlacement) -> Bool) -> [View] {
        var filtered: [View] = []
        let context = ComposeContext(composer: SideEffectComposer { view, context in
            if let itemGroup = view as? ToolbarItemGroup {
                if placement(itemGroup.placement) {
                    if expandGroups {
                        filtered.append(contentsOf: itemGroup.content.collectViews(context: context(false)).filter { !$0.isSwiftUIEmptyView })
                    } else {
                        filtered.append(itemGroup)
                    }
                }
            } else if let item = view as? ToolbarItem {
                if placement(item.placement) {
                    filtered.append(item)
                }
            } else if placement(.automatic), !view.isSwiftUIEmptyView {
                filtered.append(view)
            }
            return ComposeResult.ok
        })
        content.forEach { $0.Compose(context: context) }
        return filtered
    }
}
#endif

#if false

// TODO: Process for use in SkipUI

/// A built-in set of commands for manipulating window toolbars.
///
/// These commands are optional and can be explicitly requested by passing a
/// value of this type to the ``Scene/commands(content:)`` modifier.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct ToolbarCommands : Commands {

    /// A new value describing the built-in toolbar-related commands.
    public init() { fatalError() }

    /// The contents of the command hierarchy.
    ///
    /// For any commands that you create, provide a computed `body` property
    /// that defines the scene as a composition of other scenes. You can
    /// assemble a command hierarchy from built-in commands that SkipUI
    /// provides, as well as other commands that you've defined.
    public var body: some Commands { get { return stubCommands() } }

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    //public typealias Body = NeverView
}

//@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//extension Group : ToolbarContent where Content : ToolbarContent {
//    /// Creates a group of toolbar content instances.
//    ///
//    /// - Parameter content: A ``SkipUI/ToolbarContentBuilder`` that produces
//    /// the toolbar content instances to group.
//    public init(@ToolbarContentBuilder content: () -> Content) { fatalError() }
//
//    //public typealias Body = NeverView
//    public var body: some ToolbarContent { return stubToolbarContent() }
//}

//@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//extension Group : CustomizableToolbarContent where Content : CustomizableToolbarContent {
//
//    /// Creates a group of customizable toolbar content instances.
//    ///
//    /// - Parameter content: A ``SkipUI/ToolbarContentBuilder`` that produces
//    /// the customizable toolbar content instances to group.
//    public init(@ToolbarContentBuilder content: () -> Content) { fatalError() }
//
//    //public typealias Body = NeverView
//    public var body: some CustomizableToolbarContent { stubToolbar() }
//
//}

#endif
