import UIKit
import Pastel

protocol PauseMenuSceneDisplayLogic: ViewControllerDisplay {
    func addCharactersStatus(_ models: [StatusViewModel])
    func createOptions(with optionsAvailable: [(String, Int)])
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
    @IBOutlet weak var iPhoneXViewHeight: NSLayoutConstraint!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localizer.localizedString(key: "secondaryMenuTitle")
        
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
    func addCharactersStatus(_ models: [StatusViewModel]) {
        for model in models {
            // Auto Layout will do the job.
            let statusView = StatusView(frame: CGRect.zero)
            statusView.configure(withModel: model)
            statusStackView.addArrangedSubview(statusView)
        }
        
        if #available(iOS 11, *) {
            iPhoneXViewHeight.constant = view.safeAreaInsets.bottom
            view.layoutIfNeeded()
        }
    }
    
    func updateStatusView(_ model: StatusViewModel) {
        if let view = statusStackView.arrangedSubviews.filter({ ($0 as? StatusView)?.characterChosen == model.chosenCharacter }).first as? StatusView {
            view.configure(withModel: model)
        }
    }
    
    func createOptions(with optionsAvailable: [(String, Int)]) {
        for option in optionsAvailable {
            let button = ConfigurableButton(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
            let style = ButtonStyle(backgroundColor: .orange, highlightedBackgroundColor: .red, font: .systemFont(ofSize: 18.0), textColor: .white, cornerRadius: 4)
            button.setStyle(style)
            button.text = option.0
            button.tag = option.1
            button.addTarget(self, action: #selector(buttonSelected(sender:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(button)
        }
    }
}
