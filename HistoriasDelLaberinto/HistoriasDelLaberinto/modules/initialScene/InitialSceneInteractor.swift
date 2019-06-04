import Foundation

protocol InitialSceneBusinessLogic: BusinessLogic {
    func loadAllFiles() -> InitialScene.LoadFiles.Response
    func deleteAllFiles()
    func getRoom(request: InitialScene.RoomBuilder.Request) -> InitialScene.RoomBuilder.Response
}

class InitialSceneInteractor: InitialSceneBusinessLogic {
    private let databaseFetcherProvider: DatabaseFetcherProvider
    
    init(databaseFetcherProvider: DatabaseFetcherProvider) {
        self.databaseFetcherProvider = databaseFetcherProvider
    }
    
    func loadAllFiles() -> InitialScene.LoadFiles.Response {
        var result = ""
        let now = Date().timeIntervalSinceReferenceDate
        print("😂 Start Uploading ")
        result += "Protagonist is saved: \(saveProtagonist(with: databaseFetcherProvider.protagonistFetcher)) \n"
        result += "Characters are saved: \(saveCharacters(with: databaseFetcherProvider.charactersFetcher)) \n"
        result += "Items are saved: \(saveItems(with: databaseFetcherProvider.itemsFetcher)) \n"
        result += "Rooms are saved: \(saveRooms(with: databaseFetcherProvider.roomsFetcher)) \n"
        result += "Events are saved: \(saveEvents(with: databaseFetcherProvider.eventsFetcherManager))"
        print("😂 Finished in \(Date().timeIntervalSinceReferenceDate - now)")
        
        return InitialScene.LoadFiles.Response(stringResponse: result)
    }
    
    func deleteAllFiles() {
        let now = Date().timeIntervalSinceReferenceDate
        print("😂 Start Deleting ")
        databaseFetcherProvider.eventsFetcherManager.deleteAll()
        databaseFetcherProvider.charactersFetcher.deleteAllCharacters()
        databaseFetcherProvider.itemsFetcher.deleteAllItems()
        databaseFetcherProvider.protagonistFetcher.deleteProtagonist()
        databaseFetcherProvider.roomsFetcher.deleteAllRooms()
        print("😂 Finished in \(Date().timeIntervalSinceReferenceDate - now)")
    }
    
    func getRoom(request: InitialScene.RoomBuilder.Request) -> InitialScene.RoomBuilder.Response {
        let room = databaseFetcherProvider.roomsFetcher.getRoom(with: request.roomId)
        return InitialScene.RoomBuilder.Response(room: room)
    }
}

extension InitialSceneInteractor: GameFilesLoader {}
