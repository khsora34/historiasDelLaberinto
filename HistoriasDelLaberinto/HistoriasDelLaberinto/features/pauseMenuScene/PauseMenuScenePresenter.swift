protocol PauseMenuScenePresentationLogic: Presenter {
    func performOption(tag: Int)
}

class PauseMenuScenePresenter: BasePresenter {
    var viewController: PauseMenuSceneDisplayLogic? {
        return _viewController as? PauseMenuSceneDisplayLogic
    }
    
    var interactor: PauseMenuSceneBusinessLogic? {
        return _interactor as? PauseMenuSceneInteractor
    }
    
    var router: PauseMenuSceneRoutingLogic? {
        return _router as? PauseMenuSceneRoutingLogic
    }
    
    private var protagonist: Protagonist
    private var partner: PlayableCharacter?
    private var actualWeapons: [String: Weapon] = [:]
    
    private var characterModels: [CharacterChosen: StatusViewModel] = [:]
    
    override init() {
        self.protagonist = GameSession.protagonist
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let partnerId = protagonist.partner {
            partner = interactor?.getPartner(request: PauseMenuScene.CharacterGetter.Request(id: partnerId)).character
        }
        getWeapons()
        buildCharacters()
        createOptions()
    }
}

extension PauseMenuScenePresenter {
    private func getWeapons() {
        let weapons = [protagonist.weapon, partner?.weapon].compactMap({$0})
        var actualWeapons: [String: Weapon] = [:]
        for weaponId in weapons {
            let request = PauseMenuScene.WeaponGetter.Request(id: weaponId)
            let response = interactor?.getWeapon(request: request)
            actualWeapons[weaponId] = response?.weapon
        }
        self.actualWeapons = actualWeapons
    }
}

extension PauseMenuScenePresenter {
    private func buildCharacters() {
        let protagonistModel = StatusViewModel(chosenCharacter: .protagonist, name: protagonist.name, ailment: protagonist.currentStatusAilment, actualHealth: protagonist.currentHealthPoints, maxHealth: protagonist.maxHealthPoints, imageSource: protagonist.portraitSource, isEnemy: false, delegate: nil)
        var charactersForStatus: [StatusViewModel] = [protagonistModel]
        if let partner = partner {
            let partnerModel = StatusViewModel(chosenCharacter: .partner, name: partner.name, ailment: partner.currentStatusAilment, actualHealth: partner.currentHealthPoints, maxHealth: partner.maxHealthPoints, imageSource: partner.portraitSource, isEnemy: false, delegate: nil)
            charactersForStatus.append(partnerModel)
            characterModels[.partner] = partnerModel
        }
        
        viewController?.addCharactersStatus(charactersForStatus)
    }
    
    private func updateCharacterModel(chosen: CharacterChosen, model: StatusViewModel) {
        viewController?.updateStatusView(model)
        characterModels[chosen] = model
    }
    
    private func createOptions() {
        let availableOptions: [MenuOption] = [.items, .save, .exit]
        let transformed = availableOptions.map { return (Localizer.localizedString(key: $0.optionKey), $0.rawValue) }
        viewController?.createOptions(with: transformed)
    }
    
    private func showExitMessage() {
        if GameSession.isDataSynced {
            self.router?.endGame()
        } else {
            viewController?.showAlert(title: nil, message: Localizer.localizedString(key: "menuExitPrompt"), actions: [
                (title: Localizer.localizedString(key: "genericRiskOption"), style: .default, completion: { [weak self] in
                    self?.router?.endGame()
                }),
                (title: Localizer.localizedString(key: "genericThinkAboutItOption"), style: .cancel, completion: nil)
            ])
        }
    }
}

extension PauseMenuScenePresenter: PauseMenuScenePresentationLogic {
    func performOption(tag: Int) {
        guard let option = MenuOption(rawValue: tag) else { return }
        switch option {
        case .save:
            interactor?.saveContext()
            viewController?.showAlert(title: nil, message: Localizer.localizedString(key: "successfullySavedGame"), actions: [(title: Localizer.localizedString(key: "genericButtonAccept"), style: .default, completion: nil)])
        case .exit:
            showExitMessage()
        case .items:
            router?.goToItemsView(protagonist: protagonist, partner: partner, delegate: self)
        }
    }
}

extension PauseMenuScenePresenter: CharactersUpdateDelegate {
    func update(with protagonist: Protagonist, and partner: PlayableCharacter?) {
        self.protagonist = protagonist
        self.partner = partner
        let protagonistModel = StatusViewModel(chosenCharacter: .protagonist, name: protagonist.name, ailment: protagonist.currentStatusAilment, actualHealth: protagonist.currentHealthPoints, maxHealth: protagonist.maxHealthPoints, imageSource: protagonist.portraitSource, isEnemy: false, delegate: nil)
        updateCharacterModel(chosen: .protagonist, model: protagonistModel)
        if let partner = partner {
            let partnerModel = StatusViewModel(chosenCharacter: .partner, name: partner.name, ailment: partner.currentStatusAilment, actualHealth: partner.currentHealthPoints, maxHealth: partner.maxHealthPoints, imageSource: partner.portraitSource, isEnemy: false, delegate: nil)
            updateCharacterModel(chosen: .partner, model: partnerModel)
        }
    }
}
