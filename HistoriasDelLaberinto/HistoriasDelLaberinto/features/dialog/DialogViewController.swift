import UIKit
import Kingfisher

class Dialog {
    static func createDialog(_ dialog: DialogConfigurator, delegate: NextDialogHandler) -> DialogDisplayLogic {
        let dialog = DialogViewController(dialog)
        dialog.delegate = delegate
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
    
    lazy var topConstraint: NSLayoutConstraint = {
        return dialogView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0)
    }()
    private var configurator: DialogConfigurator
    private var timer: Timer?
    private var alignment: DialogAlignment = .bottom {
        didSet {
            guard oldValue != alignment else { return }
            switch alignment {
            case .bottom:
                topConstraint.isActive = false
                dialogHeightConstraint.isActive = false
                let heightConstraint = NSLayoutConstraint(item: dialogView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.25, constant: 0)
                heightConstraint.isActive = true
                dialogHeightConstraint = heightConstraint
                dialogTopConstraint.isActive = true
                dialogToScrollInequalityConstraint.isActive = true
                dialogBottomConstraint.isActive = true
            case .top:
                topConstraint.isActive = true
                dialogHeightConstraint.isActive = false
                let heightConstraint = NSLayoutConstraint(item: dialogView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.15, constant: 0)
                heightConstraint.isActive = true
                dialogHeightConstraint = heightConstraint
                dialogTopConstraint.isActive = false
                dialogToScrollInequalityConstraint.isActive = false
                dialogBottomConstraint.isActive = false
            }
        }
    }
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var tapWindowGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var dialogHeightConstraint: NSLayoutConstraint!
    @IBOutlet var dialogTopConstraint: NSLayoutConstraint!
    @IBOutlet var dialogToScrollInequalityConstraint: NSLayoutConstraint!
    @IBOutlet var dialogBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: NextDialogHandler?
    
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
        textView.backgroundColor = UIColor.coolBlue.withAlphaComponent(0.95)
        textView.alpha = 0.95
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
        showDialogInfo()
    }
    
    private func setupConfiguration() {
        initView()
        characterLabel.text = configurator.name
        textView.text = ""
        if let dialogue = configurator as? DialogueConfigurator {
            setup(dialogue: dialogue)
        } else if let reward = configurator as? RewardConfigurator {
            setup(reward: reward)
        } else if let choice = configurator as? ChoiceConfigurator {
            setup(choice: choice)
        } else if let battle = configurator as? BattleConfigurator {
            setup(battle: battle)
        } else {
            setup(dialogue: DialogueConfigurator(name: "Cisco", message: "Error looking for configurator.", imageUrl: ""))
        }
    }
    
    @IBAction func didTouchView(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        delegate?.continueFlow()
    }
}

extension DialogViewController: DialogDisplayLogic {
    func setNextConfigurator(_ newConfigurator: DialogConfigurator) {
        if newConfigurator is ChoiceConfigurator && configurator is DialogueConfigurator {
            configurator = newConfigurator
            showDialogInfo()
            
        } else if !newConfigurator.sharesStruct(with: configurator) {
            changeForDifferent(configurator: newConfigurator)
            
        } else {
            configurator = newConfigurator
            showDialogInfo()
        }
    }
    
    private func showDialogInfo() {
        setupConfiguration()
        internalSetTypingText()
    }
    
    private func internalSetTypingText() {
        if self.presentingViewController != nil {
            timer = textView.setTypingText(message: configurator.message, timeInterval: typingTimeInterval)
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
                self.internalSetTypingText()
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
        alignment = .bottom
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
        alignment = .bottom
    }
    
    private func setup(choice: ChoiceConfigurator) {
        characterImageView.isHidden = false
        stackView.isHidden = false
        stackView.backgroundColor = UIColor.gray.withAlphaComponent(0.85)
        stackView.spacing = 10
        
        let actions = choice.actions
        
        stackView.setButtonsInColumns(names: actions.map({$0.name}), action: #selector(buttonSelected(sender:)), for: self, numberOfColumns: 2, fixedHeight: true)
        alignment = .bottom
    }
    
    private func setup(battle: BattleConfigurator) {
        view.backgroundColor = .clear
        textView.backgroundColor = .coolBlue
        textView.alpha = 1.0
        characterImageView.isHidden = true
        stackView.isHidden = true
        alignment = battle.alignment
    }
    
    @objc func buttonSelected(sender: UIButton) {
        delegate?.elementSelected(id: sender.tag)
    }
}
