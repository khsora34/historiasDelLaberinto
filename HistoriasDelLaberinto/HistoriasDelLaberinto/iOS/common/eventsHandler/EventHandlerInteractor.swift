protocol EventHandlerInteractor {
    var eventFetcher: EventFetcherManager { get }
    var characterFetcher: CharacterFetcher { get }
    var protagonistFetcher: ProtagonistFetcher { get }
    var itemFetcher: ItemFetcher { get }
    func getEvent(request: EventsHandlerModels.FetchEvent.Request) -> EventsHandlerModels.FetchEvent.Response
    func buildDialogue(request: EventsHandlerModels.BuildDialogue.Request) -> EventsHandlerModels.BuildDialogue.Response
    func compareCondition(request: EventsHandlerModels.CompareCondition.Request) -> EventsHandlerModels.CompareCondition.Response
    func buildReward(request: EventsHandlerModels.BuildItems.Request) -> EventsHandlerModels.BuildItems.Response
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
        
        let configurator = DialogueConfigurator(name: safeCharacter.name, message: dialogue.message, imageUrl: safeCharacter.imageUrl)
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
    
    func buildReward(request: EventsHandlerModels.BuildItems.Request) -> EventsHandlerModels.BuildItems.Response {
        var protagonist = protagonistFetcher.getProtagonist()
        let event = request.event
        
        var items: [(Item, Int)] = []
        for (key, value) in event.rewards {
            if let item = itemFetcher.getItem(with: key) {
                items.append((item, value))
                if let inventoryQuantity = protagonist?.items[key] {
                    protagonist?.items[key] = inventoryQuantity + value
                } else {
                    protagonist?.items[key] = value
                }
            }
        }
        if let protagonist = protagonist {
            _ = protagonistFetcher.saveProtagonist(for: protagonist)
        }
        
        let configurator = RewardConfigurator(name: "", message: event.message, items: items)
        return EventsHandlerModels.BuildItems.Response(configurator: configurator)
    }
}
