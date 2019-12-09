enum DaoConstants {
    enum Generic: String {
        case id, key, language, name
    }
    
    enum ModelsNames: String {
        case ActionDAO, BattleEventDAO, CharacterDAO, ChoiceEventDAO, ConditionDAO, ConditionEventDAO, ConditionVariableDAO, ConsumableItemDAO, DialogueEventDAO, EventDAO, ImageSourceDAO, ItemDAO, Movement, ItemsQuantity, PlayableCharacterDAO, ProtagonistDAO, RewardEventDAO, RoomDAO, RoomPosition, TextDAO, VariableDAO, WeaponDAO
    }
    
    enum Event: String {
        case battle, reward, dialogue, choice, condition
    }
}
