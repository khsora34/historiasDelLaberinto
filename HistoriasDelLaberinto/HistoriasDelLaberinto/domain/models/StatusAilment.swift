enum StatusAilment {
    case poisoned
    case paralyzed
    case blind
}

extension StatusAilment: Codable {
    
    enum CodingKeys: CodingKey {
        case rawValue
    }
    
    enum ErrorKey: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        switch rawValue {
        case "poisoned":
            self = .poisoned
        case "paralyzed":
            self = .paralyzed
        case "blind":
            self = .blind
        default:
            throw ErrorKey.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .poisoned:
            try container.encode("poisoned", forKey: .rawValue)
        case .paralyzed:
            try container.encode("paralyzed", forKey: .rawValue)
        case .blind:
            try container.encode("blind", forKey: .rawValue)
        }
    }
}

struct InduceAilment: Codable, Hashable {
    let ailment: StatusAilment
    let induceRate: Int
}

extension InduceAilment {
    static func == (lhs: InduceAilment, rhs: InduceAilment) -> Bool {
        return lhs.ailment == rhs.ailment && lhs.induceRate == rhs.induceRate
    }
}
