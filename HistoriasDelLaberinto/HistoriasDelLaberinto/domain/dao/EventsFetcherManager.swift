protocol EventsFetcherManager {
    func getEvent(with id: String) -> Event?
    func saveEvent(_ event: Event, with id: String) -> Bool
    func deleteAll()
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
        case .battle:
            loadedEvent = getBattle(with: id)
        case .condition:
            loadedEvent = getCondition(with: id)
        }
        
        return loadedEvent
    }
    
    func saveEvent(_ event: Event, with id: String) -> Bool {
        guard saveEventType(for: event, with: id), let type = EventType(event: event) else { return false }
        switch type {
        case .dialogue:
            guard let event = event as? DialogueEvent else { return false }
            return saveDialogue(event, with: id)
        case .choice:
            guard let event = event as? ChoiceEvent else { return false }
            return saveChoice(event, with: id)
        case .reward:
            guard let event = event as? RewardEvent else { return false }
            return saveReward(event, with: id)
        case .battle:
            guard let event = event as? BattleEvent else { return false }
            return saveBattle(event, with: id)
        case .condition:
            guard let event = event as? ConditionEvent else { return false }
            return saveCondition(event, with: id)
        }
    }
    
    func deleteAll() {
        deleteAllBattles()
        deleteAllChoices()
        deleteAllRewards()
        deleteAllDialogues()
        deleteAllConditions()
        deleteAllEventTypes()
    }
}

extension EventsFetcherManagerImpl: EventTypeFetcher {}
extension EventsFetcherManagerImpl: DialogueEventFetcher {}
extension EventsFetcherManagerImpl: ChoiceEventFetcher {}
extension EventsFetcherManagerImpl: RewardEventFetcher {}
extension EventsFetcherManagerImpl: ConditionEventFetcher {}
extension EventsFetcherManagerImpl: BattleEventFetcher {}
