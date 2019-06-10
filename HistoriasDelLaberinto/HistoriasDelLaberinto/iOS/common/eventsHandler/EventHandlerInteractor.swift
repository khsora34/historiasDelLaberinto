protocol EventHandlerInteractor: ImageRemover {
    var fetcherProvider: DatabaseFetcherProvider { get }
    func getEvent(request: EventsHandlerModels.FetchEvent.Request) -> EventsHandlerModels.FetchEvent.Response
    func compareCondition(request: EventsHandlerModels.CompareCondition.Request) -> EventsHandlerModels.CompareCondition.Response
    func setIsVisited(request: EventsHandlerModels.SetVisited.Request)
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
        guard let prota = fetcherProvider.protagonistFetcher.getProtagonist() else {
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
            if let partner = protagonist.partner, !partner.isEmpty {
                return protagonist.visitedRooms[id]?.isVisitedWithPartner ?? false
            } else {
                return protagonist.visitedRooms[id]?.isVisited ?? false
            }
        case .roomNotVisited(let id):
            if let partner = protagonist.partner, !partner.isEmpty {
                return !(protagonist.visitedRooms[id]?.isVisitedWithPartner ?? false)
            } else {
                return !(protagonist.visitedRooms[id]?.isVisited ?? false)
            }
            
        }
    }
    
    func setIsVisited(request: EventsHandlerModels.SetVisited.Request) {
        guard var prota = fetcherProvider.protagonistFetcher.getProtagonist() else { return }
        if prota.visitedRooms[request.roomId] == nil {
            prota.visitedRooms[request.roomId] = VisitedRoom(isVisited: false, isVisitedWithPartner: false)
        }
        if let partner = prota.partner, !partner.isEmpty {
            prota.visitedRooms[request.roomId]?.isVisitedWithPartner = true
        } else {
            prota.visitedRooms[request.roomId]?.isVisited = true
        }
        
        _ = fetcherProvider.protagonistFetcher.saveProtagonist(for: prota)
    }
    
    func buildDialogue(request: EventsHandlerModels.BuildDialogue.Request) -> EventsHandlerModels.BuildDialogue.Response {
        let dialogue = request.event
        
        let character = fetcherProvider.charactersFetcher.getCharacter(with: dialogue.characterId)
        guard let safeCharacter = character else {
            return EventsHandlerModels.BuildDialogue.Response(configurator: nil)
        }
        
        let configurator = DialogueConfigurator(name: safeCharacter.name, message: dialogue.message, imageUrl: safeCharacter.imageUrl)
        return EventsHandlerModels.BuildDialogue.Response(configurator: configurator)
    }
    
    func buildReward(request: EventsHandlerModels.BuildItems.Request) -> EventsHandlerModels.BuildItems.Response {
        var protagonist = fetcherProvider.protagonistFetcher.getProtagonist()
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
            _ = fetcherProvider.protagonistFetcher.saveProtagonist(for: protagonist)
        }
        
        let configurator = RewardConfigurator(name: "", message: event.message, items: items)
        return EventsHandlerModels.BuildItems.Response(configurator: configurator)
    }
    
    func buildChoice(request: EventsHandlerModels.BuildChoice.Request) -> EventsHandlerModels.BuildChoice.Response {
        let event = request.event
        guard let prota = fetcherProvider.protagonistFetcher.getProtagonist() else {
            return EventsHandlerModels.BuildChoice.Response(configurator: nil)
        }
        let filtered = event.options.filter {
            $0.condition == nil || evaluateConditions(for: $0.condition!, with: prota)
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
        fetcherProvider.protagonistFetcher.deleteProtagonist()
        fetcherProvider.roomsFetcher.deleteAllRooms()
        fetcherProvider.movementFetcher.removeMovement()
        removeImageCache()
    }
}

