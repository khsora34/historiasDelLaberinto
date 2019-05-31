enum EventsHandlerModels {
    enum FetchEvent {
        struct Request {
            let id: String
        }
        struct Response {
            let event: Event?
        }
    }
    enum BuildDialogue {
        struct Request {
            let event: DialogueEvent
        }
        struct Response {
            let configurator: DialogConfigurator?
        }
    }
}

enum EventsHandlerError {
    case defaultError
    case eventNotFound
    case characterNotFound
    case custom
}
