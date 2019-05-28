import UIKit.UIApplication
import CoreData

protocol ConditionEventFetcher {
    func getCondition(with id: String) -> ConditionEvent?
    func saveCondition(_ condition: ConditionEvent, with id: String)
    func deleteAllConditions()
}

extension ConditionEventFetcher {
    func getCondition(with id: String) -> ConditionEvent? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<ConditionEventDAO> = ConditionEventDAO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", NSString(string: id))
        fetchRequest.predicate = predicate
        
        var event: ConditionEventDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            event = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let conditionEvent = event, let nextTrueStep = conditionEvent.nextStepIfTrue, let nextFalseStep = conditionEvent.nextStepIfFalse, let type = conditionEvent.type, let value = conditionEvent.value else { return nil }
        
        var condition: Condition?
        switch type {
        case "item":
            condition = .item(id: value)
        case "partner":
            condition = .partner(id: value)
        default:
            condition = nil
        }
        
        guard let safeCondition = condition else { return nil }
        
        return ConditionEvent(condition: safeCondition, nextStepIfTrue: nextTrueStep, nextStepIfFalse: nextFalseStep)
    }
    
    func saveCondition(_ condition: ConditionEvent, with id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "ConditionEventDAO", in: managedContext) else { return }
        let loadingEvent = NSManagedObject(entity: entity, insertInto: managedContext)
        
        loadingEvent.setValue(id, forKey: "id")
        loadingEvent.setValue(condition.nextStepIfTrue, forKey: "nextStepIfTrue")
        loadingEvent.setValue(condition.nextStepIfFalse, forKey: "nextStepIfFalse")
        
            switch condition.condition {
            case .item(id: let value):
                loadingEvent.setValue("item", forKey: "conditionType")
                loadingEvent.setValue(value, forKey: "conditionValue")
            case .partner(id: let value):
                loadingEvent.setValue("partner", forKey: "conditionType")
                loadingEvent.setValue(value, forKey: "conditionValue")
            }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllConditions() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<ConditionEventDAO> = ConditionEventDAO.fetchRequest()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
                managedContext.delete(result)
            }
            
            try managedContext.save()
            
        } catch {
            print(error)
        }
    }
}
