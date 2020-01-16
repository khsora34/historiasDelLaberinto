import UIKit
import Kingfisher

class ItemBackView: UIView {
    var descriptionText: String? {
        get {
            return descriptionLabel.text
        }
        set {
            descriptionLabel.text = newValue
        }
    }
    
    var flipView: (() -> Void)?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "ItemBackView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        setup()
    }
    
    private func setup() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        descriptionLabel.font = UIFont.systemFont(ofSize: 20.0)
        descriptionLabel.textColor = .white
    }
    
    func configure(withModel model: ItemViewModel) {
        self.descriptionText = model.item.description
    }
    
    @IBAction func didTapView(_ sender: Any) {
        flipView?()
    }
}
