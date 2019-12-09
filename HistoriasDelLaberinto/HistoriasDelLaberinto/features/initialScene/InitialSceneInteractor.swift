import Foundation

protocol InitialSceneBusinessLogic: BusinessLogic {
    func loadAllFiles(request: InitialScene.FileLoader.Request)
    func deleteAllFiles()
    func getRoom(request: InitialScene.RoomBuilder.Request) -> InitialScene.RoomBuilder.Response
    func getMovement() -> InitialScene.MovementGetter.Response
    func createMovement()
    func updateTexts()
}

class InitialSceneInteractor: BaseInteractor, InitialSceneBusinessLogic {
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
        super.init(localizedStringAccess: databaseFetcherProvider.localizedValueFetcher)
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
        
        loadImages(protagonist, charactersFile, roomsFile, itemsFile)
        save(protagonist, charactersFile, roomsFile, itemsFile, getEvents())
        updateTexts()
    }
    
    private func loadImages(_ protagonist: Protagonist, _ charactersFile: CharactersFile, _ roomsFile: RoomsFile, _ itemsFile: ItemsFile) {
        print("😂 Starting to load images")
        var imageUrls: [ImageSource] = []
        imageUrls.append(protagonist.imageSource)
        imageUrls.append(contentsOf: charactersFile.notPlayable.values.map({$0.imageSource}))
        imageUrls.append(contentsOf: charactersFile.playable.values.map({$0.imageSource}))
        imageUrls.append(contentsOf: charactersFile.playable.values.map({$0.portraitSource}))
        
        imageUrls.append(contentsOf: roomsFile.rooms.values.map({$0.imageSource}))
        
        imageUrls.append(contentsOf: itemsFile.consumableItems.values.map({$0.imageSource}))
        imageUrls.append(contentsOf: itemsFile.keyItems.values.map({$0.imageSource}))
        imageUrls.append(contentsOf: itemsFile.weapons.values.map({$0.imageSource}))
        loadImages(from: imageUrls)
    }
    
    func updateTexts() {
        databaseFetcherProvider.localizedValueFetcher.deleteAllTexts()
        print("Texts are saved: \(saveTexts(getTexts(), fetcher: databaseFetcherProvider.localizedValueFetcher))")
        initLanguage()
    }
    
    private func initLanguage() {
        guard UserDefaults.standard.string(forKey: "loadedLanguageIdentifier") == nil else { return }
        
        let availableLanguages = databaseFetcherProvider.localizedValueFetcher.getAvailableLanguages().map({$0.identifier})
        let systemLanguages = Locale.preferredLanguages
        var choseLanguage: String?
        var i = 0
        while choseLanguage == nil && i < systemLanguages.count {
            if availableLanguages.contains(systemLanguages[i]) {
                choseLanguage = systemLanguages[i]
            }
            i+=1
        }
        choseLanguage = choseLanguage ?? systemLanguages.first
        
        UserDefaults.standard.set(choseLanguage ?? "en", forKey: "loadedLanguageIdentifier")
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
        databaseFetcherProvider.localizedValueFetcher.deleteAllTexts()
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
