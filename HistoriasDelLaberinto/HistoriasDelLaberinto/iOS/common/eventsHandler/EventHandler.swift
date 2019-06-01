protocol EventHandler: class, ConditionEvaluator {
    var eventHandlerRouter: EventHandlerRoutingLogic? { get }
    var eventHandlerInteractor: EventHandlerInteractor? { get }
    var dialog: DialogDisplayLogic? { get set }
    var actualEvent: Event? { get set }
    func startEvent(with id: String)
    func continueFlow()
    func showError(_ error: EventsHandlerError)
}

// MARK: - Flow

extension EventHandler {
    func startEvent(with id: String) {
        guard let event = getEventInfo(with: id), let eventType = EventType(event: event) else {
            showError(.eventNotFound)
            return
        }
        
        if let condition = event as? ConditionEvent {
            startEvent(with: condition.nextStep(evaluator: self))
            return
        }
        
        actualEvent = event
        
        determineAction(type: eventType)
    }
    
    func continueFlow() {
        guard let nextStep = actualEvent?.nextStep, !nextStep.isEmpty else {
            finishFlow()
            return
        }
        startEvent(with: nextStep)
    }
    
    private func finishFlow() {
        finishDialog()
    }
    
    private func finishDialog() {
        eventHandlerRouter?.dismiss(animated: true)
        dialog = nil
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
        case .condition:
            showError(.determinedCondition)
        default:
            fatalError()
        }
    }
    
    private func showDialogue(_ event: DialogueEvent) {
        guard let configurator = getDialogueConfigurator(dialogue: event) else {
            showError(.characterNotFound)
            return
        }
        
        if dialog == nil {
            dialog = Dialog.createDialogue(configurator, delegate: self)
            eventHandlerRouter?.present(dialog!, animated: true)
        } else {
            dialog?.setNextConfigurator(newConfigurator: configurator)
        }
    }
    
    private func showReward(_ event: RewardEvent) {
        guard let configurator = getRewardConfigurator(reward: event) else {
            showError(.missingItems)
            return
        }
        if dialog == nil {
            dialog = Dialog.createReward(configurator, delegate: self)
            eventHandlerRouter?.present(dialog!, animated: true)
        } else {
            dialog?.setNextConfigurator(newConfigurator: configurator)
        }
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
    
    private func compare(with condition: Condition) -> Bool {
        guard let interactor = eventHandlerInteractor else { return false }
        let request = EventsHandlerModels.CompareCondition.Request(condition: condition)
        let response = interactor.compareCondition(request: request)
        return response.result
    }
    
    private func getRewardConfigurator(reward: RewardEvent) -> RewardConfigurator? {
        guard let interactor = eventHandlerInteractor else { return nil }
        let request = EventsHandlerModels.BuildItems.Request(event: reward)
        let response = interactor.buildReward(request: request)
        return response.configurator
    }
}

// MARK: - Error

extension EventHandler {
    func showError(_ error: EventsHandlerError) {
        actualEvent = nil
        switch error {
        case .eventNotFound:
            let errorEvent = DialogueEvent(characterId: "Cisco", message: "This event doesn't seem to be available. Sorry for the inconveniences!", nextStep: nil)
            showErrorDialogue(errorEvent)
        case .characterNotFound:
            let errorEvent = DialogueEvent(characterId: "Cisco", message: "It seems we encountered a problem showing the character. So sorry for that.", nextStep: nil)
            showErrorDialogue(errorEvent)
        case .defaultError:
            let errorEvent = DialogueEvent(characterId: "Cisco", message: "An error ocurred, sorry about that...", nextStep: nil)
            showErrorDialogue(errorEvent)
        case .determinedCondition:
            let errorEvent = DialogueEvent(characterId: "Cisco", message: "It seems the condition went way too far.", nextStep: nil)
            showErrorDialogue(errorEvent)
        case .missingItems:
            let errorEvent = DialogueEvent(characterId: "Cisco", message: "There was a problem finding the items rewarded. Sorry for that...", nextStep: nil)
            showErrorDialogue(errorEvent)
        case .custom:
            fatalError()
        }
    }
    
    func showErrorDialogue(_ event: DialogueEvent) {
        actualEvent = event
        let configurator = DialogueConfigurator(name: event.characterId, message: event.message, imageUrl: "cisco")
        
        if dialog == nil {
            dialog = Dialog.createDialogue(configurator, delegate: self)
            eventHandlerRouter?.present(dialog!, animated: true)
        } else {
            dialog?.setNextConfigurator(newConfigurator: configurator)
        }
    }
}

extension EventHandler {
    func evaluate(_ condition: Condition) -> Bool {
        return compare(with: condition)
    }
}
