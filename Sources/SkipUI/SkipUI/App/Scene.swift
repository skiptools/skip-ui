// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

public protocol Scene {
//    associatedtype Body : Scene
//    @SceneBuilder @MainActor var body: Self.Body { get }
}

extension Scene {
    @available(*, unavailable)
    public func backgroundTask<D, R>(_ task: BackgroundTask<D, R>, action: @escaping @Sendable (D) async -> R) -> some Scene /* where D : Sendable, R : Sendable */ {
        return self
    }

    @available(*, unavailable)
    public func commands/* <Content> */(/* @CommandsBuilder */ content: () -> Any /* Content */) -> some Scene /* where Content : Commands */ {
        return self
    }

    @available(*, unavailable)
    public func commandsRemoved() -> some Scene {
        return self
    }

    @available(*, unavailable)
    public func commandsReplaced/* <Content> */(/* @CommandsBuilder */ content: () -> Any /* Content */) -> some Scene /* where Content : Commands */ {
        return self
    }

    @available(*, unavailable)
    public func defaultAppStorage(_ store: UserDefaults) -> some Scene {
        return self
    }

    @available(*, unavailable)
    public func defaultSize(_ size: CGSize) -> some Scene {
        return self
    }

    @available(*, unavailable)
    public func defaultSize(width: CGFloat, height: CGFloat) -> some Scene {
        return self
    }

    @available(*, unavailable)
    public func handlesExternalEvents(matching conditions: Set<String>) -> some Scene {
        return self
    }

    @available(*, unavailable)
    public func onChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some Scene where V : Equatable {
        return self
    }

    @available(*, unavailable)
    public func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> some Scene where V : Equatable {
        return self
    }

    @available(*, unavailable)
    public func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping () -> Void) -> some Scene where V : Equatable {
        return self
    }

    @available(*, unavailable)
    public func windowResizability(_ resizability: WindowResizability) -> some Scene {
        return self
    }
}

public struct ScenePadding : Equatable, Sendable {
    public static let minimum = ScenePadding()
}

extension View {
    @available(*, unavailable)
    public func scenePadding(_ edges: Edge.Set = .all) -> some View {
        return self
    }

    @available(*, unavailable)
    public func scenePadding(_ padding: ScenePadding, edges: Edge.Set = .all) -> some View {
        return self
    }
}

public enum ScenePhase : Int, Comparable, Hashable, Sendable {
    case background
    case inactive
    case active

    public static func < (a: ScenePhase, b: ScenePhase) -> Bool {
        return a.rawValue < b.rawValue
    }
}
