import UIKit

protocol MovementSceneDisplayLogic: ViewControllerDisplay {
    func set(roomName: String)
    func showConfirmationDialog()
    func showCantMoveDialog()
}

class MovementSceneViewController: BaseViewController {
    
    private var presenter: MovementScenePresentationLogic? {
        return _presenter as? MovementScenePresentationLogic
    }
    
    @IBOutlet weak var roomNameLabel: UILabel!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func showConfirmationDialog() {
        let alert = UIAlertController(title: nil, message: "¿Quieres moverte en esta dirección?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
            self.presenter?.continueToNewRoom()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func showCantMoveDialog() {
        let alert = UIAlertController(title: nil, message: "No te puedes mover en esa dirección", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
