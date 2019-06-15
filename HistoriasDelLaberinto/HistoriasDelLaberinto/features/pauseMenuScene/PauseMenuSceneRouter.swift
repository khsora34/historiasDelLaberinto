import UIKit

protocol PauseMenuSceneRoutingLogic: RouterLogic {
    func endGame()
}

class PauseMenuSceneRouter: BaseRouter, PauseMenuSceneRoutingLogic {
    func endGame() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.initialSceneModule()
        navigation.setViewControllers([module.viewController], animated: true)
    }
}
