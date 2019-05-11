import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Dialog", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DialogViewController")
        present(viewController, animated: true, completion: nil)
    }
    
}
