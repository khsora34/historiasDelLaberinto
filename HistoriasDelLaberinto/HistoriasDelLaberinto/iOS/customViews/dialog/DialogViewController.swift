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
    private let font = UIFont.systemFont(ofSize: 0.03 * UIScreen.main.bounds.height)
    
    private var configurator: DialogConfigurator?
    private var timer: Timer?
    private var alignment: DialogAlignment = .bottom {
        didSet {
            guard oldValue != alignment else { return }
            switch alignment {
            case .bottom:
                topConstraint.isActive = false
                dialogHeightConstraint.isActive = false
                let heightConstraint = NSLayoutConstraint(item: dialogView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.3, constant: 0)
                heightConstraint.isActive = true
                dialogHeightConstraint = heightConstraint
                dialogToScrollInequalityConstraint.isActive = true
                dialogBottomConstraint.isActive = true
            case .top:
                topConstraint.isActive = true
                dialogHeightConstraint.isActive = false
                let heightConstraint = NSLayoutConstraint(item: dialogView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.15, constant: 0)
                heightConstraint.isActive = true
                dialogHeightConstraint = heightConstraint
                dialogToScrollInequalityConstraint.isActive = false
                dialogBottomConstraint.isActive = false
            }
        }
    }
    
    private lazy var topConstraint: NSLayoutConstraint = {
        return dialogView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0)
    }()
    
    weak var delegate: NextDialogHandler?
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var tapWindowGesture: UITapGestureRecognizer!
    @IBOutlet weak var dialogHeightConstraint: NSLayoutConstraint!
    @IBOutlet var dialogToScrollInequalityConstraint: NSLayoutConstraint!
    @IBOutlet var dialogBottomConstraint: NSLayoutConstraint!
    
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
        dialogView.backgroundColor = UIColor.coolBlue.withAlphaComponent(0.95)
        dialogView.alpha = 0.95
        dialogView.layer.cornerRadius = 6.0
        dialogView.alpha = dialogViewDefaultAlpha
        stackView.isHidden = true
        messageLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
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
        characterLabel.font = font
        characterLabel.text = configurator?.name
        messageLabel.font = font
        messageLabel.text = ""
        if let dialogue = configurator as? DialogueConfigurator {
            setup(dialogue: dialogue)
        } else if let reward = configurator as? RewardConfigurator {
            setup(reward: reward)
        } else if let choice = configurator as? ChoiceConfigurator {
            setup(choice: choice)
        } else if let battle = configurator as? BattleConfigurator {
            setup(battle: battle)
        }
    }
    
    @IBAction func didTouchView(_ sender: Any) {
        guard !(configurator is ChoiceConfigurator) else { return }
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
            
        } else if let configurator = configurator, !newConfigurator.sharesStruct(with: configurator) {
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
        guard let key = configurator?.message else { return }
        let message = Localizer.localizedString(key: key)
        timer = messageLabel.setTypingText(message: message, timeInterval: typingTimeInterval)
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
        characterImageView.setImage(from: dialogue.imageSource) { [weak self] (isSuccess, imageSize) in
            guard isSuccess else {
                self?.characterImageView.image = nil
                self?.characterImageView.isHidden = true
                return
            }
            self?.characterImageView.isHidden = false
            if let viewSize = self?.characterImageView.bounds {
                let viewProportion: CGFloat = viewSize.width / viewSize.height
                let imageProportion: CGFloat = imageSize.width / imageSize.height
                self?.characterImageView.contentMode = imageProportion >= viewProportion ? .scaleAspectFill: .scaleAspectFit
            } else {
                self?.characterImageView.contentMode = .scaleAspectFit
            }
        }
        alignment = .bottom
    }
    
    private func setup(reward: RewardConfigurator) {
        stackView.isHidden = false
        stackView.spacing = 0
        
        for (item, quantity) in reward.items {
            let newView = RewardView(frame: CGRect(x: 0, y: 0, width: self.stackView.frame.width, height: 80.0))
            newView.item = Localizer.localizedString(key: item.name)
            newView.quantity = "\(quantity)"
            newView.imageView.setImage(from: item.imageSource) { (succesful, _) in
                newView.imageView.isHidden = !succesful
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
        stackView.createButtonsInColumns(names: actions.map({Localizer.localizedString(key: $0.name)}), usingFontSize: font.pointSize, action: #selector(buttonSelected(sender:)), for: self)
        alignment = .bottom
    }
    
    private func setup(battle: BattleConfigurator) {
        view.backgroundColor = .clear
        dialogView.backgroundColor = .coolBlue
        dialogView.alpha = 1.0
        characterImageView.isHidden = true
        stackView.isHidden = true
        alignment = battle.alignment
    }
    
    @objc func buttonSelected(sender: UIButton) {
        timer?.invalidate()
        timer = nil
        delegate?.elementSelected(id: sender.tag)
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
