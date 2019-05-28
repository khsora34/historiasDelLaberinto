import UIKit.UIApplication
import CoreData

protocol DialogueEventFetcher {
    func getDialogue(with id: String) -> DialogueEvent?
    func saveDialogue(_ dialogue: DialogueEvent, with id: String)
    func deleteAllDialogues()
}

extension DialogueEventFetcher {
    func getDialogue(with id: String) -> DialogueEvent? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<DialogueEventDAO> = DialogueEventDAO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", NSString(string: id))
        fetchRequest.predicate = predicate
        
        var event: DialogueEventDAO?
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            event = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let characterId = event?.characterId, let message = event?.message else { return nil }
        
        return DialogueEvent(characterId: characterId, message: message, nextStep: event?.nextStep)
    }
    
    func saveDialogue(_ dialogue: DialogueEvent, with id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "DialogueEventDAO", in: managedContext) else { return }
        let loadingEvent = NSManagedObject(entity: entity, insertInto: managedContext)
        
        loadingEvent.setValue(id, forKey: "id")
        loadingEvent.setValue(dialogue.characterId, forKey: "characterId")
        loadingEvent.setValue(dialogue.message, forKey: "message")
        loadingEvent.setValue(dialogue.nextStep, forKey: "nextStep")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllDialogues() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<DialogueEventDAO> = DialogueEventDAO.fetchRequest()
        
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
