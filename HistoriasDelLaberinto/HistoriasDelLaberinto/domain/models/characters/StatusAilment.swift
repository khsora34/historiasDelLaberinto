enum StatusAilment: String {
    case poison
    case paralysis
    case blindness
    
    var ailmentKey: String {
        switch self {
        case .poison:
            return "statusAilmentPoison"
        case .paralysis:
            return "statusAilmentParalysis"
        case .blindness:
            return "statusAilmentBlindness"
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
