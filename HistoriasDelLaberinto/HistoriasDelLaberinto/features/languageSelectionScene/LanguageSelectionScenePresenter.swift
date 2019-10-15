import Foundation

protocol LanguageSelectionScenePresentationLogic: Presenter {}

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
    
    private var availableLanguages: [Locale]
    
    init(availableLanguages: [Locale]) {
        self.availableLanguages = availableLanguages
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension LanguageSelectionScenePresenter: LanguageSelectionScenePresentationLogic {
}
