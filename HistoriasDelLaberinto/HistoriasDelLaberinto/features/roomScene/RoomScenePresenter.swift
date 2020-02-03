protocol RoomScenePresentationLogic: Presenter {
    func selectedAction(_ tag: Int)
    func showMenu()
    func startWithStartEvent()
    func didTapInfoButton()
}

class RoomScenePresenter: BasePresenter {
    var viewController: RoomSceneDisplayLogic? { return _viewController as? RoomSceneDisplayLogic }
    var interactor: RoomSceneInteractor? { return _interactor as? RoomSceneInteractor }
    var router: RoomSceneRouter? { return _router as? RoomSceneRouter }
    
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
    
    init(room: Room) {
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
        let filteredActions = room.actions.filter { action in
            guard let condition = action.condition else { return true }
            let request = EventsHandlerModels.CompareCondition.Request(condition: condition)
            return interactor?.compareCondition(request: request).result ?? false
        }
        let newActions = filteredActions.filter { !self.filteredActions.contains($0) }
        let maintainingActions = self.filteredActions.filter { filteredActions.contains($0) }
        self.filteredActions = maintainingActions + newActions
        
        var modeledActions = filteredActions.map({ $0.name })
        modeledActions.append("movementAction")
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
    
    func showMenu() {
        router?.goToMenu()
    }
    
    func didTapInfoButton() {
        viewController?.showAlert(title: Localizer.localizedString(key: room.name), message: Localizer.localizedString(key: room.description), actions: [(title: Localizer.localizedString(key: "genericButtonAccept"), style: .default, completion: nil)])
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
