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
            loadedEvent = getDialogue(with: id)
        case .choice:
            loadedEvent = getChoice(with: id)
        case .reward:
            loadedEvent = getReward(with: id)
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
        case .reward:
            guard let event = event as? RewardEvent else { return }
            saveReward(event, with: id)
        default:
            fatalError()
        }
    }
}

extension EventsFetcherManagerImpl: EventTypeFetcher {}
extension EventsFetcherManagerImpl: DialogueEventFetcher {}
extension EventsFetcherManagerImpl: ChoiceEventFetcher {}
extension EventsFetcherManagerImpl: RewardEventFetcher {}
