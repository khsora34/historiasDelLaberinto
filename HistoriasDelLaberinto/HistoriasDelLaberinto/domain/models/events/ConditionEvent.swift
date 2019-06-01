struct ConditionEvent: Event, Codable {
    let condition: Condition
    let nextStepIfTrue: String
    let nextStepIfFalse: String
    let nextStep: String? = ""
    
    func nextStep(evaluator: ConditionEvaluator) -> String {
        return condition.evaluate(evaluator: evaluator) ? nextStepIfTrue: nextStepIfFalse
    }
}

typealias ConditionEventParser = YamlParser<ConditionEvent>
