protocol Presenter {
    var _viewController: ViewControllerDisplay? { get set }
    var _interactor: BusinessLogic? { get set }
    var _router: RouterLogic? { get set }
    
    func viewDidLoad()
}

class BasePresenter: Presenter {
    weak var _viewController: ViewControllerDisplay?
    var _interactor: BusinessLogic?
    var _router: RouterLogic?
    
    func viewDidLoad() {}
}

extension BasePresenter: LocalizableStringPresenterProtocol {
    func localizedString(key: String) -> String {
        return _interactor!.getString(key: key)
    }
}
