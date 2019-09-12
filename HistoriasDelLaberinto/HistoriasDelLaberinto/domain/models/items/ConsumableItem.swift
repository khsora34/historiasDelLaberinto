struct ConsumableItem: Item, Decodable, Hashable {
    let name: String
    let description: String
    let imageUrl: String
    
    let healthRecovered: Int
    
    static func == (lhs: ConsumableItem, rhs: ConsumableItem) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description
    }
}
