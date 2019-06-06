import UIKit

protocol ShowLoadingCapable: UIViewController {
    func showLoading()
    func dismissLoading()
}

extension ShowLoadingCapable {
    func showLoading() {
        let alert = UIAlertController(title: nil, message: "Cargando, espera un momento...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissLoading() {
        dismiss(animated: false, completion: nil)
    }
}
