class ItemsSceneModule: Module {
    let storyboardName: String = "ItemsScene"
    let controllerName: String = "ItemsSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic
    
    init(protagonist: Protagonist, partner: PlayableCharacter?, delegate: CharactersUpdateDelegate?, fetcherProvider: DatabaseFetcherProvider, routerProvider: RouterProvider) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        presenter = ItemsScenePresenter(protagonist: protagonist, partner: partner)
        (presenter as? ItemsScenePresenter)?.updateDelegate = delegate
        router = routerProvider.itemsSceneRouter
        interactor = ItemsSceneInteractor(fetcherProvider: fetcherProvider)
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
    }
}
