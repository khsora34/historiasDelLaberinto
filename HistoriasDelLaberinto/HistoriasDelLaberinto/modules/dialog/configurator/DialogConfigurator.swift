protocol DialogConfigurator {
    var name: String { get }
    var message: String { get }
}

extension DialogConfigurator {
    func sharesStruct(with other: DialogConfigurator) -> Bool {
        return other is Self
    }
}
