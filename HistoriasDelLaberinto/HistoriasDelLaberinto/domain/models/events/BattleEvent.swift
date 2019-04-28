struct BattleEvent: Event, Codable {
    let enemyId: String
    let nextStep: String?
}

typealias BattleEventParser = YamlParser<BattleEvent>
