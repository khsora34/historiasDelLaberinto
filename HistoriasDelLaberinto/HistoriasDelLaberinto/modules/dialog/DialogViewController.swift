import UIKit

class DialogViewController: BaseViewController {
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet var tapWindowGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        dialogView.layer.cornerRadius = 6.0
    }
    
    @IBAction func didTouchView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
