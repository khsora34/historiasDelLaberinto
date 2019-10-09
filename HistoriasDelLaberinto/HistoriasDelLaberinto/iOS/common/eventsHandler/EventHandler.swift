protocol EventHandler: ConditionEvaluator, NextDialogHandler, BattleBuilderDelegate {
    var eventHandlerRouter: EventHandlerRoutingLogic? { get }
    var eventHandlerInteractor: EventHandlerInteractor? { get }
    var room: Room { get set }
    var dialog: DialogDisplayLogic? { get set }
    var actualEvent: Event? { get set }
    var shouldSetVisitedWhenFinished: Bool { get set }
    var shouldEndGameWhenFinished: Bool { get set }
    func startEvent(with id: String)
    func onFinish()
    func showError(_ error: EventsHandlerError)
}

// MARK: - Flow

extension EventHandler {
    func startEvent(with id: String) {
        guard let event = getEventInfo(with: id) else {
            showError(.eventNotFound)
            return
        }
        
        updateVisitedStatus(event: event)
        updateEndgameStatus(event: event)
        
        actualEvent = event
        determineAction(type: EventType(event: event))
    }
    
    private func updateVisitedStatus(event: Event) {
        if !shouldSetVisitedWhenFinished, event.shouldSetVisited == true {
            shouldSetVisitedWhenFinished = true
        }
    }
    
    private func updateEndgameStatus(event: Event) {
        if !shouldEndGameWhenFinished, event.shouldEndGame == true {
            shouldEndGameWhenFinished = true
        }
    }
    
    func continueFlow() {
        if actualEvent is ChoiceEvent { return }
        
        guard let nextStep = actualEvent?.nextStep, !nextStep.isEmpty else {
            finishFlow()
            return
        }
        
        startEvent(with: nextStep)
    }
    
    private func finishFlow() {
        hideDialog()
        
        guard !shouldEndGameWhenFinished else {
            shouldEndGame()
            return
        }
        
        if shouldSetVisitedWhenFinished, let interactor = eventHandlerInteractor {
            let request = EventsHandlerModels.SetVisited.Request(room: room)
            let response = interactor.setIsVisited(request: request)
            self.room = response.room
        }
        onFinish()
    }
    
    func elementSelected(id: Int) {
        performChoice(tag: id)
    }
    
    private func performChoice(tag: Int) {
        guard let event = actualEvent as? ChoiceEvent else {
            showError(.invalidChoiceExecution)
            return
        }
        guard let nextStep = event.options[tag].nextStep, !nextStep.isEmpty else {
            finishFlow()
            return
        }
        startEvent(with: nextStep)
    }
}

// MARK: - Determiner

extension EventHandler {
    private func determineAction(type: EventType) {
        switch type {
        case .dialogue:
            showDialogue(actualEvent as! DialogueEvent)
        case .reward:
            showReward(actualEvent as! RewardEvent)
        case .choice:
            showChoice(actualEvent as! ChoiceEvent)
        case .condition:
            evaluateCondition(actualEvent as! ConditionEvent)
        case .battle:
            showBattle(actualEvent as! BattleEvent)
        case .unknown:
            print("Unable to determine action for unknown type.")
        }
    }
    
    private func showDialogue(_ event: DialogueEvent) {
        guard let configurator = getDialogueConfigurator(dialogue: event) else {
            showError(.characterNotFound)
            return
        }
        
        showDialog(with: configurator)
    }
    
    private func showReward(_ event: RewardEvent) {
        guard let configurator = getRewardConfigurator(reward: event) else {
            showError(.itemsNotFound)
            return
        }
        
        showDialog(with: configurator)
    }
    
    private func evaluateCondition(_ event: ConditionEvent) {
        let nextStep = event.nextStep(evaluator: self)
        if !nextStep.isEmpty {
            startEvent(with: nextStep)
        } else {
            finishFlow()
        }
    }
    
    private func showChoice(_ event: ChoiceEvent) {
        guard let configurator = getChoiceConfigurator(choice: event) else {
            showError(.characterNotFound)
            return
        }
        showDialog(with: configurator)
    }
    
    private func showBattle(_ event: BattleEvent) {
        guard let enemy = getBattle(event) else {
            showError(.characterNotFound)
            return
        }
        hideDialog()
        eventHandlerRouter?.goToBattle(with: enemy, with: self)
    }
}

// MARK: - Interactor access

extension EventHandler {
    private func getEventInfo(with id: String) -> Event? {
        guard let interactor = eventHandlerInteractor else { return nil }
        let request = EventsHandlerModels.FetchEvent.Request(id: id)
        let response = interactor.getEvent(request: request)
        return response.event
    }
    
    private func getDialogueConfigurator(dialogue: DialogueEvent) -> DialogueConfigurator? {
        guard let interactor = eventHandlerInteractor else { return nil }
        let request = EventsHandlerModels.BuildDialogue.Request(event: dialogue)
        let response = interactor.buildDialogue(request: request)
        return response.configurator
    }
    
    private func getRewardConfigurator(reward: RewardEvent) -> RewardConfigurator? {
        guard let interactor = eventHandlerInteractor else { return nil }
        let request = EventsHandlerModels.BuildItems.Request(event: reward)
        let response = interactor.buildReward(request: request)
        return response.configurator
    }
    
    private func getChoiceConfigurator(choice: ChoiceEvent) -> ChoiceConfigurator? {
        guard let interactor = eventHandlerInteractor else { return nil }
        let request = EventsHandlerModels.BuildChoice.Request(event: choice)
        let response = interactor.buildChoice(request: request)
        guard let actions = response.configurator?.actions, !actions.isEmpty else { return nil }
        actualEvent = ChoiceEvent(id: choice.id, options: actions, shouldSetVisited: choice.shouldSetVisited, shouldEndGame: choice.shouldEndGame)
        return response.configurator
    }
    
    private func getBattle(_ battle: BattleEvent) -> PlayableCharacter? {
        guard let interactor = eventHandlerInteractor else { return nil }
        let request = EventsHandlerModels.BuildBattle.Request(event: battle)
        let response = interactor.buildBattle(request: request)
        guard let enemy = response.enemy as? PlayableCharacter else { return nil }
        actualEvent = battle
        return enemy
    }
}

// MARK: - Error

extension EventHandler {
    func showError(_ error: EventsHandlerError) {
        actualEvent = nil
        switch error {
        case .eventNotFound:
            let errorEvent = DialogueEvent(id: "-1", characterId: "Cisco", message: "This event doesn't seem to be available. Sorry for the inconveniences!", shouldSetVisited: false, shouldEndGame: true, nextStep: nil)
            showErrorDialogue(errorEvent)
        case .characterNotFound:
            let errorEvent = DialogueEvent(id: "-1", characterId: "Cisco", message: "It seems we encountered a problem showing the character. So sorry for that.", shouldSetVisited: false, shouldEndGame: true, nextStep: nil)
            showErrorDialogue(errorEvent)
        case .defaultError:
            let errorEvent = DialogueEvent(id: "-1", characterId: "Cisco", message: "An error ocurred, sorry about that...", shouldSetVisited: false, shouldEndGame: true, nextStep: nil)
            showErrorDialogue(errorEvent)
        case .itemsNotFound:
            let errorEvent = DialogueEvent(id: "-1", characterId: "Cisco", message: "There was a problem finding the items rewarded. Sorry for that...", shouldSetVisited: false, shouldEndGame: true, nextStep: nil)
            showErrorDialogue(errorEvent)
        case .invalidChoiceExecution:
            let errorEvent = DialogueEvent(id: "-1", characterId: "Cisco", message: "The function for a choice was executed without asking for it.", shouldSetVisited: false, shouldEndGame: true, nextStep: nil)
            showErrorDialogue(errorEvent)
        case .reasonIsPartnerDefeated:
            let errorEvent = DialogueEvent(id: "-1", characterId: "Cisco", message: "It seems you finished a battle because your partner was defeated.", shouldSetVisited: false, shouldEndGame: true, nextStep: nil)
            showErrorDialogue(errorEvent)
        case .custom:
            fatalError()
        }
    }
    
    func showErrorDialogue(_ event: DialogueEvent) {
        actualEvent = event
        let configurator = DialogueConfigurator(name: event.characterId, message: event.message, imageUrl: "cisco")
        
        if dialog == nil {
            dialog = Dialog.createDialog(configurator, delegate: self)
            eventHandlerRouter?.present(dialog!, animated: true)
        } else {
            dialog?.setNextConfigurator(configurator)
        }
    }
}

extension EventHandler {
    func evaluate(_ condition: Condition) -> Bool {
        guard let interactor = eventHandlerInteractor else { return false }
        let request = EventsHandlerModels.CompareCondition.Request(condition: condition)
        let response = interactor.compareCondition(request: request)
        return response.result
    }
}

extension EventHandler {
    func onBattleFinished(reason: FinishedBattleReason) {
        switch reason {
        case .defeated(.protagonist):
            guard let nextStep = (actualEvent as? BattleEvent)?.loseStep, !nextStep.isEmpty else {
                finishFlow()
                return
            }
            startEvent(with: nextStep)
        case .defeated(.enemy):
            guard let nextStep = (actualEvent as? BattleEvent)?.winStep, !nextStep.isEmpty else {
                finishFlow()
                return
            }
            startEvent(with: nextStep)
        case .defeated(.partner):
            showError(.reasonIsPartnerDefeated)
        }
    }
    
    private func shouldEndGame() {
        eventHandlerInteractor?.endGame()
        eventHandlerRouter?.endGame()
    }
}

// MARK: - Show dialog

extension EventHandler {
    func showDialog(with configurator: DialogConfigurator) {
        if dialog == nil {
            dialog = Dialog.createDialog(configurator, delegate: self)
            eventHandlerRouter?.present(dialog!, animated: true)
        } else {
            dialog?.setNextConfigurator(configurator)
        }
    }
    
    func hideDialog() {
        dialog = nil
        eventHandlerRouter?.dismiss(animated: true)
    }
}
