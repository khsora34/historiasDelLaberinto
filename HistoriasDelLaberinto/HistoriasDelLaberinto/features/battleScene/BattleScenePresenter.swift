protocol BattleScenePresentationLogic: Presenter {
    func protaWillAttack()
    func showStartDialogue()
}

extension BattleScenePresenter {
    fileprivate struct Constants {
        static let extraDamageWithoutWeapon: Int = 5
    }
}

class BattleScenePresenter: BasePresenter {
    struct ActualState {
        var step: AttackPhase
        var character: CharacterChosen
        var target: CharacterChosen?
    }
    
    var viewController: BattleSceneDisplayLogic? {
        return _viewController as? BattleSceneDisplayLogic
    }
    
    var interactor: BattleSceneInteractor? {
        return _interactor as? BattleSceneInteractor
    }
    
    var router: BattleSceneRouter? {
        return _router as? BattleSceneRouter
    }
    
    var models: [CharacterChosen: StatusViewModel] = [:]
    var dialog: DialogDisplayLogic?
    
    var protagonist: CharacterStatus!
    var partner: CharacterStatus?
    var enemy: CharacterStatus
    
    private var actualWeapons: [String: Weapon] = [:]
    private var ailmentTurnsElapsed: [CharacterChosen: Int] = [:]
    
    private var actualState = ActualState(step: .userInput, character: .protagonist, target: nil)
    private var finishedBattleReason: FinishedBattleReason?
    
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
}

extension BattleScenePresenter: BattleScenePresentationLogic {
    func showStartDialogue() {
        showDialog(with: BattleConfigurator(message: "Un \(enemy.name) salvaje apareció.", alignment: .bottom))
    }
    
    func protaWillAttack() {
        actualState = ActualState(step: .attackPhase, character: .protagonist, target: nil)
        performNextStep()
    }
}

// MARK: - Battle logic

extension BattleScenePresenter {
    private func shouldContinueAilment() {
        let state = actualState
        let chosenCharacter = actualState.character
        if let ailment = getAilment(from: chosenCharacter), let turnsElapsed = ailmentTurnsElapsed[chosenCharacter] {
            var character = getCharacter(from: chosenCharacter)
            let message: String
            if Double.random(in: 0..<1) < Double(turnsElapsed) * 0.2 {
                message = finishedAilmentMessage(from: ailment, for: character)
                character.currentStatusAilment = nil
                setCharacter(to: chosenCharacter, using: character)
            } else {
                message = continueAilmentMessage(from: ailment, for: getCharacter(from: chosenCharacter))
            }
            actualState = ActualState(step: state.step.getNext(), character: chosenCharacter, target: nil)
            let configurator = BattleConfigurator(message: message, alignment: chosenCharacter == .enemy ? .top: .bottom)
            showDialog(with: configurator)
        } else {
            actualState = ActualState(step: state.step.getNext(), character: chosenCharacter, target: nil)
            performNextStep()
        }
    }
    
    private func evaluateAilment() {
        let chosenCharacter = actualState.character
        
        // DOES THE CHARACTER HAVE AN AILMENT?
        guard let safeAilment = getAilment(from: chosenCharacter) else {
            actualState = ActualState(step: actualState.step.getNext(), character: chosenCharacter, target: nil)
            performNextStep()
            return
        }
        
        let ailmentMessage: String
        let characterName = getCharacter(from: chosenCharacter).name
        
        switch safeAilment {
        case .poisoned:
            calculatePoisonDamage(for: chosenCharacter)
            ailmentMessage = "\(characterName) pierde vida por el veneno."
            let configurator = BattleConfigurator(message: ailmentMessage, alignment: chosenCharacter == .enemy ? .bottom: .top)
            showDialog(with: configurator)
            return
        case .paralyzed:
            if Double.random(in: 0..<1) < 0.4 {
                ailmentMessage = "\(characterName) está paralizado, no puede moverse."
                actualState = ActualState(step: .shouldContinueAilment, character: chosenCharacter.next(), target: nil)
                let configurator = BattleConfigurator(message: ailmentMessage, alignment: chosenCharacter == .enemy ? .bottom: .top)
                showDialog(with: configurator)
                return
            }
        case .blind:
            actualState = ActualState(step: actualState.step.getNext(), character: chosenCharacter, target: nil)
            performNextStep()
        }
    }
    
    private func evaluateHealth() {
        let character = actualState.character
        switch character {
        case .protagonist:
            if protagonist.currentHealthPoints == 0 {
                actualState = ActualState(step: .battleEnd, character: .protagonist, target: nil)
            } else {
                actualState = ActualState(step: .userInput, character: .protagonist, target: nil)
            }
        case .partner:
            guard let partner = partner else {
                print("💔 NO DEBERÍAS ESTAR AQUÍ.")
                actualState = ActualState(step: actualState.step.getNext(), character: .enemy, target: nil)
                performNextStep()
                return
            }
            if partner.currentHealthPoints == 0 {
                actualState = ActualState(step: .shouldContinueAilment, character: .protagonist, target: nil)
                let configurator = DialogueConfigurator(name: partner.name, message: "Lo siento, ya no puedo más...", imageUrl: partner.imageUrl)
                showDialog(with: configurator)
                return
            } else {
                actualState = ActualState(step: actualState.step.getNext(), character: .partner, target: nil)
            }
        case .enemy:
            if enemy.currentHealthPoints == 0 {
                actualState = ActualState(step: .battleEnd, character: .enemy, target: nil)
            } else {
                actualState = ActualState(step: actualState.step.getNext(), character: .enemy, target: nil)
            }
        }
        performNextStep()
    }
    
    private func evaluateHealth(for target: CharacterChosen?) {
        guard let safeTarget = target else {
            actualState = ActualState(step: AttackPhase.startPhase(), character: .protagonist, target: nil)
            performNextStep()
            return
        }
        switch safeTarget {
        case .protagonist:
            if protagonist.currentHealthPoints == 0 {
                actualState = ActualState(step: .battleEnd, character: .protagonist, target: nil)
            } else {
                actualState = ActualState(step: AttackPhase.startPhase(), character: actualState.character.next(), target: nil)
            }
            performNextStep()
        case .partner:
            guard let partner = partner else {
                print("💔 NO DEBERÍAS ESTAR AQUÍ.")
                actualState = ActualState(step: AttackPhase.startPhase(), character: .enemy, target: nil)
                performNextStep()
                return
            }
            if partner.currentHealthPoints == 0 {
                var nextCharacter = actualState.character.next()
                while nextCharacter == .partner { nextCharacter = nextCharacter.next() }
                
                actualState = ActualState(step: AttackPhase.startPhase(), character: nextCharacter, target: nil)
                let configurator = DialogueConfigurator(name: partner.name, message: "Lo siento, ya no puedo más...", imageUrl: partner.imageUrl)
                showDialog(with: configurator)
            } else {
                actualState = ActualState(step: AttackPhase.startPhase(), character: actualState.character.next(), target: nil)
                performNextStep()
            }
        case .enemy:
            if enemy.currentHealthPoints == 0 {
                actualState = ActualState(step: .battleEnd, character: .enemy, target: nil)
            } else {
                var nextCharacter = actualState.character.next()
                if partner == nil {
                    while nextCharacter == .partner { nextCharacter = nextCharacter.next() }
                }
                
                actualState = ActualState(step: AttackPhase.startPhase(), character: nextCharacter, target: nil)
            }
            performNextStep()
        }
    }
    
    private func attackPhase() {
        let chosenCharacter = actualState.character
        let character = getCharacter(from: chosenCharacter)
        let message = "\(character.name) va a atacar."
        actualState = ActualState(step: actualState.step.getNext(), character: actualState.character, target: nil)
        let configurator = BattleConfigurator(message: message, alignment: chosenCharacter == .enemy ? .top: .bottom)
        showDialog(with: configurator)
    }
    
    private func attackResult() {
        let chosenCharacter = actualState.character
        let chosenCharacterStatus = getCharacter(from: chosenCharacter)
        
        let possibleTargets = getPossibleTargets(from: chosenCharacter)
        let target = possibleTargets.shuffled()[0]
        var targetStatus = getCharacter(from: target)
        
        var attackMessage: String
        
        let actualWeapon = actualWeapons[chosenCharacterStatus.weapon ?? ""]
        
        // CALCULATE MULTIPLE ATTACKS CHANCE
        var agilityRatio = chosenCharacterStatus.agility/targetStatus.agility
        agilityRatio = agilityRatio <= 1 ? 1: agilityRatio
        
        var effectiveAttacks: Int = 0
        
        // WILL THE ATTACK HIT?
        for _ in 0..<agilityRatio where Double.random(in: 0..<1) < Double(actualWeapon?.hitRate ?? 100) / 100 {
            effectiveAttacks += 1
        }
        guard effectiveAttacks > 0 else {
            attackMessage = "Pero falló el ataque..."
            actualState = ActualState(step: actualState.step.getNext(), character: chosenCharacter, target: target)
            let configurator = BattleConfigurator(message: attackMessage, alignment: chosenCharacter == .enemy ? .top: .bottom)
            showDialog(with: configurator)
            return
        }
        
        // EXTRA AGILITY ATTACK BONUS
        if Double.random(in: 0..<1) < 0.15 {
            effectiveAttacks += 1
        }
        
        // DAMAGE CALCULATION PHASE
        // If the attacking character has any weapon, the max extra damage is the weapon's power. Else the maximum is the constant value.
        let maxExtraDamageOutput = actualWeapon?.extraDamage ?? Constants.extraDamageWithoutWeapon
        let attackDamage = chosenCharacterStatus.attack + Int.random(in: 0..<maxExtraDamageOutput)
        var calculatedDamage = (attackDamage * effectiveAttacks) - targetStatus.defense
        
        // IF THE CALCULATED DAMAGE IS NEGATIVE, INSTEAD DO CERO DAMAGE.
        if calculatedDamage <= 0 {
            attackMessage = "Pero \(targetStatus.name) absorbe al ataque."
            calculatedDamage = 0
            
        } else {
            let timesMessage = effectiveAttacks == 1 ? "1 vez": "\(effectiveAttacks) veces"
            attackMessage = "\(chosenCharacterStatus.name) golpea \(timesMessage) a \(targetStatus.name)."
        }
        
        // APPLY DAMAGE
        targetStatus.currentHealthPoints -= calculatedDamage
        targetStatus.currentHealthPoints = targetStatus.currentHealthPoints < 0 ? 0: targetStatus.currentHealthPoints
        
        // CALCULATE IF THE CHOSEN CHARACTER CAN INDUCE AN AILMENT
        if calculateAilment(actualWeapon?.inducedAilment, to: targetStatus) {
            attackMessage += "\n" + getAilmentMessage(from: actualWeapon?.inducedAilment?.ailment, for: targetStatus)
            targetStatus.currentStatusAilment = actualWeapon?.inducedAilment?.ailment
        }
        
        setCharacter(to: target, using: targetStatus)
        
        actualState = ActualState(step: .evaluateHealthAfterAttack, character: chosenCharacter, target: target)
        let configurator = BattleConfigurator(message: attackMessage, alignment: chosenCharacter == .enemy ? .top: .bottom)
        showDialog(with: configurator)
        guard let model = models[target], calculatedDamage > 0 else { return }
        viewController?.performDamage(on: model)
    }
    
    private func battleEnd() {
        if protagonist.currentHealthPoints <= 0 {
            finishedBattleReason = .defeated(.protagonist)
            let configurator = BattleConfigurator(message: "Empiezas a perder la consciencia.", alignment: .bottom)
            showDialog(with: configurator)
            return
        }
        
        updateCharacters()
        
        finishedBattleReason = .defeated(.enemy)
        if let partner = partner {
            let configurator = DialogueConfigurator(name: partner.name, message: "¡Sí, lo hemos conseguido!", imageUrl: partner.imageUrl)
            showDialog(with: configurator)
            
        } else {
            let configurator = BattleConfigurator(message: "Has conseguido derrotar al malo.", alignment: .bottom)
            showDialog(with: configurator)
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
    
    private func updateCharacters() {
        let request = BattleScene.CharacterUpdater.Request(protagonist: protagonist, partner: partner)
        interactor?.updateCharacters(request: request)
    }
}

extension BattleScenePresenter: NextDialogHandler {
    func continueFlow() {
        performNextStep()
    }
    
    func elementSelected(id: Int) {}
    
    private func performNextStep() {
        if let reason = finishedBattleReason {
            router?.dismiss(animated: true)
            router?.goBackToRoom()
            delegate?.onBattleFinished(reason: reason)
            return
        }
        switch actualState.step {
        case .shouldContinueAilment:
            shouldContinueAilment()
        case .evaluateAilment:
            evaluateAilment()
        case .evaluateHealthAfterAilment:
            evaluateHealth()
        case .attackPhase:
            attackPhase()
        case .attackResult:
            attackResult()
        case .evaluateHealthAfterAttack:
            evaluateHealth(for: actualState.target)
        case .battleEnd:
            battleEnd()
        case .userInput:
            router?.dismiss(animated: true)
        }
    }
}

extension BattleScenePresenter: BattleSceneInfoGetters {}
extension BattleScenePresenter: DialogLauncher {
    func present(_ dialog: DialogDisplayLogic) {
        router?.present(dialog, animated: true)
    }
}
