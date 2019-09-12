struct ChoiceEvent: Event, Decodable {
    let id: String
    var options: [Action]
    let shouldSetVisited: Bool?
    let shouldEndGame: Bool?
    let nextStep: String? = nil
}

typealias ChoiceEventParser = YamlParser<ChoiceEvent>
