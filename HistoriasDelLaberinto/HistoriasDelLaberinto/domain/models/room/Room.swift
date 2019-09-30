struct Room: Decodable, ImageRepresentable {
    let id: String
    let name: String
    let description: String
    let imageUrl: String
    var isGenericRoom: Bool?
    var isVisited: Bool = false
    var isVisitedWithPartner: Bool = false
    var actions: [Action]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case actions
        case isGenericRoom
        case imageUrl
    }
}
