class ExampleSceneModule: Module {
    let storyboardName: String = "ExampleScene"
    let controllerName: String = "ExampleSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic

    init(routerProvider: RouterProvider, databaseFetcherProvider: DatabaseFetcherProvider) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        presenter = ExampleScenePresenter()
        router = routerProvider.exampleSceneRouter
        interactor = ExampleSceneInteractor(databaseFetcherProvider: databaseFetcherProvider)
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
        
    }
}
