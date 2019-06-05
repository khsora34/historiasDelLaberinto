import UIKit.UIApplication
import CoreData

protocol MovementFetcher {
    func getMovement() -> Movement?
    func save() -> Bool
    func removeMovement()
}

class MovementFetcherImpl: MovementFetcher {
    func getMovement() -> Movement? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Movement> = Movement.fetchRequest()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func save() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                return true
            } catch let error as NSError {
                print("No ha sido posible guardar \(error), \(error.userInfo)")
                return false
            }
        }
        return true
    }
    
    func removeMovement() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let roomFetchRequest: NSFetchRequest<Movement> = Movement.fetchRequest()
        
        do {
            let results = try managedContext.fetch(roomFetchRequest)
            for result in results {
                if let visitedRooms = result.map {
                    for room in visitedRooms {
                        if let room = room as? NSManagedObject {
                            managedContext.delete(room)
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
