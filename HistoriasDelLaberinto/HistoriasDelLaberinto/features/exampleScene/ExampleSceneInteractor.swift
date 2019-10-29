protocol ExampleSceneBusinessLogic: BusinessLogic {
    func doSomething(request: ExampleSceneModels.Something.Request) -> ExampleSceneModels.Something.Response
    func dialogIsAvailable(request: ExampleSceneModels.DialogAvailable.Request) -> ExampleSceneModels.DialogAvailable.Response
    func deletedDb()
    func loadDb()
}

class ExampleSceneInteractor: BaseInteractor, ExampleSceneBusinessLogic {
    private let databaseFetcherProvider: DatabaseFetcherProvider
    
    init(databaseFetcherProvider: DatabaseFetcherProvider) {
        self.databaseFetcherProvider = databaseFetcherProvider
        super.init(localizedStringAccess: databaseFetcherProvider.localizedValueFetcher)
    }
    
    // MARK: Do something
    
    func doSomething(request: ExampleSceneModels.Something.Request) -> ExampleSceneModels.Something.Response {
        let worker = ExampleSceneWorker()
        let result = worker.doSomeWork(entry: request.input)
        
        return ExampleSceneModels.Something.Response(output: result)
    }
    
    func saveDb(request: ExampleSceneModels.DatabaseSaving.Request) {
        _ = databaseFetcherProvider.eventsFetcherManager.saveEvent(request.event)
    }
    
    func deletedDb() {
        databaseFetcherProvider.charactersFetcher.deleteAllCharacters()
        databaseFetcherProvider.eventsFetcherManager.deleteAll()
        databaseFetcherProvider.itemsFetcher.deleteAllItems()
        databaseFetcherProvider.movementFetcher.removeMovement()
        databaseFetcherProvider.roomsFetcher.deleteAllRooms()
    }
    
    func loadDb() {
        let protagonist = getProtagonist()
        let charactersFile = getCharacters()
        let roomsFile = getRooms()
        let itemsFile = getItems()
        let eventsFile = getEvents()
        
        save(protagonist, charactersFile, roomsFile, itemsFile, eventsFile)
    }
    
    private func save(_ protagonist: Protagonist, _ charactersFile: CharactersFile, _ roomsFile: RoomsFile, _ itemsFile: ItemsFile, _ eventsFile: EventsFile) {
        print("Characters are saved: \(saveCharacters(in: charactersFile, protagonist: protagonist, fetcher: databaseFetcherProvider.charactersFetcher))")
        print("Items are saved: \(saveItems(itemsFile, fetcher: databaseFetcherProvider.itemsFetcher))")
        print("Rooms are saved: \(saveRooms(roomsFile, fetcher: databaseFetcherProvider.roomsFetcher))")
        print("Events are saved: \(saveEvents(eventsFile, fetcher: databaseFetcherProvider.eventsFetcherManager))")
    }
    
    func getDb(request: ExampleSceneModels.DatabaseGetting.Request) -> ExampleSceneModels.DatabaseGetting.Response {
        let event = databaseFetcherProvider.eventsFetcherManager.getEvent(with: request.id)
        return ExampleSceneModels.DatabaseGetting.Response(event: event)
    }
}

extension ExampleSceneInteractor: IsEventAvailableCheckable {
    func dialogIsAvailable(request: ExampleSceneModels.DialogAvailable.Request) -> ExampleSceneModels.DialogAvailable.Response {
        guard checkEventAvailable(with: request.id, eventFetcher: databaseFetcherProvider.eventsFetcherManager) else {
            return .error(ExampleSceneModels.DialogAvailable.Response.Error(reason: "Event not available."))
        }
        return .ok
    }
}

extension ExampleSceneInteractor: EventHandlerInteractor {
    var fetcherProvider: DatabaseFetcherProvider {
        return databaseFetcherProvider
    }
}

extension ExampleSceneInteractor: ImageRemover {}
extension ExampleSceneInteractor: GameFilesLoader {}
extension ExampleSceneInteractor: FilesSaver {}
