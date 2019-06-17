protocol ItemsSceneBusinessLogic: BusinessLogic {
    func getItem(request: ItemsScene.ItemGetter.Request) -> ItemsScene.ItemGetter.Response
}

class ItemsSceneInteractor: BaseInteractor, ItemsSceneBusinessLogic {
    private let itemFetcher: ItemFetcher
    
    init(itemFetcher: ItemFetcher) {
        self.itemFetcher = itemFetcher
    }
    
    func getItem(request: ItemsScene.ItemGetter.Request) -> ItemsScene.ItemGetter.Response {
        let item = itemFetcher.getItem(with: request.itemId)
        return ItemsScene.ItemGetter.Response(item: item)
    }
}
