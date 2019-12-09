import UIKit.UIApplication
import CoreData

protocol RoomFetcher {
    func getRoom(with id: String) -> Room?
    func getAllRooms() -> [Room]
    func saveRoom(for room: Room, with id: String) -> Bool
    func deleteAllRooms()
}

class RoomFetcherImpl: RoomFetcher {
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
    
    func getRoom(with id: String) -> Room? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<RoomDAO> = RoomDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Generic.id) == %@", id)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            return getRoom(fromDao: results.first)
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return nil
        }
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
            if let newRoom = getRoom(fromDao: room) {
                modeledRooms.append(newRoom)
            }
        }
        return modeledRooms
    }
    
    private func getRoom(fromDao dao: RoomDAO?) -> Room? {
        guard let roomId = dao?.id, let loadedImageType = dao?.imageSource?.type, let loadedImageSource = dao?.imageSource?.source, let name = dao?.name, let description = dao?.descriptionString, let actionsSet = dao?.actions else { return nil }
        
        var actions: [Action] = []
        
        for action in actionsSet.compactMap({$0 as? ActionDAO}) where action.name != nil {
            var condition: Condition?
            
            if let type = action.conditionType, let value = action.conditionValue {
                switch ConditionString(rawValue: type) {
                case .item:
                    condition = .item(id: value)
                case .partner:
                    condition = .partner(id: value)
                case .roomVisited:
                    condition = .roomVisited(id: value)
                case .roomNotVisited:
                    condition = .roomNotVisited(id: value)
                case nil:
                    condition = nil
                }
            }
            actions.append(Action(name: action.name!, nextStep: action.nextStep, condition: condition))
        }
        
        let imageSource: ImageSource
        if loadedImageType == "local" {
            imageSource = .local(loadedImageSource)
        } else if loadedImageType == "remote" {
            imageSource = .remote(loadedImageSource)
        } else {
            return nil
        }
        
        return Room(id: roomId, name: name, description: description, imageSource: imageSource, isGenericRoom: dao?.isGenericRoom, startEvent: dao?.startEvent, actions: actions)
    }
    
    func saveRoom(for room: Room, with id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let roomEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.RoomDAO)", in: managedContext),
            let actionEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ActionDAO)", in: managedContext),
            let imageEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ImageSourceDAO)", in: managedContext) else { return false }
        let loadingRoom = RoomDAO(entity: roomEntity, insertInto: managedContext)
        
        loadingRoom.id = id
        loadingRoom.name = room.name
        loadingRoom.descriptionString = room.description

        let imageSource = ImageSourceDAO(entity: imageEntity, insertInto: managedContext)
        imageSource.type = room.imageSource.name
        imageSource.source = room.imageSource.value
        loadingRoom.imageSource = imageSource

        loadingRoom.isGenericRoom = room.isGenericRoom ?? false
        loadingRoom.startEvent = room.startEvent
        
        var managedActions: [NSManagedObject] = []
        
        for action in room.actions {
            let loadingAction = ActionDAO(entity: actionEntity, insertInto: managedContext)
            loadingAction.name = action.name
            loadingAction.nextStep = action.nextStep
            if let condition = action.condition {
                switch condition {
                case .item(let value):
                    loadingAction.conditionType = ConditionString.item.rawValue
                    loadingAction.conditionValue = value
                case .partner(let value):
                    loadingAction.conditionType = ConditionString.partner.rawValue
                    loadingAction.conditionValue = value
                case .roomVisited(let value):
                    loadingAction.conditionType = ConditionString.roomVisited.rawValue
                    loadingAction.conditionValue = value
                case .roomNotVisited(let value):
                    loadingAction.conditionType = ConditionString.roomNotVisited.rawValue
                    loadingAction.conditionValue = value
                }
            }
            managedActions.append(loadingAction)
        }
        
        loadingRoom.actions = NSOrderedSet(array: managedActions)
        
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
