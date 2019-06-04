import UIKit

protocol MovementSceneRoutingLogic: RouterLogic {
    func dismiss()
}

class MovementSceneRouter: BaseRouter, MovementSceneRoutingLogic {
    func goToExampleView() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigation.pushViewController(module.viewController, animated: true)
    }
    
    func dismiss() {
        drawer?.dismiss(animated: true)
        removeBlur()
    }
    
    private func removeBlur() {
        guard let drawer = drawer else { return }
        for view in drawer.view.subviews where view.isKind(of: UIVisualEffectView.self) {
            view.removeFromSuperview()
        }
    }
}
