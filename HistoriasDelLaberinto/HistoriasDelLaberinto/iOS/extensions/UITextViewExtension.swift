import UIKit

extension UITextView {
    func setTypingText(message: String, timeInterval: TimeInterval) -> Timer {
        let characters = message.map { $0 }
        let count = message.count
        var index = 0
        return Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [weak self] timer in
            if index < count {
                if let self = self {
                    let char = characters[index]
                    self.text! += "\(char)"
                    index += 1
                } else {
                    timer.invalidate()
                }
            } else {
                timer.invalidate()
            }
        })
    }
}

