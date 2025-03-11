// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.gestures.ScrollableState
import androidx.compose.runtime.Composable
#endif

public protocol ToolbarContent : View {
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

public struct ToolbarItem : CustomizableToolbarContent {
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
        EnvironmentValues.shared.setValues {
            if placement == .confirmationAction {
                var textEnvironment = $0._textEnvironment
                textEnvironment.fontWeight = Font.Weight.bold
                $0.set_textEnvironment(textEnvironment)
            }
        } in: {
            content.Compose(context: context)
        }
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

public enum ToolbarCustomizationBehavior {
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
    case navigationBarLeading
    case navigationBarTrailing
}

public enum ToolbarPlacement: Equatable {
    case automatic
    case bottomBar
    case navigationBar
    case tabBar
}

public enum ToolbarRole {
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

public struct ToolbarCustomizationOptions : OptionSet {
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

    public func toolbar(_ visibility: Visibility) -> some View {
        return toolbar(visibility, for: .bottomBar, .navigationBar, .tabBar)
    }

    public func toolbar(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        #if SKIP
        // SKIP REPLACE: var view = this
        var view = self
        if bars.contains(ToolbarPlacement.tabBar) {
            view = view.preference(key: TabBarPreferenceKey.self, value: ToolbarBarPreferences(visibility: visibility))
        }
        if bars.contains(where: { $0 != ToolbarPlacement.tabBar }) {
            view = view.preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(visibility: visibility, for: bars))
        }
        return view
        #else
        return self
        #endif
    }

    public func toolbarBackground(_ style: any ShapeStyle) -> some View {
        return toolbarBackground(style, for: .bottomBar, .navigationBar, .tabBar)
    }

    public func toolbarBackground(_ style: any ShapeStyle, for bars: ToolbarPlacement...) -> some View {
        #if SKIP
        // SKIP REPLACE: var view = this
        var view = self
        if bars.contains(ToolbarPlacement.tabBar) {
            view = view.preference(key: TabBarPreferenceKey.self, value: ToolbarBarPreferences(background: style))
        }
        if bars.contains(where: { $0 != ToolbarPlacement.tabBar }) {
            view = view.preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(background: style, for: bars))
        }
        return view
        #else
        return self
        #endif
    }

    public func toolbarBackground(_ visibility: Visibility) -> some View {
        return toolbarBackground(visibility, for: .bottomBar, .navigationBar, .tabBar)
    }

    public func toolbarBackground(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        #if SKIP
        // SKIP REPLACE: var view = this
        var view = self
        if bars.contains(ToolbarPlacement.tabBar) {
            view = view.preference(key: TabBarPreferenceKey.self, value: ToolbarBarPreferences(backgroundVisibility: visibility))
        }
        if bars.contains(where: { $0 != ToolbarPlacement.tabBar }) {
            view = view.preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(backgroundVisibility: visibility, for: bars))
        }
        return view
        #else
        return self
        #endif
    }

    public func toolbarColorScheme(_ colorScheme: ColorScheme?) -> some View {
        return toolbarColorScheme(colorScheme, for: .bottomBar, .navigationBar, .tabBar)
    }

    public func toolbarColorScheme(_ colorScheme: ColorScheme?, for bars: ToolbarPlacement...) -> some View {
        #if SKIP
        // SKIP REPLACE: var view = this
        var view = self
        if bars.contains(ToolbarPlacement.tabBar) {
            view = view.preference(key: TabBarPreferenceKey.self, value: ToolbarBarPreferences(colorScheme: colorScheme))
        }
        if bars.contains(where: { $0 != ToolbarPlacement.tabBar }) {
            view = view.preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(colorScheme: colorScheme, for: bars))
        }
        return view
        #else
        return self
        #endif
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
    typealias Value = ToolbarPreferences

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<ToolbarPreferences>
    class Companion: PreferenceKeyCompanion {
        let defaultValue = ToolbarPreferences()
        func reduce(value: inout ToolbarPreferences, nextValue: () -> ToolbarPreferences) {
            value = value.reduce(nextValue())
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

    init(content: [View]? = nil, titleDisplayMode: ToolbarTitleDisplayMode? = nil, titleMenu: View? = nil, backButtonHidden: Bool? = nil, navigationBar: ToolbarBarPreferences? = nil, bottomBar: ToolbarBarPreferences? = nil) {
        self.content = content
        self.titleDisplayMode = titleDisplayMode
        self.titleMenu = titleMenu
        self.backButtonHidden = backButtonHidden
        self.navigationBar = navigationBar
        self.bottomBar = bottomBar
    }

    init(visibility: Visibility? = nil, background: ShapeStyle? = nil, backgroundVisibility: Visibility? = nil, colorScheme: ColorScheme? = nil, isSystemBackground: Bool? = nil, scrollableState: ScrollableState? = nil, for bars: [ToolbarPlacement]) {
        let barPreferences = ToolbarBarPreferences(visibility: visibility, background: background, backgroundVisibility: backgroundVisibility, colorScheme: colorScheme, isSystemBackground: isSystemBackground, scrollableState: scrollableState)
        var navigationBar: ToolbarBarPreferences? = nil
        var bottomBar: ToolbarBarPreferences? = nil
        for bar in bars {
            switch bar {
            case .automatic, .navigationBar:
                navigationBar = barPreferences
            case .bottomBar:
                bottomBar = barPreferences
            case .tabBar:
                break
            }
        }
        self.navigationBar = navigationBar
        self.bottomBar = bottomBar
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
        return ToolbarPreferences(content: rcontent, titleDisplayMode: next.titleDisplayMode ?? titleDisplayMode, titleMenu: next.titleMenu ?? titleMenu, backButtonHidden: next.backButtonHidden ?? backButtonHidden, navigationBar: reduceBar(navigationBar, next.navigationBar), bottomBar: reduceBar(bottomBar, next.bottomBar))
    }

    private func reduceBar(_ bar: ToolbarBarPreferences?, _ next: ToolbarBarPreferences?) -> ToolbarBarPreferences? {
        if let bar, let next {
            return bar.reduce(next)
        } else {
            return next ?? bar
        }
    }

    public static func ==(lhs: ToolbarPreferences, rhs: ToolbarPreferences) -> Bool {
        guard lhs.titleDisplayMode == rhs.titleDisplayMode, lhs.backButtonHidden == rhs.backButtonHidden, lhs.navigationBar == rhs.navigationBar, lhs.bottomBar == rhs.bottomBar else {
            return false
        }
        guard (lhs.content?.count ?? 0) == (rhs.content?.count ?? 0), (lhs.titleMenu != nil) == (rhs.titleMenu != nil) else {
            return false
        }
        // Don't compare on views because they will never compare equal. Toolbar block will get re-evaluated on
        // change to any state it accesses
        return true
    }
}

struct ToolbarBarPreferences: Equatable {
    let visibility: Visibility?
    let background: ShapeStyle?
    let backgroundVisibility: Visibility?
    let colorScheme: ColorScheme?
    let isSystemBackground: Bool?
    let scrollableState: ScrollableState?

    func reduce(_ next: ToolbarBarPreferences) -> ToolbarBarPreferences {
        return ToolbarBarPreferences(visibility: next.visibility ?? visibility, background: next.background ?? background, backgroundVisibility: next.backgroundVisibility ?? backgroundVisibility, colorScheme: next.colorScheme ?? colorScheme, isSystemBackground: next.isSystemBackground ?? isSystemBackground, scrollableState: next.scrollableState ?? scrollableState)
    }

    public static func ==(lhs: ToolbarBarPreferences, rhs: ToolbarBarPreferences) -> Bool {
        // Don't compare on background because it will never compare equal
        return lhs.visibility == rhs.visibility && lhs.backgroundVisibility == rhs.backgroundVisibility && (lhs.background != nil) == (rhs.background != nil) && lhs.colorScheme == rhs.colorScheme && lhs.isSystemBackground == rhs.isSystemBackground && lhs.scrollableState == rhs.scrollableState
    }
}

struct ToolbarItems {
    let content: [View]

    @Composable func filterTopBarLeading() -> [View] {
        return filter(expandGroups: false) {
            switch $0 {
            case .topBarLeading, .navigationBarLeading, .cancellationAction:
                return true
            default:
                return false
            }
        } + filter(expandGroups: false) { $0 == .principal }
    }

    @Composable func filterTopBarTrailing() -> [View] {
        return filter(expandGroups: false) {
            switch $0 {
            case .automatic, .confirmationAction, .primaryAction, .secondaryAction, .topBarTrailing, .navigationBarTrailing:
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
        let filtered = mutableListOf<View>()
        let context = ComposeContext(composer: SideEffectComposer { view, context in
            filter(view: view, expandGroups: expandGroups, placement: placement, filtered: filtered, context: context)
        })
        content.forEach { $0.Compose(context: context) }
        return Array(filtered, nocopy: true)
    }

    @Composable private func filter(view: any View, expandGroups: Bool, placement: (ToolbarItemPlacement) -> Bool, filtered: MutableList<View>, context: (Bool) -> ComposeContext) -> ComposeResult {
        if let itemGroup = view as? ToolbarItemGroup {
            if placement(itemGroup.placement) {
                if expandGroups {
                    itemGroup.content.collectViews(context: context(false))
                        .filter { !$0.isSwiftUIEmptyView }
                        .forEach { filtered.add($0) }
                } else {
                    filtered.add(itemGroup)
                }
            }
        } else if let item = view as? ToolbarItem {
            if placement(item.placement) {
                filtered.add(item)
            }
        } else if let toolbarContent = view as? ToolbarContent {
            // Create a builder that is able to collect the view's internal content by calling ComposeContent
            let contentBuilder = ComposeBuilder(content: { view.ComposeContent(context: $0); ComposeResult.ok })
            for view in contentBuilder.collectViews(context: context(false)) {
                filter(view: view, expandGroups: expandGroups, placement: placement, filtered: filtered, context: context)
            }
        } else if placement(.automatic), !view.isSwiftUIEmptyView {
            filtered.add(view)
        }
        return ComposeResult.ok
    }
}
#endif

#if false
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
#endif
