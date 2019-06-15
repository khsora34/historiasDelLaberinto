enum PauseMenuScene {
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
    enum ProtagonistUpdater {
        struct Request {
            let protagonist: CharacterStatus
        }
    }
    enum CharacterUpdater {
        struct Request {
            let partnerId: String?
            let partner: CharacterStatus?
        }
    }
}

enum MenuOption: Int {
    case items, save, exit
    
    func getOptionName() -> String {
        switch self {
        case .items:
            return "Inventario"
        case .save:
            return "Guardar"
        case .exit:
            return "Salir"
        }
    }
}
