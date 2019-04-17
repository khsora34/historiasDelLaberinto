struct ChoiceEvent: Event, Codable {
    let id: String
    let options: [Action]
}
