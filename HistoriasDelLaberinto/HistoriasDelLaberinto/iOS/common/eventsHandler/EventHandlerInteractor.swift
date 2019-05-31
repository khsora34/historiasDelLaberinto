protocol EventHandlerInteractor {
    var eventFetcher: EventFetcherManager { get }
    var characterFetcher: CharacterFetcher { get }
    func getEvent(request: EventsHandlerModels.FetchEvent.Request) -> EventsHandlerModels.FetchEvent.Response
    func buildDialogue(request: EventsHandlerModels.BuildDialogue.Request) -> EventsHandlerModels.BuildDialogue.Response
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
}
