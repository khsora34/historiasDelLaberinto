import Foundation

protocol InitialSceneBusinessLogic: BusinessLogic {
    func loadAllFiles() -> InitialScene.LoadFiles.Response
    func deleteAllFiles()
}

class InitialSceneInteractor: InitialSceneBusinessLogic {
    func loadAllFiles() -> InitialScene.LoadFiles.Response {
        var result = ""
        
        result += "Protagonist is saved: \(saveProtagonist()) \n"
        result += "Characters are saved: \(saveCharacters()) \n"
        result += "Items are saved: \(saveItems()) \n"
        result += "Rooms are saved: \(saveRooms()) \n"
        result += "Events are saved: \(saveEvents())"
        
        return InitialScene.LoadFiles.Response(stringResponse: result)
    }
    
    func deleteAllFiles() {
        
    }
    
    private let eventsFetcher: EventsFetcherManager
    private let itemsFetcher: ItemsFetcher
    private let charactersFetcher: CharactersFetcher
    private let roomsFetcher: RoomsFetcher
    private let protagonistFetcher: ProtagonistFetcher
    var worker: InitialSceneWorker?
    
    init(eventsFetcher: EventsFetcherManager, itemsFetcher: ItemsFetcher, charactersFetcher: CharactersFetcher, roomsFetcher: RoomsFetcher, protagonistFetcher: ProtagonistFetcher) {
        self.eventsFetcher = eventsFetcher
        self.itemsFetcher = itemsFetcher
        self.charactersFetcher = charactersFetcher
        self.roomsFetcher = roomsFetcher
        self.protagonistFetcher = protagonistFetcher
    }
    
    private func saveProtagonist() -> Bool {
        guard let path = Bundle.main.path(forResource: "prota", ofType: "yml", inDirectory: "loadedGame"), let fileContent = try? String(contentsOfFile: path) else {
            return false
        }
        
        let parser = ProtagonistParser()
        guard let protagonist = parser.serialize(fileContent) else {
            return false
        }
        return protagonistFetcher.saveProtagonist(for: protagonist)
    }
    
    private func saveCharacters() -> Bool {
        guard let path = Bundle.main.path(forResource: "characters", ofType: "yml", inDirectory: "loadedGame"), let fileContent = try? String(contentsOfFile: path) else {
            return false
        }
        
        let parser = CharactersFileParser()
        guard let characters = parser.serialize(fileContent) else {
            return false
        }
        
        var bool = true
        
        for (id, character) in characters.notPlayable {
            bool = bool && charactersFetcher.saveCharacter(for: character, with: id)
        }
        
        for (id, character) in characters.playable {
            bool = bool && charactersFetcher.saveCharacter(for: character, with: id)
        }
        
        return bool
    }
    
    private func saveItems() -> Bool {
        guard let path = Bundle.main.path(forResource: "items", ofType: "yml", inDirectory: "loadedGame"), let fileContent = try? String(contentsOfFile: path) else {
            return false
        }
        
        let parser = ItemsFileParser()
        guard let items = parser.serialize(fileContent) else {
            return false
        }
        
        var bool = true
        
        for (id, item) in items.consumableItems {
            bool = bool && itemsFetcher.saveItem(for: item, with: id)
        }
        
        for (id, item) in items.keyItems {
            bool = bool && itemsFetcher.saveItem(for: item, with: id)
        }
        
        for (id, item) in items.weapons {
            bool = bool && itemsFetcher.saveItem(for: item, with: id)
        }
        
        return bool
    }
    
    private func saveRooms() -> Bool {
        guard let path = Bundle.main.path(forResource: "rooms", ofType: "yml", inDirectory: "loadedGame"), let fileContent = try? String(contentsOfFile: path) else {
            return false
        }
        
        let parser = RoomsFileParser()
        guard let rooms = parser.serialize(fileContent) else {
            return false
        }
        
        var bool = true
        
        for (id, room) in rooms.rooms {
            bool = bool && roomsFetcher.saveRoom(for: room, with: id)
        }
        
        return bool
    }
    
    private func saveEvents() -> Bool {
        guard let path = Bundle.main.path(forResource: "events", ofType: "yml", inDirectory: "loadedGame"), let fileContent = try? String(contentsOfFile: path) else {
            return false
        }
        
        let parser = EventParser()
        guard let events = parser.serialize(fileContent) else {
            return false
        }
        
        var bool = true
        
        for (id, event) in events.events {
            bool = bool && eventsFetcher.saveEvent(event, with: id)
        }
        
        return bool
    }
}
