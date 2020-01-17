class ItemViewModel {
    let id: String
    let item: Item
    let itemType: ItemType
    var quantity: Int
    let imageSource: ImageSource
    let tag: Int
    var isSelected = false
    let delegate: ItemSelectedDelegate?
    
    init(id: String, item: Item, itemType: ItemType, quantity: Int, imageSource: ImageSource, tag: Int, delegate: ItemSelectedDelegate?) {
        self.id = id
        self.item = item
        self.itemType = itemType
        self.quantity = quantity
        self.imageSource = imageSource
        self.tag = tag
        self.delegate = delegate
    }
}
