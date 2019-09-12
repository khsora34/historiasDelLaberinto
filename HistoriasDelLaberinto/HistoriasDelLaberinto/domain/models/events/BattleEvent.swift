struct BattleEvent: Event, Decodable {
    let id: String
    let enemyId: String
    let shouldSetVisited: Bool?
    let shouldEndGame: Bool?
    let winStep: String
    let loseStep: String
    let nextStep: String? = nil
}

typealias BattleEventParser = YamlParser<BattleEvent>
