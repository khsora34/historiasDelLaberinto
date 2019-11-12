import UIKit.UIViewController

protocol EventHandlerRoutingLogic: BaseRouter {
    func present(_ controller: UIViewController, animated: Bool)
    func dismiss(animated: Bool)
    func goToBattle(against enemy: PlayableCharacter, backgroundImage: ImageSource, finisher delegate: OnBattleFinishedDelegate)
    func endGame()
}
