protocol FilesSaver {
    func saveProtagonist(_ protagonist: Protagonist, fetcher: ProtagonistFetcher) -> Bool
    func saveCharacters(_ file: CharactersFile, fetcher: CharacterFetcher) -> Bool
    func saveItems(_ file: ItemsFile, fetcher: ItemFetcher) -> Bool
    func saveRooms(_ file: RoomsFile, fetcher: RoomFetcher) -> Bool
    func saveEvents(_ file: EventsFile, fetcher: EventFetcherManager) -> Bool
}

extension FilesSaver {
    func saveProtagonist(_ protagonist: Protagonist, fetcher: ProtagonistFetcher) -> Bool {
        return fetcher.saveProtagonist(for: protagonist)
    }
    
    func saveCharacters(_ file: CharactersFile, fetcher: CharacterFetcher) -> Bool {
        var bool = true
        
        for (id, character) in file.notPlayable {
            bool = bool && fetcher.saveCharacter(for: character, with: id)
        }
        
        for (id, character) in file.playable {
            bool = bool && fetcher.saveCharacter(for: character, with: id)
        }
        
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
}
