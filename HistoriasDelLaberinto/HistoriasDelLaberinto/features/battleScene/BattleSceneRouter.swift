import UIKit

protocol BattleSceneRoutingLogic: RouterLogic {
    func present(_ controller: UIViewController, animated: Bool)
    func dismiss(animated: Bool)
}

class BattleSceneRouter: BaseRouter, BattleSceneRoutingLogic {
    func present(_ controller: UIViewController, animated: Bool) {
        drawer?.present(controller, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool) {
        drawer?.dismiss(animated: animated, completion: nil)
    }
}
