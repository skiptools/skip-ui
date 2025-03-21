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

// SKIP @bridge
public struct ToolbarItem : View, CustomizableToolbarContent {
    let placement: ToolbarItemPlacement
    let content: ComposeBuilder

    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> any View) {
        self.placement = placement
        self.content = ComposeBuilder.from(content)
    }

    public init(id: String, placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> any View) {
        self.placement = placement
        self.content = ComposeBuilder.from(content)
    }

    // SKIP @bridge
    public init(id: String, bridgedPlacement: Int, bridgedContent: any View) {
        self.placement = ToolbarItemPlacement(rawValue: bridgedPlacement) ?? .automatic
        self.content = ComposeBuilder.from { bridgedContent }
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

// SKIP @bridge
public struct ToolbarItemGroup : CustomizableToolbarContent, View  {
    let placement: ToolbarItemPlacement
    let content: ComposeBuilder

    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> any View) {
        self.placement = placement
        self.content = ComposeBuilder.from(content)
    }

    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> any View, @ViewBuilder label: () -> any View) {
        self.placement = placement
        self.content = ComposeBuilder.from(content)
    }

    // SKIP @bridge
    public init(bridgedPlacement: Int, bridgedContent: any View) {
        self.placement = ToolbarItemPlacement(rawValue: bridgedPlacement) ?? .automatic
        self.content = ComposeBuilder.from { bridgedContent }
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

public enum ToolbarItemPlacement: Int {
    case automatic = 0 // For bridging
    case principal = 1 // For bridging
    case navigation = 2 // For bridging
    case primaryAction = 3 // For bridging
    case secondaryAction = 4 // For bridging
    case status = 5 // For bridging
    case confirmationAction = 6 // For bridging
    case cancellationAction = 7 // For bridging
    case destructiveAction = 8 // For bridging
    case keyboard = 9 // For bridging
    case topBarLeading = 10 // For bridging
    case topBarTrailing = 11 // For bridging
    case bottomBar = 12 // For bridging
    case navigationBarLeading = 13 // For bridging
    case navigationBarTrailing = 14 // For bridging
}

public enum ToolbarPlacement: Int, Equatable {
    case automatic = 0 // For bridging
    case bottomBar = 1 // For bridging
    case navigationBar = 2 // For bridging
    case tabBar = 3 // For bridging
}

public enum ToolbarRole {
    case automatic
    case navigationStack
    case browser
    case editor
}

public enum ToolbarTitleDisplayMode: Int {
    case automatic = 0 // For bridging
    case large = 1 // For bridging
    case inlineLarge = 2 // For bridging
    case inline = 3 // For bridging
}

public struct ToolbarCustomizationOptions : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static var alwaysAvailable = ToolbarCustomizationOptions(rawValue: 1 << 0)
}

extension View {
    public func toolbar(@ViewBuilder content: () -> any View) -> any View {
        return toolbar(id: "", content: content)
    }

    public func toolbar(id: String, @ViewBuilder content: () -> any View) -> any View {
        #if SKIP
        return preference(key: ToolbarContentPreferenceKey.self, value: ToolbarContentPreferences(content: [content()]))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func toolbar(id: String, bridgedContent: any View) -> any View {
        #if SKIP
        return preference(key: ToolbarContentPreferenceKey.self, value: ToolbarContentPreferences(content: [bridgedContent]))
        #else
        return self
        #endif
    }

    public func toolbar(_ visibility: Visibility) -> any View {
        return _toolbarVisibility(visibility, for: [])
    }

    public func toolbar(_ visibility: Visibility, for bars: ToolbarPlacement...) -> any View {
        return _toolbarVisibility(visibility, for: bars)
    }

    public func toolbarVisibility(_ visibility: Visibility) -> any View {
        return _toolbarVisibility(visibility, for: [])
    }

    public func toolbarVisibility(_ visibility: Visibility, for bars: ToolbarPlacement...) -> any View {
        return _toolbarVisibility(visibility, for: bars)
    }

    // SKIP @bridge
    public func toolbarVisibility(bridgedVisibility: Int, bridgedPlacements: [Int]) -> any View {
        return _toolbarVisibility(Visibility(rawValue: bridgedVisibility) ?? .automatic, for: bridgedPlacements.compactMap { ToolbarPlacement(rawValue: $0) })
    }

    public func _toolbarVisibility(_ visibility: Visibility, for placements: [ToolbarPlacement]) -> any View {
        #if SKIP
        // SKIP REPLACE: var view = this
        var view = self
        var bars = placements
        if bars.isEmpty {
            bars = [.bottomBar, .navigationBar, .tabBar]
        }
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

    public func toolbarBackground(_ style: any ShapeStyle) -> any View {
        return _toolbarBackground(style, for: [])
    }

    public func toolbarBackground(_ style: any ShapeStyle, for bars: ToolbarPlacement...) -> any View {
        return _toolbarBackground(style, for: bars)
    }

    // SKIP @bridge
    public func toolbarBackground(_ style: any ShapeStyle, bridgedPlacements: [Int]) -> any View {
        return _toolbarBackground(style, for: bridgedPlacements.compactMap { ToolbarPlacement(rawValue: $0) })
    }

    public func _toolbarBackground(_ style: any ShapeStyle, for placements: [ToolbarPlacement]) -> any View {
        #if SKIP
        // SKIP REPLACE: var view = this
        var view = self
        var bars = placements
        if bars.isEmpty {
            bars = [.bottomBar, .navigationBar, .tabBar]
        }
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

    public func toolbarBackground(_ visibility: Visibility) -> any View {
        return _toolbarBackgroundVisibility(visibility, for: [])
    }

    public func toolbarBackground(_ visibility: Visibility, for bars: ToolbarPlacement...) -> any View {
        return _toolbarBackgroundVisibility(visibility, for: bars)
    }

    public func toolbarBackgroundVisibility(_ visibility: Visibility) -> any View {
        return _toolbarBackgroundVisibility(visibility, for: [])
    }

    public func toolbarBackgroundVisibility(_ visibility: Visibility, for bars: ToolbarPlacement...) -> any View {
        return _toolbarBackgroundVisibility(visibility, for: bars)
    }

    // SKIP @bridge
    public func toolbarBackgroundVisibility(bridgedVisibility: Int, bridgedPlacements: [Int]) -> any View {
        return _toolbarBackgroundVisibility(Visibility(rawValue: bridgedVisibility) ?? .automatic, for: bridgedPlacements.compactMap { ToolbarPlacement(rawValue: $0) })
    }

    public func _toolbarBackgroundVisibility(_ visibility: Visibility, for placements: [ToolbarPlacement]) -> any View {
        #if SKIP
        // SKIP REPLACE: var view = this
        var view = self
        var bars = placements
        if bars.isEmpty {
            bars = [.bottomBar, .navigationBar, .tabBar]
        }
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

    public func toolbarColorScheme(_ colorScheme: ColorScheme?) -> any View {
        return _toolbarColorScheme(colorScheme, for: [])
    }

    public func toolbarColorScheme(_ colorScheme: ColorScheme?, for bars: ToolbarPlacement...) -> any View {
        return _toolbarColorScheme(colorScheme, for: bars)
    }

    // SKIP @bridge
    public func toolbarColorScheme(bridgedColorScheme: Int?, bridgedPlacements: [Int]) -> any View {
        let colorScheme: ColorScheme? = bridgedColorScheme == nil ? nil : ColorScheme(rawValue: bridgedColorScheme!)
        return _toolbarColorScheme(colorScheme, for: bridgedPlacements.compactMap { ToolbarPlacement(rawValue: $0) })
    }

    public func _toolbarColorScheme(_ colorScheme: ColorScheme?, for placements: [ToolbarPlacement]) -> some View {
        #if SKIP
        // SKIP REPLACE: var view = this
        var view = self
        var bars = placements
        if bars.isEmpty {
            bars = [.bottomBar, .navigationBar, .tabBar]
        }
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

    public func toolbarTitleDisplayMode(_ mode: ToolbarTitleDisplayMode) -> any View {
        #if SKIP
        return preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(titleDisplayMode: mode))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func toolbarTitleDisplayMode(bridgedMode: Int) -> any View {
        return toolbarTitleDisplayMode(ToolbarTitleDisplayMode(rawValue: bridgedMode) ?? .automatic)
    }

    @available(*, unavailable)
    public func toolbarTitleMenu(@ViewBuilder content: () -> any View) -> some View {
        #if SKIP
        return preference(key: ToolbarContentPreferenceKey.self, value: ToolbarContentPreferences(titleMenu: content()))
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
    let titleDisplayMode: ToolbarTitleDisplayMode?
    let backButtonHidden: Bool?
    let navigationBar: ToolbarBarPreferences?
    let bottomBar: ToolbarBarPreferences?

    init(titleDisplayMode: ToolbarTitleDisplayMode? = nil, backButtonHidden: Bool? = nil, navigationBar: ToolbarBarPreferences? = nil, bottomBar: ToolbarBarPreferences? = nil) {
        self.titleDisplayMode = titleDisplayMode
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
        self.titleDisplayMode = nil
        self.backButtonHidden = nil
    }

    func reduce(_ next: ToolbarPreferences) -> ToolbarPreferences {
        return ToolbarPreferences(titleDisplayMode: next.titleDisplayMode ?? titleDisplayMode, backButtonHidden: next.backButtonHidden ?? backButtonHidden, navigationBar: reduceBar(navigationBar, next.navigationBar), bottomBar: reduceBar(bottomBar, next.bottomBar))
    }

    private func reduceBar(_ bar: ToolbarBarPreferences?, _ next: ToolbarBarPreferences?) -> ToolbarBarPreferences? {
        if let bar, let next {
            return bar.reduce(next)
        } else {
            return next ?? bar
        }
    }

    public static func ==(lhs: ToolbarPreferences, rhs: ToolbarPreferences) -> Bool {
        return lhs.titleDisplayMode == rhs.titleDisplayMode && lhs.backButtonHidden == rhs.backButtonHidden && lhs.navigationBar == rhs.navigationBar && lhs.bottomBar == rhs.bottomBar
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

struct ToolbarContentPreferenceKey: PreferenceKey {
    typealias Value = ToolbarContentPreferences

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<ToolbarContentPreferences>
    class Companion: PreferenceKeyCompanion {
        let defaultValue = ToolbarContentPreferences()
        func reduce(value: inout ToolbarContentPreferences, nextValue: () -> ToolbarContentPreferences) {
            value = value.reduce(nextValue())
        }
    }
}

struct ToolbarContentPreferences: Equatable {
    let content: [View]?
    let titleMenu: View?

    init(content: [View]? = nil, titleMenu: View? = nil) {
        self.content = content
        self.titleMenu = titleMenu
    }

    func reduce(_ next: ToolbarContentPreferences) -> ToolbarContentPreferences {
        let rcontent: [View]?
        if let ncontent = next.content, let content {
            rcontent = content + ncontent
        } else {
            rcontent = next.content ?? content
        }
        return ToolbarContentPreferences(content: rcontent, titleMenu: next.titleMenu ?? titleMenu)
    }

    public static func ==(lhs: ToolbarContentPreferences, rhs: ToolbarContentPreferences) -> Bool {
        // Views are not going to compare equal most of the time, even if they are logically the same.
        // That's why we isolate content from other preferences, so we can only access it in the bars themselves
        return lhs.content == rhs.content && lhs.titleMenu == rhs.titleMenu
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
