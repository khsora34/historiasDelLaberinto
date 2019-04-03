struct RewardEvent: Event, Codable {
    let id: String
    let message: String
    let rewards: [Item: Int]
    let nextStep: String
}

