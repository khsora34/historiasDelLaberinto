protocol InitialScenePresentationLogic: Presenter {
    func loadFiles()
    func deleteFiles()
}

class InitialScenePresenter: BasePresenter {
    var viewController: InitialSceneDisplayLogic? {
        return _viewController as? InitialSceneDisplayLogic
    }
    
    var interactor: InitialSceneInteractor? {
        return _interactor as? InitialSceneInteractor
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
}
