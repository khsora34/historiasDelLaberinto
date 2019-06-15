import UIKit

protocol PauseMenuSceneRoutingLogic: RouterLogic {
    
}

class PauseMenuSceneRouter: BaseRouter, PauseMenuSceneRoutingLogic {
    func goToExampleView() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigation.pushViewController(module.viewController, animated: true)
    }
}
