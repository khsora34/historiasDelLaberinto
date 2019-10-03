import Foundation

protocol InitialSceneBusinessLogic: BusinessLogic {
    func loadAllFiles(request: InitialScene.FileLoader.Request)
    func deleteAllFiles()
    func getRoom(request: InitialScene.RoomBuilder.Request) -> InitialScene.RoomBuilder.Response
    func getMovement() -> InitialScene.MovementGetter.Response
    func createMovement()
}

class InitialSceneInteractor: InitialSceneBusinessLogic {
    private let databaseFetcherProvider: DatabaseFetcherProvider
    
    var operations: [Int: ImageLoadingOperation] = [:] {
        didSet {
            if operations.values.count == 0 {
                print("😂 Finished loading images")
                delegate?.finishedLoadingImages(numberOfImagesLoaded: successfulOperations)
            }
        }
    }
    
    var successfulOperations: Int = 0
    weak var delegate: ImageLoaderDelegate?
    
    init(databaseFetcherProvider: DatabaseFetcherProvider) {
        self.databaseFetcherProvider = databaseFetcherProvider
    }
    
    func loadAllFiles(request: InitialScene.FileLoader.Request) {
        let now = Date().timeIntervalSinceReferenceDate
        print("😂 Start Uploading ")
        delegate = request.imageDelegate
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
        print("😂 Starting to load images")
        var imageUrls: [String] = []
        imageUrls.append(protagonist.imageUrl)
        
        imageUrls.append(contentsOf: charactersFile.notPlayable.values.map({$0.imageUrl}))
        imageUrls.append(contentsOf: charactersFile.playable.values.map({$0.imageUrl}))
        imageUrls.append(contentsOf: charactersFile.playable.values.compactMap({$0.portraitUrl}))
        
        imageUrls.append(contentsOf: roomsFile.rooms.values.map({$0.imageUrl}))
        
        imageUrls.append(contentsOf: itemsFile.consumableItems.values.map({$0.imageUrl}))
        imageUrls.append(contentsOf: itemsFile.keyItems.values.map({$0.imageUrl}))
        imageUrls.append(contentsOf: itemsFile.weapons.values.map({$0.imageUrl}))
        loadImages(from: imageUrls)
    }
    
    private func save(_ protagonist: Protagonist, _ charactersFile: CharactersFile, _ roomsFile: RoomsFile, _ itemsFile: ItemsFile, _ eventsFile: EventsFile) {
        print("Characters are saved: \(saveCharacters(in: charactersFile, protagonist: protagonist, fetcher: databaseFetcherProvider.charactersFetcher))")
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
        databaseFetcherProvider.roomsFetcher.deleteAllRooms()
        databaseFetcherProvider.movementFetcher.removeMovement()
        removeImageCache()
        print("😂 Finished in \(Date().timeIntervalSinceReferenceDate - now)")
    }
    
    func getMovement() -> InitialScene.MovementGetter.Response {
        let movement = databaseFetcherProvider.movementFetcher.getMovement()
        return InitialScene.MovementGetter.Response(movement: movement)
    }
    
    func getRoom(request: InitialScene.RoomBuilder.Request) -> InitialScene.RoomBuilder.Response {
        let room = databaseFetcherProvider.roomsFetcher.getRoom(with: request.roomId)
        return InitialScene.RoomBuilder.Response(room: room)
    }
    
    func createMovement() {
        _ = databaseFetcherProvider.movementFetcher.createMovement()
    }
}

extension InitialSceneInteractor: GameFilesLoader {}
extension InitialSceneInteractor: FilesSaver {}
extension InitialSceneInteractor: ImageLoader {}
