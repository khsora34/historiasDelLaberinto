import UIKit

protocol RoomSceneRoutingLogic: EventHandlerRoutingLogic {
    func goToMovementView(actualRoom: Room)
}

class RoomSceneRouter: BaseRouter, RoomSceneRoutingLogic {
    func goToExampleView() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigation.pushViewController(module.viewController, animated: true)
    }
}

extension RoomSceneRouter {
    func present(_ controller: UIViewController, animated: Bool) {
        drawer?.present(controller, animated: animated, completion: nil)
    }
    
    func goToMovementView(actualRoom: Room) {
        let controller = moduleProvider.movementSceneModule(room: actualRoom).viewController
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
    
    func dismiss(animated: Bool) {
        drawer?.dismiss(animated: animated, completion: nil)
    }
    
    func goToBattle(with enemy: PlayableCharacter, with delegate: BattleBuilderDelegate) {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.battleSceneModule(enemy: enemy, delegate: delegate)
        navigation.pushViewController(module.viewController, animated: true)
    }
    
    func endGame() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.initialSceneModule()
        navigation.setViewControllers([module.viewController], animated: true)
    }
}

extension RoomSceneRouter: ImageRemover {}
