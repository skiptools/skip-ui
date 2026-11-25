// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation

/// TalkBack labels for navigation chrome that SwiftUI draws as system controls.
enum NavigationAccessibilityLabel {
    /// The system back button, in the locale TalkBack is speaking.
    static func backButton(locale: Locale) -> String {
        let identifier = locale.identifier.replacingOccurrences(of: "_", with: "-")
        let language = identifier.split(separator: "-").first.map { String($0).lowercased() } ?? ""
        return labels[language] ?? "Back"
    }

    private static let labels: [String: String] = [
        "en": "Back",
        "fr": "Retour",
        "de": "Zurück",
        "es": "Atrás",
        "it": "Indietro",
        "pt": "Voltar",
        "nl": "Terug",
        "pl": "Wstecz",
        "sv": "Tillbaka",
        "da": "Tilbage",
        "nb": "Tilbake",
        "nn": "Tilbake",
        "fi": "Takaisin",
        "cs": "Zpět",
        "hu": "Vissza",
        "ro": "Înapoi",
        "ru": "Назад",
        "uk": "Назад",
        "ja": "戻る",
        "ko": "뒤로",
        "ar": "رجوع",
        "he": "חזרה",
        "tr": "Geri",
        "el": "Πίσω",
        "th": "กลับ",
        "vi": "Quay lại",
        "id": "Kembali",
        "hi": "वापस",
        "ca": "Enrere",
        "zh": "返回",
    ]
}

#endif
