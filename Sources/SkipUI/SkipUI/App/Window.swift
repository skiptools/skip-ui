// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE

public struct WindowGroup : Scene {
    @available(*, unavailable)
    public init(id: String, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ title: Text, id: String, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, id: String, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ title: String, id: String, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(@ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ title: Text, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ title: String, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init /* <D> */(id: String, for type: Any.Type /* D.Type */, @ViewBuilder content: @escaping (Binding<Any? /* D? */>) -> any View) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ title: Text, id: String, for type: Any.Type /* D.Type */, @ViewBuilder content: @escaping (Binding<Any? /* D? */>) -> any View) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ titleKey: LocalizedStringKey, id: String, for type: Any.Type /* D.Type */, @ViewBuilder content: @escaping (Binding<Any? /* D? */>) -> any View) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ title: String, id: String, for type: Any.Type /* D.Type */, @ViewBuilder content: @escaping (Binding<Any? /* D? */>) -> any View) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(for type: Any.Type /* D.Type */, @ViewBuilder content: @escaping (Binding<Any? /* D? */>) -> any View) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ title: Text, for type: Any.Type /* D.Type */, @ViewBuilder content: @escaping (Binding<Any? /* D? */>) -> any View) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ titleKey: LocalizedStringKey, for type: Any.Type /* D.Type */, @ViewBuilder content: @escaping (Binding<Any? /* D? */>) -> any View) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ title: String, for type: Any.Type /* D.Type */, unusedp: Any? = nil, @ViewBuilder content: @escaping (Binding<Any? /* D? */>) -> any View) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(id: String, for type: Any.Type /* D.Type */, @ViewBuilder content: @escaping (Binding<Any /* D */>) -> any View, defaultValue: @escaping () -> Any /* D */) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ title: Text, id: String, for type: Any.Type? = nil /* D.Type = D.self */, @ViewBuilder content: @escaping (Binding<Any /* D */>) -> any View, defaultValue: @escaping () -> Any /* D */) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ titleKey: LocalizedStringKey, id: String, for type: Any.Type? = nil /* D.Type = D.self */, @ViewBuilder content: @escaping (Binding<Any /* D */>) -> any View, defaultValue: @escaping () -> Any /* D */) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ title: String, id: String, for type: Any.Type? = nil /* D.Type = D.self */, @ViewBuilder content: @escaping (Binding<Any /* D */>) -> any View, defaultValue: @escaping () -> Any /* D */) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(for type: Any.Type? = nil /* D.Type = D.self */, @ViewBuilder content: @escaping (Binding<Any /* D */>) -> any View, defaultValue: @escaping () -> Any /* D */) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ title: Text, for type: Any.Type? = nil /* D.Type = D.self */, @ViewBuilder content: @escaping (Binding<Any /* D */>) -> any View, defaultValue: @escaping () -> Any /* D */) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ titleKey: LocalizedStringKey, for type: Any.Type? = nil /* D.Type = D.self */, @ViewBuilder content: @escaping (Binding<Any /* D */>) -> any View, defaultValue: @escaping () -> Any /* D */) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    @available(*, unavailable)
    public init /* <D> */(_ title: String, for type: Any.Type? = nil /* D.Type = D.self */, unusedp: Any? = nil, @ViewBuilder content: @escaping (Binding<Any /* D */>) -> any View, defaultValue: @escaping () -> Any /* D */) /* where D : Decodable, D : Encodable, D : Hashable */ {
    }

    //    /// The content and behavior of the scene.
    //    ///
    //    /// For any scene that you create, provide a computed `body` property that
    //    /// defines the scene as a composition of other scenes. You can assemble a
    //    /// scene from built-in scenes that SkipUI provides, as well as other
    //    /// scenes that you've defined.
    //    ///
    //    /// Swift infers the scene's ``SkipUI/Scene/Body-swift.associatedtype``
    //    /// associated type based on the contents of the `body` property.
    //    public func makeCache(subviews: Subviews) -> Never {
    //        fatalError()
    //    }
    //
    //    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
    //        fatalError()
    //    }
    //
    //    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
    //        fatalError()
    //    }
}

public enum WindowResizability : Sendable {
    case automatic
    case contentSize
    case contentMinSize
}

#endif
