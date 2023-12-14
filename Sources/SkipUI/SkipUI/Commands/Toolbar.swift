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

// Erase the generic ID to facilitate specialized constructor support.
public struct ToolbarItem</* ID, */ Content> : CustomizableToolbarContent, View where Content : View {
    let placement: ToolbarItemPlacement
    let content: Content

    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) {
        self.placement = placement
        self.content = content()
    }

    @available(*, unavailable)
    public init(id: String, placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) {
        self.placement = placement
        self.content = content()
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let _ = content.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct ToolbarItemGroup<Content> : CustomizableToolbarContent, View where Content : View  {
    let placement: ToolbarItemPlacement
    let content: Content

    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) {
        self.placement = placement
        self.content = content()
    }

    @available(*, unavailable)
    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> any View) {
        self.placement = placement
        self.content = content()
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let _ = content.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct ToolbarTitleMenu /* <Content> */ : CustomizableToolbarContent, View /* where Content : View */ {
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
        return preference(key: ToolbarContentPreferenceKey.self, value: [content()])
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
        return self
    }

    @available(*, unavailable)
    public func toolbarBackground(_ style: any ShapeStyle, for bars: ToolbarPlacement...) -> some View {
        return self
    }

    @available(*, unavailable)
    public func toolbarBackground(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        return self
    }

    @available(*, unavailable)
    public func toolbarColorScheme(_ colorScheme: ColorScheme?, for bars: ToolbarPlacement...) -> some View {
        return self
    }

    @available(*, unavailable)
    public func toolbarTitleDisplayMode(_ mode: ToolbarTitleDisplayMode) -> some View {
        return self
    }

    @available(*, unavailable)
    public func toolbarTitleMenu(@ViewBuilder content: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func toolbarRole(_ role: ToolbarRole) -> some View {
        return self
    }
}

#if SKIP
struct ToolbarContentPreferenceKey: PreferenceKey {
    typealias Value = [View]

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<Array<View>>
    class Companion: PreferenceKeyCompanion {
        let defaultValue: [View] = []
        func reduce(value: inout [View], nextValue: () -> [View]) {
            value.append(contentsOf: nextValue())
        }
    }
}

struct ToolbarItems {
    let content: androidx.compose.runtime.State<[View]>

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
        let context = ComposeContext(composer: ClosureComposer { view, context in
            if let itemGroup = view as? ToolbarItemGroup {
                if placement(itemGroup.placement) {
                    if expandGroups {
                        filtered.append(contentsOf: itemGroup.collectViews(context: context(false)).filter { !$0.isSwiftUIEmptyView })
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
        })
        content.value.forEach { $0.Compose(context: context) }
        return filtered
    }
}
#endif

#if !SKIP

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
