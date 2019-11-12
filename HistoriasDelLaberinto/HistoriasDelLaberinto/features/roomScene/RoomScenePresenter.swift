protocol RoomScenePresentationLogic: Presenter {
    func selectedAction(_ tag: Int)
    func getInfoMessage() -> String
    func showMenu()
    func startWithStartEvent()
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
    
    private var filteredActions: [Action] = []
    
    var room: Room
    var shouldLaunchStartEvent: Bool
    var shouldSetVisitedWhenFinished: Bool = false
    var shouldEndGameWhenFinished: Bool = false
    var actualEvent: Event?
    
    var dialog: DialogDisplayLogic? {
        get {
            return viewController?.dialog
        }
        set {
            viewController?.dialog = newValue
        }
    }
    
    init(roomId: String, room: Room) {
        self.room = room
        shouldLaunchStartEvent = room.startEvent != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.set(title: room.name)
        viewController?.setImage(for: room.imageSource)
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
    func startWithStartEvent() {
        if shouldLaunchStartEvent, let id = room.startEvent {
            startEvent(with: id)
            shouldLaunchStartEvent = false
        }
    }
    
    func selectedAction(_ tag: Int) {
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
        router?.goToMenu()
    }
}

extension RoomScenePresenter: EventHandlerPresenter {
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
