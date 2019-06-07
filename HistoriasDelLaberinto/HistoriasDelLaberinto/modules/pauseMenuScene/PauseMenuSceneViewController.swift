import UIKit
import Pastel

protocol PauseMenuSceneDisplayLogic: ViewControllerDisplay {
}

class PauseMenuSceneViewController: BaseViewController {
    
    private var presenter: PauseMenuScenePresentationLogic? {
        return _presenter as? PauseMenuScenePresentationLogic
    }
    
    @IBOutlet weak var backgroundView: PastelView!
    @IBOutlet weak var conditionView: UIView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.setColors([UIColor.blue, UIColor.cyan, UIColor.blue, UIColor.green])
        backgroundView.startAnimation()
        conditionView.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        
    }
}

extension PauseMenuSceneViewController: PauseMenuSceneDisplayLogic {
}
