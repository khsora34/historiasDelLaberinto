struct DialogueEvent: Event, Codable {
    let characterId: String
    let message: String
    let nextStep: String?
}

typealias DialogueEventParser = YamlParser<DialogueEvent>
