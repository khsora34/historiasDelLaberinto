struct ConsumableItem: Item, Codable, Hashable {
    let name: String
    let description: String
    let imageUrl: String
    
    let healthRecovered: Int
    
    static func == (lhs: ConsumableItem, rhs: ConsumableItem) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description
    }
}

typealias ConsumableItemParser = YamlParser<ConsumableItem>
