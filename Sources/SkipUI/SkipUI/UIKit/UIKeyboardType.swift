// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.ui.text.input.KeyboardType
#endif

public enum UIKeyboardType: Int {
    case `default`
    case asciiCapable
    case numbersAndPunctuation
    case URL
    case numberPad
    case phonePad
    case namePhonePad
    case emailAddress
    case decimalPad
    case twitter
    case webSearch
    case asciiCapableNumberPad
    case alphabet

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
            return KeyboardType.Number
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
