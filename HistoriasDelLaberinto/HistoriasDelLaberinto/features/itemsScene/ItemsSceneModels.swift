enum ItemsScene {
    enum ItemGetter {
        struct Request {
            let itemId: String
        }
        struct Response {
            let item: Item?
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
