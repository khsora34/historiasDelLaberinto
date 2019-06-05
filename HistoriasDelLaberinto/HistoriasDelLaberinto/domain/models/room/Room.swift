struct Room: Codable, ImageRepresentable {
    let id: String
    let name: String
    let description: String
    let imageUrl: String
    let reloadWithPartner: Bool
    var isGenericRoom: Bool?
    var actions: [Action]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case reloadWithPartner = "reloadWhenPartner"
        case actions
        case isGenericRoom
        case imageUrl
    }
}
