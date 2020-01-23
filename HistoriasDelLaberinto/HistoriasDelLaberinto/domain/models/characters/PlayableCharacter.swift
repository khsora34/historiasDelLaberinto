struct PlayableCharacter: CharacterStatus {
    let name: String
    let imageSource: ImageSource
    let portraitSource: ImageSource
    
    var currentHealthPoints: Int {
        didSet {
            if currentHealthPoints > maxHealthPoints {
                currentHealthPoints = maxHealthPoints
            } else if currentHealthPoints < 0 {
                currentHealthPoints = 0
            }
        }
    }
    let maxHealthPoints: Int
    let attack: Int
    let defense: Int
    let agility: Int
    var currentStatusAilment: StatusAilment?
    var weapon: String?
}
