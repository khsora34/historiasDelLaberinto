struct Action: Codable {
    let name: String
    let eventId: String?
    let condition: Condition?
    
    private enum CodingKeys: String, CodingKey {
        case name = "action"
        case eventId = "event"
        case condition
    }
}
