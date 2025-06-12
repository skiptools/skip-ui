// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

public struct Glass : Equatable, Sendable {
    public static var regular: Glass {
        return Glass()
    }

    public func tint(_ color: Color?) -> Glass {
        return self
    }

    public func interactive(_ isEnabled: Bool = true) -> Glass {
        return self
    }
}

public struct GlassEffectContainer<Content> : View, Sendable where Content : View {
    @available(*, unavailable)
    public init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
    }

    public var body: some View {
        EmptyView()
    }
}

public struct GlassEffectTransition : Sendable {
    @available(*, unavailable)
    public static var matchedGeometry: GlassEffectTransition {
        return GlassEffectTransition()
    }

    @available(*, unavailable)
    public static func matchedGeometry(properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center) -> GlassEffectTransition {
        return GlassEffectTransition()
    }

    public static var identity: GlassEffectTransition {
        return GlassEffectTransition()
    }
}

extension View {
    @available(*, unavailable)
    public func glassEffect(_ glass: Glass = .regular, in shape: some Shape = .capsule, isEnabled: Bool = true) -> some View {
        return self
    }

    public func glassEffectTransition(_ transition: GlassEffectTransition, isEnabled: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func glassEffectUnion(id: (any Hashable)?, namespace: Namespace.ID) -> some View {
        return self
    }

    @available(*, unavailable)
    public func glassEffectID(_ id: (any Hashable)?, in namespace: Namespace.ID) -> some View {
        return self
    }
}

#endif
