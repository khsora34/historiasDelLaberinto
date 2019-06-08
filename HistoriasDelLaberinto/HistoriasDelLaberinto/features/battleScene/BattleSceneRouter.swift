import UIKit

protocol BattleSceneRoutingLogic: RouterLogic {
    func popToRoom()
}

class BattleSceneRouter: BaseRouter, BattleSceneRoutingLogic {
    func popToRoom() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        navigation.popViewController(animated: true)
    }
}
