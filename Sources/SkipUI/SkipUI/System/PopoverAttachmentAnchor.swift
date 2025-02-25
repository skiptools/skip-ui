// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if false
import struct CoreGraphics.CGRect

/// An attachment anchor for a popover.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum PopoverAttachmentAnchor {

    /// The anchor point for the popover relative to the source's frame.
    case rect(Anchor<CGRect>.Source)

    /// The anchor point for the popover expressed as a unit point  that
    /// describes possible alignments relative to a SkipUI view.
    case point(UnitPoint)
}
#endif
