protocol RoomScenePresentationLogic: Presenter {
    func start(for tag: Int)
    func showInfo()
    func showMenu()
}

class RoomScenePresenter: BasePresenter {
    var viewController: RoomSceneDisplayLogic? {
        return _viewController as? RoomSceneDisplayLogic
    }
    
    var interactor: RoomSceneInteractor? {
        return _interactor as? RoomSceneInteractor
    }
    
    var router: RoomSceneRouter? {
        return _router as? RoomSceneRouter
    }
    
    private var room: Room
    var dialog: DialogDisplayLogic?
    var actualEvent: Event?
    
    init(room: Room) {
        self.room = room
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.set(title: room.name)
        viewController?.setImage(with: room.imageUrl)
        let filteredActions = room.actions.filter { action in
            guard let condition = action.condition else { return true }
            let request = EventsHandlerModels.CompareCondition.Request(condition: condition)
            return interactor?.compareCondition(request: request).result ?? false
        }
        let modeledActions = filteredActions.map({ $0.name })
        viewController?.set(actions: modeledActions)
        
    }
}

extension RoomScenePresenter: RoomScenePresentationLogic {
    func start(for tag: Int) {
        guard let nextStep = room.actions[tag].nextStep else { return }
        startEvent(with: nextStep)
    }
    
    func showInfo() {
        
    }
    func showMenu() {
        
    }
}

extension RoomScenePresenter: EventHandler {
    var eventHandlerRouter: EventHandlerRoutingLogic? {
        return _router as? EventHandlerRoutingLogic
    }
    
    var eventHandlerInteractor: EventHandlerInteractor? {
        return _interactor as? EventHandlerInteractor
    }
}
