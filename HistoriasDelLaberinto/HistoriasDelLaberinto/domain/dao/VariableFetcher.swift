import UIKit.UIApplication
import CoreData

protocol VariableFetcher {
    func getVariable(with name: String) -> Variable?
    func saveVariable(for variable: Variable) -> Bool
    func deleteVariable(with name: String)
    func deleteAllVariables()
}

class VariableFetcherImpl: VariableFetcher {
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
    
    func getVariable(with name: String) -> Variable? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<VariableDAO> = VariableDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Generic.name) == %@", name)
        
        var variable: VariableDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            variable = results.first
        } catch let error as NSError {
            print("💔 No ha sido posible conseguir la variable \(name).\n \(error), \(error.userInfo)")
        }
        
        guard let name = variable?.name, let variableValue = VariableValue(type: variable?.type, value: variable?.value) else { return nil }
        return Variable(name: name, content: variableValue)
    }
    
    func saveVariable(for variable: Variable) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<VariableDAO> = VariableDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Generic.name) == %@", variable.name)
        
        if let results = try? managedContext.fetch(fetchRequest), let loadingVariable = results.first {
            return updateVariable(for: variable, to: loadingVariable, in: managedContext)
        } else {
            return addNewVariable(variable, in: managedContext)
        }
    }
    
    private func updateVariable(for variable: Variable, to model: VariableDAO, in context: NSManagedObjectContext) -> Bool {
        model.value = variable.content.value
        
        do {
            try context.save()
            return true
        } catch let error as NSError {
            print("💔 No ha sido posible guardar la variable \(variable.name).\n \(error), \(error.userInfo)")
            return false
        }
    }
    
    private func addNewVariable(_ variable: Variable, in context: NSManagedObjectContext) -> Bool {
        guard let variableEntity = NSEntityDescription.entity(forEntityName: DaoConstants.ModelsNames.VariableDAO.rawValue, in: context) else { return false }
        
        let loadingVariable: VariableDAO = VariableDAO(entity: variableEntity, insertInto: context)
        loadingVariable.name = variable.name
        loadingVariable.type = variable.content.type.rawValue
        loadingVariable.value = variable.content.value
        
        do {
            try context.save()
            return true
        } catch let error as NSError {
            print("💔 No ha sido posible guardar la variable \(variable.name).\n \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteVariable(with name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let characterFetchRequest: NSFetchRequest<VariableDAO> = VariableDAO.fetchRequest()
        characterFetchRequest.predicate = NSPredicate(format: "\(DaoConstants.Generic.name) == %@", name)
        
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
    
    func deleteAllVariables() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let characterFetchRequest: NSFetchRequest<VariableDAO> = VariableDAO.fetchRequest()
        
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
