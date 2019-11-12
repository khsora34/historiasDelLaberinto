struct KeyItem: Item, Decodable {
    let name: String
    let description: String
    let imageSource: ImageSource
    
    static func == (lhs: KeyItem, rhs: KeyItem) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description
    }
}
