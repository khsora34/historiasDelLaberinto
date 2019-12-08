import UIKit

protocol LanguageSelectionSceneDisplayLogic: ViewControllerDisplay {
    func showLanguages(models: [LanguageButtonInfo])
    func didUpdateLanguages(newIdentifier: String)
}

class LanguageSelectionSceneViewController: BaseViewController {
    private var presenter: LanguageSelectionScenePresentationLogic? {
        return _presenter as? LanguageSelectionScenePresentationLogic
    }
    
    private var models: [LanguageButtonInfo] = []
    
    @IBOutlet weak var saveButton: ConfigurableButton!
    @IBOutlet weak var languagesStackView: UIStackView!
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        presenter?.didConfirmLanguage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.setStyle(ButtonStyle.defaultButtonStyle)
    }
}

extension LanguageSelectionSceneViewController: LanguageSelectionSceneDisplayLogic {
    func showLanguages(models: [LanguageButtonInfo]) {
        self.models = models
        for model in models {
            let button = LanguageButton()
            button.info = model
            model.highlightAction?(model.isHighlighted)
            button.setTitle(model.text ?? model.identifier, for: .normal)
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            languagesStackView.addArrangedSubview(button)
        }
    }
    
    @objc func didTapButton(_ button: LanguageButton) {
        let model = button.info
        model?.didTapAction?()
    }
    
    func didUpdateLanguages(newIdentifier: String) {
        for model in models {
            model.highlightAction?(model.identifier == newIdentifier)
        }
    }
}
