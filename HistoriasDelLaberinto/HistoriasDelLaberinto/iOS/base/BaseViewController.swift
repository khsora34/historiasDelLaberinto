import UIKit

protocol ViewControllerDisplay: BaseViewController {
    var _presenter: Presenter? { get set }
}

class BaseViewController: UIViewController {
    var _presenter: Presenter?
}

extension BaseViewController: ViewControllerDisplay {}
