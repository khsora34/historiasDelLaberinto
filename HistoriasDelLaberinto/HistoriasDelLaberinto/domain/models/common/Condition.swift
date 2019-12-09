enum Condition {
    case partner(id: String)
    case item(id: String)
    case roomVisited(id: String)
    case roomNotVisited(id: String)
    case variable(ConditionVariable)
    
    func evaluate(evaluator: ConditionEvaluator?) -> Bool {
        return evaluator?.evaluate(self) ?? false
    }
}

extension Condition: Decodable {
    enum CodingKeys: String, CodingKey {
        case rawValue = "kind"
        case associatedValue = "required"
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        let parsedValue = ConditionString(rawValue: rawValue)
        switch parsedValue {
        case .partner:
            let partnerId = try container.decode(String.self, forKey: .associatedValue)
            self = .partner(id: partnerId)
        case .item:
            let itemId = try container.decode(String.self, forKey: .associatedValue)
            self = .item(id: itemId)
        case .roomVisited:
            let roomId = try container.decode(String.self, forKey: .associatedValue)
            self = .roomVisited(id: roomId)
        case .roomNotVisited:
            let roomId = try container.decode(String.self, forKey: .associatedValue)
            self = .roomNotVisited(id: roomId)
        case .variable:
            let variable = try container.decode(ConditionVariable.self, forKey: .associatedValue)
            self = .variable(variable)
        default:
            throw CodingError.unknownValue
        }
    }
}

enum ConditionString: String {
    case partner, item, roomVisited, roomNotVisited, variable
}

typealias ConditionParser = YamlParser<Condition>
