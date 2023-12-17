// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable

/// Recognized modifier roles.
public enum ComposeModifierRole {
    case accessibility
    case editActions
    case gesture
    case spacing
    case unspecified
    case zIndex
}

/// Used internally by modifiers to apply changes to the context supplied to modified views.
class ComposeModifierView: View {
    let view: View
    let role: ComposeModifierRole
    var action: (@Composable (inout ComposeContext) -> Void)?
    var composeContent: (@Composable (any View, ComposeContext) -> Void)?

    /// Constructor for subclasses.
    init(view: any View, role: ComposeModifierRole = .unspecified) {
        // Don't copy view
        // SKIP REPLACE: this.view = view
        self.view = view
        self.role = role
    }

    /// A modfiier that performs an action, optionally modifying the `ComposeContext` passed to the modified view.
    init(targetView: any View, role: ComposeModifierRole = .unspecified, action: @Composable (inout ComposeContext) -> Void) {
        self.init(view: targetView, role: role)
        self.action = action
    }

    /// A modifier that takes over the composition of the modified view.
    init(contentView: any View, role: ComposeModifierRole = .unspecified, composeContent: @Composable (any View, ComposeContext) -> Void) {
        self.init(view: contentView, role: role)
        self.composeContent = composeContent
    }

    @Composable override func ComposeContent(context: ComposeContext) {
        if let composeContent {
            composeContent(view, context)
        } else if let action {
            var context = context
            action(&context)
            view.Compose(context: context)
        } else {
            view.Compose(context: context)
        }
    }

    func strippingModifiers<R>(until: (ComposeModifierRole) -> Bool = { _ in false }, perform: (any View?) -> R) -> R {
        if until(role) {
            return perform(self)
        } else {
            return view.strippingModifiers(until: until, perform: perform)
        }
    }
}
#endif
