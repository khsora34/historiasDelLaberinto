protocol ExampleSceneBusinessLogic: BusinessLogic {
    func doSomething(request: ExampleSceneModels.Something.Request) -> ExampleSceneModels.Something.Response
    func dialogIsAvailable(request: ExampleSceneModels.DialogAvailable.Request) -> ExampleSceneModels.DialogAvailable.Response
}

class ExampleSceneInteractor: ExampleSceneBusinessLogic {
    private let databaseFetcherProvider: DatabaseFetcherProvider
    
    init(databaseFetcherProvider: DatabaseFetcherProvider) {
        self.databaseFetcherProvider = databaseFetcherProvider
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
