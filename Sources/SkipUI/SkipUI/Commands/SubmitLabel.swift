// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.ui.text.input.ImeAction
#endif

public enum SubmitLabel : Sendable {
    case done
    case go
    case send
    case join
    case route
    case search
    case `return`
    case next
    case `continue`

    #if SKIP
    func asImeAction() -> ImeAction {
        switch self {
        case .done:
            return ImeAction.Done
        case .go:
            return ImeAction.Go
        case .send:
            return ImeAction.Send
        case .join:
            return ImeAction.Go
        case .route:
            return ImeAction.Go
        case .search:
            return ImeAction.Search
        case .return:
            return ImeAction.Default
        case .next:
            return ImeAction.Next
        case .continue:
            return ImeAction.Next
        }
    }
    #endif
}

#endif
