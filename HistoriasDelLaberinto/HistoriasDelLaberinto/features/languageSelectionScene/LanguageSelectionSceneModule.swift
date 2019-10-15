class LanguageSelectionSceneModule: Module {
    let storyboardName: String = "LanguageSelectionScene"
    let controllerName: String = "LanguageSelectionSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic
    
    init(routerProvider: RouterProvider, databaseFetcher: DatabaseFetcherProvider) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        presenter = LanguageSelectionScenePresenter(availableLanguages: [])
        router = routerProvider.voidRouter
        interactor = LanguageSelectionSceneInteractor(localizedStringAccess: databaseFetcher.localizedValueFetcher)
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
    }
}
