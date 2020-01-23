struct Action: Decodable {
    let name: String
    let nextStep: String?
    let condition: Condition?
    
    private enum CodingKeys: String, CodingKey {
        case name = "action"
        case nextStep
        case condition
    }
}

extension Action: Equatable {
    static func == (lhs: Action, rhs: Action) -> Bool {
        guard lhs.name == rhs.name, lhs.nextStep == rhs.nextStep else { return false }
        switch (lhs.condition, rhs.condition) {
        case (.item(let id1)?, .item(let id2)?):
            return id1 == id2
        case (.roomVisited(let id1)?, .roomVisited(let id2)?):
            return id1 == id2
        case (.roomNotVisited(let id1)?, .roomNotVisited(let id2)?):
            return id1 == id2
        case (.partner(let id1)?, .partner(let id2)?):
            return id1 == id2
        case (.variable(let var1), .variable(let var2)):
            return var1 == var2
        case (.none, .none):
            return true
        default:
            return false
        }
    }
}

typealias ActionParser = YamlParser<Action>
