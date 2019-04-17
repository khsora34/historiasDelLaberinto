struct DialogueEvent: Event, Codable {
    let id: String
    let characterId: String
    let message: String
    let nextEventId: String
}

typealias DialogueEventParser = YamlParser<DialogueEvent>
