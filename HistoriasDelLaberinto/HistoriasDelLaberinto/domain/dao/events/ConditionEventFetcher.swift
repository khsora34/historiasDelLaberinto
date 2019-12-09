import UIKit.UIApplication
import CoreData

protocol ConditionEventFetcher {
    var persistentContainer: NSPersistentContainer { get }
    func getCondition(with id: String) -> ConditionEvent?
    func saveCondition(_ condition: ConditionEvent) -> Bool
    func deleteAllConditions()
}

extension ConditionEventFetcher {
    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getCondition(with id: String) -> ConditionEvent? {
        let fetchRequest: NSFetchRequest<ConditionEventDAO> = ConditionEventDAO.fetchRequest()
        let predicate = NSPredicate(format: "\(DaoConstants.Generic.id) == %@", NSString(string: id))
        fetchRequest.predicate = predicate
        
        var event: ConditionEventDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            event = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let conditionEvent = event, let nextTrueStep = conditionEvent.nextStepIfTrue, let nextFalseStep = conditionEvent.nextStepIfFalse, let type = conditionEvent.conditionType, let value = conditionEvent.conditionValue, let conditionString = ConditionString(rawValue: type) else { return nil }
        
        var condition: Condition
        switch conditionString {
        case .item:
            condition = .item(id: value)
        case .partner:
            condition = .partner(id: value)
        case .roomVisited:
            condition = .roomVisited(id: value)
        case .roomNotVisited:
            condition = .roomNotVisited(id: value)
        }
        
        return ConditionEvent(id: id, condition: condition, shouldSetVisited: conditionEvent.shouldSetVisited, shouldEndGame: event?.shouldEndGame, nextStepIfTrue: nextTrueStep, nextStepIfFalse: nextFalseStep)
    }
    
    func saveCondition(_ condition: ConditionEvent) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "ConditionEventDAO", in: managedContext) else { return false }
        let loadingEvent = ConditionEventDAO(entity: entity, insertInto: managedContext)
        
        loadingEvent.id = condition.id
        loadingEvent.type = "\(DaoConstants.Event.condition)"
        loadingEvent.shouldSetVisited = condition.shouldSetVisited ?? false
        loadingEvent.shouldEndGame = condition.shouldEndGame ?? false
        loadingEvent.nextStepIfTrue = condition.nextStepIfTrue
        loadingEvent.nextStepIfFalse = condition.nextStepIfFalse
        
        switch condition.condition {
        case .item(let value):
            loadingEvent.conditionType = "\(ConditionString.item)"
            loadingEvent.conditionValue = value
        case .partner(let value):
            loadingEvent.conditionType = "\(ConditionString.partner)"
            loadingEvent.conditionValue = value
        case .roomVisited(let value):
            loadingEvent.conditionType = "\(ConditionString.roomVisited)"
            loadingEvent.conditionValue = value
        case .roomNotVisited(let value):
            loadingEvent.conditionType = "\(ConditionString.roomNotVisited)"
            loadingEvent.conditionValue = value
        }
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteAllConditions() {
        let fetchRequest: NSFetchRequest<ConditionEventDAO> = ConditionEventDAO.fetchRequest()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
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
