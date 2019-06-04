import UIKit

protocol RoomSceneDisplayLogic: ViewControllerDisplay {
    func set(title: String)
    func setImage(with literal: String)
}

class RoomSceneViewController: BaseViewController {
    private var presenter: RoomScenePresentationLogic? {
        return _presenter as? RoomScenePresentationLogic
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundButtonView: UIView!
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundButtonView.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarButtons()
    }
    
    private func addNavigationBarButtons() {
        let image = UIImage(named: "menuIcon")
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTappedMenuButton), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(didTappedInfoButton), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.leftBarButtonItem = infoBarButtonItem
    }
    
    @IBAction func action(_ sender: Any) {
        presenter?.start()
    }
}

extension RoomSceneViewController: RoomSceneDisplayLogic {
    func set(title: String) {
        self.title = title
        
    }
    
    func setImage(with literal: String) {
        let image = UIImage(named: "GenericRoom1")
        backgroundImageView.image = image
    }
}

extension RoomSceneViewController {
    @objc func didTappedInfoButton() {
        presenter?.showInfo()
    }
    
    @objc func didTappedMenuButton() {
        presenter?.showMenu()
    }
}
