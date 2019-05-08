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
        if let globalPositionVC = navigator.viewControllers.first {
            let module = moduleProvider.exampleSceneModule()
            navigator.setViewControllers([globalPositionVC, module.viewController], animated: true)
        }
    }
}
