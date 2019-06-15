import UIKit
import Pastel

protocol PauseMenuSceneDisplayLogic: ViewControllerDisplay {
    func addCharactersStatus(_ models: [StatusViewModel])
    func createOptions(with optionsAvailable: [(String, Int)])
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
        
        backgroundView.setColors([UIColor.blue, UIColor.cyan, UIColor.blue, UIColor.green])
        backgroundView.startAnimation()
        conditionView.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        
    }
    
    @objc func buttonSelected(sender: UIButton) {
        let tag = sender.tag
    }
}

extension PauseMenuSceneViewController {
    
}

extension PauseMenuSceneViewController: PauseMenuSceneDisplayLogic {
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
