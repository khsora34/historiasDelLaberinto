import UIKit.UIApplication
import CoreData

protocol EventTypeFetcher {
    func getEventType(with id: String) -> EventDAO?
    func deleteAllEventTypes()
}

extension EventTypeFetcher {
    func getEventType(with id: String) -> EventDAO? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<EventDAO> = EventDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let results = try? managedContext.fetch(fetchRequest)
        return results?.first
    }
    
    func deleteAllEventTypes() {
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
