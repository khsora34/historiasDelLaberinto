import UIKit.UIApplication
import CoreData

protocol RewardEventFetcher {
    var persistentContainer: NSPersistentContainer { get }
    func getReward(from event: EventDAO) -> RewardEvent?
    func saveReward(_ reward: RewardEvent) -> Bool
}

extension RewardEventFetcher {
    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func getReward(from event: EventDAO) -> RewardEvent? {
        guard let rewardEvent = event as? RewardEventDAO,
            let id = event.id,
            let message = rewardEvent.message,
            let rewardsSet = rewardEvent.rewardsAssociated else { return nil }
            
        var rewards: [String: Int] = [:]

        rewardsSet.filter({ $0 is ItemsQuantity && ($0 as! ItemsQuantity).itemId != nil }).forEach {
            let pair = $0 as! ItemsQuantity
            rewards[pair.itemId!] = Int(pair.quantity)
        }

        return RewardEvent(id: id, message: message, rewards: rewards, shouldSetVisited: rewardEvent.shouldSetVisited, shouldEndGame: rewardEvent.shouldEndGame, nextStep: rewardEvent.nextStep)
    }

    func saveReward(_ reward: RewardEvent) -> Bool {
        guard let eventEntity = NSEntityDescription.entity(forEntityName: DaoConstants.ModelsNames.RewardEventDAO.rawValue, in: managedContext),
            let rewardEntity = NSEntityDescription.entity(forEntityName: DaoConstants.ModelsNames.ItemsQuantity.rawValue, in: managedContext) else { return false }

        let loadingEvent = RewardEventDAO(entity: eventEntity, insertInto: managedContext)
        loadingEvent.id = reward.id
        loadingEvent.type = DaoConstants.Event.reward.rawValue
        loadingEvent.message = reward.message
        loadingEvent.shouldSetVisited = reward.shouldSetVisited ?? false
        loadingEvent.shouldEndGame = reward.shouldEndGame ?? false
        loadingEvent.nextStep = reward.nextStep

        var managedRewards: [NSManagedObject] = []

        for rewardKey in reward.rewards.keys {
            let loadingReward = ItemsQuantity(entity: rewardEntity, insertInto: managedContext)
            loadingReward.itemId = rewardKey
            loadingReward.quantity = Int16(reward.rewards[rewardKey] ?? 0)

            managedRewards.append(loadingReward)
        }

        loadingEvent.rewardsAssociated = NSOrderedSet(array: managedRewards)

        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
            return false
        }
    }

    func deleteAllRewards() {
        let eventFetchRequest: NSFetchRequest<RewardEventDAO> = RewardEventDAO.fetchRequest()

        do {
            let results = try managedContext.fetch(eventFetchRequest)
            for result in results {
                if let rewards = result.rewardsAssociated {
                    for reward in rewards {
                        if let reward = reward as? NSManagedObject {
                            managedContext.delete(reward)
                        }
                    }
                }
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
