struct Weapon: Item, Decodable {
    let name: String
    let description: String
    let imageSource: ImageSource
    
    let extraDamage: Int
    let hitRate: Int
    let inducedAilment: InduceAilment?
    
    static func == (lhs: Weapon, rhs: Weapon) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description
    }
}
