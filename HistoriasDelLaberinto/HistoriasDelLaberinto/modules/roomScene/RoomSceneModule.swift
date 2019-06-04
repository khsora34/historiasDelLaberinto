class RoomSceneModule: Module {
    let storyboardName: String = "RoomScene"
    let controllerName: String = "RoomSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic
    
    init(routerProvider: RouterProvider, databaseFetcherProvider: DatabaseFetcherProvider) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        presenter = RoomScenePresenter()
        router = routerProvider.roomSceneRouter
        interactor = RoomSceneInteractor(databaseFetcherProvider: databaseFetcherProvider)
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
        
    }
}
