import UIKit.UIApplication
import CoreData

protocol ItemFetcher {
    func getItem(with id: String) -> Item?
    func saveItem(for item: Item, with id: String) -> Bool
    func deleteAllItems()
}

class ItemFetcherImpl: ItemFetcher {
    func getItem(with id: String) -> Item? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<ItemDAO> = ItemDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Item.id) == %@", id)
        
        var item: ItemDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            item = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let tempType = item?.type, let type = ItemType(rawValue: tempType) else { return nil }
        
        if type == .consumable {
            guard let item = item as? ConsumableItemDAO else { return nil }
            return getConsumableInfo(for: item)
        } else if type == .weapon {
            guard let item = item as? WeaponDAO else { return nil }
            return getWeaponInfo(for: item)
        } else if type == .key {
            guard let name = item?.name, let description = item?.descriptionString, let imageUrl = item?.imageUrl else { return nil }
            return KeyItem(name: name, description: description, imageUrl: imageUrl)
        }
        
        return nil
    }
    
    func saveItem(for item: Item, with id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let itemEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ItemDAO)", in: managedContext),
            let consumableEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ConsumableItemDAO)", in: managedContext),
            let weaponEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.WeaponDAO)", in: managedContext) else { return false }
        
        let loadingItem: ItemDAO
        
        if let item = item as? ConsumableItem {
            let loadingConsumable = ConsumableItemDAO(entity: consumableEntity, insertInto: managedContext)
            loadingConsumable.type = "\(ItemType.consumable)"
            loadingConsumable.healthRecovered = Int64(item.healthRecovered)
            loadingItem = loadingConsumable
            
        } else if let item = item as? Weapon {
            let loadingWeapon = WeaponDAO(entity: weaponEntity, insertInto: managedContext)
            loadingWeapon.type = "\(ItemType.weapon)"
            
            loadingWeapon.extraDamage = Int16(item.extraDamage)
            loadingWeapon.hitRate = Int16(item.hitRate)
            if let inducedAilment = item.inducedAilment {
                loadingWeapon.ailment = inducedAilment.ailment.rawValue
                loadingWeapon.induceRate = Int16(inducedAilment.induceRate)
            }
            loadingItem = loadingWeapon
            
        } else {
            loadingItem = ItemDAO(entity: itemEntity, insertInto: managedContext)
            loadingItem.type = "\(ItemType.key)"
        }
        
        loadingItem.id = id
        loadingItem.name = item.name
        loadingItem.descriptionString = item.description
        loadingItem.imageUrl = item.imageUrl
        
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
    
    private func getConsumableInfo(for item: ConsumableItemDAO) -> Item? {
        guard let name = item.name, let description = item.descriptionString, let imageUrl = item.imageUrl else { return nil }
        return ConsumableItem(name: name, description: description, imageUrl: imageUrl, healthRecovered: Int(item.healthRecovered))
    }
    
    private func getWeaponInfo(for item: WeaponDAO) -> Item? {
        guard let name = item.name, let description = item.descriptionString, let imageUrl = item.imageUrl else { return nil }
        var inducedAilment: InduceAilment?
        
        if let ailment = StatusAilment(rawValue: item.ailment ?? "") {
            inducedAilment = InduceAilment(ailment: ailment, induceRate: Int(item.induceRate))
        }
        
        return Weapon(name: name, description: description, imageUrl: imageUrl, extraDamage: Int(item.extraDamage), hitRate: Int(item.hitRate), inducedAilment: inducedAilment)
    }
}
