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
        viewController?.addCharactersStatus([])
        getProtagonist()
        getPartner()
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
}
