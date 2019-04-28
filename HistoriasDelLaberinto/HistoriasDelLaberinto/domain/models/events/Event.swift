protocol Event: Codable {
    var nextStep: String? { get }
}

enum EventType: String {
    case dialogue, condition, choice, battle, reward
}
