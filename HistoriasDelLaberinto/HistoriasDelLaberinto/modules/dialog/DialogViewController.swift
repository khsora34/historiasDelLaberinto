import UIKit

class Dialog {
    static func createDialog(imageLiteral: String) -> UIViewController {
        let dialog = DialogViewController()
        dialog.setupAlert(imageLiteral: imageLiteral)
        return dialog
    }
}

class DialogViewController: UIViewController {
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet var tapWindowGesture: UITapGestureRecognizer!
    
    fileprivate init() {
        super.init(nibName: "DialogView", bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAlert(imageLiteral: String) {
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
        characterLabel.text = "Alphonse"
        textView.text =
        """
        Hola, soy Alphonse, principe del reino de Askr.
        ¿Conoces a Gerardo? Es un gran amigo mío.
        """
        let image = UIImage(named: imageLiteral)
        characterImageView.image = image
        characterImageView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogView.layer.cornerRadius = 6.0
    }
    
    @IBAction func didTouchView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
