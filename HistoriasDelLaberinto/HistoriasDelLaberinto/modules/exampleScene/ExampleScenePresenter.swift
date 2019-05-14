import UIKit

protocol ExampleScenePresentationLogic: Presenter {
    func calculateValueWith(string: String?)
    func saveToDb()
    func getFromDb()
}

class ExampleScenePresenter: BasePresenter {
    weak var viewController: ExampleSceneDisplayLogic? {
        return _viewController as? ExampleSceneDisplayLogic
    }
    
    var interactor: ExampleSceneInteractor? {
        return _interactor as? ExampleSceneInteractor
    }
    
    var router: ExampleSceneRouter? {
        return _router as? ExampleSceneRouter
    }
    
}

// MARK: Do something

extension ExampleScenePresenter: ExampleScenePresentationLogic {
    func calculateValueWith(string: String?) {
        guard let interactor = interactor else { return }
        let request = ExampleSceneModels.Something.Request(input: string)
        let response = interactor.doSomething(request: request)
        let viewModel = ExampleSceneModels.Something.ViewModel(modeledValue: response.output)
        viewController?.displaySomething(viewModel: viewModel)
    }
    
    func saveToDb() {
        let request = ExampleSceneModels.DatabaseSaving.Request(id: "lalaland", event: DialogueEvent(characterId: "si", message: "hola", nextStep: "lalaland2"))
        interactor?.saveDb(request: request)
    }
    
    func getFromDb() {
        let request = ExampleSceneModels.DatabaseGetting.Request(id: "lalaland")
        viewController?.displayNextStep(viewModel: ExampleSceneModels.DatabaseGetting.ViewModel(nextStep: interactor?.getDb(request: request).event?.nextStep))
    }
}
