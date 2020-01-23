import UIKit.UIApplication

protocol PauseMenuSceneBusinessLogic: BusinessLogic {
    func getProtagonist() -> PauseMenuScene.ProtagonistGetter.Response
    func getPartner(request: PauseMenuScene.CharacterGetter.Request) -> PauseMenuScene.CharacterGetter.Response
    func getWeapon(request: PauseMenuScene.WeaponGetter.Request) -> PauseMenuScene.WeaponGetter.Response
    func saveContext()
}

class PauseMenuSceneInteractor: BaseInteractor, PauseMenuSceneBusinessLogic {
    private let databaseProvider: DatabaseFetcherProvider
    
    init(databaseProvider: DatabaseFetcherProvider) {
        self.databaseProvider = databaseProvider
        super.init()
    }
    
    func getProtagonist() -> PauseMenuScene.ProtagonistGetter.Response {
        let protagonist: Protagonist = GameSession.protagonist
        return PauseMenuScene.ProtagonistGetter.Response(protagonist: protagonist)
    }
    
    func getPartner(request: PauseMenuScene.CharacterGetter.Request) -> PauseMenuScene.CharacterGetter.Response {
        let partner = GameSession.partners[request.id] ?? databaseProvider.charactersFetcher.getCharacter(with: request.id) as? PlayableCharacter
        return PauseMenuScene.CharacterGetter.Response(character: partner)
    }
    
    func getWeapon(request: PauseMenuScene.WeaponGetter.Request) -> PauseMenuScene.WeaponGetter.Response {
        guard let weapon = databaseProvider.itemsFetcher.getItem(with: request.id) as? Weapon else {
            return PauseMenuScene.WeaponGetter.Response(weapon: nil)
        }
        return PauseMenuScene.WeaponGetter.Response(weapon: weapon)
    }
    
    func saveContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let protagonist: Protagonist = GameSession.protagonist
        _ = databaseProvider.charactersFetcher.saveCharacter(for: protagonist, with: "protagonist")
        
        for (id, partner) in GameSession.partners {
            _ = databaseProvider.charactersFetcher.saveCharacter(for: partner, with: id)
        }
        
        for variable in GameSession.variables.values {
            _ = databaseProvider.variableFetcher.saveVariable(for: variable)
        }
        
        for (id, room) in GameSession.rooms {
            _ = databaseProvider.roomsFetcher.saveRoom(for: room, with: id)
        }
        
        let movement: Movement = GameSession.movement
        // Movement should be saved when this is called.
        appDelegate.saveContext()
        
        GameSession.restart()
        GameSession.startSession(protagonist: protagonist, movement: movement)
    }
}
