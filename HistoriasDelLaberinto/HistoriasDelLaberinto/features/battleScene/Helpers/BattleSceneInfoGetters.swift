protocol BattleSceneInfoGetters: class {
    var protagonist: CharacterStatus! { get set }
    var partner: CharacterStatus? { get set }
    var enemy: CharacterStatus { get set }
    var models: [CharacterChosen: StatusViewModel] { get set }
    var viewController: BattleSceneDisplayLogic? { get }
}

extension BattleSceneInfoGetters {
    func getCharacter(from chosen: CharacterChosen) -> CharacterStatus {
        switch chosen {
        case .protagonist:
            return protagonist
        case .partner:
            return partner!
        case .enemy:
            return enemy
        }
    }
    
    func setCharacter(to chosen: CharacterChosen, using status: CharacterStatus) {
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
    
    func getAilment(from character: CharacterChosen) -> StatusAilment? {
        switch character {
        case .enemy:
            return enemy.currentStatusAilment
        case .partner:
            return partner?.currentStatusAilment
        case .protagonist:
            return protagonist.currentStatusAilment
        }
    }
    
    func getAilmentMessage(from ailment: StatusAilment?, for character: CharacterStatus) -> String {
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
    
    func continueAilmentMessage(from ailment: StatusAilment, for character: CharacterStatus) -> String {
        var start = "\(character.name) sigue "
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
    
    func finishedAilmentMessage(from ailment: StatusAilment, for character: CharacterStatus) -> String {
        var start = "\(character.name) ya no está "
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
    
    func getPossibleTargets(from chosen: CharacterChosen) -> [CharacterChosen] {
        switch chosen {
        case .protagonist:
            return [.enemy]
        case .partner:
            return [.enemy]
        case .enemy:
            return [.protagonist, .partner]
        }
    }
    
    func calculateAilment(_ ailment: InduceAilment?, to character: CharacterStatus) -> Bool {
        guard character.currentStatusAilment == nil, let ailment = ailment else { return false }
        return Double.random(in: 0..<1) < Double(ailment.induceRate) / 100.0
    }
    
    func calculatePoisonDamage(for character: CharacterChosen) {
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
