protocol ItemsSceneBusinessLogic: BusinessLogic {
    func getItem(request: ItemsScene.ItemGetter.Request) -> ItemsScene.ItemGetter.Response
    func updateProtagonist(request: PauseMenuScene.ProtagonistUpdater.Request)
    func updateCharacter(request: PauseMenuScene.CharacterUpdater.Request)
}

class ItemsSceneInteractor: BaseInteractor, ItemsSceneBusinessLogic {
    private let itemFetcher: ItemFetcher
    private let characterFetcher: CharacterFetcher
    
    init(fetcherProvider: DatabaseFetcherProvider) {
        self.itemFetcher = fetcherProvider.itemsFetcher
        self.characterFetcher = fetcherProvider.charactersFetcher
    }
    
    func getItem(request: ItemsScene.ItemGetter.Request) -> ItemsScene.ItemGetter.Response {
        let item = itemFetcher.getItem(with: request.itemId)
        return ItemsScene.ItemGetter.Response(item: item)
    }
    
    func updateProtagonist(request: PauseMenuScene.ProtagonistUpdater.Request) {
        guard let protagonist = request.protagonist as? Protagonist else { return }
        _ = characterFetcher.saveCharacter(for: protagonist, with: "protagonist")
    }
    
    func updateCharacter(request: PauseMenuScene.CharacterUpdater.Request) {
        guard let partner = request.partner, let partnerId = request.partnerId else {
            return
        }
        _ = characterFetcher.saveCharacter(for: partner, with: partnerId)
    }
}
