import UIKit

class ItemView: UIView {
    private let defaultItemModel = ItemViewModel(id: "-1", name: "Objeto raro", description: "¿Esto es un objeto? ¿Quién sabe?", itemType: nil, quantity: -1, imageUrl: nil, tag: -1, delegate: nil)
    private var showingBack = false
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var containerView: UIView!
    
    var frontItemView: ItemFrontView!
    var backItemView: ItemBackView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        frontItemView = ItemFrontView(frame: frame)
        backItemView = ItemBackView(frame: frame)
        defaultItemModel.configure(view: self)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        frontItemView = ItemFrontView(frame: frame)
        backItemView = ItemBackView(frame: frame)
        defaultItemModel.configure(view: self)
        initSubviews()
    }
    
    init(model: ItemViewModel, frame: CGRect) {
        super.init(frame: frame)
        frontItemView = ItemFrontView(frame: frame)
        backItemView = ItemBackView(frame: frame)
        model.configure(view: self)
        tag = model.tag
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "ItemView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        setup()
    }
    
    func setup() {
        containerView.addSubview(frontItemView)
        frontItemView.translatesAutoresizingMaskIntoConstraints = false
        frontItemView.spanSuperview()
        frontItemView.flipView = { [weak self] in
            self?.flip()
        }
        
        backItemView.flipView = { [weak self] in
            self?.flip()
        }
    }
    
    private func flip() {
        guard let toView = showingBack ? frontItemView : backItemView,
            let fromView = showingBack ? backItemView : frontItemView else { return }
        UIView.transition(from: fromView, to: toView, duration: 1, options: .transitionFlipFromRight, completion: nil)
        toView.translatesAutoresizingMaskIntoConstraints = false
        toView.spanSuperview()
        showingBack = !showingBack
    }
    
}

extension UIView {
    func spanSuperview() {
        guard superview != nil else { return }
        self.topAnchor.constraint(equalTo: superview!.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 1.0).isActive = true
        self.heightAnchor.constraint(equalTo: superview!.heightAnchor, multiplier: 1.0).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
