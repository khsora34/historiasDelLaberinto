import UIKit.UIApplication
import CoreData

protocol DialogueDaoParser {
    func getDialogue(from event: EventDAO) -> DialogueEvent?
    func saveDialogue(_ dialogue: DialogueEvent) -> Bool
}

extension DialogueDaoParser {
    func getDialogue(from event: EventDAO) -> DialogueEvent? {
        guard let dialogueEvent = event as? DialogueEventDAO else { return nil }
        
        guard let id = dialogueEvent.id, let characterId = dialogueEvent.characterId, let message = dialogueEvent.message else { return nil }
        
        return DialogueEvent(id: id, characterId: characterId, message: message, shouldSetVisited: dialogueEvent.shouldSetVisited, shouldEndGame: dialogueEvent.shouldEndGame, nextStep: dialogueEvent.nextStep)
    }
    
    func saveDialogue(_ dialogue: DialogueEvent) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false  }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "DialogueEventDAO", in: managedContext) else { return false }
        let loadingEvent = NSManagedObject(entity: entity, insertInto: managedContext)
        
        loadingEvent.setValue(dialogue.id, forKey: "id")
        loadingEvent.setValue("dialogue", forKey: "type")
        loadingEvent.setValue(dialogue.characterId, forKey: "characterId")
        loadingEvent.setValue(dialogue.message, forKey: "message")
        loadingEvent.setValue(dialogue.nextStep, forKey: "nextStep")
        loadingEvent.setValue(dialogue.shouldSetVisited, forKey: "shouldSetVisited")
        loadingEvent.setValue(dialogue.shouldEndGame, forKey: "shouldEndGame")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
}
