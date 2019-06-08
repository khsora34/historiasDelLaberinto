protocol BattleScenePresentationLogic: Presenter {
    func protaWillAttack()
}

extension BattleScenePresenter {
    enum CharacterChosen {
        case protagonist, partner, enemy
    }
    
    enum FinishedBattleReason {
        case defeated(CharacterChosen)
        case paralyzed(CharacterChosen)
    }
    
    fileprivate struct Constants {
        static let extraDamageWithoutWeapon: Int = 5
    }
}

class BattleScenePresenter: BasePresenter {
    var viewController: BattleSceneDisplayLogic? {
        return _viewController as? BattleSceneDisplayLogic
    }
    
    var interactor: BattleSceneInteractor? {
        return _interactor as? BattleSceneInteractor
    }
    
    var router: BattleSceneRouter? {
        return _router as? BattleSceneRouter
    }
    
    private var protagonist: CharacterStatus!
    private var partner: CharacterStatus?
    private var enemy: CharacterStatus
    private var models: [CharacterChosen: StatusViewModel] = [:]
    private var actualWeapons: [String: Weapon] = [:]
    
    weak var delegate: BattleBuilderDelegate?
    
    init(enemy: PlayableCharacter) {
        self.enemy = enemy
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.setBackground(with: delegate?.imageUrl)
        getProtagonist()
        getPartner()
        getWeapons()
        buildCharacters()
        buildEnemy()
    }
    
    func evaluateProtagonistBeforeAttack() -> FinishedBattleReason? {
        guard evaluateAilment(for: .partner) else {
            return getReasonForFinishingTurn()
        }
        return nil
    }
    
    func partnerAttacks() -> FinishedBattleReason? {
        guard partner != nil else { return nil }
        guard evaluateAilment(for: .partner) else {
            return getReasonForFinishingTurn()
        }
        calculateAttack(from: .partner, to: .enemy)
        return getReasonForFinishingTurn()
    }
    
    func enemyAttacks() -> FinishedBattleReason? {
        guard evaluateAilment(for: .enemy) else {
            return getReasonForFinishingTurn()
        }
        
        var target: CharacterChosen = .protagonist
        if partner != nil {
            target = Double.random(in: 0..<1) < 0.5 ? .protagonist: .partner
        }
        calculateAttack(from: .enemy, to: target)
        return getReasonForFinishingTurn()
    }
    
    func onPlayerTurnFinished() {
        if let reason = enemyAttacks() {
            calculateNextAction(reason: reason)
            return
        }
        if let reason = partnerAttacks() {
            calculateNextAction(reason: reason)
            return
        }
        if let reason = evaluateProtagonistBeforeAttack() {
            calculateNextAction(reason: reason)
            return
        }
    }
    
    func calculateNextAction(reason: FinishedBattleReason) {
        if case FinishedBattleReason.defeated = reason {
            return
        } else if case FinishedBattleReason.paralyzed(let chosen) = reason {
            var name = ""
            switch chosen {
            case .protagonist:
                name += protagonist.name
            case .partner:
                guard let partner = partner else { return }
                name += partner.name
            case .enemy:
                name += enemy.name
            }
            print("\(name) está paralizado, no puede moverse.")
        } else {
            endBattle(reason: reason)
        }
    }
    
    private func endBattle(reason: FinishedBattleReason) {
        switch reason {
        case .defeated(.enemy):
            print("YAY, defeated ^^")
        case .defeated(.protagonist):
            print("No, we dead.")
        case .defeated(.partner):
            break
        case .paralyzed:
            break
        }
        router?.popToRoom()
    }
}

extension BattleScenePresenter: BattleScenePresentationLogic {
    func protaWillAttack() {
        calculateAttack(from: .protagonist, to: .enemy)
        if let reason = getReasonForFinishingTurn() {
            endBattle(reason: reason)
        } else {
            onPlayerTurnFinished()
        }
    }
}

// MARK: - Battle logic

extension BattleScenePresenter {
    private func evaluateAilment(for character: CharacterChosen) -> Bool {
        guard let safeAilment = getAilment(from: character) else { return true }
        switch safeAilment {
        case .poisoned:
            calculatePoisonDamage(for: character)
            return evaluateCurrentHealth(for: character)
        case .paralyzed: return Double.random(in: 0..<1) < 0.4
        case .blind: return true
        }
    }
    
    private func evaluateCurrentHealth(for character: CharacterChosen) -> Bool {
        switch character {
        case .protagonist:
            if protagonist.currentHealthPoints == 0 {
                return false
            }
        case .partner:
            guard partner != nil else {
                print("💔 NO DEBERÍAS ESTAR AQUÍ.")
                return false
            }
            if partner!.currentHealthPoints == 0 {
                print("Lo siento, ya no puedo más...")
                return false
            }
        case .enemy:
            if enemy.currentHealthPoints == 0 {
                return false
            }
        }
        return true
    }
    
    private func getReasonForFinishingTurn() -> FinishedBattleReason? {
        if protagonist.currentHealthPoints <= 0 {
            return .defeated(.protagonist)
        } else if enemy.currentHealthPoints <= 0 {
            return .defeated(.enemy)
        } else if case protagonist.currentStatusAilment = StatusAilment.paralyzed {
            return .paralyzed(.protagonist)
        } else if case partner?.currentStatusAilment = StatusAilment.paralyzed {
            return .paralyzed(.partner)
        } else if case enemy.currentStatusAilment = StatusAilment.paralyzed {
            return .paralyzed(.enemy)
        }
        return nil
    }
    
    private func calculateAttack(from character: CharacterChosen, to target: CharacterChosen) {
        guard let chosenCharacter = getCharacter(from: character), var targetCharacter = getCharacter(from: target) else {
            print("💔 NO DEBERÍAS ESTAR AQUÍ TAMPOCO.")
            return
        }
        
        print("¡Chosen ataca a target!")
        
        var i = 0
        while i < (Int(chosenCharacter.agility/targetCharacter.agility)), targetCharacter.currentHealthPoints > 0 {
            if i > 0 {
                print("¡Ataca otra vez!")
            }
            guard Double.random(in: 0..<1) < Double(actualWeapons[chosenCharacter.weapon ?? ""]?.hitRate ?? 100) / 100 else {
                print("Pero falló el ataque...")
                i += 1
                continue
            }
            let attackDamage = chosenCharacter.attack + Int.random(in: 0..<(actualWeapons[chosenCharacter.weapon ?? ""]?.extraDamage ?? 1))
            let calculatedDamage = attackDamage - targetCharacter.defense
            guard calculatedDamage > 0 else {
                print("Target absorbió al ataque.")
                i += 1
                continue
            }
            targetCharacter.currentHealthPoints -= calculatedDamage
            targetCharacter.currentHealthPoints = targetCharacter.currentHealthPoints < 0 ? 0: targetCharacter.currentHealthPoints
            if calculateAilment(actualWeapons[chosenCharacter.weapon ?? ""]?.inducedAilment, to: targetCharacter) {
                print(getAilmentMessage(from: actualWeapons[chosenCharacter.weapon ?? ""]?.inducedAilment?.ailment, for: targetCharacter))
                targetCharacter.currentStatusAilment = actualWeapons[chosenCharacter.weapon ?? ""]?.inducedAilment?.ailment
            }
            setCharacter(to: target, using: targetCharacter)
            i += 1
        }
        _ = evaluateCurrentHealth(for: target)
    }
    
    private func calculateAilment(_ ailment: InduceAilment?, to character: CharacterStatus) -> Bool {
        guard character.currentStatusAilment == nil, let ailment = ailment else { return false }
        return Double.random(in: 0..<1) < Double(ailment.induceRate) / 100.0
    }
    
    private func getCharacter(from chosen: CharacterChosen) -> CharacterStatus? {
        switch chosen {
        case .protagonist:
            return protagonist
        case .partner:
            return partner
        case .enemy:
            return enemy
        }
    }
    
    private func setCharacter(to chosen: CharacterChosen, using status: CharacterStatus) {
        var model: StatusViewModel
        switch chosen {
        case .protagonist:
            protagonist = status
            guard let newModel = models[.protagonist] else { return }
            model = newModel
        case .partner:
            partner = status
            guard let newModel = models[.partner] else { return }
            model = newModel
        case .enemy:
            enemy = status
            guard let newModel = models[.enemy] else { return }
            model = newModel
        }
        model.ailment = status.currentStatusAilment
        model.actualHealth = status.currentHealthPoints
        viewController?.updateView(model)
    }
    
    private func getAilment(from character: CharacterChosen) -> StatusAilment? {
        switch character {
        case .enemy:
            return enemy.currentStatusAilment
        case .partner:
            return partner?.currentStatusAilment
        case .protagonist:
            return protagonist.currentStatusAilment
        }
    }
    
    private func getAilmentMessage(from ailment: StatusAilment?, for character: CharacterStatus) -> String {
        guard let ailment = ailment else { return "" }
        var start = "Ahora \(character.name) está "
        switch ailment {
        case .blind:
            start += "cegado."
        case .poisoned:
            start += "envenenado."
        case .paralyzed:
            start += "paralizado."
        }
        return start
    }
    
    private func calculatePoisonDamage(for character: CharacterChosen) {
        let randomDamage = 40 + Int.random(in: 0..<15)
        switch character {
        case .enemy:
            enemy.currentHealthPoints -= randomDamage
        case .partner:
            partner?.currentHealthPoints -= randomDamage
        case .protagonist:
            protagonist.currentHealthPoints -= randomDamage
        }
    }
}

// MARK: - Interactors

extension BattleScenePresenter {
    private func getProtagonist() {
        let response = interactor?.getProtagonist()
        protagonist = response?.protagonist
    }
    
    private func getPartner() {
        guard let partnerId = (protagonist as? Protagonist)?.partner  else { return }
        let request = BattleScene.CharacterGetter.Request(id: partnerId)
        let response = interactor?.getPartner(request: request)
        partner = response?.character
    }
    
    private func getWeapons() {
        let weapons = [protagonist.weapon, partner?.weapon, enemy.weapon].compactMap({$0})
        var actualWeapons: [String: Weapon] = [:]
        for weaponId in weapons {
            let request = BattleScene.WeaponGetter.Request(id: weaponId)
            let response = interactor?.getWeapon(request: request)
            actualWeapons[weaponId] = response?.weapon
        }
        self.actualWeapons = actualWeapons
    }
    
    private func buildCharacters() {
        let protagonistModel = StatusViewModel(name: protagonist.name, ailment: protagonist.currentStatusAilment, actualHealth: protagonist.currentHealthPoints, maxHealth: protagonist.maxHealthPoints, imageUrl: protagonist.imageUrl, isEnemy: false, didTouchView: nil)
        models[.protagonist] = protagonistModel
        var charactersForStatus: [StatusViewModel] = [protagonistModel]
        if let partner = partner {
            let partnerModel = StatusViewModel(name: partner.name, ailment: partner.currentStatusAilment, actualHealth: partner.currentHealthPoints, maxHealth: partner.maxHealthPoints, imageUrl: partner.imageUrl, isEnemy: false, didTouchView: nil)
            charactersForStatus.append(partnerModel)
            models[.partner] = partnerModel
        }
        viewController?.addCharactersStatus(charactersForStatus)
    }
    
    private func buildEnemy() {
        let model = StatusViewModel(name: enemy.name, ailment: enemy.currentStatusAilment, actualHealth: enemy.currentHealthPoints, maxHealth: enemy.maxHealthPoints, imageUrl: "https://cdn4.iconfinder.com/data/icons/eldorado-culture/40/ghost-512.png", isEnemy: true, didTouchView: nil)
        models[.enemy] = model
        viewController?.setEnemyInfo(imageUrl: enemy.imageUrl, model: model)
    }
}
