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
        
        guard let conditionEvent = event, let nextTrueStep = conditionEvent.nextStepIfTrue, let nextFalseStep = conditionEvent.nextStepIfFalse, let type = conditionEvent.condition?.conditionType, let conditionString = ConditionString(rawValue: type) else { return nil }
        
        var condition: Condition
        switch conditionString {
        case .item:
            guard let value = conditionEvent.condition?.conditionValue else { return nil }
            condition = .item(id: value)
        case .partner:
            guard let value = conditionEvent.condition?.conditionValue else { return nil }
            condition = .partner(id: value)
        case .roomVisited:
            guard let value = conditionEvent.condition?.conditionValue else { return nil }
            condition = .roomVisited(id: value)
        case .roomNotVisited:
            guard let value = conditionEvent.condition?.conditionValue else { return nil }
            condition = .roomNotVisited(id: value)
        case .variable:
            guard let value = conditionEvent.condition?.variableCondition, let variableToCompareId = value.comparationVariableName, let relationString = value.relation, let relation = VariableRelation(rawValue: relationString) else { return nil }
            if let initialVariableName = value.initialVariableName {
                condition = .variable(ConditionVariable(variableToCompareId: variableToCompareId, relation: relation, initialVariableName: initialVariableName))
            } else if let variableValue = VariableValue(type: value.initialVariableType, value: value.initialVariableValue) {
                condition = .variable(ConditionVariable(variableToCompareId: variableToCompareId, relation: relation, initialVariable: variableValue))
            } else {
                return nil
            }
        }
        
        return ConditionEvent(id: id, condition: condition, shouldSetVisited: conditionEvent.shouldSetVisited, shouldEndGame: event?.shouldEndGame, nextStepIfTrue: nextTrueStep, nextStepIfFalse: nextFalseStep)
    }
    
    func saveCondition(_ condition: ConditionEvent) -> Bool {
        guard
            let conditionEventEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ConditionEventDAO)", in: managedContext),
            let conditionEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ConditionDAO)", in: managedContext),
            let variableConditionEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ConditionVariableDAO)", in: managedContext)
            else { return false }
        let loadingEvent = ConditionEventDAO(entity: conditionEventEntity, insertInto: managedContext)
        
        loadingEvent.id = condition.id
        loadingEvent.type = "\(DaoConstants.Event.condition)"
        loadingEvent.shouldSetVisited = condition.shouldSetVisited ?? false
        loadingEvent.shouldEndGame = condition.shouldEndGame ?? false
        loadingEvent.nextStepIfTrue = condition.nextStepIfTrue
        loadingEvent.nextStepIfFalse = condition.nextStepIfFalse
        
        let loadingCondition = ConditionDAO(entity: conditionEntity, insertInto: managedContext)
        switch condition.condition {
        case .item(let value):
            loadingCondition.conditionType = "\(ConditionString.item)"
            loadingCondition.conditionValue = value
        case .partner(let value):
            loadingCondition.conditionType = "\(ConditionString.partner)"
            loadingCondition.conditionValue = value
        case .roomVisited(let value):
            loadingCondition.conditionType = "\(ConditionString.roomVisited)"
            loadingCondition.conditionValue = value
        case .roomNotVisited(let value):
            loadingCondition.conditionType = "\(ConditionString.roomNotVisited)"
            loadingCondition.conditionValue = value
        case .variable(let variable):
            let loadingVariableCondition = ConditionVariableDAO(entity: variableConditionEntity, insertInto: managedContext)
            loadingVariableCondition.comparationVariableName = variable.comparationVariableName
            loadingVariableCondition.initialVariableName = variable.initialVariableName
            loadingVariableCondition.initialVariableType = variable.initialVariable?.type.rawValue
            loadingVariableCondition.initialVariableValue = variable.initialVariable?.value
            loadingVariableCondition.relation = variable.relation.rawValue
            
            loadingCondition.variableCondition = loadingVariableCondition
            loadingCondition.conditionType = "\(ConditionString.variable)"
        }
        
        loadingEvent.condition = loadingCondition
        
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
