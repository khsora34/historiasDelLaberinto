import UIKit.UIApplication
import CoreData

protocol LocalizedValueFetcher {
    func getString(key: String) -> String
    func saveString(key: String, value: String, forLanguage langIdentifier: String) -> Bool
}

class LocalizedValueFetcherImpl: LocalizedValueFetcher {
    func getString(key: String) -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return key }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TextDAO> = TextDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Generic.key) == %@ AND \(DaoConstants.Generic.language)", key, UserDefaults.standard.string(forKey: "gameLanguage")!)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results.first?.value ?? key
        } catch let error as NSError {
            print("No ha sido posible conseguir el texto con clave \(key).\n\(error), \(error.userInfo)")
            return key
        }
    }
    
    func saveString(key: String, value: String, forLanguage langIdentifier: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.TextDAO)", in: managedContext) else { return false }
        let text = TextDAO(entity: entity, insertInto: managedContext)
        
        text.key = key
        text.value = value
        text.language = langIdentifier
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar el texto con clave: valor \(key):\(value) \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteAllTexts() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let roomFetchRequest: NSFetchRequest<TextDAO> = TextDAO.fetchRequest()
        
        do {
            let results = try managedContext.fetch(roomFetchRequest)
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
