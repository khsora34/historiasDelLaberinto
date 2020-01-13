import UIKit.UIApplication
import CoreData

protocol LocalizedValueFetcher {
    func getString(key: String, forLocale locale: Locale) -> String
    func getAvailableLanguages() -> [Locale]
    func saveString(key: String, value: String, forLocale locale: Locale) -> Bool
    func deleteAllTexts()
}

class LocalizedValueFetcherImpl: LocalizedValueFetcher {
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
    
    func getString(key: String, forLocale locale: Locale) -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return key }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TextDAO> = TextDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Generic.key) == %@ AND \(DaoConstants.Generic.language) == %@", key, locale.identifier)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results.first?.value ?? key
        } catch let error as NSError {
            print("No ha sido posible conseguir el texto con clave \(key).\n\(error), \(error.userInfo)")
            return key
        }
    }
    
    func getAvailableLanguages() -> [Locale] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: DaoConstants.ModelsNames.TextDAO.rawValue)
        fetchRequest.propertiesToFetch = ["language"]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            guard let finalResults = results as? [[String: String]] else {
                return []
            }
            return finalResults.compactMap { Locale(identifier: $0.values.first!) }
        } catch let error as NSError {
            print("No ha sido posible conseguir los lenguajes disponibles.\n\(error), \(error.userInfo)")
            return []
        }
    }
    
    func saveString(key: String, value: String, forLocale locale: Locale) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: DaoConstants.ModelsNames.TextDAO.rawValue, in: managedContext) else { return false }
        let text = TextDAO(entity: entity, insertInto: managedContext)
        
        text.key = key
        text.value = value
        text.language = locale.identifier
        
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
