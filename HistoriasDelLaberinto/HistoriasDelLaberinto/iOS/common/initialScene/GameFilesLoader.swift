import Foundation
protocol GameFilesLoader {
    func getProtagonist() -> Protagonist
    func getCharacters() -> CharactersFile
    func getItems() -> ItemsFile
    func getRooms() -> RoomsFile
    func getEvents() -> EventsFile
}

extension GameFilesLoader {
    func getProtagonist() -> Protagonist {
        guard let path = Bundle.main.path(forResource: "prota", ofType: "yml", inDirectory: "loadedGame"), let fileContent = try? String(contentsOfFile: path) else {
            fatalError()
        }
        
        let parser = ProtagonistParser()
        guard let protagonist = parser.serialize(fileContent) else {
            fatalError()
        }
        
        return protagonist
    }
    
    func getCharacters() -> CharactersFile {
        guard let path = Bundle.main.path(forResource: "characters", ofType: "yml", inDirectory: "loadedGame"), let fileContent = try? String(contentsOfFile: path) else {
            fatalError()
        }
        
        let parser = CharactersFileParser()
        guard let characters = parser.serialize(fileContent) else {
            fatalError()
        }
        
        return characters
    }
    
    func getItems() -> ItemsFile {
        guard let path = Bundle.main.path(forResource: "items", ofType: "yml", inDirectory: "loadedGame"), let fileContent = try? String(contentsOfFile: path) else {
            fatalError()
        }
        
        let parser = ItemsFileParser()
        guard let items = parser.serialize(fileContent) else {
            fatalError()
        }
        
        return items
    }
    
    func getRooms() -> RoomsFile {
        guard let path = Bundle.main.path(forResource: "rooms", ofType: "yml", inDirectory: "loadedGame"), let fileContent = try? String(contentsOfFile: path) else {
            fatalError()
        }
        
        let parser = RoomsFileParser()
        guard let rooms = parser.serialize(fileContent) else {
            fatalError()
        }
        
        return rooms
    }
    
    func getEvents() -> EventsFile {
        guard let path = Bundle.main.path(forResource: "events", ofType: "yml", inDirectory: "loadedGame"), let fileContent = try? String(contentsOfFile: path) else {
            fatalError()
        }
        
        let parser = EventParser()
        guard let events = parser.serialize(fileContent) else {
            fatalError()
        }
        
        return events
    }
}
