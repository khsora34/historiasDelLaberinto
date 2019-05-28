class InitialSceneModule: Module {
    let storyboardName: String = "InitialScene"
    let controllerName: String = "InitialSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic
    
    init(routerProvider: RouterProvider, eventsFetcher: EventsFetcherManager, itemsFetcher: ItemsFetcher, charactersFetcher: CharactersFetcher, roomsFetcher: RoomsFetcher, protagonistFetcher: ProtagonistFetcher) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        presenter = InitialScenePresenter()
        router = routerProvider.voidRouter
        interactor = InitialSceneInteractor(eventsFetcher: eventsFetcher, itemsFetcher: itemsFetcher, charactersFetcher: charactersFetcher, roomsFetcher: roomsFetcher, protagonistFetcher: protagonistFetcher)
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
        
    }
}
