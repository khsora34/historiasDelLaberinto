import UIKit

struct ButtonStyle {
    let backgroundColor: UIColor
    let highlightedBackgroundColor: UIColor?
    let font: UIFont
    let titleColor: UIColor
    let cornerRadius: CGFloat?
    
    init(backgroundColor: UIColor, highlightedBackgroundColor: UIColor? = nil, font: UIFont, titleColor: UIColor, cornerRadius: CGFloat? = nil) {
        self.backgroundColor = backgroundColor
        self.highlightedBackgroundColor = highlightedBackgroundColor ?? backgroundColor.inverseColor()
        self.font = font
        self.titleColor = titleColor
        self.cornerRadius = cornerRadius
    }
    
    static var defaultButtonStyle: ButtonStyle {
        return ButtonStyle(backgroundColor: .coolBlue, highlightedBackgroundColor: .darkCoolBlue, font: .systemFont(ofSize: 18), titleColor: .white, cornerRadius: 4)
    }
}
