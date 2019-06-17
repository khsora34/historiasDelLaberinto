struct ItemViewModel {
    let id: String
    let name: String
    let description: String
    let itemType: String
    var quantity: Int
    let imageUrl: String?
    let tag: Int
    var isSelected = false
    let delegate: ItemSelectedDelegate?
    
    func configure(view: ItemView) {
        view.frontItemView.name = name
        view.frontItemView.itemType = itemType
        view.frontItemView.quantity = quantity
        view.frontItemView.setImage(with: imageUrl)
        view.frontItemView.tag = tag
        view.frontItemView.delegate = delegate
        view.frontItemView.isSelected = isSelected
        view.backItemView.descriptionText = description
    }
}
