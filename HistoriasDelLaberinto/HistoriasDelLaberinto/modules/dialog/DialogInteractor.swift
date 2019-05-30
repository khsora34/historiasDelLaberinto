protocol DialogBusinessLogic: BusinessLogic {
    func getNextEvent(request: DialogModels.EventFetcher.Request) -> DialogModels.EventFetcher.Response
}

class DialogInteractor: DialogBusinessLogic {
    private let worker: DialogWorker
    private let databaseFetcherProvider: DatabaseFetcherProvider
    
    init(databaseFetcherProvider: DatabaseFetcherProvider) {
        self.databaseFetcherProvider = databaseFetcherProvider
        self.worker = DialogWorker()
    }
    
    func getNextEvent(request: DialogModels.EventFetcher.Request) -> DialogModels.EventFetcher.Response {
        let event = databaseFetcherProvider.eventsFetcherManager.getEvent(with: request.id)
        guard let safeEvent = event else {
            return .error(.eventNotFound)
        }
        
        let characterId = worker.getCharacterId(from: safeEvent)
        let character = databaseFetcherProvider.charactersFetcher.getCharacter(with: characterId ?? "")
        guard let safeCharacter = character else {
            return .error(.characterNotFound)
        }
        
        let message = worker.extractMessage(event: safeEvent)
        let output = DialogModels.EventFetcher.Response.OkOutput(characterName: safeCharacter.name, characterImageUrl: safeCharacter.imageUrl, message: message, nextStep: safeEvent.nextStep)
        return .success(output)
    }
}
