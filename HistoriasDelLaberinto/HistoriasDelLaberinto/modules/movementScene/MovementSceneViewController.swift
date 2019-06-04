import UIKit

protocol MovementSceneDisplayLogic: ViewControllerDisplay {
}

class MovementSceneViewController: BaseViewController {
    
    private var presenter: MovementScenePresentationLogic? {
        return _presenter as? MovementScenePresentationLogic
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTouchView(_ sender: Any) {
        presenter?.dismiss()
    }
}

extension MovementSceneViewController: MovementSceneDisplayLogic {
}
