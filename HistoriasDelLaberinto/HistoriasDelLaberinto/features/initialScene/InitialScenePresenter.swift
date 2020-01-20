protocol InitialScenePresentationLogic: Presenter {
    func startNewGame()
    func loadGame()
    func goToLanguagesSelection()
}

class InitialScenePresenter: BasePresenter {
    private var viewController: InitialSceneDisplayLogic? {
        return _viewController as? InitialSceneDisplayLogic
    }
    
    private var interactor: InitialSceneBusinessLogic? {
        return _interactor as? InitialSceneBusinessLogic
    }
    
    private var router: InitialSceneRoutingLogic? {
        return _router as? InitialSceneRoutingLogic
    }
    
    private var nextRoomId: String?
    var movement: Movement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.updateTexts()
        movement = interactor?.getMovement().movement
        viewController?.setLoadButton(isHidden: movement == nil)
    }
}

extension InitialScenePresenter: InitialScenePresentationLogic {
    func startNewGame() {
        nextRoomId = "startRoom"
        viewController?.setLoadButton(isHidden: true)
        viewController?.showLoading(message: Localizer.localizedString(key: "loadingPrompt"))
        interactor?.deleteAllFiles()
        let request = InitialScene.FileLoader.Request(imageDelegate: self)
        interactor?.loadAllFiles(request: request)
    }
    
    func loadGame() {
        guard let movement = movement else { return }
        guard let items = movement.map, let map = Array(items) as? [RoomPosition], !map.isEmpty else {
            viewController?.showAlert(title: nil, message: Localizer.localizedString(key: "loadingGameError"), actions: [(title: Localizer.localizedString(key: "genericButtonAccept"), style: .default, completion: nil)])
            return
        }
        let mapPositions = map.filter({ $0.x == movement.actualX && $0.y == movement.actualY })
        guard mapPositions.count == 1, let roomId = mapPositions.first?.roomId else {
            viewController?.showAlert(title: nil, message: Localizer.localizedString(key: "loadingGameError"), actions: [(title: Localizer.localizedString(key: "genericButtonAccept"), style: .default, completion: nil)])
            return
        }
        viewController?.showLoading(message: Localizer.localizedString(key: "loadingPrompt"))
        nextRoomId = roomId
        interactor?.reloadGame(request: InitialScene.FileLoader.Request(imageDelegate: self))
    }
    
    func goToLanguagesSelection() {
        router?.goToLanguagesSelection()
    }
}

extension InitialScenePresenter {
    private func goToRoom(id: String) {
        let request = InitialScene.RoomBuilder.Request(roomId: id)
        let response = interactor?.getRoom(request: request)
        
        guard let room = response?.room else {
            viewController?.showAlert(title: nil, message: Localizer.localizedString(key: "loadingGameError"), actions: [(title: Localizer.localizedString(key: "genericButtonAccept"), style: .default, completion: nil)])
            return
        }
        interactor?.createMovement()
        router?.goToRoomView(roomId: id, room: room)
    }
}

extension InitialScenePresenter: ImageLoaderDelegate {
    func finishedLoadingImages(numberOfImagesLoaded: Int, source: ImageLoaderSource) {
        viewController?.dismissLoading { [weak self] in
            if let nextRoomId = self?.nextRoomId {
                self?.goToRoom(id: nextRoomId)
            } else {
                self?.viewController?.showAlert(title: nil, message: Localizer.localizedString(key: "loadingGameError"), actions: [(title: Localizer.localizedString(key: "genericButtonAccept"), style: .default, completion: nil)])
            }
        }
    }
}
