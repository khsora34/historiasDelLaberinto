struct StatusViewModel {
    let chosenCharacter: CharacterChosen
    let name: String
    var ailment: StatusAilment?
    var actualHealth: Int
    let maxHealth: Int
    let imageUrl: String?
    let isEnemy: Bool
    var delegate: DidTouchStatusDelegate?
    
    func configure(view: StatusViewController) {
        view.characterChosen = chosenCharacter
        view.name = name
        view.setHealth(currentHealth: actualHealth, maxHealth: maxHealth)
        view.ailment = ailment
        view.setImage(with: imageUrl)
        view.setBackground(shouldDisplayForEnemy: isEnemy)
        view.touchDelegate = delegate
    }
}
