import UIKit

protocol ViewControllerDisplay: LoadingLauncher, AlertLauncher {
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
