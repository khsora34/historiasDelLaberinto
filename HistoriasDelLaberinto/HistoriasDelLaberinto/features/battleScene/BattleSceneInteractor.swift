protocol BattleSceneBusinessLogic: BusinessLogic {
    func getProtagonist() -> BattleScene.ProtagonistGetter.Response
}

class BattleSceneInteractor: BaseInteractor, BattleSceneBusinessLogic {
    private let protagonistFetcher: ProtagonistFetcher
    private let characterFetcher: CharacterFetcher
    
    init(protagonistFetcher: ProtagonistFetcher, characterFetcher: CharacterFetcher) {
        self.protagonistFetcher = protagonistFetcher
        self.characterFetcher = characterFetcher
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
    
}
