import Kingfisher

struct StatusViewModel {
    let name: String
    let ailment: StatusAilment?
    let actualHealth: Int
    let maxHealth: Int
    let imageUrl: String
    var didTouchView: (() -> Void)?
    
    func configure(view: StatusViewController) {
        view.name = name
        view.actualHealth = actualHealth
        view.maxHealth = maxHealth
        view.ailment = ailment
        view.setImage(with: imageUrl)
        view.didTouchView = didTouchView
    }
}
