struct Room: Codable {
    let id: String
    let name: String
    let description: String
    let reloadWithPartner: Bool
    let actions: [Action]
}
