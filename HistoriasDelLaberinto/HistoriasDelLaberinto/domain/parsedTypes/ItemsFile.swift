struct ItemsFile: Decodable {
    let weapons: [String: Weapon]
    let keyItems: [String: KeyItem]
    let consumableItems: [String: ConsumableItem]
}

typealias ItemsFileParser = YamlParser<ItemsFile>
