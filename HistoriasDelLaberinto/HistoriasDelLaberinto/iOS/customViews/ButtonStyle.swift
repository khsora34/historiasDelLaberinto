import UIKit

struct ButtonStyle {
    let backgroundColor: UIColor
    let highlightedBackgroundColor: UIColor?
    let font: UIFont
    let titleColor: UIColor
    let cornerRadius: CGFloat?
    let insets: UIEdgeInsets
    
    init(backgroundColor: UIColor, highlightedBackgroundColor: UIColor? = nil, font: UIFont, titleColor: UIColor, cornerRadius: CGFloat? = nil, insets: UIEdgeInsets = UIEdgeInsets()) {
        self.backgroundColor = backgroundColor
        self.highlightedBackgroundColor = highlightedBackgroundColor ?? backgroundColor.inverseColor()
        self.font = font
        self.titleColor = titleColor
        self.cornerRadius = cornerRadius
        self.insets = insets
    }
    
    static var defaultButtonStyle: ButtonStyle {
        return ButtonStyle(backgroundColor: .coolBlue, highlightedBackgroundColor: .darkCoolBlue, font: .systemFont(ofSize: 18), titleColor: .white, cornerRadius: 4, insets: UIEdgeInsets(top: 8.0, left: 5.0, bottom: 8.0, right: 5.0))
    }
}
