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
        fetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Character.id) == %@", id)
        
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
                name: name, imageUrl: imageUrl, portraitUrl: protagonist.portraitUrl,
                currentHealthPoints: Int(protagonist.currentHealthPoints),
                maxHealthPoints: Int(protagonist.maxHealthPoints),
                attack: Int(protagonist.attack),
                defense: Int(protagonist.defense),
                agility: Int(protagonist.agility),
                currentStatusAilment: nil,
                weapon: protagonist.weaponId,
                partner: protagonist.partner,
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
        guard let inventory = prota?.inventory else { return [:] }
        var items: [String: Int] = [:]
        
        inventory.filter({ $0 is ItemsQuantity && ($0 as! ItemsQuantity).itemId != nil }).forEach {
            let pair = $0 as! ItemsQuantity
            items[pair.itemId!] = Int(pair.quantity)
        }
        
        return items
    }
    
    func saveCharacter(for character: GameCharacter, with id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let characterEntity = NSEntityDescription.entity(forEntityName: DaoConstants.ModelsNames.CharacterDAO.rawValue, in: managedContext),
            let playableEntity = NSEntityDescription.entity(forEntityName: DaoConstants.ModelsNames.PlayableCharacterDAO.rawValue, in: managedContext),
            let protagonistEntity = NSEntityDescription.entity(forEntityName: DaoConstants.ModelsNames.ProtagonistDAO.rawValue, in: managedContext),
            let itemsEntity = NSEntityDescription.entity(forEntityName: DaoConstants.ModelsNames.ItemsQuantity.rawValue, in: managedContext) else { return false }
        
        deleteCharacter(with: id)
        
        let loadingCharacter: CharacterDAO
        
        if let playableCharacter = character as? CharacterStatus {
            var loadingPlayableCharacter: PlayableCharacterDAO = PlayableCharacterDAO(entity: playableEntity, insertInto: managedContext)
            
            if let protagonist = character as? Protagonist {
                let loadingProtagonist = ProtagonistDAO(entity: protagonistEntity, insertInto: managedContext)
                loadingProtagonist.partner = protagonist.partner
                
                var managedItems: [NSManagedObject] = []
                for (key, value) in protagonist.items {
                    let loadingItem = ItemsQuantity(entity: itemsEntity, insertInto: managedContext)
                    loadingItem.itemId = key
                    loadingItem.quantity = Int16(value)
                    managedItems.append(loadingItem)
                }
                
                loadingProtagonist.setValue(NSSet(array: managedItems), forKey: DaoConstants.Character.inventory.rawValue)
                
                loadingPlayableCharacter = loadingProtagonist
            }
            
            loadingPlayableCharacter.portraitUrl = playableCharacter.portraitUrl
            loadingPlayableCharacter.currentHealthPoints = Int16(playableCharacter.currentHealthPoints)
            loadingPlayableCharacter.maxHealthPoints = Int16(playableCharacter.maxHealthPoints)
            loadingPlayableCharacter.attack = Int16(playableCharacter.attack)
            loadingPlayableCharacter.defense = Int16(playableCharacter.defense)
            loadingPlayableCharacter.agility = Int16(playableCharacter.agility)
            loadingPlayableCharacter.weaponId = playableCharacter.weapon

            loadingCharacter = loadingPlayableCharacter
            
        } else {
            loadingCharacter = CharacterDAO(entity: characterEntity, insertInto: managedContext)
        }
        
        loadingCharacter.id = id
        loadingCharacter.name = character.name
        loadingCharacter.imageUrl = character.imageUrl
        
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
        characterFetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Character.id) == %@", id)
        
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
