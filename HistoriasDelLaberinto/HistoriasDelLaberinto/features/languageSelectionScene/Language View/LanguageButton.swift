import UIKit

class LanguageButton: UIButton {
    var info: LanguageButtonInfo? {
        didSet {
            info?.highlightAction = { [weak self] isHighlighted in
                self?.isHighlighted = isHighlighted
                self?.backgroundColor = isHighlighted ? UIColor.systemTeal : UIColor.systemGray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initStyle()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initStyle()
    }
    
    private func initStyle() {
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = UIColor.systemGray
        layer.cornerRadius = 4.0
    }
}

class LanguageButtonInfo {
    let text: String?
    let identifier: String
    var isHighlighted: Bool
    var didTapAction: (() -> Void)?
    var highlightAction: ((Bool) -> Void)?
    
    init(text: String?, identifier: String, isHighlighted: Bool = false) {
        self.text = text
        self.identifier = identifier
        self.isHighlighted = isHighlighted
    }
}
