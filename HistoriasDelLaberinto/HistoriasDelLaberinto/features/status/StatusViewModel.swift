import Kingfisher

struct StatusViewModel {
    let name: String
    var ailment: StatusAilment?
    var actualHealth: Int
    let maxHealth: Int
    let imageUrl: String
    let isEnemy: Bool
    var didTouchView: (() -> Void)?
    
    func configure(view: StatusViewController) {
        view.name = name
        view.maxHealth = maxHealth
        view.actualHealth = actualHealth
        view.ailment = ailment
        view.setImage(with: imageUrl)
        view.setBackground(shouldDisplayForEnemy: isEnemy)
        view.didTouchView = didTouchView
    }
}
