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
        fetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Generic.id) == %@", id)
        
        var character: CharacterDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            character = results.first
        } catch let error as NSError {
            print("💔 No ha sido posible conseguir al personaje con id \(id).\n \(error), \(error.userInfo)")
        }
        
        guard let name = character?.name, let imageUrl = character?.imageUrl, let loadedImageType = character?.imageSource?.type, let loadedImageSource = character?.imageSource?.source else { return nil }
        
        let imageSource: ImageSource
        if loadedImageType == "local" {
            imageSource = .local(loadedImageSource)
        } else if loadedImageType == "remote" {
            imageSource = .remote(loadedImageSource)
        } else {
            return nil
        }
        
        if let playableCharacter = character as? PlayableCharacterDAO, let loadedPortraitType = character?.imageSource?.type, let loadedPortraitSource = character?.imageSource?.source {
            let portraitSource: ImageSource
            if loadedPortraitType == "local" {
                portraitSource = .local(loadedPortraitSource)
            } else if loadedPortraitType == "remote" {
                portraitSource = .remote(loadedPortraitSource)
            } else {
                return nil
            }
            
            if let protagonist = character as? ProtagonistDAO {
                return Protagonist(
                    name: name, imageUrl: imageUrl, portraitUrl: protagonist.portraitUrl, imageSource: imageSource, portraitSource: portraitSource,
                    currentHealthPoints: Int(protagonist.currentHealthPoints),
                    maxHealthPoints: Int(protagonist.maxHealthPoints),
                    attack: Int(protagonist.attack),
                    defense: Int(protagonist.defense),
                    agility: Int(protagonist.agility),
                    currentStatusAilment: nil,
                    weapon: protagonist.weaponId,
                    partner: protagonist.partner,
                    items: getInventory(from: protagonist))
            } else {
                return PlayableCharacter(
                    name: name, imageUrl: imageUrl, portraitUrl: playableCharacter.portraitUrl, imageSource: imageSource, portraitSource: portraitSource,
                    currentHealthPoints: Int(playableCharacter.currentHealthPoints),
                    maxHealthPoints: Int(playableCharacter.maxHealthPoints),
                    attack: Int(playableCharacter.attack),
                    defense: Int(playableCharacter.defense),
                    agility: Int(playableCharacter.agility),
                    currentStatusAilment: nil,
                    weapon: playableCharacter.weaponId)
            }
        } else {
            return NotPlayableCharacter(name: name, imageUrl: imageUrl, imageSource: imageSource)
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
            let itemsEntity = NSEntityDescription.entity(forEntityName: DaoConstants.ModelsNames.ItemsQuantity.rawValue, in: managedContext),
            let imageEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ImageSourceDAO)", in: managedContext)
            else { return false }
        
        deleteCharacter(with: id)
        
        let loadingCharacter: CharacterDAO
        
        if let playableCharacter = character as? CharacterStatus {
            let loadingPlayableCharacter: PlayableCharacterDAO
            
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
                loadingProtagonist.inventory = NSSet(array: managedItems)
                loadingPlayableCharacter = loadingProtagonist
            } else {
                loadingPlayableCharacter = PlayableCharacterDAO(entity: playableEntity, insertInto: managedContext)
            }
            
            loadingPlayableCharacter.portraitUrl = playableCharacter.portraitUrl
            let portraitSource = ImageSourceDAO(entity: imageEntity, insertInto: managedContext)
            portraitSource.type = playableCharacter.portraitSource.name
            portraitSource.source = playableCharacter.portraitSource.value
            loadingPlayableCharacter.portraitSource = portraitSource
            
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
        
        let imageSource = ImageSourceDAO(entity: imageEntity, insertInto: managedContext)
        imageSource.type = character.imageSource.name
        imageSource.source = character.imageSource.value
        loadingCharacter.imageSource = imageSource
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("💔 No ha sido posible guardar al personaje con id \(id).\n \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteCharacter(with id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let characterFetchRequest: NSFetchRequest<CharacterDAO> = CharacterDAO.fetchRequest()
        characterFetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Generic.id) == %@", id)
        
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
