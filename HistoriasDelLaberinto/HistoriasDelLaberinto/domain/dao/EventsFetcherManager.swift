protocol EventsFetcherManager {
    func getEvent(with id: String) -> Event?
    func save(event: Event, with id: String)
}

class EventsFetcherManagerImpl: EventsFetcherManager {
    let dao: AllEventDao
    
    init(dao: AllEventDao) {
        self.dao = dao
    }
    
    func getEvent(with id: String) -> Event? {
        guard let event = dao.get(id: id), let eventType = EventType(rawValue: event.type ?? "") else { return nil }
        
        var loadedEvent: Event?
        if eventType == .dialogue {
            loadedEvent = DialogueEvent(characterId: "SI", message: "Me da igual", nextStep: "Me parece bien")
        }
        
        return loadedEvent
    }
    
    func save(event: Event, with id: String) {
        guard dao.save(event: event, with: id) else { return }
    }
}
