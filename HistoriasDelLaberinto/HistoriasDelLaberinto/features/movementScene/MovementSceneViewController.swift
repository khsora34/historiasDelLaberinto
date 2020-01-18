import UIKit

protocol MovementSceneDisplayLogic: ViewControllerDisplay {
    func set(roomName: String)
    func updateDirectionHidden(_ direction: CompassDirection, isHidden: Bool)
    func showAllDirections()
}

class MovementSceneViewController: BaseViewController {
    
    private var presenter: MovementScenePresentationLogic? {
        return _presenter as? MovementScenePresentationLogic
    }
    
    @IBOutlet weak var locationSignalLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSignalLabel.text = Localizer.localizedString(key: "movementActualRoomStart")
    }
    
    @IBAction func didTouchView(_ sender: Any) {
        presenter?.dismiss()
    }
    
    @IBAction func didTouchDirection(_ sender: UIButton) {
        presenter?.calculateDirection(tag: sender.tag)
    }
}

extension MovementSceneViewController: MovementSceneDisplayLogic {
    func set(roomName: String) {
        roomNameLabel.text = roomName
        roomNameLabel.isHidden = false
    }
    
    func updateDirectionHidden(_ direction: CompassDirection, isHidden: Bool) {
        switch direction {
        case .north:
            upButton.isHidden = isHidden
        case .east:
            rightButton.isHidden = isHidden
        case .south:
            downButton.isHidden = isHidden
        case .west:
            leftButton.isHidden = isHidden
        }
    }
    
    func showAllDirections() {
        upButton.isHidden = false
        rightButton.isHidden = false
        downButton.isHidden = false
        leftButton.isHidden = false
    }
}
