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
    
    private var movement: Movement!
    private var genericRooms: [Room]!
    private var availableRooms: [Room]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMovement()
        getRooms()
        
    }
    
    private func getMovement() {
        let response = interactor?.getMovement()
        movement = response?.movement
    }
    
    private func getRooms() {
        let request = MovementScene.GetAllRooms.Request(movement: movement)
        let response = interactor?.getAllRooms(request: request)
        genericRooms = response?.genericRooms
        availableRooms = response?.availableRooms
    }
}

extension MovementScenePresenter: MovementScenePresentationLogic {
    func dismiss() {
        router?.dismiss()
    }
}
