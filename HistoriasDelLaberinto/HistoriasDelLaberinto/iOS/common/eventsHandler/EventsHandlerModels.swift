enum EventsHandlerModels {
    enum FetchEvent {
        struct Request {
            let id: String
        }
        struct Response {
            let event: Event?
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
    
    enum SetVisited {
        struct Request {
            let room: Room
        }
        struct Response {
            let room: Room
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
    
    enum BuildItems {
        struct Request {
            let event: RewardEvent
        }
        struct Response {
            let configurator: RewardConfigurator
        }
    }
    
    enum BuildChoice {
        struct Request {
            let event: ChoiceEvent
        }
        struct Response {
            let configurator: ChoiceConfigurator?
        }
    }
    
    enum BuildBattle {
        struct Request {
            let event: BattleEvent
        }
        struct Response {
            let enemy: GameCharacter?
        }
    }
}

enum EventsHandlerError {
    case defaultError
    case eventNotFound
    case characterNotFound
    case itemsNotFound
    case invalidChoiceExecution
    case reasonIsPartnerDefeated
    case custom
}
