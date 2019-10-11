import Foundation

protocol LocalizedStringBussinesLogic {
    var localizedStringAccess: LocalizedValueFetcher { get }
    func getString(key: String) -> String
    func getString(key: String, forLanguage language: Locale) -> String
}

extension LocalizedStringBussinesLogic {
    func getString(key: String) -> String {
        guard let languageIdentifier: String = UserDefaults.standard.string(forKey: "loadedLanguageIdentifier") else {
            return key
        }
        return getString(key: key, forLanguage: Locale(identifier: languageIdentifier))
    }
    
    func getString(key: String, forLanguage language: Locale) -> String {
        return localizedStringAccess.getString(key: key, forLocale: language)
    }
}

protocol LocalizableStringPresenterProtocol: class {
    func localizedString(key: String) -> String
}
