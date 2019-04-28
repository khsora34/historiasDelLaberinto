struct ConditionEvent: Event, Codable {
    let condition: Condition
    let nextStepIfTrue: String
    let nextStepIfFalse: String
    var nextStep: String? {
        return condition.evaluate() ? nextStepIfTrue: nextStepIfFalse
    }
}

typealias ConditionEventParser = YamlParser<ConditionEvent>
