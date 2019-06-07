import UIKit

protocol BattleSceneRoutingLogic: RouterLogic {
    
}

class BattleSceneRouter: BaseRouter, BattleSceneRoutingLogic {
    func goToExampleView() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigation.pushViewController(module.viewController, animated: true)
    }
}
