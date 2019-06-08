import UIKit
import Kingfisher

protocol BattleSceneDisplayLogic: ViewControllerDisplay {
    func addCharactersStatus(_ models: [StatusViewModel])
    func setBackground(with imageUrl: String?)
    func setEnemyInfo(imageUrl: String, model: StatusViewModel)
    func updateView(_ model: StatusViewModel)
}

class BattleSceneViewController: BaseViewController {
    
    private var presenter: BattleScenePresentationLogic? {
        return _presenter as? BattleScenePresentationLogic
    }
    
    var enemyStatus: StatusViewController!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var enemyImageView: UIImageView!
    @IBOutlet weak var charactersStackView: UIStackView!
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func didTapAttackButton(_ sender: Any) {
        presenter?.protaWillAttack()
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
        enemyStatus = StatusViewController(frame: CGRect(x: 0, y: 0, width: 394, height: 100))
        model.configure(view: enemyStatus)
        enemyStatus.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enemyStatus)
        setEnemyViewConstraints(to: enemyStatus)
    }
    
    func updateView(_ model: StatusViewModel) {
        if model.isEnemy {
            model.configure(view: enemyStatus)
        } else if let view = charactersStackView.arrangedSubviews.filter({ ($0 as? StatusViewController)?.characterChosen == model.chosenCharacter }).first as? StatusViewController {
            model.configure(view: view)
        }
    }
}

extension BattleSceneViewController {
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
