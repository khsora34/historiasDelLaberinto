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
        let enemy = PlayableCharacter(name: "Bad guy", imageUrl: "https://i.imgur.com/U6RBjYo.png", portraitUrl: "https://i.imgur.com/zDH1edR.png", currentHealthPoints: 500, maxHealthPoints: 500, attack: 70, defense: 30, agility: 40, currentStatusAilment: nil, weapon: nil)
        let module = moduleProvider.battleSceneModule(enemy: enemy)
//        let module = moduleProvider.roomSceneModule(roomId: roomId, room: room)
        navigation.isNavigationBarHidden = false
        navigation.pushViewController(module.viewController, animated: true)
    }
}
