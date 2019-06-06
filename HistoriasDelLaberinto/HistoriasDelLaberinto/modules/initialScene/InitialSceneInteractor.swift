import Foundation

protocol InitialSceneBusinessLogic: BusinessLogic {
    func loadAllFiles()
    func deleteAllFiles()
    func getRoom(request: InitialScene.RoomBuilder.Request) -> InitialScene.RoomBuilder.Response
}

class InitialSceneInteractor: InitialSceneBusinessLogic {
    private let databaseFetcherProvider: DatabaseFetcherProvider
    
    var stringUrlImages: [String] = []
    
    init(databaseFetcherProvider: DatabaseFetcherProvider) {
        self.databaseFetcherProvider = databaseFetcherProvider
    }
    
    func loadAllFiles() {
        let now = Date().timeIntervalSinceReferenceDate
        print("😂 Start Uploading ")
        parseFiles()
        print("😂 Finished in \(Date().timeIntervalSinceReferenceDate - now)")
    }
    
    private func parseFiles() {
        let protagonist = getProtagonist()
        let charactersFile = getCharacters()
        let roomsFile = getRooms()
        let itemsFile = getItems()
        let eventsFile = getEvents()
        
        loadImages(protagonist, charactersFile, roomsFile, itemsFile, eventsFile)
        save(protagonist, charactersFile, roomsFile, itemsFile, eventsFile)
    }
    
    private func loadImages(_ protagonist: Protagonist, _ charactersFile: CharactersFile, _ roomsFile: RoomsFile, _ itemsFile: ItemsFile, _ eventsFile: EventsFile) {
        var imageUrls: [String] = []
        imageUrls.append(protagonist.imageUrl)
        
        imageUrls.append(contentsOf: charactersFile.notPlayable.values.map({$0.imageUrl}))
        imageUrls.append(contentsOf: charactersFile.playable.values.map({$0.imageUrl}))
        
        imageUrls.append(contentsOf: roomsFile.rooms.values.map({$0.imageUrl}))
        
        imageUrls.append(contentsOf: itemsFile.consumableItems.values.map({$0.imageUrl}))
        imageUrls.append(contentsOf: itemsFile.keyItems.values.map({$0.imageUrl}))
        imageUrls.append(contentsOf: itemsFile.weapons.values.map({$0.imageUrl}))
    }
    
    private func save(_ protagonist: Protagonist, _ charactersFile: CharactersFile, _ roomsFile: RoomsFile, _ itemsFile: ItemsFile, _ eventsFile: EventsFile) {
        print("Protagonist is saved: \(saveProtagonist(protagonist, fetcher: databaseFetcherProvider.protagonistFetcher))")
        print("Characters are saved: \(saveCharacters(charactersFile, fetcher: databaseFetcherProvider.charactersFetcher))")
        print("Items are saved: \(saveItems(itemsFile, fetcher: databaseFetcherProvider.itemsFetcher))")
        print("Rooms are saved: \(saveRooms(roomsFile, fetcher: databaseFetcherProvider.roomsFetcher))")
        print("Events are saved: \(saveEvents(eventsFile, fetcher: databaseFetcherProvider.eventsFetcherManager))")
    }
    
    func deleteAllFiles() {
        let now = Date().timeIntervalSinceReferenceDate
        print("😂 Start Deleting ")
        databaseFetcherProvider.eventsFetcherManager.deleteAll()
        databaseFetcherProvider.charactersFetcher.deleteAllCharacters()
        databaseFetcherProvider.itemsFetcher.deleteAllItems()
        databaseFetcherProvider.protagonistFetcher.deleteProtagonist()
        databaseFetcherProvider.roomsFetcher.deleteAllRooms()
        databaseFetcherProvider.movementFetcher.removeMovement()
        print("😂 Finished in \(Date().timeIntervalSinceReferenceDate - now)")
    }
    
    func getRoom(request: InitialScene.RoomBuilder.Request) -> InitialScene.RoomBuilder.Response {
        let room = databaseFetcherProvider.roomsFetcher.getRoom(with: request.roomId)
        return InitialScene.RoomBuilder.Response(room: room)
    }
}

extension InitialSceneInteractor: GameFilesLoader {}
extension InitialSceneInteractor: FilesSaver {}
extension InitialSceneInteractor: ImageLoader {}
