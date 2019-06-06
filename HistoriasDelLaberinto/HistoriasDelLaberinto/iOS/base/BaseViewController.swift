import UIKit

protocol ViewControllerDisplay: ShowLoadingCapable {
    var _presenter: Presenter? { get set }
}

class BaseViewController: UIViewController {
    var _presenter: Presenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _presenter?.viewDidLoad()
    }
}

extension BaseViewController: ViewControllerDisplay {}
