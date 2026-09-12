// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0

#if SKIP_WEB && !SKIP_BRIDGE && !SKIP

import Foundation

/// The platform-neutral representation produced by the Skip Web renderer.
///
/// `SkipUI` deliberately does not depend on JavaScriptKit. This keeps the view
/// model testable on the host and lets a browser adapter own DOM lifetime and
/// JavaScript interop.
public final class WebNode {
    public enum Kind: Equatable, Sendable {
        case fragment
        case text
        case container
        case button
        case input
    }

    public enum Attribute: Hashable, Sendable {
        case type
        case placeholder
        case ariaLabel
    }

    public enum Style: Hashable, Sendable {
        case display
        case flexDirection
        case gap
        case paddingTop
        case paddingLeading
        case paddingBottom
        case paddingTrailing
        case width
        case height
        case minWidth
        case maxWidth
        case minHeight
        case maxHeight
        case alignItems
        case justifyContent
    }

    public let kind: Kind
    public var value: String?
    public var attributes: [Attribute: String]
    public var styles: [Style: String]
    public var children: [WebNode]
    public var activate: (() -> Void)?
    public var input: ((String) -> Void)?

    public init(kind: Kind, value: String? = nil, children: [WebNode] = []) {
        self.kind = kind
        self.value = value
        self.attributes = [:]
        self.styles = [:]
        self.children = children
    }
}

/// A view that carries CSS information without changing the user's SwiftUI
/// source syntax. This is the web equivalent of a SwiftUI modifier wrapper.
public struct WebStyledView: View {
    let content: any View
    let styles: [WebNode.Style: String]

    init(content: any View, styles: [WebNode.Style: String]) {
        self.content = content
        self.styles = styles
    }

    public var body: Never {
        fatalError("WebStyledView is rendered by WebRenderer")
    }
}

/// Type-erased result-builder content used by the web implementation.
public struct WebTupleView: View {
    let views: [any View]

    init(views: [any View]) {
        self.views = views
    }

    public var body: Never {
        fatalError("WebTupleView is rendered by WebRenderer")
    }
}

/// A small, deterministic renderer for the SwiftUI-compatible core.
///
/// The renderer intentionally dispatches by framework-owned types and then
/// evaluates custom `View.body`. It never compares type names or HTML strings,
/// which keeps the dispatch safe when clients add their own views.
public enum WebRenderer {
    @MainActor
    public static func render(_ view: any View) -> WebNode {
        if let text = view as? Text {
            return WebNode(kind: .text, value: text.webString)
        }
        if let tuple = view as? WebTupleView {
            return WebNode(kind: .fragment, children: tuple.views.map(render))
        }
        if let styled = view as? WebStyledView {
            let node = render(styled.content)
            styled.styles.forEach { node.styles[$0.key] = $0.value }
            return node
        }
        if let stack = view as? VStack {
            let node = WebNode(kind: .container, children: children(of: render(stack.content.webView)))
            node.styles[.display] = "flex"
            node.styles[.flexDirection] = "column"
            node.styles[.gap] = cssPixels(stack.spacing ?? 8)
            return node
        }
        if let stack = view as? HStack {
            let node = WebNode(kind: .container, children: children(of: render(stack.content.webView)))
            node.styles[.display] = "flex"
            node.styles[.flexDirection] = "row"
            node.styles[.gap] = cssPixels(stack.spacing ?? 8)
            return node
        }
        if let button = view as? Button {
            let node = WebNode(kind: .button, children: [render(button.label.webView)])
            node.activate = button.action
            return node
        }
        if let field = view as? TextField {
            let node = WebNode(kind: .input)
            node.attributes[.type] = field.isSecure ? "password" : "text"
            node.value = field.text.wrappedValue
            node.attributes[.placeholder] = field.prompt?.webString
            node.input = field.text.set
            return node
        }
        if view is EmptyView {
            return WebNode(kind: .fragment)
        }
        return render(view.body)
    }

    private static func cssPixels(_ value: CGFloat) -> String {
        "\(value)px"
    }

    private static func children(of node: WebNode) -> [WebNode] {
        node.kind == .fragment ? node.children : [node]
    }
}

/// Coordinates invalidation with the browser adapter. State remains usable in
/// normal host tests; a mounted browser renderer simply installs this callback.
public enum WebRuntime {
    private static var invalidationHandler: (() -> Void)?

    public static func setInvalidationHandler(_ handler: (() -> Void)?) {
        invalidationHandler = handler
    }

    static func invalidate() {
        invalidationHandler?()
    }
}

#endif
