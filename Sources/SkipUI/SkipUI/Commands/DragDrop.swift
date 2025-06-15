// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public struct DragConfiguration {
    public struct OperationsWithinApp {
        public init(allowMove: Bool = false) {
        }
    }

    public struct OperationsOutsideApp {
        public init(allowCopy: Bool = true) {
        }
    }

    public var operationsWithinApp: DragConfiguration.OperationsWithinApp
    public var operationsOutsideApp: DragConfiguration.OperationsOutsideApp

    public init(operationsWithinApp: DragConfiguration.OperationsWithinApp = OperationsWithinApp(), operationsOutsideApp: DragConfiguration.OperationsOutsideApp = OperationsOutsideApp()) {
        self.operationsWithinApp = operationsWithinApp
        self.operationsOutsideApp = operationsOutsideApp
    }

    public init(allowMove: Bool) {
        self.operationsWithinApp = OperationsWithinApp(allowMove: allowMove)
        self.operationsOutsideApp = OperationsOutsideApp()
    }
}

public struct DragSession : Identifiable {
    public enum Phase : Hashable {
        case initial
        case active
        case ending(DropOperation)
        case ended(DropOperation)
        case dataTransferCompleted
    }

    public struct ID : Hashable {
        @available(*, unavailable)
        public func matches(_ dragSession: Any /* any UIDragSession */) -> Bool {
            fatalError()
        }
    }

    public let id: DragSession.ID
    public let phase: DragSession.Phase
    public let draggedItemIndex: Int

    @available(*, unavailable)
    public func draggedItemIDs(for type: Any.Type) -> [Any] {
        fatalError()
    }
}

public struct DropConfiguration {
    public let operation: DropOperation

    public init(operation: DropOperation) {
        self.operation = operation
    }
}

public protocol DropDelegate {
    func validateDrop(info: DropInfo) -> Bool
    func performDrop(info: DropInfo) -> Bool
    func dropEntered(info: DropInfo)
    func dropUpdated(info: DropInfo) -> DropProposal?
    func dropExited(info: DropInfo)
}

extension DropDelegate {
    public func validateDrop(info: DropInfo) -> Bool {
        return true
    }

    public func dropEntered(info: DropInfo) {
    }

    public func dropUpdated(info: DropInfo) -> DropProposal? {
        return nil
    }

    public func dropExited(info: DropInfo) {
    }
}

public struct DropInfo {
    public let location: CGPoint

    @available(*, unavailable)
    public func hasItemsConforming(to contentTypes: [Any /* UTType */]) -> Bool {
        fatalError()
    }

    @available(*, unavailable)
    public func itemProviders(for contentTypes: [Any /* UTType */]) -> [Any /* NSItemProvider */] {
        fatalError()
    }
}

//extension DropInfo {
//    @available(*, unavailable)
//    public func hasItemsConforming(to types: [String]) -> Bool {
//        fatalError()
//    }
//
//    @available(*, unavailable)
//    public func itemProviders(for types: [String]) -> [Any /* NSItemProvider */] {
//        fatalError()
//    }
//}

public enum DropOperation: Int, Hashable, Sendable {
    case cancel = 1
    case forbidden = 2
    case copy = 4
    case move = 8
    case delete = 16

    public struct Set : OptionSet, Hashable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let cancel = DropOperation.Set(rawValue: DropOperation.cancel.rawValue)
        public static let copy = DropOperation.Set(rawValue: DropOperation.copy.rawValue)
        public static let move = DropOperation.Set(rawValue: DropOperation.move.rawValue)
        public static let forbidden = DropOperation.Set(rawValue: DropOperation.forbidden.rawValue)
        public static let delete = DropOperation.Set(rawValue: DropOperation.delete.rawValue)
    }
}

public struct DropProposal {
    public let operation: DropOperation
    public let operationOutsideApplication: DropOperation?

    public init(operation: DropOperation) {
        self.operation = operation
        self.operationOutsideApplication = nil
    }

    public init(withinApplication: DropOperation, outsideApplication: DropOperation) {
        self.operation = withinApplication
        self.operationOutsideApplication = outsideApplication
    }
}

public struct DropSession : Identifiable {
    public struct LocalSession {
        @available(*, unavailable)
        public func draggedItemIDs(for type: Any.Type) -> [Any] {
            fatalError()
        }
    }

    public struct ID : Hashable {
        @available(*, unavailable)
        public func matches(_ dropSession: Any /* any UIDropSession */) -> Bool {
            fatalError()
        }
    }

    public enum Phase : Hashable {
        case entering
        case active
        case exiting
        case ended(DropOperation)
        case dataTransferCompleted
    }

    public let id: DropSession.ID
    public let phase: DropSession.Phase
    public let localSession: DropSession.LocalSession?

    public var itemsCount: Int
    public var suggestedOperations: DropOperation.Set
    public var size: CGSize
    public var location: CGPoint
}

extension View {
    @available(*, unavailable)
    public func dropDestination(for type: Any.Type? = nil, isEnabled: Bool = true, action: @escaping (_ items: [Any], _ session: DropSession) -> Void) -> some View /* where T : Transferable */ {
        return self
    }

    @available(*, unavailable)
    public func onDragSessionUpdated(_ onUpdate: @escaping (DragSession) -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dropConfiguration(_ configuration: @escaping (DropSession) -> DropConfiguration) -> some View {
        return self
    }

    @available(*, unavailable)
    public func onDropSessionUpdated(_ onUpdate: @escaping (DropSession) -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dragConfiguration(_ configuration: DragConfiguration) -> some View {
        return self
    }

    @available(*, unavailable)
    public func draggable(for type: Any.Type? = nil, id: AnyHashable, _ payload: @escaping (Any) -> Any?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dragContainer(for itemType: Any.Type? = nil, in namespace: Namespace.ID? = nil, selection: /* @autoclosure @escaping () -> */ [Any], _ payload: @escaping ([Any]) -> any Collection) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dragContainer(for itemType: Any.Type? = nil, id: @escaping (Any) -> Any, in namespace: Namespace.ID? = nil, selection: /* @autoclosure @escaping () -> */ [Any], _ payload: @escaping ([Any]) -> any Collection) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dragContainer(for itemType: Any.Type? = nil, in namespace: Namespace.ID? = nil, _ payload: @escaping (_ draggedItemID: Any) -> any Collection) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dragContainer(for itemType: Any.Type? = nil, id: @escaping (Any) -> Any, in namespace: Namespace.ID? = nil, _ payload: @escaping (_ draggedItemID: Any) -> any Collection) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dragContainer(for itemType: Any.Type? = nil, in namespace: Namespace.ID? = nil, selection: /* @autoclosure @escaping () -> */ Any?, _ payload: @escaping (_ draggedItemID: Any) -> Any?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dragContainer(for itemType: Any.Type? = nil, id: @escaping (Any) -> Any, in namespace: Namespace.ID? = nil, selection: /* @autoclosure @escaping () -> */ Any?, _ payload: @escaping (Any) -> Any?) -> some View {
        return self
    }
}
#endif
