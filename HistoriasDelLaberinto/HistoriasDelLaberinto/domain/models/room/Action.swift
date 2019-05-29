struct Action: Codable {
    let name: String
    let nextStep: String?
    let condition: Condition?
    
    private enum CodingKeys: String, CodingKey {
        case name = "action"
        case nextStep
        case condition
    }
}

typealias ActionParser = YamlParser<Action>
