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
            let configurator: DialogueConfigurator?
        }
    }
    enum CompareCondition {
        struct Request {
            let condition: Condition
        }
        struct Response {
            let result: Bool
        }
    }
}

enum EventsHandlerError {
    case defaultError
    case eventNotFound
    case characterNotFound
    case determinedCondition
    case custom
}
