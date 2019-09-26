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
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        var item: ItemDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            item = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let type = item?.type else { return nil }
        
        if type == "consumable" {
            guard let item = item as? ConsumableItemDAO else { return nil }
            return getConsumableInfo(for: item)
        } else if type == "weapon" {
            guard let item = item as? WeaponDAO else { return nil }
            return getWeaponInfo(for: item)
        } else if type == "key" {
            guard let name = item?.name, let description = item?.descriptionString, let imageUrl = item?.imageUrl else { return nil }
            return KeyItem(name: name, description: description, imageUrl: imageUrl)
        }
        
        return nil
    }
    
    func saveItem(for item: Item, with id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let itemEntity = NSEntityDescription.entity(forEntityName: "ItemDAO", in: managedContext),
            let consumableEntity = NSEntityDescription.entity(forEntityName: "ConsumableItemDAO", in: managedContext),
            let weaponEntity = NSEntityDescription.entity(forEntityName: "WeaponDAO", in: managedContext) else { return false }
        
        let loadingItem: NSManagedObject
        
        if let item = item as? ConsumableItem {
            loadingItem = NSManagedObject(entity: consumableEntity, insertInto: managedContext)
            loadingItem.setValue("consumable", forKey: "type")
            
            loadingItem.setValue(item.healthRecovered, forKey: "healthRecovered")
            
        } else if let item = item as? Weapon {
            loadingItem = NSManagedObject(entity: weaponEntity, insertInto: managedContext)
            loadingItem.setValue("weapon", forKey: "type")
            
            loadingItem.setValue(item.extraDamage, forKey: "extraDamage")
            loadingItem.setValue(item.hitRate, forKey: "hitRate")
            if let inducedAilment = item.inducedAilment {
                loadingItem.setValue(inducedAilment.ailment.rawValue, forKey: "ailment")
                loadingItem.setValue(inducedAilment.induceRate, forKey: "induceRate")
            }
            
        } else {
            loadingItem = NSManagedObject(entity: itemEntity, insertInto: managedContext)
            loadingItem.setValue("key", forKey: "type")
        }
        
        loadingItem.setValue(id, forKey: "id")
        loadingItem.setValue(item.name, forKey: "name")
        loadingItem.setValue(item.description, forKey: "descriptionString")
        loadingItem.setValue(item.imageUrl, forKey: "imageUrl")
        
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
        let inducedAilment: InduceAilment?
        
        switch item.ailment {
        case "poisoned":
            inducedAilment = InduceAilment(ailment: .poisoned, induceRate: Int(item.induceRate))
        case "paralyzed":
            inducedAilment = InduceAilment(ailment: .paralyzed, induceRate: Int(item.induceRate))
        case "blind":
            inducedAilment = InduceAilment(ailment: .blind, induceRate: Int(item.induceRate))
        default:
            inducedAilment = nil
        }
        
        return Weapon(name: name, description: description, imageUrl: imageUrl, extraDamage: Int(item.extraDamage), hitRate: Int(item.hitRate), inducedAilment: inducedAilment)
    }
}
