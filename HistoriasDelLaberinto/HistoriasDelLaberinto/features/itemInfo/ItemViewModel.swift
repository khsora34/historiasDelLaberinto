class ItemViewModel {
    let id: String
    let name: String
    let description: String
    let itemType: String
    var quantity: Int
    let imageUrl: String?
    let tag: Int
    var isSelected = false
    let delegate: ItemSelectedDelegate?
    
    init(id: String, name: String, description: String, itemType: String, quantity: Int, imageUrl: String?, tag: Int, delegate: ItemSelectedDelegate?) {
        self.id = id
        self.name = name
        self.description = description
        self.itemType = itemType
        self.quantity = quantity
        self.imageUrl = imageUrl
        self.tag = tag
        self.delegate = delegate
    }
    
    func configure(view: ItemView) {
        view.frontItemView.name = name
        view.frontItemView.itemType = itemType
        view.frontItemView.quantity = quantity
        view.frontItemView.setImage(with: imageUrl)
        view.frontItemView.tag = tag
        view.frontItemView.delegate = delegate
        view.frontItemView.isSelected = isSelected
        view.frontItemView.selectModel = { [weak self] selected in
            self?.isSelected = selected
        }
        view.backItemView.descriptionText = description
    }
}
