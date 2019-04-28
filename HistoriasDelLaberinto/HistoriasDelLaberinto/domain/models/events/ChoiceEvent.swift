struct ChoiceEvent: Event, Codable {
    let options: [Action]
    let nextStep: String? = nil
}

typealias ChoiceEventParser = YamlParser<ChoiceEvent>
