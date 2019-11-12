struct Protagonist: CharacterStatus, Decodable {
    let name: String
    let imageSource: ImageSource
    let portraitSource: ImageSource
    var currentHealthPoints: Int {
        didSet {
            if currentHealthPoints > maxHealthPoints {
                currentHealthPoints = maxHealthPoints
            }
        }
    }
    let maxHealthPoints: Int
    let attack: Int
    let defense: Int
    let agility: Int
    var currentStatusAilment: StatusAilment?
    var weapon: String?
    
    var partner: String?
    var items: [String: Int]
}

typealias ProtagonistParser = YamlParser<Protagonist>
