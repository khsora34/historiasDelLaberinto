protocol EventHandlerInteractor {
    var eventFetcher: EventFetcherManager { get }
    var characterFetcher: CharacterFetcher { get }
    var protagonistFetcher: ProtagonistFetcher { get }
    var itemFetcher: ItemFetcher { get }
    func getEvent(request: EventsHandlerModels.FetchEvent.Request) -> EventsHandlerModels.FetchEvent.Response
    func compareCondition(request: EventsHandlerModels.CompareCondition.Request) -> EventsHandlerModels.CompareCondition.Response
    func buildDialogue(request: EventsHandlerModels.BuildDialogue.Request) -> EventsHandlerModels.BuildDialogue.Response
    func buildReward(request: EventsHandlerModels.BuildItems.Request) -> EventsHandlerModels.BuildItems.Response
    func buildChoice(request: EventsHandlerModels.BuildChoice.Request) -> EventsHandlerModels.BuildChoice.Response
}

extension EventHandlerInteractor {
    func getEvent(request: EventsHandlerModels.FetchEvent.Request) -> EventsHandlerModels.FetchEvent.Response {
        let event = eventFetcher.getEvent(with: request.id)
        return EventsHandlerModels.FetchEvent.Response(event: event)
    }
    
    func compareCondition(request: EventsHandlerModels.CompareCondition.Request) -> EventsHandlerModels.CompareCondition.Response {
        let condition = request.condition
        guard let prota = protagonistFetcher.getProtagonist() else {
            return EventsHandlerModels.CompareCondition.Response(result: false)
        }
        
        let result = evaluateConditions(for: condition, with: prota)
        
        return EventsHandlerModels.CompareCondition.Response(result: result)
    }
    
    private func evaluateConditions(for condition: Condition, with protagonist: Protagonist) -> Bool {
        switch condition {
        case .item(let id):
            return protagonist.items[id] != nil
        case .partner(let id):
            return protagonist.partner == id
        case .roomVisited(let id):
            if protagonist.partner != nil {
                return protagonist.visitedRooms[id]?.isVisitedWithPartner ?? false
            } else {
                return protagonist.visitedRooms[id]?.isVisited ?? false
            }
        }
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
    
    func buildChoice(request: EventsHandlerModels.BuildChoice.Request) -> EventsHandlerModels.BuildChoice.Response {
        let event = request.event
        guard let prota = protagonistFetcher.getProtagonist() else {
            return EventsHandlerModels.BuildChoice.Response(configurator: nil)
        }
        let filtered = event.options.filter {
            $0.condition == nil || evaluateConditions(for: $0.condition!, with: prota)
        }
        let configurator = ChoiceConfigurator(actions: filtered)
        return EventsHandlerModels.BuildChoice.Response(configurator: configurator)
    }
}
