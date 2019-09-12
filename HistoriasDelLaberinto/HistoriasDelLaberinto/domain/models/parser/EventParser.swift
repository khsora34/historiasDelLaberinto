import Yams

class EventParser: Parser {
    typealias Parseable = EventsFile
    
    func serialize(_ responseString: String) -> Parseable? {
        var events: [Event] = []
        guard let yamlMapping = try? Yams.compose(yaml: responseString)?.sequence else { return nil }
        for event in yamlMapping.makeIterator() {
            if let eventValues = event.mapping, let mode = eventValues["mode"]?.scalar?.string, let eventType = EventType(rawValue: mode) {
                let builder = EventBuilder(node: event, type: eventType)
                if let newEvent = builder.getEvent() {
                    events.append(newEvent)
                }
            }
        }
        return EventsFile(events: events)
    }
    
    func deserialize(_ parseable: Parseable) -> String? {
        return nil
    }
}
