import UIKit.UIApplication
import CoreData

protocol ItemsFetcher {
    func getItem(with id: String) -> Item?
    func saveItem(for item: Item, with id: String) -> Bool
    func deleteAllItems()
}

class ItemsFetcherImpl: ItemsFetcher {
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
        
        guard let imageUrl = item?.imageUrl, let name = item?.name, let description = item?.descriptionString else { return nil }
        
        if let healthRecovered = item?.healthRecovered {
            return ConsumableItem(name: name, description: description, imageUrl: imageUrl, healthRecovered: Int(healthRecovered))
        } else if let weaponInfo = item?.weaponInfo {
            let inducedAilment: InduceAilment?
            
            switch weaponInfo.ailment {
            case "poisoned":
                inducedAilment = InduceAilment(ailment: .poisoned, induceRate: Int(weaponInfo.induceRate))
            case "paralyzed":
                inducedAilment = InduceAilment(ailment: .paralyzed, induceRate: Int(weaponInfo.induceRate))
            case "blind":
                inducedAilment = InduceAilment(ailment: .blind, induceRate: Int(weaponInfo.induceRate))
            default:
                inducedAilment = nil
            }
            
            return Weapon(name: name, description: description, imageUrl: imageUrl, extraDamage: Int(weaponInfo.extraDamage), hitRate: Int(weaponInfo.hitRate), inducedAilment: inducedAilment)
        } else {
            return KeyItem(name: name, description: description, imageUrl: imageUrl)
        }
    }
    
    func saveItem(for item: Item, with id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let itemEntity = NSEntityDescription.entity(forEntityName: "ItemDAO", in: managedContext),
            let weaponInfoEntity = NSEntityDescription.entity(forEntityName: "WeaponDAO", in: managedContext) else { return false }
        let loadingItem = NSManagedObject(entity: itemEntity, insertInto: managedContext)
        
        loadingItem.setValue(id, forKey: "id")
        loadingItem.setValue(item.name, forKey: "name")
        loadingItem.setValue(item.description, forKey: "descriptionString")
        loadingItem.setValue(item.imageUrl, forKey: "imageUrl")
        
        if let item = item as? ConsumableItem {
            loadingItem.setValue(item.healthRecovered, forKey: "healthRecovered")
            
        } else if let item = item as? Weapon {
            let loadingInfo = NSManagedObject(entity: weaponInfoEntity, insertInto: managedContext)
            loadingInfo.setValue(item.extraDamage, forKey: "extraDamage")
            loadingInfo.setValue(item.hitRate, forKey: "hitRate")
            
            if let inducedAilment = item.inducedAilment {
                loadingInfo.setValue(inducedAilment.ailment.rawValue, forKey: "ailment")
                loadingInfo.setValue(inducedAilment.induceRate, forKey: "induceRate")
            }
            loadingItem.setValue(loadingInfo, forKey: "weaponInfo")
        }
        
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
                if let weapon = result.weaponInfo {
                    managedContext.delete(weapon)
                }
                managedContext.delete(result)
            }
            
            try managedContext.save()
            
        } catch {
            print(error)
        }
    }
}
