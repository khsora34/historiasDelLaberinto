import Yams

struct EventBuilder {
    let node: Node
    let type: EventType
    
    func getEvent() -> Event? {
        guard let stringNode = nodeToString() else { return nil }
        let event: Event?
        switch type {
        case .battle:
            event = BattleEventParser().serialize(stringNode)
        case .choice:
            event = ChoiceEventParser().serialize(stringNode)
        case .condition:
            event = ConditionEventParser().serialize(stringNode)
        case .dialogue:
            event = DialogueEventParser().serialize(stringNode)
        case .reward:
            event = RewardEventParser().serialize(stringNode)
        case .unknown:
            print("Unable to serialize unknown type event.")
            event = nil
        }
        return event
    }
    
    private func nodeToString() -> String? {
        return try? Yams.serialize(node: node)
    }
}
