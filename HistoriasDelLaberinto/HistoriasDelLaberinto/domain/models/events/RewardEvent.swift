struct RewardEvent: Event, Codable {
    let message: String
    let rewards: [String: Int]
    let nextStep: String?
}

typealias RewardEventParser = YamlParser<RewardEvent>
