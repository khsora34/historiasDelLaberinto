protocol InitialScenePresentationLogic: Presenter {
    func loadFiles()
    func deleteFiles()
    func goToExampleView()
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
        let result = interactor?.loadAllFiles()
        viewController?.setLabelText(with: "Loaded files: \(result?.stringResponse ?? "NO")")
    }
    
    func deleteFiles() {
        interactor?.deleteAllFiles()
    }
    
    func goToExampleView() {
        let roomId = "exampleRoom"
        let request = InitialScene.RoomBuilder.Request(roomId: roomId)
        let response = interactor?.getRoom(request: request)
        guard let room = response?.room else { return }
        router?.goToRoomView(roomId: roomId, room: room)
    }
}
