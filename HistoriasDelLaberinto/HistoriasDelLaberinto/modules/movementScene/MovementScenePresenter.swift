protocol MovementScenePresentationLogic: Presenter {
    func dismiss()
}

class MovementScenePresenter: BasePresenter {
    var viewController: MovementSceneDisplayLogic? {
        return _viewController as? MovementSceneDisplayLogic
    }
    
    var interactor: MovementSceneInteractor? {
        return _interactor as? MovementSceneInteractor
    }
    
    var router: MovementSceneRouter? {
        return _router as? MovementSceneRouter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MovementScenePresenter: MovementScenePresentationLogic {
    func dismiss() {
        router?.dismiss()
    }
}
