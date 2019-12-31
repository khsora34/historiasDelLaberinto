import UIKit.UIApplication
import CoreData

protocol EventFetcher {
    var persistentContainer: NSPersistentContainer { get }
    func getEvent(_ id: String) -> EventDAO?
    func deleteAllEvents()
}

extension EventFetcher {
    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getEvent(_ id: String) -> EventDAO? {
        let fetchRequest: NSFetchRequest<EventDAO> = EventDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let results = try? managedContext.fetch(fetchRequest)
        return results?.first
    }
    
    func deleteAllEvents() {
        let fetchRequest: NSFetchRequest<EventDAO> = EventDAO.fetchRequest()
        
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
