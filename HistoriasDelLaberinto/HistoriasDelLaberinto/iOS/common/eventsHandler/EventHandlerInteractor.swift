protocol EventHandlerInteractor: ImageRemover {
    var fetcherProvider: DatabaseFetcherProvider { get }
    func getEvent(request: EventsHandlerModels.FetchEvent.Request) -> EventsHandlerModels.FetchEvent.Response
    func compareCondition(request: EventsHandlerModels.CompareCondition.Request) -> EventsHandlerModels.CompareCondition.Response
    func setIsVisited(request: EventsHandlerModels.SetVisited.Request) -> EventsHandlerModels.SetVisited.Response
    func buildDialogue(request: EventsHandlerModels.BuildDialogue.Request) -> EventsHandlerModels.BuildDialogue.Response
    func buildReward(request: EventsHandlerModels.BuildItems.Request) -> EventsHandlerModels.BuildItems.Response
    func buildChoice(request: EventsHandlerModels.BuildChoice.Request) -> EventsHandlerModels.BuildChoice.Response
    func buildBattle(request: EventsHandlerModels.BuildBattle.Request) -> EventsHandlerModels.BuildBattle.Response
    func endGame()
}

extension EventHandlerInteractor {
    func getEvent(request: EventsHandlerModels.FetchEvent.Request) -> EventsHandlerModels.FetchEvent.Response {
        let event = fetcherProvider.eventsFetcherManager.getEvent(with: request.id)
        return EventsHandlerModels.FetchEvent.Response(event: event)
    }
    
    func compareCondition(request: EventsHandlerModels.CompareCondition.Request) -> EventsHandlerModels.CompareCondition.Response {
        let condition = request.condition
        guard let protagonist = fetcherProvider.charactersFetcher.getCharacter(with: "protagonist") as? Protagonist else {
            return EventsHandlerModels.CompareCondition.Response(result: false)
        }
        
        let result: Bool = evaluateCondition(for: condition, withProta: protagonist)
        
        return EventsHandlerModels.CompareCondition.Response(result: result)
    }
    
    private func evaluateCondition(for condition: Condition, withProta protagonist: Protagonist) -> Bool {
        switch condition {
        case .item(let id):
            return protagonist.items[id] != nil
        case .partner(let id):
            return protagonist.partner == id
        case .roomVisited(let id):
            return isRoomVisited(protagonist: protagonist, roomId: id)
        case .roomNotVisited(let id):
            return !isRoomVisited(protagonist: protagonist, roomId: id)
        }
    }
    
    private func isRoomVisited(protagonist: Protagonist, roomId: String) -> Bool {
        let room = fetcherProvider.roomsFetcher.getRoom(with: roomId)
        if let partner = protagonist.partner, !partner.isEmpty {
            return room?.isVisitedWithPartner ?? false
        } else {
            return room?.isVisited ?? false
        }
    }
    
    func setIsVisited(request: EventsHandlerModels.SetVisited.Request) -> EventsHandlerModels.SetVisited.Response {
        guard let prota = fetcherProvider.charactersFetcher.getCharacter(with: "protagonist") as? Protagonist else {
            return EventsHandlerModels.SetVisited.Response(room: request.room)
        }
        var room = request.room
        if let partner = prota.partner, !partner.isEmpty {
            room.isVisitedWithPartner = true
        } else {
            room.isVisited = true
        }
        
        _ = fetcherProvider.roomsFetcher.saveRoom(for: room, with: room.id)
        return EventsHandlerModels.SetVisited.Response(room: room)
    }
    
    func buildDialogue(request: EventsHandlerModels.BuildDialogue.Request) -> EventsHandlerModels.BuildDialogue.Response {
        let dialogue = request.event
        
        let character = fetcherProvider.charactersFetcher.getCharacter(with: dialogue.characterId)
        guard let safeCharacter = character else {
            return EventsHandlerModels.BuildDialogue.Response(configurator: nil)
        }
        
        let configurator = DialogueConfigurator(name: safeCharacter.name, message: dialogue.message, imageSource: safeCharacter.imageSource)
        return EventsHandlerModels.BuildDialogue.Response(configurator: configurator)
    }
    
    func buildReward(request: EventsHandlerModels.BuildItems.Request) -> EventsHandlerModels.BuildItems.Response {
        var protagonist = fetcherProvider.charactersFetcher.getCharacter(with: "protagonist") as? Protagonist
        let event = request.event
        
        var items: [(Item, Int)] = []
        for (key, value) in event.rewards {
            if let item = fetcherProvider.itemsFetcher.getItem(with: key) {
                items.append((item, value))
                if let inventoryQuantity = protagonist?.items[key] {
                    protagonist?.items[key] = inventoryQuantity + value
                } else {
                    protagonist?.items[key] = value
                }
            }
        }
        if let protagonist = protagonist {
            _ = fetcherProvider.charactersFetcher.saveCharacter(for: protagonist, with: "protagonist")
        }
        
        let configurator = RewardConfigurator(name: "", message: event.message, items: items)
        return EventsHandlerModels.BuildItems.Response(configurator: configurator)
    }
    
    func buildChoice(request: EventsHandlerModels.BuildChoice.Request) -> EventsHandlerModels.BuildChoice.Response {
        let event = request.event
        guard let prota = fetcherProvider.charactersFetcher.getCharacter(with: "protagonist") as? Protagonist else {
            return EventsHandlerModels.BuildChoice.Response(configurator: nil)
        }
        let filtered = event.options.filter {
            $0.condition == nil || evaluateCondition(for: $0.condition!, withProta: prota)
        }
        let configurator = ChoiceConfigurator(actions: filtered)
        return EventsHandlerModels.BuildChoice.Response(configurator: configurator)
    }
    
    func buildBattle(request: EventsHandlerModels.BuildBattle.Request) -> EventsHandlerModels.BuildBattle.Response {
        let enemyId = request.event.enemyId
        guard let enemy = fetcherProvider.charactersFetcher.getCharacter(with: enemyId) else {
            return EventsHandlerModels.BuildBattle.Response(enemy: nil)
        }
        return EventsHandlerModels.BuildBattle.Response(enemy: enemy)
    }
    
    func endGame() {
        fetcherProvider.eventsFetcherManager.deleteAll()
        fetcherProvider.charactersFetcher.deleteAllCharacters()
        fetcherProvider.itemsFetcher.deleteAllItems()
        fetcherProvider.roomsFetcher.deleteAllRooms()
        fetcherProvider.movementFetcher.removeMovement()
        removeImageCache()
    }
}
