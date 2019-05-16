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
        guard let eventType = EventType(rawValue: dao.get(id: id)?.type ?? "") else { return nil }
        
        var loadedEvent: Event?
        switch eventType {
        case .dialogue:
            loadedEvent = getDialogueFromDao(id: id)
        default:
            fatalError()
        }
        
        return loadedEvent
    }
    
    func save(event: Event, with id: String) {
        guard dao.save(event: event, with: id), let type = EventType(event: event) else { return }
        switch type {
        case .dialogue:
            guard let event = event as? DialogueEvent else { return }
            save(dialogue: event, with: id)
        default:
            fatalError()
        }
    }
    
    private func getDialogueFromDao(id: String) -> DialogueEvent? {
        guard let dialogueDao = getDialogue(with: id) else { return nil }
        guard let characterId = dialogueDao.characterId, let message = dialogueDao.message else { return nil }
        return DialogueEvent(characterId: characterId, message: message, nextStep: dialogueDao.nextStep)
    }
}

extension EventsFetcherManagerImpl: DialogueDao {}
