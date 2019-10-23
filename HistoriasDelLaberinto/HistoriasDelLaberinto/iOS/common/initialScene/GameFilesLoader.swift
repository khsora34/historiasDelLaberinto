import Foundation
protocol GameFilesLoader {
    func getProtagonist() -> Protagonist
    func getCharacters() -> CharactersFile
    func getItems() -> ItemsFile
    func getRooms() -> RoomsFile
    func getEvents() -> EventsFile
    func getTexts() -> [Locale: [String: String]]
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
    
    func getTexts() -> [Locale: [String: String]] {
        var texts: [Locale: [String: String]] = [:]
        let availableLanguagePaths: [String] = Bundle.main.paths(forResourcesOfType: "strings", inDirectory: "loadedGame/texts")
        for path in availableLanguagePaths {
            guard let langDictionary = NSDictionary(contentsOfFile: path), let literals = langDictionary as? [String: String]
                else {
                    print("Unable to load file in path \(path).")
                    continue
            }
            let startIndex: String.Index = path.index(path.endIndex, offsetBy: -10)
            let endIndex: String.Index = path.index(path.endIndex, offsetBy: -8)
            
            let languageCode: String = String(path[startIndex..<endIndex])
            texts[Locale(identifier: languageCode)] = literals
        }
        return texts
    }
}
