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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.addCharactersStatus([])
    }
}

extension BattleScenePresenter: BattleScenePresentationLogic {
}
