import UIKit

protocol InitialSceneRoutingLogic: RouterLogic {
    func goToExampleView()
    func goToRoomView(roomId: String, room: Room)
}

class InitialSceneRouter: BaseRouter, InitialSceneRoutingLogic {
    func goToExampleView() {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let module = moduleProvider.exampleSceneModule()
        navigation.pushViewController(module.viewController, animated: true)
    }
    
    func goToRoomView(roomId: String, room: Room) {
        guard let navigation = drawer?.currentRootViewController as? UINavigationController else { return }
        let enemy = PlayableCharacter(name: "Bad guy", currentHealthPoints: 1000, maxHealthPoints: 1000, attack: 10, defense: 10, agility: 10, currentStatusAilment: nil, weapon: nil, imageUrl: "https://i.imgur.com/U6RBjYo.png")
        let module = moduleProvider.battleSceneModule(enemy: enemy)
//        let module = moduleProvider.roomSceneModule(roomId: roomId, room: room)
        navigation.isNavigationBarHidden = false
        navigation.pushViewController(module.viewController, animated: true)
    }
}
