import UIKit

protocol InitialSceneDisplayLogic: ViewControllerDisplay {
    func showUnableToStartGame()
    func setLoadButton(isHidden: Bool)
}

class InitialSceneViewController: BaseViewController {
    private var presenter: InitialScenePresentationLogic? {
        return _presenter as? InitialScenePresentationLogic
    }
    
    @IBOutlet weak var loadGameButton: UIButton!
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func didTapNewGame(_ sender: Any) {
        presenter?.startNewGame()
    }
    
    @IBAction func didTapLoadGame(_ sender: Any) {
        presenter?.loadGame()
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
