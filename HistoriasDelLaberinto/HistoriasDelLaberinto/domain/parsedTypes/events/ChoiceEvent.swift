struct ChoiceEvent: Event {
    let id: String
    let options: [(action: String, nextStep: String)]
}
