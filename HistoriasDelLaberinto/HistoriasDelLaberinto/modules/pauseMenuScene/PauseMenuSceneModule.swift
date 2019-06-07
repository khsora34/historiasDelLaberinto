class PauseMenuSceneModule: Module {
    let storyboardName: String = "PauseMenuScene"
    let controllerName: String = "PauseMenuSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic
    
    init(routerProvider: RouterProvider) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        presenter = PauseMenuScenePresenter()
        router = routerProvider.voidRouter
        interactor = PauseMenuSceneInteractor()
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
    }
}
