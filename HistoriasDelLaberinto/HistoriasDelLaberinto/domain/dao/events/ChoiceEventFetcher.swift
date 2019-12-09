import UIKit.UIApplication
import CoreData

protocol ChoiceEventFetcher {
    var persistentContainer: NSPersistentContainer { get }
    func getChoice(with id: String) -> ChoiceEvent?
    func saveChoice(_ choice: ChoiceEvent) -> Bool
    func deleteAllChoices()
}

extension ChoiceEventFetcher {
    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getChoice(with id: String) -> ChoiceEvent? {
        let fetchRequest: NSFetchRequest<ChoiceEventDAO> = ChoiceEventDAO.fetchRequest()
        let predicate = NSPredicate(format: "\(DaoConstants.Generic.id) == %@", id)
        fetchRequest.predicate = predicate
        
        var event: ChoiceEventDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            event = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let actionsSet = event?.actionsAssociated else { return nil }
        
        var actions: [Action] = []
        
        for element in actionsSet {
            if let actionManaged = element as? ActionDAO, let name = actionManaged.name {
                var condition: Condition?
                
                if let type = actionManaged.conditionType, let value = actionManaged.conditionValue {
                    switch ConditionString(rawValue: type) {
                    case .item:
                        condition = .item(id: value)
                    case .partner:
                        condition = .partner(id: value)
                    case .roomVisited:
                        condition = .roomVisited(id: value)
                    case .roomNotVisited:
                        condition = .roomNotVisited(id: value)
                    default:
                        condition = nil
                    }
                }
                
                actions.append(Action(name: name, nextStep: actionManaged.nextStep, condition: condition))
            }
        }
        
        return ChoiceEvent(id: id, options: actions, shouldSetVisited: event?.shouldSetVisited, shouldEndGame: event?.shouldEndGame)
    }
    
    func saveChoice(_ choice: ChoiceEvent) -> Bool {
        guard let choiceEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ChoiceEventDAO)", in: managedContext),
            let actionEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ActionDAO)", in: managedContext) else { return false }
        
        let loadingEvent = ChoiceEventDAO(entity: choiceEntity, insertInto: managedContext)
        loadingEvent.id = choice.id
        loadingEvent.type = "\(DaoConstants.Event.choice)"
        loadingEvent.shouldSetVisited = choice.shouldSetVisited ?? false
        loadingEvent.shouldEndGame = choice.shouldEndGame ?? false
        
        var managedActions: [NSManagedObject] = []
        
        for action in choice.options {
            let loadingAction = ActionDAO(entity: actionEntity, insertInto: managedContext)
            loadingAction.name = action.name
            loadingAction.nextStep = action.nextStep
            if let condition = action.condition {
                switch condition {
                case .item(let value):
                    loadingAction.conditionType = "\(ConditionString.item)"
                    loadingAction.conditionValue = value
                case .partner(let value):
                    loadingAction.conditionType = "\(ConditionString.partner)"
                    loadingAction.conditionValue = value
                case .roomVisited(let value):
                    loadingAction.conditionType = "\(ConditionString.roomVisited)"
                    loadingAction.conditionValue = value
                case .roomNotVisited(let value):
                    loadingAction.conditionType = "\(ConditionString.roomNotVisited)"
                    loadingAction.conditionValue = value
                }
            }
            managedActions.append(loadingAction)
        }
        
        loadingEvent.actionsAssociated = NSOrderedSet(array: managedActions)
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteAllChoices() {
        let eventFetchRequest: NSFetchRequest<ChoiceEventDAO> = ChoiceEventDAO.fetchRequest()
        
        do {
            let results = try managedContext.fetch(eventFetchRequest)
            for result in results {
                if let actions = result.actionsAssociated {
                    for action in actions {
                        if let action = action as? NSManagedObject {
                            managedContext.delete(action)
                        }
                    }
                }
                managedContext.delete(result)
            }
            
            if managedContext.hasChanges {
                try managedContext.save()
            }
            
        } catch {
            print(error)
        }
    }
}
