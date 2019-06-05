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
        removeBlur()
        drawer?.dismiss(animated: true)
    }
    
    func goToNewRoom(room: Room) {
        removeBlur()
        drawer?.dismiss(animated: true)
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.roomSceneModule(roomId: room.id, room: room)
        navigation.setViewControllers([module.viewController], animated: true)
    }
    
    private func removeBlur() {
        guard let drawer = drawer else { return }
        for view in drawer.view.subviews where view.isKind(of: UIVisualEffectView.self) {
            view.removeFromSuperview()
        }
    }
}
