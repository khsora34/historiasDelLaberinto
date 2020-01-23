import UIKit

protocol PauseMenuSceneRoutingLogic: RouterLogic {
    func goToItemsView(delegate: CharactersUpdateDelegate?)
    func endGame()
}

class PauseMenuSceneRouter: BaseRouter, PauseMenuSceneRoutingLogic {
    func goToItemsView(delegate: CharactersUpdateDelegate?) {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.itemsSceneModule(delegate: delegate)
        
        navigation.pushViewController(module.viewController, animated: true)
    }
    
    func endGame() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.initialSceneModule()
        navigation.setViewControllers([module.viewController], animated: true)
    }
}
