import UIKit

protocol ExampleSceneRoutingLogic: RouterLogic {
    func goToNextView()
    func goToNewView()
}

class ExampleSceneRouter: BaseRouter, ExampleSceneRoutingLogic {
    
    // MARK: Routing
    
    func goToNextView() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigation.pushViewController(module.viewController, animated: true)
    }
    
    func goToNewView() {
        guard let navigator = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigator.setViewControllers([module.viewController], animated: true)
    }
    
    func showDialog(nextStep: String) {
        let module = moduleProvider.dialogModule(nextStep: nextStep)
        drawer?.present(module.viewController, animated: true, completion: nil)
    }
}
