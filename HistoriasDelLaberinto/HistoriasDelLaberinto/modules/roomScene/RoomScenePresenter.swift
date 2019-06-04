protocol RoomScenePresentationLogic: Presenter {
    func start()
    func showInfo()
    func showMenu()
}

class RoomScenePresenter: BasePresenter {
    var dialog: DialogDisplayLogic?
    
    var actualEvent: Event?
    
    var viewController: RoomSceneDisplayLogic? {
        return _viewController as? RoomSceneDisplayLogic
    }
    
    var interactor: RoomSceneInteractor? {
        return _interactor as? RoomSceneInteractor
    }
    
    var router: RoomSceneRouter? {
        return _router as? RoomSceneRouter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.set(title: "Hola")
    }
}

extension RoomScenePresenter: RoomScenePresentationLogic {
    func start() {
        startEvent(with: "exampleChoice")
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
