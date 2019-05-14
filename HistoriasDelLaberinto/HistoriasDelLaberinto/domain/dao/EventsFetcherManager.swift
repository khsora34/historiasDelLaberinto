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
        
        return loadedEvent
    }
    
    func save(event: Event, with id: String) {
        let daoEvent = EventDAO()
        daoEvent.id = id
        let eventType = EventType(event: event)?.rawValue
        daoEvent.type = eventType
        guard dao.save(event: daoEvent) else { return }
    }
}
