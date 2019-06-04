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
        let controller = moduleProvider.movementSceneModule().viewController
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = .overCurrentContext
        addBlur()
        drawer?.present(controller, animated: true, completion: nil)
    }
    
    private func addBlur() {
        guard let drawer = drawer else { return }
        let blurView = UIVisualEffectView()
        blurView.frame = drawer.view.frame
        blurView.effect = UIBlurEffect(style: .dark)
        drawer.view.addSubview(blurView)
    }
    
    func present(_ controller: UIViewController, animated: Bool) {
        drawer?.present(controller, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool) {
        drawer?.dismiss(animated: animated, completion: nil)
    }
}
