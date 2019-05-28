import UIKit.UIApplication
import CoreData

protocol ProtagonistFetcher {
    func getProtagonist() -> Protagonist?
    func saveProtagonist(for protagonist: Protagonist) -> Bool
    func deleteProtagonist()
}

extension ProtagonistFetcher {
    func getProtagonist() -> Protagonist? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<ProtagonistDAO> = ProtagonistDAO.fetchRequest()
        
        var protagonist: ProtagonistDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            protagonist = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let name = protagonist?.name, let partner = protagonist?.partner, let status = protagonist?.status else { return nil }
        
        return Protagonist(
            name: name, partner: partner,
            currentHealthPoints: Int(status.currentHealthPoints), maxHealthPoints: Int(status.maxHealthPoints), attack: Int(status.attack), defense: Int(status.defense), agility: Int(status.agility), currentStatusAilment: nil, weapon: status.weapon,
            items: getInventory(from: protagonist),
            visitedRooms: getVisitedRooms(from: protagonist))
    }
    
    private func getInventory(from prota: ProtagonistDAO?) -> [String: Int] {
        var dict: [String: Int] = [:]
        
        guard let inventory = prota?.inventory else { return dict }
        
        for item in inventory {
            if let item = item as? ObtainedItemsDAO, let id = item.id {
                dict[id] = Int(item.quantity)
            }
        }
        
        return dict
    }
    
    private func getVisitedRooms(from prota: ProtagonistDAO?) -> [String: VisitedRoom] {
        var visitedRooms: [String: VisitedRoom] = [:]
        
        guard let rooms = prota?.visitedRooms else { return visitedRooms }
        
        for room in rooms {
            if let room = room as? VisitedRoomDAO, let id = room.id {
                visitedRooms[id] = VisitedRoom(isVisited: room.isVisited, isVisitedWithPartner: room.isVisitedWithPartner)
            }
        }
        
        return visitedRooms
    }
    
    func saveProtagonist(for protagonist: Protagonist) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let protagonistEntity = NSEntityDescription.entity(forEntityName: "ProtagonistDAO", in: managedContext),
            let statusEntity = NSEntityDescription.entity(forEntityName: "StatusDAO", in: managedContext),
            let itemsEntity = NSEntityDescription.entity(forEntityName: "ObtainedItemsDAO", in: managedContext),
            let visitedRoomsEntity = NSEntityDescription.entity(forEntityName: "VisitedRoomDAO", in: managedContext) else { return false }
        let loadingProtagonist = NSManagedObject(entity: protagonistEntity, insertInto: managedContext)
        
        loadingProtagonist.setValue(protagonist.name, forKey: "name")
        loadingProtagonist.setValue(protagonist.partner, forKey: "partner")
        
        let loadingStatus = NSManagedObject(entity: statusEntity, insertInto: managedContext)
        loadingStatus.setValue(protagonist.currentHealthPoints, forKey: "currentHealthPoints")
        loadingStatus.setValue(protagonist.maxHealthPoints, forKey: "maxHealthPoints")
        loadingStatus.setValue(protagonist.attack, forKey: "attack")
        loadingStatus.setValue(protagonist.defense, forKey: "defense")
        loadingStatus.setValue(protagonist.agility, forKey: "agility")
        loadingStatus.setValue(protagonist.weapon, forKey: "weapon")
        
        loadingProtagonist.setValue(loadingStatus, forKey: "status")
        
        var managedItems: [NSManagedObject] = []
        
        for (key, value) in protagonist.items {
            let loadingItem = NSManagedObject(entity: itemsEntity, insertInto: managedContext)
            loadingItem.setValue(key, forKey: "id")
            loadingItem.setValue(value, forKey: "quantity")
            managedItems.append(loadingItem)
        }
        
        loadingProtagonist.setValue(NSOrderedSet(array: managedItems), forKey: "inventory")
        
        var managedVisitedRooms: [NSManagedObject] = []
        
        for (key, value) in protagonist.visitedRooms {
            let loadingVisitedRoom = NSManagedObject(entity: visitedRoomsEntity, insertInto: managedContext)
            loadingVisitedRoom.setValue(key, forKey: "id")
            loadingVisitedRoom.setValue(value.isVisited, forKey: "isVisited")
            loadingVisitedRoom.setValue(value.isVisitedWithPartner, forKey: "isVisitedWithPartner")
            managedVisitedRooms.append(loadingVisitedRoom)
        }
        
        loadingProtagonist.setValue(NSOrderedSet(array: managedVisitedRooms), forKey: "visitedRooms")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteProtagonist() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let roomFetchRequest: NSFetchRequest<ProtagonistDAO> = ProtagonistDAO.fetchRequest()
        
        do {
            let results = try managedContext.fetch(roomFetchRequest)
            for result in results {
                if let status = result.status {
                    managedContext.delete(status)
                }
                if let inventory = result.inventory {
                    for item in inventory {
                        if let item = item as? NSManagedObject {
                            managedContext.delete(item)
                        }
                    }
                }
                
                if let visitedRooms = result.visitedRooms {
                    for room in visitedRooms {
                        if let room = room as? NSManagedObject {
                            managedContext.delete(room)
                        }
                    }
                }
                managedContext.delete(result)
            }
            
            try managedContext.save()
            
        } catch {
            print(error)
        }
    }
}
