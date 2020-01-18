protocol InitialScenePresentationLogic: Presenter {
    func startNewGame()
    func loadGame()
    func goToLanguagesSelection()
}

class InitialScenePresenter: BasePresenter {
    var viewController: InitialSceneDisplayLogic? {
        return _viewController as? InitialSceneDisplayLogic
    }
    
    var interactor: InitialSceneBusinessLogic? {
        return _interactor as? InitialSceneBusinessLogic
    }
    
    var router: InitialSceneRoutingLogic? {
        return _router as? InitialSceneRoutingLogic
    }
    
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
        
        goToRoom(id: roomId)
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
    func finishedLoadingImages(numberOfImagesLoaded: Int) {
//        guard numberOfImagesLoaded > 0 else {
//            viewController?.dismissLoading { [weak self] in
//                self?.viewController?.showUnableToStartGame()
//            }
//            return
//        }
        viewController?.dismissLoading { [weak self] in
            self?.goToRoom(id: "startRoom")
        }
    }
}
