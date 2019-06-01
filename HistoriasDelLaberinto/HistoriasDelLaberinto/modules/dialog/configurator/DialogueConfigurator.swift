struct DialogueConfigurator: DialogConfigurator {
    let name: String
    let message: String
    let imageUrl: String
    let items: [(Item, Int)]? = nil
}