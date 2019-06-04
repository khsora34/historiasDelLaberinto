protocol RoomSceneBusinessLogic: BusinessLogic {}

class RoomSceneInteractor: BaseInteractor, RoomSceneBusinessLogic {
    private let databaseFetcherProvider: DatabaseFetcherProvider
    init(databaseFetcherProvider: DatabaseFetcherProvider) {
        self.databaseFetcherProvider = databaseFetcherProvider
    }
}

extension RoomSceneInteractor: EventHandlerInteractor {
    var eventFetcher: EventFetcherManager {
        return databaseFetcherProvider.eventsFetcherManager
    }
    
    var characterFetcher: CharacterFetcher {
        return databaseFetcherProvider.charactersFetcher
    }
    
    var protagonistFetcher: ProtagonistFetcher {
        return databaseFetcherProvider.protagonistFetcher
    }
    
    var itemFetcher: ItemFetcher {
        return databaseFetcherProvider.itemsFetcher
    }
}
