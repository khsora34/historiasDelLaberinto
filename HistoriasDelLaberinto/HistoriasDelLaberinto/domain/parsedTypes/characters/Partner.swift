struct Partner: CharacterWithStatus, ImageRepresentable {
    let name: String
    
    var currentHealthPoints: Int
    let maxHealthPoints: Int
    let attack: Int
    let defense: Int
    let agility: Int
    var currentStatusAilment: StatusAilment?
    var weapon: Weapon
    
    let imageUrl: String
}
