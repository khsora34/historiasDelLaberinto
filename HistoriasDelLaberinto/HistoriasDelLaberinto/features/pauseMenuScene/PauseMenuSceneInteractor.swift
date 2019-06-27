import UIKit.UIApplication

protocol PauseMenuSceneBusinessLogic: BusinessLogic {
    func getProtagonist() -> PauseMenuScene.ProtagonistGetter.Response
    func getPartner(request: PauseMenuScene.CharacterGetter.Request) -> PauseMenuScene.CharacterGetter.Response
    func getWeapon(request: PauseMenuScene.WeaponGetter.Request) -> PauseMenuScene.WeaponGetter.Response
    func saveContext()
}

class PauseMenuSceneInteractor: BaseInteractor, PauseMenuSceneBusinessLogic {
    private let protagonistFetcher: ProtagonistFetcher
    private let characterFetcher: CharacterFetcher
    private let itemFetcher: ItemFetcher
    
    init(databaseProvider: DatabaseFetcherProvider) {
        self.protagonistFetcher = databaseProvider.protagonistFetcher
        self.characterFetcher = databaseProvider.charactersFetcher
        self.itemFetcher = databaseProvider.itemsFetcher
    }
    
    func getProtagonist() -> PauseMenuScene.ProtagonistGetter.Response {
        let protagonist = protagonistFetcher.getProtagonist()
        return PauseMenuScene.ProtagonistGetter.Response(protagonist: protagonist)
    }
    
    func getPartner(request: PauseMenuScene.CharacterGetter.Request) -> PauseMenuScene.CharacterGetter.Response {
        guard let partner = characterFetcher.getCharacter(with: request.id) as? PlayableCharacter else {
            return PauseMenuScene.CharacterGetter.Response(character: nil)
        }
        return PauseMenuScene.CharacterGetter.Response(character: partner)
    }
    
    func getWeapon(request: PauseMenuScene.WeaponGetter.Request) -> PauseMenuScene.WeaponGetter.Response {
        guard let weapon = itemFetcher.getItem(with: request.id) as? Weapon else {
            return PauseMenuScene.WeaponGetter.Response(weapon: nil)
        }
        return PauseMenuScene.WeaponGetter.Response(weapon: weapon)
    }
    
    func saveContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }
}
