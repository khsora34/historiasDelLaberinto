import UIKit
import Kingfisher

protocol BattleSceneDisplayLogic: ViewControllerDisplay {
    func addCharactersStatus(_ models: [StatusViewModel])
    func setBackground(using imageSource: ImageSource?)
    func setEnemyInfo(imageSource: ImageSource, model: StatusViewModel)
    func updateView(_ model: StatusViewModel)
    func performDamage(on model: StatusViewModel)
    func configureButtons(availableActions: [BattleAction])
    func setHiddenActions(_ isHidden: Bool)
}

class BattleSceneViewController: BaseViewController {
    private var presenter: BattleScenePresentationLogic? {
        return _presenter as? BattleScenePresentationLogic
    }
    
    @IBOutlet weak var enemyStatusView: StatusView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var enemyImageView: UIImageView!
    @IBOutlet weak var charactersStackView: UIStackView!
    @IBOutlet weak var actionsStackView: UIStackView!
    @IBOutlet weak var bottomContainer: UIStackView!
    
    // MARK: View lifecycle
    
    func configureButtons(availableActions: [BattleAction]) {
        var views: [UIView] = []
        for action in availableActions {
            let button = ConfigurableButton(frame: .zero)
            button.setStyle(ButtonStyle.defaultButtonStyle)
            button.text = Localizer.localizedString(key: action.actionKey)
            button.tag = action.rawValue
            button.addTarget(self, action: #selector(didTapAction(sender:)), for: .touchUpInside)
            views.append(button)
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
    
    @objc func didTapAction(sender: UIButton) {
        switch BattleAction(rawValue: sender.tag) {
        case .attack?:
            presenter?.protaWillAttack()
        case .item:
            presenter?.protaWillUseItems()
        case .none:
            return
        }
    }
}

extension BattleSceneViewController: BattleSceneDisplayLogic {
    func addCharactersStatus(_ models: [StatusViewModel]) {
        for model in models {
            // Auto Layout will do the job.
            let statusView = StatusView(frame: CGRect.zero)
            statusView.configure(withModel: model)
            charactersStackView.addArrangedSubview(statusView)
        }
    }
    
    func setBackground(using imageSource: ImageSource?) {
        guard let imageSource = imageSource else {
            backgroundImageView.image = UIImage(named: "GenericRoom1")
            return
        }
        backgroundImageView.setImage(from: imageSource)
    }
    
    func setEnemyInfo(imageSource: ImageSource, model: StatusViewModel) {
        enemyImageView.setImage(from: imageSource)
        enemyStatusView.configure(withModel: model)
    }
    
    func updateView(_ model: StatusViewModel) {
        if model.isEnemy {
            enemyStatusView.configure(withModel: model)
        } else if let view = charactersStackView.arrangedSubviews.filter({ ($0 as? StatusView)?.characterChosen == model.chosenCharacter }).first as? StatusView {
            view.configure(withModel: model)
        }
    }
    
    func performDamage(on model: StatusViewModel) {
        if model.isEnemy {
            enemyStatusView.shake()
        } else if let view = charactersStackView.arrangedSubviews.filter({ ($0 as? StatusView)?.characterChosen == model.chosenCharacter }).first {
            view.shake()
        }
    }
    
    func setHiddenActions(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.actionsStackView.isHidden = isHidden
            self.bottomContainer.layoutIfNeeded()
        }
    }
}
