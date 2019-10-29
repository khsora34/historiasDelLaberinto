class MovementSceneModule: Module {
    let storyboardName: String = "MovementScene"
    let controllerName: String = "MovementSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic
    
    init(room: Room, routerProvider: RouterProvider, databaseProvider: DatabaseFetcherProvider) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        presenter = MovementScenePresenter(room: room)
        router = routerProvider.movementSceneRouter
        interactor = MovementSceneInteractor(databaseFetcherProvider: databaseProvider)
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
    }
}
