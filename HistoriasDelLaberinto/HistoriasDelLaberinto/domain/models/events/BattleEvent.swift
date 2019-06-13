struct BattleEvent: Event, Codable {
    let enemyId: String
    let shouldSetVisited: Bool?
    let winStep: String
    let loseStep: String
    let nextStep: String? = nil
}

typealias BattleEventParser = YamlParser<BattleEvent>
