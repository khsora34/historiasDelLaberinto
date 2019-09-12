struct KeyItem: Item, Decodable, Hashable {
    let name: String
    let description: String
    let imageUrl: String
    
    static func == (lhs: KeyItem, rhs: KeyItem) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description
    }
}
