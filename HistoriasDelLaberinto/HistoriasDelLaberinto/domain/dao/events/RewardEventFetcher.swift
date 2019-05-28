import UIKit.UIApplication
import CoreData

protocol RewardEventFetcher {
    func getReward(with id: String) -> RewardEvent?
    func saveReward(_ reward: RewardEvent, with id: String)
    func deleteAllRewards()
}

extension RewardEventFetcher {
    func getReward(with id: String) -> RewardEvent? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<RewardEventDAO> = RewardEventDAO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
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
        
        for element in rewardsSet {
            if let rewardManaged = element as? RewardDAO, let name = rewardManaged.name {
                rewards[name] = Int(rewardManaged.quantity)
            }
        }
        
        return RewardEvent(message: message, rewards: rewards, nextStep: rewardEvent.nextStep)
    }
    
    func saveReward(_ reward: RewardEvent, with id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard
            let eventEntity =
            NSEntityDescription.entity(forEntityName: "RewardEventDAO", in: managedContext),
            let rewardEntity = NSEntityDescription.entity(forEntityName: "RewardDAO", in: managedContext) else { return }
        
        let loadingEvent = NSManagedObject(entity: eventEntity, insertInto: managedContext)
        loadingEvent.setValue(id, forKey: "id")
        loadingEvent.setValue(reward.message, forKey: "message")
        loadingEvent.setValue(reward.nextStep, forKey: "nextStep")
        
        var managedRewards: [NSManagedObject] = []
        
        for rewardKey in reward.rewards.keys {
            let loadingReward = NSManagedObject(entity: rewardEntity, insertInto: managedContext)
            loadingReward.setValue(rewardKey, forKey: "name")
            loadingReward.setValue(reward.rewards[rewardKey], forKey: "quantity")
            
            managedRewards.append(loadingReward)
        }
        
        loadingEvent.setValue(NSOrderedSet(array: managedRewards), forKey: "rewardsAssociated")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
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
            
            try managedContext.save()
            
        } catch {
            print(error)
        }
    }
}
