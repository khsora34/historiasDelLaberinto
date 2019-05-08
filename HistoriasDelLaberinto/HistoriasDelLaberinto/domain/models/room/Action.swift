struct Action: Codable {
    let name: String
    let eventId: String?
    let condition: Condition?
    
    private enum CodingKeys: String, CodingKey {
        case name = "action"
        case eventId = "nextStep"
        case condition
    }
}

typealias ActionParser = YamlParser<Action>
