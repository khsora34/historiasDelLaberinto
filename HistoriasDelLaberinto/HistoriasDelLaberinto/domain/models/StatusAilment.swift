enum StatusAilment {
    case poisoned
    case paralyzed
    case blind
}

struct InduceAilment {
    let ailment: StatusAilment
    let induceRate: Int
}
