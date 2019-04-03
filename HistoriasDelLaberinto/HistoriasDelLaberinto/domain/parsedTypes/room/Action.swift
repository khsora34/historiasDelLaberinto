struct Action: Codable {
    let name: String
    let eventId: String
    let condition: Condition?
}
