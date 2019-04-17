protocol GameCharacter: Codable {
    var name: String { get }
}

protocol CharacterWithStatus: GameCharacter {
    var currentHealthPoints: Int { get set }
    var maxHealthPoints: Int { get }
    var attack: Int { get }
    var defense: Int { get }
    var agility: Int { get }
    var currentStatusAilment: StatusAilment? { get set }
    var weapon: String { get set }
}
