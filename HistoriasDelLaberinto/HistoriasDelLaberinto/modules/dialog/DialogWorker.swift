class DialogWorker {
    func getCharacterId(from event: Event) -> String? {
        switch EventType(event: event) {
        case .dialogue?:
            guard let event = event as? DialogueEvent else { return nil }
            return event.characterId
        default: fatalError()
        }
    }
    
    func extractMessage(event: Event) -> String {
        switch EventType(event: event) {
        case .dialogue?:
            guard let event = event as? DialogueEvent else { return "" }
            return event.message
        default:
            fatalError()
        }
    }
}
