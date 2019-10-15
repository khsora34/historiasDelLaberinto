import UIKit

class ConfigurableButton: UIButton {
    private var style: ButtonStyle?
    
    func setupStyle(_ style: ButtonStyle) {
        self.style = style
        backgroundColor = style.backgroundColor
        setTitleColor(style.titleColor, for: .normal)
        layer.cornerRadius = style.cornerRadius ?? 0
        titleLabel?.font = style.font
        titleLabel?.textAlignment = .center
        titleLabel?.lineBreakMode = .byWordWrapping
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
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
}
