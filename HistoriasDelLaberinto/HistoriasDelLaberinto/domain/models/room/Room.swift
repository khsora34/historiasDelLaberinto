struct Room: Codable, ImageRepresentable {
    let name: String
    let description: String
    let imageUrl: String
    let reloadWithPartner: Bool
    var isGenericRoom: Bool?
    let actions: [Action]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case reloadWithPartner = "reloadWhenPartner"
        case actions
        case isGenericRoom
        case imageUrl
    }
}
