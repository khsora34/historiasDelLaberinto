struct BattleEvent: Event, Codable {
    let enemyId: String
    let shouldSetVisited: Bool?
    let nextStep: String?
}

typealias BattleEventParser = YamlParser<BattleEvent>
