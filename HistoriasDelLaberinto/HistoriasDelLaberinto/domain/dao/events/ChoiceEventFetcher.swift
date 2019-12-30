import UIKit.UIApplication
import CoreData

protocol ChoiceEventFetcher {
    var persistentContainer: NSPersistentContainer { get }
    func getChoice(from event: EventDAO) -> ChoiceEvent?
    func saveChoice(_ choice: ChoiceEvent) -> Bool
}

extension ChoiceEventFetcher {
    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func getChoice(from event: EventDAO) -> ChoiceEvent? {
        guard let event = event as? ChoiceEventDAO,
            let id = event.id,
            let actionsSet = event.actionsAssociated else { return nil }

        var actions: [Action] = []
        for element in actionsSet {
            if let actionManaged = element as? ActionDAO, let name = actionManaged.name {
                var condition: Condition?

                if let type = actionManaged.condition?.conditionType, let value = actionManaged.condition?.conditionValue {
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

        return ChoiceEvent(id: id, options: actions, shouldSetVisited: event.shouldSetVisited, shouldEndGame: event.shouldEndGame)
    }

    func saveChoice(_ choice: ChoiceEvent) -> Bool {
        guard let choiceEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ChoiceEventDAO)", in: managedContext),
            let actionEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ActionDAO)", in: managedContext),
            let conditionEntity = NSEntityDescription.entity(forEntityName: "ConditionDAO", in: managedContext),
            let conditionVariableEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ConditionVariableDAO)", in: managedContext) else { return false }
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
                let loadingCondition: ConditionDAO = ConditionDAO(entity: conditionEntity, insertInto: managedContext)
                switch condition {
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
                    loadingCondition.conditionType = "\(ConditionString.variable)"
                    loadingCondition.variableCondition = loadVariable(variable, for: ConditionVariableDAO(entity: conditionVariableEntity, insertInto: managedContext))
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

    private func loadVariable(_ variable: ConditionVariable, for daoObject: ConditionVariableDAO) -> ConditionVariableDAO {
        daoObject.comparationVariableName = variable.comparationVariableName
        daoObject.relation = "\(variable.relation)"
        if let initialVariableName = variable.initialVariableName {
            daoObject.initialVariableName = initialVariableName
        } else if let initialVariable = variable.initialVariable {
            daoObject.initialVariableType = initialVariable.type.rawValue
            daoObject.initialVariableValue = initialVariable.value
        }
        return daoObject
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
