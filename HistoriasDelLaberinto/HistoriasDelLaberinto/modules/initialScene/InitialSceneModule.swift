class InitialSceneModule: Module {
    let storyboardName: String = "InitialScene"
    let controllerName: String = "InitialSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic
    
    init(routerProvider: RouterProvider, databaseFetcherProvider: DatabaseFetcherProvider) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        presenter = InitialScenePresenter()
        router = routerProvider.initialSceneRouter
        interactor = InitialSceneInteractor(databaseFetcherProvider: databaseFetcherProvider)
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
        
    }
}
