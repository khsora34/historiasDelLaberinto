struct Weapon: Item, Decodable, Hashable {
    let name: String
    let description: String
    let imageUrl: String
    
    let extraDamage: Int
    let hitRate: Int
    let inducedAilment: InduceAilment?
    
    static func == (lhs: Weapon, rhs: Weapon) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description
    }
}
