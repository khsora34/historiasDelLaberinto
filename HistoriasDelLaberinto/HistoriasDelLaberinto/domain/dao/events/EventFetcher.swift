import UIKit.UIApplication
import CoreData

protocol EventFetcher {
    func getEvent(_ id: String) -> EventDAO?
    func deleteAllEvents()
}

extension EventFetcher {
    func getEvent(_ id: String) -> EventDAO? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<EventDAO> = EventDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let results = try? managedContext.fetch(fetchRequest)
        return results?.first
    }
    
    func deleteAllEvents() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
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
