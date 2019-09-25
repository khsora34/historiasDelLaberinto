protocol EventFetcherManager {
    func getEvent(with id: String) -> Event?
    func saveEvent(_ event: Event) -> Bool
    func deleteAll()
}

class EventFetcherManagerImpl: EventFetcherManager {
    
    func getEvent(with id: String) -> Event? {
        guard let newEvent = getEvent(id), let type = newEvent.type, let eventType = EventType(rawValue: type) else { return nil }
        
        var loadedEvent: Event?
        switch eventType {
        case .dialogue:
            loadedEvent = getDialogue(from: newEvent)
        case .choice:
            loadedEvent = getChoice(with: id)
        case .reward:
            loadedEvent = getReward(with: id)
        case .battle:
            loadedEvent = getBattle(with: id)
        case .condition:
            loadedEvent = getCondition(with: id)
        case .unknown:
            return nil
        }
        
        return loadedEvent
    }
    
    func saveEvent(_ event: Event) -> Bool {
        switch EventType(event: event) {
        case .dialogue:
            guard let event = event as? DialogueEvent else { return false }
            return saveDialogue(event)
        case .choice:
            guard let event = event as? ChoiceEvent else { return false }
            return saveChoice(event)
        case .reward:
            guard let event = event as? RewardEvent else { return false }
            return saveReward(event)
        case .battle:
            guard let event = event as? BattleEvent else { return false }
            return saveBattle(event)
        case .condition:
            guard let event = event as? ConditionEvent else { return false }
            return saveCondition(event)
        case .unknown:
            print("Unable to find the type of the event \(event.id)")
            return false
        }
    }
    
    func deleteAll() {
        deleteAllBattles()
        deleteAllChoices()
        deleteAllRewards()
        deleteAllConditions()
        deleteAllEventTypes()
    }
}

extension EventFetcherManagerImpl: EventFetcher {}
extension EventFetcherManagerImpl: DialogueDaoParser {}
extension EventFetcherManagerImpl: ChoiceEventFetcher {}
extension EventFetcherManagerImpl: RewardEventFetcher {}
extension EventFetcherManagerImpl: ConditionEventFetcher {}
extension EventFetcherManagerImpl: BattleEventFetcher {}
