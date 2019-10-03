enum DaoConstants {
    enum Generic: String {
        case id
    }
    
    enum ModelsNames: String {
        case ActionDAO, BattleEventDAO, CharacterDAO, ChoiceEventDAO, ConditionEventDAO, ConsumableItemDAO, DialogueEventDAO, EventDAO, ItemDAO, Movement, ItemsQuantity, PlayableCharacterDAO, ProtagonistDAO, RewardEventDAO, RoomDAO, RoomPosition, WeaponDAO
    }
    
    enum Event: String {
        case battle, reward, dialogue, choice, condition
    }
}
