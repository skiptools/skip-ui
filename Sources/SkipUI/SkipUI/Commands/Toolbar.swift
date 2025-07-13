// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.gestures.ScrollableState
import androidx.compose.foundation.layout.width
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
#endif

// SKIP @bridge
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

    @available(*, unavailable)
    public func sharedBackgroundVisibility(_ visibility: Visibility) -> some CustomizableToolbarContent {
        return self
    }

    @available(*, unavailable)
    public func matchedTransitionSource(id: some Hashable, in namespace: Namespace.ID) -> some CustomizableToolbarContent {
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
        self.placement = ToolbarItemPlacement(rawValue: bridgedPlacement)
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
            return ComposeResult.ok
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

public struct DefaultToolbarItem : View, ToolbarContent {
    @available(*, unavailable)
    public init(kind: ToolbarDefaultItemKind, placement: ToolbarItemPlacement = .automatic) {
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
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
        self.placement = ToolbarItemPlacement(rawValue: bridgedPlacement)
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

// SKIP @bridge
public struct ToolbarSpacer : ToolbarContent, CustomizableToolbarContent, View {
    let sizing: SpacerSizing
    let placement: ToolbarItemPlacement

    public init(_ sizing: SpacerSizing = .flexible, placement: ToolbarItemPlacement = .automatic) {
        self.sizing = sizing
        self.placement = placement
    }

    // SKIP @bridge
    public init(bridgedSizing: Int, bridgedPlacement: Int) {
        self.sizing = SpacerSizing(rawValue: bridgedSizing) ?? .flexible
        self.placement = ToolbarItemPlacement(rawValue: bridgedPlacement)
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let modifier: Modifier
        if sizing == .fixed {
            modifier = Modifier.width(8.dp)
        } else {
            modifier = EnvironmentValues.shared._fillWidth?() ?? Modifier
        }
        androidx.compose.foundation.layout.Spacer(modifier: modifier)
    }
    #else
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

public struct ToolbarItemPlacement: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = ToolbarItemPlacement(rawValue: 0) // For bridging
    public static let principal = ToolbarItemPlacement(rawValue: 1) // For bridging
    public static let navigation = ToolbarItemPlacement(rawValue: 2) // For bridging
    public static let primaryAction = ToolbarItemPlacement(rawValue: 3) // For bridging
    public static let secondaryAction = ToolbarItemPlacement(rawValue: 4) // For bridging
    public static let status = ToolbarItemPlacement(rawValue: 5) // For bridging
    public static let confirmationAction = ToolbarItemPlacement(rawValue: 6) // For bridging
    public static let cancellationAction = ToolbarItemPlacement(rawValue: 7) // For bridging
    public static let destructiveAction = ToolbarItemPlacement(rawValue: 8) // For bridging
    public static let keyboard = ToolbarItemPlacement(rawValue: 9) // For bridging
    public static let topBarLeading = ToolbarItemPlacement(rawValue: 10) // For bridging
    public static let topBarTrailing = ToolbarItemPlacement(rawValue: 11) // For bridging
    public static let bottomBar = ToolbarItemPlacement(rawValue: 12) // For bridging
    public static let navigationBarLeading = ToolbarItemPlacement(rawValue: 13) // For bridging
    public static let navigationBarTrailing = ToolbarItemPlacement(rawValue: 14) // For bridging
    @available(*, unavailable)
    public static let title = ToolbarItemPlacement(rawValue: 15) // For bridging
    @available(*, unavailable)
    public static let largeTitle = ToolbarItemPlacement(rawValue: 16) // For bridging
    @available(*, unavailable)
    public static let subtitle = ToolbarItemPlacement(rawValue: 17) // For bridging
    @available(*, unavailable)
    public static let largeSubtitle = ToolbarItemPlacement(rawValue: 18) // For bridging
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

public struct ToolbarDefaultItemKind : RawRepresentable {
    public let rawValue: Int // For bridging

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let sidebarToggle = ToolbarDefaultItemKind(rawValue: 1) // For bridging
    public static let title = ToolbarDefaultItemKind(rawValue: 2) // For bridging
    public static let search = ToolbarDefaultItemKind(rawValue: 3) // For bridging
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

    public func toolbarTitleMenu(@ViewBuilder content: () -> any View) -> some View {
        #if SKIP
        return preference(key: ToolbarContentPreferenceKey.self, value: ToolbarContentPreferences(titleMenu: ComposeBuilder.from(content)))
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
    let titleMenu: ComposeBuilder?

    init(content: [View]? = nil, titleMenu: ComposeBuilder? = nil) {
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

    /// Proces our content items, dividing them into the locations at which they should render.
    @Composable func process(context: ComposeContext) -> (topLeading: [View], topTrailing: [View], bottom: [View]) {
        let items = gather(context: context)
        var leading: [View] = []
        var trailing: [View] = []
        var principal: View? = nil
        var bottom: [View] = []
        for (view, placement) in items {
            switch placement {
            case .principal:
                principal = view
            case .topBarLeading, .navigationBarLeading, .cancellationAction:
                leading.append(view)
            case .bottomBar:
                bottom.append(view)
            default:
                trailing.append(view)
            }
        }
        if let principal {
            leading.append(principal)
        }
        // SwiftUI inserts a spacer before the last bottom item
        if bottom.count > 1 && !bottom.contains(where: { $0.strippingModifiers { $0 is Spacer || $0 is ToolbarSpacer } }) {
            bottom.insert(Spacer(), at: bottom.count - 1)
        }
        return (leading, trailing, bottom)
    }

    @Composable private func gather(context: ComposeContext) -> [(View, ToolbarItemPlacement)] {
        let items = mutableListOf<(View, ToolbarItemPlacement)>()
        let context = context.content(composer: ToolbarContentGatheringComposer(items: items))
        content.forEach { $0.Compose(context: context) }
        return Array(items, nocopy: true)
    }
}

/// Helper to gather toolbar items and extract their palcements.
final class ToolbarContentGatheringComposer : SideEffectComposer {
    let items: MutableList<(View, ToolbarItemPlacement)>
    let defaultPlacement: ToolbarItemPlacement

    init(items: MutableList<(View, ToolbarItemPlacement)>, defaultPlacement: ToolbarItemPlacement = .automatic) {
        super.init()
        self.items = items
        self.defaultPlacement = defaultPlacement
    }

    @Composable override func Compose(view: View, context: (Bool) -> ComposeContext) -> ComposeResult {
        if let composeBuilder = view as? ComposeBuilder {
            composeBuilder.ComposeContent(context: context(true))
        } else if let itemGroup = view as? ToolbarItemGroup {
            // We have to recurse into groups on the bottom bar in order to properly insert spacers between items
            // to match iOS
            let placement = itemGroup.placement == .automatic ? defaultPlacement : itemGroup.placement
            if placement == .bottomBar {
                // Recurse with a composer that also defaults to this placement
                let filterComposer = ToolbarContentGatheringComposer(items: items, defaultPlacement: placement)
                let context = context(false).content(composer: filterComposer)
                itemGroup.ComposeContent(context: context)
            } else {
                items.add((itemGroup, placement))
            }
        } else if let item = view as? ToolbarItem {
            let placement = item.placement == .automatic ? defaultPlacement : item.placement
            items.add((item, placement))
        } else if let spacer = view as? ToolbarSpacer {
            let placement = spacer.placement == .automatic ? defaultPlacement : spacer.placement
            items.add((spacer, placement))
        } else if let toolbarContent = view as? ToolbarContent {
            // Gather the custom content items to check their placement. We have to then add the custom content as
            // a single item in a single place, because attempting to compose its individual items or compose it
            // multiple times breaks updates on recompose
            let content = mutableListOf<(View, ToolbarItemPlacement)>()
            let composer = ToolbarContentGatheringComposer(items: content, defaultPlacement: defaultPlacement)
            toolbarContent.ComposeContent(context: context(false).content(composer: composer))
            if let (_, placement) = content.firstOrNull() {
                items.add((toolbarContent, placement))
            }
        } else if !view.isSwiftUIEmptyView {
            items.add((view, defaultPlacement))
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
