protocol PauseMenuScenePresentationLogic: Presenter {
}

class PauseMenuScenePresenter: BasePresenter {
    var viewController: PauseMenuSceneDisplayLogic? {
        return _viewController as? PauseMenuSceneDisplayLogic
    }
    
    var interactor: PauseMenuSceneBusinessLogic? {
        return _interactor as? PauseMenuSceneInteractor
    }
    
    var router: PauseMenuSceneRouter? {
        return _router as? PauseMenuSceneRouter
    }
    
    var models: [CharacterChosen: StatusViewModel] = [:]
    
    private var actualWeapons: [String: Weapon] = [:]
    private var protagonist: Protagonist!
    private var partner: PlayableCharacter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProtagonist()
        getPartner()
        getWeapons()
        buildCharacters()
        createOptions()
    }
}

extension PauseMenuScenePresenter {
    private func getProtagonist() {
        let response = interactor?.getProtagonist()
        protagonist = response?.protagonist
    }
    
    private func getPartner() {
        guard let partnerId = protagonist.partner  else { return }
        let request = PauseMenuScene.CharacterGetter.Request(id: partnerId)
        let response = interactor?.getPartner(request: request)
        partner = response?.character
    }
    
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
    private func createOptions() {
        let availableOptions: [MenuOptions] = [.items, .save, .exit]
        let transformed = availableOptions.map { return ($0.getOptionName(), $0.rawValue) }
        viewController?.createOptions(with: transformed)
    }
}

extension PauseMenuScenePresenter: PauseMenuScenePresentationLogic {
    func buildCharacters() {
        let protagonistModel = StatusViewModel(chosenCharacter: .protagonist, name: protagonist.name, ailment: protagonist.currentStatusAilment, actualHealth: protagonist.currentHealthPoints, maxHealth: protagonist.maxHealthPoints, imageUrl: protagonist.portraitUrl, isEnemy: false, didTouchView: nil)
        var charactersForStatus: [StatusViewModel] = [protagonistModel]
        if let partner = partner {
            let partnerModel = StatusViewModel(chosenCharacter: .partner, name: partner.name, ailment: partner.currentStatusAilment, actualHealth: partner.currentHealthPoints, maxHealth: partner.maxHealthPoints, imageUrl: partner.portraitUrl, isEnemy: false, didTouchView: nil)
            charactersForStatus.append(partnerModel)
            models[.partner] = partnerModel
        }
        viewController?.addCharactersStatus(charactersForStatus)
    }
}
