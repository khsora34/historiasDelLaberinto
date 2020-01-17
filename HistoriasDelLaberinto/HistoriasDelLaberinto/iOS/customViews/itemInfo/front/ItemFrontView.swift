import UIKit
import Kingfisher

class ItemFrontView: UIView {
    private var model: ItemViewModel!
    
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
    
    var flipView: (() -> Void)?
    var selectModel: ((Bool) -> Void)?
    weak var delegate: ItemSelectedDelegate?
    
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
    
    func configure(withModel model: ItemViewModel) {
        self.model = model
        self.nameLabel.text = model.item.name
        self.itemTypeLabel.text = Localizer.localizedString(key: model.itemType.categoryKey)
        self.quantityLabel.text = "\(model.quantity)"
        self.setImage(for: model.imageSource)
        self.tag = tag
        self.delegate = model.delegate
        self.isSelected = model.isSelected
        self.selectModel = { [weak self] selected in
            self?.isSelected = selected
        }
    }
    
    func setImage(for source: ImageSource) {
        imageView.setImage(from: source)
    }
    
    @IBAction func infoButton(_ sender: Any) {
        flipView?()
    }
    
    @IBAction func didTapView(_ sender: Any) {
        guard case .consumable = model.itemType else { return }
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
