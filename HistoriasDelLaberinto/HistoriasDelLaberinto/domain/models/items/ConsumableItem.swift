struct ConsumableItem: Item, Decodable {
    let name: String
    let description: String
    let imageUrl: String
    let imageSource: ImageSource
    
    let healthRecovered: Int
    
    static func == (lhs: ConsumableItem, rhs: ConsumableItem) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description
    }
}
