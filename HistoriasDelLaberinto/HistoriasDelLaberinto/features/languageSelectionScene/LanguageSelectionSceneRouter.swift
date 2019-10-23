import UIKit

protocol LanguageSelectionSceneRoutingLogic: RouterLogic {
    func goBackToMainMenu()
}

class LanguageSelectionSceneRouter: BaseRouter, LanguageSelectionSceneRoutingLogic {
    func goBackToMainMenu() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.initialSceneModule()
        navigation.setViewControllers([module.viewController], animated: true)
    }
}
