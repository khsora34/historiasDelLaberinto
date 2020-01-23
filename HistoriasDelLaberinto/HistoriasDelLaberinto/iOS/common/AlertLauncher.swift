import UIKit

protocol AlertLauncher: UIViewController {
    func showAlert(title: String?, message: String, actions: [(title: String, style: UIAlertAction.Style, completion: (() -> Void)?)])
}

extension AlertLauncher {
    func showAlert(title: String? = nil, message: String, actions: [(title: String, style: UIAlertAction.Style, completion: (() -> Void)?)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            var newCompletion: ((UIAlertAction) -> Void)?
            if let completion = action.completion {
                newCompletion = { _ in
                    completion()
                }
            }
            let newAction = UIAlertAction(title: action.title, style: action.style, handler: newCompletion)
            alert.addAction(newAction)
        }
        self.present(alert, animated: true)
    }
}
