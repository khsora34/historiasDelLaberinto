import UIKit
import Kingfisher

protocol RoomSceneDisplayLogic: ViewControllerDisplay {
    var dialog: DialogDisplayLogic? { get set }
    func set(title: String)
    func setImage(for source: ImageSource)
    func set(actions: [String])
    func update(withActions actions: [String])
}

class RoomSceneViewController: BaseViewController {
    private var presenter: RoomScenePresentationLogic? {
        return _presenter as? RoomScenePresentationLogic
    }
    
    var dialog: DialogDisplayLogic?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundButtonView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundButtonView.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.startWithStartEvent()
    }
    
    private func addNavigationBarButtons() {
        let image = UIImage(named: "menuIcon")
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.leftBarButtonItem = infoBarButtonItem
    }
}

extension RoomSceneViewController: RoomSceneDisplayLogic {
    func set(title: String) {
        self.title = Localizer.localizedString(key: title)
        let label = UILabel(frame: .zero)
        label.text = self.title
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.backgroundColor = UIColor.clear
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        self.navigationItem.titleView = label
    }
    
    func setImage(for source: ImageSource) {
        backgroundImageView.setImage(from: source)
    }
    
    func set(actions: [String]) {
        for stack in buttonStackView.arrangedSubviews {
            buttonStackView.removeArrangedSubview(stack)
            stack.removeFromSuperview()
        }
        buttonStackView.createButtonsInColumns(names: actions.map(Localizer.localizedString(key:)), action: #selector(didTapOption(sender:)), for: self, numberOfColumns: 2)
        
        if #available(iOS 11, *) {
            let iphoneXView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: view.safeAreaInsets.bottom)))
            iphoneXView.backgroundColor = .clear
            buttonStackView.addArrangedSubview(iphoneXView)
        }
    }
    
    func update(withActions actions: [String]) {
        guard !actions.isEmpty else { return }
        guard let iphoneXView = buttonStackView.arrangedSubviews.last else { return }
        buttonStackView.removeArrangedSubview(iphoneXView)
        iphoneXView.removeFromSuperview()
        guard let lastStackView = buttonStackView.arrangedSubviews.last as? UIStackView else { return }
        var actions = actions
        var tag = 0
        for button in lastStackView.arrangedSubviews.compactMap({$0 as? ConfigurableButton}) where button.text != nil {
            if button.text == Localizer.localizedString(key: "movementAction") {
                actions.append("movementAction")
                tag = button.tag
            } else {
                actions.insert(button.text!, at: 0)
            }
        }
        
        buttonStackView.removeArrangedSubview(lastStackView)
        lastStackView.removeFromSuperview()
        
        UIView.animate(withDuration: 0.3) {
            self.buttonStackView.createButtonsInColumns(names: actions.map(Localizer.localizedString(key:)), action: #selector(self.didTapOption(sender:)), fromTag: tag, for: self, numberOfColumns: 2)
            self.view.layoutIfNeeded()
        }
        
        if #available(iOS 11, *) {
            let iphoneXView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: view.safeAreaInsets.bottom)))
            iphoneXView.backgroundColor = .clear
            buttonStackView.addArrangedSubview(iphoneXView)
        }
    }
}

extension RoomSceneViewController {
    @objc func didTapOption(sender: UIControl) {
        presenter?.selectedAction(sender.tag)
    }
    
    @objc func didTapInfoButton() {
        presenter?.didTapInfoButton()
        
    }
    
    @objc func didTapMenuButton() {
        presenter?.showMenu()
    }
}
