struct Room: Codable {
    let name: String
    let description: String
    let reloadWithPartner: Bool
    let actions: [Action]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case reloadWithPartner = "reloadWhenPartner"
        case actions
    }
}
