import UIKit

extension UIView {
    func shake() {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.repeatCount = 3
        animation.duration = 0.2/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: -10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: 10, y: self.center.y))
        layer.add(animation, forKey: "shake")
    }
}
