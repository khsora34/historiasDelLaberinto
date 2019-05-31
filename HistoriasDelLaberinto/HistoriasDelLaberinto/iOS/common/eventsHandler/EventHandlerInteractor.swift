protocol EventHandlerInteractor {
    var eventFetcher: EventFetcherManager { get }
    var characterFetcher: CharacterFetcher { get }
    var protagonistFetcher: ProtagonistFetcher { get }
    func getEvent(request: EventsHandlerModels.FetchEvent.Request) -> EventsHandlerModels.FetchEvent.Response
    func buildDialogue(request: EventsHandlerModels.BuildDialogue.Request) -> EventsHandlerModels.BuildDialogue.Response
    func compareCondition(request: EventsHandlerModels.CompareCondition.Request) -> EventsHandlerModels.CompareCondition.Response
}

extension EventHandlerInteractor {
    func getEvent(request: EventsHandlerModels.FetchEvent.Request) -> EventsHandlerModels.FetchEvent.Response {
        let event = eventFetcher.getEvent(with: request.id)
        return EventsHandlerModels.FetchEvent.Response(event: event)
    }
    
    func buildDialogue(request: EventsHandlerModels.BuildDialogue.Request) -> EventsHandlerModels.BuildDialogue.Response {
        let dialogue = request.event
        
        let character = characterFetcher.getCharacter(with: dialogue.characterId)
        guard let safeCharacter = character else {
            return EventsHandlerModels.BuildDialogue.Response(configurator: nil)
        }
        
        let configurator = DialogConfigurator(name: safeCharacter.name, message: dialogue.message, imageUrl: safeCharacter.imageUrl)
        return EventsHandlerModels.BuildDialogue.Response(configurator: configurator)
    }
    
    func compareCondition(request: EventsHandlerModels.CompareCondition.Request) -> EventsHandlerModels.CompareCondition.Response {
        let condition = request.condition
        guard let prota = protagonistFetcher.getProtagonist() else {
            return EventsHandlerModels.CompareCondition.Response(result: false)
        }
        let result: Bool
        switch condition {
        case .item(let id):
            result = prota.items[id] != nil
        case .partner(let id):
            result = prota.partner == id
        }
        return EventsHandlerModels.CompareCondition.Response(result: result)
    }
}
