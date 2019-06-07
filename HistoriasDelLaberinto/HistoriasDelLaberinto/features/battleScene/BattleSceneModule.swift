class BattleSceneModule: Module {
    let storyboardName: String = "BattleScene"
    let controllerName: String = "BattleSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic
    
    init(routerProvider: RouterProvider) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        presenter = BattleScenePresenter()
        router = routerProvider.voidRouter
        interactor = BattleSceneInteractor()
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
    }
}
