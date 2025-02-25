// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.runtime.Composable

/// Recognized modifier roles.
public enum ComposeModifierRole {
    case accessibility
    case id
    case spacing
    case tag
    case unspecified
}

/// Used internally by modifiers to apply changes to the context supplied to modified views.
public class ComposeModifierView: View {
    let view: View
    let role: ComposeModifierRole
    var action: (@Composable (inout ComposeContext) -> ComposeResult)?
    var composeContent: (@Composable (any View, ComposeContext) -> Void)?

    /// Constructor for subclasses.
    public init(view: any View, role: ComposeModifierRole = .unspecified) {
        // Don't copy view
        // SKIP REPLACE: this.view = view
        self.view = view
        self.role = role
    }

    /// A modfiier that performs an action, optionally modifying the `ComposeContext` passed to the modified view.
    public init(targetView: any View, role: ComposeModifierRole = .unspecified, action: @Composable (inout ComposeContext) -> ComposeResult) {
        self.init(view: targetView, role: role)
        self.action = action
    }

    /// A modifier that takes over the composition of the modified view.
    public init(contentView: any View, role: ComposeModifierRole = .unspecified, composeContent: @Composable (any View, ComposeContext) -> Void) {
        self.init(view: contentView, role: role)
        self.composeContent = composeContent
    }

    @Composable override func ComposeContent(context: ComposeContext) {
        if let composeContent {
            composeContent(view, context)
        } else if let action {
            var context = context
            let _ = action(&context)
            view.Compose(context: context)
        } else {
            view.Compose(context: context)
        }
    }

    func strippingModifiers<R>(until: (ComposeModifierView) -> Bool = { _ in false }, perform: (any View?) -> R) -> R {
        if until(self) {
            return perform(self)
        } else {
            return view.strippingModifiers(until: until, perform: perform)
        }
    }
}
#endif
