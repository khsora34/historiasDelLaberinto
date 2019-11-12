import UIKit
import Kingfisher

class ItemFrontView: UIView {
    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            selectModel?(isSelected)
            if isSelected {
                layer.borderWidth = 5
                layer.borderColor = UIColor.white.cgColor
            } else {
                layer.borderWidth = 0
                layer.borderColor = UIColor.clear.cgColor
            }
            
        }
    }
    
    var itemType: ItemType? {
        didSet {
            itemTypeLabel.text = itemType?.localizedDescription()
        }
    }
    
    var quantity: Int? {
        get {
            return Int(quantityLabel.text ?? "-1")
        }
        set {
            if let value = newValue {
                quantityLabel.text = "\(value)"
            } else {
                quantityLabel.text = nil
            }
        }
    }
    
    weak var delegate: ItemSelectedDelegate?
    var flipView: (() -> Void)?
    var selectModel: ((Bool) -> Void)?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "ItemFrontView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        setup()
    }
    
    func setImage(for source: ImageSource) {
        imageView.setImage(for: source)
    }
    
    @IBAction func infoButton(_ sender: Any) {
        flipView?()
    }
    
    @IBAction func didTapView(_ sender: Any) {
        guard case .consumable? = itemType else { return }
        isSelected = !isSelected
        delegate?.didSelectItem(isSelected: isSelected, tag: self.tag)
    }
    
    private func setup() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        configureFonts()
    }
    
    private func configureFonts() {
        nameLabel.font = UIFont.systemFont(ofSize: 20.0)
        nameLabel.textColor = .white
        itemTypeLabel.font = UIFont.italicSystemFont(ofSize: 18)
        itemTypeLabel.textColor = .yellow
        quantityLabel.font = UIFont.systemFont(ofSize: 20.0)
        quantityLabel.textColor = .white
    }
}
