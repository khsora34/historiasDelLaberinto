import UIKit

class Dependencies {
    var eventsFetcherManager: EventsFetcherManager!
    var moduleProvider: ModuleProvider!
    var itemsFetcher: ItemsFetcher!
    var charactersFetcher: CharactersFetcher!
    var roomsFetcher: RoomsFetcher!
    var protagonistFetcher: ProtagonistFetcher!
    
    lazy var routerProvider: RouterProvider = {
        guard let drawer = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else {
            fatalError("Can't find drawer.")
        }
        let routerProvider = RouterProvider(drawer: drawer, moduleProvider: moduleProvider)
        return routerProvider
    }()
    
    init() {
        eventsFetcherManager = createEventFetcher()
        itemsFetcher = createItemsFetcher()
        charactersFetcher = createCharactersFetcher()
        roomsFetcher = createRoomsFetcher()
        protagonistFetcher = createProtagonistFetcher()
        createModuleProvider()
    }
    
    private func createModuleProvider() {
        moduleProvider = ModuleProvider()
        moduleProvider.routerProvider = routerProvider
        moduleProvider.eventsFetcherManager = eventsFetcherManager
        moduleProvider.itemsFetcher = itemsFetcher
        moduleProvider.charactersFetcher = charactersFetcher
        moduleProvider.roomsFetcher = roomsFetcher
        moduleProvider.protagonistFetcher = protagonistFetcher
    }
    
    private func createEventFetcher() -> EventsFetcherManager {
        return EventsFetcherManagerImpl()
    }
    
    private func createItemsFetcher() -> ItemsFetcher {
        return ItemsFetcherImpl()
    }
    
    private func createCharactersFetcher() -> CharactersFetcher {
        return CharactersFetcherImpl()
    }
    
    private func createRoomsFetcher() -> RoomsFetcher {
        return RoomsFetcherImpl()
    }
    
    private func createProtagonistFetcher() -> ProtagonistFetcher {
        return ProtagonistFetcherImpl()
    }
}
