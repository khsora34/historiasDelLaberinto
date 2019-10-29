import UIKit

protocol InitialSceneRoutingLogic: RouterLogic {
    func goToExampleView()
    func goToLanguagesSelection()
    func goToRoomView(roomId: String, room: Room)
}

class InitialSceneRouter: BaseRouter, InitialSceneRoutingLogic {
    func goToExampleView() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigation.pushViewController(module.viewController, animated: true)
    }
    
    func goToLanguagesSelection() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.languagesSelection()
        navigation.pushViewController(module.viewController, animated: true)
    }
    
    func goToRoomView(roomId: String, room: Room) {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.roomSceneModule(roomId: roomId, room: room)
        navigation.pushViewController(module.viewController, animated: true)
    }
}
