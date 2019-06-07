protocol PauseMenuScenePresentationLogic: Presenter {
}

class PauseMenuScenePresenter: BasePresenter {
    var viewController: PauseMenuSceneDisplayLogic? {
        return _viewController as? PauseMenuSceneDisplayLogic
    }
    
    var interactor: PauseMenuSceneInteractor? {
        return _interactor as? PauseMenuSceneInteractor
    }
    
    var router: PauseMenuSceneRouter? {
        return _router as? PauseMenuSceneRouter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension PauseMenuScenePresenter: PauseMenuScenePresentationLogic {
}
