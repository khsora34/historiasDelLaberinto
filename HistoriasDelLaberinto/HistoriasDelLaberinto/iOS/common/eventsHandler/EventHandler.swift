protocol EventHandler: class, Evaluator {
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
        actualEvent = event
        
        determineAction(type: eventType)
    }
    
    func continueFlow() {
        guard let nextStep = actualEvent?.nextStep else {
            finishFlow()
            return
        }
        startEvent(with: nextStep)
    }
    
    private func finishFlow() {
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
            dialog = Dialog.createDialog(with: configurator, delegate: self)
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
    
    private func getDialogueConfigurator(dialogue: DialogueEvent) -> DialogConfigurator? {
        guard let interactor = eventHandlerInteractor else { return nil }
        let request = EventsHandlerModels.BuildDialogue.Request(event: dialogue)
        let response = interactor.buildDialogue(request: request)
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
        case .custom:
            fatalError()
        }
    }
    
    func showErrorDialogue(_ event: DialogueEvent) {
        actualEvent = event
        let configurator = DialogConfigurator(name: event.characterId, message: event.message, imageUrl: "cisco")
        
        if dialog == nil {
            dialog = Dialog.createDialog(with: configurator, delegate: self)
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
