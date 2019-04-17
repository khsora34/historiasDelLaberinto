struct RewardEvent: Event, Codable {
    let id: String
    let message: String
    let rewards: [String: Int]
    let nextStep: String
}

