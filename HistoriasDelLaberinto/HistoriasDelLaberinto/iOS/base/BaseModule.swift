import UIKit

protocol Module {
    var storyboardName: String { get }
    var controllerName: String { get }
    var viewController: ViewControllerDisplay { get }
    var interactor: BusinessLogic { get }
    var presenter: Presenter { get }
    var router: RouterLogic { get }
}
