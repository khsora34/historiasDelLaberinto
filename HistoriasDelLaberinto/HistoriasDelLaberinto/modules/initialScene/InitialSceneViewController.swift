import UIKit

protocol InitialSceneDisplayLogic: ViewControllerDisplay {
    func showUnableToStartGame()
}

class InitialSceneViewController: BaseViewController {
    private var presenter: InitialScenePresentationLogic? {
        return _presenter as? InitialScenePresentationLogic
    }
    
    @IBOutlet weak var loadGameButton: UIButton!
    // MARK: Setup
    
    private func setup() {}
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction func didTapNewGame(_ sender: Any) {
        presenter?.startNewGame()
    }
}

extension InitialSceneViewController: InitialSceneDisplayLogic {
    func showUnableToStartGame() {
        let alert = UIAlertController(title: nil, message: "Ha habido un error intentando comenzar una nueva partida.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Qué bien", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
