enum StatusAilment: String {
    case poisoned
    case paralyzed
    case blind
    
    var localizedAilmentName: String {
        switch self {
        case .poisoned:
            return "Veneno"
        case .paralyzed:
            return "Parálisis"
        case .blind:
            return "Ceguera"
        }
    }
}

extension StatusAilment: Decodable {}

struct InduceAilment: Decodable, Hashable {
    let ailment: StatusAilment
    let induceRate: Int
}

extension InduceAilment {
    static func == (lhs: InduceAilment, rhs: InduceAilment) -> Bool {
        return lhs.ailment == rhs.ailment && lhs.induceRate == rhs.induceRate
    }
}
