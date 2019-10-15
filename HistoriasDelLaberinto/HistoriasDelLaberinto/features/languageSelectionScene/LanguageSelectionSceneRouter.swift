import UIKit

protocol LanguageSelectionSceneRoutingLogic: RouterLogic {
    
}

class LanguageSelectionSceneRouter: BaseRouter, LanguageSelectionSceneRoutingLogic {
    func goToExampleView() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigation.pushViewController(module.viewController, animated: true)
    }
}
