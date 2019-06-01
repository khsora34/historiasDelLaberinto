protocol DialogConfigurator {
    var name: String { get }
    var message: String { get }
    var imageUrl: String { get }
    var items: [(Item, Int)]? { get }
}
