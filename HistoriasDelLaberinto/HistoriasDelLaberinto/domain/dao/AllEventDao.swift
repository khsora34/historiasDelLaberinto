import UIKit
import CoreData

protocol AllEventDao {
    func get(id: String) -> EventDAO?
    func save(event: EventDAO) -> Bool
}

class AllEventDaoImpl: AllEventDao {
    func get(id: String) -> EventDAO? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<EventDAO> = EventDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let results = try? managedContext.fetch(fetchRequest)
        return results?.first
    }
    
    func save(event: EventDAO) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "EventDAO", in: managedContext) else { return false }
        let loadingEvent = NSManagedObject(entity: entity, insertInto: managedContext)
        
        loadingEvent.setValue(event.type, forKey: "type")
        loadingEvent.setValue(event.id, forKey: "id")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
}
