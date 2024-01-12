// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import android.content.Intent
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import androidx.core.content.ContextCompat.startActivity
#endif

// Use a class to be able to update our openURL action on compose by reference.
public class ShareLink : View {
    private static let defaultSystemImageName = "square.and.arrow.up"

    let text: Text
    let subject: Text?
    let message: Text?
    let content: Button
    var action: () -> Void

    init(text: Text, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> any View) {
        self.text = text
        self.subject = subject
        self.message = message
        self.action = { }
        #if SKIP
        self.content = Button(action: { self.action() }, label: label)
        #else
        self.content = Button("", action: {})
        #endif
    }

    public convenience init(item: URL, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> any View) {
        self.init(text: Text(item.absoluteString), subject: subject, message: message, label: label)
    }

    public convenience init(item: String, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> any View) {
        self.init(text: Text(item), subject: subject, message: message, label: label)
    }

    public convenience init(item: URL, subject: Text? = nil, message: Text? = nil) {
        self.init(text: Text(item.absoluteString), subject: subject, message: message) {
            Image(systemName: Self.defaultSystemImageName)
        }
    }

    public convenience init(item: String, subject: Text? = nil, message: Text? = nil) {
        self.init(text: Text(item), subject: subject, message: message) {
            Image(systemName: Self.defaultSystemImageName)
        }
    }

    public convenience init(_ titleKey: LocalizedStringKey, item: URL, subject: Text? = nil, message: Text? = nil) {
        self.init(text: Text(item.absoluteString), subject: subject, message: message) {
            Label(titleKey, systemImage: Self.defaultSystemImageName)
        }
    }

    public convenience init(_ titleKey: LocalizedStringKey, item: String, subject: Text? = nil, message: Text? = nil) {
        self.init(text: Text(item), subject: subject, message: message) {
            Label(titleKey, systemImage: Self.defaultSystemImageName)
        }
    }

    public convenience init(_ title: String, item: URL, subject: Text? = nil, message: Text? = nil) {
        self.init(text: Text(item.absoluteString), subject: subject, message: message) {
            Label(title, systemImage: Self.defaultSystemImageName)
        }
    }

    public convenience init(_ title: String, item: String, subject: Text? = nil, message: Text? = nil) {
        self.init(text: Text(item), subject: subject, message: message) {
            Label(title, systemImage: Self.defaultSystemImageName)
        }
    }

    public convenience init(_ title: Text, item: URL, subject: Text? = nil, message: Text? = nil) {
        self.init(text: Text(item.absoluteString), subject: subject, message: message) {
            Label(title: { title }, icon: { Image(systemName: Self.defaultSystemImageName) })
        }
    }

    public convenience init(_ title: Text, item: String, subject: Text? = nil, message: Text? = nil) {
        self.init(text: Text(item), subject: subject, message: message) {
            Label(title: { title }, icon: { Image(systemName: Self.defaultSystemImageName) })
        }
    }

    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
        let localContext = LocalContext.current

        let intent = Intent().apply {
            action = Intent.ACTION_SEND
            putExtra(Intent.EXTRA_TEXT, text.localizedTextString())
            if let subject {
                putExtra(Intent.EXTRA_SUBJECT, subject.localizedTextString())
            }
            type = "text/plain"
        }

        action = {
            let shareIntent = Intent.createChooser(intent, nil)
            localContext.startActivity(shareIntent)
        }
        content.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if !SKIP

// TODO: Process for use in SkipUI

//import protocol CoreTransferable.Transferable
//import struct UniformTypeIdentifiers.UTType
//
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//extension ShareLink {
//
//    /// Creates an instance that presents the share interface.
//    ///
//    /// - Parameters:
//    ///     - item: The item to share.
//    ///     - subject: A title for the item to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the item to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    ///     - preview: A representation of the item to render in a preview.
//    ///     - label: A view builder that produces a label that describes the
//    ///     share action.
//    public init<I>(item: I, subject: Text? = nil, message: Text? = nil, preview: SharePreview<PreviewImage, PreviewIcon>, @ViewBuilder label: () -> Label) where Data == CollectionOfOne<I>, I : Transferable { fatalError() }
//}
//
//
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Data.Element == URL {
//
//    /// Creates an instance that presents the share interface.
//    ///
//    /// - Parameters:
//    ///     - items: The items to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    ///     - label: A view builder that produces a label that describes the
//    ///     share action.
//    public init(items: Data, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) { fatalError() }
//}
//
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Data.Element == String {
//
//    /// Creates an instance that presents the share interface.
//    ///
//    /// - Parameters:
//    ///     - items: The items to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    ///     - label: A view builder that produces a label that describes the
//    ///     share action.
//    public init(items: Data, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) { fatalError() }
//}
//
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//extension ShareLink where Label == DefaultShareLinkLabel {
//
//    /// Creates an instance that presents the share interface.
//    ///
//    /// Use this initializer when you want the system-standard appearance for
//    /// `ShareLink`.
//    ///
//    /// - Parameters:
//    ///     - items: The items to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    ///     - preview: A closure that returns a representation of each item to
//    ///     render in a preview.
//    public init(items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>) { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - titleKey: A key identifying the title of the share action.
//    ///     - items: The items to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    ///     - preview: A closure that returns a representation of each item to
//    ///     render in a preview.
//    public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>) { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - title: The title of the share action.
//    ///     - items: The item to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    ///     - preview: A closure that returns a representation of each item to
//    ///     render in a preview.
//    public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>) where S : StringProtocol { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - title: The title of the share action.
//    ///     - items: The items to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    ///     - preview: A closure that returns a representation of each item to
//    ///     render in a preview.
//    public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>) { fatalError() }
//}
//
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//extension ShareLink where Label == DefaultShareLinkLabel {
//
//    /// Creates an instance that presents the share interface.
//    ///
//    /// Use this initializer when you want the system-standard appearance for
//    /// `ShareLink`.
//    ///
//    /// - Parameters:
//    ///     - item: The item to share.
//    ///     - subject: A title for the item to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the item to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    ///     - preview: A representation of the item to render in a preview.
//    public init<I>(item: I, subject: Text? = nil, message: Text? = nil, preview: SharePreview<PreviewImage, PreviewIcon>) where Data == CollectionOfOne<I>, I : Transferable { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - titleKey: A key identifying the title of the share action.
//    ///     - item: The item to share.
//    ///     - subject: A title for the item to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the item to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    ///     - preview: A representation of the item to render in a preview.
//    public init<I>(_ titleKey: LocalizedStringKey, item: I, subject: Text? = nil, message: Text? = nil, preview: SharePreview<PreviewImage, PreviewIcon>) where Data == CollectionOfOne<I>, I : Transferable { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - title: The title of the share action.
//    ///     - item: The item to share.
//    ///     - subject: A title for the item to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the item to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    ///     - preview: A representation of the item to render in a preview.
//    public init<S, I>(_ title: S, item: I, subject: Text? = nil, message: Text? = nil, preview: SharePreview<PreviewImage, PreviewIcon>) where Data == CollectionOfOne<I>, S : StringProtocol, I : Transferable { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - title: The title of the share action.
//    ///     - item: The item to share.
//    ///     - subject: A title for the item to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the item to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    ///     - preview: A representation of the item to render in a preview.
//    public init<I>(_ title: Text, item: I, subject: Text? = nil, message: Text? = nil, preview: SharePreview<PreviewImage, PreviewIcon>) where Data == CollectionOfOne<I>, I : Transferable { fatalError() }
//}
//
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Label == DefaultShareLinkLabel, Data.Element == URL {
//
//    /// Creates an instance that presents the share interface.
//    ///
//    /// Use this initializer when you want the system-standard appearance for
//    /// `ShareLink`.
//    ///
//    /// - Parameters:
//    ///     - items: The items to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    public init(items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - titleKey: A key identifying the title of the share action.
//    ///     - items: The items to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - title: The title of the share action.
//    ///     - items: The item to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil) where S : StringProtocol { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - title: The title of the share action.
//    ///     - items: The items to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }
//}
//
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Label == DefaultShareLinkLabel, Data.Element == String {
//
//    /// Creates an instance that presents the share interface.
//    ///
//    /// Use this initializer when you want the system-standard appearance for
//    /// `ShareLink`.
//    ///
//    /// - Parameters:
//    ///     - items: The items to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    public init(items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - titleKey: A key identifying the title of the share action.
//    ///     - items: The items to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - title: The title of the share action.
//    ///     - items: The item to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil) where S : StringProtocol { fatalError() }
//
//    /// Creates an instance, with a custom label, that presents the share
//    /// interface.
//    ///
//    /// - Parameters:
//    ///     - title: The title of the share action.
//    ///     - items: The items to share.
//    ///     - subject: A title for the items to show when sharing to activities
//    ///     that support a subject field.
//    ///     - message: A description of the items to show when sharing to
//    ///     activities that support a message field. Activities may
//    ///     support attributed text or HTML strings.
//    public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil) { fatalError() }
//}
//
//
///// The default label used for a share link.
/////
///// You don't use this type directly. Instead, ``ShareLink`` uses it
///// automatically depending on how you create a share link.
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//public struct DefaultShareLinkLabel : View {
//
//    @MainActor public var body: some View { get { return stubView() } }
//
////    public typealias Body = some View
//}

#endif
