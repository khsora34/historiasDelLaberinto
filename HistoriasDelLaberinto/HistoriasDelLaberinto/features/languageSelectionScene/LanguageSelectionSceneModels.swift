import Foundation

enum LanguageSelectionScene {
    enum AvailableLanguages {
        struct Response {
            let languages: [Locale]
            let currentLanguage: Locale
        }
    }
    enum SetLanguage {
        struct Request {
            let language: Locale
        }
    }
}
