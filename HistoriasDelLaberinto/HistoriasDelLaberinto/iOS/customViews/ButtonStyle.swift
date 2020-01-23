import UIKit

struct ButtonStyle {
    let backgroundColor: UIColor
    let highlightedBackgroundColor: UIColor?
    let font: UIFont
    let textColor: UIColor
    let cornerRadius: CGFloat?
    
    init(backgroundColor: UIColor, highlightedBackgroundColor: UIColor? = nil, font: UIFont, textColor: UIColor, cornerRadius: CGFloat? = nil) {
        self.backgroundColor = backgroundColor
        self.highlightedBackgroundColor = highlightedBackgroundColor ?? backgroundColor.inverseColor()
        self.font = font
        self.textColor = textColor
        self.cornerRadius = cornerRadius
    }
    
    static var defaultButtonStyle: ButtonStyle {
        return defaultButtonStyle(withFontSize: 18)
    }
    
    static func defaultButtonStyle(withFontSize size: CGFloat) -> ButtonStyle {
        return ButtonStyle(backgroundColor: .coolBlue, highlightedBackgroundColor: .darkCoolBlue, font: .systemFont(ofSize: size), textColor: .white, cornerRadius: 4)
    }
}
