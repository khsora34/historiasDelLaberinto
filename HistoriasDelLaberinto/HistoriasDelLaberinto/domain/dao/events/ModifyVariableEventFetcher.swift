import UIKit.UIApplication
import CoreData

protocol ModifyVariableEventFetcher {
    var persistentContainer: NSPersistentContainer { get }
    func getModifyVariable(from event: EventDAO) -> ModifyVariableEvent?
    func saveModifyVariable(_ event: ModifyVariableEvent) -> Bool
}

extension ModifyVariableEventFetcher {
    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getModifyVariable(from event: EventDAO) -> ModifyVariableEvent? {
        guard let event = event as? ModifyVariableEventDAO, let id = event.id, let operationString = event.operation, let operation = VariableOperation(rawValue: operationString), let variableId = event.variableId else { return nil }
        
        if let initialVariableName = event.initialVariableName {
            return ModifyVariableEvent(id: id, nextStep: event.nextStep, shouldSetVisited: event.shouldSetVisited, shouldEndGame: event.shouldEndGame, variableId: variableId, operation: operation, initialVariableName: initialVariableName)
        } else if let value = VariableValue(type: event.initialVariableType, value: event.initialVariableValue) {
            return ModifyVariableEvent(id: id, nextStep: event.nextStep, shouldSetVisited: event.shouldSetVisited, shouldEndGame: event.shouldEndGame, variableId: variableId, operation: operation, initialVariable: value)
        } else {
            return nil
        }
    }
    
    func saveModifyVariable(_ event: ModifyVariableEvent) -> Bool {
        guard let eventEntity = NSEntityDescription.entity(forEntityName: DaoConstants.ModelsNames.ModifyVariableEventDAO.rawValue, in: managedContext) else { return false }
        
        let loadingEvent = ModifyVariableEventDAO(entity: eventEntity, insertInto: managedContext)
        loadingEvent.id = event.id
        loadingEvent.type = DaoConstants.Event.modifyVariable.rawValue
        loadingEvent.shouldSetVisited = event.shouldSetVisited ?? false
        loadingEvent.shouldEndGame = event.shouldEndGame ?? false
        loadingEvent.nextStep = event.nextStep
        
        loadingEvent.operation = event.operation.rawValue
        loadingEvent.variableId = event.variableId
        loadingEvent.initialVariableType = event.initialVariable?.type.rawValue
        loadingEvent.initialVariableValue = event.initialVariable?.value
        loadingEvent.initialVariableName = event.initialVariableName
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteAllRewards() {
        let eventFetchRequest: NSFetchRequest<RewardEventDAO> = RewardEventDAO.fetchRequest()
        
        do {
            let results = try managedContext.fetch(eventFetchRequest)
            for result in results {
                if let rewards = result.rewardsAssociated {
                    for reward in rewards {
                        if let reward = reward as? NSManagedObject {
                            managedContext.delete(reward)
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
