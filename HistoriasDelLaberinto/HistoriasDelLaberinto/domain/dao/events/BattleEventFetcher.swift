import UIKit.UIApplication
import CoreData

protocol BattleEventFetcher {
    func getBattle(with id: String) -> BattleEvent?
    func saveBattle(_ battle: BattleEvent) -> Bool
    func deleteAllBattles()
}

extension BattleEventFetcher {
    func getBattle(with id: String) -> BattleEvent? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<BattleEventDAO> = BattleEventDAO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", NSString(string: id))
        fetchRequest.predicate = predicate
        
        var event: BattleEventDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            event = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let enemyId = event?.enemyId, let winStep = event?.winStep, let loseStep = event?.loseStep else { return nil }
        
        return BattleEvent(id: id, enemyId: enemyId, shouldSetVisited: event?.shouldSetVisited, shouldEndGame: event?.shouldEndGame, winStep: winStep, loseStep: loseStep)
    }
    
    func saveBattle(_ battle: BattleEvent) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "BattleEventDAO", in: managedContext) else { return false }
        let loadingEvent = NSManagedObject(entity: entity, insertInto: managedContext)
        
        loadingEvent.setValue(battle.id, forKey: "id")
        loadingEvent.setValue(battle.enemyId, forKey: "enemyId")
        loadingEvent.setValue(battle.shouldSetVisited, forKey: "shouldSetVisited")
        loadingEvent.setValue(battle.shouldEndGame, forKey: "shouldEndGame")
        loadingEvent.setValue(battle.winStep, forKey: "winStep")
        loadingEvent.setValue(battle.loseStep, forKey: "loseStep")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteAllBattles() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<BattleEventDAO> = BattleEventDAO.fetchRequest()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
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
