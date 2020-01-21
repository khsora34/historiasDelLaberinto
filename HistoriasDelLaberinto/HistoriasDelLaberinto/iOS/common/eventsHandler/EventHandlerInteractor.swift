protocol EventHandlerInteractor {
    var fetcherProvider: DatabaseFetcherProvider { get }
    func getEvent(request: EventsHandlerModels.FetchEvent.Request) -> EventsHandlerModels.FetchEvent.Response
    func compareCondition(request: EventsHandlerModels.CompareCondition.Request) -> EventsHandlerModels.CompareCondition.Response
    func setIsVisited(request: EventsHandlerModels.SetVisited.Request) -> EventsHandlerModels.SetVisited.Response
    func buildDialogue(request: EventsHandlerModels.BuildDialogue.Request) -> EventsHandlerModels.BuildDialogue.Response
    func buildReward(request: EventsHandlerModels.BuildItems.Request) -> EventsHandlerModels.BuildItems.Response
    func buildChoice(request: EventsHandlerModels.BuildChoice.Request) -> EventsHandlerModels.BuildChoice.Response
    func buildBattle(request: EventsHandlerModels.BuildBattle.Request) -> EventsHandlerModels.BuildBattle.Response
    func performVariableModification(request: EventsHandlerModels.VariableModification.Request)
    func endGame()
}

extension EventHandlerInteractor {
    func getEvent(request: EventsHandlerModels.FetchEvent.Request) -> EventsHandlerModels.FetchEvent.Response {
        let event = fetcherProvider.eventsFetcherManager.getEvent(with: request.id)
        return EventsHandlerModels.FetchEvent.Response(event: event)
    }
    
    func compareCondition(request: EventsHandlerModels.CompareCondition.Request) -> EventsHandlerModels.CompareCondition.Response {
        let condition = request.condition
        let protagonist: Protagonist = GameSession.protagonist
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
        case .variable(let operation):
            guard let leftVariable = getVariable(named: operation.comparationVariableName) else { return false }
            let relation = operation.relation
            if let rightVariable = operation.initialVariable {
                return evaluateVariables(lhs: leftVariable.content, rhs: rightVariable, withOperator: relation)
            } else if let initialVariableName = operation.initialVariableName, let rightVariable = getVariable(named: initialVariableName) {
                return evaluateVariables(lhs: leftVariable.content, rhs: rightVariable.content, withOperator: relation)
            }
            return false
        }
    }
    
    private func evaluateVariables(lhs: VariableValue, rhs: VariableValue, withOperator relation: VariableRelation) -> Bool {
        switch (lhs.type, rhs.type) {
        case (.boolean, .boolean):
            guard let lhsBool = lhs.getBool(), let rhsBool = rhs.getBool() else { return false }
            return relation.evaluate(left: lhsBool, right: rhsBool)
        case (.integer, .integer):
            guard let lhsInt = lhs.getInt(), let rhsInt = rhs.getInt() else { return false }
            return relation.evaluate(left: lhsInt, right: rhsInt)
        case (.string, .string):
            return relation.evaluate(left: lhs.value, right: rhs.value)
        default:
            return false
        }
    }
    
    private func isRoomVisited(protagonist: Protagonist, roomId: String) -> Bool {
        let room = GameSession.rooms[roomId] ?? fetcherProvider.roomsFetcher.getRoom(with: roomId)
        if let partner = protagonist.partner, !partner.isEmpty {
            return room?.isVisitedWithPartner ?? false
        } else {
            return room?.isVisited ?? false
        }
    }
    
    func setIsVisited(request: EventsHandlerModels.SetVisited.Request) -> EventsHandlerModels.SetVisited.Response {
        let protagonist: Protagonist = GameSession.protagonist
        var room = request.room
        if let partner = protagonist.partner, !partner.isEmpty {
            room.isVisitedWithPartner = true
        } else {
            room.isVisited = true
        }
        
        GameSession.addRoom(room)
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
        let event = request.event
        var protagonist: Protagonist = GameSession.protagonist
        
        var items: [(Item, Int)] = []
        for (key, value) in event.rewards {
            if let item = fetcherProvider.itemsFetcher.getItem(with: key) {
                items.append((item, value))
                if let inventoryQuantity = protagonist.items[key] {
                    protagonist.items[key] = inventoryQuantity + value
                } else {
                    protagonist.items[key] = value
                }
            }
        }
        
        GameSession.setProtagonist(protagonist)
        
        let configurator = RewardConfigurator(message: event.message, items: items)
        return EventsHandlerModels.BuildItems.Response(configurator: configurator)
    }
    
    func buildChoice(request: EventsHandlerModels.BuildChoice.Request) -> EventsHandlerModels.BuildChoice.Response {
        let event = request.event
        let protagonist: Protagonist = GameSession.protagonist
        let filtered = event.options.filter { $0.condition == nil || evaluateCondition(for: $0.condition!, withProta: protagonist) }
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
    
    func performVariableModification(request: EventsHandlerModels.VariableModification.Request) {
        let event = request.event
        if let oldVariable = getVariable(named: event.variableId) {
            if let value = event.initialVariable {
                perform(operation: event.operation, variableToModify: oldVariable, withContent: value)
                
            } else if let secondVariableName = event.initialVariableName, let secondVariable = getVariable(named: secondVariableName) {
                perform(operation: event.operation, variableToModify: oldVariable, withContent: secondVariable.content)
            }
            
        } else if event.operation == .set {
            if let value = event.initialVariable {
                let newVariable = Variable(name: event.variableId, content: value)
                GameSession.addVariable(newVariable)
                
            } else if let secondVariableName = event.initialVariableName, let secondVariable = getVariable(named: secondVariableName) {
                let newVariable = Variable(name: event.variableId, content: secondVariable.content)
                GameSession.addVariable(newVariable)
            }
        }
    }
    
    private func getVariable(named name: String) -> Variable? {
        return GameSession.variables[name] ?? fetcherProvider.variableFetcher.getVariable(with: name)
    }
    
    private func perform(operation: VariableOperation, variableToModify: Variable, withContent newContent: VariableValue) {
        guard variableToModify.content.type == newContent.type else { return }
        let newValue = operation.performOperation(originalContent: variableToModify.content, newContent: newContent)
        GameSession.addVariable(Variable(name: variableToModify.name, content: newValue))
    }
    
    func endGame() {
        fetcherProvider.eventsFetcherManager.deleteAll()
        fetcherProvider.charactersFetcher.deleteAllCharacters()
        fetcherProvider.itemsFetcher.deleteAllItems()
        fetcherProvider.roomsFetcher.deleteAllRooms()
        fetcherProvider.movementFetcher.removeMovement()
        GameSession.restart()
    }
}
