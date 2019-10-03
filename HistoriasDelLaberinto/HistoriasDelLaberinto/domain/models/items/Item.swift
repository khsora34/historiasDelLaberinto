protocol Item: ImageRepresentable {
    var name: String { get }
    var description: String { get }
}

enum ItemType: String {
    case key, weapon, consumable
    
    init?(item: Item) {
        if item is ConsumableItem {
            self = .consumable
        } else if item is KeyItem {
            self = .key
        } else if item is Weapon {
            self = .weapon
        } else {
            return nil
        }
    }
    
    func localizedDescription() -> String {
        switch self {
        case .consumable:
            return "Consumible"
        case .key:
            return "Objeto clave"
        case .weapon:
            return "Arma"
        }
    }
}
