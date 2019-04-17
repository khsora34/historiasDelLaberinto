import Yams

class EventParser: Parser {
    typealias Parseable = EventsFile
    
    func serialize(_ responseString: String) -> Parseable? {
        var events: [String: Event] = [:]
        guard let yamlMapping = try? Yams.compose(yaml: responseString)?.mapping else { return nil }
        for (eventId, event) in yamlMapping.makeIterator() {
            if let eventIdString = eventId.scalar?.string, let eventValues = event.mapping, let mode = eventValues["mode"]?.scalar?.string, let eventType = EventType(rawValue: mode) {
                let builder = EventBuilder(node: event, type: eventType)
                events[eventIdString] = builder.getEvent()
            }
        }
        return EventsFile(events: events)
    }
    
    func deserialize(_ parseable: Parseable) -> String? {
        return nil
    }
}
