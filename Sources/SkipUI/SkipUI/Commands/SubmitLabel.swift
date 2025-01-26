// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
