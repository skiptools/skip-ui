// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable

/// Recognized modifier roles.
public enum ComposeModifierRole {
    case accessibility
    case gesture
    case spacing
    case unspecified
}

/// Used internally by modifiers to apply changes to the context supplied to modified views.
class ComposeModifierView: View {
    let view: View
    let role: ComposeModifierRole
    var contextTransform: (@Composable (inout ComposeContext) -> Void)?
    var composeContent: (@Composable (any View, ComposeContext) -> Void)?

    /// A modfiier that transforms the `ComposeContext` passed to the modified view.
    init(contextView: any View, role: ComposeModifierRole = .unspecified, contextTransform: @Composable (inout ComposeContext) -> Void) {
        // Don't copy view
        // SKIP REPLACE: this.view = contextView
        self.view = contextView
        self.role = role
        self.contextTransform = contextTransform
        self.composeContent = nil
    }

    /// A modifier that takes over the composition of the modified view.
    init(contentView: any View, role: ComposeModifierRole = .unspecified, composeContent: @Composable (any View, ComposeContext) -> Void) {
        // Don't copy view
        // SKIP REPLACE: this.view = contentView
        self.view = contentView
        self.role = role
        self.contextTransform = nil
        self.composeContent = composeContent
    }

    @Composable override func ComposeContent(context: ComposeContext) {
        if let composeContent {
            composeContent(view, context)
        } else if let contextTransform {
            var context = context
            contextTransform(&context)
            view.ComposeContent(context)
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
