protocol GameCharacter: Decodable, ImageRepresentable, ImageSourceRepresentable {
    var name: String { get }
}

protocol CharacterStatus: GameCharacter {
    var portraitSource: ImageSource { get }
    var currentHealthPoints: Int { get set }
    var maxHealthPoints: Int { get }
    var attack: Int { get }
    var defense: Int { get }
    var agility: Int { get }
    var currentStatusAilment: StatusAilment? { get set }
    var weapon: String? { get set }
    var portraitUrl: String? { get }
}
