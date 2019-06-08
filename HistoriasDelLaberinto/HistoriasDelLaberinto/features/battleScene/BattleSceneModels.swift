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
}
