// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.ui.text.input.KeyboardType
#endif

public enum UIKeyboardType: Int {
    case `default` = 0 // For bridging
    case asciiCapable = 1 // For bridging
    case numbersAndPunctuation = 2 // For bridging
    case URL = 3 // For bridging
    case numberPad = 4 // For bridging
    case phonePad = 5 // For bridging
    case namePhonePad = 6 // For bridging
    case emailAddress = 7 // For bridging
    case decimalPad = 8 // For bridging
    case twitter = 9 // For bridging
    case webSearch = 10 // For bridging
    case asciiCapableNumberPad = 11 // For bridging
    case alphabet = 12 // For bridging

    #if SKIP
    func asComposeKeyboardType() -> KeyboardType {
        switch self {
        case .default:
            return KeyboardType.Text
        case .asciiCapable:
            return KeyboardType.Ascii
        case .numbersAndPunctuation:
            return KeyboardType.Text
        case .URL:
            return KeyboardType.Uri
        case .numberPad:
            return KeyboardType.NumberPassword
        case .phonePad:
            return KeyboardType.Phone
        case .namePhonePad:
            return KeyboardType.Text
        case .emailAddress:
            return KeyboardType.Email
        case .decimalPad:
            return KeyboardType.Decimal
        case .twitter:
            return KeyboardType.Text
        case .webSearch:
            return KeyboardType.Text
        case .asciiCapableNumberPad:
            return KeyboardType.Text
        case .alphabet:
            return KeyboardType.Text
        }
    }
    #endif
}

#endif
