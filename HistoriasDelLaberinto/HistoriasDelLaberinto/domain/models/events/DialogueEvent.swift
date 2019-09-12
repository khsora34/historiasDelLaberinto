struct DialogueEvent: Event, Codable {
    let id: String
    let characterId: String
    let message: String
    let shouldSetVisited: Bool?
    let shouldEndGame: Bool?
    let nextStep: String?
}

typealias DialogueEventParser = YamlParser<DialogueEvent>
