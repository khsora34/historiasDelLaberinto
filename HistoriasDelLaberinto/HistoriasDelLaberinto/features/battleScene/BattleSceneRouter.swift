import UIKit

protocol BattleSceneRoutingLogic: RouterLogic {
    func present(_ controller: UIViewController, animated: Bool)
    func dismiss(animated: Bool)
    func goToItemsView(delegate: CharactersUpdateDelegate?)
    func goBackToRoom()
}

class BattleSceneRouter: BaseRouter, BattleSceneRoutingLogic {
    func present(_ controller: UIViewController, animated: Bool) {
        drawer?.present(controller, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool) {
        drawer?.dismiss(animated: animated, completion: nil)
    }
    
    func goToItemsView(delegate: CharactersUpdateDelegate?) {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.itemsSceneModule(delegate: delegate)
        
        navigation.pushViewController(module.viewController, animated: true)
    }
    
    func goBackToRoom() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        navigation.popViewController(animated: true)
    }
}

extension BattleSceneRouter: DialogRouter {}
