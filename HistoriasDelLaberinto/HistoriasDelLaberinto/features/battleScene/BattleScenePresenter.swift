protocol BattleScenePresentationLogic: Presenter {
}

class BattleScenePresenter: BasePresenter {
    var viewController: BattleSceneDisplayLogic? {
        return _viewController as? BattleSceneDisplayLogic
    }
    
    var interactor: BattleSceneInteractor? {
        return _interactor as? BattleSceneInteractor
    }
    
    var router: BattleSceneRouter? {
        return _router as? BattleSceneRouter
    }
    
    private var protagonist: Protagonist!
    private var partner: PlayableCharacter?
    private var enemy: PlayableCharacter
    
    weak var delegate: BattleBuilderDelegate?
    
    init(enemy: PlayableCharacter) {
        self.enemy = enemy
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.setBackground(with: delegate?.imageUrl)
        getProtagonist()
        getPartner()
        buildCharacters()
        buildEnemy()
    }
}

extension BattleScenePresenter: BattleScenePresentationLogic {
}

extension BattleScenePresenter {
    private func getProtagonist() {
        let response = interactor?.getProtagonist()
        protagonist = response?.protagonist
    }
    
    private func getPartner() {
        guard let partnerId = protagonist.partner else { return }
        let request = BattleScene.CharacterGetter.Request(id: partnerId)
        let response = interactor?.getPartner(request: request)
        partner = response?.character
    }
    
    private func buildCharacters() {
        let protagonistModel = StatusViewModel(name: protagonist.name, ailment: protagonist.currentStatusAilment, actualHealth: protagonist.currentHealthPoints, maxHealth: protagonist.maxHealthPoints, imageUrl: protagonist.imageUrl, isEnemy: false, didTouchView: nil)
        var charactersForStatus: [StatusViewModel] = [protagonistModel]
        if let partner = partner {
            let partnerModel = StatusViewModel(name: partner.name, ailment: partner.currentStatusAilment, actualHealth: partner.currentHealthPoints, maxHealth: partner.maxHealthPoints, imageUrl: partner.imageUrl, isEnemy: false, didTouchView: nil)
            charactersForStatus.append(partnerModel)
        }
        viewController?.addCharactersStatus(charactersForStatus)
    }
    
    private func buildEnemy() {
        let model = StatusViewModel(name: enemy.name, ailment: enemy.currentStatusAilment, actualHealth: enemy.currentHealthPoints, maxHealth: enemy.maxHealthPoints, imageUrl: "https://cdn4.iconfinder.com/data/icons/eldorado-culture/40/ghost-512.png", isEnemy: true, didTouchView: nil)
        viewController?.setEnemyInfo(imageUrl: enemy.imageUrl, model: model)
    }
}
