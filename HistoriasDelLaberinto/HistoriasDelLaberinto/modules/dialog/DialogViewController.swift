import UIKit
import Kingfisher

class Dialog {
    static func createDialog() -> BaseViewController {
        let dialog = DialogViewController()
        dialog.initView()
        return dialog
    }
}

protocol DialogDisplayLogic: ViewControllerDisplay {
    func setFirstConfigurator(configurator: DialogConfigurator)
}

class DialogViewController: BaseViewController {
    
    private var configurator: DialogConfigurator!
    
    var presenter: DialogPresentationLogic? {
        return _presenter as? DialogPresentationLogic
    }
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet var tapWindowGesture: UITapGestureRecognizer!
    
    fileprivate init() {
        super.init(nibName: "DialogView", bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
    }
    
    func initView() {
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
        dialogView.layer.cornerRadius = 6.0
    }
    
    private func setupConfiguration() {
        characterLabel.text = configurator.name
        textView.text = configurator.message
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
        guard let newConfigurator = presenter?.getNextStep().dialogConfigurator else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if newConfigurator.imageUrl != configurator.imageUrl {
            characterImageView.image = nil
        }
        
        configurator = newConfigurator
        setupConfiguration()
    }
}

extension DialogViewController: DialogDisplayLogic {
    func setFirstConfigurator(configurator: DialogConfigurator) {
        self.configurator = configurator
    }
}
