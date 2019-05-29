protocol DialogPresentationLogic: Presenter {
    func getNextStep() -> DialogModels.EventFetcher.ViewModel
}

class DialogPresenter: BasePresenter {
    var viewController: DialogDisplayLogic? {
        return _viewController as? DialogDisplayLogic
    }
    
    var interactor: DialogInteractor? {
        return _interactor as? DialogInteractor
    }
    
    var router: DialogRoutingLogic? {
        return _router as? DialogRoutingLogic
    }
    
    private var nextStep: String
    
    init(nextStep: String) {
        self.nextStep = nextStep
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = DialogModels.EventFetcher.Request(id: nextStep)
        let response = interactor?.getNextEvent(request: request)
        switch response {
        case .success(let name, let imageUrl, let message)?:
            let dialogConfigurator = DialogConfigurator(name: name, message: message, imageUrl: imageUrl)
            viewController?.setFirstConfigurator(configurator: dialogConfigurator)
        default:
            router?.dismiss()
        }
    }
}

extension DialogPresenter: DialogPresentationLogic {
    func getNextStep() -> DialogModels.EventFetcher.ViewModel {
        let request = DialogModels.EventFetcher.Request(id: nextStep)
        let response = interactor?.getNextEvent(request: request)
        switch response {
        case .success(let name, let imageUrl, let message)?:
            let dialogConfigurator = DialogConfigurator(name: name, message: message, imageUrl: imageUrl)
            return DialogModels.EventFetcher.ViewModel(dialogConfigurator: dialogConfigurator)
        default:
            return DialogModels.EventFetcher.ViewModel(dialogConfigurator: nil)
        }
    }
}
