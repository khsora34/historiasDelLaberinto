import UIKit
import Pastel

protocol PauseMenuSceneDisplayLogic: ViewControllerDisplay {
    func addCharactersStatus(_ models: [StatusViewModel])
    func createOptions(with optionsAvailable: [(String, Int)])
    func showMessage(_ message: String)
    func showExitMessage()
}

class PauseMenuSceneViewController: BaseViewController {
    
    private var presenter: PauseMenuScenePresentationLogic? {
        return _presenter as? PauseMenuScenePresentationLogic
    }
    
    @IBOutlet weak var backgroundView: PastelView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var conditionView: UIView!
    @IBOutlet weak var statusStackView: UIStackView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Menú"
        
        backgroundView.setColors([UIColor.blue, UIColor.cyan, UIColor.blue, UIColor.green])
        backgroundView.startAnimation()
        conditionView.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            presenter?.saveGame()
        }
    }
    
    @objc func buttonSelected(sender: UIButton) {
        let tag = sender.tag
        presenter?.performOption(tag: tag)
    }
}

extension PauseMenuSceneViewController {
    
}

extension PauseMenuSceneViewController: PauseMenuSceneDisplayLogic {
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showExitMessage() {
        let alert = UIAlertController(title: nil, message: "¿Estás seguro de que quieres salir? Se borrará tu progreso si sales sin guardar.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Me arriesgaré", style: .default, handler: { [weak self] _ in
            self?.presenter?.exitGame()
        }))
        alert.addAction(UIAlertAction(title: "Déjame pensarlo", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func addCharactersStatus(_ models: [StatusViewModel]) {
        for model in models {
            // Auto Layout will do the job.
            let statusView = StatusViewController(frame: CGRect.zero)
            model.configure(view: statusView)
            statusStackView.addArrangedSubview(statusView)
        }
    }
    
    func createOptions(with optionsAvailable: [(String, Int)]) {
        for option in optionsAvailable {
            let button = RoundedButton(color: UIColor.black.withAlphaComponent(0.3), frame: .zero)
            button.setTitle(option.0, for: .normal)
            button.tag = option.1
            button.addTarget(self, action: #selector(buttonSelected(sender:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(button)
        }
    }
}
