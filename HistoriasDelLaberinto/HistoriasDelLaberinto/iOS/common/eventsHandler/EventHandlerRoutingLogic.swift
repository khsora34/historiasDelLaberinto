import UIKit.UIViewController

protocol EventHandlerRoutingLogic: BaseRouter {
    func present(_ controller: UIViewController, animated: Bool)
    func dismiss(animated: Bool)
    func goToBattle(with enemy: PlayableCharacter, with delegate: BattleBuilderDelegate)
    func endGame()
}
