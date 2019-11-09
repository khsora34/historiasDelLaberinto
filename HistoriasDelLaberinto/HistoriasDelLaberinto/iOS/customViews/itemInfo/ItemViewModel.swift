class ItemViewModel {
    let id: String
    let name: String
    let description: String
    let itemType: ItemType?
    var quantity: Int
    let imageSource: ImageSource
    let tag: Int
    var isSelected = false
    let delegate: ItemSelectedDelegate?
    
    init(id: String, name: String, description: String, itemType: ItemType?, quantity: Int, imageSource: ImageSource, tag: Int, delegate: ItemSelectedDelegate?) {
        self.id = id
        self.name = name
        self.description = description
        self.itemType = itemType
        self.quantity = quantity
        self.imageSource = imageSource
        self.tag = tag
        self.delegate = delegate
    }
    
    func configure(view: ItemView) {
        view.frontItemView.name = name
        view.frontItemView.itemType = itemType
        view.frontItemView.quantity = quantity
        view.frontItemView.setImage(for: imageSource)
        view.frontItemView.tag = tag
        view.frontItemView.delegate = delegate
        view.frontItemView.isSelected = isSelected
        view.frontItemView.selectModel = { [weak self] selected in
            self?.isSelected = selected
        }
        view.backItemView.descriptionText = description
    }
}
