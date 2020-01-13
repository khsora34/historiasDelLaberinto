import UIKit.UIApplication
import CoreData

protocol DialogueEventFetcher {
    var persistentContainer: NSPersistentContainer { get }
    func getDialogue(from event: EventDAO) -> DialogueEvent?
    func saveDialogue(_ dialogue: DialogueEvent) -> Bool
}

extension DialogueEventFetcher {
    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getDialogue(from event: EventDAO) -> DialogueEvent? {
        guard let dialogueEvent = event as? DialogueEventDAO else { return nil }
        
        guard let id = dialogueEvent.id, let characterId = dialogueEvent.characterId, let message = dialogueEvent.message else { return nil }
        
        return DialogueEvent(id: id, characterId: characterId, message: message, shouldSetVisited: dialogueEvent.shouldSetVisited, shouldEndGame: dialogueEvent.shouldEndGame, nextStep: dialogueEvent.nextStep)
    }
    
    func saveDialogue(_ dialogue: DialogueEvent) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: DaoConstants.ModelsNames.DialogueEventDAO.rawValue, in: managedContext) else { return false }
        let loadingEvent = DialogueEventDAO(entity: entity, insertInto: managedContext)
        
        loadingEvent.id = dialogue.id
        loadingEvent.type = DaoConstants.Event.dialogue.rawValue
        loadingEvent.characterId = dialogue.characterId
        loadingEvent.message = dialogue.message
        loadingEvent.nextStep = dialogue.nextStep
        loadingEvent.shouldSetVisited = dialogue.shouldSetVisited ?? false
        loadingEvent.shouldEndGame = dialogue.shouldEndGame ?? false
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
}
