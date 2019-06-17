class ItemsSceneModule: Module {
    let storyboardName: String = "ItemsScene"
    let controllerName: String = "ItemsSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic
    
    init(protagonist: Protagonist, partner: PlayableCharacter?, fetcherProvider: DatabaseFetcherProvider, routerProvider: RouterProvider) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        presenter = ItemsScenePresenter(protagonist: protagonist, partner: partner)
        router = routerProvider.itemsSceneRouter
        interactor = ItemsSceneInteractor(itemFetcher: fetcherProvider.itemsFetcher)
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
    }
}
