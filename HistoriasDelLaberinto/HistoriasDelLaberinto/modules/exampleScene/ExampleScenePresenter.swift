import UIKit

protocol ExampleScenePresentationLogic: Presenter {
    func calculateValueWith(string: String?)
    func navigateToPlace()
    func navigateToNewPlace()
    func showDialog()
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
    
    // MARK: Event handler
    
    var dialog: DialogDisplayLogic?
    var actualEvent: Event?
    
}

// MARK: Do something

extension ExampleScenePresenter: ExampleScenePresentationLogic {
    func navigateToNewPlace() {
        router?.goToNewView()
    }
    
    func navigateToPlace() {
        router?.goToNextView()
    }
    
    func calculateValueWith(string: String?) {
        guard let interactor = interactor else { return }
        let request = ExampleSceneModels.Something.Request(input: string)
        let response = interactor.doSomething(request: request)
        let viewModel = ExampleSceneModels.Something.ViewModel(modeledValue: response.output)
        viewController?.displaySomething(viewModel: viewModel)
    }
    
    func showDialog() {
        startEvent(with: "exampleDialogue1")
    }
}

extension ExampleScenePresenter: EventHandler {
    var eventHandlerRouter: EventHandlerRoutingLogic? {
        return _router as? EventHandlerRoutingLogic
    }
    
    var eventHandlerInteractor: EventHandlerInteractor? {
        return _interactor as? EventHandlerInteractor
    }
}
