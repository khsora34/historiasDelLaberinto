import UIKit.UIApplication
import CoreData

protocol EventTypeFetcher {
    func getEventType(with id: String) -> EventDAO?
    func saveEventType(for event: Event, with id: String) -> Bool
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
    
    func saveEventType(for event: Event, with id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "EventDAO", in: managedContext) else { return false }
        let loadingEvent = NSManagedObject(entity: entity, insertInto: managedContext)
        
        guard let eventType = EventType(event: event) else { return false }
        
        loadingEvent.setValue(eventType.rawValue, forKey: "type")
        loadingEvent.setValue(id, forKey: "id")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
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
            
            try managedContext.save()
            
        } catch {
            print(error)
        }
    }
}
