import UIKit.UIApplication
import CoreData

protocol RewardEventFetcher {
    func getReward(with id: String) -> RewardEvent?
    func saveReward(_ reward: RewardEvent) -> Bool
    func deleteAllRewards()
}

extension RewardEventFetcher {
    func getReward(with id: String) -> RewardEvent? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<RewardEventDAO> = RewardEventDAO.fetchRequest()
        let predicate = NSPredicate(format: "\(DaoConstants.Event.id) == %@", id)
        fetchRequest.predicate = predicate
        
        var event: RewardEventDAO?
        do {
            let results = try managedContext.fetch(fetchRequest)
            event = results.first
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        guard let rewardEvent = event, let message = rewardEvent.message, let rewardsSet = rewardEvent.rewardsAssociated else { return nil }
        
        var rewards: [String: Int] = [:]
        
        rewardsSet.filter({ $0 is ItemsQuantity && ($0 as! ItemsQuantity).itemId != nil }).forEach {
            let pair = $0 as! ItemsQuantity
            rewards[pair.itemId!] = Int(pair.quantity)
        }
        
        return RewardEvent(id: id, message: message, rewards: rewards, shouldSetVisited: rewardEvent.shouldSetVisited, shouldEndGame: event?.shouldEndGame, nextStep: rewardEvent.nextStep)
    }
    
    func saveReward(_ reward: RewardEvent) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let eventEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.RewardEventDAO)", in: managedContext),
            let rewardEntity = NSEntityDescription.entity(forEntityName: "\(DaoConstants.ModelsNames.ItemsQuantity)", in: managedContext) else { return false }
        
        let loadingEvent = RewardEventDAO(entity: eventEntity, insertInto: managedContext)
        loadingEvent.id = reward.id
        loadingEvent.type = "\(DaoConstants.Event.reward)"
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
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
