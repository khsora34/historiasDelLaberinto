import CoreData
import UIKit.UIApplication

protocol EventFetcherManager {
    func getEvent(with id: String) -> Event?
    func saveEvent(_ event: Event) -> Bool
    func deleteAll()
}

class EventFetcherManagerImpl: EventFetcherManager {
    let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to retrieve shared app delegate.")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    func getEvent(with id: String) -> Event? {
        guard let newEvent = getEvent(id), let type = newEvent.type, let eventType = EventType(rawValue: type) else { return nil }
        
        var loadedEvent: Event?
        switch eventType {
        case .dialogue:
            loadedEvent = getDialogue(from: newEvent)
        case .choice:
            loadedEvent = getChoice(from: newEvent)
        case .reward:
            loadedEvent = getReward(from: newEvent)
        case .battle:
            loadedEvent = getBattle(from: newEvent)
        case .condition:
            loadedEvent = getCondition(from: newEvent)
        case .modifyVariable:
            loadedEvent = getModifyVariable(from: newEvent)
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
        case .modifyVariable:
            guard let event = event as? ModifyVariableEvent else { return false }
            return saveModifyVariable(event)
        case .unknown:
            print("Unable to find the type of the event \(event.id)")
            return false
        }
    }
    
    func deleteAll() {
        deleteAllEvents()
    }
}

extension EventFetcherManagerImpl: EventFetcher {}
extension EventFetcherManagerImpl: DialogueEventFetcher {}
extension EventFetcherManagerImpl: ChoiceEventFetcher {}
extension EventFetcherManagerImpl: RewardEventFetcher {}
extension EventFetcherManagerImpl: ConditionEventFetcher {}
extension EventFetcherManagerImpl: BattleEventFetcher {}
extension EventFetcherManagerImpl: ModifyVariableEventFetcher {}
