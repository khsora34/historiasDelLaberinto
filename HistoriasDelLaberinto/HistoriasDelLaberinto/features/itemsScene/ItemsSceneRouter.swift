import UIKit

protocol ItemsSceneRoutingLogic: RouterLogic {
    
}

class ItemsSceneRouter: BaseRouter, ItemsSceneRoutingLogic {
    func goToExampleView() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigation.pushViewController(module.viewController, animated: true)
    }
}
