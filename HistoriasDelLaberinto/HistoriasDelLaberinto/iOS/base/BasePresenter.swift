protocol Presenter: LocalizableStringPresenterProtocol {
    var _viewController: ViewControllerDisplay? { get set }
    var _interactor: BusinessLogic? { get set }
    var _router: RouterLogic? { get set }
    
    func viewDidLoad()
}

extension Presenter {
    func localizedString(key: String) -> String {
        return _interactor!.getString(key: key)
    }
}

class BasePresenter: Presenter {
    weak var _viewController: ViewControllerDisplay?
    var _interactor: BusinessLogic?
    var _router: RouterLogic?
    
    func viewDidLoad() {}
}
