import Foundation

protocol InitialSceneBusinessLogic: BusinessLogic {
    func loadAllFiles() -> InitialScene.LoadFiles.Response
    func deleteAllFiles()
}

class InitialSceneInteractor: InitialSceneBusinessLogic {
    private let databaseFetcherProvider: DatabaseFetcherProvider
    
    init(databaseFetcherProvider: DatabaseFetcherProvider) {
        self.databaseFetcherProvider = databaseFetcherProvider
    }
    
    func loadAllFiles() -> InitialScene.LoadFiles.Response {
        var result = ""
        
        result += "Protagonist is saved: \(saveProtagonist(with: databaseFetcherProvider.protagonistFetcher)) \n"
        result += "Characters are saved: \(saveCharacters(with: databaseFetcherProvider.charactersFetcher)) \n"
        result += "Items are saved: \(saveItems(with: databaseFetcherProvider.itemsFetcher)) \n"
        result += "Rooms are saved: \(saveRooms(with: databaseFetcherProvider.roomsFetcher)) \n"
        result += "Events are saved: \(saveEvents(with: databaseFetcherProvider.eventsFetcherManager))"
        
        return InitialScene.LoadFiles.Response(stringResponse: result)
    }
    
    func deleteAllFiles() {
        
    }
}

extension InitialSceneInteractor: GameFilesLoader {}
