protocol InitialScenePresentationLogic: Presenter {
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
    func startNewGame() {
        interactor?.deleteAllFiles()
        interactor?.loadAllFiles()
        goToRoom(id: "startRoom")
    }
    
    
    private func goToRoom(id: String) {
        let request = InitialScene.RoomBuilder.Request(roomId: id)
        let response = interactor?.getRoom(request: request)
        
        guard let room = response?.room else {
            viewController?.showUnableToStartGame()
            return
        }
        router?.goToRoomView(roomId: id, room: room)
    }
}
