import Foundation

protocol LanguageSelectionSceneBusinessLogic: BusinessLogic {
    func getAvailableLanguages() -> LanguageSelectionScene.AvailableLanguages.Response
    func setLanguage(request: LanguageSelectionScene.SetLanguage.Request)
}

class LanguageSelectionSceneInteractor: BaseInteractor, LanguageSelectionSceneBusinessLogic {
    private let localizedStringAccess: LocalizedValueFetcher
    
    init(databaseFetcher: DatabaseFetcherProvider) {
        self.localizedStringAccess = databaseFetcher.localizedValueFetcher
    }
    
    func getAvailableLanguages() -> LanguageSelectionScene.AvailableLanguages.Response {
        let languages = localizedStringAccess.getAvailableLanguages()
        let currentLanguageString = UserDefaults.standard.string(forKey: "loadedLanguageIdentifier")!
        return LanguageSelectionScene.AvailableLanguages.Response(languages: languages, currentLanguage: Locale(identifier: currentLanguageString))
    }
    
    func setLanguage(request: LanguageSelectionScene.SetLanguage.Request) {
        UserDefaults.standard.set(request.language.identifier, forKey: "loadedLanguageIdentifier")
    }
}
