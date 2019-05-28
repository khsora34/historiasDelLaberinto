class ModuleProvider {
    var routerProvider: RouterProvider!
    var eventsFetcherManager: EventsFetcherManager!
    var itemsFetcher: ItemsFetcher!
    var charactersFetcher: CharactersFetcher!
    var roomsFetcher: RoomsFetcher!
    var protagonistFetcher: ProtagonistFetcher!
    
    init() {}
    
    func exampleSceneModule() -> Module {
        return ExampleSceneModule(routerProvider: routerProvider, eventsFetcherManager: eventsFetcherManager)
    }
    
    func initialSceneModule() -> Module {
        return InitialSceneModule(routerProvider: routerProvider, eventsFetcher: eventsFetcherManager, itemsFetcher: itemsFetcher, charactersFetcher: charactersFetcher, roomsFetcher: roomsFetcher, protagonistFetcher: protagonistFetcher)
    }
}
