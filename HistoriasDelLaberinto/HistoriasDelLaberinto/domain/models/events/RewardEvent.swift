struct RewardEvent: Event, Codable {
    let message: String
    let rewards: [String: Int]
    let shouldSetVisited: Bool?
    let shouldEndGame: Bool?
    let nextStep: String?
}

typealias RewardEventParser = YamlParser<RewardEvent>
