enum DaoConstants {
    enum Character: String {
        case id, imageUrl, name, agility, attack, currentHealthPoints, defense, maxHealthPoints, portraitUrl, weaponId, partner, inventory
    }
    
    enum ModelsNames: String {
        case ActionDAO, BattleEventDAO, CharacterDAO, ChoiceEventDAO, ConditionEventDAO, ConsumableItemDAO, DialogueEventDAO, EventDAO, ItemDAO, Movement, ItemsQuantity, PlayableCharacterDAO, ProtagonistDAO, RewardEventDAO, RoomDAO, RoomPosition, WeaponDAO
    }
    
    enum Action: String {
        case conditionType, conditionValue, name, nextStep
    }
    
    enum BattleEvent: String {
        case enemyId, loseStep, winStep
    }
    
    enum ChoiceEvent: String {
        case actionsAssociated
    }
    
    enum ConditionEvent: String {
        case conditionType, conditionValue, nextStepIfFalse, nextStepIfTrue
    }
    
    enum DialogueEvent: String {
        case characterId, message, nextStep
    }
    
    enum Event: String {
        case id, shouldEndGame, shouldSetVisited, type, battle, reward, dialogue, choice, condition
    }
    
    enum Item: String {
        case healthRecovered, descriptionString, id, imageUrl, type, name, itemId, quantity, ailment, extraDamage, hitRate, induceRate
    }
    
    enum Movement: String {
        case actualX, actualY, compassPoint, genericProb
    }
    
    enum RewardEvent: String {
        case message, nextStep, rewardsAssociated
    }
    
    enum Room: String {
        case id, descriptionString, imageUrl, isGenericRoom, isVisited, isVisitedWithPartner, name, actions
    }
    
    enum RoomPosition: String {
        case roomId, x, y
    }
}
