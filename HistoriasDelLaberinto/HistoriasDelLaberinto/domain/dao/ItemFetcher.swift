import UIKit.UIApplication
import CoreData

protocol ItemFetcher {
    func getItem(with id: String) -> Item?
    func saveItem(for item: Item, with id: String) -> Bool
    func deleteAllItems()
}

class ItemFetcherImpl: ItemFetcher {
    let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to retrieve shared app delegate.")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    func getItem(with id: String) -> Item? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<ItemDAO> = ItemDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Generic.id) == %@", id)
        
        var item: ItemDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            item = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let name = item?.name, let description = item?.descriptionString, let loadedImageType = item?.imageSource?.type, let loadedImageSource = item?.imageSource?.source else { return nil }
        
        let imageSource: ImageSource
        if loadedImageType == "local" {
            imageSource = .local(loadedImageSource)
        } else if loadedImageType == "remote" {
            imageSource = .remote(loadedImageSource)
        } else {
            return nil
        }
        
        if let consumable = item as? ConsumableItemDAO {
            return ConsumableItem(name: name, description: description, imageSource: imageSource, healthRecovered: Int(consumable.healthRecovered))
            
        } else if let weapon = item as? WeaponDAO {
            var inducedAilment: InduceAilment?
            
            if let ailmentString = weapon.ailment, let ailment = StatusAilment(rawValue: ailmentString) {
                inducedAilment = InduceAilment(ailment: ailment, induceRate: Int(weapon.induceRate))
            }
            
            return Weapon(name: name, description: description, imageSource: imageSource, extraDamage: Int(weapon.extraDamage), hitRate: Int(weapon.hitRate), inducedAilment: inducedAilment)
            
        } else {
            return KeyItem(name: name, description: description, imageSource: imageSource)
        }
    }
    
    func saveItem(for item: Item, with id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let itemEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ItemDAO)", in: managedContext),
            let consumableEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ConsumableItemDAO)", in: managedContext),
            let weaponEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.WeaponDAO)", in: managedContext),
            let imageEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ImageSourceDAO)", in: managedContext) else { return false }
        
        let loadingItem: ItemDAO
        
        if let item = item as? ConsumableItem {
            let loadingConsumable = ConsumableItemDAO(entity: consumableEntity, insertInto: managedContext)
            loadingConsumable.healthRecovered = Int64(item.healthRecovered)
            loadingItem = loadingConsumable
            
        } else if let item = item as? Weapon {
            let loadingWeapon = WeaponDAO(entity: weaponEntity, insertInto: managedContext)
            
            loadingWeapon.extraDamage = Int16(item.extraDamage)
            loadingWeapon.hitRate = Int16(item.hitRate)
            if let inducedAilment = item.inducedAilment {
                loadingWeapon.ailment = inducedAilment.ailment.rawValue
                loadingWeapon.induceRate = Int16(inducedAilment.induceRate)
            }
            loadingItem = loadingWeapon
            
        } else {
            loadingItem = ItemDAO(entity: itemEntity, insertInto: managedContext)
        }
        
        loadingItem.id = id
        loadingItem.name = item.name
        loadingItem.descriptionString = item.description
        let imageSource = ImageSourceDAO(entity: imageEntity, insertInto: managedContext)
        imageSource.type = item.imageSource.name
        imageSource.source = item.imageSource.value
        loadingItem.imageSource = imageSource
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteAllItems() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let itemFetchRequest: NSFetchRequest<ItemDAO> = ItemDAO.fetchRequest()
        
        do {
            let results = try managedContext.fetch(itemFetchRequest)
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
