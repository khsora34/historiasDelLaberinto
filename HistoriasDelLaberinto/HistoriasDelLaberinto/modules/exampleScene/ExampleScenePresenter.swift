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
        router?.showDialog(nextStep: "exampleDialogue1")
    }
}
