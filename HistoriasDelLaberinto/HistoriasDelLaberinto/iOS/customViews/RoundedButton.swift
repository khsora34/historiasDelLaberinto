import UIKit

class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setStyle()
    }
    
    private func setStyle() {
        backgroundColor = .coolBlue
        layer.cornerRadius = 4.0
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: "Helvetica Neue", size: 18.0)
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        setBackgroundColor(color: .darkCoolBlue, forState: .highlighted)
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        
        let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(minimumSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: minimumSize))
        }
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.clipsToBounds = true
        self.setBackgroundImage(colorImage, for: forState)
    }
}
