import Foundation
protocol GameFilesLoader {
    func saveProtagonist(with protagonistFetcher: ProtagonistFetcher) -> Bool
    func saveCharacters(with charactersFetcher: CharactersFetcher) -> Bool
    func saveItems(with itemsFetcher: ItemsFetcher) -> Bool
    func saveRooms(with roomsFetcher: RoomsFetcher) -> Bool
    func saveEvents(with eventsFetcher: EventsFetcherManager) -> Bool
}

extension GameFilesLoader {
    func saveProtagonist(with protagonistFetcher: ProtagonistFetcher) -> Bool {
        guard let path = Bundle.main.path(forResource: "prota", ofType: "yml", inDirectory: "loadedGame"), let fileContent = try? String(contentsOfFile: path) else {
            return false
        }
        
        let parser = ProtagonistParser()
        guard let protagonist = parser.serialize(fileContent) else {
            return false
        }
        return protagonistFetcher.saveProtagonist(for: protagonist)
    }
    
    func saveCharacters(with charactersFetcher: CharactersFetcher) -> Bool {
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
    
    func saveItems(with itemsFetcher: ItemsFetcher) -> Bool {
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
    
    func saveRooms(with roomsFetcher: RoomsFetcher) -> Bool {
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
    
    func saveEvents(with eventsFetcher: EventsFetcherManager) -> Bool {
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
