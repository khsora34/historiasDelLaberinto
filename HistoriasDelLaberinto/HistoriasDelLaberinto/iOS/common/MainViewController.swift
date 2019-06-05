import UIKit

class MainViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hideKeyboardTapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        return tapGesture
    }()
    
    private(set) var currentRootViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainView)
        setupAnchors(from: mainView, to: view)
        
        view.addGestureRecognizer(hideKeyboardTapGesture)
    }
    
    func setRoot(viewController: UIViewController?) {
        if let currentViewController = currentRootViewController {
            remove(currentViewController)
        }
        guard let nextViewController = viewController else {
            return
        }
        setViewController(nextViewController)
    }
    
    private func setupAnchors(from childView: UIView, to superView: UIView) {
        childView.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        childView.leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        childView.rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
    
    private func setViewController(_ viewController: UIViewController) {
        guard let newView = viewController.view else {
            return
        }
        newView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(viewController)
        mainView.addSubview(newView)
        newView.frame = mainView.frame
        setupAnchors(from: newView, to: mainView)
        viewController.didMove(toParent: self)
        currentRootViewController = viewController
    }
    
    func remove(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(false)
    }
}
