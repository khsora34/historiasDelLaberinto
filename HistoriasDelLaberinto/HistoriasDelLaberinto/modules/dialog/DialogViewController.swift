import UIKit
import Kingfisher

class Dialog {
    static func createDialog(with configurator: DialogConfigurator, delegate: EventHandler) -> DialogDisplayLogic {
        let dialog = DialogViewController(configurator)
        dialog.delegate = delegate
        dialog.initView()
        return dialog
    }
}

protocol DialogDisplayLogic: UIViewController {
    func setNextConfigurator(newConfigurator: DialogConfigurator)
}

class DialogViewController: UIViewController {
    private let typingTimeInterval: TimeInterval = 0.02
    
    private var configurator: DialogConfigurator
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterImageView: UIImageView!
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConfiguration()
        textView.setTypingText(message: configurator.message, timeInterval: typingTimeInterval)
    }
    
    private func setupConfiguration() {
        characterLabel.text = configurator.name
        textView.text = ""
        let url = URL(string: configurator.imageUrl)
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
    
    @IBAction func didTouchView(_ sender: Any) {
        delegate?.continueFlow()
    }
}

extension DialogViewController: DialogDisplayLogic {
    func setNextConfigurator(newConfigurator: DialogConfigurator) {
        if newConfigurator.imageUrl != configurator.imageUrl {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                self.characterImageView.alpha = 0.3
                self.dialogView.alpha = 0.3
            }, completion: { _ in
                self.configurator = newConfigurator
                self.setupConfiguration()
                
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.characterImageView.alpha = 1.0
                    self.dialogView.alpha = 0.95
                }, completion: { _ in
                    self.textView.setTypingText(message: self.configurator.message, timeInterval: self.typingTimeInterval)
                })
            })
            
        } else {
            configurator = newConfigurator
            setupConfiguration()
            textView.setTypingText(message: configurator.message, timeInterval: typingTimeInterval)
        }
    }
}
