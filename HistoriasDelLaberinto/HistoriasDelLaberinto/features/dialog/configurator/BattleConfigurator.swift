struct BattleConfigurator: DialogConfigurator {
    let name: String = ""
    let message: String
    let alignment: DialogAlignment
}

enum DialogAlignment {
    case top, bottom
}
