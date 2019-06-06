import UIKit.UIApplication
import CoreData

protocol ChoiceEventFetcher {
    func getChoice(with id: String) -> ChoiceEvent?
    func saveChoice(_ choice: ChoiceEvent, with id: String) -> Bool
    func deleteAllChoices()
}

extension ChoiceEventFetcher {
    func getChoice(with id: String) -> ChoiceEvent? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<ChoiceEventDAO> = ChoiceEventDAO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
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
                    switch type {
                    case "item":
                        condition = .item(id: value)
                    case "partner":
                        condition = .partner(id: value)
                    case "roomVisited":
                        condition = .roomVisited(id: value)
                    case "roomNotVisited":
                        condition = .roomNotVisited(id: value)
                    default:
                        condition = nil
                    }
                }
                
                actions.append(Action(name: name, nextStep: actionManaged.nextStep, condition: condition))
            }
        }
        
        return ChoiceEvent(options: actions, shouldSetVisited: event?.shouldSetVisited)
    }
    
    func saveChoice(_ choice: ChoiceEvent, with id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard
            let choiceEntity =
            NSEntityDescription.entity(forEntityName: "ChoiceEventDAO", in: managedContext),
            let actionEntity = NSEntityDescription.entity(forEntityName: "ActionDAO", in: managedContext) else { return false }
        
        let loadingEvent = NSManagedObject(entity: choiceEntity, insertInto: managedContext)
        loadingEvent.setValue(id, forKey: "id")
        
        var managedActions: [NSManagedObject] = []
        
        for action in choice.options {
            let loadingAction = NSManagedObject(entity: actionEntity, insertInto: managedContext)
            loadingAction.setValue(action.name, forKey: "name")
            loadingAction.setValue(action.nextStep, forKey: "nextStep")
            if let condition = action.condition {
                switch condition {
                case .item(let next):
                    loadingAction.setValue("item", forKey: "conditionType")
                    loadingAction.setValue(next, forKey: "conditionValue")
                case .partner(let next):
                    loadingAction.setValue("partner", forKey: "conditionType")
                    loadingAction.setValue(next, forKey: "conditionValue")
                case .roomVisited(let value):
                    loadingAction.setValue("roomVisited", forKey: "conditionType")
                    loadingAction.setValue(value, forKey: "conditionValue")
                case .roomNotVisited(let value):
                    loadingAction.setValue("roomNotVisited", forKey: "conditionType")
                    loadingAction.setValue(value, forKey: "conditionValue")
                }
            }
            managedActions.append(loadingAction)
        }
        
        loadingEvent.setValue(NSOrderedSet(array: managedActions), forKey: "actionsAssociated")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteAllChoices() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
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
