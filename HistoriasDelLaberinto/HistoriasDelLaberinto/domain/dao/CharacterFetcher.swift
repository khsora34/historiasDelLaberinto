import UIKit.UIApplication
import CoreData

protocol CharacterFetcher {
    func getCharacter(with id: String) -> GameCharacter?
    func saveCharacter(for character: GameCharacter, with id: String) -> Bool
    func deleteCharacter(with id: String)
    func deleteAllCharacters()
}

class CharacterFetcherImpl: CharacterFetcher {
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
        
        guard let name = character?.name, let imageUrl = character?.imageUrl else { return nil }
        
        if let protagonist = character as? ProtagonistDAO {
            return Protagonist(
                name: name, imageUrl: imageUrl, portraitUrl: protagonist.portraitUrl, partner: protagonist.partner,
                currentHealthPoints: Int(protagonist.currentHealthPoints),
                maxHealthPoints: Int(protagonist.maxHealthPoints),
                attack: Int(protagonist.attack),
                defense: Int(protagonist.defense),
                agility: Int(protagonist.agility),
                currentStatusAilment: nil,
                weapon: protagonist.weaponId,
                items: getInventory(from: protagonist))
        } else if let playableCharacter = character as? PlayableCharacterDAO {
            return PlayableCharacter(
                name: name, imageUrl: imageUrl, portraitUrl: playableCharacter.portraitUrl,
                currentHealthPoints: Int(playableCharacter.currentHealthPoints),
                maxHealthPoints: Int(playableCharacter.maxHealthPoints),
                attack: Int(playableCharacter.attack),
                defense: Int(playableCharacter.defense),
                agility: Int(playableCharacter.agility),
                currentStatusAilment: nil,
                weapon: playableCharacter.weaponId)
        } else {
            return NotPlayableCharacter(name: name, imageUrl: imageUrl)
        }
    }
    
    private func getInventory(from prota: ProtagonistDAO?) -> [String: Int] {
        var dict: [String: Int] = [:]
        
        guard let inventory = prota?.inventory else { return dict }
        
        for item in inventory {
            if let item = item as? ObtainedItemsDAO, let id = item.id {
                dict[id] = Int(item.quantity)
            }
        }
        
        return dict
    }
    
    func saveCharacter(for character: GameCharacter, with id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let characterEntity = NSEntityDescription.entity(forEntityName: "CharacterDAO", in: managedContext),
            let itemsEntity = NSEntityDescription.entity(forEntityName: "ObtainedItemsDAO", in: managedContext) else { return false }
        
        deleteCharacter(with: id)
        
        let loadingCharacter = NSManagedObject(entity: characterEntity, insertInto: managedContext)
        loadingCharacter.setValue(id, forKey: "id")
        loadingCharacter.setValue(character.name, forKey: "name")
        loadingCharacter.setValue(character.imageUrl, forKey: "imageUrl")
        
        if let character = character as? PlayableCharacter {
            loadingCharacter.setValue(character.portraitUrl, forKey: "portraitUrl")
            loadingCharacter.setValue(character.currentHealthPoints, forKey: "currentHealthPoints")
            loadingCharacter.setValue(character.maxHealthPoints, forKey: "maxHealthPoints")
            loadingCharacter.setValue(character.attack, forKey: "attack")
            loadingCharacter.setValue(character.defense, forKey: "defense")
            loadingCharacter.setValue(character.agility, forKey: "agility")
            loadingCharacter.setValue(character.weapon, forKey: "weapon")
            
        }
        
        if let protagonist = character as? Protagonist {
            loadingCharacter.setValue(protagonist.partner, forKey: "partner")
            
            var managedItems: [NSManagedObject] = []
            
            for (key, value) in protagonist.items {
                let loadingItem = NSManagedObject(entity: itemsEntity, insertInto: managedContext)
                loadingItem.setValue(key, forKey: "id")
                loadingItem.setValue(value, forKey: "quantity")
                managedItems.append(loadingItem)
            }
            
            loadingCharacter.setValue(NSSet(array: managedItems), forKey: "inventory")
        }
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteCharacter(with id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let characterFetchRequest: NSFetchRequest<CharacterDAO> = CharacterDAO.fetchRequest()
        characterFetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try managedContext.fetch(characterFetchRequest)
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
    
    func deleteAllCharacters() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let characterFetchRequest: NSFetchRequest<CharacterDAO> = CharacterDAO.fetchRequest()
        
        do {
            let results = try managedContext.fetch(characterFetchRequest)
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
