// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// The visual prominence of a badge.
///
/// Badges can be used for different kinds of information, from the
/// passive number of items in a container to the number of required
/// actions. The prominence of badges in Lists can be adjusted to reflect
/// this and be made to draw more or less attention to themselves.
///
/// Badges will default to `standard` prominence unless specified.
///
/// The following example shows a ``List`` displaying a list of folders
/// with an informational badge with lower prominence, showing the number
/// of items in the folder.
///
///     List(folders) { folder in
///         Text(folder.name)
///             .badge(folder.numberOfItems)
///     }
///     .badgeProminence(.decreased)
///
@available(iOS 17.0, macOS 14.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct BadgeProminence : Hashable, Sendable {

    /// The lowest level of prominence for a badge.
    ///
    /// This level or prominence should be used for badges that display a value
    /// of passive information that requires no user action, such as total
    /// number of messages or content.
    ///
    /// In lists on iOS and macOS, this results in badge labels being
    /// displayed without any extra decoration. On iOS, this looks the same as
    /// `.standard`.
    ///
    ///     List(folders) { folder in
    ///         Text(folder.name)
    ///             .badge(folder.numberOfItems)
    ///     }
    ///     .badgeProminence(.decreased)
    ///
    public static let decreased: BadgeProminence = { fatalError() }()

    /// The standard level of prominence for a badge.
    ///
    /// This level of prominence should be used for badges that display a value
    /// that suggests user action, such as a count of unread messages or new
    /// invitations.
    ///
    /// In lists on macOS, this results in a badge label on a grayscale platter;
    /// and in lists on iOS, this prominence of badge has no platter.
    ///
    ///     List(mailboxes) { mailbox in
    ///         Text(mailbox.name)
    ///             .badge(mailbox.numberOfUnreadMessages)
    ///     }
    ///     .badgeProminence(.standard)
    ///
    public static let standard: BadgeProminence = { fatalError() }()

    /// The highest level of prominence for a badge.
    ///
    /// This level of prominence should be used for badges that display a value
    /// that requires user action, such as number of updates or account errors.
    ///
    /// In lists on iOS and macOS, this results in badge labels being displayed
    /// on a red platter.
    ///
    ///     ForEach(accounts) { account in
    ///         Text(account.userName)
    ///             .badge(account.setupErrors)
    ///             .badgeProminence(.increased)
    ///     }
    ///
    public static let increased: BadgeProminence = { fatalError() }()

    


}


#endif
