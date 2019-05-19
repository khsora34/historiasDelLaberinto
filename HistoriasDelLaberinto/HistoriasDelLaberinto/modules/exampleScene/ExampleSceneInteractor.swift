protocol ExampleSceneBusinessLogic: BusinessLogic {
    func doSomething(request: ExampleSceneModels.Something.Request) -> ExampleSceneModels.Something.Response
    
}

class ExampleSceneInteractor: ExampleSceneBusinessLogic {
    private let eventsFetcherManager: EventsFetcherManager
    
    init(eventsFetcherManager: EventsFetcherManager) {
        self.eventsFetcherManager = eventsFetcherManager
    }
    
    // MARK: Do something
    
    func doSomething(request: ExampleSceneModels.Something.Request) -> ExampleSceneModels.Something.Response {
        let worker = ExampleScenePerformer()
        let result = worker.doSomeWork(entry: request.input)
        
        return ExampleSceneModels.Something.Response(output: result)
    }
    
    func saveDb(request: ExampleSceneModels.DatabaseSaving.Request) {
        eventsFetcherManager.saveEvent(request.event, with: request.id)
    }
    
    func getDb(request: ExampleSceneModels.DatabaseGetting.Request) -> ExampleSceneModels.DatabaseGetting.Response {
        let event = eventsFetcherManager.getEvent(with: request.id)
        return ExampleSceneModels.DatabaseGetting.Response(event: event)
    }
}
