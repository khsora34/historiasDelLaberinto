protocol BattleSceneBusinessLogic: BusinessLogic {
    func getPartner(request: BattleScene.CharacterGetter.Request) -> BattleScene.CharacterGetter.Response
    func getWeapon(request: BattleScene.WeaponGetter.Request) -> BattleScene.WeaponGetter.Response
}

class BattleSceneInteractor: BaseInteractor, BattleSceneBusinessLogic {
    private let characterFetcher: CharacterFetcher
    private let itemFetcher: ItemFetcher
    
    init(databaseProvider: DatabaseFetcherProvider) {
        self.characterFetcher = databaseProvider.charactersFetcher
        self.itemFetcher = databaseProvider.itemsFetcher
        super.init()
    }
    
    func getPartner(request: BattleScene.CharacterGetter.Request) -> BattleScene.CharacterGetter.Response {
        let partner = GameSession.partners[request.id] ?? characterFetcher.getCharacter(with: request.id) as? PlayableCharacter
        return BattleScene.CharacterGetter.Response(character: partner)
    }
    
    func getWeapon(request: BattleScene.WeaponGetter.Request) -> BattleScene.WeaponGetter.Response {
        guard let weapon = itemFetcher.getItem(with: request.id) as? Weapon else {
            return BattleScene.WeaponGetter.Response(weapon: nil)
        }
        return BattleScene.WeaponGetter.Response(weapon: weapon)
    }
    
}
