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
        }
        return event
    }
    
    private func nodeToString() -> String? {
        return try? Yams.serialize(node: node)
    }
    
    private func choiceEvent() -> ChoiceEvent? {
        guard let options = node["options"]?.array() else { return nil }
        var actions: [Action] = []

        for option in options {
            if let serializedOption = try? Yams.serialize(node: option), let action = ActionParser().serialize(serializedOption) {
                actions.append(action)
            }
        }

        return ChoiceEvent(options: actions, shouldSetVisited: node["shouldSetVisited"]?.bool)
        
    }
}
