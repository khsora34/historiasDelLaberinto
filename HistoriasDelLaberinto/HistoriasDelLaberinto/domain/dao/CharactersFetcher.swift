import UIKit.UIApplication
import CoreData

protocol CharactersFetcher {
    func getCharacter(with id: String) -> GameCharacter?
    func saveCharacter(for character: GameCharacter, with id: String) -> Bool
}

extension CharactersFetcher {
    func getCharacter(with id: String) -> GameCharacter? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CharacterDAO> = CharacterDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        var character: CharacterDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            character = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let imageUrl = character?.imageUrl, let name = character?.name else { return nil }
        
        if let status = character?.status {
            return PlayableCharacter(name: name, currentHealthPoints: Int(status.currentHealthPoints), maxHealthPoints: Int(status.maxHealthPoints), attack: Int(status.attack), defense: Int(status.defense), agility: Int(status.agility), currentStatusAilment: nil, weapon: status.weapon, imageUrl: imageUrl)
        } else {
            return NotPlayableCharacter(name: name, imageUrl: imageUrl)
        }
    }
    
    func saveCharacter(for character: GameCharacter, with id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let characterEntity = NSEntityDescription.entity(forEntityName: "CharacterDAO", in: managedContext),
            let statusEntity = NSEntityDescription.entity(forEntityName: "StatusDAO", in: managedContext) else { return false }
        let loadingCharacter = NSManagedObject(entity: characterEntity, insertInto: managedContext)
        
        loadingCharacter.setValue(id, forKey: "id")
        loadingCharacter.setValue(character.name, forKey: "name")
        loadingCharacter.setValue(character.imageUrl, forKey: "imageUrl")
        
        if let character = character as? PlayableCharacter {
            let loadingStatus = NSManagedObject(entity: statusEntity, insertInto: managedContext)
            loadingStatus.setValue(character.currentHealthPoints, forKey: "currentHealthPoints")
            loadingStatus.setValue(character.maxHealthPoints, forKey: "maxHealthPoints")
            loadingStatus.setValue(character.attack, forKey: "attack")
            loadingStatus.setValue(character.defense, forKey: "defense")
            loadingStatus.setValue(character.agility, forKey: "agility")
            loadingStatus.setValue(character.weapon, forKey: "weapon")
            loadingCharacter.setValue(loadingStatus, forKey: "status")
        }
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
}
