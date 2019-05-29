class DialogModule: Module {
    var storyboardName: String = ""
    var controllerName: String = ""
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic
    
    init(nextStep: String, routerProvider: RouterProvider, databaseFetcherProvider: DatabaseFetcherProvider) {
        viewController = Dialog.createDialog()
        presenter = DialogPresenter(nextStep: nextStep)
        router = routerProvider.dialogRouter
        interactor = DialogInteractor(databaseFetcherProvider: databaseFetcherProvider)
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
        
    }
}
