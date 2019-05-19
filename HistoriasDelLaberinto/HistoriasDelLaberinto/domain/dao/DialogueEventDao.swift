import UIKit
import CoreData

protocol DialogueDao {
    func getDialogue(with id: String) -> DialogueEventDAO?
    func saveDialogue(_ dialogue: DialogueEvent, with id: String)
}

extension DialogueDao {
    func getDialogue(with id: String) -> DialogueEventDAO? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<DialogueEventDAO> = DialogueEventDAO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", NSString(string: id))
        fetchRequest.predicate = predicate
        
        do {
        let results = try managedContext.fetch(fetchRequest)
            return results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func saveDialogue(_ dialogue: DialogueEvent, with id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "DialogueEventDAO", in: managedContext) else { return }
        let loadingEvent = NSManagedObject(entity: entity, insertInto: managedContext)
        
        loadingEvent.setValue(dialogue.characterId, forKey: "characterId")
        loadingEvent.setValue(dialogue.message, forKey: "message")
        loadingEvent.setValue(dialogue.nextStep, forKey: "nextStep")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
    }
}
