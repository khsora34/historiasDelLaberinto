struct RewardEvent: Event {
    let id: String
    let message: String
    let rewards: [(item: Item, quantity: Int)]
    let nextStep: String
}
