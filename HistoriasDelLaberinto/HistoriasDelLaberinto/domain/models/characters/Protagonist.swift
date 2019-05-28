struct Protagonist: CharacterStatus, Codable {
    let name: String
    let imageUrl: String = ""
    var partner: String

    var currentHealthPoints: Int
    let maxHealthPoints: Int
    let attack: Int
    let defense: Int
    let agility: Int
    var currentStatusAilment: StatusAilment?
    var weapon: String?
    
    var items: [String: Int]
    var visitedRooms: [String: VisitedRoom]
}

struct VisitedRoom: Codable {
    var isVisited: Bool
    var isVisitedWithPartner: Bool
}

typealias ProtagonistParser = YamlParser<Protagonist>
