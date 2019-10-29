import UIKit

extension UIColor {
    static var coolBlue: UIColor {
        return UIColor(hue: 211/360, saturation: 1, brightness: 1, alpha: 1)
    }
    
    static var darkCoolBlue: UIColor {
        return UIColor(hue: 211/360, saturation: 1, brightness: 0.5, alpha: 1)
    }
    
    static var veryDarkGray: UIColor {
        return UIColor(white: 0.2, alpha: 1)
    }
    
    func inverseColor() -> UIColor {
        let ciColor = CIColor(color: self)
        return UIColor(red: 1 - ciColor.red, green: 1 - ciColor.green, blue: 1 - ciColor.blue, alpha: ciColor.alpha)
    }
    
    func darkenColor(scale: CGFloat = 0.5) -> UIColor {
        let ciColor = CIColor(color: self)
        return UIColor(red: ciColor.red * scale, green: ciColor.green * scale, blue: ciColor.blue * scale, alpha: ciColor.alpha)
    }
}
