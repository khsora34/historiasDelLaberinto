import UIKit
import Pastel

protocol PauseMenuSceneDisplayLogic: ViewControllerDisplay {
    func addCharactersStatus(_ models: [StatusViewModel])
    func createOptions(with optionsAvailable: [(String, Int)])
    func showMessage(_ message: String)
    func showExitMessage()
    func updateStatusView(_ model: StatusViewModel)
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
    
    @objc func buttonSelected(sender: UIButton) {
        let tag = sender.tag
        presenter?.performOption(tag: tag)
    }
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
        
        if #available(iOS 11, *) {
            let iphoneXView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: view.safeAreaInsets.bottom)))
            iphoneXView.backgroundColor = .clear
            statusStackView.addArrangedSubview(iphoneXView)
        }
    }
    
    func updateStatusView(_ model: StatusViewModel) {
        if let view = statusStackView.arrangedSubviews.filter({ ($0 as? StatusViewController)?.characterChosen == model.chosenCharacter }).first as? StatusViewController {
            model.configure(view: view)
        }
    }
    
    func createOptions(with optionsAvailable: [(String, Int)]) {
        for option in optionsAvailable {
            let button = ConfigurableButton(type: .custom)
            let style = ButtonStyle(backgroundColor: .orange, highlightedBackgroundColor: .red, font: .systemFont(ofSize: 18.0), titleColor: .white, cornerRadius: 4)
            button.setupStyle(style)
            button.setTitle(option.0, for: .normal)
            button.tag = option.1
            button.addTarget(self, action: #selector(buttonSelected(sender:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(button)
        }
    }
}
