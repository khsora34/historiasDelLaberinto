import UIKit

class ConfigurableButton: UIControl {
    private var style: ButtonStyle?
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabel()
    }
    
    private func configureLabel() {
        addSubview(label)
        self.topAnchor.constraint(greaterThanOrEqualTo: label.topAnchor, constant: -5).isActive = true
        self.bottomAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: 5).isActive = true
        self.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
        self.leftAnchor.constraint(equalTo: label.leftAnchor, constant: -10).isActive = true
        self.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        label.isUserInteractionEnabled = false
    }
    
    func setStyle(_ style: ButtonStyle) {
        self.style = style
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius ?? 0
        label.textColor = style.textColor
        label.font = style.font
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backgroundColor = style?.highlightedBackgroundColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = style?.backgroundColor
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        backgroundColor = style?.backgroundColor
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer.isKind(of: UITapGestureRecognizer.self) else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        return gestureRecognizers?.contains(gestureRecognizer) == true
    }
}
