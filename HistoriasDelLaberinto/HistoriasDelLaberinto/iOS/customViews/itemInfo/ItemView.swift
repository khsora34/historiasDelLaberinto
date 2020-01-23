import UIKit

class ItemView: UIView {
    private var showingBack = false
    
    var frontItemView: ItemFrontView!
    var backItemView: ItemBackView!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var containerView: UIView!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 70)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        frontItemView = ItemFrontView(frame: frame)
        backItemView = ItemBackView(frame: frame)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        frontItemView = ItemFrontView(frame: frame)
        backItemView = ItemBackView(frame: frame)
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
        frontItemView.flipView = flip
        backItemView.flipView = flip
    }
    
    func configure(withModel model: ItemViewModel) {
        frontItemView.configure(withModel: model)
        backItemView.configure(withModel: model)
        tag = model.tag
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
        guard let superview = superview else { return }
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1.0).isActive = true
        self.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 1.0).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
