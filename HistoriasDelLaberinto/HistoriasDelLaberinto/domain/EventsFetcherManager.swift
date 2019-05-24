protocol EventsFetcherManager {
    func getEvent(with id: String) -> Event?
    func saveEvent(_ event: Event, with id: String)
}

class EventsFetcherManagerImpl: EventsFetcherManager {
    
    func getEvent(with id: String) -> Event? {
        guard let eventType = EventType(rawValue: getEventType(with: id)?.type ?? "") else { return nil }
        
        var loadedEvent: Event?
        switch eventType {
        case .dialogue:
            loadedEvent = getDialogueFromDao(id: id)
        case .choice:
            loadedEvent = getChoice(with: id)
        default:
            fatalError()
        }
        
        return loadedEvent
    }
    
    func saveEvent(_ event: Event, with id: String) {
        guard saveEventType(for: event, with: id), let type = EventType(event: event) else { return }
        switch type {
        case .dialogue:
            guard let event = event as? DialogueEvent else { return }
            saveDialogue(event, with: id)
        case .choice:
            guard let event = event as? ChoiceEvent else { return }
            saveChoice(event, with: id)
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

extension EventsFetcherManagerImpl: EventTypeDao {}
extension EventsFetcherManagerImpl: DialogueDao {}
extension EventsFetcherManagerImpl: ChoiceEventDao {}
