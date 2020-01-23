import UIKit

protocol InitialSceneDisplayLogic: ViewControllerDisplay {
    func setLoadButton(isHidden: Bool)
}

class InitialSceneViewController: BaseViewController {
    private var presenter: InitialScenePresentationLogic? {
        return _presenter as? InitialScenePresentationLogic
    }
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var loadGameButton: UIButton!
    @IBOutlet weak var changeLanguageButton: UIButton!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTitleLabel.text = Localizer.localizedString(key: "gameTitle")
        newGameButton.setTitle(Localizer.localizedString(key: "newGameButton"), for: .normal)
        loadGameButton.setTitle(Localizer.localizedString(key: "loadGameButton"), for: .normal)
        changeLanguageButton.setTitle(Localizer.localizedString(key: "changeLanguageButtonText"), for: .normal)
    }
    
    @IBAction func didTapNewGame(_ sender: Any) {
        presenter?.startNewGame()
    }
    
    @IBAction func didTapLoadGame(_ sender: Any) {
        presenter?.loadGame()
    }
    
    @IBAction func didTapLanguagesButton(_ sender: Any) {
        presenter?.goToLanguagesSelection()
    }
}

extension InitialSceneViewController: InitialSceneDisplayLogic {
    func setLoadButton(isHidden: Bool) {
        loadGameButton.isHidden = isHidden
    }
}
