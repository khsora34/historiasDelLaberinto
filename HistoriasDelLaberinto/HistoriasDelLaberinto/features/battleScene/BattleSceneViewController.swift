import UIKit
import Kingfisher

protocol BattleSceneDisplayLogic: ViewControllerDisplay {
    func addCharactersStatus(_ models: [StatusViewModel])
    func setBackground(with imageUrl: String?)
    func setEnemyInfo(imageUrl: String, model: StatusViewModel)
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
            let statusView = StatusViewController(frame: CGRect.zero)
            model.configure(view: statusView)
            charactersStackView.addArrangedSubview(statusView)
        }
    }
    
    func setBackground(with imageUrl: String?) {
        guard let imageUrl = imageUrl else { return }
        backgroundImageView.kf.setImage(with: URL(string: imageUrl))
    }
    
    func setEnemyInfo(imageUrl: String, model: StatusViewModel) {
        enemyImageView.kf.setImage(with: URL(string: imageUrl))
        let statusView = StatusViewController(frame: CGRect(x: 0, y: 0, width: 394, height: 100))
        model.configure(view: statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusView)
        setEnemyViewConstraints(to: statusView)
    }
    
    private func setEnemyViewConstraints(to view: UIView) {
        let margins = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -10),
            view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 10)
            ])
        
        if #available(iOS 11, *) {
            let guide = self.view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0)
                ])
            
        } else {
            let standardSpacing: CGFloat = 8.0
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing)
                ])
        }
    }
}
