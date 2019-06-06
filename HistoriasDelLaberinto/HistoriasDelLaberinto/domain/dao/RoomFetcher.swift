import UIKit.UIApplication
import CoreData

protocol RoomFetcher {
    func getRoom(with id: String) -> Room?
    func getAllRooms() -> [Room]
    func saveRoom(for room: Room, with id: String) -> Bool
    func deleteAllRooms()
}

class RoomFetcherImpl: RoomFetcher {
    func getRoom(with id: String) -> Room? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<RoomDAO> = RoomDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        var room: RoomDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            room = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let roomId = room?.id, let imageUrl = room?.imageUrl, let name = room?.name, let description = room?.descriptionString, let reloadWithPartner = room?.reloadWithPartner, let isGeneric = room?.isGenericRoom, let actionsSet = room?.actions else { return nil }
        
        var actions: [Action] = []
        
        for action in actionsSet {
            if let actionManaged = action as? ActionDAO, let name = actionManaged.name {
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
        
        return Room(id: roomId, name: name, description: description, imageUrl: imageUrl, reloadWithPartner: reloadWithPartner, isGenericRoom: isGeneric, actions: actions)
    }
    
    func getAllRooms() -> [Room] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<RoomDAO> = RoomDAO.fetchRequest()
        
        var rooms: [RoomDAO] = []
        do {
            rooms = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        var modeledRooms: [Room] = []
        
        for room in rooms {
            guard let roomId = room.id, let imageUrl = room.imageUrl, let name = room.name, let description = room.descriptionString, let actionsSet = room.actions else { continue }
            
            var actions: [Action] = []
            
            for action in actionsSet {
                if let actionManaged = action as? ActionDAO, let name = actionManaged.name {
                    var condition: Condition?
                    
                    if let type = actionManaged.conditionType, let value = actionManaged.conditionValue {
                        switch type {
                        case "item":
                            condition = .item(id: value)
                        case "partner":
                            condition = .partner(id: value)
                        case "roomVisited":
                            condition = .roomVisited(id: value)
                        default:
                            condition = nil
                        }
                    }
                    actions.append(Action(name: name, nextStep: actionManaged.nextStep, condition: condition))
                }
            }
            
            let modeledRoom = Room(id: roomId, name: name, description: description, imageUrl: imageUrl, reloadWithPartner: room.reloadWithPartner, isGenericRoom: room.isGenericRoom, actions: actions)
            modeledRooms.append(modeledRoom)
        }
        return modeledRooms
    }
    
    func saveRoom(for room: Room, with id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let roomEntity = NSEntityDescription.entity(forEntityName: "RoomDAO", in: managedContext),
            let actionEntity = NSEntityDescription.entity(forEntityName: "ActionDAO", in: managedContext) else { return false }
        let loadingRoom = NSManagedObject(entity: roomEntity, insertInto: managedContext)
        
        loadingRoom.setValue(id, forKey: "id")
        loadingRoom.setValue(room.name, forKey: "name")
        loadingRoom.setValue(room.description, forKey: "descriptionString")
        loadingRoom.setValue(room.imageUrl, forKey: "imageUrl")
        loadingRoom.setValue(room.isGenericRoom ?? false, forKey: "isGenericRoom")
        loadingRoom.setValue(room.reloadWithPartner, forKey: "reloadWithPartner")
        
        var managedActions: [NSManagedObject] = []
        
        for action in room.actions {
            let loadingAction = NSManagedObject(entity: actionEntity, insertInto: managedContext)
            loadingAction.setValue(action.name, forKey: "name")
            loadingAction.setValue(action.nextStep, forKey: "nextStep")
            if let condition = action.condition {
                switch condition {
                case .item(id: let next):
                    loadingAction.setValue("item", forKey: "conditionType")
                    loadingAction.setValue(next, forKey: "conditionValue")
                case .partner(id: let next):
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
        
        loadingRoom.setValue(NSSet(array: managedActions), forKey: "actions")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteAllRooms() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let roomFetchRequest: NSFetchRequest<RoomDAO> = RoomDAO.fetchRequest()
        
        do {
            let results = try managedContext.fetch(roomFetchRequest)
            for result in results {
                if let actions = result.actions {
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
