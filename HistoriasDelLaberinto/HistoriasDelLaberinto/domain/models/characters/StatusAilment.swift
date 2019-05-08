enum StatusAilment: String {
    case poisoned
    case paralyzed
    case blind
}

extension StatusAilment: Codable {}

struct InduceAilment: Codable, Hashable {
    let ailment: StatusAilment
    let induceRate: Int
}

extension InduceAilment {
    static func == (lhs: InduceAilment, rhs: InduceAilment) -> Bool {
        return lhs.ailment == rhs.ailment && lhs.induceRate == rhs.induceRate
    }
}
