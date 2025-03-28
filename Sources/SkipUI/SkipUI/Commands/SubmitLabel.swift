// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.ui.text.input.ImeAction
#endif

public enum SubmitLabel: Int {
    case done = 0 // For bridging
    case go = 1 // For bridging
    case send = 2 // For bridging
    case join = 3 // For bridging
    case route = 4 // For bridging
    case search = 5 // For bridging
    case `return` = 6 // For bridging
    case next = 7 // For bridging
    case `continue` = 8 // For bridging

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
