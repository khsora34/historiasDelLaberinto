import UIKit

protocol LanguageSelectionSceneDisplayLogic: ViewControllerDisplay {
}

class LanguageSelectionSceneViewController: BaseViewController {
    
    private var presenter: LanguageSelectionScenePresentationLogic? {
        return _presenter as? LanguageSelectionScenePresentationLogic
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LanguageSelectionSceneViewController: LanguageSelectionSceneDisplayLogic {
}
