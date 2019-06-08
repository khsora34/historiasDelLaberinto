struct PlayableCharacter: CharacterStatus {
    let name: String
    let imageUrl: String
    let portraitUrl: String?
    
    var currentHealthPoints: Int
    let maxHealthPoints: Int
    let attack: Int
    let defense: Int
    let agility: Int
    var currentStatusAilment: StatusAilment?
    var weapon: String?
}
