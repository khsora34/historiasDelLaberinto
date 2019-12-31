import UIKit.UIApplication
import CoreData

protocol BattleEventFetcher {
    var persistentContainer: NSPersistentContainer { get }
    func getBattle(from event: EventDAO) -> BattleEvent?
    func saveBattle(_ battle: BattleEvent) -> Bool
}

extension BattleEventFetcher {

    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func getBattle(from event: EventDAO) -> BattleEvent? {
        guard let event = event as? BattleEventDAO,
            let id = event.id,
            let enemyId = event.enemyId,
            let winStep = event.winStep,
            let loseStep = event.loseStep else { return nil }
        return BattleEvent(id: id, enemyId: enemyId, shouldSetVisited: event.shouldSetVisited, shouldEndGame: event.shouldEndGame, winStep: winStep, loseStep: loseStep)
    }

    func saveBattle(_ battle: BattleEvent) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.BattleEventDAO)", in: managedContext) else { return false }

        let loadingEvent = BattleEventDAO(entity: entity, insertInto: managedContext)
        loadingEvent.id = battle.id
        loadingEvent.type = "\(DaoConstants.Event.battle)"
        loadingEvent.enemyId = battle.enemyId
        loadingEvent.shouldSetVisited = battle.shouldSetVisited ?? false
        loadingEvent.shouldEndGame = battle.shouldEndGame ?? false
        loadingEvent.winStep = battle.winStep
        loadingEvent.loseStep = battle.loseStep

        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }

    func deleteAllBattles() {
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
