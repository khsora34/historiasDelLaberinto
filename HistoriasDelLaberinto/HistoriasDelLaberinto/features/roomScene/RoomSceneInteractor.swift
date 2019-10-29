protocol RoomSceneBusinessLogic: BusinessLogic {}

class RoomSceneInteractor: BaseInteractor, RoomSceneBusinessLogic {
    private let databaseFetcherProvider: DatabaseFetcherProvider
    init(databaseFetcherProvider: DatabaseFetcherProvider) {
        self.databaseFetcherProvider = databaseFetcherProvider
        super.init(localizedStringAccess: databaseFetcherProvider.localizedValueFetcher)
    }
}

extension RoomSceneInteractor: EventHandlerInteractor {
    var fetcherProvider: DatabaseFetcherProvider {
        return databaseFetcherProvider
    }
}
