protocol InitialScenePresentationLogic: Presenter {
    func loadFiles()
    func deleteFiles()
    func startNewGame()
}

class InitialScenePresenter: BasePresenter {
    var viewController: InitialSceneDisplayLogic? {
        return _viewController as? InitialSceneDisplayLogic
    }
    
    var interactor: InitialSceneInteractor? {
        return _interactor as? InitialSceneInteractor
    }
    
    var router: InitialSceneRoutingLogic? {
        return _router as? InitialSceneRoutingLogic
    }
}

extension InitialScenePresenter: InitialScenePresentationLogic {
    func loadFiles() {
        interactor?.loadAllFiles()
    }
    
    func deleteFiles() {
        interactor?.deleteAllFiles()
    }
    
    func startNewGame() {
        interactor?.deleteAllFiles()
        interactor?.loadAllFiles()
        goToStartRoom()
    }
    
    private func goToStartRoom() {
        let request = InitialScene.RoomBuilder.Request(roomId: "startRoom")
        let response = interactor?.getRoom(request: request)
        
        guard let room = response?.room else {
            viewController?.showUnableToStartGame()
            return
        }
        router?.goToRoomView(roomId: "startRoom", room: room)
    }
}
