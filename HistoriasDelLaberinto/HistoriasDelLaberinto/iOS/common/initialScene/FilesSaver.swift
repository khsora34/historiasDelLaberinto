protocol FilesSaver {
    func saveCharacters(in file: CharactersFile, protagonist: Protagonist, fetcher: CharacterFetcher) -> Bool
    func saveItems(_ file: ItemsFile, fetcher: ItemFetcher) -> Bool
    func saveRooms(_ file: RoomsFile, fetcher: RoomFetcher) -> Bool
    func saveEvents(_ file: EventsFile, fetcher: EventFetcherManager) -> Bool
}

extension FilesSaver {
    func saveCharacters(in file: CharactersFile, protagonist: Protagonist, fetcher: CharacterFetcher) -> Bool {
        var bool = true
        
        for (id, character) in file.notPlayable {
            bool = bool && fetcher.saveCharacter(for: character, with: id)
        }
        
        for (id, character) in file.playable {
            bool = bool && fetcher.saveCharacter(for: character, with: id)
        }
        
        bool = bool && fetcher.saveCharacter(for: protagonist, with: "protagonist")
        
        return bool
    }
    
    func saveItems(_ file: ItemsFile, fetcher: ItemFetcher) -> Bool {
        var bool = true
        
        for (id, item) in file.consumableItems {
            bool = bool && fetcher.saveItem(for: item, with: id)
        }
        
        for (id, item) in file.keyItems {
            bool = bool && fetcher.saveItem(for: item, with: id)
        }
        
        for (id, item) in file.weapons {
            bool = bool && fetcher.saveItem(for: item, with: id)
        }
        
        return bool
    }
    
    func saveRooms(_ file: RoomsFile, fetcher: RoomFetcher) -> Bool {
        var bool = true
        
        for (id, room) in file.rooms {
            bool = bool && fetcher.saveRoom(for: room, with: id)
        }
        
        return bool
    }
    
    func saveEvents(_ file: EventsFile, fetcher: EventFetcherManager) -> Bool {
        var bool = true
        
        for event in file.events {
            bool = bool && fetcher.saveEvent(event)
        }
        
        return bool
    }
    
    func saveTexts(_ texts: [String: [String: String]], fetcher: LocalizedValueFetcher) -> Bool {
        var bool = true
        
        for (key, value) in texts {
            for (literalKey, literalValue) in value {
                bool = bool && fetcher.saveString(key: literalKey, value: literalValue, forLanguage: key)
            }
        }
        
        return bool
    }
}
