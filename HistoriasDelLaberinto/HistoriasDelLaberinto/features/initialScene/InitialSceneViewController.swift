import UIKit

protocol InitialSceneDisplayLogic: ViewControllerDisplay {
    func showUnableToStartGame()
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
        gameTitleLabel.text = presenter?.gameTitle
        newGameButton.setTitle(presenter?.newGameButtonText, for: .normal)
        loadGameButton.setTitle(presenter?.loadGameButtonText, for: .normal)
        changeLanguageButton.setTitle(presenter?.changeLanguageButtonText, for: .normal)
        let image = UIImage(named: "settingsIcon")
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        var other = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapSettingsButton))
        
        self.navigationItem.rightBarButtonItem = other
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
    
    @objc func didTapSettingsButton() {
        
    }
}

extension InitialSceneViewController: InitialSceneDisplayLogic {
    func showUnableToStartGame() {
        let alert = UIAlertController(title: nil, message: "Ha habido un error intentando comenzar una nueva partida. Vuelve a intentarlo en otro momento.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Qué bien", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func setLoadButton(isHidden: Bool) {
        loadGameButton.isHidden = isHidden
    }
}
