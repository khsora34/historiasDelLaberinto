import Foundation

public class Localizer {
    public static var shared: Localizer = Localizer()
    private var localizedStringAccess: LocalizedValueFetcher?
    
    public func setup(localizedStringAccess: LocalizedValueFetcher) {
        self.localizedStringAccess = localizedStringAccess
    }
    
    func getString(_ key: String) -> String {
        guard let languageIdentifier: String = UserDefaults.standard.string(forKey: "loadedLanguageIdentifier") else {
            return key
        }
        return getString(key, forLanguage: Locale(identifier: languageIdentifier))
    }
    
    func getString(_ key: String, forLanguage language: Locale) -> String {
        guard let localizedStringAccess = localizedStringAccess else { return key }
        return localizedStringAccess.getString(key: key, forLocale: language)
    }
    
    public static func localizedString(key: String) -> String {
        return Localizer.shared.getString(key)
    }
}
