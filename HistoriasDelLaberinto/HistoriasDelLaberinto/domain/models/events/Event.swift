protocol Event: Decodable {
    var id: String { get }
    var nextStep: String? { get }
    var shouldSetVisited: Bool? { get }
    var shouldEndGame: Bool? { get }
}

enum EventType: String {
    case dialogue, condition, choice, battle, reward
    
    init?(event: Event?) {
        if event is DialogueEvent {
            self = .dialogue
        } else if event is ConditionEvent {
            self = .condition
        } else if event is ChoiceEvent {
            self = .choice
        } else if event is BattleEvent {
            self = .battle
        } else if event is RewardEvent {
            self = .reward
        } else {
            return nil
        }
    }
}
