struct StatusViewModel {
    let chosenCharacter: CharacterChosen
    let name: String
    var ailment: StatusAilment?
    var actualHealth: Int
    let maxHealth: Int
    let imageSource: ImageSource
    let isEnemy: Bool
    var delegate: DidTouchStatusDelegate?
    
    func configure(view: StatusView) {
        view.characterChosen = chosenCharacter
        view.name = name
        view.setHealth(currentHealth: actualHealth, maxHealth: maxHealth)
        view.ailment = ailment
        view.setImage(for: imageSource)
        view.setBackground(shouldDisplayForEnemy: isEnemy)
        view.touchDelegate = delegate
    }
}
