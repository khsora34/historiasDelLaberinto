struct DialogueEvent: Event, Codable {
    let characterId: String
    let message: String
    let shouldSetVisited: Bool?
    let nextStep: String?
}

typealias DialogueEventParser = YamlParser<DialogueEvent>
