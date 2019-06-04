enum Condition {
    case partner(id: String)
    case item(id: String)
    case roomVisited(id: String)
    
    func evaluate(evaluator: ConditionEvaluator?) -> Bool {
        return evaluator?.evaluate(self) ?? false
    }
}

extension Condition: Codable {
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
        switch rawValue {
        case "partner":
            let partnerId = try container.decode(String.self, forKey: .associatedValue)
            self = .partner(id: partnerId)
        case "item":
            let itemId = try container.decode(String.self, forKey: .associatedValue)
            self = .item(id: itemId)
        case "roomVisited":
            let roomId = try container.decode(String.self, forKey: .associatedValue)
            self = .item(id: roomId)
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .partner(let partnerId):
            try container.encode("partner", forKey: .rawValue)
            try container.encode(partnerId, forKey: .associatedValue)
        case .item(let itemId):
            try container.encode("item", forKey: .rawValue)
            try container.encode(itemId, forKey: .associatedValue)
        case .roomVisited(let roomId):
            try container.encode("roomVisited", forKey: .rawValue)
            try container.encode(roomId, forKey: .associatedValue)
        }
    }
}

typealias ConditionParser = YamlParser<Condition>
