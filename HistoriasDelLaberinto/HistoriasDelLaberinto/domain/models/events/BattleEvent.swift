struct BattleEvent: Event, Codable {
    let id: String
    let enemyId: String
    let nextStep: String
}

typealias BattleEventParser = YamlParser<BattleEvent>
