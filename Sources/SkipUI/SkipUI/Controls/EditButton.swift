// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation

/// A button that toggles the edit mode environment value.
///
/// Shows "Edit", then a bold "Done" while editing, as on iOS.
// SKIP @bridge
public struct EditButton : View {
    // SKIP @bridge
    public init() {
    }

    #if SKIP
    public var body: some View {
        let editMode = EnvironmentValues.shared.editMode
        let isEditing = editMode?.wrappedValue.isEditing == true
        return Button(action: {
            withAnimation {
                editMode?.wrappedValue = isEditing ? EditMode.inactive : EditMode.active
            }
        }) {
            Text(isEditing ? "Done" : "Edit")
                .fontWeight(isEditing ? Font.Weight.semibold : nil)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
