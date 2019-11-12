import UIKit
import Kingfisher

protocol BattleSceneDisplayLogic: ViewControllerDisplay {
    func addCharactersStatus(_ models: [StatusViewModel])
    func setBackground(using imageSource: ImageSource?)
    func setEnemyInfo(imageSource: ImageSource, model: StatusViewModel)
    func updateView(_ model: StatusViewModel)
    func performDamage(on model: StatusViewModel)
    func configureButtons(availableActions: [BattleAction])
}

class BattleSceneViewController: BaseViewController {
    
    private var presenter: BattleScenePresentationLogic? {
        return _presenter as? BattleScenePresentationLogic
    }
    
    var enemyStatus: StatusView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var enemyImageView: UIImageView!
    @IBOutlet weak var charactersStackView: UIStackView!
    @IBOutlet weak var actionsStackView: UIStackView!
    
    // MARK: View lifecycle
    
    func configureButtons(availableActions: [BattleAction]) {
        var views: [UIButton] = []
        if availableActions.contains(.attack) {
            let attackButton = ConfigurableButton(frame: .zero)
            attackButton.setupStyle(ButtonStyle.defaultButtonStyle)
            attackButton.setTitle("Atacar", for: .normal)
            attackButton.addTarget(self, action: #selector(didTapAttackButton), for: .touchUpInside)
            views.append(attackButton)
        }
        
        if availableActions.contains(.items) {
            let itemsButton = ConfigurableButton(frame: .zero)
            itemsButton.setupStyle(ButtonStyle.defaultButtonStyle)
            itemsButton.setTitle("Inventario", for: .normal)
            itemsButton.addTarget(self, action: #selector(didTapItemsButton), for: .touchUpInside)
            views.append(itemsButton)
        }
        
        actionsStackView.addViewsInColumns(views)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func didTapAttackButton() {
        presenter?.protaWillAttack()
    }
    
    @objc func didTapItemsButton() {
        presenter?.protaWillUseItems()
    }
}

extension BattleSceneViewController: BattleSceneDisplayLogic {
    func addCharactersStatus(_ models: [StatusViewModel]) {
        for model in models {
            // Auto Layout will do the job.
            let statusView = StatusView(frame: CGRect.zero)
            model.configure(view: statusView)
            charactersStackView.addArrangedSubview(statusView)
        }
    }
    
    func setBackground(using imageSource: ImageSource?) {
        guard let imageSource = imageSource else {
            backgroundImageView.image = UIImage(named: "GenericRoom1")
            return
        }
        backgroundImageView.setImage(for: imageSource)
    }
    
    func setEnemyInfo(imageSource: ImageSource, model: StatusViewModel) {
        enemyImageView.setImage(for: imageSource)
        enemyStatus = StatusView(frame: CGRect(x: 0, y: 0, width: 394, height: 100))
        model.configure(view: enemyStatus)
        enemyStatus.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enemyStatus)
        setEnemyViewConstraints(to: enemyStatus)
    }
    
    func updateView(_ model: StatusViewModel) {
        if model.isEnemy {
            model.configure(view: enemyStatus)
        } else if let view = charactersStackView.arrangedSubviews.filter({ ($0 as? StatusView)?.characterChosen == model.chosenCharacter }).first as? StatusView {
            model.configure(view: view)
        }
    }
    
    func performDamage(on model: StatusViewModel) {
        if model.isEnemy {
            enemyStatus.shake()
        } else if let view = charactersStackView.arrangedSubviews.filter({ ($0 as? StatusView)?.characterChosen == model.chosenCharacter }).first {
            view.shake()
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
