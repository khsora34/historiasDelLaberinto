protocol RoomScenePresentationLogic: Presenter {
    func start(for tag: Int)
    func getInfoMessage() -> String
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
    private var filteredActions: [Action] = []
    
    var roomId: String
    var shouldSetVisitedWhenFinished: Bool = false
    var isDialogPresented: Bool = false
    var dialog: DialogDisplayLogic?
    var actualEvent: Event?
    
    init(roomId: String, room: Room) {
        self.roomId = roomId
        self.room = room
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.set(title: room.name)
        viewController?.setImage(with: room.imageUrl)
        loadActions()
    }
    
    private func loadActions() {
        var filteredActions = room.actions.filter { action in
            guard let condition = action.condition else { return true }
            let request = EventsHandlerModels.CompareCondition.Request(condition: condition)
            return interactor?.compareCondition(request: request).result ?? false
        }
        if !self.filteredActions.isEmpty {
            let newActions = filteredActions.filter { action in
                for extAction in self.filteredActions where extAction == action {
                    return false
                }
                return true
            }
            let maintainingActions = self.filteredActions.filter { action in
                filteredActions.contains(where: { second in
                    return action == second
                })
            }
            filteredActions = maintainingActions + newActions
        }
        self.filteredActions = filteredActions
        var modeledActions = filteredActions.map({ $0.name })
        modeledActions.append("Moverse")
        viewController?.set(actions: modeledActions)
    }
}

extension RoomScenePresenter: RoomScenePresentationLogic {
    func start(for tag: Int) {
        if tag == filteredActions.count {
            router?.goToMovementView(actualRoom: room)
            return
        }
        
        guard let nextStep = filteredActions[tag].nextStep else { return }
        startEvent(with: nextStep)
    }
    
    func getInfoMessage() -> String {
        return room.description
    }
    
    func showMenu() {
        
    }
}

extension RoomScenePresenter: EventHandler {    
    var imageUrl: String {
        return room.imageUrl
    }
    
    func onFinish() {
        loadActions()
    }
    
    var eventHandlerRouter: EventHandlerRoutingLogic? {
        return _router as? EventHandlerRoutingLogic
    }
    
    var eventHandlerInteractor: EventHandlerInteractor? {
        return _interactor as? EventHandlerInteractor
    }
}
