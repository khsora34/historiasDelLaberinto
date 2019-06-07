class BattleSceneModule: Module {
    let storyboardName: String = "BattleScene"
    let controllerName: String = "BattleSceneViewController"
    var viewController: ViewControllerDisplay
    var interactor: BusinessLogic
    var presenter: Presenter
    var router: RouterLogic
    
    init(enemy: PlayableCharacter, routerProvider: RouterProvider, protagonistFetcher: ProtagonistFetcher, characterFetcher: CharacterFetcher) {
        viewController = ViewCreator.createFrom(storyboardName: storyboardName, forController: controllerName)
        presenter = BattleScenePresenter(enemy: enemy)
        router = routerProvider.voidRouter
        interactor = BattleSceneInteractor(protagonistFetcher: protagonistFetcher, characterFetcher: characterFetcher)
        viewController._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._viewController = viewController
    }
}
