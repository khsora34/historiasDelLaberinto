import UIKit

protocol PauseMenuSceneRoutingLogic: RouterLogic {
    func goToItemsView(protagonist: Protagonist, partner: PlayableCharacter?)
    func endGame()
}

class PauseMenuSceneRouter: BaseRouter, PauseMenuSceneRoutingLogic {
    func goToItemsView(protagonist: Protagonist, partner: PlayableCharacter?) {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.itemsSceneModule(protagonist: protagonist, partner: partner)
        navigation.pushViewController(module.viewController, animated: true)
    }
    
    func endGame() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.initialSceneModule()
        navigation.setViewControllers([module.viewController], animated: true)
    }
}
