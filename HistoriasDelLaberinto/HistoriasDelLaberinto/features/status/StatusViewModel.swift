struct StatusViewModel {
    let chosenCharacter: CharacterChosen
    let name: String
    var ailment: StatusAilment?
    var actualHealth: Int
    let maxHealth: Int
    let imageSource: ImageSource
    let isEnemy: Bool
    var delegate: DidTouchStatusDelegate?
}
