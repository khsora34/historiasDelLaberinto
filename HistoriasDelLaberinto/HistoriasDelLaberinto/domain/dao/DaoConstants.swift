enum DaoConstants {
    enum Generic: String {
        case id, key, language
    }
    
    enum ModelsNames: String {
        case ActionDAO, BattleEventDAO, CharacterDAO, ChoiceEventDAO, ConditionEventDAO, ConsumableItemDAO, DialogueEventDAO, EventDAO, ImageSourceDAO, ItemDAO, Movement, ItemsQuantity, PlayableCharacterDAO, ProtagonistDAO, RewardEventDAO, RoomDAO, RoomPosition, TextDAO, WeaponDAO
    }
    
    enum Event: String {
        case battle, reward, dialogue, choice, condition
    }
}
