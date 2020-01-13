extension BattleScenePresenter {
    struct Constants {
        static let extraDamageWithoutWeapon: Int = 5
    }
}

extension BattleScenePresenter {
    func buildCharacters() {
        let protagonistModel = StatusViewModel(chosenCharacter: .protagonist, name: protagonist.name, ailment: protagonist.currentStatusAilment, actualHealth: protagonist.currentHealthPoints, maxHealth: protagonist.maxHealthPoints, imageSource: protagonist.portraitSource, isEnemy: false, delegate: nil)
        models[.protagonist] = protagonistModel
        var charactersForStatus: [StatusViewModel] = [protagonistModel]
        if let partner = partner {
            let partnerModel = StatusViewModel(chosenCharacter: .partner, name: partner.name, ailment: partner.currentStatusAilment, actualHealth: partner.currentHealthPoints, maxHealth: partner.maxHealthPoints, imageSource: partner.portraitSource, isEnemy: false, delegate: nil)
            charactersForStatus.append(partnerModel)
            models[.partner] = partnerModel
        }
        viewController?.addCharactersStatus(charactersForStatus)
        
        let model = StatusViewModel(chosenCharacter: .enemy, name: enemy.name, ailment: enemy.currentStatusAilment, actualHealth: enemy.currentHealthPoints, maxHealth: enemy.maxHealthPoints, imageSource: enemy.portraitSource, isEnemy: true, delegate: nil)
        models[.enemy] = model
        viewController?.setEnemyInfo(imageSource: enemy.imageSource, model: model)
    }
    
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
            protagonist = status as? Protagonist
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
        var start = character.name + " "
        switch ailment {
        case .blindness:
            start += localizedString(key: "battleMessageGetBlind")
        case .poison:
            start += localizedString(key: "battleMessageGetPoisoned")
        case .paralysis:
            start += localizedString(key: "battleMessageGetParalyzed")
        }
        return start
    }
    
    func continueAilmentMessage(from ailment: StatusAilment, for character: CharacterStatus) -> String {
        var start = character.name + " "
        switch ailment {
        case .blindness:
            start += localizedString(key: "battleMessageStillBlind")
        case .poison:
            start += localizedString(key: "battleMessageStillPoisoned")
        case .paralysis:
            start += localizedString(key: "battleMessageStillParalyzed")
        }
        return start
    }
    
    func finishedAilmentMessage(from ailment: StatusAilment, for character: CharacterStatus) -> String {
        var start = character.name + " "
        switch ailment {
        case .blindness:
            start += localizedString(key: "battleMessageFinishBlindness")
        case .poison:
            start += localizedString(key: "battleMessageFinishPoison")
        case .paralysis:
            start += localizedString(key: "battleMessageFinishParalysis")
        }
        return start
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
    
    private func updateCharacterModel(chosen: CharacterChosen, model: StatusViewModel) {
        viewController?.updateView(model)
        models[chosen] = model
    }
    
    func updateStatusModels() {
        let protagonistModel = StatusViewModel(chosenCharacter: .protagonist, name: protagonist.name, ailment: protagonist.currentStatusAilment, actualHealth: protagonist.currentHealthPoints, maxHealth: protagonist.maxHealthPoints, imageSource: protagonist.portraitSource, isEnemy: false, delegate: nil)
        updateCharacterModel(chosen: .protagonist, model: protagonistModel)
        if let partner = partner {
            let partnerModel = StatusViewModel(chosenCharacter: .partner, name: partner.name, ailment: partner.currentStatusAilment, actualHealth: partner.currentHealthPoints, maxHealth: partner.maxHealthPoints, imageSource: partner.portraitSource, isEnemy: false, delegate: nil)
            updateCharacterModel(chosen: .partner, model: partnerModel)
        }
    }
}
