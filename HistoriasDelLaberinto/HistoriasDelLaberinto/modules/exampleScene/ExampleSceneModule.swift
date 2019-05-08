class ExampleSceneModule: Module {
    let storyboardName: String = "ExampleScene"
    let controllerName: String = "ExampleSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic

    init(routerProvider: RouterProvider) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        let presenterInput = ExampleScenePresenterInput()
        presenter = ExampleScenePresenter(input: presenterInput)
        router = routerProvider.exampleSceneRouter
        interactor = ExampleSceneInteractor()
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
        
    }
}
