import UIKit

protocol InitialSceneRoutingLogic: RouterLogic {
    func goToExampleView()
    func goToRoomView(room: Room)
}

class InitialSceneRouter: BaseRouter, InitialSceneRoutingLogic {
    func goToExampleView() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigation.pushViewController(module.viewController, animated: true)
    }
    
    func goToRoomView(room: Room) {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.roomSceneModule(room: room)
        navigation.pushViewController(module.viewController, animated: true)
    }
}
