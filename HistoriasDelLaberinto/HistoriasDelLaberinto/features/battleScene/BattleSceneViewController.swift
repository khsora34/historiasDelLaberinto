import UIKit

protocol BattleSceneDisplayLogic: ViewControllerDisplay {
    func addCharactersStatus(_ models: [StatusViewModel])
}

class BattleSceneViewController: BaseViewController {
    
    private var presenter: BattleScenePresentationLogic? {
        return _presenter as? BattleScenePresentationLogic
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var enemyImageView: UIImageView!
    @IBOutlet weak var charactersStackView: UIStackView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func didTapAttackButton(_ sender: Any) {
        
    }
    
    @IBAction func didTapItemsButton(_ sender: Any) {
        
    }
}

extension BattleSceneViewController: BattleSceneDisplayLogic {
    func addCharactersStatus(_ models: [StatusViewModel]) {
        for model in models {
            // Auto Layout will do the job.
            let view = StatusViewController(frame: CGRect.zero)
            model.configure(view: view)
            charactersStackView.addArrangedSubview(view)
        }
    }
}
