enum BattleScene {
    enum ProtagonistGetter {
        struct Response {
            let protagonist: Protagonist?
        }
    }
    enum CharacterGetter {
        struct Request {
            let id: String
        }
        struct Response {
            let character: PlayableCharacter?
        }
    }
    enum WeaponGetter {
        struct Request {
            let id: String
        }
        struct Response {
            let weapon: Weapon?
        }
    }
    
    enum CharacterUpdater {
        struct Request {
            let protagonist: CharacterStatus
            let partner: CharacterStatus?
        }
    }
}

enum AttackPhase: Int {
    case shouldContinueAilment = 0
    case evaluateAilment
    case evaluateHealthAfterAilment
    case attackPhase
    case attackResult
    case evaluateHealthAfterAttack
    case battleEnd
    case userInput
    
    func getNext() -> AttackPhase {
        if let value = AttackPhase(rawValue: self.rawValue + 1) {
            if value == .evaluateHealthAfterAttack {
                return .shouldContinueAilment
            }
            return value
        }
        return .shouldContinueAilment
    }
    
    static func startPhase() -> AttackPhase {
        return .shouldContinueAilment
    }
}

enum CharacterChosen: Int {
    case protagonist = 0, enemy, partner
    
    func next() -> CharacterChosen {
        if let value = CharacterChosen(rawValue: self.rawValue + 1) {
            return value
        }
        return .protagonist
    }
}

enum FinishedBattleReason {
    case defeated(CharacterChosen)
}
