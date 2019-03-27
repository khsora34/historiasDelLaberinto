struct Protagonist: CharacterWithStatus {
    let name: String
    var partnerId: String

    var currentHealthPoints: Int
    let maxHealthPoints: Int
    let attack: Int
    let defense: Int
    let agility: Int
    var currentStatusAilment: StatusAilment?
    var weapon: Weapon
    
    var items: [(Item, Int)]
    var visitedRooms: [Int: VisitedRoom]
}

struct VisitedRoom {
    var isVisited: Bool
    var isVisitedWithPartner: Bool
}
