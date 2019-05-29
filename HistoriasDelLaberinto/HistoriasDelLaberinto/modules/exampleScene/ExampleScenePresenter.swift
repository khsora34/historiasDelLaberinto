import UIKit

protocol ExampleScenePresentationLogic: Presenter {
    func calculateValueWith(string: String?)
    func saveToDb()
    func getFromDb()
}

class ExampleScenePresenter: BasePresenter {
    var viewController: ExampleSceneDisplayLogic? {
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
        let request = ExampleSceneModels.DatabaseSaving.Request(id: "choiceTest1", event: ChoiceEvent(options: [Action(name: "accion1", nextStep: "2", condition: nil), Action(name: "accion2", nextStep: nil, condition: .partner(id: "HOLA")), Action(name: "3", nextStep: "4", condition: .item(id: "potion"))]))
        interactor?.saveDb(request: request)
    }
    
    func getFromDb() {
        let request = ExampleSceneModels.DatabaseGetting.Request(id: "choiceTest1")
        let newEvent = interactor?.getDb(request: request).event
        viewController?.displayNextStep(viewModel: ExampleSceneModels.DatabaseGetting.ViewModel(nextStep: (newEvent as? ChoiceEvent)?.options[0].nextStep))
    }
}
