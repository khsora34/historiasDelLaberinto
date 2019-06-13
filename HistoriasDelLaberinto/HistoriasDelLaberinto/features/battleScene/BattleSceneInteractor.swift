protocol BattleSceneBusinessLogic: BusinessLogic {
    func getProtagonist() -> BattleScene.ProtagonistGetter.Response
}

class BattleSceneInteractor: BaseInteractor, BattleSceneBusinessLogic {
    private let protagonistFetcher: ProtagonistFetcher
    private let characterFetcher: CharacterFetcher
    private let itemFetcher: ItemFetcher
    
    init(databaseProvider: DatabaseFetcherProvider) {
        self.protagonistFetcher = databaseProvider.protagonistFetcher
        self.characterFetcher = databaseProvider.charactersFetcher
        self.itemFetcher = databaseProvider.itemsFetcher
    }
    
    func getProtagonist() -> BattleScene.ProtagonistGetter.Response {
        let protagonist = protagonistFetcher.getProtagonist()
        return BattleScene.ProtagonistGetter.Response(protagonist: protagonist)
    }
    
    func getPartner(request: BattleScene.CharacterGetter.Request) -> BattleScene.CharacterGetter.Response {
        guard let partner = characterFetcher.getCharacter(with: request.id) as? PlayableCharacter else {
            return BattleScene.CharacterGetter.Response(character: nil)
        }
        return BattleScene.CharacterGetter.Response(character: partner)
    }
    
    func getWeapon(request: BattleScene.WeaponGetter.Request) -> BattleScene.WeaponGetter.Response {
        guard let weapon = itemFetcher.getItem(with: request.id) as? Weapon else {
            return BattleScene.WeaponGetter.Response(weapon: nil)
        }
        return BattleScene.WeaponGetter.Response(weapon: weapon)
    }
    
    func updateCharacters(request: BattleScene.CharacterUpdater.Request) {
        guard let protagonist = request.protagonist as? Protagonist else { return }
        
        _ = protagonistFetcher.saveProtagonist(for: protagonist)
        if let partner = request.partner, let partnerId = protagonist.partner {
            _ = characterFetcher.saveCharacter(for: partner, with: partnerId)
        }
        
    }
    
}
