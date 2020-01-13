import Foundation

protocol LanguageSelectionScenePresentationLogic: Presenter {
    func didConfirmLanguage()
}

class LanguageSelectionScenePresenter: BasePresenter {
    var viewController: LanguageSelectionSceneDisplayLogic? {
        return _viewController as? LanguageSelectionSceneDisplayLogic
    }
    
    var interactor: LanguageSelectionSceneBusinessLogic? {
        return _interactor as? LanguageSelectionSceneBusinessLogic
    }
    
    var router: LanguageSelectionSceneRoutingLogic? {
        return _router as? LanguageSelectionSceneRoutingLogic
    }
    
    private var availableLanguages: [Locale] = []
    private var oldLanguage: Locale?
    private var selectedLanguage: Locale?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAvailableLanguages()
        createModels()
        viewController?.setSaveButtonText(localizedString(key: "genericButtonSave"))
    }
    
    private func getAvailableLanguages() {
        guard let response = interactor?.getAvailableLanguages() else { return }
        self.oldLanguage = response.currentLanguage
        self.selectedLanguage = response.currentLanguage
        self.availableLanguages = response.languages
    }
    
    private func createModels() {
        var languageModels: [LanguageButtonInfo] = []
        for language in availableLanguages {
            let localizedLanguageName: String? = language.localizedString(forIdentifier: language.identifier)?.capitalized
            let identifier: String = language.identifier
            let info = LanguageButtonInfo(text: localizedLanguageName, identifier: identifier, isHighlighted: identifier == selectedLanguage?.identifier)
            
            info.didTapAction = {
                self.setLanguage(for: language)
            }
            
            languageModels.append(info)
        }
        viewController?.showLanguages(models: languageModels)
    }
    
    private func setLanguage(for locale: Locale) {
        selectedLanguage = locale
        viewController?.didUpdateLanguages(newIdentifier: locale.identifier)
    }
}

extension LanguageSelectionScenePresenter: LanguageSelectionScenePresentationLogic {
    func didConfirmLanguage() {
        guard let selectedLanguage = selectedLanguage else { return }
        interactor?.setLanguage(request: LanguageSelectionScene.SetLanguage.Request(language: selectedLanguage))
        router?.goBackToMainMenu()
    }
}
