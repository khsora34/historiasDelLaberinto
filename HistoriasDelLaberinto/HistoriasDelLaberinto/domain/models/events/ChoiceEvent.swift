struct ChoiceEvent: Event, Codable {
    var options: [Action]
    let shouldSetVisited: Bool?
    let nextStep: String? = nil
}

typealias ChoiceEventParser = YamlParser<ChoiceEvent>
