// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import Foundation

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context.CLIPBOARD_SERVICE

public class UIPasteboard {
    public static let general = UIPasteboard()

    private init() {
        let context = ProcessInfo.processInfo.androidContext
        if let clipboardManager = context.getSystemService(CLIPBOARD_SERVICE) as? ClipboardManager {
            clipboardManager.addPrimaryClipChangedListener(Listener())
        }
    }

    @available(*, unavailable)
    public init?(name pasteboardName: UIPasteboard.Name, create: Bool) {
    }

    @available(*, unavailable)
    public static func withUniqueName() -> UIPasteboard {
        fatalError()
    }

    public var name: UIPasteboard.Name {
        return .general
    }

    @available(*, unavailable)
    public static func remove(withName pasteboardName: UIPasteboard.Name) {
    }

    @available(*, unavailable)
    public var isPersistent: Bool {
        fatalError()
    }

    @available(*, unavailable)
    public func setPersistent(_ persistent: Bool) {
    }

    @available(*, unavailable)
    public var changeCount: Int {
        fatalError()
    }

    @available(*, unavailable)
    public var itemProviders: [Any /* NSItemProvider */] {
        fatalError()
    }

    @available(*, unavailable)
    public func setItemProviders(_ itemProviders: [Any /* NSItemProvider */], localOnly: Bool, expirationDate: Date?) {
    }

    @available(*, unavailable)
    public func setObjects(_ objects: [Any /* NSItemProviderWriting */]) {
    }

    @available(*, unavailable)
    public func setObjects(_ objects: [Any /* NSItemProviderWriting */], localOnly: Bool, expirationDate: Date?) {
    }

    @available(*, unavailable)
    public var types: [String] {
        fatalError()
    }

    @available(*, unavailable)
    public func contains(pasteboardTypes: [String]) -> Bool {
        fatalError()
    }

    @available(*, unavailable)
    public func data(forPasteboardType pasteboardType: String) -> Data? {
        fatalError()
    }

    @available(*, unavailable)
    public func value(forPasteboardType pasteboardType: String) -> Any? {
        fatalError()
    }

    @available(*, unavailable)
    public func setValue(_ value: Any, forPasteboardType pasteboardType: String) {
    }

    @available(*, unavailable)
    public func setData(_ data: Data, forPasteboardType pasteboardType: String) {
    }

    public var numberOfItems: Int {
        return string != nil ? 1 : 0
    }

    @available(*, unavailable)
    public func types(forItemSet itemSet: IndexSet?) -> [[String]] {
        fatalError()
    }

    @available(*, unavailable)
    public func contains(pasteboardTypes: [String], inItemSet itemSet: IndexSet?) -> Bool {
        fatalError()
    }

    @available(*, unavailable)
    public func itemSet(withPasteboardTypes pasteboardTypes: [String]) -> IndexSet? {
        fatalError()
    }

    @available(*, unavailable)
    public func values(forPasteboardType pasteboardType: String, inItemSet itemSet: IndexSet?) -> [Any]? {
        fatalError()
    }

    @available(*, unavailable)
    public func data(forPasteboardType pasteboardType: String, inItemSet itemSet: IndexSet?) -> [Data]? {
        fatalError()
    }

    @available(*, unavailable)
    public var items: [[String : Any]] {
        fatalError()
    }

    @available(*, unavailable)
    public func addItems(_ items: [[String : Any]]) {
    }

    @available(*, unavailable)
    open func setItems(_ items: [[String : Any]], options: [UIPasteboard.OptionsKey : Any] = [:]) {
        fatalError()
    }

    public var string: String? {
        get {
            let context = ProcessInfo.processInfo.androidContext
            guard let clipboardManager = context.getSystemService(CLIPBOARD_SERVICE) as? ClipboardManager else {
                return nil
            }
            guard clipboardManager.hasPrimaryClip(), let clipData = clipboardManager.getPrimaryClip(), clipData.getItemCount() > 0 else {
                return nil
            }
            // SKIP NOWARN
            let string = String(clipData.getItemAt(0).coerceToText(context))
            return string.isEmpty ? nil : string
        }
        set {
            if let newValue {
                strings = [newValue]
            } else {
                strings = nil
            }
        }
    }

    public var strings: [String]? {
        get {
            let context = ProcessInfo.processInfo.androidContext
            guard let clipboardManager = context.getSystemService(CLIPBOARD_SERVICE) as? ClipboardManager else {
                return nil
            }
            guard clipboardManager.hasPrimaryClip(), let clipData = clipboardManager.getPrimaryClip() else {
                return nil
            }
            let count = clipData.getItemCount()
            var strings: [String] = []
            for i in 0..<count {
                // SKIP NOWARN
                let string = String(clipData.getItemAt(i).coerceToText(context))
                if !string.isEmpty {
                    strings.append(string)
                }
            }
            return strings.isEmpty ? nil : strings
        }
        set {
            let context = ProcessInfo.processInfo.androidContext
            guard let clipboardManager = context.getSystemService(CLIPBOARD_SERVICE) as? ClipboardManager else {
                return
            }
            guard let newValue, !newValue.isEmpty else {
                clipboardManager.clearPrimaryClip()
                return
            }
            let clipData = ClipData.newPlainText("", newValue[0])
            for i in 1..<newValue.count {
                clipData.addItem(ClipData.Item(newValue[i]))
            }
            clipboardManager.setPrimaryClip(clipData)
        }
    }

    public var url: URL? {
        get {
            let context = ProcessInfo.processInfo.androidContext
            guard let clipboardManager = context.getSystemService(CLIPBOARD_SERVICE) as? ClipboardManager else {
                return nil
            }
            guard clipboardManager.hasPrimaryClip(), let clipData = clipboardManager.getPrimaryClip(), clipData.getItemCount() > 0 else {
                return nil
            }
            // We attempt to get each item as a URI first to avoid coerceToText potentially resolving the URI
            // content into a string
            if let androidURI = clipData.getItemAt(0).getUri(), let url = URL(string: androidURI.toString()) {
                return url
            }
            // SKIP NOWARN
            let string = String(clipData.getItemAt(0).coerceToText(context))
            return URL(string: string)
        }
        set {
            if let newValue {
                urls = [newValue]
            } else {
                urls = nil
            }
        }
    }

    public var urls: [URL]? {
        get {
            let context = ProcessInfo.processInfo.androidContext
            guard let clipboardManager = context.getSystemService(CLIPBOARD_SERVICE) as? ClipboardManager else {
                return nil
            }
            guard clipboardManager.hasPrimaryClip(), let clipData = clipboardManager.getPrimaryClip() else {
                return nil
            }
            let count = clipData.getItemCount()
            var urls: [URL] = []
            for i in 0..<count {
                // We attempt to get each item as a URI first to avoid coerceToText potentially resolving the URI
                // content into a string
                if let androidURI = clipData.getItemAt(i).getUri(), let url = URL(string: androidURI.toString()) {
                    urls.append(url)
                } else {
                    // SKIP NOWARN
                    if let string = String(clipData.getItemAt(i).coerceToText(context)), let url = URL(string: string) {
                        urls.append(url)
                    }
                }
            }
            return urls.isEmpty ? nil : urls
        }
        set {
            let context = ProcessInfo.processInfo.androidContext
            guard let clipboardManager = context.getSystemService(CLIPBOARD_SERVICE) as? ClipboardManager else {
                return
            }
            guard let newValue, !newValue.isEmpty else {
                clipboardManager.clearPrimaryClip()
                return
            }
            let clipData = ClipData.newRawUri("", android.net.Uri.parse(newValue[0].absoluteString))
            for i in 1..<newValue.count {
                clipData.addItem(ClipData.Item(android.net.Uri.parse(newValue[i].absoluteString)))
            }
            clipboardManager.setPrimaryClip(clipData)
        }
    }

    @available(*, unavailable)
    public var image: Any? /* UIImage */ {
        get {
            fatalError()
        }
        set {
        }
    }

    @available(*, unavailable)
    public var images: [Any /* UIImage */]? {
        get {
            fatalError()
        }
        set {
        }
    }

    @available(*, unavailable)
    public var color: Any? /* UIColor? */ {
        get {
            fatalError()
        }
        set {
        }
    }

    @available(*, unavailable)
    public var colors: [Any /* UIColor */]? {
        get {
            fatalError()
        }
        set {
        }
    }

    public var hasStrings: Bool {
        return string != nil
    }

    public var hasURLs: Bool {
        return url != nil
    }

    @available(*, unavailable)
    open var hasImages: Bool {
        fatalError()
    }

    @available(*, unavailable)
    open var hasColors: Bool {
        fatalError()
    }

    public struct DetectedValues {
        @available(*, unavailable)
        public var patterns: Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */> {
            fatalError()
        }

        @available(*, unavailable)
        public var probableWebURL: String {
            fatalError()
        }

        @available(*, unavailable)
        public var probableWebSearch: String {
            fatalError()
        }

        @available(*, unavailable)
        public var number: Double? {
            fatalError()
        }

        @available(*, unavailable)
        public var links: [Any /* DDMatchLink */] {
            fatalError()
        }

        @available(*, unavailable)
        public var phoneNumbers: [Any /* DDMatchPhoneNumber */] {
            fatalError()
        }

        @available(*, unavailable)
        public var emailAddresses: [Any /* DDMatchEmailAddress */] {
            fatalError()
        }

        @available(*, unavailable)
        public var postalAddresses: [Any /* DDMatchPostalAddress */] {
            fatalError()
        }

        @available(*, unavailable)
        public var calendarEvents: [Any /* DDMatchCalendarEvent */] {
            fatalError()
        }

        @available(*, unavailable)
        public var shipmentTrackingNumbers: [Any /* DDMatchShipmentTrackingNumber */] {
            fatalError()
        }

        @available(*, unavailable)
        public var flightNumbers: [Any /* DDMatchFlightNumber */] {
            fatalError()
        }

        @available(*, unavailable)
        public var moneyAmounts: [Any /* DDMatchMoneyAmount */] {
            fatalError()
        }
    }

    @available(*, unavailable)
    public func detectPatterns(for keyPaths: Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */>, completionHandler: @escaping (Result<Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */>, Error>) -> ()) {
        fatalError()
    }

    @available(*, unavailable)
    public func detectedPatterns(for keyPaths: Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */>) async throws -> Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */> {
        fatalError()
    }

    @available(*, unavailable)
    public func detectPatterns(for keyPaths: Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */>, inItemSet itemSet: IndexSet?, completionHandler: @escaping (Result<[Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */>], Error>) -> ()) {
        fatalError()
    }

    @available(*, unavailable)
    public func detectedPatterns(for keyPaths: Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */>, inItemSet itemSet: IndexSet?) async throws -> [Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */>] {
        fatalError()
    }

    @available(*, unavailable)
    public func detectValues(for keyPaths: Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */>, completionHandler: @escaping (Result<UIPasteboard.DetectedValues, Error>) -> ()) {
        fatalError()
    }

    @available(*, unavailable)
    public func detectedValues(for keyPaths: Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */>) async throws -> UIPasteboard.DetectedValues {
        fatalError()
    }

    @available(*, unavailable)
    public func detectValues(for keyPaths: Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */>, inItemSet itemSet: IndexSet?, completionHandler: @escaping (Result<[UIPasteboard.DetectedValues], Error>) -> ()) {
        fatalError()
    }

    @available(*, unavailable)
    public func detectedValues(for keyPaths: Set<AnyHashable /* PartialKeyPath<UIPasteboard.DetectedValues> */>, inItemSet itemSet: IndexSet?) async throws -> [UIPasteboard.DetectedValues] {
        fatalError()
    }

    /*
    @available(*, unavailable)
    public func setObjects<T>(_ objects: [T]) where T : _ObjectiveCBridgeable, T._ObjectiveCType : NSItemProviderWriting {
        fatalError()
    }

    @available(*, unavailable)
    public func setObjects<T>(_ objects: [T], localOnly: Bool, expirationDate: Date?) where T : _ObjectiveCBridgeable, T._ObjectiveCType : NSItemProviderWriting {
        fatalError()
    }
    */

    public struct OptionsKey : Hashable, Equatable, RawRepresentable, Sendable {
        @available(*, unavailable)
        public static var expirationDate: UIPasteboard.OptionsKey {
            fatalError()
        }

        @available(*, unavailable)
        public static var localOnly: UIPasteboard.OptionsKey {
            fatalError()
        }

        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public static var changedNotification = Notification.Name(rawValue: "UIPasteboardChanged")

    private final class Listener: ClipboardManager.OnPrimaryClipChangedListener {
        override func onPrimaryClipChanged() {
            NotificationCenter.default.post(name: UIPasteboard.changedNotification, object: UIPasteboard.general)
        }
    }

    @available(*, unavailable)
    public static var changedTypesAddedUserInfoKey: String {
        fatalError()
    }

    @available(*, unavailable)
    public static var changedTypesRemovedUserInfoKey: String {
        fatalError()
    }

    @available(*, unavailable)
    public static var removedNotification: Notification.Name {
        fatalError()
    }

    @available(*, unavailable)
    public static var typeListString: [String] {
        fatalError()
    }

    @available(*, unavailable)
    public static var typeListURL: [String] {
        fatalError()
    }

    @available(*, unavailable)
    public static var typeListImage: [String] {
        fatalError()
    }

    @available(*, unavailable)
    public static var typeListColor: [String] {
        fatalError()
    }

    @available(*, unavailable)
    public static var typeAutomatic: String {
        fatalError()
    }

    public struct Name : Hashable, Equatable, RawRepresentable, @unchecked Sendable {
        public static let general = UIPasteboard.Name(rawValue: "general")

        public let rawValue: String

        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public struct DetectionPattern : Hashable, Equatable, RawRepresentable, @unchecked Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}
#endif
