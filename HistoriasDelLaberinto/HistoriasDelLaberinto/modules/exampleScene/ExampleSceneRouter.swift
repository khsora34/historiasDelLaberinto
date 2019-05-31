import UIKit

protocol ExampleSceneRoutingLogic: EventHandlerRoutingLogic {
    func goToNextView()
    func goToNewView()
}

class ExampleSceneRouter: BaseRouter, ExampleSceneRoutingLogic {
    
    // MARK: Routing
    
    func goToNextView() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigation.pushViewController(module.viewController, animated: true)
    }
    
    func goToNewView() {
        guard let navigator = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigator.setViewControllers([module.viewController], animated: true)
    }
    
    func present(_ controller: UIViewController, animated: Bool) {
        drawer?.present(controller, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool) {
        drawer?.dismiss(animated: animated, completion: nil)
    }
}
