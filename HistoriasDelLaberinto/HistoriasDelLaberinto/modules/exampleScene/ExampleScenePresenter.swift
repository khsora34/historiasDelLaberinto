import UIKit

protocol ExampleScenePresentationLogic: Presenter {
    func calculateValueWith(string: String?)
    func navigateToPlace()
    func navigateToNewPlace()
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
    
    init(input: ExampleScenePresenterInput) {
        super.init()
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
        let request = ExampleScene.Something.Request(input: string)
        let response = interactor.doSomething(request: request)
        let viewModel = ExampleScene.Something.ViewModel(modeledValue: response.output)
        viewController?.displaySomething(viewModel: viewModel)
    }
}
