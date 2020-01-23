import UIKit

protocol LoadingLauncher: UIViewController {
    func showLoading(title: String?, message: String?)
    func dismissLoading(completion: (() -> Void)?)
}

extension LoadingLauncher {
    func showLoading(title: String? = nil, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissLoading(completion: (() -> Void)? = nil) {
        dismiss(animated: false, completion: completion)
    }
}
