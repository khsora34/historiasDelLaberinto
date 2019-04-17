struct ConditionEvent: Event, Codable {
    let id: String
    let condition: Condition
    let nextStepIfTrue: String
    let nextStepIfFalse: String
    var nextStep: String {
        return condition.evaluate() ? nextStepIfTrue: nextStepIfFalse
    }
}
