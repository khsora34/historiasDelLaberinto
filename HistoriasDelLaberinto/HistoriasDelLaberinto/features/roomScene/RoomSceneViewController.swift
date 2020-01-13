import UIKit
import Kingfisher

protocol RoomSceneDisplayLogic: ViewControllerDisplay {
    var dialog: DialogDisplayLogic? { get set }
    func set(title: String)
    func setImage(for source: ImageSource)
    func set(actions: [String])
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
        self.title = title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
    }
    
    func setImage(for source: ImageSource) {
        backgroundImageView.setImage(from: source)
    }
    
    func set(actions: [String]) {
        for stack in buttonStackView.arrangedSubviews {
            buttonStackView.removeArrangedSubview(stack)
            stack.removeFromSuperview()
        }
        buttonStackView.createButtonsInColumns(names: actions, action: #selector(didTapOption(sender:)), for: self, numberOfColumns: 2)
        
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
