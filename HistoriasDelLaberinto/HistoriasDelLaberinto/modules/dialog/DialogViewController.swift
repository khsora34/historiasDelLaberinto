import UIKit
import Kingfisher

class Dialog {
    static func createDialogue(_ dialogue: DialogueConfigurator, delegate: EventHandler) -> DialogDisplayLogic {
        let dialog = DialogViewController(dialogue)
        dialog.delegate = delegate
        dialog.initView()
        return dialog
    }
    
    static func createReward(_ reward: RewardConfigurator, delegate: EventHandler) -> DialogDisplayLogic {
        let dialog = DialogViewController(reward)
        dialog.delegate = delegate
        dialog.initView()
        return dialog
    }
    
    static func createChoice(_ choice: ChoiceConfigurator, delegate: EventHandler) -> DialogDisplayLogic {
        let dialog = DialogViewController(choice)
        dialog.delegate = delegate
        dialog.initView()
        return dialog
    }
}

protocol DialogDisplayLogic: UIViewController {
    func setNextConfigurator(_ newConfigurator: DialogConfigurator)
}

class DialogViewController: UIViewController {
    private let typingTimeInterval: TimeInterval = 0.02
    private let dialogViewDefaultAlpha: CGFloat = 0.95
    private let transitionAlpha: CGFloat = 0.3
    
    private var configurator: DialogConfigurator
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var tapWindowGesture: UITapGestureRecognizer!
    
    weak var delegate: EventHandler?
    
    fileprivate init(_ configurator: DialogConfigurator) {
        self.configurator = configurator
        super.init(nibName: "DialogView", bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
        dialogView.layer.cornerRadius = 6.0
        dialogView.alpha = dialogViewDefaultAlpha
        stackView.isHidden = true
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
        }
        characterImageView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConfiguration()
        textView.setTypingText(message: configurator.message, timeInterval: typingTimeInterval)
    }
    
    private func setupConfiguration(newConfigurator: DialogConfigurator? = nil) {
        initView()
        characterLabel.text = configurator.name
        textView.text = ""
        if let dialogue = configurator as? DialogueConfigurator {
            setup(dialogue: dialogue)
        } else if let reward = configurator as? RewardConfigurator {
            setup(reward: reward)
        } else if let choice = configurator as? ChoiceConfigurator {
            setup(choice: choice)
        } else {
            setup(dialogue: DialogueConfigurator(name: "Cisco", message: "Error looking for configurator.", imageUrl: ""))
        }
    }
    
    @IBAction func didTouchView(_ sender: Any) {
        delegate?.continueFlow()
    }
}

extension DialogViewController: DialogDisplayLogic {
    func setNextConfigurator(_ newConfigurator: DialogConfigurator) {
        if !newConfigurator.sharesStruct(with: configurator) {
            changeForDifferent(configurator: newConfigurator)
            
        } else {
            configurator = newConfigurator
            setupConfiguration()
            textView.setTypingText(message: configurator.message, timeInterval: typingTimeInterval)
        }
    }
    
    private func changeForDifferent(configurator newConfigurator: DialogConfigurator) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.characterImageView.alpha = self.transitionAlpha
            self.stackView.isHidden = true
            self.dialogView.alpha = self.transitionAlpha
        }, completion: { _ in
            self.configurator = newConfigurator
            self.setupConfiguration()
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.characterImageView.alpha = 1.0
                self.dialogView.alpha = self.dialogViewDefaultAlpha
            }, completion: { _ in
                self.textView.setTypingText(message: self.configurator.message, timeInterval: self.typingTimeInterval)
            })
        })
    }
}

extension DialogViewController {
    private func setup(dialogue: DialogueConfigurator) {
        let url = URL(string: dialogue.imageUrl)
        characterImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.1))]) { [weak self] (result) in
            switch result {
            case .success:
                self?.characterImageView.isHidden = false
            case .failure:
                self?.characterImageView.image = nil
                self?.characterImageView.isHidden = true
            }
        }
    }
    
    private func setup(reward: RewardConfigurator) {
        stackView.isHidden = false
        stackView.spacing = 0
        
        for (item, quantity) in reward.items {
            let newView = RewardView(frame: CGRect(x: 0, y: 0, width: self.stackView.frame.width, height: 80.0))
            newView.item = item.name
            newView.quantity = "\(quantity)"
            let url = URL(string: item.imageUrl)
            newView.imageView.kf.setImage(with: url) { _ in
                newView.imageView.isHidden = false
            }
            self.stackView.addArrangedSubview(newView)
        }
        (stackView.arrangedSubviews.last as? RewardView)?.isLast = true
    }
    
    private func setup(choice: ChoiceConfigurator) {
        stackView.isHidden = false
        stackView.backgroundColor = UIColor.gray.withAlphaComponent(0.85)
        stackView.spacing = 10
        
        let actions = choice.actions
        
        stackView.setButtonsInColumns(names: actions.map({$0.name}), action: #selector(buttonSelected(sender:)), for: self, numberOfColumns: 2, fixedHeight: true)
    }
    
}

extension DialogViewController: ButtonSelectableView {
    @objc func buttonSelected(sender: UIButton) {
        delegate?.performChoice(tag: sender.tag)
    }
}
