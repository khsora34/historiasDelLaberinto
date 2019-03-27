struct Weapon: Item {
    let name: String
    let description: String
    let imageUrl: String
    
    let extraDamage: Int
    let hitRate: Int
    let inducedAilment: InduceAilment
}
