// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

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
